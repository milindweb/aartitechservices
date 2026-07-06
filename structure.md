# MK9 PROJECT STRUCTURE

## Architecture

Frontend : Cloudflare Pages (aartitechservices.pages.dev / mk9.in)
Backend  : Supabase Edge Functions (JavaScript/TypeScript)
Database : Supabase PostgreSQL (via `backend/schema/`)
Storage  : Supabase Storage (via client SDK)
Auth     : Supabase Auth (Login / Registration / Forgot Password / Reset Password) ✅

## Repository
GitHub: https://github.com/milindweb/aartitechservices.git

## Future Subdomains

mk9.in                → Main Portal (deployed from `frontend/`)
app.mk9.in            → App Area (deployed from `frontend/app/`) — alternative to /app/* paths
blog.mk9.in           → Blog Module
society.mk9.in        → Society Management
seniority.mk9.in      → Seniority Management
hospital.mk9.in       → Hospital Management
admin.mk9.in          → Admin Panel

## Repository Structure

mk9/
│
├── README.md
├── CHANGELOG.md
├── structure.md
├── .gitignore
├── .env.example
├── .env.original                  ↤ Backup of original env vars
├── complaint.json
│
├── supabase/
│   │
│   ├── .gitignore
│   ├── config.toml
│   ├── .temp/                     (various temp files: project-ref, versions, etc.)
│   │
│   └── functions/
│       │
│       ├── blog-posts/
│       │   └── index.ts
│       │
│       ├── hospital-patients/
│       │   └── index.ts
│       │
│       ├── hospital-masters/
│       │   └── index.ts
│       │
│       └── hospital-dashboard/
│           └── index.ts
│
├── docs/
│   │
│   ├── DEPLOYMENT.md
│   ├── ROADMAP.md
│   └── SRS-Hospital.md              ↤ Hospital Management System SRS
│
├── Future/
│   ├── CRM/
│   ├── ERP/
│   ├── HRMS/
│   ├── Inventory/
│   └── School/
│
├── VScode/                        (empty — reserved)
│
├── frontend/
│   │
│   ├── .htaccess                    ↤ Apache security & caching
│   ├── _headers                     ↤ Cloudflare headers & caching / SEO
│   ├── _redirects                   ↤ Cloudflare URL rewrites
│   ├── 404.html                     ↤ Custom 404 page
│   ├── robots.txt                   ↤ Crawler rules
│   ├── sitemap.xml                  ↤ XML sitemap (manual updates required)
│   ├── index.html                   ⭐ SEO — fully indexed
│   │
│   ├── config/
│   │   │
│   │   └── supabase.js              ↤ Supabase client init (URL + anon key)
│   │
│   ├── data/
│   │   │
│   │   └── posts.json               ⭐ Blog posts data (JSON-driven)
│   │
│   ├── blog/
│   │   │
│   │   └── posts/                   ⭐ Individual blog post HTML files (29 posts)
│   │       ├── _template.html
│   │       ├── arduino-esp32-workshop.html
│   │       ├── automotive-diagnostics-guide.html
│   │       ├── brand-identity-design.html
│   │       ├── build-professional-network-freelancer.html
│   │       ├── build-rest-api-nodejs-postgresql.html
│   │       ├── camera-buying-guide-2026.html
│   │       ├── chatgpt-business-ai.html
│   │       ├── digital-tools-small-business-2026.html
│   │       ├── digitizing-society-management.html
│   │       ├── drone-photography-real-estate.html
│   │       ├── drone-regulations-india-dgca.html
│   │       ├── drone-types-cost-india.html
│   │       ├── engineering-project-ideas-final-year.html
│   │       ├── full-stack-beginners-guide.html
│   │       ├── gbp-optimization-navi-mumbai.html
│   │       ├── industrial-electrical-maintenance.html
│   │       ├── industrial-training-college-industry.html
│   │       ├── internship-rules-maharashtra-engineering.html
│   │       ├── local-seo-navi-mumbai.html
│   │       ├── modern-portfolio-cloudflare-pages.html
│   │       ├── opencode-zen-free-models-vscode.html
│   │       ├── pcb-design-workshop.html
│   │       ├── petrol-vs-e20-vs-ev-2wheeler-guide.html
│   │       ├── readymade-projects-all-branches.html
│   │       ├── real-time-task-manager-react-nodejs.html
│   │       ├── seo-vs-google-ads.html
│   │       ├── workplace-safety-small-business.html
│   │       └── zero-budget-content-marketing.html
│   │
│   ├── pages/
│   │   │
│   │   ├── about.html
│   │   ├── blog.html                ⭐ Dynamic blog listing (JS-driven)
│   │   ├── contact.html
│   │   ├── contactform.html
│   │   ├── links.html
│   │   ├── portfolio.html
│   │   ├── privacy.html
│   │   ├── terms.html
│   │   │
│   │   ├── blog/                    (empty — placeholder subdirs: ai/, automation/, cloud/, development/, seo/, training/)
│   │   ├── portfolio/               (empty)
│   │   │
│   │   ├── expertise/
│   │   │   ├── digital-engineering.html
│   │   │   ├── freelance-digital-marketing-seo.html
│   │   │   └── learning-innovation.html    # Tabbed: Projects, Training, Workshops
│   │   │
│   │   └── partners/
│   │       ├── index.html
│   │       ├── graphics.html
│   │       ├── electrical.html
│   │       └── automotive.html
│   │
│   ├── app/                         ⭐ Login required — NOINDEX, NOFOLLOW
│   │   │
│   │   ├── dashboard.html           ⭐ Post-login landing page
│   │   ├── profile.html             ↤ User profile page
│   │   │
│   │   ├── auth/                    ↤ Authentication pages
│   │   │   ├── login.html
│   │   │   ├── register.html
│   │   │   ├── reset-password.html
│   │   │   ├── callback.html        ↤ Handles Supabase Auth redirects
│   │   │   └── SETUP.md             ↤ Auth setup guide
│   │   │
│   │   ├── admin/
│   │   │   ├── users.html           ↤ User management
│   │   │   └── audit.html           ↤ Audit logs
│   │   │
│   │   ├── seniority/
│   │   │   ├── seniority-list.html       ↤ Auth-guarded
│   │   │   └── seniority-management.html ↤ Auth-guarded
│   │   │
│   │   ├── hospital/                ⭐ Hospital management module
│   │   │   ├── dashboard.html
│   │   │   ├── new-visit.html       (7-step OPD visit form)
│   │   │   ├── patient-list.html
│   │   │   ├── patient-profile.html
│   │   │   ├── appointments.html
│   │   │   └── css/
│   │   │       └── hospital.css
│   │   ├── society/                 (empty — placeholder)
│   │   ├── future-apps/             (empty — placeholder)
│   │   └── ticket-manager/          (empty — placeholder)
│   │
│   ├── shared/
│   │   │
│   │   ├── components/
│   │   │   ├── header.html
│   │   │   └── footer.html
│   │   │
│   │   ├── css/
│   │   │   ├── style.css             # Shared base styles
│   │   │   ├── headerfooter.css
│   │   │   ├── auth.css              # Auth page styles (cards, forms, alerts, spinner)
│   │   │   ├── blog-sidebar.css
│   │   │   └── nadstyle.css
│   │   │
│   │   ├── js/
│   │   │   ├── config.js             # Centralized site config (brand, domain, contact, social)
│   │   │   ├── seo-injector.js       # Reads config + PAGE_CONFIG; injects meta/OG/Twitter/JSON-LD
│   │   │   ├── headerfooter.js       # Loads header/footer HTML + replaces {{PLACEHOLDERS}}; auth-aware nav
│   │   │   ├── auth.js               # Auth module — signIn, signUp, signOut, requireAuth, getUser, getUserRole
│   │   │   ├── blog.js               ⭐ Blog engine — search, categories, tags, pagination
│   │   │   ├── blog-sidebar.js       # Blog sidebar widget
│   │   │   └── form-handler.js
│   │   │
│   │   └── assets/
│   │       └── img/
│   │           ├── favicon.png
│   │           ├── logo.png
│   │           ├── og-default.svg
│   │           ├── icons8-project-96.png
│   │           ├── SocCal01.png
│   │           ├── SocCal02.png
│   │           ├── SocCal03.png
│   │           ├── SocCal04.png
│   │           └── graphics/
│   │               ├── birthday.svg
│   │               ├── wedding.svg
│   │               ├── logo.svg
│   │               └── video.svg
│   │
│   └── services/
│       │
│       └── blogService.js
│
└── backend/
    │
    ├── .env.example
    │
    ├── schema/
    │   ├── schema.sql
    │   ├── database-design.md
    │   ├── rls-policies.sql
    │   ├── auth-trigger.sql          ↤ Auto-create users_profile on signup
    │   └── admin-rls-policy.sql      ↤ Admin RLS policies
    │
    ├── seed/
    │   └── seed.sql
    │
    ├── import/                      ⭐ ETL pipeline for medical master data
    │   ├── README.md                (pipeline docs)
    │   ├── requirements.txt
    │   ├── config.py
    │   ├── raw/                     (source data — gitignored)
    │   │   ├── CDCI/                (7 TSV files)
    │   │   └── LOINC/               (Loinc.csv, Part.csv, etc.)
    │   ├── cleaned/                 (filtered CSVs — gitignored)
    │   ├── scripts/
    │   │   ├── utils.py
    │   │   ├── filter_cdci.py
    │   │   ├── filter_loinc.py
    │   │   ├── filter_icd10.py      (placeholder)
    │   │   ├── import_supabase.py
    │   │   └── verify_data.py
    │   └── sql/
    │       ├── medicine_master.sql
    │       ├── investigation_master.sql
    │       ├── revert-future-tables.sql
    │       └── diagnosis_master.sql (placeholder)
    │
    └── modules/
        │
        ├── blog/
        │   └── functions/           (empty — reserved for blog edge functions)
        │
        └── hospital/                ⭐ Hospital schema, seed & policies
            ├── schema/
            │   └── hospital-schema.sql
            ├── seed/
            │   └── seed-masters.sql
            └── policies/
                └── hospital-rls.sql

---

## Navigation

Expertise
    ├── Digital Engineering
    ├── Digital Marketing & SEO
    ├── Learning & Innovation
    └── Strategic Partners
        ├── Graphics, Photography & Branding (partners/graphics)
        ├── Electrical Services (partners/electrical)
        └── Automotive Services (partners/automotive)
Portfolio
Blog
About
Contact

---

## SEO Rules

| Area | Path | Indexing | robots.txt |
|------|------|----------|------------|
| Public site | `/` | Indexed, follow | Allowed |
| App area | `/app/` | `noindex, nofollow` | Disallowed |

### Implementation

**`frontend/_headers`**
```
/app/*
  X-Robots-Tag: noindex, nofollow
```

**`robots.txt`** (served from publish root)
```
User-agent: *
Allow: /

Disallow: /app/
Sitemap: https://mk9.in/sitemap.xml
```

### `_redirects` rules

Publish root: `frontend/`
404 page: `frontend/404.html`

Public pages:
```
/                         /index.html                                                        200
/about                    /pages/about.html                                                  200
/portfolio                /pages/portfolio.html                                              200
/contact                  /pages/contact.html                                                200
/blog                     /pages/blog.html                                                   200
/links                    /pages/links.html                                                  200
/terms                    /pages/terms.html                                                  200
/privacy                  /pages/privacy.html                                                200

/expertise/digital-engineering     /pages/expertise/digital-engineering.html                 200
/expertise/digital-marketing-seo   /pages/expertise/freelance-digital-marketing-seo.html      200
/expertise/learning-innovation     /pages/expertise/learning-innovation.html                  200

/partners                 /pages/partners/index.html                                         200
/partners/graphics        /pages/partners/graphics.html                                      200
/partners/electrical      /pages/partners/electrical.html                                    200
/partners/automotive      /pages/partners/automotive.html                                    200

Blog (dynamic listing + clean URLs):
/blog                     /pages/blog.html                                                   200
/blog/:slug               /blog/posts/:slug.html                                             200
```

Auth (clean URL rewrites):
```
/login               /app/auth/login.html                                                   200
/register            /app/auth/register.html                                                200
/reset-password      /app/auth/reset-password.html                                          200
/auth/callback       /app/auth/callback.html                                                200
/dashboard           /app/dashboard.html                                                    200
/app/admin           /app/admin/users.html                                                  200
```

Seniority (clean URL rewrites):
```
/app/seniority           /app/seniority/seniority-list.html                                 200
/app/seniority/manage    /app/seniority/seniority-management.html                           200
```

Legacy redirects (301):
```
/seo-digital-marketing          /expertise/digital-marketing-seo                              301
/website-development            /expertise/digital-engineering                                301
/business-automation            /expertise/digital-engineering                                301
/project-training               /expertise/learning-innovation                                301
/graphics-branding              /partners/graphics                                            301
/photography                    /partners/graphics                                            301
/electrical                     /partners/electrical                                          301
/automotive                     /partners/automotive                                          301

/pages/services/business-automation.html        /expertise/digital-engineering              301
/pages/services/photography.html                /partners/graphics                         301
/workshop.html                  /expertise/learning-innovation                              301

/seniority                      /app/seniority                                               301
/seniority/manage               /app/seniority/manage                                        301
/modules/seniority/pages/seniority-list          /app/seniority/seniority-list.html         301
/modules/seniority/pages/seniority-management     /app/seniority/seniority-management.html  301
```

---

## Public / Private Boundary

```
                    ┌──────────────────────────────────┐
                    │          mk9.in                   │
                    │   (Cloudflare Pages)              │
                    │   Publish root: frontend/         │
                    └────────────┬─────────────────────┘
                                 │
                    ┌────────────┴─────────────┐
                    │                          │
            ┌───────┴───────┐         ┌───────┴───────┐
            │     /         │         │    /app/      │
            │  (SEO: ✓)     │         │ (noindex)     │
            │               │         │               │
            │ index.html    │         │ auth/          │
            │ pages/        │         │ dashboard.html │
            │ expertise/    │         │ admin/         │
            │ partners/     │         │ seniority/     │
            │ blog/         │         │ profile.html   │
            └───────────────┘         └───────────────┘
```

- The root `/` (index.html, pages/) is indexed.
- Everything inside `app/` is `noindex, nofollow`.
- `app/` is disallowed in `robots.txt`.

---

## Key Files & Configuration

### Root Level
- **.gitignore** — Prevent .env, node_modules, build files from repo
- **.env.original** — Backup of original environment variables

### Supabase (Edge Functions)
- **supabase/functions/<name>/** — Each Edge Function as a standalone module
- Functions named `{module}-{entity}` (e.g., `blog-posts`)
- Deploy with: `supabase functions deploy <name>`

### Site Configuration (Centralized)
- **frontend/shared/js/config.js** — Single source of truth: brand name, domain, contact info, social links, OG image path
- **frontend/shared/js/seo-injector.js** — Reads `SITE_CONFIG` + per-page `PAGE_CONFIG`; dynamically generates `<title>`, all meta/OG/Twitter tags, canonical URL, and JSON-LD (Organization + BreadcrumbList)
- **Each HTML page** defines only a small `PAGE_CONFIG = { title, description, canonical }` block — no hardcoded meta tags
- **header.html / footer.html** — Use `{{PLACEHOLDER}}` syntax (e.g., `{{SITE_NAME_UPPER}}`, `{{PHONE}}`, `{{SOCIAL_WA}}`); replaced at runtime by `headerfooter.js` using values from `config.js`
- Change brand name, domain, phone, email, or social links in **one file** (`config.js`) and it propagates to every page, header, footer, and JSON-LD automatically
- Static XML/text files (`sitemap.xml`, `robots.txt`) still require manual domain updates

### Frontend Config
- **frontend/shared/js/config.js** — All site config (brand, domain, contact, social)
- **frontend/config/supabase.js** — Supabase client initialization (URL + anon key)

### Auth System
- **Supabase Auth** — Email/password authentication with session management
- **frontend/shared/js/auth.js** — Auth module: `signIn`, `signUp`, `signOut`, `resetPassword`, `requireAuth`, `getUser`, `getUserRole`
- **frontend/shared/css/auth.css** — Auth page styles
- **frontend/app/auth/** — Login, register, reset-password, callback pages
- **frontend/app/dashboard.html** — Post-login dashboard; shows different content per role (developer = full, admin = simplified, user = basic)
- **frontend/app/profile.html** — User profile page
- **backend/schema/auth-trigger.sql** — PostgreSQL trigger to auto-create `users_profile` on signup
- **Auth guard** — Seniority pages and dashboard redirect unauthenticated users to `/login`
- **Auth-aware nav** — Header shows DASHBOARD + LOGOUT when logged in; footer shows only LOGIN when logged out, no links when logged in
- **Roles**: `user` (default), `blogger`, `developer` (full access, can assign admin role), `hospital_admin`, `society_admin`, `senior_admin`, `admin` (project access, assigned by developer)

### Admin Module
- **frontend/app/admin/users.html** — User management interface (accessible by admin & developer)
- **frontend/app/admin/audit.html** — Audit log viewer
- **backend/schema/admin-rls-policy.sql** — Admin-specific RLS policies

### Dashboard by Role
| Role | Dashboard | Access |
|------|-----------|--------|
| Developer | Full dashboard — Seniority, Blog, User Management, Profile, Website | Everything |
| Admin | Simplified — User Management, Audit Logs, Profile, Website | Admin tasks |
| Senior Admin | Full dashboard (minus user mgmt) | Seniority + general |
| User | Basic — Seniority, Blog, Profile, Website | General modules |

### Backend Schema
- **backend/schema/schema.sql** — Core tables, indexes, RLS policies
- **backend/schema/rls-policies.sql** — Detailed row-level security documentation
- **backend/schema/admin-rls-policy.sql** — Admin role permissions and policies
- **backend/seed/seed.sql** — Initial data for categories, departments, groups

---

## Future Modules

To add a new module:

  1. Create `frontend/app/<name>/` (pages/, components/, css/, js/)
  2. Create `supabase/functions/<name>-*/index.ts` for each edge function
  3. Create `backend/modules/<name>/` (schema/, policies/, seed/)
  4. Add migration file in `backend/migrations/`

Active modules:
  - `frontend/app/hospital/` ✅ (dashboard, new-visit, patient-list, patient-profile, appointments)
  - `backend/modules/hospital/` ✅ (schema, seed, policies)
  - `backend/import/` ✅ (CDCI + LOINC ETL pipeline: filter → clean → import → verify)
  - `supabase/functions/hospital-patients/` ✅
  - `supabase/functions/hospital-masters/` ✅
  - `supabase/functions/hospital-dashboard/` ✅

Placeholders:
  - `frontend/app/society/`
  - `frontend/app/future-apps/`
  - `frontend/app/ticket-manager/`

All future modules should use:

- Supabase Auth
- Supabase PostgreSQL
- Supabase Storage
- Supabase Edge Functions

without changing the main architecture.

### Import Pipeline (`backend/import/`)

```
backend/import/
├── README.md                       # Usage docs
├── requirements.txt                # psycopg2-binary, python-dotenv
├── config.py                       # DB creds, file paths, column mappings
├── raw/                            # Source data (gitignored)
│   ├── CDCI/                       # 7 TSV files (BrandMaster, GenericMaster, etc.)
│   └── LOINC/                      # Loinc.csv + Part.csv (imported); AnswerList, LoincAnswerListLink & LoincPartLink (raw/ only — not imported)
├── cleaned/                        # Filtered CSVs (gitignored)
├── scripts/
│   ├── utils.py                    # Shared logger
│   ├── filter_cdci.py              # TSV → CSV (all columns kept)
│   ├── filter_loinc.py             # Loinc.csv → 7 columns, ACTIVE/TRIAL only
│   ├── filter_icd10.py             # Placeholder
│   ├── import_supabase.py          # Run SQL DDL + batch inserts (1k/batch)
│   └── verify_data.py              # CSV row count vs DB row count
└── sql/
    ├── medicine_master.sql         # 7 tables + medicine_search MV
    ├── investigation_master.sql    # loinc_codes + loinc_parts (future tables removed — run revert-future-tables.sql if exported)
    ├── revert-future-tables.sql    # Drop loinc_answer_list, loinc_answer_list_links, loinc_part_links from Supabase
    └── diagnosis_master.sql        # icd10_codes (placeholder)
```

**Pipeline flow:** `filter_cdci.py` + `filter_loinc.py` → cleaned CSVs → `import_supabase.py` (SQL DDL + batch INSERT ON CONFLICT DO NOTHING) → `verify_data.py`

**Cleaned CSV sizes:**

| File | Size | Rows |
|------|------|------|
| **CDCI** | | **186,673** |
| substance_master.csv | 352K | 3,274 |
| generic_master.csv | 2.5M | 10,174 |
| brand_master.csv | 13M | 93,019 |
| product_master.csv | 1.9M | 71,503 |
| drug_form_master.csv | 16K | 422 |
| route_master.csv | 4.9K | 160 |
| supplier_master.csv | 374K | 8,121 |
| **LOINC** | | **908,495** |
| loinc_codes.csv | 12M | 102,751 |
| loinc_parts.csv | 6.9M | 74,087 |


