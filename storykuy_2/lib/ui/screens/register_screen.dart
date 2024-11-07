// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storykuy/common/result_state.dart';

import '../../common/common.dart';
import '../../provider/auth_provider.dart';
import '../widgets/password_text_field.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onLogin;
  final Function() onRegister;
  const RegisterScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isNameError = false;
  bool isEmailError = false;
  bool isPasswordError = false;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

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
              Text(
                AppLocalizations.of(context)!.name,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.green),
              ),
              TextField(
                keyboardType: TextInputType.name,
                controller: nameController,
                decoration: InputDecoration(
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 1.5,
                      color: Colors.green,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: AppLocalizations.of(context)!.hintName,
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
                visible: isNameError,
                child: Text(
                  AppLocalizations.of(context)!.errorName,
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
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
                  hintText: AppLocalizations.of(context)!.hintEmail,
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
                child: Text(
                  AppLocalizations.of(context)!.errorEmail,
                  style: const TextStyle(fontSize: 10, color: Colors.red),
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
                child: Text(
                  AppLocalizations.of(context)!.errorPassword,
                  style: const TextStyle(fontSize: 10, color: Colors.red),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              if (context.watch<AuthProvider>().registerState ==
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
                          passwordController.text.isEmpty &&
                          nameController.text.isEmpty) {
                        setState(() {
                          isNameError = true;
                          isEmailError = true;
                          isPasswordError = true;
                        });
                      } else if (nameController.text.isEmpty) {
                        setState(() {
                          isNameError = true;
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
                        await authRead.register(
                          nameController.text,
                          emailController.text,
                          passwordController.text,
                        );
                        if (authRead.registerState == ResultState.loaded) {
                          widget.onLogin();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                authRead.message,
                              ),
                            ),
                          );
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
                                BorderRadius.all(Radius.circular(8)))),
                    child: const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        "Register",
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
                  widget.onLogin();
                },
                child: Align(
                  alignment: Alignment.center,
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.loginRegister,
                          style: const TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        const TextSpan(
                          text: " Login",
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
