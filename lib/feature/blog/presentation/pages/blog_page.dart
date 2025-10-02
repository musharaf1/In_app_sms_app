import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:inapp_sms/feature/blog/presentation/pages/add_new_blog_page.dart';

class BlogPage extends StatelessWidget {
  static route() => MaterialPageRoute(
    builder: (context) {
      return const BlogPage();
    },
  );
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("blog App"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),
    );
  }
}
