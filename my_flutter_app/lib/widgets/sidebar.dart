import 'package:flutter/material.dart';

class Sidebar extends StatelessWidget {
  const Sidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final users = [
      {'name': '函館　函之介', 'sub': 'ミライ株式会社 企画制作部', 'avatar': 'https://i.pravatar.cc/150?img=5'},
      {'name': 'つき山　くま子', 'sub': '', 'avatar': 'https://i.pravatar.cc/150?img=6'},
      {'name': '函館山（5）', 'sub': '', 'avatar': 'https://i.pravatar.cc/150?img=7'},
      {'name': '米田 ほう作', 'sub': '', 'avatar': 'https://i.pravatar.cc/150?img=8'},
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // プロフィール
          Row(
            children: [
              const CircleAvatar(radius: 28, backgroundImage: NetworkImage('https://i.pravatar.cc/150?img=1')),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('漁坂 隆哉', style: TextStyle(fontWeight: FontWeight.w700)),
                    SizedBox(height: 4),
                    Text('ミライ株式会社 企画制作部', style: TextStyle(color: Colors.black54, fontSize: 12)),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 14),
          // タブ（擬似）
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(color: const Color(0xFF23A9D6), borderRadius: BorderRadius.circular(8)),
            child: const Center(child: Text('すべて', style: TextStyle(color: Colors.white))),
          ),
          const SizedBox(height: 12),
          // ユーザーリスト
          Expanded(
            child: ListView.separated(
              itemCount: users.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, idx) {
                final u = users[idx];
                return Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFF0F4F6)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(radius: 22, backgroundImage: NetworkImage(u['avatar']!)),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(u['name']!, style: const TextStyle(fontWeight: FontWeight.w600)),
                            if ((u['sub'] ?? '').isNotEmpty)
                              Text(u['sub']!, style: const TextStyle(fontSize: 12, color: Colors.black54)),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
