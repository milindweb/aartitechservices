const SUPABASE_CONFIG = {
  url: 'https://ywnqqvebqzsohlwbtpiz.supabase.co',
  anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Inl3bnFxdmVicXpzb2hsd2J0cGl6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODMwODQ3NDIsImV4cCI6MjA5ODY2MDc0Mn0.1CJ2njZ2rr0nSK1M0lu2KQ5JqEujflRBMK6p9SIjvFQ',
};

let SUPABASE = null;

function initSupabase() {
  if (SUPABASE) return SUPABASE;
  if (typeof supabaseClient !== 'undefined') {
    SUPABASE = supabaseClient.createClient(SUPABASE_CONFIG.url, SUPABASE_CONFIG.anonKey, {
      auth: { autoRefreshToken: true, persistSession: true, detectSessionInUrl: true },
    });
    return SUPABASE;
  }
  console.error('Supabase JS client not loaded. Include the CDN script.');
  return null;
}

if (typeof supabaseClient !== 'undefined') {
  SUPABASE = initSupabase();
}
