// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// class LoginNotifier extends StateNotifier<AsyncValue<void>> {
//   final LoginUseCase loginUseCase;
//   final TokenNotifier tokenNotifier;
//
//   LoginNotifier(this.loginUseCase, this.tokenNotifier) : super(const AsyncData(null));
//
//   Future<void> login(String id, String password) async {
//     state = const AsyncLoading();
//     try {
//       final token = await loginUseCase.login(id, password);
//       tokenNotifier.setToken(token); // 토큰 저장
//       state = const AsyncData(null);
//     } catch (e, st) {
//       state = AsyncError(e, st);
//     }
//   }
// }
