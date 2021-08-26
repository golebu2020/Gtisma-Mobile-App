import 'package:shared_preferences/shared_preferences.dart';

class UserPreferences{
  static final UserPreferences _instance = UserPreferences._ctor();
  factory UserPreferences(){
    return _instance;
  }

  UserPreferences._ctor();
  SharedPreferences _prefs;

  init() async{
    _prefs = await SharedPreferences.getInstance();
  }
  get data{
    return _prefs.getString('LangS') ?? '';
  }
  Future setData(String value){
    return _prefs.setString('LangS', value);
  }
  Future saveUserToken(String value){
    return _prefs.setString('LangS', value);
  }
  Future saveRegisterStatus(bool value){
    return _prefs.setBool('registered?', value);
  }
  get registerStatus{
    return _prefs.getBool('registered?');
  }
// USER EMAILS
  Future saveUserEmail(String value){
    return _prefs.setString('email', value);
  }
  get userEmail{
    return _prefs.getString('email') ?? '';
  }
  //Save all
  Future saveSpecific(String key, String value){
    return _prefs.setString(key, value);
  }
  String getSpecific(String key){
    return _prefs.getString(key) ?? '';
  }



  Future saveBoolValue(String key, bool value){
    return _prefs.setBool(key, value);
  }
  bool getBoolValue(String key){
    return _prefs.getBool(key);
  }

  /* NAvigation Rules for SharedPreferences

   */
  Future storeSelectedLanguage(bool value){
    return _prefs.setBool('selectedLanguage_nav', value);
  }

  bool retrieveSelectedLanguage(){
    return _prefs.getBool('selectedLanguage_nav');
  }
  Future storeIntroScreen(bool value){
    return _prefs.setBool('introScreen_nav', value);
  }

  bool retrieveIntroScreen(){
    return _prefs.getBool('introScreen_nav');
  }
  Future storeRegister(bool value){
    return _prefs.setBool('register_nav', value);
  }

  bool retrieveRegister(){
    return _prefs.getBool('register_nav');
  }
  Future storeToken(bool value){
    return _prefs.setBool('token_nav', value);
  }

  bool retrieveToken(){
    return _prefs.getBool('token_nav');
  }

  Future storeNotificationOTP(String otpNot){
    return _prefs.setString('not_otp', otpNot);
  }
  String retrieveNotificationOTP(){
    return _prefs.getString('not_otp');
  }

  Future storeNotificationTitle(String title){
    return _prefs.setString('not_title', title);
  }
  String retrieveNotificationTitle(){
    return _prefs.getString('not_title');
  }
  //SAVE FIREBASE TOKEN
  Future storeFirebaseID(String title){
    return _prefs.setString('user_firebase_token', title);
  }
  String retrieveFirebaseID(){
    return _prefs.getString('user_firebase_token');
  }
  //SAVE EMAIL
  Future storeSocialLoginEmail(String title){
    return _prefs.setString('social_login_email', title);
  }
  String retrieveSocialLoginEmail(){
    return _prefs.getString('social_login_email');
  }

  //SAVE PICTURE
  Future storeSocialLoginPicURL(String title){
    return _prefs.setString('social_login_picUrl', title);
  }
  String retrieveSocialLoginPicURL(){
    return _prefs.getString('social_login_picUrl');
  }

  //SAVE NAME
  Future storeSocialLoginName(String title){
    return _prefs.setString('social_login_name', title);
  }
  String retrieveSocialLoginName(){
    return _prefs.getString('social_login_name');
  }

  //SAVE SOCIAL_ID
  Future storeSocialLoginID(String title){
    return _prefs.setString('social_login_ID', title);
  }
  String retrieveSocialLoginID(String title){
    return _prefs.getString('social_login_ID');
  }

  //SAVE DEVICE ID
  Future storeDeviceID(String title){
    return _prefs.setString('unique_device_id', title);
  }
  String retrieveDeviceID(){
    return _prefs.getString('unique_device_id');
  }

  //SAVE LOGIN TYPE
  Future storeLoginType(String title){
    return _prefs.setString('social_login_type', title);
  }
  String retrieveLoginType(){
    return _prefs.getString('social_login_type');
  }

  Future storeUserTypeId(int id){
    return _prefs.setInt('userTypeId', id);
  }
  int retrieveUserTypeId(){
    return _prefs.getInt('userTypeId');
  }

  //SAVE LOGIN TYPE
  Future storeUserData(String title){
    return _prefs.setString('userData', title);
  }
  String retrieveUserData(){
    return _prefs.getString('userData');
  }

  //SEND REPORT HERE
  Future saveReportStateId(int title){
    return _prefs.setInt('reportStateId', title);
  }
  int getReportStateId(){
    return _prefs.getInt('reportStateId');
  }
  Future saveReportCrimeId(int title){
    return _prefs.setInt('reportCrimeId', title);
  }
  int getReportCrimeId(){
    return _prefs.getInt('reportCrimeId');
  }
  Future saveReportDescription(String title){
    return _prefs.setString('reportDescription', title);
  }
  String getReportDescription(){
    return _prefs.getString('reportDescription');
  }
  Future saveReportLocation(String title){
    return _prefs.setString('reportLocation', title);
  }
  String getReportLocation(){
    return _prefs.getString('reportLocation');
  }
  Future saveReportAddress(String title){
    return _prefs.setString('reportAddress', title);
  }
  String getReportAddress(){
    return _prefs.getString('reportAddress');
  }
  Future saveReportFile(String title){
    return _prefs.setString('saveReportFile', title);
  }
  String getReportFile(){
    return _prefs.getString('saveReportFile');
  }

  Future initReportFile(){
    return _prefs.setString('saveReportFile', '');
  }

  Future saveAudioDuration(int duration){
    return _prefs.setInt('saveAudioDuration',duration);
  }

  int getAudioDuration(){
    return _prefs.getInt('saveAudioDuration');
  }
  
  Future saveGeneralHeight(double height){
    return _prefs.setDouble('generalHeight', height);
  }

  double getGeneralHeight(){
    return _prefs.getDouble('generalHeight');
  }
  Future saveGeneralWidth(double width){
    return _prefs.setDouble('generalWidth', width);
  }

  double getGeneralWidth(){
    return _prefs.getDouble('generalWidth');
  }


}

