# Chat History — FabricIQ mini Hands-on

A running log so work can resume across sessions/devices. Newest entries at the top.

---

## Session log

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

**Next steps:**
- Optionally add screenshots to the session docs.
