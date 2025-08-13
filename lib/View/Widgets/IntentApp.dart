import 'package:flutter/material.dart';
import 'package:wishcrafted/View/Widgets/AccessibleText/AccessibleText.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';

class IntentDropdownScreen extends StatefulWidget {
  const IntentDropdownScreen({super.key});

  @override
  State<IntentDropdownScreen> createState() => _IntentDropdownScreenState();
}

class _IntentDropdownScreenState extends State<IntentDropdownScreen> {
  // قائمة النوايا
  final Map<String, String> intents = {
    "ترفيه وتجارب غامرة":
        "الهروب من الواقع، مكافحة الوحدة، بناء هويات رقمية، الشعور بالحضور والانتماء",
    "تعليم وتطوير مستمر":
        "الإنجاز السريع، مواكبة السوق، تجاوز التعليم التقليدي، البحث عن الإرشاد",
    "صحة وعافية شاملة":
        "السيطرة على الصحة، تحقيق التوازن الشامل، السيادة على البيانات الصحية، الدعم الآمن",
    "تجارة واقتصاد قيمي":
        "التعبير عن الهوية، أثر الشراء، الأصالة والشفافية، الانتماء لمجتمع قيمي",
    "إنتاجية وإبداع معزز":
        "كسر الحصار الإبداعي، تحويل الأفكار لواقع، الاستقلال المالي، المساهمة في بناء الويب",
    "خدمات يومية متقدمة":
        "الأمان، الوقت مقابل المال، التغلب على البيروقراطية، بناء سجل مالي وسمعة ذكية",
    "تواصل اجتماعي هادف":
        "تأكيد الهوية، كسر الوحدة، نشر القيم، الانخراط بحركات اجتماعية فعالة",
    "تجارب مستقبلية/تخطيط":
        "تقليل القلق من المستقبل، التحكم في المصير، البحث عن نسخة أفضل من الذات",
    "اكتشاف ذاتي/استكشاف":
        "الحاجة للإلهام، اختبار حدود الشخصية، استكشاف قيم أو أنماط حياة جديدة",
    "مبادرات/مشاريع جماعية":
        "الرغبة في التأثير، التنظيم الذاتي، القيادة، تطوير الحراك المجتمعي",
  };

  String? selectedIntent; // النية المختارة

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DropdownButtonFormField<String>(
            isExpanded: true,
          
            decoration: InputDecoration(
              labelText: "اختر النية الظاهرة",
              labelStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: context.getFontSize(12),
              ),
              border: OutlineInputBorder(),
            ),
            value: selectedIntent,
            items: intents.keys.map((intent) {
              return DropdownMenuItem<String>(
                alignment: Alignment.center,
                value: intent,
                child: AccessibleText(
                  intent,
                  style: TextStyle(fontSize: context.getFontSize(12)),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedIntent = value;
              });
            },
          ),
          SizedBox(height: context.getHeight(12)),
          if (selectedIntent != null)
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                  "النية الخفية: ${intents[selectedIntent]!}",
                  style: TextStyle(fontSize: context.getFontSize(14)),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
