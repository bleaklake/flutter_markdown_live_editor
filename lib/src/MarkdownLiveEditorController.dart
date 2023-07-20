import 'package:dart_markdown/dart_markdown.dart' as dmd;
import 'package:flutter/material.dart';
import 'package:source_span/source_span.dart';

import './MarkdownElement.dart';
import './elements/ParagraphElement.dart';

class MarkdownLiveEditorController extends TextEditingController {
  final _markdown = dmd.Markdown();

  bool isBack(String current, String last) {
    return current.length < last.length;
  }

  MarkdownLiveEditorController({
    required String text
  }) : super(text: text);

  /// Setting this will notify all the listeners of this [TextEditingController]
  /// that they need to update (it calls [notifyListeners]).
  @override
  set text(String newText) {
    value = value.copyWith(
      text: newText,
      selection: const TextSelection.collapsed(offset: -1),
      composing: TextRange.empty,
    );
  }

  final _shamSourceLocation = SourceLocation(0, sourceUrl: "", line: 0, column: 0);
  /// Builds [TextSpan] from current editing value.
  @override
  TextSpan buildTextSpan(
      {required BuildContext context,
      TextStyle? style,
      required bool withComposing}) {

    MarkdownElement.currentText = text;
    MarkdownElement.textSelection = super.selection;

    // AST nodes.
    final nodes = _markdown.parse(text);

    final masterElement = dmd.BlockElement("BlockElement",
        start: _shamSourceLocation,
        end: _shamSourceLocation,
        children: nodes);

    final selectedStyle = Theme.of(context).textTheme.bodyMedium ?? TextStyle();

    final masterParagraph = ParagraphElement(currentElement: masterElement,
        textStyle: selectedStyle,
        context: context);

    if(nodes.isNotEmpty){
      if(nodes.first.start.offset != 0){
        // FIXME : Could be slow
        masterParagraph!.textSpans.insert(0, TextSpan(text:text.substring(0, nodes.first.start.offset), style: selectedStyle));
      }
      if(nodes.last.end.offset != text.length){
        masterParagraph!.textSpans.add(TextSpan(text:text.substring(nodes.last.end.offset), style: selectedStyle));
      }
    }

    return TextSpan(style: style, children: masterParagraph!.textSpans);
  }
}
