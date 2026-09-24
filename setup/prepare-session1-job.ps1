param(
    [Parameter(Mandatory)][guid]$WorkspaceId,
    [Parameter(Mandatory)][guid]$LakehouseId,
    [Parameter(Mandatory)][uri]$QueryUri,
    [Parameter(Mandatory)][string]$OutputPath
)

$ErrorActionPreference = 'Stop'
if ($QueryUri.Scheme -ne 'https') { throw 'The KQL endpoint must use HTTPS.' }
$source = Get-Content (Join-Path $PSScriptRoot 'setup-shared-lakehouse.ipynb') -Raw | ConvertFrom-Json
$tableCells = @($source.cells | Where-Object { $_.cell_type -eq 'code' -and ($_.source -join "`n").Contains('hospitals_data =') })
$readingCells = @($source.cells | Where-Object { $_.cell_type -eq 'code' -and ($_.source -join "`n").Contains('def kql_mgmt(') })
if ($tableCells.Count -ne 1 -or $readingCells.Count -ne 1) { throw 'Expected exactly one lakehouse data cell and one eventhouse data cell.' }

$endpointLiteral = $QueryUri.AbsoluteUri.TrimEnd('/') | ConvertTo-Json -Compress
$initialization = @"
import json
import requests
from datetime import datetime, timedelta
from notebookutils import mssparkutils
from pyspark.sql import SparkSession
from pyspark.sql.types import StructType, StructField, IntegerType, StringType
from pyspark.sql.functions import to_timestamp

workspace_id = "$WorkspaceId"
lakehouse_id = "$LakehouseId"
query_uri = $endpointLiteral
lakehouse_tables_path = f"abfss://{workspace_id}@onelake.dfs.fabric.microsoft.com/{lakehouse_id}/Tables"
spark = SparkSession.builder.getOrCreate()
"@
$verification = @'
expected_counts = {"Hospitals": 1, "Departments": 3, "Rooms": 10, "Patients": 5, "VitalSignEquipment": 5}
actual_counts = {}
for table_name, expected_count in expected_counts.items():
    actual_count = spark.read.format("delta").load(f"{lakehouse_tables_path}/{table_name}").count()
    if actual_count != expected_count:
        raise RuntimeError(f"{table_name}: expected {expected_count}, got {actual_count}")
    actual_counts[table_name] = actual_count
reading_count = kql_query("VitalSignsReadings | count")[0][0]
if reading_count != 15:
    raise RuntimeError(f"VitalSignsReadings: expected 15, got {reading_count}")
actual_counts["VitalSignsReadings"] = reading_count
report = {"workspaceId": workspace_id, "lakehouseId": lakehouse_id, "validatedAtUtc": datetime.utcnow().isoformat() + "Z", "counts": actual_counts}
report_path = f"abfss://{workspace_id}@onelake.dfs.fabric.microsoft.com/{lakehouse_id}/Files/session1-validation.json"
mssparkutils.fs.put(report_path, json.dumps(report, indent=2), True)
print(json.dumps(report, indent=2))
print("SESSION1_DATA_VALIDATED")
'@
$cells = @()
$cellNumber = 0
$tableCode = ($tableCells[0].source | ForEach-Object { $_.TrimEnd("`r", "`n") }) -join "`n"
$readingCode = ($readingCells[0].source | ForEach-Object { $_.TrimEnd("`r", "`n") }) -join "`n"
foreach ($code in @($initialization, $tableCode, $readingCode, $verification)) {
    $cellNumber++
    $cells += @{
        cell_type = 'code'
        id = "session1-$cellNumber"
        metadata = @{ language = 'python' }
        execution_count = $null
        outputs = @()
        source = @($code -split '\r?\n' | ForEach-Object { "$_`n" })
    }
}
$notebook = @{
    nbformat = 4
    nbformat_minor = 5
    metadata = @{
        kernelspec = @{ name = 'synapse_pyspark'; display_name = 'Synapse PySpark'; language = 'python' }
        language_info = @{ name = 'python' }
        dependencies = @{ lakehouse = @{
            default_lakehouse = "$LakehouseId"
            default_lakehouse_name = 'LamnaHealthcareLH'
            default_lakehouse_workspace_id = "$WorkspaceId"
        } }
    }
    cells = $cells
}
$notebookJson = $notebook | ConvertTo-Json -Depth 30
$payload = @{
    displayName = 'provision-shared-data-api'
    type = 'Notebook'
    description = 'Session 1 shared sample data setup and row-count verification; no ontology or data agent creation.'
    definition = @{
        format = 'ipynb'
        parts = @(@{
            path = 'notebook-content.ipynb'
            payloadType = 'InlineBase64'
            payload = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($notebookJson))
        })
    }
}
$payload | ConvertTo-Json -Depth 35 | Set-Content -LiteralPath $OutputPath -Encoding utf8
Write-Output "Prepared notebook request: $OutputPath"