import 'package:fall_assist/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:maps_launcher/maps_launcher.dart';

class FallHistory extends StatefulWidget {
  @override
  _FallHistoryState createState() => _FallHistoryState();
}

class _FallHistoryState extends State<FallHistory> {
  //final fb = FirebaseDatabase.instance;

  var dbRef = FirebaseDatabase.instance.reference().child("sensorData");

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
            'Fall History',
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
        body: Column(
          children: <Widget>[
            SizedBox(
              height: SizeConfig.safeBlockVertical * 3,
            ),
            FallStream(dbRef: dbRef),
          ],
        ),
      ),
    );
  }
}

class FallStream extends StatefulWidget {
  var dbRef;
  FallStream({Key key, this.dbRef}) : super(key: key);
  @override
  _FallStreamState createState() => _FallStreamState();
}

class _FallStreamState extends State<FallStream> {
  List<FallTile> data = [];
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
      stream: widget.dbRef.onValue,
      builder: (context, snap) {
        if (snap.hasData &&
            !snap.hasError &&
            snap.data.snapshot.value != null) {
          DataSnapshot snapshot = snap.data.snapshot;
          //print(snapshot.value);
          //print(snapshot.value.runtimeType);
          //print('here1');
          Map<dynamic, dynamic> map = snapshot.value;
          //print('here2');
          //print(map);
          data = map.entries
              .map((entry) => FallTile(
                    angle: entry.value["angle"],
                    fall: entry.value["fall"],
                    lat: entry.value["latitude"],
                    long: entry.value["longitude"],
                    timst: entry.value["timestamp"],
                    day: entry.value["date"],
                  ))
              .toList();

          return snap.data.snapshot.value == null
              ? SizedBox()
              : Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0.8),
                    child: ListView(
                      physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      children: data,
                    ),
                  ),
                );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class FallTile extends StatelessWidget {
  var angle, fall, lat, long, timst, day;

  FallTile({this.angle, this.fall, this.lat, this.long, this.timst, this.day});
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              //contentPadding: EdgeInsets.all(2),
              leading: Icon(Icons.arrow_drop_down_circle),
              title: const Text('Fall Detected'),
              subtitle: Text(
                'Date:  $day\nTime: $timst',
                style: TextStyle(color: Colors.black.withOpacity(0.6)),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: GestureDetector(
                onDoubleTap: () {
                    MapsLauncher.launchCoordinates(
                    12, 77);
                },
                child: Text(
                  'A fall was detected on $day, $timst hrs at latitude $lat, longitude $long. ',
                  style: TextStyle(color: Colors.black.withOpacity(0.6)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
