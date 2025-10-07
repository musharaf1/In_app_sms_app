import 'package:hive/hive.dart';
import 'package:inapp_sms/feature/blog/data/models/blog_model.dart';

abstract interface class BlogLocalDataSource {
  void uploadLocalBlogs({required List<BlogModel> blogs});

  List<BlogModel> fetchBlogs();
}

class BlogLocalDataSourceImp implements BlogLocalDataSource {
  final Box box;

  BlogLocalDataSourceImp(this.box);

  @override
  List<BlogModel> fetchBlogs() {
    final List<BlogModel> blogs = [];

    box.read(() {
      for (int i = 0; i < box.length; i++) {
        blogs.add(BlogModel.fromJson(box.get(i.toString())));
      }
    });

    return blogs;
  }

  @override
  void uploadLocalBlogs({required List<BlogModel> blogs}) {
    box.clear();

    box.write(() {
      for (int i = 0; i < blogs.length; i++) {
        box.put(i.toString(), blogs[i].toJson());
      }
    });
  }
}
