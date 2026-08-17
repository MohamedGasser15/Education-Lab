class StringUtils {
  static bool isNullOrEmpty(String? value) => value == null || value.isEmpty;

  static bool isNullOrBlank(String? value) =>
      value == null || value.trim().isEmpty;

  static String? nullIfEmpty(String? value) =>
      isNullOrEmpty(value) ? null : value;

  static String capitalize(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  static String truncate(String value, {int maxLength = 50}) {
    if (value.length <= maxLength) return value;
    return '${value.substring(0, maxLength)}...';
  }

  static bool isValidEmail(String value) =>
      RegExp(r'^[\w\.-]+@[\w\.-]+\.\w{2,}$').hasMatch(value);

  static String maskEmail(String email) {
    final parts = email.split('@');
    if (parts.length != 2) return email;
    final local = parts[0];
    if (local.length <= 2) return '${local[0]}*@${parts[1]}';
    return '${local.substring(0, 2)}${'*' * (local.length - 2)}@${parts[1]}';
  }
}