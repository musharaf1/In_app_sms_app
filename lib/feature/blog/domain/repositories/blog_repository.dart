import 'dart:io';
import 'package:fpdart/fpdart.dart';
import 'package:inapp_sms/core/error/failure.dart';
import 'package:inapp_sms/feature/blog/domain/entities/blog.dart';

abstract interface class BlogRepository {
  Future<Either<Failure, Blog>> uploadBlog({
    required File image,
    required title,
    required content,
    required posterId,
    required List<String> topics,
  });
}
