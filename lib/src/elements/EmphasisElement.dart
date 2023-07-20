import 'package:flutter/widgets.dart';
import '../MarkdownBlockElement.dart';

class EmphasisElement extends MarkdownBlockElement{
  @override
  late List<TextSpan> textSpans = [];

  EmphasisElement({required super.currentElement, required super.textStyle, required super.context});

  @override
  setTextStyle(){
    textStyle = super.textStyle.copyWith(fontStyle: FontStyle.italic);
  }
}