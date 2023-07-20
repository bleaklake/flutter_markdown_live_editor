import './MarkdownElement.dart';

abstract class MarkdownTextElement extends MarkdownElement{
  String text;

  MarkdownTextElement({required this.text, required super.context, required super.textStyle}){
    draw(false);
  }
}
