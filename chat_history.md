# Chat History — FabricIQ mini Hands-on

A running log so work can resume across sessions/devices. Newest entries at the top.

---

## Current state (resume anchor) — 2026-09-22

**Repo:** `https://github.com/ChettapongP-MFST/FabricIQ-mini-Hands-on` (private) · branches `main` + `master` kept identical · latest commit `8984455`.

**Deliverable = 3-session lab** for up to 25 participants sharing one workspace; each builds their own ontology + data agent. Files:
```
README.md                                 # Overview + naming convention + data model + attribution
chat_history.md                           # This log
sessions/
  session-1-lab-preparation.md            # Instructor: shared LH + EH + 25-user roster + naming
  session-2-create-ontology.md            # Participant: build ontology (incl. §2.6 semantic enrichment)
  session-3-create-data-agent.md          # Participant: build data agent
  images/                                 # real (s1-*, s2-*, s3-*) + reference (23-*, 28-*) screenshots
setup/
  setup-shared-lakehouse.ipynb            # Interactive Session 1 notebook (creates LH + EH). NOTE: %pip magic
                                          # means it can't run as a headless API job — use plain-Spark for API.
```

**Naming convention:** ontology `LamnaHealthcareOntology_UserNN`, agent `LamnaHealthcareAgent_UserNN`; shared read-only `LamnaHealthcareLH` + `LamnaHealthcareEH`; participants `user01`–`user25`. Worked example in Sessions 2/3 = `User99`.

**Test environment (live, DO NOT DELETE — user instruction):**
- Workspace `FabricIQ-Handson-Shared`, group `f921a535-cef1-40a3-abb1-bef1db0e78c0`
- Tenant `7908fa56-15cc-44d4-9e7e-15316b8f01e4` (MngEnvMCAP545530), account `chettapongp@MngEnvMCAP545530.onmicrosoft.com`
- Capacity: **paid F8** `fcapacity02`, West US 3 (not Trial — data agent supported)
- Provisioned items (via Fabric REST API):
  - Lakehouse `LamnaHealthcareLH` `7c26ded4-c984-4753-b957-020458bfec28` (+ SQL endpoint) — 5 tables: Hospitals, Departments, Rooms, Patients, VitalSignEquipment
  - Eventhouse `LamnaHealthcareEH` `26dbb6e9-e59a-4463-8fd7-08547def7d06` (KQLDatabase `414b2266-bef6-4be8-b41a-f95215ead207`) — table `VitalSignsReadings` (15 rows)
  - Ontology `LamnaHealthcareOntology_User99` `89f1ccb1-0da7-43b2-9c79-e64fe58254ca` (+ auto Graph model + lakehouse)
  - Data agent `LamnaHealthcareAgent_User99` `a63e0983-3fd9-41c6-ae2f-61d21f871618` (created but NOT configured — no data source/instructions/publish)
  - Notebook `provision-shared-data-api` `6d3a2ec3-ec11-49fa-aa12-f1c2f6032207`

**How provisioning was done:** temp Python scripts in `%TEMP%` (not in repo) using `az account get-access-token --resource https://api.fabric.microsoft.com` (token kept inside the script, never printed). Notebook created + run via RunNotebook job API; ontology via `POST /items` (type Ontology) with proven definition; data agent via `POST /items` (type DataAgent).

**Screenshots in docs:** real live captures — `s1-workspace-items`, `s1-lakehouse-tables`, `s2-ontology-canvas`, `s3-data-agent`; official-lab reference images — `23-*` (entity types, add-relationship, structure, time-series binding, entity overview) + `28-GQL-generated`.

**Known limits:** Fabric editors run in sandboxed cross-origin iframes (`pbides.powerbi.com`) — screenshot-able but not clickable by automation. So the ontology **entity-type overview** and data-agent **GQL test chat** stay as reference images; the automated ontology build shows **plural** entity names vs. the manual singular names (noted in Session 2).

**Open follow-ups:** (1) finish the data agent in the UI (add ontology source + instructions + test) to capture a real GQL screenshot; (2) artifacts kept per user's "don't delete" instruction.

---

## Session log

### 2026-09-22 — Create User99 ontology + data agent via API; live captures

- Created **`LamnaHealthcareOntology_User99`** via the Fabric REST API (proven ontology definition: 5 entity types + bindings + relationships, bound to the shared lakehouse/eventhouse). Fabric auto-created its Graph model + lakehouse. Processing succeeded.
- Created **`LamnaHealthcareAgent_User99`** (type `DataAgent`) via the API (201). Item exists; data-source/instructions/test-chat config must be done in the UI (not API-drivable).
- Captured **live screenshots** and wired them in:
  - Session 2: the real ontology open in the editor with its five entity types (with a note that the automated build shows plural names vs. the manual singular names).
  - Session 3: the real data agent configuration view (toolbar: Add data, Agent instructions, Test data agent, Publish).
- Limits confirmed: in-editor dialogs (Welcome tour) and controls live in sandboxed iframes — screenshot-able but not clickable, so the ontology entity-overview and the data-agent GQL test can't be automated (those remain reference images).

### 2026-09-22 — Provision Session 1 via Fabric API + real screenshots

- Renamed the worked example to `User99` in Sessions 2 & 3.
- **Provisioned Session 1 via the Fabric REST API** (az token kept inside a script, never printed): created a job-friendly notebook (no `%pip`/`sempy`) and ran it via the RunNotebook job API. It created `LamnaHealthcareLH` (5 tables) + `LamnaHealthcareEH` (`VitalSignsReadings`, 15 rows). Verified via API.
  - Note: the original `setup-shared-lakehouse.ipynb` failed as a headless job (`%pip install semantic-link` magic isn't supported in job runs). The repo notebook is still fine for interactive use; the API path uses a plain-Spark variant.
- Captured **real screenshots** from the live workspace and wired them in:
  - Session 1: workspace items list + lakehouse Tables view.
  - Session 2 §2.0: replaced the reused lakehouse image with the real capture.
- **Automation limit still applies:** Fabric editors are in sandboxed cross-origin iframes — screenshot-able but not clickable by automation. The API provisions artifacts; UI build steps can't be driven programmatically.

### 2026-09-22 — Add key screenshots to Sessions 2 & 3

- Verified the target workspace (`FabricIQ-Handson-Shared`, group `f921a535-...`) is on **paid F8 capacity** (`fcapacity02`, West US 3) — not Trial; data agent supported.
- **Automation limitation found:** Fabric workload editors (notebook, ontology, data agent) render inside sandboxed cross-origin iframes (`pbides.powerbi.com`). Browser automation can pixel-screenshot them but cannot click/type inside them, so the editors can't be fully driven programmatically.
- Per user direction, added **a few key reference screenshots** from the official Microsoft Learn labs (23 and 28) into `sessions/images/` and embedded them at the matching steps:
  - Session 2: lakehouse tables, entity types complete, add-relationship dialog, ontology structure, time-series binding, entity type overview.
  - Session 3: generated GQL.
- Added an "About the screenshots" attribution note to both sessions and README.

### 2026-09-22 — Add semantic enrichment step

- Added **Session 2 § 2.6 — Add descriptions and metadata (semantic enrichment)** covering descriptions/synonyms/metadata for entity types, and descriptions/metadata for properties and relationships, with healthcare sample values (steps verified against Microsoft Learn docs).
- Renumbered Preview to § 2.7; bumped Session 2 estimated time to ~50 min.
- Noted honestly that the data agent preview doesn't consume enrichment fields (agent tuning stays in Session 3 instructions).

### 2026-09-22 — Fix shared workspace name

- Set the shared workspace name definitively to **`FabricIQ-Handson-Shared`** across README and Sessions 1–3 (previously shown only as an example).

### 2026-09-22 — Customer-ready sanitization

**Goal:** Make the lab materials customer-ready and remove content customers don't need.

**Changes:**
- Neutralized informal wording ("mock/mockup" → "assigned usernames"/"roster") in Session 1 and the log.
- Softened attribution/derivation wording in the README and setup notebook so materials read as a standalone deliverable.
- Removed internal-only notes and speculative next steps from this log.

### 2026-09-22 — Initial build

**Goal:** Build a hands-on lab combining two Microsoft Learn labs into a Fabric IQ + Data Agents exercise for **25 participants** sharing **one Fabric workspace** and the **same shared** lakehouse `LamnaHealthcareLH` (+ eventhouse `LamnaHealthcareEH`), where each participant creates their **own** ontology and data agent.

Source labs:
- Lab 23 — [Create an ontology with Fabric IQ](https://microsoftlearning.github.io/mslearn-fabric/Instructions/Labs/23-build-ontology-manually.html)
- Lab 28 — [Build a Fabric data agent with an ontology](https://microsoftlearning.github.io/mslearn-fabric/Instructions/Labs/28-build-data-agent-ontology.html)
- Setup notebook reused: `Allfiles/Labs/27-28/setup-ontology.ipynb`

**Done so far:**
1. Created the GitHub repo `ChettapongP-MFST/FabricIQ-mini-Hands-on` (private) and connected local git.
2. Built the lab, then restructured it into **3 sessions**.
3. Added a setup notebook that reuses **Steps 0–2** of the official setup notebook (infra + lakehouse tables + eventhouse readings) and **stops before ontology creation** so each participant builds their own.
4. Naming convention set to `User01` format (per user request).
5. Pushed to both `main` and `master` branches.

**Repo structure:**
```
README.md                                 # Overview + naming convention + data model
chat_history.md                           # This log
sessions/
  session-1-lab-preparation.md            # Instructor: shared LH + EH + 25-user roster + naming
  session-2-create-ontology.md            # Participant: build own ontology
  session-3-create-data-agent.md          # Participant: build own data agent
setup/
  setup-shared-lakehouse.ipynb            # Run once in Session 1 (creates LamnaHealthcareLH + LamnaHealthcareEH)
```

**Naming convention:**
- Ontology: `LamnaHealthcareOntology_UserNN` (e.g. `LamnaHealthcareOntology_User01`)
- Data agent: `LamnaHealthcareAgent_UserNN` (e.g. `LamnaHealthcareAgent_User01`)
- Shared, read-only: `LamnaHealthcareLH` (lakehouse), `LamnaHealthcareEH` (eventhouse)
- Participants: usernames `user01`–`user25`

**Key facts / decisions:**
- Lakehouse tables are **PascalCase**: `Hospitals`, `Departments`, `Rooms`, `Patients`, `VitalSignEquipment` (written by the notebook via `enable_schema=False`). Session 2 binding steps reference these exact names.
- Eventhouse `LamnaHealthcareEH` holds `VitalSignsReadings` (15 rows, time-series) for the VitalSignEquipment time-series binding.
- Relationship names follow Lab 23 manual style: `contains`, `has`, `assignedTo`, `monitors`, `locatedIn`.
- Data agent test questions + agent instructions taken from Lab 28.
- Data agents require **paid Fabric Copilot capacity** (Trial not supported).
- Notebook is idempotent (safe to re-run).

**Git state:**
- Remote: `https://github.com/ChettapongP-MFST/FabricIQ-mini-Hands-on`
- Default branch: `main`. Also pushed identical `master` branch.
- Latest commit: "Add FabricIQ mini hands-on lab in 3 sessions with shared LH+EH setup notebook".

**Next steps (at the time):**
- Add screenshots to the session docs. *(Done in later entries — see the Current state anchor at the top.)*
