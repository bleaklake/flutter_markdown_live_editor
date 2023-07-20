import 'package:dart_markdown/dart_markdown.dart' as dmd;
import 'package:flutter/material.dart';
import 'package:collection/collection.dart';

import './helpers/types.dart';
import 'MarkdownElement.dart';
import 'elements/ParagraphElement.dart';
import 'elements/StrongEmphasisElement.dart';
import 'elements/EmphasisElement.dart';
import 'elements/HeadingElement.dart';
import 'elements/TextElement.dart';

abstract class MarkdownBlockElement extends MarkdownElement {
  dmd.Element currentElement;
  List<MarkdownElement> childrenElements = [];

  static final ALL_TUPLE_ELEMENTS = [
    Tuple(["paragraph"], ParagraphElement.new),
    Tuple(["strongEmphasis"], StrongEmphasisElement.new),
    Tuple(["emphasis"], EmphasisElement.new),
    Tuple(["atxHeading"], HeadingElement.new),
  ];

  // bulletList
  // listItem

  MarkdownBlockElement(
      {required this.currentElement,
      required super.context,
      required super.textStyle}) {
    setTextStyle();
    currentElement.children.forEachIndexed((i, it) {
      if (i != 0) {
        final previousChildElement = currentElement.children[i - 1];
        if (it.start.offset != previousChildElement.end.offset) {
          childrenElements.add(TextElement(
              text: MarkdownElement.currentText
                  .substring(previousChildElement.end.offset, it.start.offset),
              textStyle: textStyle,
              context: context));
        }
      }
      switch (it.runtimeType) {
        case dmd.BlockElement:
        case dmd.InlineElement:
          it = it as dmd.Element;
          var selectedElement = ALL_TUPLE_ELEMENTS.firstWhereOrNull(
              (e) => e.first.contains((it as dmd.Element).type));
          if (selectedElement == null) {
            print("📕 Missing Element ${it.type}");
            selectedElement = ALL_TUPLE_ELEMENTS.first;
          }
          childrenElements.add(selectedElement.second(
              currentElement: it, textStyle: textStyle, context: context));
          break;
        case dmd.Text:
        default:
          it = it as dmd.Text;
          childrenElements.add(TextElement(
              text: it.text, textStyle: textStyle, context: context));
          break;
      }
    });

    if(MarkdownElement.textSelection == null) {
      draw(true);
      return;
    }

    draw(checkSelected());
  }

  bool checkSelected(){
    final isBaseInside =
        (currentElement.start.offset <= MarkdownElement.textSelection!.baseOffset) &&
            (MarkdownElement.textSelection!.baseOffset <= currentElement.end.offset);

    final isExtentInside =
        (currentElement.start.offset <= MarkdownElement.textSelection!.extentOffset) &&
            (MarkdownElement.textSelection!.extentOffset <= currentElement.end.offset);

    return isBaseInside || isExtentInside;
  }

  void setTextStyle();

  List<TextSpan> drawChildren() {
    return childrenElements.expandIndexed((i, e) {
      final res = e.textSpans;
      if (i != 0) {}
      return res;
    }).toList();
  }

  @override
  draw(bool isSelected) {
    textSpans.clear();

    if (this.currentElement.markers.isNotEmpty) {
      final paddingStart = this.currentElement.children.isEmpty ? "" : MarkdownElement.currentText.substring(
          this.currentElement.markers.first.end.offset,
          this.currentElement.children.first.start.offset);
      String text = this.currentElement.markers.first.text + paddingStart;
      textSpans.addAll(TextElement(
              text: isSelected ? text : ("\u{200B}" * text.length),
              textStyle: textStyle,
              context: context)
          .textSpans);
    }

    textSpans.addAll(this.drawChildren());

    if (this.currentElement.markers.length > 1) {
      final paddingEnd = this.currentElement.children.isEmpty ? "" : MarkdownElement.currentText.substring(
          this.currentElement.children.last.end.offset,
          this.currentElement.markers.last.start.offset);
      String text = paddingEnd + this.currentElement.markers[1].text;
      textSpans.addAll(TextElement(
              text: isSelected ? text : ("\u{200B}" * text.length),
              textStyle: textStyle,
              context: context)
          .textSpans);
    }
  }
}
