import 'package:flutter/material.dart';
import 'package:wishcrafted/View/Widgets/AccessibleText/AccessibleText.dart';
import 'package:wishcrafted/View/style/SizeApp/ScreenSize.dart';

class IntentDropdownScreen extends StatefulWidget {
  const IntentDropdownScreen({super.key});

  @override
  State<IntentDropdownScreen> createState() => _IntentDropdownScreenState();
}

class _IntentDropdownScreenState extends State<IntentDropdownScreen> {
  final Map<String, String> intents = {
    "ترفيه وتجارب غامرة": "الهروب من الواقع، مكافحة الوحدة، بناء هويات رقمية، الشعور بالحضور والانتماء",
    "تعليم وتطوير مستمر": "الإنجاز السريع، مواكبة السوق، تجاوز التعليم التقليدي، البحث عن الإرشاد",
    "صحة وعافية شاملة": "السيطرة على الصحة، تحقيق التوازن الشامل، السيادة على البيانات الصحية، الدعم الآمن",
    "تجارة واقتصاد قيمي": "التعبير عن الهوية، أثر الشراء، الأصالة والشفافية، الانتماء لمجتمع قيمي",
    "إنتاجية وإبداع معزز": "كسر الحصار الإبداعي، تحويل الأفكار لواقع، الاستقلال المالي، المساهمة في بناء الويب",
    "خدمات يومية متقدمة": "الأمان، الوقت مقابل المال، التغلب على البيروقراطية، بناء سجل مالي وسمعة ذكية",
    "تواصل اجتماعي هادف": "تأكيد الهوية، كسر الوحدة، نشر القيم، الانخراط بحركات اجتماعية فعالة",
    "تجارب مستقبلية/تخطيط": "تقليل القلق من المستقبل، التحكم في المصير، البحث عن نسخة أفضل من الذات",
    "اكتشاف ذاتي/استكشاف": "الحاجة للإلهام، اختبار حدود الشخصية، استكشاف قيم أو أنماط حياة جديدة",
    "مبادرات/مشاريع جماعية": "الرغبة في التأثير، التنظيم الذاتي، القيادة، تطوير الحراك المجتمعي",
  };

  String? selectedIntent;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.getHeight(220),
      child: ListView.separated(
        itemCount: intents.length,
        separatorBuilder: (context, i) => SizedBox(height: 8),
        itemBuilder: (context, i) {
          String key = intents.keys.elementAt(i);
          return Material(
            color: selectedIntent == key
                ? Theme.of(context).colorScheme.secondary.withOpacity(0.15)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () {
                setState(() {
                  selectedIntent = key;
                });
              },
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: 18,
                  horizontal: 14,
                ),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: selectedIntent == key
                        ? Theme.of(context).colorScheme.secondary
                        : Colors.grey.shade300,
                    width: selectedIntent == key ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: selectedIntent == key
                      ? Theme.of(context).colorScheme.secondary.withOpacity(0.07)
                      : Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(
                      selectedIntent == key
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      color: Theme.of(context).colorScheme.secondary,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: AccessibleText(
                        key,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: context.getFontSize(15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}