import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishcrafted/Controller/DashboardContorller/dashboardcontroller.dart';
import 'package:wishcrafted/Controller/auth_provider.dart';
import 'package:wishcrafted/Helper/Service/initService.dart';
import 'package:wishcrafted/Models/chat_session.dart';
import 'package:wishcrafted/View/RegisterScreen.dart';
import 'package:wishcrafted/View/style/AppColors/AppColors.dart';
import 'package:wishcrafted/View/LoginScreen.dart';

class ChatHistoryDrawer extends StatelessWidget {
  const ChatHistoryDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.background,
      child: Column(
        children: [
          // رأس الدراوير مع معلومات المستخدم
          // Container(
          //   width: double.infinity,
          //   decoration: BoxDecoration(
          //     gradient: LinearGradient(
          //       colors: [AppColors.curveTop1, AppColors.curveTop2],
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //     ),
          //   ),
          //   child: SafeArea(
          //     child: Padding(
          //       padding: const EdgeInsets.all(16.0),
          //       child: Column(
          //         crossAxisAlignment: CrossAxisAlignment.start,
          //         children: [
          //           Row(
          //             children: [
          //               CircleAvatar(
          //                 radius: 30,
          //                 backgroundColor: Colors.white.withOpacity(0.3),
          //                 child: Icon(
          //                   Icons.person,
          //                   size: 32,
          //                   color: Colors.white,
          //                 ),
          //               ),
          //               SizedBox(width: 12),
          //               Expanded(
          //                 child: Column(
          //                   crossAxisAlignment: CrossAxisAlignment.start,
          //                   children: [
          //                     Text(
          //                       'مرحباً بك',
          //                       style: TextStyle(
          //                         color: Colors.white,
          //                         fontSize: 20,
          //                         fontWeight: FontWeight.bold,
          //                       ),
          //                     ),
          //                     Consumer<DashboardController>(
          //                       builder: (context, controller, child) {
          //                         return Text(
          //                           '${controller.chatSessions.length} محادثة محفوظة',
          //                           style: TextStyle(
          //                             color: Colors.white.withOpacity(0.9),
          //                             fontSize: 14,
          //                           ),
          //                         );
          //                       },
          //                     ),
          //                   ],
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ],
          //       ),
          //     ),
          //   ),
          // ),

          // SafeArea(
          //   child: SizedBox(
          //     width: double.infinity,
          //     child: ElevatedButton.icon(
          //       onPressed: () {
          //         context.read<DashboardController>().startNewChat();
          //         Navigator.pop(context);
          //       },
          //       icon: Icon(Icons.add, color: Colors.white),
          //       label: Text(
          //         'محادثة جديدة',
          //         style: TextStyle(
          //           color: Colors.white,
          //           fontSize: 16,
          //           fontWeight: FontWeight.bold,
          //         ),
          //       ),
          //       style: ElevatedButton.styleFrom(
          //         backgroundColor: AppColors.accent,
          //         padding: EdgeInsets.symmetric(vertical: 12),
          //         shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(12),
          //         ),
          //       ),
          //     ),
          //   ),
          // ),

          // قائمة المحادثات
          Expanded(
            child: SafeArea(
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
          ),

          // إعدادات إضافية
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                  color: AppColors.textMain.withOpacity(0.2),
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                // تسجيل الخروج
                ListTile(
                  leading: Icon(Icons.logout, color: AppColors.accent),
                  title: Text(
                    'تسجيل الخروج',
                    style: TextStyle(color: AppColors.textMain, fontSize: 16),
                  ),
                  onTap: () {
                    _showLogoutConfirmation(context);
                  },
                ),

                // حذف الحساب
                ListTile(
                  leading: Icon(Icons.delete_forever, color: Colors.red),
                  title: Text(
                    'حذف الحساب',
                    style: TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  onTap: () {
                    _showDeleteAccountConfirmation(context);
                  },
                ),

                // مسح جميع المحادثات
                ListTile(
                  leading: Icon(Icons.clear_all, color: Colors.orange),
                  title: Text(
                    'مسح جميع المحادثات',
                    style: TextStyle(color: Colors.orange, fontSize: 16),
                  ),
                  onTap: () {
                    _showClearAllDialog(context);
                  },
                ),
              ],
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

  void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'تسجيل الخروج',
          style: TextStyle(color: AppColors.textMain),
        ),
        content: Text(
          'هل أنت متأكد من تسجيل الخروج؟',
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
            onPressed: () async {
              Navigator.pop(context); // أغلق الحوار أولاً
              final authProvider = context.read<AuthProvider>();
              final success = await authProvider.logout();

              if (success) {
                // مسح جميع المحادثات المحلية
                context.read<DashboardController>().clearAllChatSessions();
                shared.remove('isLogin');
                shared.remove('onborded');
                // العودة إلى شاشة تسجيل الدخول
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                  (route) => false,
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(authProvider.error ?? 'فشل تسجيل الخروج'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent),
            child: Text('تسجيل الخروج', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'حذف الحساب نهائياً',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'تحذير: هذا الإجراء لا يمكن التراجع عنه!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('سيتم حذف:', style: TextStyle(color: AppColors.textMain)),
            Text(
              '• حسابك بشكل نهائي',
              style: TextStyle(color: AppColors.textMain),
            ),
            Text(
              '• جميع محادثاتك مع الذكاء الاصطناعي',
              style: TextStyle(color: AppColors.textMain),
            ),
            Text(
              '• جميع بياناتك الشخصية',
              style: TextStyle(color: AppColors.textMain),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('إلغاء', style: TextStyle(color: AppColors.textMain)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
              _showFinalDeleteConfirmation(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text('متابعة', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showFinalDeleteConfirmation(BuildContext context) {
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(
          'تأكيد نهائي',
          style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'اكتب "حذف الحساب" للتأكيد:',
              style: TextStyle(color: AppColors.textMain),
            ),
            SizedBox(height: 12),
            TextField(
              controller: confirmController,
              decoration: InputDecoration(
                hintText: 'حذف الحساب',
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.red),
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              confirmController.dispose();
              Navigator.pop(context);
            },
            child: Text('إلغاء', style: TextStyle(color: AppColors.textMain)),
          ),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return ElevatedButton(
                // onPressed: () {
                //    Navigator.pop(context);
                // },
                onPressed: authProvider.isLoading
                    ? null
                    : () async {
                        if (confirmController.text.trim() == 'حذف الحساب') {
                          final success = await authProvider.deleteAccount();

                          if (success) {
                            // مسح جميع المحادثات المحلية
                            context
                                .read<DashboardController>()
                                .clearAllChatSessions();

                            confirmController.dispose();
                            Navigator.pop(context);

                            shared.remove('onborded');
                            shared.remove('isLogin');

                            // العودة إلى شاشة تسجيل الدخول
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ),
                            );

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('تم حذف الحساب بنجاح'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  authProvider.error ?? 'فشل حذف الحساب',
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('يجب كتابة "حذف الحساب" بالضبط'),
                              backgroundColor: Colors.orange,
                            ),
                          );
                        }
                      },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: authProvider.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Text(
                        'حذف نهائياً',
                        style: TextStyle(color: Colors.white),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}
