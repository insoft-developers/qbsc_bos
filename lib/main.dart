import 'dart:io';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/controllers/home_controller.dart'; // 🔥 DITAMBAHKAN
import 'package:qbsc_saas/app/controllers/auth_controller.dart'; // 🔥 DITAMBAHKAN

import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/utils/firebase_background_handler.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/utils/topic_service.dart';
import 'package:qbsc_saas/app/views/absensi/absensi.dart';
import 'package:qbsc_saas/app/views/broadcast/broadcast.dart';
import 'package:qbsc_saas/app/views/doc/doc.dart';

import 'package:qbsc_saas/app/views/home_view.dart';
import 'package:qbsc_saas/app/views/kandang/kandang_tab_page.dart';
import 'package:qbsc_saas/app/views/login_view.dart';
import 'package:qbsc_saas/app/views/master/master.dart';
import 'package:qbsc_saas/app/views/notifikasi/notifikasi.dart';
import 'package:qbsc_saas/app/views/patroli/patroli.dart';
import 'package:qbsc_saas/app/views/pengaturan/password/change_password.dart';
import 'package:qbsc_saas/app/views/pengaturan/pengaturan.dart';
import 'package:qbsc_saas/app/views/pengaturan/profil/profil.dart';
import 'package:qbsc_saas/app/views/situasi/situasi.dart';
import 'package:qbsc_saas/app/views/splash_view.dart';
import 'package:qbsc_saas/app/views/tamu/tamu.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  if (Platform.isAndroid) { await messaging.requestPermission(alert: true, badge: true, sound: true); }

  await messaging.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  // ===========================
  //  ANDROID NOTIFICATION SETUP
  // ===========================
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications',
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('notif'),
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.createNotificationChannel(channel);

  const initAndroid = AndroidInitializationSettings("@mipmap/ic_launcher");

  const DarwinInitializationSettings initIOS = DarwinInitializationSettings();

  const InitializationSettings initSettings = InitializationSettings(
    android: initAndroid,
    iOS: initIOS,
  );

  await flutterLocalNotificationsPlugin.initialize(initSettings);

  // ===========================
  //  HIVE DATABASE
  // ===========================

  await Get.putAsync<ApiProvider>(() async => await ApiProvider().init());
  await AppPrefs.init();

  // ====================================
  //  PUT CONTROLLERS GLOBAL (🔥 WAJIB)
  // ====================================
  Get.put(HomeController(), permanent: true); // 🔥 NOTIF BADGE
  Get.put(AuthController(), permanent: true); // 🔥 untuk foto dll

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final homeC = Get.find<HomeController>(); // 🔥 akses badge notif

  @override
  void initState() {
    super.initState();
    TopicService.initializeTopicOnStartup();
    setupForegroundMessageHandler();
  }

  void setupForegroundMessageHandler() {
    FirebaseMessaging.onMessage.listen((message) {
      // ==============================
      //   INCREMENT BADGE (🔥)
      // ==============================
      homeC.increment();
      print('foreground notif');

      final notif = message.notification;

      if (notif != null) {
        flutterLocalNotificationsPlugin.show(
          notif.hashCode,
          notif.title,
          notif.body,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'high_importance_channel',
              'High Importance Notifications',
              importance: Importance.high,
              priority: Priority.high,
              playSound: true,
              sound: RawResourceAndroidNotificationSound('notif'),
            ),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      scaffoldMessengerKey:
      SnackbarHelper.scaffoldMessengerKey,
      debugShowCheckedModeBanner: ApiProvider.isDev ? true : false,
      title: 'QBSC',
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => const SplashView()),
        GetPage(name: '/login', page: () => const LoginView()),
        GetPage(name: '/home', page: () => HomeView()),
        GetPage(name: '/absensi', page: () => Absensi()),
        GetPage(name: '/patroli', page: () => Patroli()),
        GetPage(name: '/kandang', page: () => KandangTabPage()),
        GetPage(name: '/doc', page: () => DocPage()),
        GetPage(name: '/broadcast', page: () => Broadcast()),
        GetPage(name: '/situasi', page: () => SituasiPage()),
        GetPage(name: '/tamu', page: () => TamuPage()),

        GetPage(name: '/pengaturan', page: () => Pengaturan()),
        GetPage(name: '/notifikasi', page: () => Notifikasi()),
        GetPage(name: '/pengaturan/profile', page: () => ProfilePage()),
        GetPage(name: '/pengaturan/password', page: () => ChangePassword()),
        GetPage(name: '/master', page: () =>  Master()),
      ],
    );
  }
}
