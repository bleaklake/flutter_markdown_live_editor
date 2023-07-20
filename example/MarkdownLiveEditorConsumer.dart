import 'package:flutter/material.dart';
import 'package:markdown_live_editor/markdown_live_editor.dart';

class MarkdownLiveEditorConsumer extends StatefulWidget {
  MarkdownLiveEditorConsumer({super.key});

  @override
  State<MarkdownLiveEditorConsumer> createState() =>
      _MarkdownLiveEditorConsumerState();
}

class _MarkdownLiveEditorConsumerState
    extends State<MarkdownLiveEditorConsumer> {
  String _text = "# Big **Title**\n***description***";

  handleChanged(String s) {
    print(s);
    _text = s;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: SingleChildScrollView(
                child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(children: [
                      TextFormField(
                          minLines: 1,
                          maxLines: 100,
                          onChanged: handleChanged,
                          controller: MarkdownLiveEditorController(text: _text))
                    ])))));
  }
}
