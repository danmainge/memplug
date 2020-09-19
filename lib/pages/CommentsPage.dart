import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:memeplug/pages/HomePage.dart';
import 'package:memeplug/widgets/constants.dart';
import 'package:memeplug/widgets/dart/HeaderWidget.dart';
import 'package:memeplug/widgets/dart/ProgressWidget.dart';
import 'package:timeago/timeago.dart' as tAgo;

class CommentsPage extends StatefulWidget {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;
  CommentsPage({this.postId, this.postOwnerId, this.postImageUrl});
  @override
  CommentsPageState createState() => CommentsPageState(
      postId: postId, postOwnerId: postOwnerId, postImageUrl: postImageUrl);
}

class CommentsPageState extends State<CommentsPage> {
  final String postId;
  final String postOwnerId;
  final String postImageUrl;
  TextEditingController commentTextEditingController = TextEditingController();

  CommentsPageState({this.postId, this.postOwnerId, this.postImageUrl});
  retriveComments() {
    return StreamBuilder(
      stream: commentsReference
          .document(postId)
          .collection('comments')
          .orderBy('timestamp', descending: false)
          .snapshots(),
      builder: (context, dataSnapshot) {
        if (!dataSnapshot.hasData) {
          return circularProgress();
        }
        List<Comment> comments = [];
        dataSnapshot.data.documents.forEach((document) {
          comments.add(Comment.fromDocument(document));
        });
        return ListView(children: comments);
      },
    );
  }

  addComment() {
    commentsReference.document(postId).collection('comments').add({
      'username': currentUser.username,
      'comment': commentTextEditingController.text,
      'timestamp': DateTime.now(),
      'url': currentUser.url,
      'userId': currentUser.id
    });
    bool isNotPostOwner = postOwnerId != currentUser.id;
    if (isNotPostOwner) {
      activityFeedReference.document(postOwnerId).collection('feedItems').add({
        'type': 'comment',
        'commmentDate': timestamp,
        'postId': postId,
        'userId': currentUser.id,
        'username': currentUser.username,
        'userProfileImg': currentUser.url,
        'url': postImageUrl,
      });
    }
    commentTextEditingController.clear();
    print(Text('publish button clicked'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: 'comments'),
      body: Container(
        margin: EdgeInsets.only(bottom: 10.0),
        child: Column(
          children: <Widget>[
            Expanded(child: retriveComments()),
            Divider(),
            Container(
              color: Colors.grey[700],
              child: Row(
                children: [
                  Expanded(
                      child: ListTile(
                    title: TextFormField(
                      controller: commentTextEditingController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'write comment ...',
                        hintStyle: TextStyle(color: Colors.grey),
                        fillColor: Colors.black,
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kButtonColor),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: kButtonColor),
                        ),
                      ),
                    ),
                    trailing: OutlineButton.icon(
                      onPressed: addComment,
                      color: kButtonColor,
                      icon: Icon(
                        Icons.add_comment,
                      ),
                      label: Text(
                        'publish',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Comment extends StatelessWidget {
  final String username;
  final String userId;
  final String url;
  final String comment;
  final Timestamp timestamp;

  Comment({this.username, this.userId, this.url, this.comment, this.timestamp});
  factory Comment.fromDocument(DocumentSnapshot documentSnapshot) {
    return Comment(
      username: documentSnapshot['username'],
      userId: documentSnapshot['userId'],
      url: documentSnapshot['url'],
      comment: documentSnapshot['comment'],
      timestamp: documentSnapshot['timestamp'],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.0),
      child: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                username + ':' + comment,
                style: TextStyle(color: Colors.white),
              ),
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(url),
              ),
              subtitle: Text(
                tAgo.format(timestamp.toDate()),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
