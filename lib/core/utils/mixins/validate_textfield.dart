mixin ValidationMixin {
  String validateEmail(String value) {
    if (value.isEmpty) {
      return 'Please enter an email address.';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
      return 'Please enter a valid email address.';
    } else {
      return "";
    }
  }

  String validatePassword(String value) {
    if (value.isEmpty) {
      return 'Please enter a password.';
    } else if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    } else {
      return "";
    }
  }

  String validateField(String value) {
    if (value.isEmpty) {
      return 'Please enter a value.';
    } else if (RegExp(r'[0-9]').hasMatch(value)) {
      return 'Input should not contain digits.';
    } else {
      return "";
    }
  }

  String simpleValidation(String value) {
    if (value.isEmpty) {
      return 'Please enter user name.';
    } else {
      return "";
    }
  }

  String phoneValidation(String value) {
    if (value.isEmpty) {
      return 'Please enter phone number.';
    } else {
      return "";
    }
  }
}