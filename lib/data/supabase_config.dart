/// URL e chave anon do projeto "constancia" no Supabase.
///
/// A anon key é pública por design — foi feita pra ser embutida no app
/// cliente (fica visível pra qualquer um que inspecionar o app de
/// qualquer forma). O controle de acesso real fica nas políticas de
/// Row Level Security configuradas no banco (veja supabase/schema.sql).
/// Quem NUNCA deve entrar no app é a service_role key.
class SupabaseConfig {
  SupabaseConfig._();

  static const String url = 'https://bvjocbinhtczyirhmkpy.supabase.co';
  static const String anonKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ2am9jYmluaHRjenlpcmhta3B5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3OTA5NzgyMzcsImV4cCI6MjEwNjU1NDIzN30.lGQQLv_nyShhnngnRkMHEkKSTIi8MnbEyozH7uixCBQ';
}
