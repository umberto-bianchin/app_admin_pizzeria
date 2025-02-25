import 'package:app_admin_pizzeria/providers/menu_provider.dart';
import 'package:app_admin_pizzeria/providers/orders_provider.dart';
import 'package:app_admin_pizzeria/screens/auth_screen.dart';
import 'package:app_admin_pizzeria/providers/page_provider.dart';
import 'package:app_admin_pizzeria/screens/main_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();
const defaultPadding = 16.0;

final listDisplay = [const AuthScreen(), MainScreen()];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PageProvider()),
      ChangeNotifierProvider(create: (_) => OrdersProvider()),
      ChangeNotifierProvider(create: (_) => MenuProvider()),
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
        scaffoldBackgroundColor: const Color.fromARGB(255, 238, 238, 238),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        canvasColor: const Color.fromARGB(255, 92, 98, 136),
        primaryColor: const Color(0xFF2697FF),
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
