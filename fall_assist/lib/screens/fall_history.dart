import 'package:fall_assist/util/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_database/firebase_database.dart';

class FallHistory extends StatefulWidget {
  @override
  _FallHistoryState createState() => _FallHistoryState();
}

class _FallHistoryState extends State<FallHistory> {
  //final fb = FirebaseDatabase.instance;

  var dbRef = FirebaseDatabase.instance.reference().child("sensorData");

  @override
  Widget build(BuildContext context) {
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
              height: SizeConfig.safeBlockVertical * 4.2,
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
  List<FallTile> data;
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
                    isExpanded: false,
                  ))
              .toList();

          return snap.data.snapshot.value == null
              ? SizedBox()
              : SingleChildScrollView(
                  child: Container(
                    //padding: EdgeInsets.only(top: 80),
                    child: _buildPanel(),
                  ),
                );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          data[index].isExpanded = !isExpanded;
        });
      },
      children: data.map<ExpansionPanel>((FallTile item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return ListTile(
              title: Text("Fall" + " " + "Occured" + " " + "at " + item.timst),
            );
          },
          body: ListTile(
            title: Text(item.timst),
          ),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }
}

class FallTile {
  var angle, fall, lat, long, timst;
  bool isExpanded;
  FallTile(
      {this.angle,
      this.fall,
      this.lat,
      this.long,
      this.timst,
      this.isExpanded});
}

/*
StreamBuilder(
        stream: dbRef.onValue,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.indigo,
              ),
            );
          }
          if (snap.hasError) {
            // _showDialog("No internet!",
            //     "Please check your internet connectivity.", context);
          }
          final falls = snap.data.snapshot.value;
          List<FallTile> fallTiles = [];
          //HashMap hm = new HashMap<int, Documentsnap>();
          for (int i = 0; i < falls.length; i++) {
            final rankingTile = FallTile(
                angle: falls[i]["angle"].toString(),
                fall: falls[i]["fall"].toString(),
                lat: falls[i]["latitude"].toString(),
                long: falls[i]["longitude"].toString(),
                timst: falls[i]["timestamp"].toString());
            fallTiles.add(rankingTile);
          }
          return Expanded(
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.safeBlockVertical * 0.8),
              child: ListView(
                physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                children: fallTiles,
              ),
            ),
          );
        })

*/
