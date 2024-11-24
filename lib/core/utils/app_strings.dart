abstract class AppStrings {
  static const emptyString = '';
  static const signUpFailed = 'Sign up failed.';
  static const loginFailed = 'Login failed.';
  static const userNotFound = 'User not found in database.';
  static const noTitle = 'No Title';
  static const noBody = 'No Body';

  static String get nameHint => "Name";
  static String get emailHint => "Email";
  static String get passwordHint => "Password";
  static String get confirmPasswordHint => "Confirm Password";

  static String get emailRequired => "Email is required";
  static String get emailInvalid => "Enter a valid email";
  static String get passwordRequired => "Password is required";
  static String get passwordMinLength => "Must be at least 8 characters";
  static String get passwordOneLowerCase => "Must contain a lowercase letter";
  static String get passwordOneUpperCase => "Must contain an uppercase letter";
  static String get passwordOneSpecialChar => "Must contain a special character";
  static String get passwordOneNumber => "Must contain at least one number";
  
  static String get welcomeBack => "Welcome back!";
  static String get login => "Login";
  static String get noAccount => "Don't have an account?";
  static String get registerNow => "Register Now";

  static String get registerStart => "Let's get started!";
  static String get register => "Register";
  static String get alreadyHaveAccount => "Already have an account?";
  static String get loginNow => "Login Now";


  static const String nameRequired = "Name is required.";
  static const String nameInvalid = "Name can only contain letters and spaces.";
  static const String nameTooLong = "Name must not exceed 50 characters.";

  static const String confirmPasswordRequired = "Please confirm your password.";
  static const String passwordsDoNotMatch = "Passwords do not match.";
}