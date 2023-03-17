import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgres/postgres.dart';
import 'package:tamannaretail/deviceId.dart';

class Connect {
  static bool checkIfConnectCnnexists = false;
  static var myFile = File('connect.cnn');
  static var loginFile = File('login${DeviceId.deviceDetails['userName']}.log');
  static bool checkIfLoginFileexist = false;
}

class DBConnection {
  static var Host;
  static var Port;
  static var UserName;
  static var Password;
  static String DBName = '';
}

class Common {
  static List<String> arrBugsList = [];
  static bool notConnected = false;
  static var UserName = '';
}

class PostGresSqlConnect {
  static var connection = PostgreSQLConnection(
      "${DBConnection.Host}", DBConnection.Port, "",
      username: "${DBConnection.UserName}",
      password: "${DBConnection.Password}",
      timeoutInSeconds: 600,
      queryTimeoutInSeconds: 600);
  static var dbconnection = PostgreSQLConnection(
    "${DBConnection.Host}",
    DBConnection.Port,
    DBConnection.DBName,
    username: "${DBConnection.UserName}",
    password: "${DBConnection.Password}",
  );
  static bool connectionWithDB = false;
}

class Company {
  static var name;
  static List<Map> companyName = [];
  static var noOfRecord;
}

class FilterConstant {
  static bool isAdd = true;
  static bool isEdit = false;
  static bool buttonUpdate = true;
  static bool buttonView = true;
  static bool buttonCancel = false;
  static bool buttonAddSave = true;
}

class Country {
  static var detail;
}

class Edit {
  static var id;
}

class ToUpperCase extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return newValue.copyWith(text: newValue.text.toUpperCase());
  }
}

class ThemeColor {
  static var fontColor = "";
  static var buttonColor = "";
  static var buttonFontColor = "";
  static var fieldBackColor = "";
  static var fieldBorderColor = "";
  static var backgroundColor = "";
  static var fieldBorderFocusColor = "";
  static var labelFontStyle = "";
  static var labelFontWeight = "";
}

class DefaultTheme {
  static var defaultFontColor = Color(0xff443a49);
  static var defaultButtonColor = Color(0xff443a49);
  static var defaultButtonFontColor = Color(0xff443a49);
  static var defaultFieldBackColor = Color(0xff443a49);
  static var defaultFieldBorderColor = Color(0xff443a49);
  static var defaultBackgroundColor = Color(0xff443a49);
  static var defaultFieldBorderFocusColor = Color(0xff443a49);
  static var defaultLabelFontStyle = FontStyle.normal;
  static var defaultLabelFontWeight = FontWeight.normal;
}
