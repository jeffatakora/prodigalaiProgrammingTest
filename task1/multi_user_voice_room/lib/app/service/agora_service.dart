import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:agora_token_service/agora_token_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  RtcEngine? _engine;
  bool _isMuted = false;
  final Function(int, bool) onUserSpeaking;
  final expirationInSeconds = 3600;
  final currentTimestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

  AgoraService({required this.onUserSpeaking});

  Future<void> initialize() async {
    // Request microphone permission
    await Permission.microphone.request();

    // Create RTC engine instance
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(
      appId: dotenv.env['AGORA_APP_ID']!,
    ));

    // Enable audio volume indication
    await _engine!.enableAudioVolumeIndication(
      interval: 250,
      smooth: 3,
      reportVad: true,
    );

    _setupAgoraEventHandlers();
  }

  void _setupAgoraEventHandlers() {
    // Register event handlers
    _engine!.registerEventHandler(RtcEngineEventHandler(
      onJoinChannelSuccess: (connection, elapsed) {
        //fetch user here
        print("Local user joined channel ${connection.localUid}");
      },
      onUserJoined: (connection, remoteUid, elapsed) {
        print("Remote user joined: $remoteUid");
      },
      onUserOffline: (connection, remoteUid, reason) {
        print("Remote user left: $remoteUid");
      },
      onAudioVolumeIndication:
          (connection, speakers, speakerNumber, totalVolume) {
        print("Audio volume indication - Number of speakers: $speakerNumber");
        for (var speaker in speakers) {
          print("Speaker uid: ${speaker.uid}, volume: ${speaker.volume}");
          if (speaker.uid != null && speaker.volume != null) {
            onUserSpeaking(speaker.uid!, speaker.volume! > 5);
          }
        }
      },
    ));
  }

  Future<void> joinChannel(String channelName, int uid) async {
    final expireTimestamp = currentTimestamp + expirationInSeconds;
    await _engine?.setChannelProfile(
      ChannelProfileType.channelProfileLiveBroadcasting,
    );
    await _engine?.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    final token = RtcTokenBuilder.build(
      appId: dotenv.env['AGORA_APP_ID']!,
      appCertificate: dotenv.env['AGORA_APP_CERT']!,
      channelName: channelName,
      uid: uid.toString(),
      role: RtcRole.publisher,
      expireTimestamp: expireTimestamp,
    );
    await _engine?.joinChannel(
      token: token,
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel() async {
    await _engine?.leaveChannel();
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    await _engine?.muteLocalAudioStream(_isMuted);
  }

  bool get isMuted => _isMuted;

  void dispose() {
    _engine?.disableAudio();
  }
}
