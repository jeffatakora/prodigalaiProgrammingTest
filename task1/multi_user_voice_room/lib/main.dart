import 'package:flutter/material.dart';
import 'package:multi_user_voice_room/app/provider/auth_provioder.dart';
import 'package:multi_user_voice_room/app/provider/room_provider.dart';
import 'package:multi_user_voice_room/app/screen/login/login.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => RoomProvider()),
      ],
      child: MaterialApp(
          title: 'Voice Room App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const LoginScreen()),
    );
  }
}
