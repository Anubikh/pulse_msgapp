import 'package:flutter/material.dart';
import 'package:minimsgapp_pantaleta/Services/Auth/auth_service.dart';
import 'package:minimsgapp_pantaleta/Components/my_button.dart';
import 'package:minimsgapp_pantaleta/Components/my_textfield.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;

  LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _pwdController = TextEditingController();
  bool _isPasswordVisible = false;

  // Login Method
  void login(BuildContext context) async {
    final authService = AuthService();

    // Try Login
    try {
      await authService.signInWithEmailPassword(
        _emailController.text.trim(),
        _pwdController.text.trim(),
      );
    }

    // Catch any errors

    catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Error"),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK"),
            ),
          ],
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
            Icons.chat_bubble,
            size: 80,
            color: Theme.of(context).colorScheme.primary,
          ),

          const SizedBox(height: 4),

          // Title
          Text(
            "P U L S E",
            style: TextStyle(color: Colors.red, fontSize: 40),
          ),

          const SizedBox(height: 10),

          // Welcome back message
          Text(
            "Welcome back to the message app.",
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),

          const SizedBox(height: 25),

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

          const SizedBox(height: 25),

          // Login button
          MyButton(
            text: "Login",
            onTap: () => login(context),
          ),

          const SizedBox(height: 25),

          // Register button
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Not a user? ",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: Text(
                  "Register now!",
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
