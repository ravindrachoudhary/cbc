import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:tamannaretail/publicMethod.dart';
import 'package:window_size/window_size.dart';

class ConnectCnn extends StatefulWidget {
  const ConnectCnn({super.key});

  @override
  State<ConnectCnn> createState() => _ConnectCnnState();
}

class _ConnectCnnState extends State<ConnectCnn> {
  @override
  void initState() {
    readConnectCnnFile(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    setWindowTitle("Tamanna");
    return Scaffold();
  }
}
