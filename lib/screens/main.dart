import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../firebase_options.dart';
import '../models/Local.dart';
import 'location/LocationDetails.dart';
import 'location/LocationPage.dart';
import 'poi/POIDetails.dart';
import 'poi/POIPage.dart';

void initFirebase() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

}

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initFirebase();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PraticalWork2',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Color(0xFF02458A)),
        useMaterial3: true,
      ),
      initialRoute: LocationPage.routeName,
      routes: {
        LocationPage.routeName : (context) => const LocationPage(title: 'Locations'),
        LocationDetailPage.routeName: (context) =>  LocationDetailPage(),
        POIPage.routeName: (context) => const POIPage(title: 'Points of Interest',),
        POIDetailPage.routeName: (context) => POIDetailPage(),
      },
    );
  }
}

