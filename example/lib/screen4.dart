import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_3d_viewer/flutter_3d_viewer.dart';

class Screen4 extends StatefulWidget {
  const Screen4({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<Screen4> createState() => _Screen4State();
}

class _Screen4State extends State<Screen4> with SingleTickerProviderStateMixin {
  late Scene3DViewer _scene;
  Object3DViewer? _cube;
  late AnimationController _controller;

  void _onSceneCreated(Scene3DViewer scene) {
    _scene = scene;
    scene.camera.position.z = 50;
    _cube = Object3DViewer(
        scale: Vector3(2.0, 2.0, 2.0),
        backfaceCulling: false,
        fileName: 'assets/cube/cube.obj');
    const int samples = 100;
    const double radius = 8;
    const double offset = 2 / samples;
    final double increment = pi * (3 - sqrt(5));
    for (var i = 0; i < samples; i++) {
      final y = (i * offset - 1) + offset / 2;
      final r = sqrt(1 - pow(y, 2));
      final phi = ((i + 1) % samples) * increment;
      final x = cos(phi) * r;
      final z = sin(phi) * r;
      final Object3DViewer cube = Object3DViewer(
        position: Vector3(x, y, z)..scale(radius),
        fileName: 'assets/cube/cube.obj',
      );
      _cube!.add(cube);
    }
    scene.world.add(_cube!);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 30000), vsync: this)
      ..addListener(() {
        if (_cube != null) {
          _cube!.rotation.y = _controller.value * 360;
          _cube!.updateTransform();
          _scene.update();
        }
      })
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: Center(
        child: Flutter3DViewer(
          onSceneCreated: _onSceneCreated,
        ),
      ),
    );
  }
}
