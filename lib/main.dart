import 'package:brain_bench/app/app.dart';
import 'package:brain_bench/core/utils/logging_setup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  setupLogging();
  runApp(
    const ProviderScope(
      child: BrainBenchApp(),
    ),
  );
}
