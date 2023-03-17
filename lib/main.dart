// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:tamannaretail/Forms/frmCountryMaster.dart';
import 'package:tamannaretail/Forms/frmDatabaseConnection.dart';
import 'package:tamannaretail/Forms/frmMdi.dart';
import 'package:tamannaretail/Forms/frmSelectDatabase.dart';
import 'package:tamannaretail/Forms/frmCompanyList.dart';
import 'package:tamannaretail/Forms/frmThemeColor.dart';
import 'package:tamannaretail/grid.dart';

import 'package:tamannaretail/publicMethod.dart';

import 'package:tamannaretail/splashScreen.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  checkConnectCnn();
  // WidgetsFlutterBinding.ensureInitialized();
  // await windowManager.ensureInitialized();
  // hide();
  runApp(const MyApp());
}

// void hide() {
//   WindowOptions windowOptions = const WindowOptions(
//     center: true,
//     titleBarStyle: TitleBarStyle.hidden,
//   );
//   windowManager.waitUntilReadyToShow(windowOptions, () async {
//     await windowManager.show();
//   });
// }

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        // textTheme: fontBold(),
      ),
      builder: EasyLoading.init(),
      home: const SplashScreen(),
      routes: {
        "/FrmDatabase": (context) => const FrmDatabaseConnection(),
        "/Home": (context) => const MyHomePage(
              title: '',
            ),
        "/FrmSelectDatabase": (context) => const FrmSelectDatabase(),
        "/FrmCompanyList": (context) => const FrmCompanyList(),
        "/FrmMdi": (context) => const FrmMdi(),
        "/FrmCountryMaster": (context) => const FrmCountryMaster(),
        "/MainGrid": (context) => const MainGrid(),
        "/FrmThemeColor": (context) => const FrmThemeColor(
              title: '',
            ),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  @override
  void initState() {
    readConnectCnnFile(context);
    super.initState();
  }

  @override
  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),

      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
