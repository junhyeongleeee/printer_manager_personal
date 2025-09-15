import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/core/token.dart';

class TokenProvider extends StateNotifier<Token?> {
  TokenProvider() : super(null);

  void setToken(Token token) => state = token;
  void clearToken() => state = null;
  Token get token => state!;
}

final tokenProvider = StateNotifierProvider<TokenProvider, Token?>((ref) {
  return TokenProvider();
});
