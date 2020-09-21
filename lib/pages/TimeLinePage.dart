import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memeplug/models/user.dart';
import 'package:memeplug/pages/EditProfilePage.dart';
import 'package:memeplug/pages/NotificationsPage.dart';
import 'package:memeplug/widgets/dart/HeaderWidget.dart';
import 'package:memeplug/widgets/dart/PostWidget.dart';
import 'package:memeplug/widgets/dart/ProgressWidget.dart';
import 'package:memeplug/pages/HomePage.dart';

class TimeLinePage extends StatefulWidget {
  final User gCurrentUser;
  TimeLinePage({this.gCurrentUser});
  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {
  List<Post> posts;
  List<String> followingsList = [];
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  retriveTimeLine() async {
    QuerySnapshot querySnapshot = await timelineReference
        .document(widget.gCurrentUser.id)
        .collection('timelinePosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    List<Post> allposts = querySnapshot.documents
        .map((document) => Post.fromDocument(document))
        .toList();
    setState(() {
      this.posts = allposts;
    });
  }

  retriveFollowings() async {
    QuerySnapshot querySnapshot = await followingReference
        .document(currentUser.id)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      followingsList = querySnapshot.documents
          .map((document) => document.documentID)
          .toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    retriveTimeLine();
    retriveFollowings();
  }

  createUserTimeline() {
    if (posts == null) {
      return circularProgress();
    } else {
      return ListView(children: posts);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: header(context, isAppTitle: true),
        body: RefreshIndicator(
          child: createUserTimeline(),
          onRefresh: () => retriveTimeLine(),
        ));
  }
}
