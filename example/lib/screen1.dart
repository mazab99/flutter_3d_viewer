import 'package:flutter/material.dart';
import 'package:flutter_3d_viewer/flutter_3d_viewer.dart';

class Screen1 extends StatefulWidget {


  const Screen1({
    Key? key,
  }) : super(key: key);

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1>
    with SingleTickerProviderStateMixin {
  late Scene3DViewer _scene;
  Object3DViewer? _bunny;
  late AnimationController _controller;
  final double _ambient = 0.1;
  double _diffuse = 0.8;
  double _specular = 0.5;
  double _shininess = 0.0;

  void _onSceneCreated(Scene3DViewer scene) {
    _scene = scene;
    scene.camera.position.z = 10;
    scene.light.position.setFrom(Vector3(0, 10, 10));
    scene.light.setColor(Colors.white, _ambient, _diffuse, _specular);
    _bunny = Object3DViewer(
      position: Vector3(0, -1.0, 0),
      scale: Vector3(10.0, 10.0, 10.0),
      lighting: true,
      fileName: 'assets/bunny/bunny.obj',
    );
    scene.world.add(_bunny!);
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 30000),
      vsync: this,
    )
      ..addListener(() {
        if (_bunny != null) {
          _bunny!.rotation.y = _controller.value * 360;
          _bunny!.updateTransform();
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
        title: const Text('Flutter 3d viewer'),
      ),
      body: Stack(
        children: <Widget>[
          Flutter3DViewer(onSceneCreated: _onSceneCreated),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Flexible(flex: 2, child: Text('diffuse')),
                  Flexible(
                    flex: 8,
                    child: Slider(
                      value: _diffuse,
                      min: 0.0,
                      max: 1.0,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          _diffuse = value;
                          _scene.light.setColor(
                              Colors.white, _ambient, _diffuse, _specular);
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Flexible(flex: 2, child: Text('specular')),
                  Flexible(
                    flex: 8,
                    child: Slider(
                      value: _specular,
                      min: 0.0,
                      max: 1.0,
                      divisions: 100,
                      onChanged: (value) {
                        setState(() {
                          _specular = value;
                          _scene.light.setColor(
                              Colors.white, _ambient, _diffuse, _specular);
                        });
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  const Flexible(flex: 2, child: Text('shininess')),
                  Flexible(
                    flex: 8,
                    child: Slider(
                      value: _shininess,
                      min: 0.0,
                      max: 32.0,
                      divisions: 32,
                      onChanged: (value) {
                        setState(() {
                          _shininess = value;
                          _bunny!.mesh.material.shininess = _shininess;
                        });
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
