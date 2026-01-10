import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});
  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  XFile? _lastPhoto;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _setupCamera();
  }

  Future<void> _setupCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('権限が必要です'),
            content: const Text('カメラの使用を許可してください。'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('閉じる')),
            ],
          ),
        );
        if (mounted) Navigator.of(context).pop();
      }
      return;
    }

    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        throw Exception('利用可能なカメラが見つかりません');
      }
      CameraDescription selected = cameras.first;
      for (var c in cameras) {
        if (c.lensDirection == CameraLensDirection.back) {
          selected = c;
          break;
        }
      }
      _controller = CameraController(selected, ResolutionPreset.high, enableAudio: false);
      await _controller!.initialize();
      if (mounted) setState(() => _isInitializing = false);
    } catch (e) {
      if (mounted) {
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('エラー'),
            content: Text('カメラの初期化に失敗しました: $e'),
            actions: [
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('閉じる')),
            ],
          ),
        );
        if (mounted) Navigator.of(context).pop();
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    try {
      final file = await _controller!.takePicture();
      setState(() => _lastPhoto = file);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('撮影に失敗しました: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('カメラ')),
      body: _isInitializing
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: _controller != null && _controller!.value.isInitialized
                      ? CameraPreview(_controller!)
                      : const Center(child: Text('カメラが利用できません')),
                ),
                if (_lastPhoto != null)
                  SizedBox(
                    height: 120,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.file(File(_lastPhoto!.path), fit: BoxFit.contain),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        icon: const Icon(Icons.camera),
                        label: const Text('撮影'),
                        onPressed: _takePicture,
                      ),
                      const SizedBox(width: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.close),
                        label: const Text('戻る'),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}