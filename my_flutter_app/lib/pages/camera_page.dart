import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> with WidgetsBindingObserver {
  CameraController? _controller;
  XFile? _capturedFile;
  bool _isInitializing = true;
  CameraDescription? _camera;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initCamera();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController? controller = _controller;
    if (controller == null) return;

    if (state == AppLifecycleState.inactive || state == AppLifecycleState.paused) {
      try {
        controller.dispose();
      } catch (_) {}
      _controller = null;
    } else if (state == AppLifecycleState.resumed) {
      _initCamera();
    }
  }

  Future<void> _initCamera() async {
    if (_controller != null) {
      try {
        await _controller!.dispose();
      } catch (_) {}
      _controller = null;
    }

    setState(() {
      _isInitializing = true;
      _errorMessage = null;
    });

    try {
      final cameras = await availableCameras();
      if (!mounted) return;
      _camera = cameras.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.isNotEmpty ? cameras.first : throw Exception('カメラが見つかりません'),
      );
      _controller = CameraController(_camera!, ResolutionPreset.medium, enableAudio: false);

      await _controller!.initialize();
    } on CameraException catch (e) {
      debugPrint('Camera init error (CameraException): $e');
      _errorMessage = 'カメラの初期化に失敗しました: ${e.code}';
    } catch (e) {
      debugPrint('Camera init error: $e');
      _errorMessage = 'カメラの初期化に失敗しました';
    } finally {
      if (!mounted) return;
      setState(() {
        _isInitializing = false;
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null || !_controller!.value.isInitialized || _controller!.value.isTakingPicture) return;
    try {
      final file = await _controller!.takePicture();
      if (!mounted) return;
      setState(() => _capturedFile = file);
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => PicturePreviewScreen(imagePath: file.path),
        ),
      );
    } catch (e) {
      debugPrint('takePicture error: $e');
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('撮影に失敗しました')));
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isInitializing) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('カメラ')),
        body: Center(child: Text(_errorMessage!)),
      );
    }

    if (_controller == null || !_controller!.value.isInitialized) {
      return Scaffold(
        appBar: AppBar(title: const Text('カメラ')),
        body: const Center(child: Text('カメラを初期化できませんでした')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('カメラ')),
      body: Stack(
        children: [
          Center(
            child: AspectRatio(
              aspectRatio: _controller!.value.aspectRatio,
              child: CameraPreview(_controller!),
            ),
          ),
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: _takePicture,
                  child: const Icon(Icons.camera_alt),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PicturePreviewScreen extends StatelessWidget {
  final String imagePath;
  const PicturePreviewScreen({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('撮影プレビュー')),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: Image.file(File(imagePath), fit: BoxFit.contain),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    child: const Text('閉じる'),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
