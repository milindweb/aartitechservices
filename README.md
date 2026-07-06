# AartiTechServices (MK9)

Multi-service business portal with static HTML/CSS/JS frontend, Supabase backend, and Cloudflare Pages hosting.

## Tech Stack

- **Frontend:** HTML5, CSS3 (custom properties, dark/light mode), JavaScript (ES6 modules)
- **Hosting:** Cloudflare Pages (static, no build step)
- **Backend:** Supabase Edge Functions (TypeScript/Deno)
- **Database:** Supabase PostgreSQL with Row Level Security
- **Auth:** Supabase Auth (email/password, magic link, OAuth)
- **Storage:** Supabase Storage
- **CDN:** Font Awesome 6.4, PapaParse, SheetJS, jsPDF, jsPDF-AutoTable

## Project Structure

```
├── frontend/              # Static website (Cloudflare Pages)
│   ├── _headers           # Cloudflare headers & caching
│   ├── _redirects         # Cloudflare URL rewrites
│   ├── .htaccess          # Apache security & caching
│   ├── 404.html           # Custom 404 page
│   ├── robots.txt         # Crawler rules
│   ├── sitemap.xml        # XML sitemap
│   ├── index.html         # Homepage (SEO indexed)
│   ├── data/              # Static data files
│   │   └── posts.json     # Blog posts data (JSON-driven)
│   ├── blog/              # Blog module
│   │   └── posts/         # 29 individual blog post HTML files
│   ├── pages/             # SEO-indexed public pages
│   │   ├── about.html     # About page
│   │   ├── contact.html   # Contact page
│   │   ├── blog.html      # Blog listing (dynamic, JS-driven)
│   │   ├── portfolio.html # Portfolio page
│   │   ├── links.html     # Links page
│   │   ├── privacy.html   # Privacy policy
│   │   ├── terms.html     # Terms of service
│   │   ├── expertise/     # Service pages
│   │   │   ├── digital-engineering.html
│   │   │   ├── freelance-digital-marketing-seo.html
│   │   │   └── learning-innovation.html
│   │   └── partners/      # Partner pages
│   │       ├── index.html
│   │       ├── graphics.html
│   │       ├── electrical.html
│   │       └── automotive.html
│   ├── app/               # Login-required (noindex)
│   │   ├── auth/          # Login, register, password-reset, callback pages
│   │   ├── admin/         # Admin: user management, audit logs
│   │   ├── dashboard.html # Post-login dashboard
│   │   ├── profile.html   # User profile
│   │   ├── seniority/     # Seniority management
│   │   ├── hospital/      # (placeholder)
│   │   ├── society/       # (placeholder)
│   │   ├── future-apps/   # (placeholder)
│   │   └── ticket-manager/ # (placeholder)
│   ├── shared/            # Shared components, CSS, JS, assets
│   │   ├── components/    # header.html, footer.html
│   │   ├── css/           # style.css, headerfooter.css, auth.css, blog-sidebar.css, nadstyle.css
│   │   ├── js/            # config.js, seo-injector.js, headerfooter.js, auth.js, blog.js, blog-sidebar.js, form-handler.js
│   │   └── assets/img/    # Logo, favicon, OG image, icons, social calendar images
│   ├── config/            # Runtime config
│   │   └── supabase.js    # Supabase client initialization
│   └── services/          # API service classes
├── backend/               # Database schema & configuration
│   ├── schema/            # schema.sql, rls-policies.sql, auth-trigger.sql, admin-rls-policy.sql, database-design.md
│   ├── seed/              # seed.sql
│   └── modules/           # Module-specific schema (blog/)
├── supabase/
│   ├── config.toml        # Supabase project config
│   └── functions/         # Edge Functions
│       └── blog-posts/    # Blog CRUD API
├── docs/                  # DEPLOYMENT.md, ROADMAP.md
├── Future/                # Module placeholders (CRM, ERP, HRMS, Inventory, School)
└── VScode/                # (empty)
```

## Features

### Implemented
- **Homepage** with hero, service cards, premium services, team section
- **6 Service Pages:** Digital Marketing & SEO, Web & Software Development, College Projects & Training, Graphics/Photography & Branding, Electrical, Automotive
- **Centralized Configuration** (`shared/js/config.js`) — brand name, domain, contact, social links in one file
- **Dynamic SEO Injection** — titles, meta, OG/Twitter tags, JSON-LD generated from config at runtime
- **Blog System** — static JSON-driven engine with 29 posts, search, category/tag filtering, pagination, and clean `/blog/:slug` URLs
- **Seniority Management** module with CSV/Excel/PDF export
- **Authentication** — Supabase Auth with email/password login, registration, password reset, auth callback handling, and session management
- **User Dashboard** — post-login landing page with user profile info, role badge, and module navigation
- **User Profile** page
- **Admin Module** — user management and audit logs
- **Auth Guard** — protected pages redirect unauthenticated users to login
- **Auth-Aware Navigation** — header shows DASHBOARD link only when logged in; no SIGN IN link (accessible via footer)
- **Contact Form** integrated with Google Apps Script, dynamically loaded per-page (no labels, placeholders only)
- **Shared component classes** (`p-*`) in `style.css` — consistent dark gradient hero, white cards, blue gradient icons across all service pages
- **Dark/Light Theme** toggle with localStorage persistence
- **Responsive Design** with mobile hamburger navigation
- **SEO:** robots.txt, sitemap.xml, favicon, dynamic Open Graph / JSON-LD

### Planned
- Full blog CRUD with comments
- Hospital management (departments, doctors, appointments)
- Society management (groups, members, events)
- Ticket manager
- Additional Supabase Edge Functions (comments, hospital, society, etc.)
- Automated sitemap generation

## Getting Started

1. Clone the repo
2. Edit `frontend/shared/js/config.js` with your brand name, domain, and contact info
3. Configure `frontend/config/supabase.js` with your Supabase project URL and anon key
4. Configure `backend/.env.example` with your Supabase project credentials
5. Run `backend/schema/schema.sql` and `backend/schema/auth-trigger.sql` against your Supabase database
6. Deploy the `frontend/` directory to Cloudflare Pages
7. Deploy Edge Functions from `supabase/functions/`
8. Set `site_url` and redirect URLs in Supabase Auth settings
