import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'database.dart';
import 'login.dart';
import 'register.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late UserDatabase userDatabase;

  @override
  void initState() {
    super.initState();
    userDatabase = UserDatabase();
    initializeDatabase();
  }

  void initializeDatabase() async {
    await userDatabase.initDatabase();
    bool isLoggedIn = await SessionManager.isLoggedIn();
    if (isLoggedIn) {
      Navigator.of(context).pushReplacementNamed('/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sample App with SQLite',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        '/login': (context) => LoginScreen(databaseHelper: userDatabase),
        '/home': (context) => _HomeScreen(databaseHelper: userDatabase),
        '/register': (context) => RegisterScreen(databaseHelper: userDatabase),
      },
      initialRoute: '/login',
    );
  }
}

class _HomeScreen extends StatelessWidget {
  final UserDatabase databaseHelper;

  const _HomeScreen({Key? key, required this.databaseHelper}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: databaseHelper.getUserById(1),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        } else {
          if (snapshot.hasError) {
            return Scaffold(body: Center(child: Text('Error: ${snapshot.error}')));
          } else {
            return MyHomePage(databaseHelper: databaseHelper, user: snapshot.data!, title: '',);
          }
        }
      },
    );
  }
}

class SessionManager {
  static const String isLoggedInKey = 'isLoggedIn';

  static Future<void> setLoggedIn(bool isLoggedIn) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(isLoggedInKey, isLoggedIn);
  }

  static Future<bool> isLoggedIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(isLoggedInKey) ?? false;
  }
}
