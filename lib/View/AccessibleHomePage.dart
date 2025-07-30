import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class AccessibleHomePage extends StatefulWidget {
  @override
  _AccessibleHomePageState createState() => _AccessibleHomePageState();
}

class _AccessibleHomePageState extends State<AccessibleHomePage> {
  double _fontSize = 16.0;
  bool _highContrast = false;
  bool _simplifiedUI = false;
  bool _enableTextToSpeech = true;
  bool _enableZoom = false;
  bool _enableSpeechToText = false;
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speech = stt.SpeechToText();
  String _speechText = '';

  Future<void> _speak(String text) async {
    if (_enableTextToSpeech) {
      await _flutterTts.setLanguage("ar-IQ");
      await _flutterTts.setPitch(1);
      await _flutterTts.speak(text);
    }
  }

  Future<void> _startListening() async {
    bool available = await _speech.initialize();
    if (available) {
      _speech.listen(onResult: (val) {
        setState(() {
          _speechText = val.recognizedWords;
        });
      });
    }
  }

  Widget _accessibleText(String text) {
    return GestureDetector(
      onLongPress: () => _speak(text),
      child: Text(
        text,
        textScaleFactor: _enableZoom ? 1.5 : 1.0,
        style: TextStyle(fontSize: _fontSize, color: _highContrast ? Colors.yellow : Colors.black),
      ),
    );
  }

  @override
  void dispose() {
    _flutterTts.stop();
    _speech.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = _highContrast ? Colors.black : Colors.white;
    final Color textColor = _highContrast ? Colors.yellow : Colors.black;

    return Scaffold(
      appBar: AppBar(
        title: _accessibleText('واجهة الوصول الشامل'),
        backgroundColor: _highContrast ? Colors.black : Colors.blue,
      ),
      backgroundColor: backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _accessibleText('مرحبًا بك! عدّل الإعدادات حسب احتياجك:'),
              const SizedBox(height: 20),

              // حجم الخط
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _accessibleText('حجم الخط:'),
                  Slider(
                    min: 12,
                    max: 30,
                    value: _fontSize,
                    onChanged: (value) {
                      setState(() {
                        _fontSize = value;
                      });
                    },
                  ),
                ],
              ),

              // تباين الألوان
              SwitchListTile(
                title: _accessibleText('تفعيل التباين العالي'),
                value: _highContrast,
                onChanged: (val) {
                  setState(() {
                    _highContrast = val;
                  });
                },
              ),

              // واجهة مبسطة
              SwitchListTile(
                title: _accessibleText('واجهة مبسطة (لذوي صعوبات الانتباه)'),
                value: _simplifiedUI,
                onChanged: (val) {
                  setState(() {
                    _simplifiedUI = val;
                  });
                },
              ),

              // قراءة النص
              SwitchListTile(
                title: _accessibleText('قراءة النص عند الضغط المطول'),
                value: _enableTextToSpeech,
                onChanged: (val) {
                  setState(() {
                    _enableTextToSpeech = val;
                  });
                },
              ),

              // تكبير المحتوى
              SwitchListTile(
                title: _accessibleText('تكبير المحتوى على مستوى الشاشة'),
                value: _enableZoom,
                onChanged: (val) {
                  setState(() {
                    _enableZoom = val;
                  });
                },
              ),

              // تحويل الصوت إلى نص
              SwitchListTile(
                title: _accessibleText('تحويل الصوت إلى نص (Speech to Text)'),
                value: _enableSpeechToText,
                onChanged: (val) {
                  setState(() {
                    _enableSpeechToText = val;
                    if (val) _startListening();
                  });
                },
              ),

              if (_enableSpeechToText && _speechText.isNotEmpty) ...[
                const SizedBox(height: 10),
                _accessibleText('النص المحول من الصوت:'),
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    _speechText,
                    style: TextStyle(fontSize: _fontSize),
                  ),
                )
              ],

              const SizedBox(height: 30),

              if (!_simplifiedUI) ...[
                _accessibleText('هذا مثال على محتوى غني ومفصل يساعد المستخدم على فهم الخيارات المتاحة.'),
              ] else ...[
                _accessibleText('محتوى مبسّط.'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
