// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zoom_tap_animation/zoom_tap_animation.dart';

class confirm_dialog extends StatefulWidget {
  final icon;
  final text;
  final IconColor;
  final Function() funzione;

  confirm_dialog({
    super.key,
    required this.funzione,
    required this.icon,
    required this.text,
    required this.IconColor
  });

  @override
  State<confirm_dialog> createState() => _confirm_dialogState();
}

class _confirm_dialogState extends State<confirm_dialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ZoomTapAnimation(
              onTap: () {Navigator.pop(context); widget.funzione();},
              child: Icon(Icons.check, color: Colors.green,),
            ),
            ZoomTapAnimation(
              onTap: () {Navigator.pop(context);},
              child: Icon(Icons.close, color: Colors.red,),
            ),
          ],
        )

      ],
      backgroundColor: Colors.black,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(width: 1, color: Colors.red)
      ),
      icon: Icon(
        widget.icon,
        color: widget.IconColor,
        size: 50,
      ),
      title: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: const TextStyle(
            fontFamily: 'SF-Pro',
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: TextDecoration.none,
            letterSpacing: 1,
          ),
          children: [
            TextSpan(
              text: widget.text,
            ),
          ],
        ),
      )
    
    );
  }
}
