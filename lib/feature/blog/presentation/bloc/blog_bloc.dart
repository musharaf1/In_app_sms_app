import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inapp_sms/core/usecase/usecase.dart';
import 'package:inapp_sms/feature/blog/domain/entities/blog.dart';
import 'package:inapp_sms/feature/blog/domain/usecase/get_all_blogs.dart';
import 'package:inapp_sms/feature/blog/domain/usecase/upload_blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog _uploadBlog;

  final GetAllBlogs _getAllBlogs;
  BlogBloc({required UploadBlog uploadBlog, required GetAllBlogs getAllBlogs})
    : _getAllBlogs = getAllBlogs,

      _uploadBlog = uploadBlog,

      super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });

    on<UploadBlogEvent>(_onUploadBlogEvent);

    on<GetAllBlogsEvent>(_onGetAllBagsEvent);
  }

  _onUploadBlogEvent(UploadBlogEvent event, Emitter<BlogState> emit) async {
    final res = await _uploadBlog(
      UploadBlogParams(
        posterId: event.posterId,
        title: event.title,
        content: event.content,
        image: event.image,
        topics: event.topics,
      ),
    );

    res.fold(
      (l) => emit(BlogFailure(l.errorMessage)),
      (r) => emit(BlogSuccess()),
    );
  }

  FutureOr<void> _onGetAllBagsEvent(
    GetAllBlogsEvent event,
    Emitter<BlogState> emit,
  ) async {
    final res = await _getAllBlogs(NoParams());

    res.fold(
      (l) => emit(BlogFailure(l.errorMessage)),
      (r) => emit(GetAllBlogSuccess(r)),
    );
  }
}
