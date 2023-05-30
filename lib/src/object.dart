import 'dart:ui';
import 'package:vector_math/vector_math_64.dart';
import 'scene.dart';
import 'mesh.dart';

class Object3DViewer {
  Object3DViewer({
    Vector3? position,
    Vector3? rotation,
    Vector3? scale,
    this.name,
    Mesh3DViewer? mesh,
    Scene3DViewer? scene,
    this.parent,
    List<Object3DViewer>? children,
    this.backfaceCulling = true,
    this.lighting = false,
    this.visiable = true,
    bool normalized = true,
    String? fileName,
    bool isAsset = true,
  }) {
    if (position != null) position.copyInto(this.position);
    if (rotation != null) rotation.copyInto(this.rotation);
    if (scale != null) scale.copyInto(this.scale);
    updateTransform();
    this.mesh = mesh ?? Mesh3DViewer();
    this.children = children ?? <Object3DViewer>[];
    for (Object3DViewer child in this.children) {
      child.parent = this;
    }
    this.scene = scene;

    // load mesh from obj file
    if (fileName != null) {
      loadObj(fileName, normalized, isAsset: isAsset).then((List<Mesh3DViewer> meshes) {
        if (meshes.length == 1) {
          this.mesh = meshes[0];
        } else if (meshes.length > 1) {
          // multiple objects
          for (Mesh3DViewer mesh in meshes) {
            add(Object3DViewer(name: mesh.name, mesh: mesh, backfaceCulling: backfaceCulling, lighting: lighting));
          }
        }
        this.scene?.objectCreated(this);
      });
    } else {
      this.scene?.objectCreated(this);
    }
  }

  /// The local position of this object relative to the parent. Default is Vector3(0.0, 0.0, 0.0). updateTransform after you change the value.
  final Vector3 position = Vector3(0.0, 0.0, 0.0);

  /// The local rotation of this object relative to the parent. Default is Vector3(0.0, 0.0, 0.0). updateTransform after you change the value.
  final Vector3 rotation = Vector3(0.0, 0.0, 0.0);

  /// The local scale of this object relative to the parent. Default is Vector3(1.0, 1.0, 1.0). updateTransform after you change the value.
  final Vector3 scale = Vector3(1.0, 1.0, 1.0);

  /// The name of this object.
  String? name;

  /// The scene of this object.
  Scene3DViewer? _scene;
  Scene3DViewer? get scene => _scene;
  set scene(Scene3DViewer? value) {
    _scene = value;
    for (Object3DViewer child in children) {
      child.scene = value;
    }
  }

  /// The parent of this object.
  Object3DViewer? parent;

  /// The children of this object.
  late List<Object3DViewer> children;

  /// The mesh of this object
  late Mesh3DViewer mesh;

  /// The backface will be culled without rendering.
  bool backfaceCulling;

  /// Enable basic lighting, default to false.
  bool lighting;

  /// Is this object visiable.
  bool visiable;

  /// The transformation of the object in the scene, including position, rotation, and scaling.
  final Matrix4 transform = Matrix4.identity();

  void updateTransform() {
    final Matrix4 m = Matrix4.compose(position, Quaternion.euler(radians(rotation.y), radians(rotation.x), radians(rotation.z)), scale);
    transform.setFrom(m);
  }

  /// Add a child
  void add(Object3DViewer object) {
    assert(object != this);
    object.scene = scene;
    object.parent = this;
    children.add(object);
  }

  /// Remove a child
  void remove(Object3DViewer object) {
    children.remove(object);
  }

  /// Find a child matching the name
  Object3DViewer? find(Pattern name) {
    for (Object3DViewer child in children) {
      if (child.name != null && (name as RegExp).hasMatch(child.name!)) return child;
      final Object3DViewer? result = child.find(name);
      if (result != null) return result;
    }
    return null;
  }
}
