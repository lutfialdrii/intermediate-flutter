class LoginResponseEntity {
  final bool error;
  final String message;
  final LoginResultEntity loginResult;

  LoginResponseEntity({
    required this.error,
    required this.message,
    required this.loginResult,
  });
}

class LoginResultEntity  {
  final String userId;
  final String name;
  final String token;

  LoginResultEntity({
    required this.userId,
    required this.name,
    required this.token,
  });
}

// {
//     "error": false,
//     "message": "success",
//     "loginResult": {
//         "userId": "user-NyxDZNXeAE-ZMkag",
//         "name": "Lutfi Aldri Permana",
//         "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJ1c2VyLU55eERaTlhlQUUtWk1rYWciLCJpYXQiOjE3Mjk3NDM1Nzd9.zXTRsr26eaKp6trqUc2YzRmLb4hAYF9uP_j9urwCa9I"
//     }
// }