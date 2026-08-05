# Deployment

## Architecture

```
Static site → GitHub → Cloudflare Pages → aartitechservices.pages.dev
```

Pure static HTML/CSS/JS. No backend, no database, no auth. Hosted on Cloudflare Pages with the repo root as the build output.

## Cloudflare Pages

### Build Settings
- **Framework preset:** None (static HTML/CSS/JS)
- **Build command:** None
- **Build output:** `/` (repo root)
- **Root directory:** `/` (repo root)

### Configuration Files
| File | Purpose |
|------|---------|
| `_headers` | Security headers & cache rules |
| `_redirects` | Clean URL rewrites & page consolidation redirects |

### Site Configuration
All branding, domain, contact, and SEO values are centralized in:
- **`js/config.js`** — Change brand name, domain, phone, social links, etc. here
- **`js/seo-injector.js`** — Reads config + per-page PAGE_CONFIG to inject meta tags at runtime

No build step is required — updates to `config.js` take effect immediately on next deploy.

**Note:** `sitemap.xml` and `robots.txt` are static files and must be updated manually when the domain changes.

### Deployment Steps
1. Push changes to the GitHub repository
2. Cloudflare Pages auto-deploys from the configured branch
3. Site is live at the configured domain

## Project Layout

```
├── index.html          Homepage
├── about.html          About page
├── blog.html           Blog listing (static, JSON-driven)
├── contact.html        Contact page
├── portfolio.html      Portfolio
├── css/                Stylesheets
├── js/                 Scripts (config, seo-injector, header/footer, blog, forms)
├── data/               Static data (posts.json)
├── img/                Images
├── fonts/              Self-hosted icon fonts (Font Awesome, Bootstrap Icons)
├── components/         Header & footer partials (loaded at runtime)
├── expertise/          Service pages
├── partners/           Partner pages
└── blog/posts/         Individual blog post HTML files
```
