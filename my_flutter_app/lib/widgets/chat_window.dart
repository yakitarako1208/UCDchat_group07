import 'package:flutter/material.dart';
import 'message_bubble.dart';

class ChatWindow extends StatefulWidget {
  const ChatWindow({super.key});

  @override
  State<ChatWindow> createState() => _ChatWindowState();
}

class _ChatWindowState extends State<ChatWindow> {
  final List<Message> _msgs = [
    Message(
      text: 'はじめまして、函館さん。\n公立はこだて未来大学３年の中村と申します！！\n投稿みました！とても気になり、詳しくお話を聞きたいと思い、チャットを送らせていただきました。\n返信おまちしてます。',
      time: '10:15',
      me: false,
      avatar: 'https://i.pravatar.cc/150?img=11',
    ),
    Message(
      text: 'こんにちは、中村さん。\nミライ株式会社企画制作部の函館と申します。\nちょうど来週に説明会を開くので参加してみませんか？',
      time: '10:20',
      me: true,
      avatar: 'https://i.pravatar.cc/150?img=5',
    ),
  ];

  final TextEditingController _ctrl = TextEditingController();
  final ScrollController _scroll = ScrollController();

  void _send() {
    final t = _ctrl.text.trim();
    if (t.isEmpty) return;
    setState(() {
      _msgs.add(Message(text: t, time: 'Now', me: false, avatar: 'https://i.pravatar.cc/150?img=11'));
      _ctrl.clear();
    });
    // スクロールを末尾へ
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) _scroll.jumpTo(_scroll.position.maxScrollExtent);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: const [
        BoxShadow(color: Color(0x11000000), blurRadius: 6, offset: Offset(0, 2))
      ]),
      child: Column(
        children: [
          // ヘッダ
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFFEDEDED)))),
            child: const Text('函館　函之介（ミライ株式会社　企画制作部）', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          // メッセージ一覧
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: ListView.separated(
                controller: _scroll,
                itemCount: _msgs.length,
                separatorBuilder: (_, __) => const SizedBox(height: 18),
                itemBuilder: (context, idx) {
                  return MessageBubble(message: _msgs[idx]);
                },
              ),
            ),
          ),
          // コンポーザ
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: Color(0xFFEDEDED)))),
            child: Row(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.add_circle_outline)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: InputDecoration(
                      hintText: '参加したいです！具体的な日程は決まっていますか？',
                      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _send,
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
                  child: const Text('送信'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }
}
