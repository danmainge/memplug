import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memeplug/models/user.dart';
import 'package:memeplug/pages/HomePage.dart';
import 'package:memeplug/widgets/constants.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:memeplug/widgets/dart/ProgressWidget.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with AutomaticKeepAliveClientMixin<SearchPage> {
  TextEditingController searchTextEditingController = TextEditingController();
  Future<QuerySnapshot> futureSearchResults;
  emptyTextFormField() {
    searchTextEditingController.clear();
  }

  controlSearching(String str) {
    Future<QuerySnapshot> allUsers = userReference
        .where('profileName', isGreaterThanOrEqualTo: str)
        .getDocuments();
    setState(() {
      futureSearchResults = allUsers;
    });
  }

  AppBar searchPageHeader() {
    return AppBar(
      backgroundColor: Colors.black,
      title: TextFormField(
        style: TextStyle(color: Colors.white, fontSize: 18.0),
        controller: searchTextEditingController,
        decoration: InputDecoration(
          fillColor: Colors.white.withOpacity(0.4),
          filled: true,
          hintText: 'Look for friends',
          hintStyle: TextStyle(color: Colors.white),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
          prefixIcon: Icon(Feather.search, color: Colors.white),
          prefixIconConstraints: BoxConstraints(minHeight: 32, minWidth: 32),
          suffix: IconButton(
            constraints: BoxConstraints(minHeight: 32, minWidth: 32),
            icon: Icon(Icons.clear, color: Colors.white),
            onPressed: emptyTextFormField,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(50.0),
            borderSide: BorderSide(
              width: 0,
              style: BorderStyle.none,
            ),
          ),
        ),
        onFieldSubmitted: controlSearching,
      ),
    );
  }

  Container displayNoSearchResultsfound() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Container(
      child: Center(
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            // Image.asset(
            //   'assets/images/playstore.png',
            //   height: 200,
            //   width: 200,
            // ),
            Icon(
              Icons.group,
              color: Colors.grey,
              size: 200.0,
            ),
            Text(
              'users',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 50.0),
            )
          ],
        ),
      ),
    );
  }

  displayUserFoundScreen() {
    return FutureBuilder(
        future: futureSearchResults,
        builder: (context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
            return circularProgress();
            Center(
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/images/playstore.jpg',
                    height: 200,
                    width: 200,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    'user not found',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 50.0),
                  )
                ],
              ),
            );
          }
          List<UserResult> searchUsersResult = [];
          dataSnapshot.data.documents.forEach((document) {
            User eachUser = User.fromDocument(document);
            UserResult userResult = UserResult(eachUser);
            searchUsersResult.add(userResult);
          });
          return ListView(children: searchUsersResult);
        });
  }

  bool get wantKeepAlive => true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: searchPageHeader(),
        body: futureSearchResults == null
            ? displayNoSearchResultsfound()
            : displayUserFoundScreen());
  }
}

class UserResult extends StatelessWidget {
  final User eachUser;
  UserResult(this.eachUser);

  void showSnackBar(BuildContext context) {
    SnackBar snackBar = SnackBar(content: Text('NYENYE NYENYE BUBU'));
    Scaffold.of(context).showSnackBar(snackBar);
    //  var snackBar = SnackBar(content: Text("data"),);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(3.0),
      child: Container(
        color: Colors.white54,
        child: Column(
          children: <Widget>[
            GestureDetector(
              onTap: () => showSnackBar(context),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.black,
                  backgroundImage: CachedNetworkImageProvider(eachUser.url),
                ),
                title: Text(
                  eachUser.profileName,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  eachUser.username,
                  style: TextStyle(color: Colors.black, fontSize: 13.0),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
