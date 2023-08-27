import 'package:app_admin_pizzeria/providers/orders_provider.dart';
import 'package:app_admin_pizzeria/screens/auth_screen.dart';
import 'package:app_admin_pizzeria/constants.dart';
import 'package:app_admin_pizzeria/providers/page_provider.dart';
import 'package:app_admin_pizzeria/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

final listDisplay = [const AuthScreen(), const MainScreen()];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PageProvider()),
      ChangeNotifierProvider(create: (_) => OrdersProvider()),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        canvasColor: secondaryColor,
      ),
      home: Scaffold(
        body: SafeArea(
          child:
              listDisplay[Provider.of<PageProvider>(context).loginStatus.index],
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
