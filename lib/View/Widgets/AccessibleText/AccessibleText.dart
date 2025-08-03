import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishcrafted/Controller/AccessibilityProvider/AccessibilityProvider.dart';

class AccessibleText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;

  const AccessibleText(this.text, {super.key, this.style, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Consumer<AccessibilityProvider>(
      builder: (context, access, child) => GestureDetector(
        onLongPress: () {
          if (access.ttsEnabled) {
            access.speak(text);
          }
        },
        child: Text(
          text,
          style:
              style?.copyWith(fontSize: access.fontSize) ??
              TextStyle(fontSize: access.fontSize),
          textAlign: textAlign,
        ),
      ),
    );
  }
}
