import 'package:build_variant_app/flavor_config.dart';
import 'package:build_variant_app/my_app.dart';
import 'package:flutter/material.dart';

void main() {
  FlavorConfig(
    color: Colors.blue,
    flavor: FlavorType.prod,
    values: FlavorValues(titleApp: "Production App"),
  );

  runApp(const MyApp());
}
