import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';


class test extends StatelessWidget {


  var recentJobsRef =   FirebaseDatabase.instance
      .reference()
      .child('recent')
      .orderByChild('created_at')  //order by creation time.
      .limitToFirst(10);           //limited to get only 10 documents.
//Now you can use stream builder to get the data.


  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: recentJobsRef.onValue,
      builder: (context, snap) {
        if (snap.hasData && !snap.hasError && snap.data.snapshot.value!=null) {

//taking the data snapshot.
          DataSnapshot snapshot = snap.data.snapshot;
          List item=[];
          List _list=[];
//it gives all the documents in this list.
          _list=snapshot.value;
//Now we're just checking if document is not null then add it to another list called "item".
//I faced this problem it works fine without null check until you remove a document and then your stream reads data including the removed one with a null value(if you have some better approach let me know).
          _list.forEach((f){
            if(f!=null){
              item.add(f);
            }
          }
          );
          return snap.data.snapshot.value == null
//return sizedbox if there's nothing in database.
              ? SizedBox()
//otherwise return a list of widgets.
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: item.length,
            itemBuilder: (context, index) {
//              return _containerForRecentJobs(
//                  item[index]['title']
//              );
            },
          );
        } else {
          return   Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}




