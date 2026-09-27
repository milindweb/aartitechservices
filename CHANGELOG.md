# Changelog

## v2.3.0 — 2026-09-28 — Add MKsociety, NADSOC and Society Calculator screenshots to portfolio

### Added
- `portfolio.html` — new featured project card for **MKsociety – Society & Apartment Management Platform** (status Live, live preview `https://mksoc.in`) with modules, technology stack and an eight-screenshot grid
- `img/MKsociety/` — eight WebP product screenshots (`dashboard`, `dashboard-dark`, `maintenance-billing`, `invoice`, `accounting`, `trial-balance`, `reports`, `complaint`; ~431 KB total)
- `portfolio.html` — eleven-screenshot grid added to the existing **NAD Society Management System** card
- `img/NADSOC/` — eleven PNG screenshots converted to WebP (`admin-panel`, `bulk-sms`, `custom-report`, `dashboard`, `demand`, `final-settlement`, `members`, `recovery`, `report`, `surety`, `user-management`; ~736 KB total)
- `img/SocCal/` — four Society Calculator screenshots converted from root PNGs to WebP (`soccal-01`–`soccal-04`; ~198 KB total, down from ~2.8 MB)
- `js/lightbox.js` — click-to-zoom lightbox for `.screenshot-grid` images (native `<dialog>`, close via button, backdrop click or Escape; progressive enhancement)
- `js/gallery.js` — one-image-at-a-time horizontal carousel for each project's screenshots (scroll-snap for swipe/trackpad, prev/next buttons, `current / total` counter, arrow/Home/End keys; progressive enhancement)

### Changed
- `portfolio.html` — Society Calculator screenshots moved from `img/` to `img/SocCal/`
- `portfolio.html` — screenshot grids converted from an auto-fit grid to a single-image scroll-snap carousel with prev/next controls and a counter
- `portfolio.html` — added `rel="noopener"` to external preview links and de-duplicated the `.screenshot-grid img` cursor rule

### Fixed
- `js/lightbox.js` — added `aria-label` to the lightbox dialog for screen-reader context
- `js/lightbox.js` — ignore the click that follows a horizontal swipe so scrolling a carousel no longer opens the lightbox

### Documentation
- `README.md` — added `js/lightbox.js` to the scripts list
- `CHANGELOG.md` — added this entry

---

## v2.2.0 — 2026-08-05 — Fix Cloudflare clean-URL redirect loops

### Fixed
- `_redirects` — removed 1:1 clean-URL rewrite rules (`/about → /about.html 200`, etc.) that conflicted with Cloudflare Pages' automatic clean-URL feature, causing infinite 308 redirect loops on `/about`, `/portfolio`, `/contact`, `/blog`, and `/partners/*`
- Cloudflare auto-serves `.html` files at clean URLs, so those pages no longer need any rule; only rules where the target filename differs remain (blog slugs, expertise alias, legacy 301s, favicon)

### Documentation
- `structure.md` — updated Clean URLs & Redirects section to document the auto clean-URL behavior and remaining rules
- `CHANGELOG.md` — added this entry

---

## v2.1.0 — 2026-08-05 — Local dev server honoring _redirects + blog sidebar slug fix

### Added
- `_local_server.py` — local development server that reads `_redirects` and serves clean URLs (`/blog`, `/blog/:slug`, `/about`, etc.) exactly like Cloudflare Pages; run with `python3 _local_server.py`

### Fixed
- `js/blog-sidebar.js` — current post now correctly excluded from "Recent Posts": slug resolution handles both the clean URL (`/blog/:slug`) and the physical path (`/blog/posts/:slug.html`) via `window.location.pathname`

### Documentation
- `structure.md` — added Local Development section
- `CHANGELOG.md` — added this entry

---

## v2.0.0 — 2026-08-05 — Convert to fully static business site (remove Supabase & auth)

### Added
- `fonts/` — self-hosted Font Awesome 6.4 + Bootstrap Icons 1.10.5 (no CDN dependency)
- `structure.md` — rewritten for the new root-based static structure

### Removed
- `supabase/` (config.toml, edge functions, migrations) — deleted
- `complaint.json`, `import.log`, `Future/` — deleted
- All auth: login/logout/dashboard nav items removed from `components/header.html`, `components/footer.html`, `js/headerfooter.js`

### Changed
- Repo root is now the publish root — `frontend/` folder removed, contents moved to root
- Pages flattened: `pages/*.html` → root (`about.html`, `blog.html`, `contact.html`, etc.); `pages/expertise/` → `expertise/`, `pages/partners/` → `partners/`
- Shared assets relocated: `shared/css/` → `css/`, `shared/js/` → `js/`, `shared/components/` → `components/`, `shared/assets/img/` → `img/`
- All HTML/JS/CSS references updated from `/shared/*` to the new root-level paths
- CDN font links replaced with self-hosted local paths
- `_redirects` — removed `/app/*` and auth lines; retargeted `/about` etc. to root; kept all blog slug redirects
- `_headers` — removed `/app/*` noindex block; updated asset paths
- `robots.txt` — removed `Disallow: /app/`
- `portfolio.html`, `privacy.html`, `expertise/learning-innovation.html` — removed Supabase mentions

### Moved to Archive
- `app/`, `backend/`, `Hospital data raw/`, `config/`, `services/`, `shared/js/auth.js`, `shared/css/auth.css`, `docs/SRS-Hospital.md`, `structure.md` (old) → `archive/`
- `archive/README.md` — documents the archived content

### Documentation
- `README.md` — rewritten for static-only architecture and root structure
- `docs/DEPLOYMENT.md`, `docs/ROADMAP.md` — updated for static-only, no Supabase
- `CHANGELOG.md` — added this entry

---

## v1.7.0 — 2026-07-06 — Hospital masters JSON + fallback refactor

### Added
- `frontend/app/hospital/data/masters.json` — Central JSON file with exact 22 departments (code + name) and 12 doctors list

### Changed
- `frontend/app/hospital/new-visit.html` — replaced hardcoded fallback arrays with fetch from `masters.json`; added `loadMastersFallback()` helper
- `frontend/app/hospital/appointments.html` — department dropdown fallback now loads from `masters.json`
- `frontend/app/hospital/department-list.html` — removed (replaced by JSON data file)

### Documentation
- `structure.md`, `README.md`, `SRS-Hospital.md` — updated file tree with `data/masters.json`
- `CHANGELOG.md` — added this entry

---

## v1.6.0 — 2026-07-06 — Hospital sub-navigation component

### Added
- `frontend/app/hospital/components/hospital-nav.html` — Reusable sub-navigation bar with back button, hospital home link, and quick links (New Visit, Patients, Appointments)
- `frontend/app/hospital/js/hospital-nav.js` — Dynamic component loader (fetches and injects nav HTML)
- `.hosp-nav` styles in `frontend/app/hospital/css/hospital.css` — Sticky sub-nav below main header with responsive breakpoints

### Changed
- All 5 hospital pages (`dashboard.html`, `new-visit.html`, `patient-list.html`, `patient-profile.html`, `appointments.html`) — added `<div id="hospitalNav">` + hospital-nav.js for consistent cross-page navigation

### Documentation
- `structure.md` — added `components/` and `js/` directories under hospital module
- `README.md` — updated hospital file tree with new files
- `SRS-Hospital.md` — added navigation section and updated file structure
- `CHANGELOG.md` — added this entry

---

## v1.5.0 — 2026-07-06 — Hospital management module & medical master data pipeline

### Added
- `frontend/app/hospital/` — Full hospital management UI: dashboard, 7-step OPD visit form (`new-visit.html`), patient list with search/pagination, patient profile with visit history, appointment calendar with modal booking
- `backend/modules/hospital/` — Database schema (18 OPD transaction tables), seed data (22 departments, 12 doctors, ~90 symptoms, billing rate cards), RLS policies
- `backend/import/` — Complete ETL pipeline for medical master data: CDCI (186K+ drugs, brands, generics) and LOINC (102K+ lab tests) → filter scripts → SQL DDL → batch import → verification
- `supabase/functions/hospital-patients/` — Edge function for patient CRUD (GET by ID, paginated search, POST create)
- `supabase/functions/hospital-masters/` — Edge function for master data lookups (medicines, investigations, symptoms, diagnoses, doctors, departments)
- `supabase/functions/hospital-dashboard/` — Edge function for dashboard stats aggregation
- `docs/SRS-Hospital.md` — Comprehensive software requirements specification for the hospital module

### Documentation
- `structure.md` — updated file tree with hospital frontend, backend modules, import pipeline, edge functions, and SRS document
- `README.md` — updated file tree, moved hospital from Planned to Implemented, added medical data pipeline
- `CHANGELOG.md` — added this entry

---

## v1.4.0 — 2026-07-06 — Documentation sync with actual filesystem

### Documentation
- `structure.md` — complete rewrite to match actual filesystem:
  - Added missing root files: `.env.example`, `complaint.json`, `Projects/`, `VScode/`
  - Added `frontend/pages/portfolio.html`, `privacy.html`, `terms.html`
  - Added `frontend/pages/blog/` and `frontend/pages/portfolio/` (empty dirs)
  - Added `frontend/app/profile.html`, `admin/` (users.html, audit.html)
  - Added `frontend/app/hospital/`, `society/`, `future-apps/`, `ticket-manager/` (placeholder dirs)
  - Added `frontend/shared/css/blog-sidebar.css`
  - Added `frontend/shared/js/blog-sidebar.js`
  - Added `frontend/shared/assets/img/SocCal01.png` through `SocCal04.png`
  - Added `backend/schema/admin-rls-policy.sql`
  - Added `supabase/config.toml`, `supabase/.gitignore`, `supabase/.temp/`
  - Updated blog post count from ~20 to 29
  - Updated _redirects section with `/privacy`, `/terms`, `/portfolio`, `/app/admin`, `/favicon.ico`
  - Added Admin Module section to Key Files
  - Added Future Module placeholders section
- `README.md` — updated file tree, added privacy/terms/portfolio pages, admin module, profile page, blog count, Supabase config, Future/, Projects/, VScode/
- `CHANGELOG.md` — added this entry

---

## v1.3.0 — 2026-07-03 — Auth fixes, header reorder, sign-out redirect, favicon

### Fixed
- `frontend/config/supabase.js` — Corrected global variable name from `supabaseClient` to `supabase` (CDN exposes `supabase`, not `supabaseClient`); SUPABASE was always null
- `frontend/app/auth/callback.html` — Fixed broken redirect logic: `type === 'recovery' || data?.session` always sent logged-in users to `/reset-password` regardless of type
- `frontend/app/auth/register.html` — Auto-redirect to `/dashboard` when session exists immediately (email confirmations disabled)
- `frontend/shared/js/auth.js` — Redirect to homepage (`/`) on sign-out instead of `/login` (no SIGN IN link in header)
- `backend/schema/auth-trigger.sql` — Created `users_profile` table, trigger function, and RLS policies on Supabase project

### Changed
- `frontend/shared/components/header.html` — Desktop nav reordered: EXPERTISE → PORTFOLIO → BLOG → ABOUT → CONTACT; SIGN IN link replaced with hidden DASHBOARD link (shown only when session exists)
- `frontend/shared/components/footer.html` — Added Dashboard link to Quick Links alongside Login
- `frontend/shared/js/headerfooter.js` — `updateAuthNavLink` now shows/hides the dashboard item instead of toggling SIGN IN ↔ DASHBOARD
- `frontend/_redirects` — Added `/favicon.ico` → `/shared/assets/img/favicon.png` redirect

### Documentation
- `CHANGELOG.md` — added this entry

---

## v1.2.0 — 2026-07-03 — Supabase Auth system with login, register, password reset, and dashboard

### Added
- `frontend/config/supabase.js` — Supabase client initialization with anon key
- `frontend/shared/js/auth.js` — Auth module: signIn, signUp, signOut, resetPassword, getUser, getUserRole, requireAuth, onAuthChange
- `frontend/shared/css/auth.css` — Auth page styles (cards, forms, alerts, spinners, password toggle)
- `frontend/app/auth/login.html` — Email/password login with redirect support
- `frontend/app/auth/register.html` — Registration with name, email, phone, password (min 6 chars), terms checkbox
- `frontend/app/auth/reset-password.html` — Two-step: request reset link → set new password
- `frontend/app/auth/callback.html` — Handles Supabase Auth redirects (email confirmation, password reset)
- `frontend/app/auth/SETUP.md` — Auth system setup guide
- `frontend/app/dashboard.html` — Post-login dashboard with user profile avatar, role badge, module cards, logout
- `backend/schema/auth-trigger.sql` — PostgreSQL trigger to auto-create `users_profile` on auth signup

### Changed
- `frontend/_redirects` — Added `/login`, `/register`, `/reset-password`, `/auth/callback`, `/dashboard` clean URLs
- `frontend/shared/components/header.html` — Added dynamic SIGN IN / DASHBOARD nav link (desktop + mobile)
- `frontend/shared/js/headerfooter.js` — Nav link dynamically updates based on Supabase session in localStorage
- `frontend/shared/js/config.js` — Default domain changed to `aartitechservices.pages.dev` (permanent), mk9.in kept as `primaryDomain`
- `frontend/services/blogService.js` — Switched from ES module import to global `SUPABASE` object
- `frontend/app/seniority/seniority-list.html` — Added auth guard (redirects to `/login` if unauthenticated)
- `frontend/app/seniority/seniority-management.html` — Added auth guard
- `supabase/config.toml` — site_url set to `aartitechservices.pages.dev`, redirect URLs configured for both domains + localhost

### Documentation
- `structure.md` — added auth files, updated architecture, redirects, diagram, and config sections
- `CHANGELOG.md` — added this entry

---

## v1.1.0 — 2026-07-03 — Static blog engine with 20 posts

### Added
- `frontend/data/posts.json` — All 20 blog post entries with metadata (title, date, category, tags, excerpt, image)
- `frontend/shared/js/blog.js` — Blog engine: fetches JSON, renders cards, search, category/tag filtering, pagination
- `frontend/pages/blog.html` — Dynamic blog listing replacing hardcoded articles; contact form moved inside `<main>`
- `frontend/blog/posts/_template.html` — Duplicatable post template
- 20 full HTML blog posts across 10 categories (Web Development, Full Stack Development, Digital Marketing & SEO, Photography & Branding, Electrical Services, Automotive Services, AI & Technology, Training & Workshops, Learning & Innovation, Others)

### Changed
- `frontend/_redirects` — `/blog` → `/pages/blog.html` + `/blog/:slug` → `/blog/posts/:slug.html` for all 20 posts
- Category "Business Automation" renamed to "Full Stack Development"
- Removed categories "IoT & Engineering", "Cloud & DevOps", "Tips & Tutorials"
- Added categories "Learning & Innovation", "Others"
- "Hands-On Electronics Workshop" → "Hands on Arduino ESP32 Workshop" with new content

### Documentation
- `README.md` — added `data/`, `blog/posts/`, `blog.js` to file tree; updated Features with static JSON-driven blog
- `structure.md` — added `data/`, `blog/posts/`, `blog.js` to file tree; added blog redirect rules
- `CHANGELOG.md` — added this entry

---

## v1.0.12 — 2026-06-28 — Digital engineering page overhaul

### Changed
- `frontend/pages/expertise/digital-engineering.html` — major content and design update:
  - Renamed "Starter Website" → "Static Website" card with updated features and description
  - Added discount pricing display (strikethrough original price + sale price) for Static, Business, and Web App plans
  - Enterprise plan now shows ₹49,999 / onwards instead of "Custom Quote"
  - Converted all plan feature lists to inline paragraph descriptions for consistent layout
  - Added horizontal divider line below prices
  - Icon and plan name now on same line via `.plan-header` flex container
  - All plan names uppercased and bold
  - Old prices colored red, current prices in site accent blue with increased font size
  - All card buttons unified to site accent blue
  - Card hover glow effect with blue border + shadow
  - Scroll-triggered fade-in animation via IntersectionObserver
  - Price hover scale animation
  - Removed duplicate hero/subtitle content
  - Capitalized all page headings

### Documentation
- `CHANGELOG.md` — added this entry

---

## v1.0.10 — 2026-06-28 — Header cleanup & expanded engineering branches

### Changed
- Desktop nav: flattened Learning & Innovation sub-dropdown to plain link (tabs only accessible via page)
- Desktop nav: removed Login link (already in footer)
- Mobile nav: removed 3 indented sub-links (Projects, Industrial Training, Technical Workshops)
- Mobile nav: removed Login link
- Learning & Innovation: expanded Engineering Branches from 3 (Electrical, Electronics, Instrumentation) to 4 (Electrical, Electronics, Computer & AI, Mechanical) across all 3 tabs

### Documentation
- `structure.md` — updated Navigation section
- `CHANGELOG.md` — added this entry

---

## v1.0.9 — 2026-06-28 — Added engineering branches to Projects, Training, Workshops tabs

### Changed
- Each tab (Projects, Industrial Training, Technical Workshops) now has an "Engineering Branches" section with 3 discipline-specific cards

---

## v1.0.8 — 2026-06-28 — Moved tab CTAs above contact form

### Changed
- Dynamic CTA moved above the contact form in each tab; updates text on tab switch

---

## v1.0.7 — 2026-06-28 — Tabbed Learning & Innovation page

### Changed
- Consolidated Projects, Industrial Training, Technical Workshops into a single tabbed page at `/expertise/learning-innovation`
- Added animated tab switching (fade + slide) with URL hash support (`#projects`, `#training`, `#workshops`)
- Old standalone pages redirected via 301 to hash anchors
- Header nav links updated to point to hash URLs

### Removed
- `frontend/pages/expertise/projects.html`
- `frontend/pages/expertise/training.html`
- `frontend/pages/expertise/workshop.html`

### Documentation
- `README.md` — updated file tree
- `structure.md` — updated file tree and navigation section
- `CHANGELOG.md` — added this entry

---

## v1.0.6 — 2026-06-28 — Animated nested dropdown navigation

### Changed
- Upgraded Expertise dropdown with animated nested sub-menus
- Learning & Innovation now shows Projects, Industrial Training, Technical Workshops in a slide-in sub-dropdown
- Strategic Partners now shows Graphics, Electrical, Automotive in a slide-in sub-dropdown
- Main dropdown uses smooth fade+slide animation instead of abrupt show/hide
- Dark mode styles added for sub-dropdown panels

### Documentation
- `README.md` — updated project structure to reflect flattened `frontend/` layout and new pages
- `structure.md` — added sub-items for Strategic Partners in Navigation section
- `CHANGELOG.md` — added this entry

---

## v1.0.2 — 2026-06-27 — Removed GitHub remote & flattened site structure

### Changed
- Removed GitHub remote origin — local-only repo
- Flattened `frontend/` structure: removed `site/` subdirectory
- `frontend/site/index.html` → `frontend/index.html`
- `frontend/site/pages/` → `frontend/pages/`
- Updated `frontend/_redirects` — all `/site/` destination paths removed
- Updated 11 HTML files — `fetch("/site/pages/contactform.html")` → `fetch("/pages/contactform.html")`

### Documentation
- `structure.md` — removed `site/` nesting from file tree, diagram, and redirects docs; removed GitHub details
- `CHANGELOG.md` — added this entry

---

## v1.0.1 — 2026-06-27 — MIME type fix & structure sync

### Fixed
- `frontend/_redirects` — removed `/shared/*` identity rewrite that caused JS/CSS to be served as `text/html`, blocking them via `X-Content-Type-Options: nosniff`
- `frontend/_redirects` — removed `/app/*` identity rewrite (same MIME type risk for future assets under `/app/`)

### Documentation
- `structure.md` — rewritten to match actual filesystem (removed non-existent files/dirs, fixed paths)
- `CHANGELOG.md` — added this entry
- `README.md` — updated project structure tree to match actual filesystem

---

## v1.0.0 — 2026-06-27 — new code written for old website update

### Added

### Removed 

### Changed

### Fixed

### Documentation
- `README.md` — updated structure, features, and getting started to reflect centralized config
- `structure.md` — added config.js, seo-injector.js to file tree; new Site Configuration section
- `docs/DEPLOYMENT.md` — created with deployment steps and config notes
- `docs/ROADMAP.md` — created with completed/in-progress/planned items
