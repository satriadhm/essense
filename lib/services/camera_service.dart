import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

/// Service to manage camera operations and permissions
class CameraService {
  static final CameraService _instance = CameraService._internal();

  factory CameraService() {
    return _instance;
  }

  CameraService._internal();

  CameraController? _controller;
  List<CameraDescription>? _cameras;

  /// Check if camera controller is initialized
  bool get isInitialized => _controller != null && _controller!.value.isInitialized;

  /// Get the camera controller
  CameraController? get controller => _controller;

  /// Initialize camera with available cameras
  Future<void> initializeCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras == null || _cameras!.isEmpty) {
        throw Exception('No cameras available');
      }

      // Prefer back camera
      final CameraDescription camera = _cameras!.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => _cameras!.first,
      );

      _controller = CameraController(
        camera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
    } catch (e) {
      debugPrint('Error initializing camera: $e');
      rethrow;
    }
  }

  /// Switch camera (front/back)
  Future<void> switchCamera() async {
    if (_cameras == null || _cameras!.isEmpty) return;

    try {
      final currentLens = _controller?.description.lensDirection;
      final newCamera = _cameras!.firstWhere(
        (camera) => camera.lensDirection != currentLens,
        orElse: () => _cameras!.first,
      );

      await _controller?.dispose();

      _controller = CameraController(
        newCamera,
        ResolutionPreset.high,
        enableAudio: false,
      );

      await _controller!.initialize();
    } catch (e) {
      debugPrint('Error switching camera: $e');
    }
  }

  /// Capture a photo and return the file path
  Future<String?> capturePhoto() async {
    if (!isInitialized) {
      throw Exception('Camera not initialized');
    }

    try {
      final XFile photo = await _controller!.takePicture();
      return photo.path;
    } catch (e) {
      debugPrint('Error capturing photo: $e');
      rethrow;
    }
  }

  /// Record a video
  Future<void> startVideoRecording() async {
    if (!isInitialized) {
      throw Exception('Camera not initialized');
    }

    try {
      if (_controller!.value.isRecordingVideo) return;
      await _controller!.startVideoRecording();
    } catch (e) {
      debugPrint('Error starting video recording: $e');
      rethrow;
    }
  }

  /// Stop recording video
  Future<XFile?> stopVideoRecording() async {
    if (!isInitialized) {
      throw Exception('Camera not initialized');
    }

    try {
      if (!_controller!.value.isRecordingVideo) return null;
      return await _controller!.stopVideoRecording();
    } catch (e) {
      debugPrint('Error stopping video recording: $e');
      rethrow;
    }
  }

  /// Enable/disable flash
  Future<void> setFlashMode(FlashMode mode) async {
    if (!isInitialized) return;

    try {
      await _controller!.setFlashMode(mode);
    } catch (e) {
      debugPrint('Error setting flash mode: $e');
    }
  }

  /// Get current flash mode
  FlashMode? getFlashMode() {
    return _controller?.value.flashMode;
  }

  /// Set zoom level (1.0 - max zoom)
  Future<void> setZoom(double zoom) async {
    if (!isInitialized) return;

    try {
      final maxZoom = await _controller!.getMaxZoomLevel();
      final clampedZoom = zoom.clamp(1.0, maxZoom);
      await _controller!.setZoomLevel(clampedZoom);
    } catch (e) {
      debugPrint('Error setting zoom: $e');
    }
  }

  /// Get max zoom level
  Future<double?> getMaxZoomLevel() async {
    if (!isInitialized) return null;

    try {
      return await _controller!.getMaxZoomLevel();
    } catch (e) {
      debugPrint('Error getting max zoom: $e');
      return null;
    }
  }

  /// Get min zoom level
  Future<double?> getMinZoomLevel() async {
    if (!isInitialized) return null;

    try {
      return await _controller!.getMinZoomLevel();
    } catch (e) {
      debugPrint('Error getting min zoom: $e');
      return null;
    }
  }

  /// Pause camera preview
  Future<void> pauseCamera() async {
    if (!isInitialized) return;

    try {
      await _controller!.pausePreview();
    } catch (e) {
      debugPrint('Error pausing camera: $e');
    }
  }

  /// Resume camera preview
  Future<void> resumeCamera() async {
    if (!isInitialized) return;

    try {
      await _controller!.resumePreview();
    } catch (e) {
      debugPrint('Error resuming camera: $e');
    }
  }

  /// Dispose camera controller
  Future<void> dispose() async {
    try {
      await _controller?.dispose();
      _controller = null;
    } catch (e) {
      debugPrint('Error disposing camera: $e');
    }
  }
}
