import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inapp_sms/feature/blog/domain/usecase/upload_blog.dart';

part 'blog_event.dart';
part 'blog_state.dart';

class BlogBloc extends Bloc<BlogEvent, BlogState> {
  final UploadBlog uploadBlog;
  BlogBloc(this.uploadBlog) : super(BlogInitial()) {
    on<BlogEvent>((event, emit) {
      emit(BlogLoading());
    });

    on<UploadBlogEvent>(_onUploadBlogEvent);
  }

  _onUploadBlogEvent(UploadBlogEvent event, Emitter<BlogState> emit) async {
    final res = await uploadBlog(
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
}
