import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tamannaretail/menu_bar.dart';

import 'package:tamannaretail/publicVariable.dart';
import 'package:window_size/window_size.dart';

class FrmMdi extends StatefulWidget {
  const FrmMdi({super.key});

  @override
  State<FrmMdi> createState() => _FrmMdiState();
}

class _FrmMdiState extends State<FrmMdi> {
  @override
  void initState() {
    super.initState();
  }

  var year = DBConnection.DBName.substring(DBConnection.DBName.length - 6);

  @override
  Widget build(BuildContext context) {
    setWindowTitle(Company.name);

    return Scaffold(
      body: Container(
        child: Column(
          children: [
            NavBar(),
            Text(
              Company.name,
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              "(${year.substring(0, 4)}-${year.substring(4, 6)})",
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 32.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
