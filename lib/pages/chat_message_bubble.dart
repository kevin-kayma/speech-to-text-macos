// ignore_for_file: deprecated_member_use

import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/extension/context_extension.dart';
import 'package:transcribe/extension/padding_extension.dart';
import 'package:transcribe/models/chat_message.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessage message;
  final bool isTyping; // New property to indicate if this bubble is the typing indicator

  const ChatMessageBubble({super.key, required this.message, this.isTyping = false});

  @override
  Widget build(BuildContext context) {
    final bool isUser = message.sender == MessageSender.user;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: isUser ? AppTheme.darkFontColor : AppTheme.darkFontColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16.0),
            topRight: const Radius.circular(16.0),
            bottomLeft: isUser
                ? const Radius.circular(16.0)
                : (isTyping ? const Radius.circular(16.0) : const Radius.circular(4.0)),
            bottomRight: isUser
                ? const Radius.circular(4.0)
                : (isTyping ? const Radius.circular(16.0) : const Radius.circular(16.0)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            if (isTyping)
              const TypingIndicator() // Show typing indicator if bot is typing
            else if (isUser)
              Text(
                message.text,
                style: TextStyle(color: AppTheme.lightFontColor, fontSize: 14),
              )
            else
              MarkdownBody(
                data: message.text,
                selectable: true,
                styleSheet: MarkdownStyleSheet(
                  a: TextStyle(color: AppTheme.lightFontColor),
                  p: TextStyle(color: AppTheme.lightFontColor),
                ),
              ),
            const SizedBox(height: 4),
            if (!isTyping) // Hide timestamp when typing
              Text(
                DateFormat('hh:mm a').format(message.timestamp), // Format timestamp
                style: TextStyle(color: AppTheme.lightFontColor.withAlpha(150), fontSize: 10),
              ),
          ],
        ),
      ).paddingOnly(left: isUser ? context.width * 0.1 : 0, right: isUser ? 0 : context.width * 0.1),
    );
  }
}

class TypingIndicator extends StatefulWidget {
  const TypingIndicator({super.key});

  @override
  State<TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<TypingIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _dotAnimations;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();

    _dotAnimations = List.generate(3, (index) {
      return Tween<double>(begin: 0.0, end: -5.0).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(
            (0.1 + (index * 0.2)),
            (0.6 + (index * 0.2)),
            curve: Curves.easeInOutSine,
          ),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _dotAnimations[index].value),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2.0),
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: AppTheme.lightFontColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
