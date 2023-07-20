import 'package:flutter/material.dart';
import '../MarkdownBlockElement.dart';

class ParagraphElement extends MarkdownBlockElement{
  @override
  late List<TextSpan> textSpans = [];

  ParagraphElement({required super.currentElement, required super.textStyle, required super.context});

  @override
  setTextStyle(){
    textStyle = super.textStyle.copyWith();
  }

}