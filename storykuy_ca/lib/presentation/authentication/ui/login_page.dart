import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storykuy/common/result_state.dart';
import 'package:storykuy/domain/entities/authentication/body/login_request_entity.dart';
import 'package:storykuy/gen/assets.gen.dart';
import 'package:storykuy/presentation/authentication/provider/login_notifier.dart';
import 'package:storykuy/presentation/authentication/widgets/password_text_field.dart';
import 'package:storykuy/presentation/home_screen/ui/home_screen_page.dart';

class LoginPage extends StatefulWidget {
  static const routeName = "/login";

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isEmailError = false;
  bool isPasswordError = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Assets.ilustrationLight.image(),
                  const Text(
                    "Email",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.green),
                  ),
                  TextField(
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          width: 1.5,
                          color: Colors.green,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),

                      hintText: "Masukkan Email",
                      hintStyle: const TextStyle(color: Colors.black45),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      // label: Text("Email"),
                    ),
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                  ),
                  Visibility(
                    visible: isEmailError,
                    child: const Text(
                      "Email harus diisi",
                      style: TextStyle(fontSize: 10, color: Colors.red),
                    ),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text(
                    "Password",
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Colors.green),
                  ),
                  PasswordTextField(
                    controller: passwordController,
                  ),
                  Visibility(
                    visible: isPasswordError,
                    child: const Text(
                      "Password harus diisi",
                      style: TextStyle(fontSize: 10, color: Colors.red),
                    ),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8)))),
                      onPressed: () {
                        if (emailController.text.isEmpty &&
                            passwordController.text.isEmpty) {
                          setState(() {
                            isEmailError = true;
                            isPasswordError = true;
                          });
                        } else if (emailController.text.isEmpty) {
                          setState(() {
                            isEmailError = true;
                          });
                        } else if (passwordController.text.isEmpty) {
                          setState(() {
                            isPasswordError = true;
                          });
                        } else {
                          isPasswordError = false;
                          isEmailError = false;

                          Provider.of<LoginNotifier>(context, listen: false)
                              .loginUser(LoginRequestEntity(
                                  email: emailController.text,
                                  password: passwordController.text));
                        }
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          "Login",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Consumer<LoginNotifier>(
            builder: (context, value, child) {
              if (value.loginState == ResultState.Loading) {
                return Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(child: CircularProgressIndicator()),
                );
              }

              if (value.loginState == ResultState.Error) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(value.message),
                      backgroundColor: Colors.red,
                    ));
                  },
                );
              }
              if (value.loginState == ResultState.Loaded) {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(SnackBar(content: Text(value.message)));
                  },
                );
                Navigator.of(context)
                    .pushReplacementNamed(HomeScreenPage.routeName);
              }

              return const SizedBox.shrink();
            },
          )
        ],
      ),
    );
  }
}
