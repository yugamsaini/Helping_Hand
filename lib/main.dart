import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:helping_hand/firebase_options.dart';
import 'package:helping_hand/providers/organisation_provider.dart';
import 'package:helping_hand/providers/user_provider.dart';
import 'package:helping_hand/resources/notifications.dart';
import 'package:helping_hand/views/organisation/org_edit_profile.dart';
import 'package:helping_hand/views/organisation/org_feed.dart';
import 'package:helping_hand/views/organisation/org_profile.dart';
import 'package:helping_hand/views/user/profile_page.dart';
import 'package:helping_hand/widgets/utils.dart';
import 'package:helping_hand/resources/auth_page.dart';
import 'package:provider/provider.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  print("Handling a background message: ${message.messageId}");
}

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // var res = await FlutterNotificationChannel.registerNotificationChannel(
  //   description: 'For showing message notification',
  //   id: 'chats',
  //   importance: NotificationImportance.IMPORTANCE_HIGH,
  //   name: 'Chats',
  //   visibility: v.NotificationVisibility.VISIBILITY_PUBLIC,
  // );
  // print('\n$res');
  await Notifications.createNotificationChannel('chats', 'Chats');
  await Notifications.initNotification();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrganisationProvider(),
        ),
      ],
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: colorCustom,
          fontFamily: 'Poppins'
        ),
        debugShowCheckedModeBanner: false,
        home:  OrganisationProfilePage(), 
      ),
    );
  }
}
