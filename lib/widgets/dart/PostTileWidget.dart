import 'package:flutter/material.dart';
import 'package:memeplug/widgets/dart/PostWidget.dart';

class PostTile extends StatelessWidget {
  final Post post;
  PostTile(this.post);
  // PostTile(Post eachPost, {this.post});
  displayFullPost(context) {}
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => displayFullPost(context),
      child: Image.network(post.url),
      // child: Text('hi')
    );
  }
}
