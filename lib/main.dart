import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:seek_commerce/screens/change_password_screen.dart';
import 'package:seek_commerce/screens/forgot_password_screen.dart';
import 'package:seek_commerce/screens/home_screen.dart';
import 'package:seek_commerce/screens/signup_screen.dart';
import '../provider/auth_provider.dart';
import '../services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:seek_commerce/screens/login_screen.dart';
import 'package:seek_commerce/screens/email_verification_screen.dart';
import 'package:seek_commerce/screens/reset_password_screen.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import '../api_config.dart';

void main() async {
  Stripe.publishableKey = ApiConfig().stripePubKey;
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  NotificationService().initialize();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AuthProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    _handleIncomingLinks();
  }

  void _handleIncomingLinks() async {
    // Handle initial link
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) {
      _handleLink(initialLink as String);
    }

    // Handle incoming links
    _appLinks.stringLinkStream.listen((String? link) {
      if (link != null) {
        _handleLink(link);
      }
    });
  }

  void _handleLink(String link) {
    Uri uri = Uri.parse(link);
    if (uri.path == '/verify-email') {
      String? token = uri.queryParameters['token'];
      if (token != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => EmailVerificationScreen(token: token)),
        );
      }
    } else if (uri.path == '/reset-password') {
      String? token = uri.queryParameters['token'];
      if (token != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ResetPasswordScreen(token: token)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'Seek Commerce',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginScreen(),
        '/register': (context) => SignupScreen(),
        '/forgot-password': (context) => ForgotPasswordScreen(),
        '/change-password': (context) => ChangePasswordScreen(),
        '/reset-password': (context) => ResetPasswordScreen(
            token: ModalRoute.of(context)!.settings.arguments as String),
        '/verify-email': (context) => EmailVerificationScreen(
            token: ModalRoute.of(context)!.settings.arguments as String),
        '/home': (context) => HomeScreen(),
      },
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final AuthProvider _authProvider = AuthProvider();
  @override
  void initState() {
    super.initState();
    Timer(
        const Duration(milliseconds: 5000),
        () => _authProvider.isAuthenticated
            ? Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()))
            : Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const LoginScreen())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xff9747FF), Color(0xffAAD238)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: Center(
            child: Image.asset('assets/images/logo_white.svg'
                //image: AssetImage('assets/images/logo_white.svg'),
                )),
      ),
    );
  }
}
