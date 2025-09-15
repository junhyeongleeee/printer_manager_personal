import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:print_manager/domain/entities/user.dart';

final userProvider = StateNotifierProvider<UserNotifier, User?>((ref) {
  return UserNotifier();
});

class UserNotifier extends StateNotifier<User?> {
  UserNotifier()
      : super(User(
    id: '',
    pw: '',
    company: '',
    name: '',
    location: '',
    phoneNum: '',
  ));

  void updateUser(User newUser) {
    state = newUser;
  }

  void updateFields({
    String? id,
    String? pw,
    String? company,
    String? name,
    String? location,
    String? phoneNum,
  }) {
    if (state == null) return;
    state = state!.copyWith(
      pw: pw,
      company: company,
      name: name,
      location: location,
      phoneNum: phoneNum,
    );
  }

  void clear() {
    state = null;
  }
}
