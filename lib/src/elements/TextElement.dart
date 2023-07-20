import 'package:flutter/widgets.dart';
import '../MarkdownTextElement.dart';

class TextElement extends MarkdownTextElement{
  @override
  late List<TextSpan> textSpans = [];

  TextElement({required super.text, required super.textStyle, required super.context});

  @override
  draw(bool isSelected) {
    textSpans = [TextSpan(text:text, style: super.textStyle)];
  }
}