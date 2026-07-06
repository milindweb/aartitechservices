# Roadmap

## ✅ Completed

### Foundation
- [x] Static HTML/CSS/JS frontend deployed on Cloudflare Pages
- [x] Supabase database schema with RLS policies
- [x] Supabase Auth (email/password, magic link, OAuth)
- [x] Blog Edge Functions (CRUD)
- [x] Centralized site configuration (`config.js`) — brand, domain, contact, social
- [x] Dynamic SEO injection (`seo-injector.js`) — titles, meta, OG/Twitter tags, JSON-LD
- [x] Header/footer driven by config placeholders
- [x] Shared component CSS classes (`p-*`) for consistent service page design

### Pages Launched
- [x] Homepage
- [x] Blog listing page
- [x] Contact page + enquiry form (with privacy/terms/disclaimer/feedback accordions)
- [x] 6 service pages (SEO, Web & Software Dev, Projects & Training, Graphics/Photography & Branding, Electrical, Automotive)

### Hospital Management System
- [x] OPD visit workflow (7-step form with patient, doctor, vitals, clinical, prescription, billing)
- [x] Patient registry with search, pagination, and profile with visit history
- [x] Appointment calendar with modal booking and inline status management
- [x] Medical master data pipeline (CDCI drugs, LOINC lab tests)
- [x] Hospital sub-navigation component (back, home, quick links on every page)

## 🚧 In Progress

### Seniority Management Module
- [ ] Seniority list view with search/filter/export
- [ ] Management dashboard (add/edit/promote)
- [ ] Supabase Edge Functions for data operations

## 📋 Planned

### Modules
- [ ] Blog module (full CRUD, categories, comments)
- [ ] Society Management System
- [ ] Admin Panel

### Infrastructure
- [ ] Subdomain routing (blog.mk9.in, seniority.mk9.in, etc.)
- [ ] CI/CD with GitHub Actions
- [ ] Automated sitemap generation (to replace static sitemap.xml)
- [ ] Environment-specific config (dev/staging/prod)

### Features
- [ ] Dynamic OG image generation
- [ ] Page analytics dashboard
- [ ] Multi-language support
