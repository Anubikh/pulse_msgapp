import 'package:flutter/material.dart';
import 'package:minimsgapp_pantaleta/Services/Auth/auth_service.dart';
import 'package:minimsgapp_pantaleta/Components/my_button.dart';
import 'package:minimsgapp_pantaleta/Components/my_textfield.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  final TextEditingController _cnfrmpwdController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  // Register method
  void register(BuildContext context) {
    final _auth = AuthService();

    // Passwords match = creates user.
    if (_pwdController.text == _cnfrmpwdController.text) {
      try {
        _auth.signUpWithEmailPassword(_emailController.text,
            _pwdController.text, _usernameController.text);
      } catch (e) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(e.toString()),
          ),
        );
      }
    }

    // Passwords dont match = tell user to fix
    else {
      showDialog(
        context: context,
        builder: (context) => const AlertDialog(
          title: Text("Passwords don't match."),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo
          Icon(
            Icons.person,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(height: 4),

          // Welcome message
          Text(
            "Let's sign you up an account.",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 25),

          // Username textfield
          MyTextfield(
            hintText: "Username",
            obscureText: false,
            controller: _usernameController,
          ),

          const SizedBox(height: 10),
          // Email textfield
          MyTextfield(
            hintText: "Email",
            obscureText: false,
            controller: _emailController,
          ),

          const SizedBox(height: 10),

          // Password textfield
          MyTextfield(
            hintText: "Password",
            obscureText: !_isPasswordVisible,
            controller: _pwdController,
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),

          const SizedBox(height: 10),

          MyTextfield(
            hintText: "Confirm Password",
            obscureText: !_isConfirmPasswordVisible,
            controller: _cnfrmpwdController,
            suffixIcon: IconButton(
              icon: Icon(
                _isConfirmPasswordVisible
                    ? Icons.visibility
                    : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                });
              },
            ),
          ),

          const SizedBox(height: 25),

          // Login button
          MyButton(
            text: "Register",
            onTap: () => register(context),
          ),

          const SizedBox(height: 25),

          // Register button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  "Login now.",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
