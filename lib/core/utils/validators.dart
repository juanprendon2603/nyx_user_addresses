class Validators {
  static String? requiredText(String? v, {String field = 'Este campo'}) {
    if (v == null || v.trim().isEmpty) return '$field es obligatorio';
    return null;
  }

  static String? dateNotNull(DateTime? v, {String field = 'Fecha'}) {
    if (v == null) return '$field es obligatoria';
    return null;
  }
}
