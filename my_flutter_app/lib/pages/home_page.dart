import 'package:flutter/material.dart';
import '../widgets/sidebar.dart';
import '../widgets/chat_window.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          children: [
            const FlutterLogo(size: 28),
            const SizedBox(width: 12),
            const Text('HAKODATE KAKKI', style: TextStyle(color: Color(0xFF1FA3D0), fontWeight: FontWeight.w700)),
            const Spacer(),
            SizedBox(
              width: 360,
              child: TextField(
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  hintText: '気になるワードを入力',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
            const SizedBox(width: 12),
            const Icon(Icons.notifications_none, color: Colors.black54),
            const SizedBox(width: 8),
            CircleAvatar(backgroundColor: Colors.grey[300], radius: 14),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF5F7F9),
      body: Row(
        children: const [
          SizedBox(width: 260, child: Sidebar()),
          Expanded(child: ChatWindow()),
        ],
      ),
    );
  }
}
