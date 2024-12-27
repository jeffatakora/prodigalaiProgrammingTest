import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multi_user_voice_room/app/model/user.dart';
import 'package:multi_user_voice_room/app/provider/auth_provider.dart';
import 'package:multi_user_voice_room/app/provider/room_provider.dart';
import 'package:multi_user_voice_room/app/screen/login/login.dart';
import 'package:multi_user_voice_room/app/screen/voice_room/voice_room.dart';
import 'package:multi_user_voice_room/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
//load dotenv flies
  await dotenv.load(fileName: ".env");

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => RoomService()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<UserModel?>(
        future: context.read<AuthService>().getCurrentUser(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: const CircularProgressIndicator());
          }
          return snapshot.hasData ? const RoomScreen() : const LoginScreen();
        },
      ),
    );
  }
}
