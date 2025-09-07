import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishcrafted/Models/chat_message.dart';
import 'package:wishcrafted/Controller/chat_provider.dart';
import 'package:wishcrafted/View/DashBoardScreen/Ai.dart';
import 'package:wishcrafted/View/style/AppColors/AppColors.dart';

class ChatScreen extends StatefulWidget {
  final List<ChatMessage> messages;
  final bool embedded; // if true, render without Scaffold/AppBar
  final bool externalIsLoading; // loading flag provided by parent when embedded

  const ChatScreen(
    this.messages, {
    Key? key,
    this.embedded = false,
    this.externalIsLoading = false,
  }) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  @override
  void initState() {
    super.initState();
  }
  // void _send(String text) {
  //   if (text.trim().isEmpty) return;
  //   context.read<ChatProvider>().sendMessage(text);
  //   _controller.clear();
  // }

  Widget _buildMessage(ChatMessage msg, {required bool animateAssistant}) {
    final bool isUser = msg.isUser;
    final bubble = Container(
      decoration: BoxDecoration(
        color: isUser ? AppColors.curveTop1 : AppColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: isUser
          ? Text(
              msg.text,
              style: TextStyle(color: AppColors.textMain, fontSize: 16),
            )
          : (animateAssistant && msg.animate)
          ? TypewriterText(
              text: msg.text,
              style: TextStyle(color: AppColors.textMain, fontSize: 16),
              speed: const Duration(milliseconds: 40),
            )
          : Text(
              msg.text,
              style: TextStyle(color: AppColors.textMain, fontSize: 16),
            ),
    );

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: bubble,
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    final chat = context.watch<ChatProvider>();
    final conversations = chat.conversations;
    final currentId = chat.currentId;

    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  const Icon(Icons.history),
                  const SizedBox(width: 8),
                  const Text(
                    'المحادثات',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add_comment),
                    tooltip: 'محادثة جديدة',
                    onPressed: () =>
                        context.read<ChatProvider>().startNewConversation(),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.separated(
                itemCount: conversations.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (context, i) {
                  final c = conversations[i];
                  return ListTile(
                    selected: c.id == currentId,
                    title: Text(
                      c.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text(
                      '${c.messages.length} رسالة • آخر تحديث: ${c.updatedAt.toLocal()}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () {
                      context.read<ChatProvider>().switchConversation(c.id);
                      Navigator.pop(context);
                    },
                    trailing: PopupMenuButton<String>(
                      onSelected: (v) async {
                        if (v == 'rename') {
                          final controller = TextEditingController(
                            text: c.title,
                          );
                          final newTitle = await showDialog<String>(
                            context: context,
                            builder: (_) => AlertDialog(
                              title: const Text('إعادة تسمية'),
                              content: TextField(controller: controller),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('إلغاء'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, controller.text),
                                  child: const Text('حفظ'),
                                ),
                              ],
                            ),
                          );
                          if (newTitle != null) {
                            await context
                                .read<ChatProvider>()
                                .renameConversation(c.id, newTitle);
                          }
                        } else if (v == 'delete') {
                          await context.read<ChatProvider>().deleteConversation(
                            c.id,
                          );
                        }
                      },
                      itemBuilder: (_) => const [
                        PopupMenuItem(
                          value: 'rename',
                          child: Text('إعادة تسمية'),
                        ),
                        PopupMenuItem(value: 'delete', child: Text('حذف')),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If embedded, use parent-provided data and render list-only (no Scaffold)
    if (widget.embedded) {
      final messages = widget.messages;
      final isTyping = widget.externalIsLoading;
      final bool animateAssistant =
          messages.isNotEmpty && !messages.last.isUser && messages.last.animate;

      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (isTyping && index == 0) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('🤖 ... يكتب'),
                    ),
                  );
                }
                final effectiveIndex = isTyping ? index - 1 : index;
                final msg = messages[messages.length - 1 - effectiveIndex];
                final isLastAssistant =
                    !msg.isUser &&
                    (messages.length - 1 - effectiveIndex) ==
                        messages.length - 1;
                return _buildMessage(
                  msg,
                  animateAssistant: animateAssistant && isLastAssistant,
                );
              },
            ),
          ),
        ],
      );
    }

    final chat = context.watch<ChatProvider>();
    final messages = chat.currentMessages;
    final isTyping = chat.isLoading;

    // نحدد إذا يجب تشغيل الأنميشن فقط للرسالة المساعدة الأخيرة في المحادثة الحالية
    final bool animateAssistant =
        messages.isNotEmpty && !messages.last.isUser && messages.last.animate;

    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: AppBar(
        title: const Text('الدردشة'),
        actions: [
          IconButton(
            tooltip: 'محادثة جديدة',
            icon: const Icon(Icons.add_comment),
            onPressed: () =>
                context.read<ChatProvider>().startNewConversation(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: messages.length + (isTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (isTyping && index == 0) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: const Text('🤖 ... يكتب'),
                    ),
                  );
                }
                final effectiveIndex = isTyping ? index - 1 : index;
                final msg = messages[messages.length - 1 - effectiveIndex];
                final isLastAssistant =
                    !msg.isUser &&
                    (messages.length - 1 - effectiveIndex) ==
                        messages.length - 1;
                return _buildMessage(
                  msg,
                  animateAssistant: animateAssistant && isLastAssistant,
                );
              },
            ),
          ),
          // Container(
          //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          //   color: AppColors.card,
          //   child: Row(
          //     children: [
          // Expanded(
          //   child: TextField(
          //     controller: _controller,
          //     decoration: const InputDecoration(
          //       hintText: 'اكتب رسالتك...',
          //       border: InputBorder.none,
          //     ),
          //     onSubmitted: _send,
          //   ),
          // ),
          // IconButton(
          //   icon: const Icon(Icons.send),
          //   onPressed: () => _send(_controller.text),
          // ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
