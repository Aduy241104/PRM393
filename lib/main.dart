import 'package:flutter/material.dart';
import 'package:project/widgets/home_page.dart';
import 'package:provider/provider.dart';
import 'authProvider.dart';
import 'widgets/login_page.dart';
// import 'home_page.dart'; // Hãy chắc chắn bạn đã có file này

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final authProvider = AuthProvider();
  await authProvider.initAuth();

  runApp(
    ChangeNotifierProvider(create: (_) => authProvider, child: const MyApp()),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home: Consumer<AuthProvider>(
        builder: (context, auth, child) {
          if (auth.isLoggedIn) {
            return const HomePage(); // Đã login thì vào HomePage
          }
          return LoginPage(); // Chưa login thì ở LoginPage
        },
      ),
    );
  }
}
