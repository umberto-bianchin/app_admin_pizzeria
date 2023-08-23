import 'package:app_admin_pizzeria/auth.dart';
import 'package:app_admin_pizzeria/constants.dart';
import 'package:app_admin_pizzeria/providers/page_provider.dart';
import 'package:app_admin_pizzeria/screens/main_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => PageProvider()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final PageController _pageController = PageController();
  final ValueNotifier<int> selectedPage = ValueNotifier(0);

  @override
  Widget build(BuildContext context) {
    selectedPage.value = Provider.of<PageProvider>(context).selectedPage;

    selectedPage.addListener(() {
      _pageController.jumpToPage(selectedPage.value);
    });

    return MaterialApp(
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: bgColor,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        canvasColor: secondaryColor,
      ),
      home: Scaffold(
        body: SafeArea(
          child: StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Text("Exception");
                } else if (snapshot.hasData) {
                  return PageView(
                    physics: const NeverScrollableScrollPhysics(),
                    allowImplicitScrolling: false,
                    controller: _pageController,
                    children: [MainScreen(index: selectedPage.value)],
                  );
                } else {
                  return const AuthScreen();
                }
              }),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
