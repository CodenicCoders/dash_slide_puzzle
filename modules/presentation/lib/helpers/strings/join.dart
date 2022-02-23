/// Creates an asset path by combining the [parts] into a single string
/// separated by `/`.
///
/// e.g.
/// ```dart
/// join(['hello', 'world','!']) = 'hello/world/!'
/// ```
///
/// Unlike the [path](https://api.flutter.dev/flutter/package-path_path/package-path_path-library.html)
/// library, this doesn't change the separator to `\` on Windows since
/// resource paths on Flutter uses `/` regardless of the utilized platform.
String join(List<String> parts) {
  final buffer = StringBuffer();

  for (var i = 0; i < parts.length; i++) {
    buffer.write(parts[i]);

    if (i < parts.length - 1) {
      buffer.write('/');
    }
  }

  return buffer.toString();
}
