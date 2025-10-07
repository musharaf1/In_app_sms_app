import 'package:flutter/material.dart';
import 'package:inapp_sms/core/utils/calculate_reading_time.dart';
import 'package:inapp_sms/feature/blog/domain/entities/blog.dart';
import 'package:inapp_sms/feature/blog/presentation/pages/blog_viewer_page.dart';

class BlogCard extends StatelessWidget {
  final Blog blog;
  final Color color;
  const BlogCard({super.key, required this.blog, required this.color});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(context, BlogViewerPage.route(blog)),
      child: Container(
        margin: EdgeInsets.all(16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        // height: 200,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: blog.topics
                        .map(
                          (topic) => Padding(
                            padding: EdgeInsets.all(5),
                            child: Chip(label: Text(topic)),
                          ),
                        )
                        .toList(),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  blog.title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),

                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),

            Text(
              "${calculateReadingTime(blog.content)} min",
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
      ),
    );
  }
}
