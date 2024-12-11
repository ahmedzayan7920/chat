import 'app_strings.dart';

abstract class AppValidator {
  /* 
    Password validation
  */
  static const int _minLength = 8;

  static final RegExp _lowercaseRegExp = RegExp(r'[a-z]');
  static final RegExp _uppercaseRegExp = RegExp(r'[A-Z]');
  static final RegExp _specialCharRegExp = RegExp(r'[!@#\$&*~]');
  static final RegExp _numberRegExp = RegExp(r'[0-9]');

  static bool _hasMinLength(String password) => password.length >= _minLength;
  static bool _hasLowercase(String password) =>
      _lowercaseRegExp.hasMatch(password);
  static bool _hasUppercase(String password) =>
      _uppercaseRegExp.hasMatch(password);
  static bool _hasSpecialChar(String password) =>
      _specialCharRegExp.hasMatch(password);
  static bool _hasNumber(String password) => _numberRegExp.hasMatch(password);

  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return AppStrings.passwordRequired;
    }
    if (!_hasNumber(password)) return AppStrings.passwordOneNumber;
    if (!_hasLowercase(password)) return AppStrings.passwordOneLowerCase;
    if (!_hasUppercase(password)) return AppStrings.passwordOneUpperCase;
    if (!_hasSpecialChar(password)) return AppStrings.passwordOneSpecialChar;
    if (!_hasMinLength(password)) return AppStrings.passwordMinLength;
    return null;
  }

  /* 
    Email validation
  */
  static final RegExp _emailRegExp = RegExp(
    r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+',
  );

  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) return AppStrings.emailRequired;
    if (!_emailRegExp.hasMatch(email)) return AppStrings.emailInvalid;
    return null;
  }

  /* 
    Name validation
  */
  static final RegExp _nameRegExp = RegExp(r"^[a-zA-Z\s]+$");
  static const int _maxNameLength = 50;

  static String? validateName(String? name) {
    if (name == null || name.isEmpty) {
      return AppStrings.nameRequired;
    }
    if (!_nameRegExp.hasMatch(name)) {
      return AppStrings.nameInvalid;
    }
    if (name.length > _maxNameLength) {
      return AppStrings.nameTooLong;
    }
    return null;
  }

  /* 
    Confirm password validation
  */
  static String? validateConfirmPassword(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return AppStrings.confirmPasswordRequired;
    }
    if (password != confirmPassword) {
      return AppStrings.passwordsDoNotMatch;
    }
    return null;
  }

  /* 
    Field validation
  */

  static String? validateField(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return "$fieldName ${AppStrings.isRequired}";
    }
    return null;
  }
}
