import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class AgoraService {
  static const String appId = '5c86532fff8e4ab2a918a183946a8adc';
  static const String channelName = 'default_channel';

  RtcEngine? _engine;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await Permission.microphone.request();

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(appId: appId));

    await _engine!.enableAudio();
    await _engine!.setChannelProfile(
      ChannelProfileType.channelProfileLiveBroadcasting,
    );
    await _engine!.setClientRole(role: ClientRoleType.clientRoleBroadcaster);

    _isInitialized = true;
  }

  Future<void> joinChannel() async {
    if (!_isInitialized) await initialize();

    await _engine?.joinChannel(
      token: 'e5f9739e04cc4792b7457eb9a94631c1', // Use token in production
      channelId: channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveChannel() async {
    await _engine?.leaveChannel();
  }

  Future<void> toggleMute(bool muted) async {
    await _engine?.muteLocalAudioStream(muted);
  }

  void dispose() {
    // _engine?.dispose();
    _isInitialized = false;
  }
}
