import 'package:shared_preferences/shared_preferences.dart';

import '../my_account/user_dto.dart';


class SharedPreferencesHelper {
  static final String onboardingVisited = 'onboarding_visited';
  static final String token = 'token';
  static final String mobile = 'mobile';
  static final String email = 'email';
  static final String firstName = 'firstName';
  static final String lastName = 'lastName';
  static final String doesHoldMembership = 'doesHoldMembership';
  static final String isEmailVerified = 'isEmailVerified';
  static final String cart = 'cart';

  static Future<String> getValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key) ?? '';
  }

  static Future<UserDto> getUserDetails() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return UserDto(
      firstName: prefs.getString(firstName) ?? '',
      lastName: prefs.getString(lastName) ?? '',
      mobile: prefs.getString(mobile) ?? '',
      email: prefs.getString(email) ?? '',
      doesHoldMembership: prefs.getBool(doesHoldMembership) ?? false,
      isEmailVerified: prefs.getBool(isEmailVerified) ?? false,
      token: prefs.getString(token) ?? '',
    );
  }

  static Future<bool> setValue(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(key, value);
  }

  static Future<bool> removeValue(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.remove(key);
  }

  static Future<void> setValues(Map<String, String> map) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    map.forEach((key, value) {
      prefs.setString(key, value);
    });
  }

  static Future<void> setMembershipFlag(bool membershipFlag) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(SharedPreferencesHelper.doesHoldMembership, membershipFlag);
  }

  static Future<void> setIsEmailVerified(bool emailVerifiedFlag) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(SharedPreferencesHelper.isEmailVerified, emailVerifiedFlag);
  }
}
