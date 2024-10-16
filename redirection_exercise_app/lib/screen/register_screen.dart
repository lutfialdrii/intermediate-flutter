import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:redirection_exercise/model/user.dart';
import 'package:redirection_exercise/provider/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  final Function() onRegister;
  final Function() onLogin;
  const RegisterScreen({
    super.key,
    required this.onRegister,
    required this.onLogin,
  });

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Screen'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 300),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    hintText: "Email",
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(hintText: "Password"),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                context.watch<AuthProvider>().isLoadingRegister
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            final scaffoldMessanger =
                                ScaffoldMessenger.of(context);
                            final user = User(
                              email: emailController.text,
                              password: passwordController.text,
                            );

                            final authRead = context.read<AuthProvider>();
                            final result = await authRead.saveUser(user);
                            if (result) {
                              widget.onRegister;
                            } else {
                              scaffoldMessanger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Your Email or Password is invalid",
                                  ),
                                ),
                              );
                            }
                          }
                        },
                        child: Text("REGISTER"),
                      ),
                SizedBox(
                  height: 8,
                ),
                OutlinedButton(
                  onPressed: () {
                    widget.onLogin();
                  },
                  child: Text("LOGIN"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
