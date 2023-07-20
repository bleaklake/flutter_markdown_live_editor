import 'package:flutter/material.dart';

abstract class MarkdownElement {
  BuildContext context;
  TextStyle textStyle;
  abstract List<TextSpan> textSpans;

  static TextSelection? textSelection;
  static String currentText = "";

  MarkdownElement({required this.context, required this.textStyle});

  draw(bool isSelected);
}
