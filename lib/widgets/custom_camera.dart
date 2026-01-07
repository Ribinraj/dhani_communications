// Placeholder for CustomCameraWidget (replace with actual import)
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CustomCameraWidget extends StatefulWidget {
  final CameraLensDirection lensDirection;
  final Function(File) onImageCaptured;
  final double? height;
  final double? width;

  const CustomCameraWidget({
    super.key,
    this.lensDirection = CameraLensDirection.front,
    required this.onImageCaptured,
    this.height,
    this.width,
  });

  @override
  State<CustomCameraWidget> createState() => CustomCameraWidgetState();
}

class CustomCameraWidgetState extends State<CustomCameraWidget> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;
  File? _capturedImage;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();
      final camera = _cameras!.firstWhere(
        (cam) => cam.lensDirection == widget.lensDirection,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
      if (mounted) {
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Error initializing camera: $e');
    }
  }

  // Public method to capture image - can be called from parent widget
  Future<File?> captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return null;

    try {
      final image = await _controller!.takePicture();
      final imageFile = File(image.path);
      
      setState(() {
        _capturedImage = imageFile;
      });
      
      widget.onImageCaptured(imageFile);
      return imageFile;
    } catch (e) {
      debugPrint('Error capturing image: $e');
      return null;
    }
  }

  void _retakeImage() {
    setState(() {
      _capturedImage = null;
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final displayHeight = widget.height ?? MediaQuery.of(context).size.width * 0.6;
    final displayWidth = widget.width ?? MediaQuery.of(context).size.width * 0.6;

    if (_capturedImage != null) {
      return Container(
        height: displayHeight,
        width: displayWidth,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: const Color(0xFF59CBEF),
            width: 3,
          ),
        ),
        child: ClipOval(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.file(
                _capturedImage!,
                fit: BoxFit.cover,
              ),
              Positioned(
                bottom: 10,
                right: 10,
                child: GestureDetector(
                  onTap: _retakeImage,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.refresh,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized || _controller == null) {
      return Container(
        height: displayHeight,
        width: displayWidth,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.grey[300],
          border: Border.all(
            color: const Color(0xFF59CBEF),
            width: 3,
          ),
        ),
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Container(
      height: displayHeight,
      width: displayWidth,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFF59CBEF),
          width: 3,
        ),
      ),
      child: ClipOval(
        child: CameraPreview(_controller!),
      ),
    );
  }
}
