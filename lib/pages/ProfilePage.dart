import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:memeplug/models/user.dart';
import 'package:memeplug/pages/EditProfilePage.dart';
import 'package:memeplug/pages/HomePage.dart';
import 'package:memeplug/widgets/dart/HeaderWidget.dart';
import 'package:memeplug/widgets/dart/PostTileWidget.dart';
import 'package:memeplug/widgets/dart/PostWidget.dart';
import 'package:memeplug/widgets/dart/ProgressWidget.dart';
import 'package:memeplug/widgets/constants.dart';

class ProfilePage extends StatefulWidget {
  final String userProfileId;
  ProfilePage({this.userProfileId});
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final String currentOnlineUserId = currentUser?.id;
  bool loading = false;
  int countPost = 0;
  List<Post> postsList = [];
  String postOrientation = 'grid';
  int countTotalFollowers = 0;
  int countTotalFollowings = 0;
  bool following = false;
  void initState() {
    super.initState();
    getAllProfilePosts();
    getAllFollowers();
    getAllFollowings();
    checkIfAlreadyFollowing();
  }

  getAllFollowings() async {
    QuerySnapshot querySnapshot = await followingReference
        .document(widget.userProfileId)
        .collection('userFollowing')
        .getDocuments();
    setState(() {
      countTotalFollowings = querySnapshot.documents.length;
    });
  }

  getAllFollowers() async {
    QuerySnapshot querySnapshot = await followersReference
        .document(widget.userProfileId)
        .collection('userFollowers')
        .getDocuments();
    setState(() {
      countTotalFollowers = querySnapshot.documents.length;
    });
  }

  checkIfAlreadyFollowing() async {
    DocumentSnapshot documentSnapshot = await followersReference
        .document(widget.userProfileId)
        .collection('usersFollowers')
        .document(currentOnlineUserId)
        .get();
    setState(() {
      following = documentSnapshot.exists;
    });
  }

  createProfileTopView() {
    return FutureBuilder(
        future: usersReference.document(widget.userProfileId).get(),
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
            return Container(
              width: 0,
              height: 0,
            );
          }
          User user = User.fromDocument(dataSnapshot.data);
          return Padding(
            padding: EdgeInsets.all(17.0),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 35.0,
                      backgroundColor: Colors.grey,
                      backgroundImage: CachedNetworkImageProvider(user.url),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: <Widget>[
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              createColumns('posts', countPost
                                  // 1000000
                                  ),
                              createColumns(
                                  'followers',
                                  // 100000
                                  countTotalFollowers),
                              createColumns(
                                  'following',
                                  // 10000000000
                                  countTotalFollowings),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[createButton()],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 9),
                  child: Text(
                    user.username,
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    user.profileName,
                    style: TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.only(top: 3),
                  child: Text(
                    user.bio,
                    style: TextStyle(fontSize: 18.0, color: Colors.white54),
                  ),
                )
              ],
            ),
          );
        });
  }

  createButton() {
    bool ownProfile = currentOnlineUserId == widget.userProfileId;
    if (ownProfile) {
      return createButtonTitleAndFunction(
          title: 'Edit profile', performFunction: editUserProfile);
    } else if (following) {
      return createButtonTitleAndFunction(
        title: 'unfollow',
        performFunction: controlUnFollowUser,
      );
    } else if (!following) {
      return createButtonTitleAndFunction(
        title: 'follow',
        performFunction: controlFollowUser,
      );
    }
  }

  controlUnFollowUser() {
    setState(() {
      following = false;
    });
    followersReference
        .document(widget.userProfileId)
        .collection('userFollowing')
        .document(currentOnlineUserId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });

    followingReference
        .document(currentOnlineUserId)
        .collection('userFolllowing')
        .document(widget.userProfileId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
    activityFeedReference
        .document(widget.userProfileId)
        .collection('feedItems')
        .document(currentOnlineUserId)
        .get()
        .then((document) {
      if (document.exists) {
        document.reference.delete();
      }
    });
  }

  controlFollowUser() {
    setState(() {
      following = true;
    });
    followersReference
        .document(widget.userProfileId)
        .collection('userFollowers')
        .document(currentOnlineUserId)
        .setData({});
    followingReference
        .document(currentOnlineUserId)
        .collection('userFollowing')
        .document(widget.userProfileId)
        .setData({});

    activityFeedReference
        .document(widget.userProfileId)
        .collection('feedItems')
        .document(currentOnlineUserId)
        .setData({
      'type': 'follow',
      'ownerId': widget.userProfileId,
      'username': currentUser.username,
      'timestamp': DateTime.now(),
      'userProfileImg': currentUser.url,
      'userId': currentOnlineUserId
    });
  }

  Container createButtonTitleAndFunction(
      {String title, Function performFunction}) {
    return Container(
      padding: EdgeInsets.only(top: 3.0),
      child: FlatButton(
          onPressed: performFunction,
          child: Container(
            width: 150.0,
            height: 26.0,
            child: Text(
              title,
              style: TextStyle(
                color: following ? Colors.grey : Theme.of(context).accentColor,
              ),
            ),
            alignment: Alignment.center,
            decoration: BoxDecoration(
                color: following ? Colors.black : kButtonColor,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(6.0)),
          )),
    );
  }

  editUserProfile() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                EditProfilePage(currentOnlineUserId: currentOnlineUserId)));
  }

  Column createColumns(String title, int count) {
    return Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            count.toString(),
            style: TextStyle(
                fontSize: 20.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
          Container(
            margin: EdgeInsets.only(top: 5.0),
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey),
            ),
          )
        ]);
  }

  @override
  Widget build(BuildContext context) {
    // ScreenUtil.init(context, height: 896, width: 414, allowFontScaling: true);
    return Scaffold(
      appBar: header(context, strTitle: 'Profile'),
      body: ListView(
        children: <Widget>[
          createProfileTopView(),
          Divider(),
          createListAndGridPostOrientaion(),
          Divider(
            height: 0.0,
          ),
          displayProfilePost(),
        ],
      ),
    );
  }

  displayProfilePost() {
    if (loading) {
      return circularProgress();
    } else if (postsList.isEmpty) {
      return Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(30.0),
              child: Icon(
                Icons.photo_library,
                color: Colors.grey,
                size: 200.0,
              ),
            ),
            Padding(
                padding: EdgeInsets.all(30.0),
                child: Text('No posts',
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold))),
          ],
        ),
      );
    } else if (postOrientation == 'grid') {
      List<GridTile> gridTilesList = [];
      postsList.forEach((eachPost) {
        gridTilesList.add(GridTile(child: PostTile(eachPost)));
      });
      return GridView.count(
          crossAxisCount: 3,
          childAspectRatio: 1.0,
          mainAxisSpacing: 2.5,
          crossAxisSpacing: 1.5,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: gridTilesList);
    } else if (postOrientation == 'list') {
      return Column(
        children: postsList,
      );
    }
  }

  getAllProfilePosts() async {
    setState(() {
      loading = true;
    });
    QuerySnapshot querySnapshot = await postsReference
        .document(widget.userProfileId)
        .collection('usersPosts')
        .orderBy('timestamp', descending: true)
        .getDocuments();
    setState(() {
      loading = false;
      countPost = querySnapshot.documents.length;
      postsList = querySnapshot.documents
          .map((documentSnapshot) => Post.fromDocument(documentSnapshot))
          .toList();
    });
  }

  createListAndGridPostOrientaion() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
            onPressed: () => setOrientation('grid'),
            icon: Icon(Icons.grid_on),
            color: postOrientation == 'grid'
                ? Theme.of(context).primaryColor
                : Colors.grey),
        IconButton(
            onPressed: () => setOrientation('list'),
            icon: Icon(Icons.list),
            color: postOrientation == 'list'
                ? Theme.of(context).primaryColor
                : Colors.grey)
      ],
    );
  }

  setOrientation(String orientation) {
    setState(() {
      this.postOrientation = orientation;
    });
  }
}
