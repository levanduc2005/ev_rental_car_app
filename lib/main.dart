import 'package:flutter_template/app/app.dart';
import 'package:flutter_template/bootstrap.dart';

/// Default entry point.
///
/// Flavor-specific entry points (e.g. `main_dev.dart`, `main_prod.dart`) can
/// call [bootstrap] with different configuration while reusing [App].
void main() => bootstrap(App.new);
