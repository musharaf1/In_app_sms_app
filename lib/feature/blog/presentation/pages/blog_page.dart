import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inapp_sms/core/common/widgets/loader.dart';
import 'package:inapp_sms/core/theme/app_pallet.dart';
import 'package:inapp_sms/core/utils/show_snackbar.dart';
import 'package:inapp_sms/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:inapp_sms/feature/blog/presentation/pages/add_new_blog_page.dart';
import 'package:inapp_sms/feature/blog/presentation/widgets/blog_card.dart';

class BlogPage extends StatefulWidget {
  static route() => MaterialPageRoute(
    builder: (context) {
      return const BlogPage();
    },
  );
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();
}

class _BlogPageState extends State<BlogPage> {
  @override
  void initState() {
    context.read<BlogBloc>().add(GetAllBlogsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("blog App"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewBlogPage.route());
            },
            icon: Icon(CupertinoIcons.add_circled),
          ),
        ],
      ),

      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          } else if (state is GetAllBlogSuccess) {
            return ListView.builder(
              itemCount: state.blogs.length,
              itemBuilder: (context, index) {
                final blog = state.blogs[index];
                return BlogCard(
                  blog: blog,
                  color: index % 3 == 0
                      ? AppPallet.kPrimary1
                      : index % 2 == 0
                      ? AppPallet.contentSecondary
                      : AppPallet.contentPrimary,
                );
              },
            );
          }
          return SizedBox();
        },
      ),
    );
  }
}
