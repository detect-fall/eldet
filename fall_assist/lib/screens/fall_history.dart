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

  var recentJobsRef = FirebaseDatabase.instance.reference().child('sensorData');

  @override
  Widget build(BuildContext context) {
    //final ref = fb.reference();
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.indigo));
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
        body: StreamBuilder(
          stream: recentJobsRef.onValue,
          builder: (context, snap) {
            if (snap.hasData &&
                !snap.hasError &&
                snap.data.snapshot.value != null) {
//taking the data snapshot.
              DataSnapshot snapshot = snap.data.snapshot;
              List item = [];
              List _list = [];
//it gives all the documents in this list.
              _list = snapshot.value;
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
                        return Text(item[index]['angle']);
                      },
                    );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }
}
