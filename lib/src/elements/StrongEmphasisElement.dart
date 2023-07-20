import 'package:flutter/widgets.dart';
import '../MarkdownBlockElement.dart';

class StrongEmphasisElement extends MarkdownBlockElement{
  @override
  late List<TextSpan> textSpans = [];

  StrongEmphasisElement({required super.currentElement, required super.textStyle, required super.context});

  @override
  setTextStyle(){
    textStyle = super.textStyle.copyWith(fontWeight: FontWeight.w600);
  }
}