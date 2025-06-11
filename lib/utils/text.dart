import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextGlobalWidget extends StatelessWidget {
  final String text;
  final double fontSize;
  final FontWeight? fontWeight;
  final TextAlign? textAlign;
  final Color? fontColor;
  final FontStyle? fontStyle;
  final TextOverflow? textOverflow;
  final int? maxLines;

  const TextGlobalWidget({
    super.key,
    required this.text,
    required this.fontSize,
    this.fontWeight,
    this.textAlign,
    this.fontColor = Colors.white,
    this.fontStyle,
    this.textOverflow,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      overflow: textOverflow ?? TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: textAlign,
      style: GoogleFonts.poppins(
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        color: fontColor,
      ),
    );
  }
}
