import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:memeplug/pages/CreateAccountPage.dart';
import 'package:memeplug/pages/NotificationsPage.dart';
import 'package:memeplug/pages/ProfilePage.dart';
import 'package:memeplug/pages/SearchPage.dart';
import 'package:memeplug/pages/TimeLinePage.dart';
import 'package:memeplug/pages/UploadPage.dart';
import 'package:memeplug/models/user.dart';
import 'package:memeplug/pages/changeprofilepicture.dart';
import 'package:memeplug/widgets/constants.dart';

final GoogleSignIn gSignIn = GoogleSignIn();
final usersReference = Firestore.instance.collection('Users');
final StorageReference storageReference =
    FirebaseStorage.instance.ref().child('Posts Pictures');
final DateTime timestamp = DateTime.now();
final postsReference = Firestore.instance.collection('posts');
final commentsReference = Firestore.instance.collection('comments');
final activityFeedReference = Firestore.instance.collection('feed');
final followingReference = Firestore.instance.collection('following');
final followersReference = Firestore.instance.collection('followers');
User currentUser;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isSignedIn = false;
  PageController pageController;
  int getPageIndex = 0;
  bool klabelNavigationColor = false;
  int colorIndex = 0;

  void initState() {
    super.initState();
    pageController = PageController();

    gSignIn.onCurrentUserChanged.listen((gSigninAccount) {
      controlSignIn(gSigninAccount);
    }, onError: (gError) {
      print('Error Message:' + gError);
    });
    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }).catchError((gError) {
      print('Error Message:' + gError);
    });
  }

  controlSignIn(GoogleSignInAccount signInAccount) async {
    if (signInAccount != null) {
      await userSaveInfoToFireStore();
      setState(() {
        isSignedIn = true;
      });
    } else {
      setState(() {
        isSignedIn = false;
      });
    }
  }

  userSaveInfoToFireStore() async {
    final GoogleSignInAccount gCurrentUser = gSignIn.currentUser;
    DocumentSnapshot documentSnapshot =
        await usersReference.document(gCurrentUser.id).get();
    if (!documentSnapshot.exists) {
      final username = await Navigator.push(context,
          MaterialPageRoute(builder: (context) => CreateAccountPage()));
      usersReference.document(gCurrentUser.id).setData({
        'id': gCurrentUser.id,
        'profileName': gCurrentUser.displayName,
        'username': username,
        'url': gCurrentUser.photoUrl,
        'email': gCurrentUser.email,
        'bio': "",
        'timestamp': timestamp,
      });
      documentSnapshot = await usersReference.document(gCurrentUser.id).get();
    }
    currentUser = User.fromDocument(documentSnapshot);
  }

  void dipose() {
    pageController.dispose();
    super.dispose();
  }

  logInUser() {
    gSignIn.signIn();
  }

  logOutUser() {
    gSignIn.signOut();
  }

  whenPageChanges(int pageIndex) {
    setState(() {
      this.getPageIndex = pageIndex;
      this.colorIndex = pageIndex;
    });
  }

  onTapChange(int pageIndex) {
    pageController.animateToPage(
      pageIndex,
      duration: Duration(milliseconds: 1),
      curve: Curves.easeIn,
      // curve: Curves.bounceInOut,
    );
  }

  Widget buildHomeScreen() {
    return Scaffold(
      body: PageView(
        children: <Widget>[
          RaisedButton.icon(
              onPressed: logOutUser,
              icon: Icon(Icons.close),
              label: Text(
                'sign out',
                style: TextStyle(fontFamily: 'SFProText'),
              )),
          // TimeLinePage(),
          SearchPage(),
          UploadPage(
            gCurrentUser: currentUser,
          ),
          NotificationsPage(),
          ProfilePage(userProfileId: currentUser.id),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: getPageIndex,
        onTap: onTapChange,
        backgroundColor: Theme.of(context).accentColor,
        activeColor: Colors.white,
        inactiveColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home, size: 27.0),
              title: new Text(
                'Home',
                style: TextStyle(
                  color: colorIndex == 0 ? kButtonColor : kGreyColor,
                ),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.search, size: 27.0),
              title: Text(
                'Search',
                style: TextStyle(
                  color: colorIndex == 1 ? kButtonColor : kGreyColor,
                ),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.photo_camera, size: 27.0),
              title: Text(
                'Camera',
                style: TextStyle(
                  color: colorIndex == 2 ? kButtonColor : kGreyColor,
                ),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.favorite, size: 27.0),
              title: Text(
                'Favorite',
                style: TextStyle(
                  color: colorIndex == 3 ? kButtonColor : kGreyColor,
                ),
              )),
          BottomNavigationBarItem(
              icon: Icon(Icons.person, size: 27.0),
              title: Text(
                'profile',
                style: TextStyle(
                  color: colorIndex == 4 ? kButtonColor : kGreyColor,
                ),
              ))
        ],
      ),
    );
  }

  Scaffold buildSignInScreen() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.black,
              Colors.black38,
              Colors.yellow[700],
              Colors.yellow[800],
              Colors.yellow[900]
            ],
            stops: [0.2, 0.4, 0.6, 0.8, 1.0],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Memeplug',
              style: TextStyle(
                  fontFamily: 'Signatra', fontSize: 92.0, color: Colors.white),
            ),
            GestureDetector(
              onTap: () => logInUser(),
              child: Container(
                width: 270.0,
                height: 65.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/google_signin_button.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isSignedIn) {
      return buildHomeScreen();
    } else {
      return buildSignInScreen();
    }
  }
}
