import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:multi_user_voice_room/app/provider/auth_provider.dart';
import 'package:multi_user_voice_room/app/provider/room_provider.dart';
import 'package:multi_user_voice_room/app/screen/login/login.dart';
import 'package:multi_user_voice_room/app/screen/voice_room/voice_room.dart';
import 'package:multi_user_voice_room/app/service/auth_services.dart';
import 'package:multi_user_voice_room/firebase_options.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
//load dotenv flies
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide AuthService
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),

        // Provide AuthProvider
        ChangeNotifierProxyProvider<AuthService, AuthenticationProvider>(
          create: (context) => AuthenticationProvider(
            context.read<AuthService>(),
          ),
          update: (context, authService, previous) =>
              previous ?? AuthenticationProvider(authService),
        ),

        // Provide VoiceRoomProvider with lazy loading
        ChangeNotifierProvider.value(
          value: RoomProvider(dotenv.env['AGORA_APP_CHANNEL']!,),
        ),
      ],
      child: MaterialApp(
        title: 'Voice Room App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
          inputDecorationTheme: InputDecorationTheme(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 48),
            ),
          ),
        ),
        home: Consumer<AuthenticationProvider>(
          builder: (context, authProvider, child) {
            return authProvider.isAuthenticated
                ? const VoiceRoomWrapper()
                : const LoginScreen();
          },
        ),
      ),
    );
  }
}

// Wrapper widget for VoiceRoom to handle provider state
class VoiceRoomWrapper extends StatelessWidget {
  const VoiceRoomWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthenticationProvider>();
    final user = authProvider.user;

    if (user == null) {
      return const LoginScreen();
    }

    return Consumer<RoomProvider>(
      builder: (context, voiceRoomProvider, child) {
        return VoiceRoomScreen(currentUser: user);
      },
    );
  }
}
