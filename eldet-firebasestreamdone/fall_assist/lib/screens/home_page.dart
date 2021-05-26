import 'package:fall_assist/screens/fall_history.dart';
import 'package:fall_assist/util/size_config.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      print('here');
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('here');
      print('A new onMessageOpenedApp event was published!');
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return FallHistory();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.indigo,
    ));
    SizeConfig().init(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.dark,
          title: Text(
            'Fall Assist',
            style: GoogleFonts.montserrat(
                fontWeight: FontWeight.w600,
                color: Colors.white,
                fontSize: MediaQuery.of(context).size.width * 0.05),
          ),
          centerTitle: true,
          backgroundColor: Colors.indigo,
          elevation: 10.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              bottom: Radius.circular(15),
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: ScrollPhysics(parent: BouncingScrollPhysics()),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.05,
              ),
              Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05),
                child: Text(
                  '👉  What is Fall Assist ❓',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                      fontSize: SizeConfig.safeBlockHorizontal * 5.5),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.045,
              ),
              Container(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05,
                    right: MediaQuery.of(context).size.width * 0.05),
                child: RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      TextSpan(
                        text:
                            '➡  Fall Assist is a mobile application that facilitates rapid detection and intervention for individuals who have experienced a fall. \n \n',
                        style: GoogleFonts.montserrat(
                            fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text:
                            '➡  This application aims to reduce the physical and mental damage caused, by reducing the time interval between the fall and and its discovery. \n \n',
                        style: GoogleFonts.montserrat(
                            fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text:
                            '➡  Fall Assist will alert the caretaker or the family members within seconds after the fall and thus making sure that no time is lost post fall which is very crucial. \n \n',
                        style: GoogleFonts.montserrat(
                            fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text:
                            '➡  According to the World Health Organization (WHO), around 646 k fatal falls occur each year in the world,the majority of whom are suffered by adults older than 65 years. \n \n',
                        style: GoogleFonts.montserrat(
                            fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                      TextSpan(
                        text:
                            '➡  This makes it the second reason for unintentional injury death, followed by road traffic injuries. Globally, falls are a major public health problem for the elderly. \n \n',
                        style: GoogleFonts.montserrat(
                            fontSize: SizeConfig.safeBlockHorizontal * 4.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.075,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
