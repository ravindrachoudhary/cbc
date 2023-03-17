// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:postgres/postgres.dart';
import 'package:tamannaretail/FuncTextFormField.dart';
import 'package:tamannaretail/main.dart';
import 'package:tamannaretail/publicMethod.dart';
import 'package:tamannaretail/publicVariable.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class FrmDatabaseConnection extends StatefulWidget {
  const FrmDatabaseConnection({super.key});

  @override
  State<FrmDatabaseConnection> createState() => _FrmDatabaseConnectionState();
}

class _FrmDatabaseConnectionState extends State<FrmDatabaseConnection> {
  final formGlobalKey = GlobalKey<FormState>();
  final FocusScopeNode _node = FocusScopeNode();
  var contents;
  final CtrlHost = TextEditingController();
  final CtrlPort = TextEditingController();
  final CtrlUserName = TextEditingController();
  final CtrlPassword = TextEditingController();

  bool isConnected = false;
  FocusNode OK = FocusNode();
  FocusNode NodeHost = FocusNode();
  FocusNode NodePort = FocusNode();
  FocusNode NodeUserName = FocusNode();
  FocusNode NodePassword = FocusNode();

  @override
  void dispose() {
    _node.dispose();
    NodeHost.dispose();
    super.dispose();
  }

  @override
  void initState() {
    if (Common.notConnected == true) {
      CtrlHost.text = DBConnection.Host.toString();
    }
    if (Common.notConnected == true) {
      CtrlPort.text = DBConnection.Port.toString();
    }
    if (Common.notConnected == true) {
      CtrlUserName.text = DBConnection.UserName.toString();
    }
    if (Common.notConnected == true) {
      CtrlPassword.text = DBConnection.Password.toString();
    }
    selectedText(NodeHost, CtrlHost);
    selectedText(NodePort, CtrlPort);
    selectedText(NodeUserName, CtrlUserName);
    selectedText(NodePassword, CtrlPassword);
    super.initState();
  }

  Future writeDataToCnnFile() async {
    bool cnnFileExist = await Connect.myFile.exists();

    if (cnnFileExist == true) {
      await Connect.myFile.delete();
    }
    var Host = CtrlHost.text.trim();
    var Port = int.parse(CtrlPort.text.trim());
    var UserName = CtrlUserName.text.trim();
    var Password = CtrlPassword.text.trim();
    var connection = PostgreSQLConnection("${Host}", Port, "",
        username: "${UserName}",
        password: "${Password}",
        timeoutInSeconds: 600,
        queryTimeoutInSeconds: 600);

    EasyLoading.show(status: "Please wait while we connect your database");
    try {
      await connection.open().then((value) async {
        isConnected = true;
        contents = "$Host"
            "\n$Port"
            "\n$UserName"
            "\n$Password";

        await Connect.myFile.create();
        await Connect.myFile.writeAsString(contents.toString());
      });
      EasyLoading.dismiss();
    } catch (e) {
      addNewBugToList(e);
    }

    if (isConnected == false) {
      showDialogBox(context, 'Please enter correct details', '', [
        buttonElevated(true, () {
          FocusScope.of(context).requestFocus(NodeHost);
          Navigator.pop(context);
        }, 'OK')
      ]);
    } else {
      showDialogBox(context, 'Yeah!!! Successfully Connected', '', [
        buttonElevated(true, () {
          Navigator.pushNamedAndRemoveUntil(
              context, "/FrmSelectDatabase", (_) => false);
        }, 'OK')
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Form(
        autovalidateMode: AutovalidateMode.always,
        key: formGlobalKey,
        child: FocusScope(
          node: _node,
          child: Column(
            children: [
              const SizedBox(height: 50),
              funcTextFormField(true, false, CtrlHost, (value) {
                return (value!.isEmpty) ? 'Please enter Host' : null;
              }, "Host", tmpFocusNode: NodeHost),
              const SizedBox(height: 24),
              funcTextFormField(false, false, CtrlPort, (value) {
                return (value!.isEmpty) ? 'Please enter Port' : null;
              }, "Port",
                  tmpInputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  tmpFocusNode: NodePort),
              const SizedBox(height: 24),
              funcTextFormField(false, false, CtrlUserName, (value) {
                return (value!.isEmpty) ? 'Please enter UserName' : null;
              }, "UserName", tmpFocusNode: NodeUserName),
              const SizedBox(height: 24),
              TextFormField(
                obscureText: true,
                controller: CtrlPassword,
                focusNode: NodePassword,
                validator: (value) {
                  return (value!.isEmpty) ? 'Please enter Password' : null;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: "Password",
                ),
              ),
              const SizedBox(height: 50),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await writeDataToCnnFile();
                    },
                    child: const Text('TEST & SUBMIT'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialogBox(
                          context, 'Are you Sure', 'Do you want to exit?', [
                        buttonElevated(false,
                            () => Navigator.of(context).pop(false), 'No'),
                        buttonElevated(true, () => exit(0), 'Yes')
                      ]);
                    },
                    child: Text('EXIT'),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ));
  }
}
