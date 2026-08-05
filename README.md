# AartiTechServices

Business and portfolio website for Aarti Tech Services — a clean, static HTML/CSS/JS site hosted on Cloudflare Pages. No backend, no database, no auth.

## Tech Stack

- **Frontend:** HTML5, CSS3 (custom properties, dark/light mode), JavaScript (ES6 modules)
- **Hosting:** Cloudflare Pages (static, no build step)
- **Fonts:** Self-hosted Font Awesome 6.4 + Bootstrap Icons 1.10.5
- **Contact Form:** Google Apps Script
- **Blog:** Static JSON-driven engine (search, category/tag filtering, pagination, clean `/blog/:slug` URLs)

## Project Structure

```
├── index.html           Homepage
├── about.html           About page
├── blog.html            Blog listing (JS-driven)
├── contact.html         Contact page
├── contactform.html     Contact form partial
├── links.html           Links page
├── portfolio.html       Portfolio page
├── privacy.html         Privacy policy
├── terms.html           Terms of service
├── 404.html             Custom 404 page
├── expertise/           Service pages (digital engineering, marketing/SEO, learning & innovation)
├── partners/            Partner pages (graphics, electrical, automotive)
├── blog/posts/          29 blog post HTML files
├── css/                 Stylesheets
├── js/                  Scripts (config, seo-injector, header/footer, blog, forms)
├── data/                Static data (posts.json)
├── img/                 Images
├── fonts/               Self-hosted icon fonts
├── components/          Header & footer partials (loaded at runtime)
├── archive/             Archived code (auth, app modules, backend, hospital) — not deployed
├── docs/                Deployment & roadmap
├── _headers             Cloudflare security headers & caching
├── _redirects           Cloudflare URL rewrites
├── robots.txt           Crawler rules
└── sitemap.xml          XML sitemap
```

## Features

- **Homepage** with hero, service cards, premium services, team section
- **6 Service Pages** (3 expertise: Digital Engineering, Digital Marketing & SEO, Learning & Innovation; 3 partners: Graphics/Photography & Branding, Electrical, Automotive)
- **Centralized Configuration** (`js/config.js`) — brand name, domain, contact, social links in one file
- **Dynamic SEO Injection** — titles, meta, OG/Twitter tags, JSON-LD generated from config at runtime
- **Blog System** — static JSON-driven engine with 29 posts, search, category/tag filtering, pagination, clean `/blog/:slug` URLs
- **Contact Form** integrated with Google Apps Script, dynamically loaded per-page
- **Dark/Light Theme** toggle with localStorage persistence
- **Responsive Design** with mobile hamburger navigation
- **SEO:** robots.txt, sitemap.xml, favicon, dynamic Open Graph / JSON-LD
- **Self-hosted fonts** — no external CDN dependencies

## Getting Started

1. Clone the repo
2. Edit `js/config.js` with your brand name, domain, and contact info
3. Deploy the repo root to Cloudflare Pages (static, no build step)

## Deployment

See [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md).
