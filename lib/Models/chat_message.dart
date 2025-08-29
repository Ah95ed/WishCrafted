class ChatMessage {
  final String text;
  final bool isUser;
  // transient flag: used only for UI animation, not persisted
  bool animate;

  ChatMessage({required this.text, required this.isUser, this.animate = false});

  Map<String, dynamic> toJson() => {
        'text': text,
        'isUser': isUser,
        // 'animate' intentionally not saved to avoid re-animating on revisit
      };

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      text: (json['text'] ?? '') as String,
      isUser: (json['isUser'] ?? false) as bool,
      animate: false,
    );
  }
}
