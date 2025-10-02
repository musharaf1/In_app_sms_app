import 'dart:io';

import 'package:fpdart/fpdart.dart';
import 'package:inapp_sms/core/error/exception.dart';
import 'package:inapp_sms/core/error/failure.dart';
import 'package:inapp_sms/feature/blog/data/datasources/blog_remote_data_source.dart';
import 'package:inapp_sms/feature/blog/data/models/blog_model.dart';
import 'package:inapp_sms/feature/blog/domain/entities/blog.dart';
import 'package:inapp_sms/feature/blog/domain/repositories/blog_repository.dart';
import 'package:uuid/uuid.dart';

class BlogRepositoryImpl implements BlogRepository {
  final BlogRemoteDataSource blogRemoteDataSource;

  BlogRepositoryImpl({required this.blogRemoteDataSource});

  @override
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required title,
    required content,
    required posterId,
    required List<String> topics,
  }) async {
    try {
      BlogModel blogModel = BlogModel(
        id: const Uuid().v1(),
        posterId: posterId,
        title: title,
        content: content,
        imageUrl: '',
        topics: topics,
        updatedAt: DateTime.now(),
      );

      final imageUrl = await blogRemoteDataSource.uploadBlogImage(
        image: image,
        blog: blogModel,
      );

      blogModel = blogModel.copyWith(imageUrl: imageUrl);

      final uploadedBlogModel = await blogRemoteDataSource.uploadBlog(
        blogModel,
      );
      return right(uploadedBlogModel);
    } on ServerException catch (e) {
      return left(Failure(e.message));
    }
  }
}
