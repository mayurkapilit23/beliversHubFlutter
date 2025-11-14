import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? hint;
  final TextEditingController controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final suffixIcon;
  final void Function(String)? onChanged;
  final String? Function(String?)? validator;

  const CustomTextField({
    super.key,
    // required this.label,
    required this.controller,
    this.hint,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: TextFormField(
        style: TextStyle(color: Colors.black, fontSize: 16),

        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        onChanged: onChanged,
        validator: validator,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15.0,
            vertical: 14.0,
          ),
          border: InputBorder.none,

          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 14),

          suffixIcon: suffixIcon,
          suffixIconColor: Colors.grey,
        ),
      ),
    );
  }
}
