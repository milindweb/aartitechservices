# Changelog

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
