# MK9 PROJECT STRUCTURE

## Architecture

Frontend : GitHub + Cloudflare Pages + mk9.in
Backend  : Supabase Edge Functions (JavaScript/TypeScript)
Database : Supabase PostgreSQL (via `backend/schema/` + `backend/migrations/`)
Storage  : Supabase Storage (via client SDK)
Auth     : Supabase Auth (Login / Registration / Forgot Password / Reset Password)

## GITHUB DETAILS
Username: milindweb
Repository: https://github.com/milindweb/aartitechservices

## Future Subdomains

mk9.in                → Main Portal (deployed from `frontend/site/`)
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
├── LICENSE
├── .gitignore
├── .env.example
├── .env.local (⚠️ DO NOT COMMIT)
├── package.json
├── package-lock.json
│
├── supabase/
│   │
│   ├── config.toml
│   │
│   └── functions/
│       │
│       ├── auth-handler/
│       ├── blog-posts/
│       ├── blog-comments/
│       ├── hospital-appointments/
│       ├── hospital-doctors/
│       ├── society-groups/
│       ├── society-posts/
│       ├── seniority-records/
│       ├── seniority-promotions/
│       ├── admin-audit/
│       └── admin-settings/
│
├── docs/
│   │
│   ├── SRS/
│   │   ├── website-srs.md
│   │   ├── blog-srs.md
│   │   ├── hospital-srs.md
│   │   ├── society-srs.md
│   │   └── seniority-srs.md
│   │
│   ├── DATABASE/
│   │   ├── database-design.md
│   │   ├── er-diagram.md
│   │   └── schema-notes.md
│   │
│   ├── API/
│   │   └── api-documentation.md
│   │
│   ├── DEPLOYMENT.md
│   └── ROADMAP.md
│
├── frontend/
│   │
│   ├── package.json
│   ├── .env.example
│   ├── .env.local (⚠️ DO NOT COMMIT)
│   ├── .htaccess                    ↤ Apache security & caching
│   ├── _headers                     ↤ Cloudflare headers & caching / SEO
│   ├── _redirects                   ↤ Cloudflare URL rewrites
│   │
│   ├── site/                        ⭐ SEO — fully indexed
│   │   │
│   │   ├── index.html
│   │   │
│   │   ├── pages/
│   │   │   │
│   │   │   ├── about.html
│   │   │   ├── contact.html
│   │   │   ├── portfolio.html
│   │   │   ├── blog.html
│   │   │   ├── links.html
│   │   │   │
│   │   │   ├── expertise/
│   │   │   │   ├── digital-engineering.html
│   │   │   │   ├── freelance-digital-marketing-seo.html
│   │   │   │   ├── learning-innovation.html
│   │   │   │   └── strategic-partners.html
│   │   │   │
│   │   │   ├── partners/
│   │   │   │   ├── graphics.html
│   │   │   │   ├── photography.html
│   │   │   │   ├── electrical.html
│   │   │   │   └── automotive.html
│   │   │   │
│   │   │   └── blog/
│   │   │       ├── seo/
│   │   │       ├── development/
│   │   │       ├── cloud/
│   │   │       ├── automation/
│   │   │       ├── ai/
│   │   │       └── training/
│   │   │
│   │   └── assets/
│   │
│   ├── app/                         ⭐ Login required — NOINDEX, NOFOLLOW
│   │   │
│   │   ├── auth/   (Use supaabse default auth system)
│   │   │   ├── login.html
│   │   │   ├── register.html
│   │   │   └── forgot-password.html
│   │   │
│   │   ├── hospital/
│   │   ├── seniority/
│   │   ├── ticket-manager/
│   │   ├── admin/
│   │   └── future-apps/
│   │
│   ├── shared/
│   │   │
│   │   ├── components/
│   │   │   ├── header.html
│   │   │   ├── footer.html
│   │   │   ├── navbar.html
│   │   │   ├── sidebar.html
│   │   │   └── loader.html
│   │   │
│   │   ├── css/
│   │   │   ├── style.css             # Shared base styles
│   │   │   ├── headerfooter.css
│   │   │   ├── variables.css
│   │   │   └── responsive.css
│   │   │
│   │   ├── js/
│   │   │   ├── config.js             # Centralized site config (brand, domain, contact, social)
│   │   │   ├── seo-injector.js       # Reads config + PAGE_CONFIG; injects meta/OG/Twitter/JSON-LD
│   │   │   ├── app.js
│   │   │   ├── auth.js
│   │   │   ├── navbar.js
│   │   │   ├── headerfooter.js       # Loads header/footer HTML + replaces {{PLACEHOLDERS}}
│   │   │   ├── form-handler.js
│   │   │   └── utils.js
│   │   │
│   │   └── assets/
│   │       ├── img/
│   │       │   ├── og-default.svg
│   │       │   └── graphics/
│   │       │       ├── birthday.svg
│   │       │       ├── wedding.svg
│   │       │       ├── logo.svg
│   │       │       └── video.svg
│   │       ├── icons/
│   │       ├── fonts/
│   │       └── data/
│   │
│   ├── services/
│   │   │
│   │   ├── supabaseClient.js
│   │   ├── api.js
│   │   ├── authService.js
│   │   ├── blogService.js
│   │   ├── hospitalService.js
│   │   ├── societyService.js
│   │   ├── seniorityService.js
│   │   ├── storageService.js
│   │   └── adminService.js
│   │
│   └── config/
│       ├── supabase.js
│       ├── env.js
│       ├── routes.js
│       └── constants.js
│
├── backend/
│   │
│   ├── .env.example
│   ├── .env.local (⚠️ DO NOT COMMIT)
│   │
│   ├── schema/
│   │   ├── schema.sql
│   │   ├── database-design.md
│   │   └── rls-policies.sql
│   │
│   ├── seed/
│   │   ├── seed.sql
│   │   └── seed-data.json
│   │
│   ├── migrations/
│   │   ├── 001_initial_schema.sql
│   │   ├── 002_blog_module.sql
│   │   ├── 003_hospital_module.sql
│   │   ├── 004_society_module.sql
│   │   ├── 005_seniority_module.sql
│   │   └── migration-status.md
│   │
│   ├── modules/
│   │   │
│   │   ├── auth/
│   │   │   ├── schema/
│   │   │   │   └── auth-schema.sql
│   │   │   └── policies/
│   │   │       └── auth-policies.sql
│   │   │
│   │   ├── blog/
│   │   │   ├── schema/
│   │   │   │   └── blog-schema.sql
│   │   │   ├── policies/
│   │   │   │   └── blog-policies.sql
│   │   │   └── seed/
│   │   │       └── blog-seed.sql
│   │   │
│   │   ├── hospital/
│   │   │   ├── schema/
│   │   │   │   └── hospital-schema.sql
│   │   │   ├── policies/
│   │   │   │   └── hospital-policies.sql
│   │   │   └── seed/
│   │   │       └── hospital-seed.sql
│   │   │
│   │   ├── society/
│   │   │   ├── schema/
│   │   │   │   └── society-schema.sql
│   │   │   ├── policies/
│   │   │   │   └── society-policies.sql
│   │   │   └── seed/
│   │   │       └── society-seed.sql
│   │   │
│   │   ├── seniority/
│   │   │   ├── schema/
│   │   │   │   └── seniority-schema.sql
│   │   │   ├── policies/
│   │   │   │   └── seniority-policies.sql
│   │   │   └── seed/
│   │   │       └── seniority-seed.sql
│   │   │
│   │   └── admin/
│   │       ├── schema/
│   │       │   └── admin-schema.sql
│   │       └── policies/
│   │           └── admin-policies.sql
│   │
│   ├── shared/
│   │   │
│   │   ├── config/
│   │   │   ├── supabase-config.ts
│   │   │   └── constants.ts
│   │   │
│   │   ├── middleware/
│   │   │   ├── auth-middleware.ts
│   │   │   ├── rate-limit.ts
│   │   │   └── error-handler.ts
│   │   │
│   │   ├── utils/
│   │   │   ├── validators.ts
│   │   │   ├── formatters.ts
│   │   │   ├── logger.ts
│   │   │   └── helpers.ts
│   │   │
│   │   └── types/
│   │       ├── index.ts
│   │       ├── database.ts
│   │       └── api.ts
│   │
│   └── scripts/
│       ├── backup.sh
│       ├── deploy.sh
│       ├── setup.sh
│       └── reset-db.sh
│
├── storage/
│   │
│   ├── blog/
│   │   └── featured/
│   ├── hospital/
│   │   ├── documents/
│   │   └── prescriptions/
│   ├── society/
│   ├── seniority/
│   ├── documents/
│   ├── reports/
│   └── templates/
│
├── .github/
│   └── workflows/
│       ├── deploy-frontend.yml
│       └── deploy-functions.yml
│
└── Future/
    ├── CRM
    ├── ERP
    ├── HRMS
    ├── School
    ├── Inventory
    └── Any New Application

---

## Navigation

Home
About
Expertise
    ├── Digital Engineering
    ├── Digital Marketing & SEO
    ├── Learning & Innovation
    └── Strategic Partners
Portfolio
Blog
Contact
Login

---

## SEO Rules

| Area | Path | Indexing | robots.txt |
|------|------|----------|------------|
| Public site | `/site/` | Indexed, follow | Allowed |
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

Public pages:
```
/                         /site/index.html                                                   200
/about                    /site/pages/about.html                                             200
/contact                  /site/pages/contact.html                                           200
/portfolio                /site/pages/portfolio.html                                         200
/blog                     /site/pages/blog.html                                              200
/links                    /site/pages/links.html                                             200

/expertise/digital-engineering     /site/pages/expertise/digital-engineering.html            200
/expertise/digital-marketing-seo   /site/pages/expertise/freelance-digital-marketing-seo.html 200
/expertise/learning-innovation     /site/pages/expertise/learning-innovation.html             200
/expertise/strategic-partners      /site/pages/expertise/strategic-partners.html              200

/partners/graphics        /site/pages/partners/graphics.html                                 200
/partners/photography     /site/pages/partners/photography.html                              200
/partners/electrical      /site/pages/partners/electrical.html                               200
/partners/automotive      /site/pages/partners/automotive.html                               200
```

Auth pages (only entry point to app area):
```
/login                   /app/auth/login.html                                                200
/register                /app/auth/register.html                                              200
/forgot-password         /app/auth/forgot-password.html                                       200
```

App area (catch-all):
```
/app/*                   /app/:splat                                                          200
```

Legacy redirects (301):
```
/seo-digital-marketing          /expertise/digital-marketing-seo                              301
/website-development            /expertise/digital-engineering                                301
/project-training               /expertise/learning-innovation                                301
/graphics-branding              /partners/graphics                                            301
/electrical                     /partners/electrical                                          301
/automotive                     /partners/automotive                                          301
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
            │    /site/     │         │    /app/      │
            │  (SEO: ✓)     │         │ (noindex)     │
            │               │         │               │
            │ index.html    │         │ auth/         │
            │ pages/        │         │ hospital/     │
            │ expertise/    │         │ society/      │
            │ partners/     │         │ seniority/    │
            │ blog/         │         │ admin/        │
            │ portfolio/    │         │ ticket-man./  │
            └───────────────┘         └───────────────┘
```

- Everything inside `site/` is indexed.
- Everything inside `app/` is `noindex, nofollow`.
- `app/` is disallowed in `robots.txt`.
- Login is the only public entry point to the applications.

---

## Key Files & Configuration

### Root Level
- **package.json** — Project dependencies & scripts (includes `supabase` CLI)
- **.env.example** — Template for environment variables (version control safe)
- **.env.local** — Actual secrets & keys (⚠️ add to .gitignore)
- **.gitignore** — Prevent node_modules, .env.local, build files from repo

### Supabase (Edge Functions)
- **supabase/config.toml** — Project ID, function settings, auth config
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
- **frontend/config/supabase.js** — Supabase client initialization with ANON_KEY
- **frontend/services/authService.js** — Auth operations (login, register, logout)
- **frontend/services/supabaseClient.js** — Shared Supabase client instance

### Backend Schema
- **backend/schema/schema.sql** — Core tables, indexes, RLS policies
- **backend/schema/rls-policies.sql** — Detailed row-level security documentation
- **backend/seed/seed.sql** — Initial data for categories, departments, groups
- **backend/migrations/** — Versioned database changes

---

## Future Modules

To add a new module:

  1. Create `frontend/app/<name>/` (pages/, components/, css/, js/)
  2. Create `supabase/functions/<name>-*/index.ts` for each edge function
  3. Create `backend/modules/<name>/` (schema/, policies/, seed/)
  4. Add migration file in `backend/migrations/`
  5. Register routes in `frontend/config/routes.js`

All future modules should use:

- Supabase Auth
- Supabase PostgreSQL
- Supabase Storage
- Supabase Edge Functions

without changing the main architecture.
