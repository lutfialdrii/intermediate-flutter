import 'package:dartz/dartz.dart';
import 'package:storykuy/domain/entities/authentication/body/login_request_entity.dart';
import 'package:storykuy/domain/entities/authentication/response/login_response_entity.dart';
import 'package:storykuy/domain/repositories/auth_repository.dart';

class LoginUserUseCase {
  final AuthRepository authRepository;

  LoginUserUseCase({required this.authRepository});

  Future<Either<String, LoginResponseEntity>> execute(
      LoginRequestEntity params) async {
    final response = await authRepository.loginUser(params);
    return response;
  }
}
