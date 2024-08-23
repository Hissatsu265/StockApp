import 'package:flutter/material.dart';
import 'package:stock_app/providers/stock_provider.dart';
import 'package:stock_app/services/auth_service.dart';
import 'package:stock_app/view/auth/login_screen.dart';

// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => StockProvider()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: const Color(0xFF3b82f6),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3b82f6),
            ),
          ),
        ),
        home: LoginScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
