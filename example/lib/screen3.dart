import 'package:flutter/material.dart';
import 'package:flutter_3d_viewer/flutter_3d_viewer.dart';

class Screen3 extends StatefulWidget {
  const Screen3({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<Screen3> createState() => _Screen3State();
}

class _Screen3State extends State<Screen3> with SingleTickerProviderStateMixin {
  void _onSceneCreated(Scene3DViewer scene) {
    scene.camera.position.z = 10;
    scene.camera.target.y = 2;
    scene.world.add(
      Object3DViewer(
        scale: Vector3(10.0, 10.0, 10.0),
        fileName: 'assets/ruby_rose/ruby_rose.obj',
      ),
    );
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
