import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'database_repository_providers.g.dart';

@riverpod
FirebaseFirestore firestore(Ref ref) {
  return FirebaseFirestore.instance;
}
