import 'package:sendbird_sdk/sendbird_sdk.dart';

class HandleService {
  static final HandleService _instance = HandleService._internal();

  factory HandleService() {
    return _instance;
  }

  HandleService._internal();

  static const String APP_ID = 'BC823AD1-FBEA-4F08-8F41-CF0D9D280FBF';
  static const String CHANNEL_URL =
      'sendbird_open_channel_14092_bf4075fbb8f12dc0df3ccc5c653f027186ac9211';

  static late SendbirdSdk sendbird;

  static Future<void> initialize() async {
    try {
      sendbird = await SendbirdSdk(appId: APP_ID);
    } catch (e) {
      print('Error initializing Sendbird: $e');
    }
  }

  static Future<void> joinChannel() async {
    try {
      OpenChannel channel = await OpenChannel.getChannel(CHANNEL_URL);
      await channel.enter();
    } catch (e) {
      print('Error joining channel: $e');
    }
  }
}
