// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgres/postgres.dart';
import 'package:process_run/shell_run.dart';
import 'package:tamannaretail/funcCreateDatabase.dart';
import 'package:tamannaretail/publicVariable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:process_run/which.dart';

Future<void> checkConnectCnn() async {
  Connect.checkIfConnectCnnexists = await Connect.myFile.exists();
}

void addNewBugToList(var errorDescription) {
  errorDescription = errorDescription.toString();
  errorDescription = errorDescription.replaceAll("'", "");
  errorDescription = errorDescription.replaceAll("\"", "");
  Common.arrBugsList.add(
      "${"<ul><li><b>Date&Time : </b>${DateFormat('dd MMM, yy - hh:mm a').format(DateTime.now())}<br><b>Description : </b>" + errorDescription}</li></ul>");
  EasyLoading.dismiss();
}

Future<bool> showDialogBox(
    BuildContext context, String title, String content, List<Widget> widget,
    {StateSetter? setState}) async {
  return (await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: widget,
        ),
      )) ??
      false;
}

Future<bool> showDialogBoxList(
    BuildContext context, String title, var list, List<Widget> widget,
    {Function? setState}) async {
  return (await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
          title: Text(title),
          content: list,
          actions: widget,
        ),
      )) ??
      false;
}

Widget buttonElevated(
  bool autofocus,
  var onpress,
  String title,
) {
  return ElevatedButton(
      autofocus: autofocus, onPressed: onpress, child: Text(title));
}

Widget buttonElevatedWithSize(
    var width, var height, bool autofocus, var onpress, String title,
    {var tmpFocusNode}) {
  return SizedBox(
      width: width * 0.07,
      height: height * 0.05,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor(), // This is what you need!
          ),
          focusNode: tmpFocusNode,
          autofocus: autofocus,
          onPressed: onpress,
          child: Text(
            title,
            style: TextStyle(color: buttonFontColor()),
          )));
}
// openCalc() async {
//   var shell = Shell();
//   await shell.run('''calc''');
// }

// Focus(
//         onKey: (node, event) {
// return (event.logicalKey == LogicalKeyboardKey.f1)
//     ? openCalc()
//     : null;
//         },
//         child:)

selectedText(FocusNode node, TextEditingController controller) {
  node.addListener(() {
    if (node.hasFocus) {
      controller.selection =
          TextSelection(baseOffset: 0, extentOffset: controller.text.length);
    }
  });
}

readConnectCnnFile(BuildContext context) async {
  Common.notConnected = true;

  var tmpConnectCnnValue = await Connect.myFile.readAsLines();
  DBConnection.Host = tmpConnectCnnValue[0];
  DBConnection.Port = int.parse(tmpConnectCnnValue[1]);
  DBConnection.UserName = tmpConnectCnnValue[2];
  DBConnection.Password = tmpConnectCnnValue[3];
  EasyLoading.show(status: "Please wait while we connect your database");
  try {
    await PostGresSqlConnect.connection.open().then((value) {
      print("Connected Successfully");
      DBConnection.Host = tmpConnectCnnValue[0];
      DBConnection.Port = int.parse(tmpConnectCnnValue[1]);
      DBConnection.UserName = tmpConnectCnnValue[2];
      DBConnection.Password = tmpConnectCnnValue[3];
    });
    Navigator.pushNamedAndRemoveUntil(
        context, "/FrmSelectDatabase", (_) => false);
  } catch (e) {
    showDialogBox(context, 'Please enter correct details', '', [
      buttonElevated(true, () {
        Navigator.pushNamedAndRemoveUntil(
            context, "/FrmDatabase", (_) => false);
      }, 'OK')
    ]);
  }
  EasyLoading.dismiss();
}

Future<List<Map<String, dynamic>>> sqlQuery(
    String query, List<String> tblNames) async {
  try {
    var data = await PostGresSqlConnect.connection.mappedResultsQuery(query);
    return data;
  } catch (ex) {
    return [];
  }
}

Future<List<Map<String, dynamic>>> sqlQueryDB(
    String query, List<String> tblNames) async {
  try {
    var data = await PostGresSqlConnect.dbconnection.mappedResultsQuery(query);
    return data;
  } catch (ex) {
    return [];
  }
}

pgDownpgUpToEnter(List focusNode, int length, var func) {
  focusNode = List.generate(
      length,
      (index) => FocusNode(onKeyEvent: (node, event) {
            if (event.runtimeType == KeyUpEvent &&
                (event.logicalKey == LogicalKeyboardKey.arrowUp ||
                    event.logicalKey == LogicalKeyboardKey.arrowDown ||
                    event.logicalKey == LogicalKeyboardKey.tab)) {
              [func(index)];
            }

            return KeyEventResult.ignored;
          }));
}

toUpperCaseAndReplace(var value) {
  return value.toUpperCase().replaceFirst("'", "''");
}

countryDetail(String value) {
  return Country.detail[0]['country_master'][value].toString();
}

substring(var field, int start, int end) {
  return field.toString().substring(start, end);
}

themeSetting() async {
  var theme = await sqlQueryDB(
      "select theme_type, theme_value from theme_setting;", []);
  try {
    if (theme.isEmpty) {
      await sqlQueryDB(
          "INSERT into theme_setting(theme_type,theme_value) VALUES ('FONT COLOUR', '${substring(DefaultTheme.defaultFontColor, 6, 16)}'), ('BUTTON COLOUR', '${substring(DefaultTheme.defaultButtonColor, 6, 16)}'),('BUTTON FONT COLOUR', '${substring(DefaultTheme.defaultButtonFontColor, 6, 16)}'),('FIELD BACKGROUND COLOUR', '${substring(DefaultTheme.defaultFieldBackColor, 6, 16)}'),('FIELD BORDER COLOUR', '${substring(DefaultTheme.defaultFieldBorderColor, 6, 16)}'),('BACKGROUND COLOUR', '${substring(DefaultTheme.defaultBackgroundColor, 6, 16)}'),('FIELD BORDER FOCUS COLOUR', '${substring(DefaultTheme.defaultFieldBorderFocusColor, 6, 16)}'),('LABLE FONT STYLE', 'false'),('LABLE FONT WEIGHT', 'false');",
          []);

      for (int i = 0; i <= theme.length - 1; i++) {
        if (theme[i]['theme_setting']['theme_type'] == "FONT COLOUR") {
          ThemeColor.fontColor = theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] == "BUTTON COLOUR") {
          ThemeColor.buttonColor = theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] ==
            "BUTTON FONT COLOUR") {
          ThemeColor.buttonFontColor = theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] ==
            "FIELD BACKGROUND COLOUR") {
          ThemeColor.fieldBackColor = theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] ==
            "FIELD BORDER COLOUR") {
          ThemeColor.fieldBorderColor =
              theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] ==
            "BACKGROUND COLOUR") {
          ThemeColor.backgroundColor = theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] ==
            "FIELD BORDER FOCUS COLOUR") {
          ThemeColor.fieldBorderFocusColor =
              theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] ==
            "LABLE FONT STYLE") {
          ThemeColor.labelFontStyle = theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] ==
            "LABLE FONT WEIGHT") {
          ThemeColor.labelFontWeight = theme[i]['theme_setting']['theme_value'];
        }
      }
    } else {
      for (int i = 0; i <= theme.length - 1; i++) {
        if (theme[i]['theme_setting']['theme_type'] == "FONT COLOUR") {
          ThemeColor.fontColor = theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] == "BUTTON COLOUR") {
          ThemeColor.buttonColor = theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] ==
            "BUTTON FONT COLOUR") {
          ThemeColor.buttonFontColor = theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] ==
            "FIELD BACKGROUND COLOUR") {
          ThemeColor.fieldBackColor = theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] ==
            "FIELD BORDER COLOUR") {
          ThemeColor.fieldBorderColor =
              theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] ==
            "BACKGROUND COLOUR") {
          ThemeColor.backgroundColor = theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] ==
            "FIELD BORDER FOCUS COLOUR") {
          ThemeColor.fieldBorderFocusColor =
              theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] ==
            "LABLE FONT STYLE") {
          ThemeColor.labelFontStyle = theme[i]['theme_setting']['theme_value'];
        } else if (theme[i]['theme_setting']['theme_type'] ==
            "LABLE FONT WEIGHT") {
          ThemeColor.labelFontWeight = theme[i]['theme_setting']['theme_value'];
        }
      }
    }
  } catch (e) {}
}

insertDefaultQueries() async {
  var theme = await sqlQueryDB(
      "select settings_name, settings_value from settings_master;", []);
  try {
    if (theme.isEmpty) {
      await sqlQueryDB(
          "INSERT INTO public.settings_master(settings_module, settings_name, settings_value) VALUES ( 'COUNTRY MASTER', 'COUNTRY SHORT NAME', 'TRUE'),( 'COUNTRY MASTER', 'COUNTRY CODE', 'TRUE'),( 'COUNTRY MASTER', 'CURRENCY CODE', 'TRUE'),( 'COUNTRY MASTER', 'CURRENCY SYMBOL', 'TRUE'),( 'COUNTRY MASTER', 'CURRENCY PLACEMENT', 'TRUE'),( 'COUNTRY MASTER', 'CONTINENT', 'TRUE');",
          []);
      for (int i = 0; i <= theme.length - 1; i++) {
        if (theme[i]['settings_master']['settings_name'] ==
            "COUNTRY SHORT NAME") {
          ThemeColor.fontColor = theme[i]['settings_master']['theme_value'];
        } else if (theme[i]['settings_master']['settings_name'] ==
            "BUTTON COLOUR") {
          ThemeColor.buttonColor = theme[i]['settings_master']['theme_value'];
        } else if (theme[i]['settings_master']['settings_name'] ==
            "COUNTRY CODE") {
          ThemeColor.buttonFontColor =
              theme[i]['settings_master']['theme_value'];
        } else if (theme[i]['settings_master']['settings_name'] ==
            "CURRENCY CODE") {
          ThemeColor.fieldBackColor =
              theme[i]['settings_master']['theme_value'];
        } else if (theme[i]['settings_master']['settings_name'] ==
            "CURRENCY SYMBOL") {
          ThemeColor.fieldBorderColor =
              theme[i]['settings_master']['theme_value'];
        } else if (theme[i]['settings_master']['settings_name'] ==
            "CURRENCY PLACEMENT") {
          ThemeColor.backgroundColor =
              theme[i]['settings_master']['theme_value'];
        } else if (theme[i]['settings_master']['settings_name'] ==
            "CONTINENT") {
          ThemeColor.fieldBorderFocusColor =
              theme[i]['settings_master']['theme_value'];
        }
      }
    } else {
      for (int i = 0; i <= theme.length - 1; i++) {
        if (theme[i]['settings_master']['settings_name'] ==
            "COUNTRY SHORT NAME") {
          ThemeColor.fontColor = theme[i]['settings_master']['theme_value'];
        } else if (theme[i]['settings_master']['settings_name'] ==
            "BUTTON COLOUR") {
          ThemeColor.buttonColor = theme[i]['settings_master']['theme_value'];
        } else if (theme[i]['settings_master']['settings_name'] ==
            "COUNTRY CODE") {
          ThemeColor.buttonFontColor =
              theme[i]['settings_master']['theme_value'];
        } else if (theme[i]['settings_master']['settings_name'] ==
            "CURRENCY CODE") {
          ThemeColor.fieldBackColor =
              theme[i]['settings_master']['theme_value'];
        } else if (theme[i]['settings_master']['settings_name'] ==
            "CURRENCY SYMBOL") {
          ThemeColor.fieldBorderColor =
              theme[i]['settings_master']['theme_value'];
        } else if (theme[i]['settings_master']['settings_name'] ==
            "CURRENCY PLACEMENT") {
          ThemeColor.backgroundColor =
              theme[i]['settings_master']['theme_value'];
        } else if (theme[i]['settings_master']['settings_name'] ==
            "CONTINENT") {
          ThemeColor.fieldBorderFocusColor =
              theme[i]['settings_master']['theme_value'];
        }
      }
    }
  } catch (e) {}
}

fontBold() {
  if (ThemeColor.labelFontWeight == 'false') {
    return FontWeight.normal;
  } else {
    return FontWeight.bold;
  }
}

fontItalic() {
  if (ThemeColor.labelFontStyle == 'false') {
    return FontStyle.normal;
  } else {
    return FontStyle.italic;
  }
}

fontColordfg() {
  return Color(int.parse(ThemeColor.fontColor));
}

borderColor() {
  return Color(int.parse(ThemeColor.fieldBorderColor));
}

fieldBorderFocusColor() {
  return Color(int.parse(ThemeColor.fieldBorderFocusColor));
}

fieldBackgroundColor() {
  return Color(int.parse(ThemeColor.fieldBackColor));
}

buttonColor() {
  return Color(int.parse(ThemeColor.buttonColor));
}

buttonFontColor() {
  return Color(int.parse(ThemeColor.buttonFontColor));
}

fieldBorderColor() {
  return Color(int.parse(ThemeColor.fieldBorderColor));
}

backGroundColor() {
  return Color(int.parse(ThemeColor.backgroundColor));
}

resetTheme(StateSetter setState) async {
  await sqlQueryDB("DELETE FROM public.theme_setting", []);
  DefaultTheme.defaultFontColor = Color(0xff443a49);
  DefaultTheme.defaultButtonColor = Color(0xff443a49);
  DefaultTheme.defaultButtonFontColor = Color(0xff443a49);
  DefaultTheme.defaultFieldBackColor = Color(0xff443a49);
  DefaultTheme.defaultFieldBorderColor = Color(0xff443a49);
  DefaultTheme.defaultBackgroundColor = Color(0xff443a49);
  DefaultTheme.defaultFieldBorderFocusColor = Color(0xff443a49);
  DefaultTheme.defaultLabelFontStyle = FontStyle.normal;
  DefaultTheme.defaultLabelFontWeight = FontWeight.normal;
  await sqlQueryDB(
      "INSERT into theme_setting(theme_type,theme_value) VALUES ('FONT COLOUR', '${substring(DefaultTheme.defaultFontColor, 6, 16).toString()}'), ('BUTTON COLOUR', '${substring(DefaultTheme.defaultButtonColor, 6, 16).toString()}'),('BUTTON FONT COLOUR', '${substring(DefaultTheme.defaultButtonFontColor, 6, 16).toString()}'),('FIELD BACKGROUND COLOUR', '${substring(DefaultTheme.defaultFieldBackColor, 6, 16).toString()}'),('FIELD BORDER COLOUR', '${substring(DefaultTheme.defaultFieldBorderColor, 6, 16).toString()}'),('BACKGROUND COLOUR', '${substring(DefaultTheme.defaultBackgroundColor, 6, 16).toString()}'),('FIELD BORDER FOCUS COLOUR', '${substring(DefaultTheme.defaultFieldBorderFocusColor, 6, 16).toString()}'),('LABLE FONT STYLE', 'false'),('LABLE FONT WEIGHT', 'false');",
      []);
  setState(
    () {},
  );
}
