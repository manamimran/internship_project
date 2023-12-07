import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TextFieldWidget extends StatelessWidget{
  TextFieldWidget({required this.labelText,required this.textEditingController});
  TextEditingController textEditingController = TextEditingController();
  final String labelText;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300.0,
      height: 45.0,
        child:
            TextField(
              controller: textEditingController,
              decoration: InputDecoration(
                  hintText: labelText
              ),
            )

    );
  }


}