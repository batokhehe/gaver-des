import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CameraCapturePage extends StatefulWidget {
  const CameraCapturePage({super.key});

  @override
  State<CameraCapturePage> createState() => _CameraCapturePageState();
}

class _CameraCapturePageState extends State<CameraCapturePage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isTakingPicture = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();

    _controller = CameraController(
      _cameras!.first,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(context),
          Expanded(
            child: Stack(
              children: [_buildCameraPreview(), _buildCaptureButton(context)],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg_header.png"),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 54, 16, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text(
                "Bukti Pengiriman",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCaptureButton(BuildContext context) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: Center(
        child: GestureDetector(
          onTap: _isTakingPicture ? null : () => _takePicture(context),
          child: AnimatedScale(
            scale: _isTakingPicture ? 0.9 : 1,
            duration: const Duration(milliseconds: 150),
            child: Image.asset(width: 100, "assets/icons/ic_take_camera.png"),
          ),
        ),
      ),
    );
  }

  Future<void> _takePicture(BuildContext context) async {
    try {
      setState(() => _isTakingPicture = true);

      final picture = await _controller!.takePicture();
      if (!mounted) return;

      final result = await context.push<String>(
        '/receipt-preview',
        extra: picture.path,
      );

      if (result != null && mounted) {
        context.pop(result);
      }
    } catch (e) {
      debugPrint("Camera error: $e");
    } finally {
      if (mounted) {
        setState(() => _isTakingPicture = false);
      }
    }
  }

  _buildCameraPreview() {
    return Positioned.fill(child: CameraPreview(_controller!));
  }
}
