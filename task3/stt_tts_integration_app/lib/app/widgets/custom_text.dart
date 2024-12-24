
import 'package:flutter/material.dart';
import 'package:stt_tts_integration_app/app/utils/app_colors.dart';


/// Custom text widget with various styling options.
class CustomText extends StatelessWidget {
  final String text;
  final Color? txtColor;
  final double? font;
  final int? maxLine;
  final FontWeight? fntweight;
  final FontStyle? fntstyle;
  final double? letterSpace, lineHeight;
  final TextAlign? txtAlign;
  final TextStyle? textStyle;
  final TextDecoration? textDecoration;
  final bool? softWrap;
  final TextOverflow? ellipsis;
  final GestureTapCallback? nav;

  const CustomText(
      {super.key,
      required this.text,
      this.txtColor,
      this.txtAlign,
      this.font,
      this.maxLine,
      this.fntweight,
      this.fntstyle,
      this.letterSpace,
      this.textStyle,
      this.lineHeight,
      this.textDecoration,
      this.softWrap,
      this.ellipsis,
      this.nav});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: nav,
      child: Text(
        text,
        textAlign: txtAlign,
        softWrap: softWrap,
        overflow: ellipsis,
        maxLines: maxLine,
        style: textStyle ??
            TextStyle(
                decoration: textDecoration ?? TextDecoration.none,
                color: txtColor ?? AppColors.kBlack,
                fontSize: font ?? 14,
                letterSpacing: letterSpace,
                fontStyle: fntstyle ?? FontStyle.normal,
                height: lineHeight,
                fontWeight: fntweight),
      ),
    );
  }
}
