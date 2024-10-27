import 'package:storykuy/domain/entities/authentication/body/login_request_entity.dart';
import 'package:storykuy/domain/entities/authentication/response/login_response_entity.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<String, LoginResponseEntity>> loginUser(
      LoginRequestEntity loginRequestEntity);
}
