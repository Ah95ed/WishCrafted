import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wishcrafted/View/Widgets/AccessibleText/AccessibleText.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  TextEditingController _intentController = TextEditingController();

  Future<void> _saveIntent(String intent) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selected_intent', intent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: AccessibleText('لوحة التحكم'),
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text("أدخل النية:", style: TextStyle(fontWeight: FontWeight.bold)),
            TextField(
              controller: _intentController,
              decoration: InputDecoration(
                hintText: 'مثال: تطوير مهارة الذكاء الاصطناعي',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                if (_intentController.text.isNotEmpty) {
                  _saveIntent(_intentController.text);
                  Navigator.pushNamed(context, '/journey');
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5c9aff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: Text("ابدأ الرحلة"),
            ),
            SizedBox(height: context.getHeight(10)),
            Text("النية الحالية:", style: TextStyle(fontWeight: FontWeight.bold)),
            Container(
              padding: EdgeInsets.all(12),
              margin: EdgeInsets.only(top: 8, bottom: 16),
              decoration: BoxDecoration(
                color: Color(0xFFE7F5FF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                _intentController.text.isEmpty
                    ? "لا توجد نية محددة"
                    : _intentController.text,
                style: TextStyle(fontSize: 16),
              ),
            ),
            Text("تحليل مبدئي:"),
            SizedBox(height: 8),
            Text(
              "هذه النية تفتح فرصًا متعددة، يمكن تقسيمها إلى أهداف فرعية وخطوات تنفيذية...",
              style: TextStyle(fontSize: 14),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/intent_insights');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF5c9aff),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: Text("عرض التحليلات المتقدمة"),
            ),
          ],
        ),
      ),
    );
  }
}
