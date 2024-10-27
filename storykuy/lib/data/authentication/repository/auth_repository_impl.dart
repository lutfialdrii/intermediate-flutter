import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:storykuy/data/authentication/datasource/auth_remote_datasource.dart';
import 'package:storykuy/data/authentication/mapper/auth_mapper.dart';
import 'package:storykuy/domain/entities/authentication/body/login_request_entity.dart';
import 'package:storykuy/domain/entities/authentication/response/login_response_entity.dart';
import 'package:storykuy/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthRemoteDataSourceImpl authRemoteDataSource;
  final AuthMapper mapper;

  AuthRepositoryImpl(
      {required this.authRemoteDataSource, required this.mapper});

  @override
  Future<Either<String, LoginResponseEntity>> loginUser(
      LoginRequestEntity loginRequestEntity) async {
    try {
      final response = await authRemoteDataSource
          .loginUser(mapper.mapLoginRequestEntityToModel(loginRequestEntity));

      return Right(mapper.mapLoginResponseModelToEntity(response));
    } on DioException catch (e) {
      return Left("Terjadi Kesalahan : ${e.message}");
    }
  }
}
