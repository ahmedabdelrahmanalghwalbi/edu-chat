import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'firebase_options.dart';
import 'provider/firebase_provider.dart';
import 'features/screens/auth/auth_page.dart';
import 'features/screens/users_chats/chats_screen.dart';

Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_backgroundMessageHandler);
  runApp(const MyApp());
}

final navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<FirebaseProvider>(
        create: (BuildContext _) => FirebaseProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: AppThemeService.getTheme(isDark: false, context: context),
          darkTheme: AppThemeService.getTheme(isDark: false, context: context),
          themeMode: ThemeMode.light,
          title: 'EDU-CHAT',
          navigatorKey: navigatorKey,
          home: const MainPage(),
        ),
      );
}

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
            if (snapshot.hasData) {
              return const ChatsScreen();
            } else {
              return const AuthPage();
            }
          },
        ),
      );
}
