import 'package:flutter/material.dart';

class SpecialNeedsScreen extends StatefulWidget {
  const SpecialNeedsScreen({super.key});

  @override
  State<SpecialNeedsScreen> createState() => _SpecialNeedsScreenState();
}

class _SpecialNeedsScreenState extends State<SpecialNeedsScreen> {
  double fontSize = 16;
  Color textColor = Colors.black;
  Color bgColor = Colors.deepPurple[50]!;

  // زر تكبير الخط: يزيد حجم الخط في الشاشة
  void _increaseFontSize() {
    setState(() {
      fontSize = fontSize < 28 ? fontSize + 2 : fontSize;
    });
  }

  // زر تغيير الألوان: يغير ألوان النص والخلفية لتسهيل القراءة
  void _toggleColors() {
    setState(() {
      if (bgColor == Colors.deepPurple[50]) {
        bgColor = Colors.black;
        textColor = Colors.white;
      } else {
        bgColor = Colors.deepPurple[50]!;
        textColor = Colors.black;
      }
    });
  }

  // زر تشغيل قارئ الشاشة: يظهر رسالة توضيحية (في التطبيق الحقيقي يتم دعم قارئ الشاشة تلقائياً)
  void _activateScreenReader() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم تفعيل دعم قارئ الشاشة.')));
  }

  // زر الأوامر الصوتية: يظهر رسالة توضيحية (في التطبيق الحقيقي يمكن إضافة دعم الأوامر الصوتية)
  void _activateVoiceCommands() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('تم تفعيل دعم الأوامر الصوتية.')),
    );
  }

  // زر دعم لغة الإشارة: يظهر رسالة توضيحية (في التطبيق الحقيقي يمكن إضافة فيديو أو ترجمة نصية)
  void _activateSignLanguageSupport() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('تم تفعيل دعم لغة الإشارة.')));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text('قسم الاحتياجات الخاصة'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            margin: const EdgeInsets.all(32),
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.accessibility_new,
                    size: 64,
                    color: Colors.deepPurple,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'مرحبا بك في قسم الاحتياجات الخاصة',
                    style: TextStyle(
                      fontSize: fontSize + 6,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple[700],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'هنا يمكنك الحصول على خدمات ودعم مخصص لذوي الاحتياجات الخاصة.',
                    style: TextStyle(fontSize: fontSize, color: textColor),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  // دعم تكبير الخط
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.zoom_in),
                        label: const Text('تكبير الخط'),
                        onPressed: _increaseFontSize,
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.color_lens),
                        label: const Text('تغيير الألوان'),
                        onPressed: _toggleColors,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // دعم قارئ الشاشة
                  ElevatedButton.icon(
                    icon: const Icon(Icons.record_voice_over),
                    label: const Text('تشغيل قارئ الشاشة'),
                    onPressed: _activateScreenReader,
                  ),
                  const SizedBox(height: 16),
                  // دعم الأوامر الصوتية
                  ElevatedButton.icon(
                    icon: const Icon(Icons.mic),
                    label: const Text('الأوامر الصوتية'),
                    onPressed: _activateVoiceCommands,
                  ),
                  const SizedBox(height: 16),
                  // دعم لغة الإشارة أو الترجمة النصية
                  ElevatedButton.icon(
                    icon: const Icon(Icons.sign_language),
                    label: const Text('دعم لغة الإشارة'),
                    onPressed: _activateSignLanguageSupport,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      padding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 24,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('العودة'),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
