import 'package:flutter/material.dart';

class Message {
  final String text;
  final String time;
  final bool me;
  final String avatar;
  Message({required this.text, required this.time, required this.me, required this.avatar});
}

class MessageBubble extends StatelessWidget {
  final Message message;
  const MessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final bubbleColor = message.me ? const Color(0xFFEEF6FA) : const Color(0xFF23A9D6);
    final textColor = message.me ? Colors.black87 : Colors.white;
    final align = message.me ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = message.me
        ? const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomLeft: Radius.circular(18))
        : const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18), bottomRight: Radius.circular(18));

    return Row(
      mainAxisAlignment: message.me ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (!message.me) ...[
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: CircleAvatar(radius: 24, backgroundImage: NetworkImage(message.avatar)),
          )
        ],
        Flexible(
          child: Column(
            crossAxisAlignment: align,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(color: bubbleColor, borderRadius: radius),
                child: Text(message.text, style: TextStyle(color: textColor)),
              ),
              const SizedBox(height: 6),
              Text(message.time, style: const TextStyle(fontSize: 12, color: Colors.black45)),
            ],
          ),
        ),
        if (message.me) const SizedBox(width: 48),
      ],
    );
  }
}
