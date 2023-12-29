import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget{
  TextFieldWidget({required this.labelText,required this.textEditingController,required this.isPassword});
  TextEditingController textEditingController = TextEditingController();
  final String labelText;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 45.0,
        child:
            TextField(
              controller: textEditingController,
              obscureText: isPassword,
              decoration: InputDecoration(
                  hintText: labelText
              ),
            ),

    );
  }

}