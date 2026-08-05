# AARTI TECH SERVICES — PROJECT STRUCTURE

## Architecture

Frontend : Cloudflare Pages (aartitechservices.pages.dev / mk9.in)
Backend  : None (fully static — no database, no server, no auth)
Hosting  : Cloudflare Pages (static, no build step, publish root = repo root)
Fonts    : Self-hosted (Font Awesome 6.4 + Bootstrap Icons 1.10.5)
Forms    : Google Apps Script (contact form)
Blog     : Static JSON-driven engine (no backend)

## Repository

GitHub: https://github.com/milindweb/aartitechservices.git

## Repository Structure

aartitechservices/
│
├── README.md                        ↤ Project overview
├── CHANGELOG.md                     ↤ Version history
├── structure.md                     ↤ This file
├── .gitignore
├── .env.example
├── .env.original                    ↤ Backup of original env vars
├── .htaccess                        ↤ Apache security & caching
├── _headers                         ↤ Cloudflare headers & caching / SEO
├── _redirects                       ↤ Cloudflare URL rewrites (clean URLs + legacy 301s)
├── _local_server.py                 ↤ Local dev server honoring _redirects
├── robots.txt                       ↤ Crawler rules
├── sitemap.xml                      ↤ XML sitemap (manual updates required)
│
├── index.html                       ⭐ Homepage
├── about.html                       ↤ About page
├── blog.html                        ⭐ Dynamic blog listing (JS-driven)
├── contact.html                     ↤ Contact page
├── contactform.html                 ↤ Contact form partial (fetched by JS)
├── links.html                       ↤ Links page
├── portfolio.html                   ↤ Portfolio page
├── privacy.html                     ↤ Privacy policy
├── terms.html                       ↤ Terms of service
├── 404.html                         ↤ Custom 404 page
│
├── expertise/                       ↤ Service pages
│   ├── digital-engineering.html
│   ├── freelance-digital-marketing-seo.html
│   └── learning-innovation.html     # Tabbed: Projects, Training, Workshops
│
├── partners/                        ↤ Strategic partner pages
│   ├── index.html
│   ├── graphics.html
│   ├── electrical.html
│   └── automotive.html
│
├── blog/
│   └── posts/                       ⭐ 29 individual blog post HTML files
│       ├── _template.html           ↤ Duplicatable post template
│       ├── arduino-esp32-workshop.html
│       ├── automotive-diagnostics-guide.html
│       ├── brand-identity-design.html
│       ├── build-professional-network-freelancer.html
│       ├── build-rest-api-nodejs-postgresql.html
│       ├── camera-buying-guide-2026.html
│       ├── chatgpt-business-ai.html
│       ├── digital-tools-small-business-2026.html
│       ├── digitizing-society-management.html
│       ├── drone-photography-real-estate.html
│       ├── drone-regulations-india-dgca.html
│       ├── drone-types-cost-india.html
│       ├── engineering-project-ideas-final-year.html
│       ├── full-stack-beginners-guide.html
│       ├── gbp-optimization-navi-mumbai.html
│       ├── industrial-electrical-maintenance.html
│       ├── industrial-training-college-industry.html
│       ├── internship-rules-maharashtra-engineering.html
│       ├── local-seo-navi-mumbai.html
│       ├── modern-portfolio-cloudflare-pages.html
│       ├── opencode-zen-free-models-vscode.html
│       ├── pcb-design-workshop.html
│       ├── petrol-vs-e20-vs-ev-2wheeler-guide.html
│       ├── readymade-projects-all-branches.html
│       ├── real-time-task-manager-react-nodejs.html
│       ├── seo-vs-google-ads.html
│       ├── workplace-safety-small-business.html
│       └── zero-budget-content-marketing.html
│
├── css/                             ↤ Stylesheets
│   ├── style.css                    # Shared base styles
│   ├── headerfooter.css
│   ├── blog-sidebar.css
│   └── nadstyle.css
│
├── js/                              ↤ Scripts
│   ├── config.js                    # Centralized site config (brand, domain, contact, social)
│   ├── seo-injector.js              # Reads config + PAGE_CONFIG; injects meta/OG/Twitter/JSON-LD
│   ├── headerfooter.js              # Loads header/footer HTML + replaces {{PLACEHOLDERS}}
│   ├── blog.js                      ⭐ Blog engine — search, categories, tags, pagination
│   ├── blog-sidebar.js              # Blog sidebar widget (recent posts, categories, tags)
│   └── form-handler.js              # Contact form handler (Google Apps Script)
│
├── data/
│   └── posts.json                   ⭐ Blog posts data (JSON-driven)
│
├── components/
│   ├── header.html                  ↤ Shared header (loaded at runtime)
│   └── footer.html                  ↤ Shared footer (loaded at runtime)
│
├── img/                             ↤ Images
│   ├── favicon.png
│   ├── logo.png
│   ├── og-default.svg
│   ├── icons8-project-96.png
│   ├── SocCal01.png
│   ├── SocCal02.png
│   ├── SocCal03.png
│   ├── SocCal04.png
│   └── graphics/
│       ├── birthday.svg
│       ├── logo.svg
│       ├── video.svg
│       └── wedding.svg
│
├── fonts/                           ↤ Self-hosted icon fonts (no CDN)
│   ├── fontawesome/
│   │   ├── css/                     (all.min.css, v4-shims.min.css)
│   │   └── webfonts/                (fa-brands-400.woff2, fa-regular-400.woff2, fa-solid-900.woff2, fa-v4compatibility.woff2)
│   └── bootstrap-icons/
│       └── font/
│           ├── bootstrap-icons.css
│           ├── bootstrap-icons.min.css
│           └── fonts/               (bootstrap-icons.woff2)
│
├── docs/
│   ├── DEPLOYMENT.md                ↤ Deployment guide
│   └── ROADMAP.md                   ↤ Roadmap
│
├── archive/                         ↤ Archived code (not deployed)
│   ├── README.md                    ↤ Explains archived content
│   ├── app/                         ↤ Old auth/admin/dashboard/profile/seniority/hospital UI
│   ├── backend/                     ↤ Old Supabase backend (schema, seed, import pipeline, modules)
│   ├── config/                      ↤ Old supabase.js client config
│   ├── services/                    ↤ Old blogService.js (Supabase-driven)
│   ├── shared/                      ↤ Old auth.js, auth.css
│   ├── docs/                        ↤ SRS-Hospital.md
│   └── Hospital data raw/           ↤ Raw medical data files
│
└── VScode/                          (empty — reserved)

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

## Clean URLs & Redirects

Cloudflare Pages automatically serves `.html` files at clean URLs (e.g. `/about.html` → `/about`, 308 redirect on the `.html` form). No `_redirects` rule is needed for pages that map 1:1 to a file.

Rules in `_redirects` cover only paths where the target filename differs:

### Expertise alias (200 rewrite)
```
/expertise/digital-marketing-seo   /expertise/freelance-digital-marketing-seo.html   200
```

### Expertise page anchors (301)
```
/expertise/learning-innovation/projects     /expertise/learning-innovation#projects   301
/expertise/learning-innovation/training     /expertise/learning-innovation#training   301
/expertise/learning-innovation/workshops    /expertise/learning-innovation#workshops  301
```

### Legacy redirects (301) — old service URLs → new clean URLs
```
/seo-digital-marketing          /expertise/digital-marketing-seo                 301
/website-development            /expertise/digital-engineering                   301
/business-automation            /expertise/digital-engineering                   301
/project-training               /expertise/learning-innovation                   301
/photography                    /partners/graphics                               301
/graphics-branding              /partners/graphics                               301
/electrical                     /partners/electrical                             301
/automotive                     /partners/automotive                             301
```

### Old direct file paths (301)
```
/pages/services/business-automation.html    /expertise/digital-engineering        301
/pages/services/photography.html            /partners/graphics                    301
/workshop.html                              /expertise/learning-innovation        301
```

### Blog posts — clean /blog/:slug URLs (200 rewrite)
```
/blog/:slug   /blog/posts/:slug.html   200
```
(One rule per post, generated for all 29 posts.)

### Favicon (200 rewrite)
```
/favicon.ico   /img/favicon.png   200
```

---

## SEO Rules

| Area | Path | Indexing | robots.txt |
|------|------|----------|------------|
| Entire public site | `/` | Indexed, follow | Allowed |

- No `noindex` areas — the old `/app/*` block was removed.
- `robots.txt` allows everything and points to the sitemap.

---

## Key Files & Configuration

### Site Configuration (Centralized)
- **js/config.js** — Single source of truth: brand name, domain, contact info, social links, OG image path
- **js/seo-injector.js** — Reads `SITE_CONFIG` + per-page `PAGE_CONFIG`; dynamically generates `<title>`, all meta/OG/Twitter tags, canonical URL, and JSON-LD (Organization + BreadcrumbList)
- **Each HTML page** defines only a small `PAGE_CONFIG = { title, description, canonical }` block — no hardcoded meta tags
- **components/header.html / footer.html** — Use `{{PLACEHOLDER}}` syntax (e.g., `{{SITE_NAME_UPPER}}`, `{{PHONE}}`, `{{SOCIAL_WA}}`); replaced at runtime by `js/headerfooter.js` using values from `config.js`
- Change brand name, domain, phone, email, or social links in **one file** (`config.js`) and it propagates to every page, header, footer, and JSON-LD automatically
- Static XML/text files (`sitemap.xml`, `robots.txt`) still require manual domain updates

### Blog
- **data/posts.json** — All post metadata (title, date, category, tags, excerpt, url)
- **js/blog.js** — Listing engine: search, category/tag filtering, pagination
- **js/blog-sidebar.js** — Sidebar widget: search, categories, recent posts, tag cloud
- **blog/posts/*.html** — Full HTML posts; each post has its own `PAGE_CONFIG` block

### Local Development
- **python3 _local_server.py** — Dev server that honors `_redirects` (serves `/blog`, `/about`, `/blog/:slug`, etc. exactly like Cloudflare). Default port 8080.

---

## Future Modules

All previously-planned app modules (auth, admin, dashboard, profile, seniority, hospital, society, ticket-manager) and the Supabase backend were **archived** (`archive/`) when the site was converted to a fully static business site. They are not deployed and are kept for reference only.

To add future functionality:
- Keep the static architecture (no backend).
- For interactive features, use client-side JS + third-party services (e.g., Google Apps Script forms) exactly like the current contact form.
