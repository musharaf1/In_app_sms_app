part of 'blog_bloc.dart';

@immutable
sealed class BlogState {}

final class BlogInitial extends BlogState {}

final class BlogLoading extends BlogState {}

final class BlogFailure extends BlogState {
  final String error;

  BlogFailure(this.error);
}

final class BlogSuccess extends BlogState {}

final class GetAllBlogSuccess extends BlogState {
  final List<Blog> blogs;

  GetAllBlogSuccess(this.blogs);
}

final class GetAllBlogFailure extends BlogState {
  final String error;

  GetAllBlogFailure(this.error);
}
