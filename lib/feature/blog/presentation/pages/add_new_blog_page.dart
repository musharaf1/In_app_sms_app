import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:inapp_sms/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:inapp_sms/core/common/widgets/loader.dart';
import 'package:inapp_sms/core/theme/app_pallet.dart';
import 'package:inapp_sms/core/utils/pick_image.dart';
import 'package:inapp_sms/core/utils/show_snackbar.dart';
import 'package:inapp_sms/feature/blog/presentation/bloc/blog_bloc.dart';
import 'package:inapp_sms/feature/blog/presentation/pages/blog_page.dart';
import 'package:inapp_sms/feature/blog/presentation/widgets/blog_editor.dart';

class AddNewBlogPage extends StatefulWidget {
  static route() =>
      MaterialPageRoute(builder: (context) => const AddNewBlogPage());
  const AddNewBlogPage({super.key});

  @override
  State<AddNewBlogPage> createState() => _AddNewBlogPageState();
}

class _AddNewBlogPageState extends State<AddNewBlogPage> {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  File? image;
  void selectImage() async {
    final pickedImage = await pickImage();

    if (pickedImage != null) {
      setState(() {
        image = pickedImage;
      });
    }
  }

  final selectedTopics = <String>[];

  void uploadBlog() {
    if (formKey.currentState!.validate() &&
        selectedTopics.isNotEmpty &&
        image != null) {
      final posterId =
          (context.read<AppUserCubit>().state as AppUserLoggedIn).user.id;

      context.read<BlogBloc>().add(
        UploadBlogEvent(
          posterId,
          titleController.text.trim(),
          contentController.text.trim(),
          image!,
          selectedTopics,
        ),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              uploadBlog();
            },
            icon: Icon(Icons.done_rounded),
          ),
        ],
      ),

      body: BlocConsumer<BlogBloc, BlogState>(
        listener: (context, state) {
          if (state is BlogFailure) {
            showSnackbar(context, state.error);
          } else if (state is BlogSuccess) {
            Navigator.pushAndRemoveUntil(
              context,
              BlogPage.route(),
              (route) => false,
            );
          }
        },
        builder: (context, state) {
          if (state is BlogLoading) {
            return const Loader();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    image != null
                        ? GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: SizedBox(
                              height: 150,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(image!, fit: BoxFit.cover),
                              ),
                            ),
                          )
                        : GestureDetector(
                            onTap: () {
                              selectImage();
                            },
                            child: DottedBorder(
                              options: RoundedRectDottedBorderOptions(
                                strokeCap: StrokeCap.round,
                                color: AppPallet.borderColor,
                                dashPattern: [10, 4],
                                radius: Radius.circular(10),
                              ),

                              child: SizedBox(
                                height: 150,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.folder_open, size: 40),
                                    SizedBox(height: 15),
                                    Text(
                                      "Select your image",
                                      style: TextStyle(fontSize: 15),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                    SizedBox(height: 20),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children:
                            [
                              "Technology",
                              "Business",
                              "Programming",
                              "Entertainment",
                            ].map((e) {
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (selectedTopics.contains(e)) {
                                      selectedTopics.remove(e);
                                    } else {
                                      selectedTopics.add(e);
                                    }

                                    setState(() {});
                                  },
                                  child: Chip(
                                    color: WidgetStatePropertyAll(
                                      selectedTopics.contains(e)
                                          ? AppPallet.pendingColor
                                          : null,
                                    ),
                                    side: selectedTopics.contains(e)
                                        ? null
                                        : BorderSide(
                                            color: AppPallet.borderColor,
                                          ),
                                    label: Text(e),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                    SizedBox(height: 10),
                    BlogEditor(
                      controller: titleController,
                      hintText: "Blog title",
                    ),
                    SizedBox(height: 10),
                    BlogEditor(
                      controller: contentController,
                      hintText: "Blog Content",
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
