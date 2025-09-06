import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mytodoapp/features/authentication/data/auth_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)

class AuthController extends _$AuthController {
  @override
  FutureOr<void> build() {
    throw UnimplementedError();
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .createUserWithEmailAndPassword(email: email, password: password),
    );
  }

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signInWithEmailAndPassword(email: email, password: password),
    );
  }

  Future<void> signOut() async {
    state = const AsyncLoading();
    state = state = await AsyncValue.guard(
      () => ref
          .read(authRepositoryProvider)
          .signOut(),
    );
  }
}
