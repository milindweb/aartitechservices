# MK9 PROJECT STRUCTURE

## Architecture

Frontend : Cloudflare Pages (aartitechsevices.pages.dev / mk9.in)
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
│   │   └── posts/                   ⭐ Individual blog post HTML files
│   │       ├── _template.html
│   │       ├── modern-portfolio-cloudflare-pages.html
│   │       ├── digitizing-society-management.html
│   │       ├── local-seo-navi-mumbai.html
│   │       ├── ... (20 posts)
│   │       └── readymade-projects-all-branches.html
│   │
│   ├── pages/
│   │   │
│   │   ├── contact.html
│   │   ├── contactform.html
│   │   ├── blog.html                ⭐ Dynamic blog listing (JS-driven)
│   │   ├── links.html
│   │   │
│   │   ├── expertise/
│   │   │   ├── digital-engineering.html
│   │   │   ├── freelance-digital-marketing-seo.html
│   │   │   └── learning-innovation.html    # Tabbed: Projects, Training, Workshops
│   │   │
│   │   └── partners/
│   │       ├── graphics.html
│   │       ├── electrical.html
│   │       └── automotive.html
│   │
│       ├── app/                         ⭐ Login required — NOINDEX, NOFOLLOW
│   │   │
│   │   ├── auth/                    ↤ Authentication pages
│   │   │   ├── login.html
│   │   │   ├── register.html
│   │   │   ├── reset-password.html
│   │   │   ├── callback.html        ↤ Handles Supabase Auth redirects
│   │   │   └── SETUP.md             ↤ Auth setup guide
│   │   │
│   │   ├── dashboard.html           ⭐ Post-login landing page
│   │   │
│   │   └── seniority/
│   │       ├── seniority-list.html       ↤ Auth-guarded
│   │       └── seniority-management.html ↤ Auth-guarded
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
│   │   │   └── nadstyle.css
│   │   │
│   │   │   ├── js/
│   │   │   ├── config.js             # Centralized site config (brand, domain, contact, social)
│   │   │   ├── seo-injector.js       # Reads config + PAGE_CONFIG; injects meta/OG/Twitter/JSON-LD
│   │   │   ├── headerfooter.js       # Loads header/footer HTML + replaces {{PLACEHOLDERS}}; auth-aware nav
│   │   │   ├── auth.js               # Auth module — signIn, signUp, signOut, requireAuth, getUser, getUserRole
│   │   │   ├── blog.js               ⭐ Blog engine — search, categories, tags, pagination
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
│
├── backend/
│   │
│   ├── .env.example
│   │
│   ├── schema/
│   │   ├── schema.sql
│   │   ├── database-design.md
│   │   ├── rls-policies.sql
│   │   └── auth-trigger.sql          ↤ Auto-create users_profile on signup
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
/contact                  /pages/contact.html                                                200
/blog                     /pages/blog.html                                                   200
/links                    /pages/links.html                                                  200

/expertise/digital-engineering     /pages/expertise/digital-engineering.html                 200
/expertise/digital-marketing-seo   /pages/expertise/freelance-digital-marketing-seo.html      200
/expertise/learning-innovation     /pages/expertise/learning-innovation.html                  200

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
             │ index.html    │         │ auth/          │
             │ pages/        │         │ dashboard.html │
             │ expertise/    │         │ seniority/     │
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
- **frontend/config/supabase.js** — Supabase client initialization (URL + anon key)

### Auth System
- **Supabase Auth** — Email/password authentication with session management
- **frontend/shared/js/auth.js** — Auth module: `signIn`, `signUp`, `signOut`, `resetPassword`, `requireAuth`, `getUser`, `getUserRole`
- **frontend/shared/css/auth.css** — Auth page styles
- **frontend/app/auth/** — Login, register, reset-password, callback pages
- **frontend/app/dashboard.html** — Post-login dashboard with user profile and module links
- **backend/schema/auth-trigger.sql** — PostgreSQL trigger to auto-create `users_profile` on signup
- **Auth guard** — Seniority pages and dashboard redirect unauthenticated users to `/login`
- **Auth-aware nav** — Header shows DASHBOARD link only when logged in; no SIGN IN link in header (accessible via footer)

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
