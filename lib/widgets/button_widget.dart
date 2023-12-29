import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget{
  ButtonWidget({required this.labelText,required this.onPressed});
  final String labelText;
  void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
   return Container(width: 300,
       height: 45,
       decoration: BoxDecoration(
           borderRadius: BorderRadius.circular(10), color: Colors.amber),
       child: GestureDetector(
         onTap: onPressed,
           child: Center(
               child: Text(labelText,style: TextStyle(
                 color: Colors.white, // Set the text color here
               ),),),),

   );
  }

}