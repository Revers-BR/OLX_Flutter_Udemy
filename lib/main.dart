import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:olx_flutter/config/config.dart';
import 'package:olx_flutter/config/firebase_options.dart';
import 'package:olx_flutter/views/login.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  
  runApp(MaterialApp(
    title: "OLX",
    home: const Login(),
    theme: tema,
  ));
}