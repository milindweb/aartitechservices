# Auth System Setup Guide

## Prerequisites
- A Supabase project (free tier works)
- Your Supabase project URL and anon key

---

## Step 1: Update Supabase Config

Edit `frontend/config/supabase.js` and replace the placeholders:

```js
url: 'https://YOUR_PROJECT_ID.supabase.co',
anonKey: 'your-anon-key-here',
```

Get these from: Supabase Dashboard → Settings → API

---

## Step 2: Enable Supabase Auth

In Supabase Dashboard → Authentication → Settings:
- **Email Auth**: Enabled by default
- **Confirm email**: Your choice (recommended: ON for production, OFF for testing)
- **Redirect URL**: Add `https://yourdomain.com/auth/callback` (and `http://localhost:PORT/auth/callback` for local)

---

## Step 3: Run Database Trigger

In Supabase Dashboard → SQL Editor, run the contents of:
```
backend/schema/auth-trigger.sql
```

This auto-creates a `users_profile` row when someone signs up.

---

## Step 4: Deploy

Upload all files to Cloudflare Pages as-is. The redirects in `_redirects` handle clean URLs like `/login`, `/register`, etc.

---

## Testing Locally

You can test locally with any static server (e.g. `npx serve frontend/` or VS Code Live Server). Make sure to add `http://localhost:3000/auth/callback` to Supabase redirect URLs.

---

## First User

1. Go to `/register` and create an account
2. If email confirmation is ON, check email and click the link
3. Go to `/login` and sign in
4. You'll land on `/dashboard`
