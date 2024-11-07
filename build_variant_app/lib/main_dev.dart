import 'package:build_variant_app/my_app.dart';
import 'package:flutter/material.dart';

import 'flavor_config.dart';

void main() {
  FlavorConfig(
    color: Colors.orange,
    flavor: FlavorType.dev,
    values: FlavorValues(titleApp: "Development App"),
  );

  runApp(const MyApp());
}
