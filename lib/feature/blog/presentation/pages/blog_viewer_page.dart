import 'package:flutter/material.dart';
import 'package:inapp_sms/core/theme/app_pallet.dart';
import 'package:inapp_sms/core/utils/calculate_reading_time.dart';
import 'package:inapp_sms/core/utils/format_date.dart';
import 'package:inapp_sms/feature/blog/domain/entities/blog.dart';

class BlogViewerPage extends StatelessWidget {
  final Blog blog;

  static route(Blog blog) =>
      MaterialPageRoute(builder: (context) => BlogViewerPage(blog: blog));
  const BlogViewerPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Scrollbar(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  blog.title,
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 10),

                Text(
                  "By ${blog.posterName}",
                  style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
                ),
                SizedBox(height: 10),

                Text(
                  "${formatDateBydMMMYYYY(blog.updatedAt)} . ${calculateReadingTime(blog.content)} min",

                  style: TextStyle(
                    color: AppPallet.contentSecondary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                SizedBox(height: 20),

                ClipRRect(
                  borderRadius: BorderRadiusGeometry.circular(10),
                  child: Image.network(blog.imageUrl),
                ),

                SizedBox(height: 20),

                Text(blog.content, style: TextStyle(fontSize: 16, height: 2)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
