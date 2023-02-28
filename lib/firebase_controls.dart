import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'dataclasses.dart';

class JobsController{
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('jobs');
  Future<DocumentReference> addJob(Job job) {
    return collection.add(job.toFirestore());
  }
}

class ResultsController{
  final CollectionReference collection =
  FirebaseFirestore.instance.collection('results');
  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }
  void updateViews(String ref, int newViews) {
    collection.doc(ref).update({'views':newViews});
  }
  void updateLikes(String ref, int newLikes) {
    collection.doc(ref).update({'likes':newLikes});
  }
  Future<List<Result>> getMostViewed(int number) async {
    List<Result> resList = <Result>[];
    QuerySnapshot querySnapshot= await collection.orderBy('views',descending: true)
        .limit(number)
        .get();
    print("ABCDEFG");
    for (var doc in querySnapshot.docs) {
      print(doc.data());
    }
    List<QueryDocumentSnapshot<Map<String,dynamic>>> docs = querySnapshot.docs as List<QueryDocumentSnapshot<Map<String,dynamic>>>;
    docs.forEach((element) { resList.add(Result.fromfirestore(element.id,element.data()));});
    print("AAAJ");
    print(resList);
    return resList;
  }
  Future<List<Result>> getMostLiked(int number) async {
    List<Result> resList = <Result>[];
    QuerySnapshot querySnapshot = await collection.orderBy('likes',descending: true)
        .limit(number)
        .get();
    print("AAAAAAA");
    for (var doc in querySnapshot.docs) {
      print(doc.data());
    }
    List<QueryDocumentSnapshot<Map<String,dynamic>>> docs = querySnapshot.docs as List<QueryDocumentSnapshot<Map<String,dynamic>>>;
    docs.forEach((element) { resList.add(Result.fromfirestore(element.id,element.data()));});
    return resList;
  }
  Future<List<Result>> getMostRecent(int number) async {
    List<Result> resList = <Result>[];
    QuerySnapshot querySnapshot = await collection.orderBy('timestamp',descending: true)
        .limit(number)
        .get();
    print("AAAAAAA");
    for (var doc in querySnapshot.docs) {
      print(doc.data());
    }
    List<QueryDocumentSnapshot<Map<String,dynamic>>> docs = querySnapshot.docs as List<QueryDocumentSnapshot<Map<String,dynamic>>>;
    docs.forEach((element) { resList.add(Result.fromfirestore(element.id,element.data()));});
    return resList;
  }
  Future<Result> waitForResult (String ID) async {
    final docRef = collection.doc(ID);
    DocumentSnapshot? result;
    String test = '';
    StreamSubscription<DocumentSnapshot> sub = docRef.snapshots().listen(
          (event)
          {
            print("current data: ${event.data()}");
            test = event.data().toString();
            result = event;
          },
      onError: (error) => print("Listen failed: $error"),
    );
    print("=========================");
    print(test);
    print("=========================");
    while(test=="null" || test == "") {
      await Future.delayed(Duration(seconds: 1));
    }
    sub.cancel();
    return Result(answer: result!.get('answer'),
                  summary: result!.get('summary'),
                  views: result!.get('views'),
                  likes: result!.get('likes'),
                  originalQuestion: result!.get('originalQuestion'),
                  ref: result!.id,
                  timestamp: result!.get('timestamp')
    );
  }
}