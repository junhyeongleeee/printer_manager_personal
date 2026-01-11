import '../../domain/entities/user.dart';
import '../datasources/local/database_helper.dart';
import 'package:print_manager/core/data/datasources/remote/api_service.dart';
import 'package:print_manager/core/data/models/request/login_request.dart';
import 'package:print_manager/core/data/models/response/login_response.dart';
import 'package:print_manager/core/domain/repositories/user_repository.dart';
import 'package:print_manager/core/data/models/request/user_request.dart';
import 'package:print_manager/core/data/models/response/user_response.dart';
import 'package:print_manager/core/data/models/response/get_user_response.dart';


//TODO: 추후 Repository 패턴 도입을 통해 Domain - Data Layer 분리 예정

// class UserRepositoryImpl {
//   final DatabaseHelper db;
//
//   UserRepositoryImpl(this.db);
//
//   Future<void> saveUser(User user) async {
//     await db.insertUser(user.toMap());
//   }
//
//   Future<User?> loadUser(String id) async {
//     final map = await db.getUserByBusinessNumber(id);
//     return map != null ? User.fromMap(map) : null;
//   }
//
//   Future<void> deleteUser(String id) async {
//     await db.deleteUser(id);
//   }
// }

class UserRepositoryImpl implements UserRepository {
  final ApiService api;

  UserRepositoryImpl(this.api);

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    return api.login(request);
  }

  @override
  Future<UserResponse> updateUser(UserRequest request) {
    return api.updateUser(request);
  }

  @override
  Future<GetUserResponse> GetUser() {
    return api.getUser();
  }
}

