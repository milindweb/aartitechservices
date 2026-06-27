# Changelog

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
