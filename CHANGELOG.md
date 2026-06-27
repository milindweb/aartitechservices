# Changelog

## v1.0.11 — 2026-06-28 — Complete homepage redesign

### Changed
- `index.html` — completely rewritten with 10 new sections per provided content:
  - Hero with updated headline, mission statement, and CTA
  - "Digital Solutions That Drive Business Growth" intro
  - "Our Expertise" with 4 detailed service cards (Digital Engineering, Digital Marketing & SEO, Learning & Innovation, Strategic Partners)
  - "Why Choose Aarti Tech Services" feature grid
  - "Featured Portfolio" category list
  - "Latest Insights" blog topics
  - "Let's Build & Grow Together" final CTA section
  - Stats bar, contact form, and contact intro retained
- WhatsApp CTA buttons use dynamic `SITE_CONFIG.social.whatsapp` from config.js

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
