// lib/features/assistant_bot/presentation/view/assistant_view.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hisab_kitab/app/service_locator/service_locator.dart';
import 'package:hisab_kitab/features/assistant_bot/domain/entity/assistant_entity.dart';
import 'package:hisab_kitab/features/assistant_bot/domain/use_case/ask_assistant_usecase.dart';
import 'package:hisab_kitab/features/assistant_bot/presentation/view_model/assistant_event.dart';
import 'package:hisab_kitab/features/assistant_bot/presentation/view_model/assistant_state.dart';
import 'package:hisab_kitab/features/assistant_bot/presentation/view_model/assistant_view_model.dart';

class AssistantView extends StatelessWidget {
  const AssistantView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AssistantViewModel(serviceLocator<AskAssistantUsecase>()),
      child: const _AssistantChatScreen(),
    );
  }
}

class _AssistantChatScreen extends StatelessWidget {
  const _AssistantChatScreen();

  @override
  Widget build(BuildContext context) {
    final textController = TextEditingController();
    final scrollController = ScrollController();

    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    void sendMessage() {
      if (textController.text.trim().isNotEmpty) {
        context.read<AssistantViewModel>().add(
          SendQuery(textController.text.trim()),
        );
        textController.clear();
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Hisab Assistant'), elevation: 1),
      body: Column(
        children: [
          Expanded(
            child: BlocConsumer<AssistantViewModel, AssistantState>(
              listener: (context, state) {
                if (state.status == AssistantStatus.success ||
                    state.status == AssistantStatus.loading) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (scrollController.hasClients) {
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    }
                  });
                }
              },
              builder: (context, state) {
                return ListView.builder(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16.0),
                  itemCount:
                      state.messages.length +
                      (state.status == AssistantStatus.loading ? 1 : 0),
                  itemBuilder: (context, index) {
                    if (state.status == AssistantStatus.loading &&
                        index == state.messages.length) {
                      return _ChatMessage(
                        message: AssistantEntity(
                          role: MessageRole.model,
                          text: '...',
                          timestamp: DateTime.now(),
                        ),
                      );
                    }
                    return _ChatMessage(message: state.messages[index]);
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              boxShadow: [
                BoxShadow(
                  spreadRadius: 1,
                  blurRadius: 5,
                  color: Colors.black.withOpacity(0.08),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    onSubmitted: (_) => sendMessage(),
                    decoration: InputDecoration(
                      hintText: 'Ask a question...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(
                          color:
                              isDarkMode
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: const BorderSide(
                          color: Colors.orange,
                          width: 2,
                        ),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessage extends StatelessWidget {
  final AssistantEntity message;
  const _ChatMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final bool isUser = message.role == MessageRole.user;
    final bool isError = message.role == MessageRole.error;

    Color bubbleColor;
    Color textColor;

    if (isError) {
      bubbleColor =
          isDarkMode
              ? Colors.red.shade900.withOpacity(0.5)
              : Colors.red.shade100;
      textColor = isDarkMode ? Colors.red.shade100 : Colors.red.shade900;
    } else if (isUser) {
      bubbleColor = Colors.orange;
      textColor = Colors.white;
    } else {
      bubbleColor = isDarkMode ? Colors.grey.shade800 : Colors.orange.shade50;
      textColor = isDarkMode ? Colors.white70 : Colors.black87;
    }

    // ignore: unnecessary_null_comparison
    if (message.timestamp == null) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4.0),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          child: const SizedBox(
            width: 30,
            height: 20,
            child: Text("...", style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ),
      );
    }

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: isUser ? const Radius.circular(20) : Radius.zero,
            bottomRight: isUser ? Radius.zero : const Radius.circular(20),
          ),
        ),
        child: Text(message.text, style: TextStyle(color: textColor)),
      ),
    );
  }
}
