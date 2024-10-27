class LoginResponseModel {
  String? error;
  String? message;
  LoginResult? loginResult;

  LoginResponseModel({
    this.error,
    this.message,
    this.loginResult,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'error': error,
      'message': message,
      'loginResult': loginResult?.toJson(),
    };
  }

  factory LoginResponseModel.fromJson(Map<String, dynamic> map) {
    return LoginResponseModel(
      error: map['error'] != null ? map['error'] as String : null,
      message: map['message'] != null ? map['message'] as String : null,
      loginResult: map['loginResult'] != null
          ? LoginResult.fromJson(map['loginResult'] as Map<String, dynamic>)
          : null,
    );
  }
}

class LoginResult {
  String? userId;
  String? name;
  String? token;

  LoginResult({
    this.userId,
    this.name,
    this.token,
  });

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'userId': userId,
      'name': name,
      'token': token,
    };
  }

  factory LoginResult.fromJson(Map<String, dynamic> map) {
    return LoginResult(
      userId: map['userId'] != null ? map['userId'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      token: map['token'] != null ? map['token'] as String : null,
    );
  }
}