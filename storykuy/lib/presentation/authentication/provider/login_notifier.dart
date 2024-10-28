import 'package:flutter/foundation.dart';
import 'package:storykuy/common/result_state.dart';
import 'package:storykuy/data/authentication/mapper/auth_mapper.dart';
import 'package:storykuy/domain/entities/authentication/body/login_request_entity.dart';
import 'package:storykuy/domain/usecases/authentication/login_user_use_case.dart';

import '../../../domain/entities/authentication/response/login_response_entity.dart';

class LoginNotifier extends ChangeNotifier {
  final LoginUserUseCase useCase;
  final AuthMapper mapper;

  LoginNotifier({
    required this.useCase,
    required this.mapper,
  });

  String _message = "";
  String get message => _message;

  ResultState _loginState = ResultState.Empty;
  ResultState get loginState => _loginState;

  LoginResponseEntity? _responseEntity;
  LoginResponseEntity get responseEntity => _responseEntity!;

  Future<void> loginUser(LoginRequestEntity requestEntity) async {
    _loginState = ResultState.Loading;
    notifyListeners();

    final result = await useCase.execute(requestEntity);
    result.fold(
      (messsage) {
        _message = messsage;
      },
      (LoginResponseEntity response) {
        _loginState = ResultState.Loaded;
        _responseEntity = response;
        notifyListeners();
      },
    );
  }
}
