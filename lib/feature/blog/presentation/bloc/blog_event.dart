part of 'blog_bloc.dart';

@immutable
sealed class BlogEvent {}

class UploadBlogEvent extends BlogEvent {
  final String posterId;
  final String title;
  final String content;
  final File image;
  final List<String> topics;

  UploadBlogEvent(
    this.posterId,
    this.title,
    this.content,
    this.image,
    this.topics,
  );
}

sealed class UploadImage extends BlogEvent {}
