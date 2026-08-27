# sales_pal

A new Flutter project.

## Getting Started

Generated code is not checked into version control, so a fresh clone will not
compile until you run the code generator:

```sh
flutter pub get
dart run build_runner build
flutter run
```

This generates `lib/gen/assets.gen.dart` (asset references) and
`lib/core/navigation/app_routes.g.dart` (type-safe routes). The latter is a
`part` file, so without it `flutter analyze` and `flutter test` will report
errors rather than merely failing at runtime.

Re-run `dart run build_runner build` whenever you add an asset or change a
route. Use `dart run build_runner watch` to regenerate automatically while
developing.

## Resources

A few resources to get you started if this is your first Flutter project:

- [Learn Flutter](https://docs.flutter.dev/get-started/learn-flutter)
- [Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Flutter learning resources](https://docs.flutter.dev/reference/learning-resources)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
