import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  const CustomFormTextField({
    super.key,
    this.onChanged,
    this.hintText,
    this.obscureText = false,
  });

  final Function(String)? onChanged;
  final String? hintText;
  final bool obscureText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      style: const TextStyle(color: Colors.white), // 👈 هنا يخلي النص الأبيض

      obscureText: obscureText,
      validator: (data){
        if(data == null || data.isEmpty){
          return 'field is required';
        }
        return null;
      },
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: Colors.white70, // 👈 لون فاتح وواضح على الخلفية الغامقة
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.white
            ),
            ),
      ),
    );
  }
}
