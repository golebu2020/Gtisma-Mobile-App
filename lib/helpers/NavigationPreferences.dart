import 'package:shared_preferences/shared_preferences.dart';

class NavigationPreferences {
  static final NavigationPreferences _instance = NavigationPreferences._ctor();

  factory NavigationPreferences(){
    return _instance;
  }

  NavigationPreferences._ctor();

  SharedPreferences _prefs;

  init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  //Store Intro and retrieve Intro screen
  Future storeIntroScreen(bool title) {
    return _prefs.setBool('introScreen_KEY', title);
  }

  bool retrieveIntroScreen() {
    return _prefs.getBool('introScreen_KEY');
  }

  //Store and retrive selectLanguage screen
  Future storeSelectLanguage(bool title) {
    return _prefs.setBool('selectLanguage_KEY', title);
  }

  bool retrieveSelectLanguage() {
    return _prefs.getBool('selectLanguage_KEY');
  }

  //Store Intro and retrieve Intro screen
  Future storeLoginScreen(bool title) {
    return _prefs.setBool('loginScreen_KEY', title);
  }

  bool retrieveLoginScreen() {
    return _prefs.getBool('loginScreen_KEY');
  }

  //Store Intro and retrieve Intro screen
  Future storeSignupScreen(bool title) {
    return _prefs.setBool('signUp_KEY', title);
  }

  bool retrieveSignupScreen() {
    return _prefs.getBool('signUp_KEY');
  }
}

