import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishcrafted/View/Widgets/AccessibleText/AccessibleText.dart';
import 'package:wishcrafted/View/Widgets/CurveClipper/CurveClipper.dart';
import 'package:wishcrafted/View/Widgets/IntentApp.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';
import 'package:wishcrafted/View/style/AppColors/AppColors.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController _intentController = TextEditingController();

  // Future<void> _saveIntent(String intent) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('selected_intent', intent);
  // }

  @override
  Widget build(BuildContext context) {
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
          // المحتوى
          SafeArea(
            child: Padding(
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
                          fontSize: context.getFontSize(2),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: context.getHeight(8)),
                      IntentDropdownScreen(
                        // controller: _intentController,
                      ),
                      SizedBox(height: context.getHeight(8)),
                      ElevatedButton.icon(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("لايعمل الان")),
                          );
                          // if (_intentController.text.isNotEmpty) {
                          //   _saveIntent(_intentController.text);

                          //   // Navigator.pushNamed(context, '/journey');
                          // }
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
                        label: Text("ابدأ الرحلة",
                            style: TextStyle(
                          fontSize: context.getFontSize(16),
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        )),
                      ),
                      SizedBox(height: context.getHeight(10)),
                      Divider(),
                      SizedBox(height: context.getHeight(8)),
                      AccessibleText(
                        "النية الحالية:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(12),
                        margin: EdgeInsets.only(top: 4, bottom: 6),
                        decoration: BoxDecoration(
                          color: AppColors.curveBottom1,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: AccessibleText(
                          _intentController.text.isEmpty
                              ? "لا توجد نية محددة"
                              : _intentController.text,
                          style: TextStyle(
                            fontSize: context.getFontSize(14),
                            color: AppColors.textMain,
                          ),
                        ),
                      ),
                      AccessibleText(
                        "تحليل مبدئي:",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textMain,
                        ),
                      ),
                      SizedBox(height: 2),
                      AccessibleText(
                        "هذه النية تفتح فرصًا متعددة، يمكن تقسيمها إلى أهداف فرعية وخطوات تنفيذية...",
                        style: TextStyle(
                          fontSize: context.getFontSize(14),
                          color: AppColors.textMain,
                        ),
                      ),
                      Spacer(),
                      ElevatedButton.icon(
                        onPressed: () {
                          // Navigator.pushNamed(context, '/intent_insights');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        icon: Icon(Icons.analytics),
                        label: Text("عرض التحليلات المتقدمة"),
                      ),
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
