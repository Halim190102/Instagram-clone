import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_app/providers/user_provider.dart';
import 'package:new_app/responsive/mobile_screen_layout.dart';
import 'package:new_app/responsive/responsive_layout_screen.dart';
import 'package:new_app/responsive/web_screen_layout.dart';
// import 'package:new_app/responsive/mobile_screen_layout.dart';
// import 'package:new_app/responsive/responsive_layout_screen.dart';
// import 'package:new_app/responsive/web_screen_layout.dart';
import 'package:new_app/screens/login_screen.dart';
import 'package:new_app/utils/colors.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyAtF9Tz9L3gjzLBPTklFD1wB6y_JRZhCGo',
        appId: '1:179349761859:web:b10348b53844cb2bad09f6',
        messagingSenderId: '179349761859',
        projectId: 'new-project-5494b',
      ),
    );
  } else {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: 'AIzaSyDaTcuQqazA78tdDoqknok1dCi_7_1f_So',
        appId: '1:179349761859:android:7cdfb5dd508d9296ad09f6',
        messagingSenderId: '179349761859',
        projectId: 'new-project-5494b',
      ),
    );
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => UserProvider(),
          ),
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData.dark()
              .copyWith(scaffoldBackgroundColor: mobileBackground),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const ResponsiveLayout(
                    mobileScreenLayout: MobileScreenLayout(),
                    webScreenLayout: WebScreenLayout(),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              return const LoginScreen();
            },
          ),
        ),
      ),
    );
  }
}
