class Validators {
  static String? requiredInt(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final n = int.tryParse(v);
    if (n == null) return 'Enter a number';
    if (n < 0) return 'Must be ≥ 0';
    return null;
  }

  static String? requiredIntAllowNeg(String? v) {
    if (v == null || v.trim().isEmpty) return 'Required';
    final n = int.tryParse(v);
    if (n == null) return 'Enter a number';
    return null;
  }
}
