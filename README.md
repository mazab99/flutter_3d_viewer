# ⚡flutter_3d_viewer

Custom widgets and components ready to use under your awesome projects!

## 🎖Installing

```yaml
dependencies:
  flutter_3d_viewer: ^<latest_version>
```



#### ❤Loved the utility? [Donate here](https://paypal.me/MahmoudA44?country.x=US&locale.x=en_US).
#### 🚀Want to learn more about Flutter? [Checkout this out!](https://web.telegram.org/k/#@DartWFlutter)
#### 💥DM me on Linkedin  [Follow here](https://www.linkedin.com/in/mazap64/)


## 🐛 Bugs/Requests

If you encounter any problems feel free to open an issue. If you feel the library is
missing a feature, please raise a ticket on Github and I'll look into it.
Pull request are also welcome.# flutter_3d_viewer

```

```dart
import 'package:flutter_3d_viewer/flutter_3d_viewer.dart';
  
@override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Flutter3DViewer(
          onSceneCreated: (Scene scene) {
            Scene3DViewer.world.add(Object(fileName: ''));
          },
        ),
      ),
    );
  }
```

