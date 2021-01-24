import 'package:avatar_glow/avatar_glow.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtisma/Screens/EyewitnessLogin.dart';
import 'package:gtisma/dashboardComponents/MakeAPictureDashboard.dart';
import 'package:gtisma/helpers/NavigtionHelper.dart';
import 'package:gtisma/helpers/UserPreferences.dart';
import 'package:gtisma/Screens/EyewitnessLogin.dart' as loginthings;
import 'package:gtisma/Screens/EyewitnessDashboard.dart' as dash;
import 'package:gtisma/helpers/GlobalVariables.dart';

SelectLanguage lang = SelectLanguage();
dynamic nativeLanguage = '';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    nativeLanguage = UserPreferences().data;
    return DrawerSource();
  }
}


class DrawerSource extends StatefulWidget {
  @override
  _DrawerSourceState createState() => _DrawerSourceState();
}

class _DrawerSourceState extends State<DrawerSource> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Stack(
            children: [
              ColorFiltered(
                child: Image.asset('assets/images/header_banner.jpeg',
                    fit: BoxFit.cover, width: double.infinity, height: 200),
                colorFilter: ColorFilter.mode(Color.fromRGBO(120, 78, 125, 1.0), BlendMode.softLight),
              ),
              Container(
                padding: EdgeInsets.only(left: 10.0, top: 20.0),
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: AvatarGlow(
                        glowColor: Colors.white,
                        endRadius: 60.0,
                        duration: Duration(milliseconds: 1000),
                        repeat: true,
                        showTwoGlows: true,
                        repeatPauseDuration: Duration(milliseconds: 100),
                        child: Material(
                          elevation: 0.0,
                          shape: CircleBorder(),
                          child: CircleAvatar(
                            backgroundImage: NetworkImage(UserPreferences().retrieveSocialLoginPicURL()),
                            radius: 30.0,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        UserPreferences().retrieveSocialLoginName(),
                        style: GoogleFonts.arvo(
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: Text(
                        UserPreferences().retrieveSocialLoginEmail(),
                        style: GoogleFonts.arvo(
                          fontWeight: FontWeight.w600,
                          fontSize: 12.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ListTile(
            focusColor: Colors.blueAccent,
            leading: Icon(Icons.language),
            title: Text(
              lang.languagTester(nativeLanguage)[39],
              style: GoogleFonts.robotoSlab(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
            onTap: () {
              Navigator.of(context).pop();
              dash.EyewitnessBodyState().moveToChangeLanguage();
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(Icons.report),
            title: Text(
              lang.languagTester(nativeLanguage)[35],
              style: GoogleFonts.robotoSlab(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
            onTap: () async{
              Navigator.of(context).pop();
              //await dash.EyewitnessDashboard().movetoAnotherPage0();
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(Icons.add_a_photo),
            title: Text(
              lang.languagTester(nativeLanguage)[36],
              style: GoogleFonts.robotoSlab(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
            onTap: () async{
              Navigator.of(context).pop();
              NavigationHelper().navigateAnotherPage(context, MakeAPictureDashboard());
            },
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(Icons.ondemand_video),
            title: Text(
              lang.languagTester(nativeLanguage)[37],
              style: GoogleFonts.robotoSlab(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
            onTap: () async {
              Navigator.of(context).pop();
            }
          ),
          Divider(
            height: 1,
          ),
          ListTile(
            leading: Icon(Icons.wrap_text),
            title: Text(
              lang.languagTester(nativeLanguage)[38],
              style: GoogleFonts.robotoSlab(
                fontSize: 15.0,
                color: Colors.black,
              ),
            ),
            onTap: () async{
              Navigator.of(context).pop();
              //await dash.EyewitnessDashboard().movetoAnotherPage3();
            },
          ),
          Divider(
            height: 1,
          ),
          SizedBox(
            height: 50.0,
          ),
          // RaisedButton(
          //     color: Color.fromRGBO(120, 78, 125, 1.0),
          //     padding: EdgeInsets.only(
          //         left: 40.0, right: 40.0, top: 10.0, bottom: 10.0),
          //     textColor: Colors.white,
          //     shape: StadiumBorder(),
          //     child: Text(
          //       'Logout',
          //       style: GoogleFonts.robotoSlab(
          //           fontWeight: FontWeight.w600, fontSize: 15.0),
          //     ),
          //     onPressed: () async {
          //       dash.EyewitnessBodyState().logOut();
          //       NavigationHelper()
          //           .navigateAnotherPage(context, EyewitnessLoginStat());
          //     }
          //     ),
        ],
      ),
    );
  }

  showMyDialog(BuildContext context, String title, String desc){

  }
}

