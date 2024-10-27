import 'package:storykuy/common/dio_service.dart';
import 'package:storykuy/data/authentication/model/body/login_request_model.dart';
import 'package:storykuy/data/authentication/model/response/login_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<LoginResponseModel> loginUser(LoginRequestModel loginRequest);
}

class AuthRemoteDataSourceImpl extends AuthRemoteDataSource {
  final DioService dioService;

  AuthRemoteDataSourceImpl({required this.dioService});
  @override
  Future<LoginResponseModel> loginUser(LoginRequestModel loginRequest) async {
    final response = await dioService.post('/login', data: {
      'email': loginRequest.email,
      'password': loginRequest.password,
    });

    if (response.statusCode == 200) {
      return LoginResponseModel.fromJson(response.data);
    } else {
      throw Exception('Login failed: ${response.data['message']}');
    }
  }
}
