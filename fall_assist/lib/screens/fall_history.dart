import 'dart:convert';

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

class FallStream extends StatelessWidget {
  var dbRef;
  FallStream({this.dbRef});
  // void _showDialog(
  //     String a,
  //     String b,
  //     BuildContext context,
  //     ) {
  //   // flutter defined function
  //   showDialog(
  //     context: context,
  //     barrierDismissible: false,
  //     builder: (BuildContext context) {

  //       // return object of type Dialog
  //       return AlertDialog(
  //         contentPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal*6.2,SizeConfig.safeBlockHorizontal*2,
  //             SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*2),
  //         shape: RoundedRectangleBorder(

  //           borderRadius: BorderRadius.circular(10),
  //         ),
  //         title: new Text(a,style: GoogleFonts.montserrat(
  //             fontWeight: FontWeight.w500, color: Colors.black, fontSize:SizeConfig.safeBlockHorizontal*5),),
  //         content: new Text(b,style: GoogleFonts.montserrat(
  //           fontWeight: FontWeight.normal,
  //           fontSize:SizeConfig.safeBlockHorizontal*4,
  //           color: Colors.black,
  //         ),),
  //         actions: <Widget>[
  //           // usually buttons at the bottom of the dialog
  //           new FlatButton(
  //             child: new Text(" OK",style: TextStyle(
  //                 fontSize: SizeConfig.safeBlockHorizontal*3.5
  //             ),),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    // void _showDialog(
    //     String a,
    //     String b,
    //     BuildContext context,
    //     ) {
    //   // flutter defined function
    //   showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context) {

    //       // return object of type Dialog
    //       return AlertDialog(
    //         contentPadding: EdgeInsets.fromLTRB(SizeConfig.safeBlockHorizontal*6.2,SizeConfig.safeBlockHorizontal*2,
    //             SizeConfig.safeBlockHorizontal*4,SizeConfig.safeBlockHorizontal*2),
    //         shape: RoundedRectangleBorder(

    //           borderRadius: BorderRadius.circular(10),
    //         ),
    //         title: new Text(a,style: GoogleFonts.montserrat(
    //             fontWeight: FontWeight.w500, color: Colors.black, fontSize:SizeConfig.safeBlockHorizontal*5),),
    //         content: new Text(b,style: GoogleFonts.montserrat(
    //           fontWeight: FontWeight.normal,
    //           fontSize:SizeConfig.safeBlockHorizontal*4,
    //           color: Colors.black,
    //         ),),
    //         actions: <Widget>[
    //           // usually buttons at the bottom of the dialog
    //           new FlatButton(
    //             child: new Text(" OK",style: TextStyle(
    //                 fontSize: SizeConfig.safeBlockHorizontal*3.5
    //             ),),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // }

    // Future<bool>  getConnectivityStatus()async{
    //   try {
    //     final result = await InternetAddress.lookup('google.com');
    //     if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

    //     }
    //   } on SocketException catch (_) {
    //     _showDialog("No Internet!", "Please check your internet connection.",context);
    //     return false;
    //   }
    // }

    return StreamBuilder<dynamic>(
      stream: dbRef.onValue,
      builder: (context, snap) {
        if (snap.hasData &&
            !snap.hasError &&
            snap.data.snapshot.value != null) {
          DataSnapshot snapshot = snap.data.snapshot;
          print(snapshot.value);
          print(snapshot.value.runtimeType);
          List item = [];
          List<dynamic> _list = [];
          print('here1');
          Map<dynamic, dynamic> map = snapshot.value;
          print('here2');
          print(map);

          //Map<String, dynamic> map = json.decode(snapshot.value);
//it gives all the documents in this list.

//Now we're just checking if document is not null then add it to another list called "item".
//I faced this problem it works fine without null check until you remove a document and then your stream reads data including the removed one with a null value(if you have some better approach let me know).
          _list.forEach((f) {
            if (f != null) {
              item.add(f);
            }
          });
          return snap.data.snapshot.value == null
//return sizedbox if there's nothing in database.
              ? SizedBox()
//otherwise return a list of widgets.
              : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: item.length,
                  itemBuilder: (context, index) {
                    return FallTile(
                        angle: item[index]['angle'],
                        fall: item[index]['fall'],
                        lat: item[index]['latitude'],
                        long: item[index]['longitude'],
                        timst: item[index]['timestamp']);
                  },
                );
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}

class FallTile extends StatelessWidget {
  var angle, fall, lat, long, timst;
  FallTile({this.angle, this.fall, this.lat, this.long, this.timst});
  //final Documentsnap rank;
  //int index;

  //RankingTile({this.rank, this.index});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
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
