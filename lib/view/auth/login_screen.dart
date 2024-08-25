import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_app/navigation/navigation_helper.dart';
import 'package:stock_app/view/dashboard/dashboard_screen.dart';
import '../../services/auth_service.dart';
import 'register_screen.dart';

final TextEditingController passwordController = TextEditingController();

class LoginScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Hero(
                  tag: 'loginImage',
                  child: Image.asset(
                    "assets/img/login_image.png",
                    height: 320,
                    width: 350,
                    fit: BoxFit.cover,
                  ),
                ),
                const Text(
                  'Login now',
                  style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                const Text("Please enter the below detail to continue"),
                const SizedBox(height: 25),
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F1F1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                PasswordField(),
                const SizedBox(
                  height: 15,
                ),
                Consumer<AuthService>(
                  builder: (context, authService, child) {
                    return authService.isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () async {
                              try {
                                await authService.signIn(emailController.text,
                                    passwordController.text);

                                var user = authService.currentUser;
                                if (user != null && !user.emailVerified) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      backgroundColor: Color(0xFFff3b3c),
                                      content: Text(
                                        'Email chưa được xác thực. Vui lòng kiểm tra email để xác thực.',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ),
                                  );
                                  return;
                                }
                                NavigationHelper.navigateWithSlideFromRight(
                                    context, DashboardScreen());
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    backgroundColor: Color(0xFFff3b3c),
                                    content: Text(
                                      'Login Failed',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                );
                              }
                            },
                            child: const Text('Login',
                                style: TextStyle(color: Colors.white)),
                          );
                  },
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterScreen()),
                    );
                  },
                  child: const Text(
                    'Create an account',
                    style: TextStyle(color: Color(0xFF3b82f6)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PasswordField extends StatefulWidget {
  const PasswordField({super.key});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF1F1F1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextFormField(
        controller: passwordController,
        decoration: InputDecoration(
            hintText: 'Password',
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility : Icons.visibility_off,
              ),
              onPressed: () {
                setState(() {
                  _obscureText = !_obscureText;
                });
              },
            )),
        obscureText: _obscureText,
      ),
    );
  }
}
