import 'package:flutter/material.dart';
import 'package:wishcrafted/View/Widgets/AccessibleText/AccessibleText.dart';
import 'package:wishcrafted/View/Widgets/CurveClipper/CurveClipper.dart';
import 'package:wishcrafted/View/Widgets/IntentApp.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';
import 'package:wishcrafted/View/style/AppColors/AppColors.dart';
import 'package:provider/provider.dart';
import 'package:wishcrafted/Controller/DashboardContorller/dashboardcontroller.dart';
import 'package:wishcrafted/Provider/chat_provider.dart';
import 'package:wishcrafted/Models/chat_message.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController _intentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final dashboardController = Provider.of<DashboardController>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // منحنى علوي
          ClipPath(
            clipper: TopCurveClipper(),
            child: Container(
              height: context.getHeight(120),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.curveTop1, AppColors.curveTop2],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // منحنى سفلي
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: BottomCurveClipper(),
              child: Container(
                height: context.getHeight(70),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.curveBottom1, AppColors.curveBottom2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
          ),
          // المحتوى مع Scroll
          SafeArea(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.all(context.getMinSize(8)),
              child: Card(
                color: AppColors.card,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Padding(
                  padding: EdgeInsets.all(context.getMinSize(8)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: context.getHeight(4)),
                      AccessibleText(
                        "اختر نيتك للبدء",
                        style: TextStyle(
                          fontSize: context.getFontSize(16),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      TextFormField(
                        controller: _intentController,
                        decoration: InputDecoration(
                          labelText: "أدخل رسالتك للذكاء الاصطناعي",
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: context.getHeight(8)),
                      IntentDropdownScreen(),
                      SizedBox(height: context.getHeight(8)),
                      ElevatedButton.icon(
                        onPressed: () async {
                          final text = _intentController.text.trim();
                          if (text.isNotEmpty) {
                            await dashboardController.askGemini(text);
                            _intentController.clear();
                          }
                          dashboardController.selectedIntent.title;
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(Icons.rocket_launch),
                        label: Text(
                          "ابدأ الرحلة",
                          style: TextStyle(
                            fontSize: context.getFontSize(16),
                            fontWeight: FontWeight.bold,
                            color: AppColors.textMain,
                          ),
                        ),
                      ),
                      SizedBox(height: context.getHeight(10)),
                      Divider(),
                      SizedBox(height: context.getHeight(8)),
                      // AccessibleText(
                      //   "النية الحالية:",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     color: AppColors.textMain,
                      //   ),
                      // ),
                      // Container(
                      //   padding: EdgeInsets.all(12),
                      //   margin: EdgeInsets.only(top: 4, bottom: 6),
                      //   decoration: BoxDecoration(
                      //     color: AppColors.curveBottom1,
                      //     borderRadius: BorderRadius.circular(10),
                      //   ),
                      //   child: AccessibleText(
                      //     dashboardController.selectedIntent?.description ??
                      //         "لا توجد نية محددة",
                      //     style: TextStyle(
                      //       fontSize: context.getFontSize(14),
                      //       color: AppColors.textMain,
                      //     ),
                      //   ),
                      // ),
                      // AccessibleText(
                      //   "تحليل مبدئي:",
                      //   style: TextStyle(
                      //     fontWeight: FontWeight.bold,
                      //     color: AppColors.textMain,
                      //   ),
                      // ),
                      // SizedBox(height: 2),
                      // AccessibleText(
                      //   "هذه النية تفتح فرصًا متعددة، يمكن تقسيمها إلى أهداف فرعية وخطوات تنفيذية...",
                      //   style: TextStyle(
                      //     fontSize: context.getFontSize(14),
                      //     color: AppColors.textMain,
                      //   ),
                      // ),
                      // SizedBox(height: context.getHeight(10)),
                      // ElevatedButton.icon(
                      //   onPressed: () {
                      //     // Navigator.pushNamed(context, '/intent_insights');
                      //   },
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: AppColors.accent,
                      //     foregroundColor: Colors.white,
                      //     padding: EdgeInsets.symmetric(vertical: 12),
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(12),
                      //     ),
                      //   ),
                      //   icon: Icon(Icons.analytics),
                      //   label: Text("عرض التحليلات المتقدمة"),
                      // ),
                      // SizedBox(height: context.getHeight(8)),
                      AccessibleText(
                        "محادثة الذكاء الاصطناعي:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                      SizedBox(height: 8),
                      dashboardController.isLoading
                          ? Center(child: CircularProgressIndicator())
                          : SingleChildScrollView(
                              child: SizedBox(
                                child: Text(
                                  dashboardController.messages
                                      .map((m) => m.text)
                                      .join('\n'),
                                ),
                              ),
                            ),

                      // GridView.builder(
                      //     shrinkWrap: true,
                      //     physics: NeverScrollableScrollPhysics(),
                      //     gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      //       crossAxisCount: 1,
                      //       childAspectRatio: 4,
                      //       mainAxisSpacing: 8,
                      //     ),
                      //     itemCount: dashboardController.messages.length,
                      //     itemBuilder: (context, index) {
                      //       final msg = dashboardController.messages[index];
                      //       return Container(
                      //         alignment: msg.isUser
                      //             ? Alignment.centerRight
                      //             : Alignment.centerLeft,
                      //         child: Container(
                      //           padding: EdgeInsets.all(10),
                      //           decoration: BoxDecoration(
                      //             color: msg.isUser
                      //                 ? AppColors.curveTop2
                      //                 : AppColors.curveBottom2,
                      //             borderRadius: BorderRadius.circular(8),
                      //           ),
                      //           child: Text(
                      //             msg.text,
                      //             style: TextStyle(
                      //               color: AppColors.textMain,
                      //               fontSize: context.getFontSize(14),
                      //             ),
                      //           ),
                      //         ),
                      //       );
                      //     },
                      //   ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
