import 'package:flutter/material.dart';

class CustomFormTextField extends StatelessWidget {
  CustomFormTextField({super.key, this.onChanged, this.hintText});
  Function(String)? onChanged;

  String? hintText;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
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
