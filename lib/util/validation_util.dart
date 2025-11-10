class ValidationUtil {
  static String? email(String? val) {
    if (val == null || val.trim().isEmpty || !val.contains("@")) {
      return "Please enter a valid email address";
    }
    return null;
  }

  static String? password(String? val) {
    if (val == null || val.trim().length < 6) {
      return "Password must be at laest 6 characters long";
    }
    return null;
  }

  static String? username(String? val) {
    if (val == null || val.trim().length < 4) {
      return "username must be at least 4 characters long";
    }
    return null;
  }
}
