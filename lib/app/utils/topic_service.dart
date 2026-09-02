import 'package:firebase_messaging/firebase_messaging.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class TopicService {
  static const String globalTopic = 'qbsc_all';

  static Future<void> saveTopic(String topic) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('topic', topic);
  }

  static Future<String?> getSavedTopic() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('topic');
  }

  static Future<void> unsubscribeOldTopic() async {
    final prefs = await SharedPreferences.getInstance();
    String? oldTopic = prefs.getString('topic');

    if (oldTopic != null) {
      await FirebaseMessaging.instance.unsubscribeFromTopic(oldTopic);
      print("⚠️ Unsubscribed old topic: $oldTopic");
    }
  }

  static Future<void> subscribeNewTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
    print("🟩 Subscribed to: $topic");

    await saveTopic(topic);
  }

  /// Panggil saat app start / login
  static Future<void> initializeTopicOnStartup() async {
    if (Platform.isIOS) return;
    // ✅ global topic (selalu aktif)
    await FirebaseMessaging.instance.subscribeToTopic(globalTopic);

    // ✅ company topic (jika ada)
    String? topic = await getSavedTopic();
    if (topic != null) {
      await FirebaseMessaging.instance.subscribeToTopic(topic);
      print("🔁 Auto resubscribed topic: $topic");
    }
  }
}
