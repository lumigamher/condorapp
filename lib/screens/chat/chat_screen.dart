import 'package:condorapp/widgets/message_bubble.dart';
import 'package:condorapp/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/chat_provider.dart';
import '../../theme.dart';


class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _initChat();
  }

  void _initChat() async {
    await context.read<ChatProvider>().getChatHistory();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Mi Señor Jesús",
          style: theme.textTheme.headlineSmall?.copyWith(
            color: AppColors.accent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.background,
              AppColors.background.withOpacity(0.95),
            ],
          ),
        ),
        child: Consumer<ChatProvider>(
          builder: (context, chatProvider, child) {
            return Column(
              children: [
                if (chatProvider.error != null)
                  Container(
                    color: theme.colorScheme.error.withOpacity(0.1),
                    padding: EdgeInsets.all(8),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            chatProvider.error!,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.error,
                            ),
                          ),
                        ),
                        IconButton(
                          icon: Icon(LucideIcons.xCircle, color: theme.colorScheme.error),
                          onPressed: chatProvider.clearError,
                        ),
                      ],
                    ),
                  ).animate().fadeIn().moveY(begin: -200, end: 0, duration: 500.ms, curve: Curves.easeOut),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    padding: EdgeInsets.only(bottom: 20),
                    itemCount: chatProvider.messages.length,
                    itemBuilder: (context, index) {
                      return MessageBubble(
                        message: chatProvider.messages[index],
                      ).animate()
                        .fadeIn(duration: 300.ms)
                        .slideX(
                          begin: chatProvider.messages[index].fromAI ? -0.2 : 0.2,
                          duration: 300.ms,
                          curve: Curves.easeOutQuad,
                        );
                    },
                  ),
                ),
                if (chatProvider.isLoading)
                  TypingIndicator().animate().fadeIn(),
                _buildInputArea(chatProvider, theme),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputArea(ChatProvider chatProvider, ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.2),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: "Escribe un mensaje...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(16),
                        hintStyle: TextStyle(color: AppColors.primary.withOpacity(0.5)),
                      ),
                      enabled: !chatProvider.isLoading,
                      onSubmitted: (text) {
                        if (!chatProvider.isLoading) {
                          _sendMessage(chatProvider);
                        }
                      },
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 300),
                    margin: EdgeInsets.only(right: 8),
                    child: IconButton(
                      onPressed: chatProvider.isLoading 
                        ? null 
                        : () => _sendMessage(chatProvider),
                      icon: Icon(
                        LucideIcons.send,
                        color: chatProvider.isLoading
                            ? AppColors.primary.withOpacity(0.5)
                            : AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(ChatProvider chatProvider) {
    if (_messageController.text.trim().isNotEmpty) {
      chatProvider.sendMessage(_messageController.text);
      _messageController.clear();
      Future.delayed(Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}