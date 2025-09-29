import 'package:flutter/material.dart';

class AuthField extends StatelessWidget {
  final TextEditingController editingController;
  final String hintText;
  final bool isObscureText;
  const AuthField({
    super.key,
    required this.hintText,
    required this.editingController,
    this.isObscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: isObscureText,
      controller: editingController,
      decoration: InputDecoration(hintText: hintText),
      validator: (value) {
        if (value!.isEmpty) {
          return "You forgot to enter the right parameter";
        }
        return null;
      },
    );
  }
}
