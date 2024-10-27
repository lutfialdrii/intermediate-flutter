import 'package:storykuy/data/authentication/model/body/login_request_model.dart';
import 'package:storykuy/data/authentication/model/response/login_response_model.dart';
import 'package:storykuy/domain/entities/authentication/body/login_request_entity.dart';
import 'package:storykuy/domain/entities/authentication/response/login_response_entity.dart';

class AuthMapper {
  LoginRequestModel mapLoginRequestEntityToModel(LoginRequestEntity request) {
    return LoginRequestModel(
      email: request.email,
      password: request.password,
    );
  }

  LoginRequestEntity mapLoginRequestModelToEntity(LoginRequestModel model) {
    return LoginRequestEntity(
      email: model.email,
      password: model.password,
    );
  }

  LoginResponseModel mapLoginResponseEntityToModel(
      LoginResponseEntity response) {
    return LoginResponseModel(
        error: response.error,
        message: response.message,
        loginResult: mapLoginResultEntityToModel(response.loginResult));
  }

  LoginResponseEntity mapLoginResponseModelToEntity(LoginResponseModel model) {
    return LoginResponseEntity(
        error: model.error ?? "",
        message: model.message ?? "",
        loginResult: mapLoginResultModelToEntity(model.loginResult));
  }

  LoginResult mapLoginResultEntityToModel(LoginResultEntity entity) {
    return LoginResult(
      userId: entity.userId,
      name: entity.name,
      token: entity.token,
    );
  }

  LoginResultEntity mapLoginResultModelToEntity(LoginResult? model) {
    return LoginResultEntity(
      userId: model?.userId ?? "",
      name: model?.name ?? "",
      token: model?.token ?? "",
    );
  }
}
