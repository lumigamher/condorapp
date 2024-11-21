import 'package:condorapp/widgets/message_bubble.dart';
import 'package:condorapp/widgets/typing_indicator.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../providers/chat_provider.dart';
import '../../providers/auth_provider.dart';
import '../../theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

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
        duration: const Duration(milliseconds: 300),
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
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(LucideIcons.moreVertical, color: AppColors.accent),
            onSelected: (value) {
              switch (value) {
                case 'clear':
                  context.read<ChatProvider>().clearCurrentConversation();
                  break;
                case 'new':
                  context.read<ChatProvider>().startNewConversation();
                  break;
                case 'logout':
                  context.read<AuthProvider>().logout(context);
                  break;
              }
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'new',
                child: Row(
                  children: [
                    Icon(LucideIcons.plus, size: 18),
                    SizedBox(width: 12),
                    Text('Nueva Conversación'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'clear',
                child: Row(
                  children: [
                    Icon(LucideIcons.trash2, size: 18),
                    SizedBox(width: 12),
                    Text('Borrar Conversación'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(LucideIcons.logOut, size: 18),
                    SizedBox(width: 12),
                    Text('Cerrar Sesión'),
                  ],
                ),
              ),
            ],
          ),
        ],
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
                    padding: const EdgeInsets.all(8),
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
                    padding: const EdgeInsets.only(bottom: 20),
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
                  const TypingIndicator().animate().fadeIn(),
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
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.accent.withOpacity(0.3),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: TextField(
                        controller: _messageController,
                        decoration: InputDecoration(
                          hintText: "Escribe un mensaje...",
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          fillColor: Colors.transparent,
                          filled: false,
                          contentPadding: const EdgeInsets.symmetric(vertical: 12),
                          hintStyle: TextStyle(
                            color: AppColors.primary.withOpacity(0.5),
                          ),
                        ),
                        enabled: !chatProvider.isLoading,
                        onSubmitted: (text) {
                          if (!chatProvider.isLoading) {
                            _sendMessage(chatProvider);
                          }
                        },
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: chatProvider.isLoading 
                      ? null 
                      : () => _sendMessage(chatProvider),
                    icon: Icon(
                      Icons.send_rounded,
                      color: chatProvider.isLoading
                          ? AppColors.primary.withOpacity(0.5)
                          : AppColors.accent,
                    ),
                  ),
                  const SizedBox(width: 8),
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
      Future.delayed(const Duration(milliseconds: 100), _scrollToBottom);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}