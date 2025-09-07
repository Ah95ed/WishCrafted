import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishcrafted/Controller/DashboardContorller/dashboardcontroller.dart';
import 'package:wishcrafted/Models/chat_session.dart';
import 'package:wishcrafted/View/style/AppColors/AppColors.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';

class ChatHistoryDrawer extends StatelessWidget {
  const ChatHistoryDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          // رأس الدراوير
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Column(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.start,
          //     children: [
          //       CircleAvatar(
          //         radius: 40,
          //         backgroundColor: Colors.white.withOpacity(0.3),
          //         child: Icon(
          //           Icons.chat_bubble_outline,
          //           size: 40,
          //           color: Colors.white,
          //         ),
          //       ),
          //       SizedBox(height: 16),
          //       Text(
          //         'محادثاتي',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 24,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       Text(
          //         'مع الذكاء الاصطناعي',
          //         style: TextStyle(
          //           color: Colors.white.withOpacity(0.8),
          //           fontSize: 16,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // زر محادثة جديدة
          SafeArea(
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  context.read<DashboardController>().startNewChat();
                  Navigator.pop(context);
                },
                icon: Icon(Icons.add, color: Colors.white),
                label: Text(
                  'محادثة جديدة',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ),

          // قائمة المحادثات
          Expanded(
            child: Consumer<DashboardController>(
              builder: (context, controller, child) {
                if (controller.chatSessions.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.chat_bubble_outline,
                          size: 64,
                          color: AppColors.textMain,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'لا توجد محادثات محفوظة',
                          style: TextStyle(
                            color: AppColors.textMain,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'ابدأ محادثة جديدة مع الذكاء الاصطناعي',
                          style: TextStyle(
                            color: AppColors.textMain,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                // ترتيب المحادثات حسب آخر تحديث
                final sortedSessions = List<ChatSession>.from(
                  controller.chatSessions,
                )..sort((a, b) => b.lastUpdated.compareTo(a.lastUpdated));

                return ListView.builder(
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  itemCount: sortedSessions.length,
                  itemBuilder: (context, index) {
                    final session = sortedSessions[index];
                    final isCurrentSession =
                        controller.currentSession?.id == session.id;

                    return Card(
                      color: isCurrentSession
                          ? AppColors.accent
                          : AppColors.card,
                      margin: EdgeInsets.symmetric(vertical: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isCurrentSession
                              ? AppColors.accent
                              : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isCurrentSession
                              ? AppColors.accent
                              : AppColors.curveTop1,
                          child: Icon(
                            Icons.chat,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                        title: Text(
                          session.title,
                          style: TextStyle(
                            color: AppColors.textMain,
                            fontWeight: isCurrentSession
                                ? FontWeight.bold
                                : FontWeight.normal,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 4),
                            Text(
                              '${session.messages.length} رسالة',
                              style: TextStyle(
                                color: AppColors.textMain,
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              _formatDate(session.lastUpdated),
                              style: TextStyle(
                                color: AppColors.textMain,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          controller.selectChatSession(session);
                          Navigator.pop(context);
                        },
                        trailing: PopupMenuButton<String>(
                          icon: Icon(
                            Icons.more_vert,
                            color: AppColors.textMain,
                          ),
                          onSelected: (value) {
                            if (value == 'delete') {
                              _showDeleteConfirmation(
                                context,
                                controller,
                                session,
                              );
                            }
                          },
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                    size: 20,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'حذف',
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),

          // إعدادات إضافية
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextButton.icon(
              onPressed: () {
                _showClearAllDialog(context);
              },
              icon: Icon(Icons.clear_all, color: Colors.red),
              label: Text(
                'مسح جميع المحادثات',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'اليوم ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'أمس ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} أيام';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    DashboardController controller,
    ChatSession session,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'حذف المحادثة',
          style: TextStyle(color: AppColors.textMain),
        ),
        content: Text(
          'هل أنت متأكد من حذف هذه المحادثة؟ لا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(color: AppColors.textMain.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: AppColors.textMain.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              controller.deleteChatSession(session.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('حذف', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showClearAllDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'مسح جميع المحادثات',
          style: TextStyle(color: AppColors.textMain),
        ),
        content: Text(
          'هل أنت متأكد من حذف جميع المحادثات؟ لا يمكن التراجع عن هذا الإجراء.',
          style: TextStyle(color: AppColors.textMain.withOpacity(0.8)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(color: AppColors.textMain.withOpacity(0.7)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<DashboardController>().clearAllChatSessions();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('مسح الكل', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
