import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'package:stock_app/navigation/navigation_helper.dart';
import 'package:stock_app/view/auth/login_screen.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();

  RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                height: 10,
              ),
              Hero(
                tag: 'loginImage',
                child: Image.asset(
                  "assets/img/signup_image.webp",
                  height: 290,
                  width: 350,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: 'Email', border: const OutlineInputBorder()),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: passwordController,
                  decoration: const InputDecoration(
                      hintText: 'Password', border: const OutlineInputBorder()),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  controller: repasswordController,
                  decoration: const InputDecoration(
                      hintText: 'Enter Password again',
                      border: const OutlineInputBorder()),
                  obscureText: true,
                ),
              ),
              const SizedBox(height: 20),
              Consumer<AuthService>(
                builder: (context, authService, child) {
                  return authService.isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: () async {
                            if (passwordController.text !=
                                repasswordController.text) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Color(0xFFff3b3c),
                                  content: Text(
                                    'Passwords do not match!',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                              return;
                            }
                            try {
                              await authService.signUp(emailController.text,
                                  passwordController.text);

                              // Gửi email xác thực
                              var user = authService.currentUser;
                              await user?.sendEmailVerification();

                              // Hiển thị thông báo yêu cầu xác thực email
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  backgroundColor: Color(0xFF38b64a),
                                  content: Text(
                                    'Đăng kí thành công! Vui lòng kiểm tra email để xác thực tài khoản.',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );

                              NavigationHelper.navigateWithSlideFromLeft(
                                  context, LoginScreen());
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    backgroundColor: Color(0xFFff3b3c),
                                    content: Text('Register Failed: $e',
                                        style: const TextStyle(
                                            color: Colors.white))),
                              );
                            }
                          },
                          // ElevatedButton(
                          //   onPressed: () async {
                          //     if (passwordController.text != repasswordController.text) {
                          //       ScaffoldMessenger.of(context).showSnackBar(
                          //         const SnackBar(
                          //           backgroundColor: Color(0xFFff3b3c),
                          //           content: Text('Passwords do not match!',
                          //               style: TextStyle(color: Colors.white)),
                          //         ),
                          //       );
                          //       return;
                          //     }
                          //     try {
                          //       await context
                          //           .read<AuthService>()
                          //           .signUp(emailController.text, passwordController.text);

                          //       // Gửi email xác thực
                          //       var user = context.read<AuthService>().currentUser;
                          //       await user?.sendEmailVerification();

                          //       // Hiển thị thông báo yêu cầu xác thực email
                          //       ScaffoldMessenger.of(context).showSnackBar(
                          //         const SnackBar(
                          //           backgroundColor: Color(0xFF38b64a),
                          //           content: Text(
                          //             'Đăng kí thành công! Vui lòng kiểm tra email để xác thực tài khoản.',
                          //             style: TextStyle(color: Colors.white),
                          //           ),
                          //         ),
                          //       );

                          //       NavigationHelper.navigateWithSlideFromLeft(
                          //           context, LoginScreen());
                          //     } catch (e) {
                          //       ScaffoldMessenger.of(context).showSnackBar(
                          //         SnackBar(
                          //             backgroundColor: Color(0xFFff3b3c),
                          //             content: Text('Register Failed: $e',
                          //                 style: const TextStyle(color: Colors.white))),
                          //       );
                          //     }
                          //   },
                          child: const Text(
                            'Register',
                            style: TextStyle(color: Colors.white),
                          ),
                        );
                },
              ),
              TextButton(
                onPressed: () {
                  NavigationHelper.navigateWithSlideFromRight(
                      context, LoginScreen());
                },
                child: const Text(
                  'Have an account',
                  style: TextStyle(color: Color(0xFF3b82f6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
