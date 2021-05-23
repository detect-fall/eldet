import 'package:fall_assist/util/size_config.dart';
import 'package:fall_assist/widgets/bottom_nav_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
  }

  void timer() async {
    Future.delayed(const Duration(milliseconds: 3000), () async {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
        return BottomNavBar();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Scaffold(
        backgroundColor: Colors.indigo,
        body: Center(
          child: FittedBox(
            fit: BoxFit.contain,
            child: Text(
              'Fall. Assist.',
              style: GoogleFonts.montserrat(
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.safeBlockHorizontal * 10,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class SystemUiOverlayStyle {}
