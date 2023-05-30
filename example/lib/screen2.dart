import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_3d_viewer/flutter_3d_viewer.dart';

class Screen2 extends StatefulWidget {
  const Screen2({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<Screen2> createState() => _Screen2State();
}

class _Screen2State extends State<Screen2> with SingleTickerProviderStateMixin {
  late Scene3DViewer _scene;
  Object3DViewer? _earth;
  late Object3DViewer _stars;
  late AnimationController _controller;

  void generateSphereObject(Object3DViewer parent, String name, double radius,
      bool backfaceCulling, String texturePath) async {
    final Mesh3DViewer mesh =
        await generateSphereMesh(radius: radius, texturePath: texturePath);
    parent
        .add(Object3DViewer(name: name, mesh: mesh, backfaceCulling: backfaceCulling));
    _scene.updateTexture();
  }

  void _onSceneCreated(Scene3DViewer scene) {
    _scene = scene;
    _scene.camera.position.z = 16;

    // model from https://free3d.com/3d-model/planet-earth-99065.html
    // _earth = Object(name: 'earth', scale: Vector3(10.0, 10.0, 10.0), backfaceCulling: true, fileName: 'assets/earth/earth.obj');

    // create by code
    _earth = Object3DViewer(name: 'earth', scale: Vector3(10.0, 10.0, 10.0));
    generateSphereObject(
        _earth!, 'surface', 0.485, true, 'assets/earth/4096_earth.jpg');
    generateSphereObject(
        _earth!, 'clouds', 0.5, true, 'assets/earth/4096_clouds.png');
    _scene.world.add(_earth!);

    // texture from https://www.solarsystemscope.com/textures/
    _stars = Object3DViewer(name: 'stars', scale: Vector3(2000.0, 2000.0, 2000.0));
    generateSphereObject(
        _stars, 'surface', 0.5, false, 'assets/stars/2k_stars.jpg');
    _scene.world.add(_stars);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        duration: const Duration(milliseconds: 30000), vsync: this)
      ..addListener(() {
        if (_earth != null) {
          _earth!.rotation.y = _controller.value * 360;
          _earth!.updateTransform();
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
      backgroundColor: Colors.black,
      body: Flutter3DViewer(onSceneCreated: _onSceneCreated),
    );
  }
}

Future<Mesh3DViewer> generateSphereMesh(
    {num radius = 0.5,
    int latSegments = 32,
    int lonSegments = 64,
    required String texturePath,}) async {
  int count = (latSegments + 1) * (lonSegments + 1);
  List<Vector3> vertices = List<Vector3>.filled(count, Vector3.zero());
  List<Offset> texcoords = List<Offset>.filled(count, Offset.zero);
  List<Polygon3DViewer> indices =
      List<Polygon3DViewer>.filled(latSegments * lonSegments * 2, Polygon3DViewer(0, 0, 0));

  int i = 0;
  for (int y = 0; y <= latSegments; ++y) {
    final double v = y / latSegments;
    final double sv = math.sin(v * math.pi);
    final double cv = math.cos(v * math.pi);
    for (int x = 0; x <= lonSegments; ++x) {
      final double u = x / lonSegments;
      vertices[i] = Vector3(radius * math.cos(u * math.pi * 2.0) * sv,
          radius * cv, radius * math.sin(u * math.pi * 2.0) * sv);
      texcoords[i] = Offset(1.0 - u, 1.0 - v);
      i++;
    }
  }

  i = 0;
  for (int y = 0; y < latSegments; ++y) {
    final int base1 = (lonSegments + 1) * y;
    final int base2 = (lonSegments + 1) * (y + 1);
    for (int x = 0; x < lonSegments; ++x) {
      indices[i++] = Polygon3DViewer(base1 + x, base1 + x + 1, base2 + x);
      indices[i++] = Polygon3DViewer(base1 + x + 1, base2 + x + 1, base2 + x);
    }
  }

  ui.Image texture = await loadImageFromAsset(texturePath);
  final Mesh3DViewer mesh = Mesh3DViewer(
      vertices: vertices,
      texcoords: texcoords,
      indices: indices,
      texture: texture,
      texturePath: texturePath);
  return mesh;
}
