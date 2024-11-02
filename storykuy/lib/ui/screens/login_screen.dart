// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storykuy/common/result_state.dart';

import '../../provider/auth_provider.dart';
import '../widgets/password_text_field.dart';

class LoginScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;
  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isEmailError = false;
  bool isPasswordError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/ilustration_light.png'),
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
              if (context.watch<AuthProvider>().loginState ==
                  ResultState.loading)
                const Center(
                  child: CircularProgressIndicator(),
                )
              else
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
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
                        final authRead = context.read<AuthProvider>();
                        await authRead.login(
                            emailController.text, passwordController.text);
                        if (authRead.loginState == ResultState.loaded) {
                          widget.onLogin();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                authRead.message,
                              ),
                            ),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(const Radius.circular(8)))),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "LOGIN",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 8,
              ),
              InkWell(
                onTap: () {
                  widget.onRegister();
                },
                child: Align(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: "Belum punya akun? ",
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "Register",
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
