import 'package:flutter/material.dart';
import '../MarkdownBlockElement.dart';
import '../MarkdownElement.dart';

class HeadingElement extends MarkdownBlockElement {
  @override
  late List<TextSpan> textSpans = [];

  HeadingElement(
      {required super.currentElement,
      required super.textStyle,
      required super.context});

  @override
  setTextStyle() {
    final tt = Theme.of(context).textTheme;
    TextStyle? t;
    switch (super.currentElement.markers.first.text.length) {
      case 1:
        t = tt.headlineLarge;
        break;
      case 2:
        t = tt.headlineMedium;
        break;
      case 3:
        t = tt.headlineSmall;
        break;
      case 4:
        t = tt.titleLarge;
        break;
      case 5:
        t = tt.titleMedium;
        break;
      case 6:
      default:
        t = tt.titleSmall;
        break;
    }
    if (t == null) return;
    textStyle = t.copyWith();
  }

  int indexOfPosition(String text, String pattern, int position) {
    int currentIndex = 0;
    for (var i = 0; i <= position; i++) {
      currentIndex = text.indexOf(pattern, currentIndex) + pattern.length;
      if (currentIndex == -1) return -1;
    }
    return currentIndex - pattern.length;
  }

  @override
  bool checkSelected() {
    var startLine = indexOfPosition(
        MarkdownElement.currentText, "\n", currentElement.start.line - 1);
    if (startLine == -1) {
      startLine = 0;
    }
    var endLine = MarkdownElement.currentText.indexOf("\n", startLine + 1);
    if (endLine == -1) {
      endLine = MarkdownElement.currentText.length;
    }

    final isBaseInside =
        (startLine <= MarkdownElement.textSelection!.baseOffset) &&
            (MarkdownElement.textSelection!.baseOffset <= endLine);

    if (isBaseInside) return true;

    final isExtentInside =
        (startLine <= MarkdownElement.textSelection!.extentOffset) &&
            (MarkdownElement.textSelection!.extentOffset <= endLine);

    if (isExtentInside) return true;

    final isSurrended =
        (MarkdownElement.textSelection!.baseOffset <= startLine) &&
            (endLine <= MarkdownElement.textSelection!.extentOffset);

    return isSurrended;
  }
}
