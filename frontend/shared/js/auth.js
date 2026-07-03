const AUTH = {
  _listeners: [],

  async getSession() {
    try {
      const { data, error } = await SUPABASE.auth.getSession();
      if (error) throw error;
      return data.session;
    } catch (err) {
      console.error('getSession error:', err);
      return null;
    }
  },

  async getUser() {
    try {
      const { data: authData, error: authError } = await SUPABASE.auth.getUser();
      if (authError || !authData?.user) return null;
      const { data: profile } = await SUPABASE
        .from('users_profile')
        .select('*')
        .eq('id', authData.user.id)
        .maybeSingle();
      return { ...authData.user, profile: profile || null };
    } catch (err) {
      console.error('getUser error:', err);
      return null;
    }
  },

  async signIn(email, password) {
    const { data, error } = await SUPABASE.auth.signInWithPassword({
      email: email.trim().toLowerCase(),
      password,
    });
    if (error) throw error;
    return data;
  },

  async signInWithGoogle(redirect) {
    var dest = `${window.location.origin}/auth/callback`;
    if (redirect) dest += '?redirect=' + encodeURIComponent(redirect);
    const { data, error } = await SUPABASE.auth.signInWithOAuth({
      provider: 'google',
      options: { redirectTo: dest },
    });
    if (error) throw error;
    return data;
  },

  async signUp(email, password, metadata = {}) {
    const { data, error } = await SUPABASE.auth.signUp({
      email: email.trim().toLowerCase(),
      password,
      options: {
        data: { full_name: metadata.full_name || '', phone: metadata.phone || '' },
      },
    });
    if (error) throw error;
    return data;
  },

  async signOut() {
    const { error } = await SUPABASE.auth.signOut();
    if (error) throw error;
    window.location.href = '/';
  },

  async resetPassword(email) {
    const { data, error } = await SUPABASE.auth.resetPasswordForEmail(
      email.trim().toLowerCase(),
      { redirectTo: `${window.location.origin}/auth/callback?type=recovery` }
    );
    if (error) throw error;
    return data;
  },

  async updatePassword(newPassword) {
    const { data, error } = await SUPABASE.auth.updateUser({ password: newPassword });
    if (error) throw error;
    return data;
  },

  onAuthChange(callback) {
    const { data: sub } = SUPABASE.auth.onAuthStateChange((event, session) => {
      callback(event, session);
    });
    this._listeners.push(sub);
    return sub;
  },

  async requireAuth() {
    const session = await this.getSession();
    if (!session) {
      const redirect = encodeURIComponent(window.location.pathname + window.location.search);
      window.location.href = `/login?redirect=${redirect}`;
      return null;
    }
    return session;
  },

  async getUserRole() {
    const user = await this.getUser();
    return user?.profile?.role || 'user';
  },

  async hasRole(roles) {
    const role = await this.getUserRole();
    return roles.includes(role);
  },

  cleanup() {
    this._listeners.forEach(s => { if (s?.unsubscribe) s.unsubscribe(); });
    this._listeners = [];
  },
};
