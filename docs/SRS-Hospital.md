# Hospital / Clinic Management System — SRS

## Platform

| Component | Technology |
|-----------|------------|
| Domain | hospital.mk9.in (subdomain) |
| Auth | Supabase Auth (role: `hospital_admin`) |
| Frontend | Static HTML/CSS/JS — deployed from `frontend/app/hospital/` |
| Backend | Supabase Edge Functions (`supabase/functions/hospital-*/`) |
| Database | Supabase PostgreSQL (`backend/modules/hospital/schema/`) |
| Storage | Supabase Storage |
| Auth guard | All pages call `requireAuth()`; unauthenticated users are redirected to `/login` |

## Domain & Routing

- **Subdomain:** `hospital.mk9.in` (future — currently accessible via `mk9.in/app/hospital/`)
- All hospital pages are under `/app/hospital/` → `noindex, nofollow`
- Clean URL rewrites (defined in `frontend/_redirects`):

```
/app/hospital                        /app/hospital/dashboard.html               200
/app/hospital/dashboard              /app/hospital/dashboard.html               200
/app/hospital/new-visit              /app/hospital/new-visit.html               200
/app/hospital/patient-list           /app/hospital/patient-list.html            200
/app/hospital/patient-profile        /app/hospital/patient-profile.html         200
/app/hospital/appointments           /app/hospital/appointments.html            200
```

## File Structure

```
frontend/app/hospital/
├── dashboard.html           # Dashboard overview with stats & quick actions
├── new-visit.html           # Multi-step OPD visit form (7 steps)
├── patient-list.html        # Searchable patient list with pagination
├── patient-profile.html     # Full patient profile + visit history
├── appointments.html        # Daily appointment calendar + modal booking
├── css/
│   └── hospital.css         # Hospital-specific styles
└── js/                      # (reserved for future JS modules)

backend/modules/hospital/
├── schema/
│   └── hospital-schema.sql  # OPD transaction tables (patients, visits, vitals, etc.)
├── seed/
│   └── seed-masters.sql     # Departments, doctors, symptoms, billing items
└── policies/
    └── hospital-rls.sql     # Row-level security policies

supabase/functions/
├── hospital-patients/       # Edge function for patient CRUD
├── hospital-masters/        # Edge function for master data lookups
└── hospital-dashboard/      # Edge function for dashboard aggregation

backend/import/
├── README.md                # ETL pipeline docs
├── config.py                # DB creds, file paths, column mappings
├── scripts/
│   ├── filter_cdci.py       # CDCI (medicine) TSV → CSV
│   ├── filter_loinc.py      # LOINC (investigation) CSV → filtered
│   └── import_supabase.py   # SQL DDL + batch insert
├── sql/
│   ├── medicine_master.sql  # 7 CDCI tables + medicine_search MV
│   ├── investigation_master.sql  # LOINC tables (loinc_codes + loinc_parts only; revert-future-tables.sql drops the rest if exported)
│   └── diagnosis_master.sql # ICD-10 (placeholder)
└── cleaned/                 # Filtered CSVs (gitignored)
```

## Database Schema — Detailed Reference

This section explains every table and column in plain language — what it stores, where the data comes from, and how it's used in the application.

---

### 🧾 Master Data Tables (shared across modules, created in `backend/schema/schema.sql`)

---

#### `hospital_departments`
**Purpose:** Lists all clinical departments available for OPD visits and doctor assignment. Acts as the department dropdown throughout the app.

| Column | Type | Example Value | How It's Used |
|--------|------|---------------|---------------|
| `id` | UUID (auto) | `uuid-v4` | Primary key, referenced by `hospital_visits.department_id`, `hospital_doctor_master.department_id`, `hospital_appointments` |
| `name` | VARCHAR | `"Cardiology"` | Displayed in department dropdown, visit cards, appointment forms |
| `code` | VARCHAR | `"CARD"` | Short code for internal reference, used in `symptom_master.department_code` |
| `description` | TEXT | `"Cardiology"` | Human-readable description |

**Source:** Seeded by `seed-masters.sql` — 22 departments.
**Used in:** Steps 2 (doctor), 4 (symptom autocomplete filter), appointments modal, profile page.
**Relationships:** One department → many doctors, many symptoms, many visits.

---

#### `hospital_doctor_master`
**Purpose:** Registry of doctors and hospitals that can be assigned to OPD visits. Includes both individual doctors (linked to a department) and hospital entities (no department link).

| Column | Type | Example Value | How It's Used |
|--------|------|---------------|---------------|
| `id` | UUID (auto) | `uuid-v4` | Primary key, referenced by `hospital_visits.doctor_id`, `hospital_doctor_notes.doctor_id` |
| `name` | VARCHAR | `"Dr. Girkar"` or `"KEM Hospital"` | Displayed in doctor dropdown, visit cards, profile |
| `department_id` | UUID (nullable) | references `hospital_departments.id` | Links individual doctors to their department; `NULL` for hospital entities (they serve all depts) |
| `is_hospital` | BOOLEAN | `false` (individual) / `true` (hospital) | Determines display styling and filtering logic — hospitals shown in all department selections |

**Source:** Seeded by `seed-masters.sql` — 8 doctors (linked to General Medicine) + 6 hospitals (no department).
**Used in:** Step 2 (doctor selection), patient profile, appointment modal.
**Filtering logic:** When a department is selected, only doctors with that `department_id` AND `is_hospital = false` are shown, plus a static "Other" option. Hospitals appear regardless.

---

#### `symptom_master`
**Purpose:** Department-wise catalog of common symptoms/chief complaints. Powers the symptom autocomplete in Step 4.

| Column | Type | Example Value | How It's Used |
|--------|------|---------------|---------------|
| `id` | UUID (auto) | `uuid-v4` | Primary key |
| `department_code` | VARCHAR | `"CARD"` | Matches `hospital_departments.code` — filters symptoms by selected department |
| `symptom_name` | VARCHAR | `"Chest pain"`, `"Fever"` | Displayed as autocomplete suggestions when typing a complaint |

**Source:** Seeded by `seed-masters.sql` — ~90 symptoms across all 22 departments.
**Used in:** Step 4 (Chief Complaints autocomplete `datalist`).

---

#### `hospital_appointments`
**Purpose:** Pre-scheduled patient appointments for future dates. Booked via the appointments modal, viewed in the daily calendar.

| Column | Type | Example Value | How It's Used |
|--------|------|---------------|---------------|
| `id` | UUID (auto) | `uuid-v4` | Primary key |
| `patient_id` | UUID | references `hospital_patients.id` | Links to the patient (created on-the-fly if new) |
| `doctor_id` | UUID (nullable) | references `hospital_doctor_master.id` | Which doctor the appointment is with |
| `appointment_date` | TIMESTAMP | `"2026-07-10 10:30:00"` | The scheduled date and time |
| `duration_minutes` | INT | `15` | Slot duration (default in schema) |
| `status` | VARCHAR | `"scheduled"` / `"confirmed"` / `"completed"` / `"cancelled"` | Determines badge color and available actions |
| `notes` | TEXT | `"Patient needs ECG done"` | Free-text notes for the appointment |
| `created_at` | TIMESTAMP | auto | When the appointment was booked |

**Source:** Created through the appointments modal form (patient name + optional dept/doctor/date/time).
**Used in:** Appointments page (daily view), dashboard (today's count).
**Behavior:** Clicking "completed" or "cancelled" inline updates the status without page reload.

---

### 📦 Import Pipeline Tables (from `backend/import/sql/`)

These tables are populated by the ETL pipeline and serve as read-only reference data for autocomplete and validation.

---

#### `medicine_search` (Materialized View)
**Purpose:** Fast combined search across generic and brand medicine names for the prescription autocomplete. This is the primary lookup table for Step 5.

| Column | Type | Example Value | How It's Used |
|--------|------|---------------|---------------|
| `generic_name` | VARCHAR | `"Paracetamol"` | Medicine name suggestions when doctor types in prescription |
| `brand_name` | VARCHAR | `"Calpol 500"` | Brand name suggestions alongside generic |
| `strength` | VARCHAR | `"500mg"` | Shown as supplementary info (optional) |

**Source:** Materialized view joining `generic_master` and `brand_master` from CDCI.
**Used in:** Step 5 — each prescription row loads an autocomplete `datalist` from this view (limited to 500 results for performance).

---

#### `loinc_codes`
**Purpose:** Standardized laboratory test names and codes from the LOINC database. Powers the investigation test autocomplete in Step 4.

| Column | Type | Example Value | How It's Used |
|--------|------|---------------|---------------|
| `loinc_num` | VARCHAR(10) | `"2345-7"` | LOINC identifier, referenced by `hospital_investigation_results.loinc_code` |
| `long_common_name` | TEXT | `"Hemoglobin [Mass/volume] in Blood"` | Display name in autocomplete |
| `status` | VARCHAR | `"ACTIVE"` | Filter: only ACTIVE and TRIAL records are loaded |
| `units` | VARCHAR | `"g/dL"` | Measurement unit (optional, for future reference range validation) |

**Source:** Imported from LOINC CSV (filtered to ACTIVE/TRIAL only, 7 columns kept).
**Used in:** Step 4 (Suggested Investigations autocomplete).

---

#### `icd10_codes`
**Purpose:** Standardized disease/diagnosis codes from ICD-10. Provides autocomplete suggestions for diagnosis fields.

| Column | Type | Example Value | How It's Used |
|--------|------|---------------|---------------|
| `icd_code` | VARCHAR(20) | `"J45.0"` | ICD-10 code, referenced by `hospital_diagnoses.icd_code` |
| `disease_name` | TEXT | `"Asthma"` | Displayed in diagnosis autocomplete |
| `category` | VARCHAR | `"Respiratory"` | Optional grouping |

**Source:** ICD-10 import (placeholder — currently seeded with basic data or empty).
**Used in:** Step 4 (Provisional/Final Diagnosis datalist from `disease_name`).

---

### 📋 OPD Transaction Tables (created in `backend/modules/hospital/schema/hospital-schema.sql`)

These 17 tables store all clinical and administrative data for each OPD visit. They are populated by the 7-step form (`new-visit.html`).

---

#### `hospital_patients`
**What it stores:** The master registry of every patient who has ever visited. One row per patient, for life.

| Column | Type | Example Value | Data Source | How It's Used |
|--------|------|---------------|-------------|---------------|
| `id` | UUID (auto) | `uuid-v4` | Auto-generated | Primary key, linked from all other tables |
| `uhid` | VARCHAR(50) UNIQUE | `"PT-20260705-001"` | **User input** (Step 1) or auto-generated | The unique patient ID displayed everywhere — profile URL parameter (`/patient-profile?id=PT-...`), visit cards, search |
| `full_name` | VARCHAR(255) | `"Ramesh Sharma"` | **User input** (Step 1) | Displayed in all patient-facing UIs |
| `gender` | VARCHAR(10) | `"Male"` | **User input** (Step 1) | Filter in patient list, display in profile |
| `date_of_birth` | DATE | `"1985-03-15"` | **User input** (Step 1) | Used to auto-calculate age |
| `age` | INT (generated) | `41` | **Auto** — computed from DOB | Read-only display in profile and list; always current because it's a generated column |
| `mobile` | VARCHAR(20) | `"9876543210"` | **User input** (Step 1) | Searchable field in patient list, displayed in profile |
| `email` | VARCHAR(255) | `"ramesh@email.com"` | **User input** (Step 1) | Optional contact |
| `address` | TEXT | `"Sector 15, Navi Mumbai"` | **User input** (Step 1) | Displayed in profile |
| `blood_group` | VARCHAR(5) | `"B+"` | **User input** (optional) | Displayed in profile for emergency reference |
| `drug_allergies` | TEXT[] | `{"Penicillin","Sulphur"}` | **User input** (Step 4, combined from history) | Displayed as colored badges in profile header for quick visibility |
| `created_by` | UUID | references `auth.users.id` | **Auto** — current logged-in user | Audit trail |
| `created_at` | TIMESTAMP | auto | Auto | Sort order for patient list (newest first) |
| `updated_at` | TIMESTAMP | auto | Auto | Last modification time |

**Design choices explained:**
- `uhid` is manually entered (clinic can use their own numbering) OR auto-generated as `APPT-{timestamp}` when created from the appointments modal.
- `age` is a GENERATED column — it recalculates every time you query it based on `date_of_birth` and `CURRENT_DATE`. No need to update it manually.
- `drug_allergies` is an array (`TEXT[]`) — multiple allergies stored in a single field for simplicity; displayed as individual badge pills in the profile.

---

#### `hospital_visits`
**What it stores:** One row per OPD visit — the core record that all other clinical data links to. Think of this as the "visit header" or "encounter record."

| Column | Type | Example Value | Data Source | How It's Used |
|--------|------|---------------|-------------|---------------|
| `id` | UUID (auto) | `uuid-v4` | Auto-generated | Primary key, referenced by ALL other clinical tables (vitals, prescriptions, billing, etc.) |
| `patient_id` | UUID | references `hospital_patients.id` | **Auto** — from Step 1 (selected or newly created patient) | Links the visit to a patient record |
| `opd_number` | VARCHAR(50) | `"PT-20260705-001-1720185600000"` | **Auto** — `{uhid}-{timestamp}` | The unique OPD slip number for this visit |
| `token_number` | INT | `12` | **User input** (Step 1) | Daily token number for queue management |
| `visit_date` | TIMESTAMP | `"2026-07-05 10:30:00"` | **Auto** — defaults to NOW() | When the visit started; used for daily visit counting and history sorting |
| `visit_type` | VARCHAR(20) | `"New"` / `"Follow-up"` | **User input** (Step 1) | Determines visit classification; "New" means first-ever visit for this patient |
| `department_id` | UUID | references `hospital_departments.id` | **User input** (Step 2) | Which department the patient consulted |
| `doctor_id` | UUID (nullable) | references `hospital_doctor_master.id` | **User input** (Step 2) | Which doctor attended; NULL if "Other" was selected |
| `referred_by` | TEXT | `"Dr. Mehta from City Hospital"` | **User input** (Step 2) | Free text — who referred this patient |
| `visit_status` | VARCHAR(20) | `"active"` / `"completed"` / `"cancelled"` | **Auto** — set to `"active"` on create, changed to `"completed"` after save | Controls dashboard stats ("Pending" = active), badge color in recent visits |
| `created_by` | UUID | references `auth.users.id` | **Auto** — current user | Audit trail |
| `created_at` | TIMESTAMP | auto | Auto | Sort order for recent visits |
| `updated_at` | TIMESTAMP | auto | Auto | Last modification time |

**Key insight:** This table is the hub of the entire schema. Every clinical detail table has a `visit_id` foreign key pointing here. When viewing a patient profile, you load their visits, then JOIN all the detail tables to show a complete picture.

---

#### `hospital_chief_complaints`
**What it stores:** The patient's reasons for visiting — the symptoms they describe in their own words. Multiple complaints per visit (add/remove dynamically).

| Column | Type | Example Value | Data Source | How It's Used |
|--------|------|---------------|-------------|---------------|
| `id` | UUID (auto) | `uuid-v4` | Auto | Primary key |
| `visit_id` | UUID | references `hospital_visits.id` | **Auto** — from current visit | Links complaints to the visit |
| `symptom` | TEXT | `"Chest pain"` | **User input** (Step 4 — typed or selected from autocomplete) | Displayed in visit details on profile |
| `duration` | TEXT | `"3 days"` | **User input** (Step 4) | How long the symptom has persisted |
| `severity` | VARCHAR(20) | `"moderate"` | Future use | For severity triage |

**How it works in the UI:** Each complaint row has a symptom input with a `datalist` populated from `symptom_master` (filtered by the department selected in Step 2). Duration is free text.

---

#### `hospital_histories`
**What it stores:** Structured medical history sections for each visit. Uses a `history_type` enum to categorize different aspects of the patient's history.

| Column | Type | Example Value | Data Source | How It's Used |
|--------|------|---------------|-------------|---------------|
| `id` | UUID (auto) | `uuid-v4` | Auto | Primary key |
| `visit_id` | UUID | references `hospital_visits.id` | Auto | Links to visit |
| `history_type` | VARCHAR(50) | One of 6 types (see below) | **Auto** — determined by which textarea in Step 4 | Categorizes the historical information |
| `description` | TEXT | `"Patient has been experiencing..."` | **User input** (Step 4) | The actual history text |

**The 6 history types and what they capture:**
| Type | Form Field (Step 4) | What It Stores |
|------|---------------------|----------------|
| `present_illness` | "History of Present Illness" | Timeline of current symptoms, when they started, progression |
| `past_medical` | "Past Medical History" | Chronic conditions, past surgeries, hospitalizations |
| `current_medicines` | "Current Medicines" | Any ongoing medications the patient is taking |
| `drug_allergy` | "Drug Allergies" | Known drug allergies (also stored on `hospital_patients` for profile display) |
| `family` | "Family / Personal History" | Family medical history, lifestyle (smoking, alcohol, etc.) |
| `personal` | (within Family/Personal textarea) | Personal history details |

**Design choice:** Using a type/d-value pattern instead of separate columns per history type keeps the schema flexible — no schema changes needed if we add more history types in the future.

---

#### `hospital_vitals`
**What it stores:** Objective physiological measurements taken during the visit. One row per visit (vitals are captured once per encounter).

| Column | Type | Example Value | Data Source | Notes |
|--------|------|---------------|-------------|-------|
| `id` | UUID (auto) | `uuid-v4` | Auto | Primary key |
| `visit_id` | UUID | references `hospital_visits.id` | Auto | Links to visit |
| `height_cm` | DECIMAL(5,1) | `170.5` | **User input** (Step 3) | Used with weight to compute BMI |
| `weight_kg` | DECIMAL(5,1) | `72.0` | **User input** (Step 3) | Used with height to compute BMI |
| `bmi` | DECIMAL(4,1) (generated) | `24.8` | **Auto** — `weight / (height/100)²` | Read-only display; never manually entered |
| `bp_systolic` | INT | `120` | **User input** (Step 3) | Upper number of blood pressure reading |
| `bp_diastolic` | INT | `80` | **User input** (Step 3) | Lower number of blood pressure reading |
| `pulse_rate` | INT | `72` | **User input** (Step 3) | Heartbeats per minute |
| `respiratory_rate` | INT | `16` | **User input** (Step 3) | Breaths per minute |
| `spo2` | INT | `98` | **User input** (Step 3) | Oxygen saturation percentage (0-100) |
| `temperature` | DECIMAL(4,1) | `98.6` | **User input** (Step 3) | Body temperature in Fahrenheit |
| `blood_sugar` | DECIMAL(6,1) | `110.0` | **User input** (Step 3) | Blood glucose level |
| `blood_sugar_type` | VARCHAR(20) | `"Fasting"` / `"Random"` / `"Post Prandial"` / `"HbA1c"` | **User input** (Step 3) | Context for the blood sugar reading |

**BMI formula:** `ROUND((weight_kg / ((height_cm / 100) ^ 2))::DECIMAL, 1)` — standard medical BMI calculation, stored as a generated column.

---

#### `hospital_examinations`
**What it stores:** Physical examination findings categorized by examination type. Same type/d-value pattern as histories.

| Column | Type | Example Value | Data Source |
|--------|------|---------------|-------------|
| `id` | UUID (auto) | `uuid-v4` | Auto |
| `visit_id` | UUID | references `hospital_visits.id` | Auto |
| `exam_type` | VARCHAR(50) | `"general"` / `"systemic"` / `"clinical_findings"` / `"lab_findings"` | **Auto** — maps to Step 4 textareas |
| `description` | TEXT | `"Patient is alert and oriented"` | **User input** (Step 4) |

**What each exam type covers:**
| Type | Focus Area | Examples |
|------|------------|----------|
| `general` | General appearance, build, nourishment | "Well-built, well-nourished, no pallor" |
| `systemic` | System-specific examination (CVS, RS, CNS, etc.) | "CVS: S1S2 normal, no murmurs" |
| `clinical_findings` | Doctor's clinical observations | "Mild tenderness in right upper quadrant" |
| `lab_findings` | Any lab results available at time of visit | "Hb: 13.2 g/dL, WBC: 7800" |

---

#### `hospital_investigation_results`
**What it stores:** Lab test / investigation orders and results. Multiple investigations per visit (add/remove dynamically).

| Column | Type | Example Value | Data Source | How It's Used |
|--------|------|---------------|-------------|---------------|
| `id` | UUID (auto) | `uuid-v4` | Auto | Primary key |
| `visit_id` | UUID | references `hospital_visits.id` | Auto | Links to visit |
| `loinc_code` | VARCHAR(10) (nullable) | `"2345-7"` | **Auto** — if test matches a LOINC code | Optional formal mapping to standardized lab test |
| `test_name` | TEXT | `"Hemoglobin"` | **User input** (Step 4 — typed or selected from LOINC autocomplete) | The actual test name ordered |
| `category` | VARCHAR(100) | `"Hematology"` | **User input** (optional) | Grouping for reports |
| `result` | TEXT | `"14.2"` | **User input** (Step 4) | The lab result value |
| `normal_range` | TEXT | `"13.0-17.0 g/dL"` | **User input** (Step 4) | Expected normal range for comparison |
| `status` | VARCHAR(20) (generated) | `"pending"` / `"not_applicable"` / `"reviewed"` | **Auto** — based on result and normal_range presence | Visual indicator: pending = no result yet, reviewed = has result |
| `doctor_remark` | TEXT | `"Borderline low — retest in 1 month"` | **User input** (Step 4) | Doctor's interpretation of the result |
| `is_abnormal` | BOOLEAN | `false` | **User input** (manual toggle, future use) | Flag for abnormal results |

**Generated status logic:**
```
IF result IS NULL      → 'pending'
IF normal_range IS NULL → 'not_applicable'
otherwise              → 'reviewed'
```

**How it works in the UI:** The test name input has a `datalist` populated from `loinc_codes` (limited to 200 results for performance). The doctor types part of a test name and selects from suggestions.

---

#### `hospital_diagnoses`
**What it stores:** The medical diagnosis — what the doctor concludes the patient has. Up to 2 per visit (provisional + final).

| Column | Type | Example Value | Data Source |
|--------|------|---------------|-------------|
| `id` | UUID (auto) | `uuid-v4` | Auto |
| `visit_id` | UUID | references `hospital_visits.id` | Auto |
| `diagnosis_type` | VARCHAR(20) | `"provisional"` / `"final"` | **Auto** — determined by which field in Step 4 |
| `icd_code` | VARCHAR(20) (nullable) | `"J45.0"` | **Auto** — if diagnosis text matches ICD-10 entry |
| `diagnosis_text` | TEXT | `"Bronchial Asthma"` | **User input** (Step 4 — typed or selected from ICD-10 autocomplete) |
| `notes` | TEXT | `"Mild persistent, well controlled"` | **User input** (optional) |

**How it's used in UI:** The diagnosis inputs in Step 4 have a `datalist` populated from `icd10_codes.disease_name`. Two separate entries: provisional (working diagnosis) and final (confirmed diagnosis after investigation results).

---

#### `hospital_prescriptions`
**What it stores:** Medicines prescribed during the visit. Multiple prescriptions per visit (add/remove dynamically in Step 5).

| Column | Type | Example Value | Data Source |
|--------|------|---------------|-------------|
| `id` | UUID (auto) | `uuid-v4` | Auto |
| `visit_id` | UUID | references `hospital_visits.id` | Auto |
| `generic_id` | INT (nullable) | references `generic_master.id` | **Auto** — matched if CDCI generic found for entered name |
| `brand_id` | INT (nullable) | references `brand_master.id` | **Auto** — matched if CDCI brand found for entered name |
| `medicine_name` | TEXT | `"Paracetamol"` | **User input** (Step 5 — typed or autocompleted from `medicine_search`) |
| `route` | VARCHAR(50) | `"Tablet"` | **Dropdown** (Step 5) |
| `frequency` | VARCHAR(50) | `"BD"` | **Dropdown** (Step 5) |
| `food_timing` | VARCHAR(50) | `"After Food"` | **Dropdown** (Step 5) |
| `duration` | VARCHAR(100) | `"5 days"` | **User input** (Step 5) |
| `instructions` | TEXT | `"1-0-1 after meals"` | **User input** (Step 5) |
| `is_active` | BOOLEAN | `true` (default) | For future use — to mark discontinued prescriptions |

**Dropdown options explained:**

| Field | Available Values | Medical Meaning |
|-------|-----------------|-----------------|
| `route` | Tablet, Capsule, Syrup, Injection, IV, Ointment, Drops, Other | How the medicine is administered |
| `frequency` | OD (Once Daily), BD (Twice Daily), TDS (Three Times Daily), QID (Four Times Daily), HS (At Bedtime), SOS (As Needed), STAT (Immediately), Weekly, Monthly | How often to take the medicine |
| `food_timing` | Before Food, After Food, With Food, Empty Stomach, At Bedtime, SOS, Not Applicable | When to take relative to meals |

**How autocomplete works:** The medicine input has a `datalist` loaded from `medicine_search` materialized view (CDCI data: 500 results, both generic and brand names). Doctor types "Para..." and sees "Paracetamol", "Paracetamol 500mg", "Paracip", etc.

---

#### `hospital_procedures`
**What it stores:** Procedures or treatments performed during the visit. Multiple can be selected (checkboxes).

| Column | Type | Example Value | Data Source |
|--------|------|---------------|-------------|
| `id` | UUID (auto) | `uuid-v4` | Auto |
| `visit_id` | UUID | references `hospital_visits.id` | Auto |
| `procedure_name` | VARCHAR(100) | `"Injection"` | **Checkbox selection** (Step 4) |
| `notes` | TEXT | `"IM injection in deltoid, 1ml"` | **User input** (Step 4 — shared "Treatment Notes" textarea) |

**Available procedures (checkboxes):** Injection, Dressing, Nebulization, IV Fluids, Minor Procedure, Other Treatment.
**Notes are shared** across all selected procedures (one textarea for all).

---

#### `hospital_advice`
**What it stores:** Lifestyle and wellness advice given to the patient. The Step 4 advice textarea is a single free-text field.

| Column | Type | Example Value | Data Source |
|--------|------|---------------|-------------|
| `id` | UUID (auto) | `uuid-v4` | Auto |
| `visit_id` | UUID | references `hospital_visits.id` | Auto |
| `advice_type` | VARCHAR(50) | `"General Instructions"` (currently — all advice stored under this type) | **Auto** — currently hardcoded as "General Instructions" |
| `description` | TEXT | `"Avoid oily food, walk 30 min daily, take adequate rest"` | **User input** (Step 4) |

**Advice categories (available for future use):** Diet, Lifestyle, Rest, Exercise, General Instructions.
**Current behavior:** The single advice textarea saves everything under "General Instructions" type, regardless of content.

---

#### `hospital_special_instructions`
**What it stores:** Additional special instructions that don't fit in other sections. Separate from general advice for clarity.

| Column | Type | Example Value | Data Source |
|--------|------|---------------|-------------|
| `id` | UUID (auto) | `uuid-v4` | Auto |
| `visit_id` | UUID | references `hospital_visits.id` | Auto |
| `instructions` | TEXT | `"Patient advised to return immediately if chest pain recurs"` | **User input** (future — not yet in the form) |
| `created_at` | TIMESTAMP | auto | Auto |

**Note:** This table exists in the schema but is not yet connected to a form field in the current UI.

---

#### `hospital_followups`
**What it stores:** Follow-up tracking — whether the patient needs to return, and what the outcome of the previous treatment was. One row per visit.

| Column | Type | Example Value | Data Source |
|--------|------|---------------|-------------|
| `id` | UUID (auto) | `uuid-v4` | Auto |
| `visit_id` | UUID | references `hospital_visits.id` | Auto |
| `treatment_response` | VARCHAR(30) | `"Improved"` / `"Recovered"` / `"No Change"` / `"Worsened"` / `"Follow-up Required"` / `"N/A"` | **Dropdown** (Step 4) |
| `followup_date` | DATE | `"2026-07-20"` | **User input** (Step 4) | Date the patient should return |
| `next_visit_advice` | TEXT | `"Bring all previous reports"` | **User input** (Step 4) |

**Business logic:** If treatment_response is "Follow-up Required", the followup_date becomes critical. The dashboard's "Today's Appointments" shows pre-booked appointments, not follow-up dates (currently).

---

#### `hospital_doctor_notes`
**What it stores:** The doctor's final remarks and signature for the visit. One row per visit.

| Column | Type | Example Value | Data Source |
|--------|------|---------------|-------------|
| `id` | UUID (auto) | `uuid-v4` | Auto |
| `visit_id` | UUID | references `hospital_visits.id` | Auto |
| `remarks` | TEXT | `"Patient responded well to treatment. Continue same medications."` | **User input** (Step 4) |
| `signature` | TEXT | `"Dr. Girkar"` | **User input** (Step 4 — doctor name or signature stamp) |
| `doctor_id` | UUID (nullable) | references `hospital_doctor_master.id` | **Auto** — from Step 2 doctor selection |
| `created_at` | TIMESTAMP | auto | Auto |

---

#### `hospital_billing_items`
**What it stores:** Individual line items on the bill. Each item is a service/product with quantity, rate, and auto-calculated amount. Multiple items per visit (add/remove dynamically in Step 6).

| Column | Type | Example Value | Data Source |
|--------|------|---------------|-------------|
| `id` | UUID (auto) | `uuid-v4` | Auto |
| `visit_id` | UUID | references `hospital_visits.id` | Auto |
| `description` | TEXT | `"Consultation Fee"` | **User input** (Step 6 — default pre-filled) |
| `quantity` | INT | `2` | **User input** (Step 6) |
| `rate` | DECIMAL(10,2) | `300.00` | **User input** (Step 6) |
| `amount` | DECIMAL(10,2) (generated) | `600.00` | **Auto** — `quantity × rate` |
| `created_at` | TIMESTAMP | auto | Auto |

**How it works in the UI:**
- Click "Add Item" to create a new billing row
- First item defaults to "Consultation Fee" × 1 × ₹300
- Quantity and rate are editable; amount auto-updates via `calcBillSummary()` JavaScript
- A "Remove" button deletes the row and recalculates totals

---

#### `hospital_billing_summary`
**What it stores:** The final bill summary — one row per visit with totals, discount, and payment status.

| Column | Type | Example Value | Data Source |
|--------|------|---------------|-------------|
| `id` | UUID (auto) | `uuid-v4` | Auto |
| `visit_id` | UUID | references `hospital_visits.id` (UNIQUE) | Auto |
| `total_amount` | DECIMAL(10,2) | `600.00` | **Auto** — computed from billing items |
| `discount` | DECIMAL(10,2) | `50.00` | **User input** (Step 6) |
| `grand_total` | DECIMAL(10,2) (generated) | `550.00` | **Auto** — `total_amount - discount` |
| `payment_status` | VARCHAR(20) | `"pending"` / `"paid"` / `"partially_paid"` / `"cancelled"` | **Auto** — set to `"pending"` on save |
| `payment_method` | VARCHAR(50) | `"Cash"` / `"UPI"` / `"Card"` | Future use |
| `created_at` | TIMESTAMP | auto | Auto |
| `updated_at` | TIMESTAMP | auto | Auto |

**Why separate from billing items?** The `hospital_billing_items` table stores individual line items (many per visit), while `hospital_billing_summary` stores the aggregated total (one per visit). This follows standard POS/invoicing database design — the UNIQUE constraint on `visit_id` ensures exactly one summary per visit.

---

### 🔑 Entity Relationship Summary

```
hospital_patients (1) ────── (many) hospital_visits
                                       │
                    ┌──────────────────┼──────────────────┐
                    │ (1)              │ (1)              │ (1)
         hospital_chief_complaints     │         hospital_billing_items
               hospital_histories      │         hospital_billing_summary
                hospital_vitals        │
            hospital_examinations      │
    hospital_investigation_results     │
              hospital_diagnoses       │
           hospital_prescriptions      │
            hospital_procedures        │
                hospital_advice        │
    hospital_special_instructions      │
              hospital_followups       │
           hospital_doctor_notes       │
                                      (1 per visit each)
```

Every detail table has a `visit_id` foreign key → `hospital_visits.id`. The central query pattern is:
```sql
SELECT * FROM hospital_visits v
JOIN hospital_patients p ON v.patient_id = p.id
LEFT JOIN hospital_vitals vt ON vt.visit_id = v.id
LEFT JOIN hospital_prescriptions rx ON rx.visit_id = v.id
-- ... etc for all detail tables
WHERE v.id = 'some-visit-id';
```

---

### ⚙️ Key Design Decisions

| Decision | Why | Benefit |
|----------|-----|---------|
| `age` as GENERATED column | No manual updates needed; accurate whenever queried | Patient age is always correct, even years later |
| `bmi` as GENERATED column | Prevents calculation errors; consistent formula | No application-level BMI logic needed |
| `amount` as GENERATED column | Line total always matches qty × rate | Prevents billing discrepancies |
| `grand_total` as GENERATED column | Total = amount - discount (always consistent) | Audit-proof billing summary |
| `investigation.status` as GENERATED column | Automatically reflects result entry state | UI can show "pending" vs "reviewed" without extra logic |
| Type/d-value pattern for histories & exams | Flexible — add new history/exam types without schema changes | Easy to extend for new clinical requirements |
| Visit-centric design | All clinical data links to the visit, not the patient | Clean separation: patient profile = many visits, each visit = complete clinical record |
| `opd_number = {UHID}-{timestamp}` | Globally unique, human-readable, sortable | No collisions even across multiple clinics |

## OPD Visit Flow (7-Step Form)

### Step 1 — Patient Information

| Field | Type | Notes |
|-------|------|-------|
| Search Existing Patient | Autocomplete | Searches by name, mobile, or UHID; pre-fills form on selection |
| UHID * | Text | Unique patient identifier (auto-generated or entered) |
| Visit Type | Select | New / Follow-up |
| Token No. | Number | Optional |
| Patient Name * | Text | |
| Mobile | Tel | |
| Gender | Select | Male / Female / Other |
| Date of Birth | Date | Triggers auto age calculation |
| Age (auto) | Text (readonly) | Auto-calculated from DOB |
| Email | Email | |
| Address | Textarea | |

### Step 2 — Doctor & Department

| Field | Type | Notes |
|-------|------|-------|
| Department * | Select (22 depts) | Loaded from `hospital_departments` |
| Doctor * | Select | Filtered by department; includes "Other" option |
| Referred By | Text | Free text |

**Departments:** General Medicine (MED), Cardiology (CARD), Emergency/Casualty (CASUALTY), Pulmonology (CHEST/TB), Dental (DENT), Dermatology (DERM), Endocrinology (ENDO), ENT, Ophthalmology (EYE), Gastroenterology (GASTRO), Nephrology (NEPH), Neurology (NEURO), Neurosurgery (NSURG), Obstetrics & Gynecology (OBG/GYN), Oncology (ONCO), Orthopedics (ORTHO), Pediatrics (PAEDS), Physical Medicine & Rehab (PMR), Psychiatry (PSY), General Surgery (SURG), Urology (URO), Physiotherapy (PHYSIO)

**Doctors:** Dr. Girkar, Dr. Nerekar, Dr. Sathe, Dr. Hajari, Gargi Hospital, Gitai Hospital, Shyamnagar Hospital, INHS Sandhani, Terna Hospital, JJ Hospital, KEM Hospital, Other

### Step 3 — Vitals

| Field | Type | Notes |
|-------|------|-------|
| Height (cm) | Number | Triggers BMI auto-calculation |
| Weight (kg) | Number | Triggers BMI auto-calculation |
| BMI (auto) | Text (readonly) | Auto-calculated |
| BP Systolic | Number | |
| BP Diastolic | Number | |
| Pulse Rate | Number | |
| Respiratory Rate | Number | |
| SpO₂ (%) | Number | 0–100 |
| Temperature (°F) | Number | |
| Blood Sugar | Number | |
| Blood Sugar Type | Select | Fasting / Post Prandial / Random / HbA1c |

### Step 4 — Clinical Details

**Chief Complaints** (dynamic add/remove)
| Field | Type |
|-------|------|
| Symptom | Autocomplete (from `symptom_master`, filtered by department) |
| Duration | Text |

**History**
| Field | Type |
|-------|------|
| History of Present Illness | Textarea |
| Past Medical History | Textarea |
| Current Medicines | Textarea |
| Drug Allergies | Textarea |
| Family / Personal History | Textarea |

**Examination**
| Field | Type |
|-------|------|
| General Examination | Textarea |
| Systemic Examination | Textarea |
| Clinical Findings | Textarea |
| Lab Findings | Textarea |

**Suggested Investigations** (dynamic add/remove)
| Field | Type | Notes |
|-------|------|-------|
| Test Name | Autocomplete | From `loinc_codes` (LOINC master) |
| Result | Text | |
| Normal Range | Text | |
| Doctor Remark | Text | |

**Diagnosis**
| Field | Type | Notes |
|-------|------|-------|
| Provisional Diagnosis | Text + datalist | ICD-10 autocomplete |
| Final Diagnosis | Text + datalist | ICD-10 autocomplete |

**Procedures / Treatment** (multi-select checkboxes)
- Injection, Dressing, Nebulization, IV Fluids, Minor Procedure, Other Treatment
- Treatment Notes (textarea)

**Advice & Follow-up**
| Field | Type | Options |
|-------|------|---------|
| Advice | Textarea | Diet, Lifestyle, Rest, Exercise, General Instructions |
| Treatment Response | Select | N/A / Improved / Recovered / No Change / Worsened / Follow-up Required |
| Follow-up Date | Date | |
| Next Visit Advice | Text | |

**Doctor Remarks**
| Field | Type |
|-------|------|
| Remarks | Textarea |
| Signature | Text |

### Step 5 — Prescription

Each prescription entry (dynamic add/remove):

| Field | Type | Options |
|-------|------|---------|
| Medicine | Autocomplete | From `medicine_search` MV (CDCI — generic + brand names) |
| Route | Select | Tablet / Capsule / Syrup / Injection / IV / Ointment / Drops / Other |
| Frequency | Select | OD / BD / TDS / QID / HS / SOS / STAT / Weekly / Monthly |
| Food Timing | Select | Before Food / After Food / With Food / Empty Stomach / At Bedtime / SOS / Not Applicable |
| Duration | Text | e.g. "7 days", "5 doses" |
| Instructions | Text | e.g. "1-0-1", "after meals" |

### Step 6 — Billing

Each billing item (dynamic add/remove):

| Field | Type | Notes |
|-------|------|-------|
| Description | Text | Default: "Consultation Fee" |
| Quantity | Number | Default: 1 |
| Rate (₹) | Number | Default: 300 |
| Amount | Auto | = Qty × Rate |

Summary:
| Field | Type |
|-------|------|
| Total | Auto |
| Discount (₹) | Number |
| Grand Total | Auto (= Total − Discount) |

### Step 7 — Review & Save

- Displays summary of all sections
- Save button persists everything in a single transaction flow (sequential inserts)
- On success: redirects to dashboard

## Dashboard

### Stats Cards
| Metric | Source |
|--------|--------|
| Total Patients | `hospital_patients` count |
| Today's Visits | `hospital_visits` count for today |
| Pending Visits | `hospital_visits` count WHERE `visit_status = 'active'` |
| Today's Appointments | `hospital_appointments` count for today |

### Quick Actions
- New Visit → `/app/hospital/new-visit`
- Search Patients → `/app/hospital/patient-list`
- Appointments → `/app/hospital/appointments`

### Recent Visits
- Last 10 visits with patient name, OPD number, date, type, status

## Appointments

### Daily View
- Date navigator with prev/next/today buttons
- Lists all appointments for selected date
- Status badges: scheduled (blue), confirmed (green), cancelled (red), completed (purple)
- Inline action buttons to mark scheduled appointments as completed or cancelled

### New Appointment Modal
| Field | Type |
|-------|------|
| Patient Name * | Text |
| Mobile | Tel |
| Department | Select (22 depts) |
| Doctor | Select (filtered by department) |
| Date * | Date |
| Time | Time |
| Notes | Textarea |

## Patient List
- Searchable by name, UHID, or mobile
- Filterable by gender
- Paginated (20 per page)
- Table columns: UHID, Name, Gender, Age, Mobile, Visit Count, Last Visit Date
- Click UHID → patient profile page

## Patient Profile
- Header: Avatar, Name, UHID, Gender, Age, Mobile, Email, Allergies, Address
- "New Visit" action button
- Visit history (expandable cards)
- Each visit card shows: Date, OPD#, Department, Doctor, Type
- Expanded view: Vitals, Complaints, Diagnosis, Prescriptions, Procedures, Follow-up, Billing

## Master Data & Import Pipeline

| Dataset | Source | Format | Usage | Status |
|---------|--------|--------|-------|--------|
| Medicines | CDCI (Common Drug Codes for India) | TSV → CSV → 7 tables + MV | Prescription autocomplete | ✅ Imported |
| Investigations | LOINC (Loinc.csv, Part.csv, etc.) | CSV | Lab test selection & reporting | ✅ Imported |
| Symptoms | Custom JSON (dept.json) | JSON | OPD symptom autocomplete | ✅ Seeded |
| Diagnosis | ICD-10 | CSV | Disease coding | 🔜 Future |
| Procedures | SNOMED CT | — | Procedure coding | 🔜 Future |

### ETL Pipeline (`backend/import/`)

```
raw/ (CDCI TSVs, LOINC CSVs)
  → scripts/filter_cdci.py (TSV → all-columns CSV)
  → scripts/filter_loinc.py (ACTIVE/TRIAL only, 7 columns)
  → cleaned/ CSVs
  → scripts/import_supabase.py (DDL SQL + batch INSERT, 1k/batch)
  → scripts/verify_data.py (row count verification)
```

**CDCI Tables:** `drug_master`, `generic_master`, `brand_master`, `dosage_form_master`, `route_master`, `strength_master`, `manufacturer_master`, `medicine_search` (materialized view)

**LOINC Tables:** `loinc_codes`, `loinc_parts` only. Future tables (`loinc_answer_list`, `loinc_answer_list_links`, `loinc_part_links`) DDL removed — recreate from `sql/diagnosis_master.sql` or revert recipe when needed.

### Custom Masters (Seeded)

| Master | Data |
|--------|------|
| Department Master | 22 departments with codes |
| Doctor Master | 11 local doctors/hospitals |
| Symptom Master | ~90 symptoms across departments |
| Investigation Categories | (per-visit, dynamic) |
| Medicine Frequency | OD, BD, TDS, QID, HS, SOS, STAT, Weekly, Monthly |
| Medicine Route | Tablet, Capsule, Syrup, Injection, IV, Ointment, Drops, Other |
| Food Timing | Before/After/With Food, Empty Stomach, At Bedtime, SOS, N/A |
| Follow-up Status | N/A, Improved, Recovered, No Change, Worsened, Follow-up Required |
| Billing Items | Consultation Fee, Online Consultation, Follow-up Visit, etc. |

## Edge Functions

| Function | Purpose |
|----------|---------|
| `hospital-patients` | Patient CRUD operations |
| `hospital-masters` | Master data lookups (departments, doctors, symptoms) |
| `hospital-dashboard` | Aggregated dashboard stats |

## RLS Policies (`hospital-rls.sql`)

- Users can read/write patients, visits, and clinical data
- `hospital_admin` role has full access
- Policies enforce row-level security per `auth.uid()`

## Architecture Diagram

```
                         ┌──────────────────────────────┐
                         │     mk9.in (Cloudflare)       │
                         │  Publish root: frontend/       │
                         └──────────┬───────────────────┘
                                    │
                    ┌───────────────┴────────────────┐
                    │         /app/hospital/          │
                    │      (noindex, nofollow)        │
                    ├─────────────────────────────────┤
                    │ dashboard.html                  │
                    │ new-visit.html (7-step OPD)    │
                    │ patient-list.html              │
                    │ patient-profile.html           │
                    │ appointments.html              │
                    └───────────────┬────────────────┘
                                    │
          ┌─────────────────────────┼─────────────────────────┐
          │                         │                         │
          ▼                         ▼                         ▼
  ┌───────────────┐     ┌───────────────────┐     ┌──────────────────┐
  │  Supabase     │     │  Supabase Edge    │     │  Import Pipeline │
  │  PostgreSQL   │◄────┤  Functions        │     │  (backend/import/)│
  │               │     │  hospital-*       │     │                  │
  │  hospital_*   │     └───────────────────┘     │  CDCI → LOINC    │
  │  tables       │                                │  → ICD-10        │
  │  + RLS        │                                └──────────────────┘
  └───────────────┘
```

## Constraints & Conventions

- All hospital pages under `/app/hospital/` → `noindex, nofollow` (set in `_headers`)
- Auth guard via `requireAuth()` on every page
- Admin role: `hospital_admin` (assigned by `developer` role)
- All master data files stay in `Hospital data raw/` (gitignored)
- Follow the `structure.md` project conventions — minimal folder structure, reuse existing patterns
- New modules: create `frontend/app/<name>/` pages + `backend/modules/<name>/` schema + `supabase/functions/<name>-*` edge functions
