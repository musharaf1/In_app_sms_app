import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:inapp_sms/core/error/failure.dart';
import 'package:inapp_sms/core/usecase/usecase.dart';
import 'package:inapp_sms/feature/blog/domain/entities/blog.dart';
import 'package:inapp_sms/feature/blog/domain/repositories/blog_repository.dart';

class UploadBlog implements UseCase<Blog, UploadBlogParams> {
  final BlogRepository blogRepository;

  UploadBlog(this.blogRepository);
  @override
  Future<Either<Failure, Blog>> call(UploadBlogParams params) async {
    return await blogRepository.uploadBlog(
      image: params.image,
      title: params.title,
      content: params.content,
      posterId: params.posterId,
      topics: params.topics,
    );
  }
}

class UploadBlogParams {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogParams({
    required this.posterId,
    required this.title,
    required this.content,
    required this.image,
    required this.topics,
  });
}
