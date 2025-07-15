// ignore_for_file: deprecated_member_use

import 'package:flutter/scheduler.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/controllers/chat_controller.dart';
import 'package:transcribe/extension/string_extension.dart';
import 'package:transcribe/models/chat_message.dart';
import 'package:transcribe/pages/chat_message_bubble.dart';
import 'package:transcribe/providers/providers.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({required this.audioId, super.key, required this.transcript});
  final String transcript;
  final int audioId;

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      final audioModel = ref.read(audioListProvider.notifier).getAudioById(widget.audioId);
      ref.read(chatbotProvider).initMessageScreen(audioModel?.chatList ?? []);
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final chatbotState = ref.watch(chatbotProvider);
    final chatbotNotifier = ref.read(chatbotProvider);

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        foregroundColor: AppTheme.lightFontColor,
        automaticallyImplyLeading: false,
        centerTitle: true,
        leading: !chatbotState.isBotTyping && !chatbotState.isLoading
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : const SizedBox(),
        leadingWidth: 60,
        title: const Text(
          'Transcribe AI',
          style: TextStyle(fontSize: 18),
          overflow: TextOverflow.ellipsis,
        ),
        actions: const [SizedBox(width: 60)],
      ),
      body: Column(
        children: [
          if (chatbotState.errorMessage != null)
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Colors.red.withAlpha(150),
              alignment: Alignment.center,
              child: Text(
                chatbotState.errorMessage ?? '',
                style: TextStyle(color: Colors.red.withAlpha(200)),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16.0),
              itemCount: chatbotState.chatHistory.length + (chatbotState.isBotTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == chatbotState.chatHistory.length && chatbotState.isBotTyping) {
                  return ChatMessageBubble(
                    message: ChatMessage(
                      text: chatbotState.typingMessageContent,
                      timestamp: DateTime.now(),
                      sender: MessageSender.bot,
                    ),
                    isTyping: chatbotState.isBotTyping && chatbotState.typingMessageContent.isEmptyString,
                  );
                }
                final message = chatbotState.chatHistory[index];
                return ChatMessageBubble(message: message);
              },
            ),
          ),
          if (chatbotState.isLoading && chatbotState.typingMessageContent.isEmptyString)
            const LinearProgressIndicator(color: AppTheme.lightFontColor),
          _buildMessageInput(chatbotNotifier),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMessageInput(ChatbotNotifier notifier) {
    final bool isInputDisabled = notifier.isLoading || notifier.isBotTyping;

    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              onChanged: (text) => notifier.updateInputMessage(text),
              enabled: !isInputDisabled,
              decoration: InputDecoration(
                hintText: 'Type your message...',
                hintStyle: const TextStyle(color: AppTheme.lightFontColor),
                filled: true,
                fillColor: isInputDisabled ? AppTheme.darkFontColor.withOpacity(0.5) : AppTheme.darkFontColor,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25.0),
                  borderSide: BorderSide(
                    color: isInputDisabled ? AppTheme.lightFontColor : AppTheme.lightFontColor,
                    width: 2.0,
                  ), // Muted border if disabled
                ),
              ),
              style: TextStyle(
                color: isInputDisabled ? AppTheme.lightFontColor : AppTheme.lightFontColor,
              ),
              cursorColor: AppTheme.lightFontColor,
            ),
          ),
          const SizedBox(width: 6),
          SizedBox(
            height: 50,
            width: 50,
            child: FloatingActionButton(
              onPressed: isInputDisabled || _messageController.text.trim().isEmpty
                  ? null
                  : () {
                      Utils.sendAnalyticsEvent(AnalyticsEvents.sendChat);
                      if (Utils.isCanAccess(CanAccess.chatbot)) {
                        notifier.sendMessage(ref, context, _messageController.text, widget.transcript, widget.audioId);
                        _messageController.clear();
                      } else {
                        StoreConfig.showSubscription(context);
                      }
                    },
              backgroundColor: isInputDisabled ? AppTheme.darkFontColor : AppTheme.primaryColor,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
              child: const Center(
                child: Icon(
                  Icons.send_rounded,
                  color: AppTheme.staticBlackColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
