// domain/repositories/user_repository.dart
import 'package:print_manager/data/models/response/login_response.dart';

import '../entities/user.dart';
import 'package:print_manager/data/models/request/login_request.dart';
import 'package:print_manager/data/models/request/user_request.dart';
import 'package:print_manager/data/models/response/user_response.dart';
import 'package:print_manager/data/models/response/get_user_response.dart';


//TODO: 추후 Repository 패턴 도입을 통해 Domain - Data Layer 분리 예정

// abstract class UserRepository {
//   Future<User> getCurrentUser();
//   Future<void> saveUser(User user);
//   Future<void> clearUser();
// }
abstract class UserRepository {
  Future<LoginResponse> login(LoginRequest request); // returns accessToken
  Future<UserResponse> updateUser(UserRequest request);
  Future<GetUserResponse> GetUser();
}
