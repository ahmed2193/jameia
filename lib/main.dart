import 'package:flutter/material.dart';

import 'package:jameia/core/di/service_locator.dart' as di;

import 'package:jameia/Jameia_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.initServiceLocator();
  runApp(const JameiaApp());
}

