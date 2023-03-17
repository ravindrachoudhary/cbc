import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tamannaretail/deviceId.dart';
import 'package:tamannaretail/readCnn.dart';
import 'package:tamannaretail/Forms/frmDatabaseConnection.dart';
import 'package:tamannaretail/Forms/frmSelectDatabase.dart';
import 'package:tamannaretail/publicMethod.dart';
import 'package:tamannaretail/publicVariable.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    initPlatformState(setState, mounted);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSplashScreen(
        duration: 1,
        splash: 'assets/images/splash.jpg',
        nextScreen: (Connect.checkIfConnectCnnexists == false)
            ? FrmDatabaseConnection()
            : ConnectCnn(),
        splashTransition: SplashTransition.fadeTransition,
      ),
    );
  }
}
