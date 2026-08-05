# Archive

Code removed from the live website, kept for reference. Not deployed.

## Contents

- **app/** — Login-required modules (auth, admin, dashboard, profile, seniority, hospital). Depends on Supabase + auth which no longer exist; archived pages will not run.
- **backend/** — Supabase/PostgreSQL schema, seed, medical master-data ETL pipeline, hospital module schema.
- **config/** — Supabase client configuration (`supabase.js`).
- **services/** — `blogService.js` (Supabase-backed blog CRUD, replaced by the static JSON-driven blog).
- **shared/** — `auth.js` + `auth.css` (auth system support files).
- **docs/** — `SRS-Hospital.md` (hospital module spec).
- **Hospital data raw/** — Raw CDCI / LOINC medical master data files.
- **structure.md** — Original full-project blueprint (pre-restructure).
