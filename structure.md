# MK9 PROJECT STRUCTURE

## Architecture

Frontend : Cloudflare Pages + mk9.in
Backend  : Supabase Edge Functions (JavaScript/TypeScript)
Database : Supabase PostgreSQL (via `backend/schema/`)
Storage  : Supabase Storage (via client SDK)
Auth     : Supabase Auth (Login / Registration / Forgot Password / Reset Password)

## Repository
Local only — no remote configured

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
├── .gitignore
├── .env.original                  ↤ Backup of original env vars
│
├── supabase/
│   │
│   └── functions/
│       │
│       └── blog-posts/
│           └── index.ts
│
├── docs/
│   │
│   ├── DEPLOYMENT.md
│   └── ROADMAP.md
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
│   ├── pages/
│   │   │
│   │   ├── contact.html
│   │   ├── contactform.html
│   │   ├── blog.html
│   │   ├── links.html
│   │   │
│   │   ├── expertise/
│   │   │   ├── digital-engineering.html
│   │   │   ├── freelance-digital-marketing-seo.html
│   │   │   └── learning-innovation.html
│   │   │
│   │   └── partners/
│   │       ├── graphics.html
│   │       ├── electrical.html
│   │       └── automotive.html
│   │
│   ├── app/                         ⭐ Login required — NOINDEX, NOFOLLOW
│   │   │
│   │   └── seniority/
│   │       ├── seniority-list.html
│   │       └── seniority-management.html
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
│   │   │   └── nadstyle.css
│   │   │
│   │   ├── js/
│   │   │   ├── config.js             # Centralized site config (brand, domain, contact, social)
│   │   │   ├── seo-injector.js       # Reads config + PAGE_CONFIG; injects meta/OG/Twitter/JSON-LD
│   │   │   ├── headerfooter.js       # Loads header/footer HTML + replaces {{PLACEHOLDERS}}
│   │   │   └── form-handler.js
│   │   │
│   │   └── assets/
│   │       └── img/
│   │           ├── og-default.svg
│   │           ├── favicon.png
│   │           ├── logo.png
│   │           ├── icons8-project-96.png
│   │           └── graphics/
│   │               ├── birthday.svg
│   │               ├── wedding.svg
│   │               ├── logo.svg
│   │               └── video.svg
│   │
│   ├── services/
│   │   │
│   │   └── blogService.js
│   │
│   └── config/                      (empty — reserved for future use)
│
├── backend/
│   │
│   ├── .env.example
│   │
│   ├── schema/
│   │   ├── schema.sql
│   │   ├── database-design.md
│   │   └── rls-policies.sql
│   │
│   ├── seed/
│   │   └── seed.sql
│   │
│   └── modules/
│       │
│       └── blog/
│           └── functions/           (empty — reserved for blog edge functions)
│
└── Future/
    ├── CRM
    ├── ERP
    ├── HRMS
    ├── Inventory
    └── School

---

## Navigation

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
/contact                  /pages/contact.html                                                200
/blog                     /pages/blog.html                                                   200
/links                    /pages/links.html                                                  200

/expertise/digital-engineering     /pages/expertise/digital-engineering.html                 200
/expertise/digital-marketing-seo   /pages/expertise/freelance-digital-marketing-seo.html      200
/expertise/learning-innovation     /pages/expertise/learning-innovation.html                  200

/partners/graphics        /pages/partners/graphics.html                                      200
/partners/electrical      /pages/partners/electrical.html                                    200
/partners/automotive      /pages/partners/automotive.html                                    200
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
            │ index.html    │         │ seniority/    │
            │ pages/        │         │               │
            │ expertise/    │         │               │
            │ partners/     │         │               │
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

### Backend Schema
- **backend/schema/schema.sql** — Core tables, indexes, RLS policies
- **backend/schema/rls-policies.sql** — Detailed row-level security documentation
- **backend/seed/seed.sql** — Initial data for categories, departments, groups

---

## Future Modules

To add a new module:

  1. Create `frontend/app/<name>/` (pages/, components/, css/, js/)
  2. Create `supabase/functions/<name>-*/index.ts` for each edge function
  3. Create `backend/modules/<name>/` (schema/, policies/, seed/)
  4. Add migration file in `backend/migrations/`

All future modules should use:

- Supabase Auth
- Supabase PostgreSQL
- Supabase Storage
- Supabase Edge Functions

without changing the main architecture.
