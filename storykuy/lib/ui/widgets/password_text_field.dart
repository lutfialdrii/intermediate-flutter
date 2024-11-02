import 'package:flutter/material.dart';

import '../../common/common.dart';

class PasswordTextField extends StatefulWidget {
  final TextEditingController controller;
  const PasswordTextField({
    super.key,
    required this.controller,
  });

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: _isObscure,
      controller: widget.controller,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            width: 1.5,
            color: Colors.green,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        hintText: AppLocalizations.of(context)!.hintPassword,
        hintStyle: const TextStyle(color: Colors.black45),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
      ),
      onTapOutside: (event) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}
