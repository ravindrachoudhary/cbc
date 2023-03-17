// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:postgres/postgres.dart';
import 'package:tamannaretail/FuncTextFormField.dart';
import 'package:tamannaretail/deviceId.dart';

import 'package:tamannaretail/funcCreateDatabase.dart';
import 'package:tamannaretail/publicMethod.dart';
import 'package:tamannaretail/publicVariable.dart';
import 'package:window_manager/window_manager.dart';
import 'package:window_size/window_size.dart';

class FrmSelectDatabase extends StatefulWidget {
  const FrmSelectDatabase({super.key});

  @override
  State<FrmSelectDatabase> createState() => _FrmSelectDatabaseState();
}

// void show() {
//   WindowOptions windowOptions = const WindowOptions(
//     center: true,
//     titleBarStyle: TitleBarStyle.normal,
//   );
//   windowManager.waitUntilReadyToShow(windowOptions, () async {
//     await windowManager.show();
//   });
// }

class _FrmSelectDatabaseState extends State<FrmSelectDatabase> {
  ScrollController? _controller;
  ScrollController scroller = ScrollController();
  int selectedIndex = -1;
  var contents;

  List<Widget> companyCard = [];
  final CtrlUsername = TextEditingController();
  final CtrlPassword = TextEditingController();
  FocusNode NodeUsername = FocusNode();
  @override
  void initState() {
    //  show();
    super.initState();

    _controller = ScrollController();

    Future.delayed(Duration(seconds: 0), () async {
      await loadBatch();

      setState(() {});
    });
    Future.delayed(const Duration(milliseconds: 150), () {
      jumpToLast();
    });
  }

  @override
  void dispose() {
    NodeUsername.dispose();
    super.dispose();
  }

  Future loadBatch() async {
    try {
      CheckDB.database = await sqlQuery(
          "SELECT datname FROM pg_database where datname LIKE 'tamanna_%' ORDER BY substring(datname,length(datname)-5,6) ASC;",
          []);

      CheckDB.noOfRecord = CheckDB.database.length;
      if (CheckDB.noOfRecord == 0) {
        createYear(context, 'No year found!!');
      }
    } catch (e) {
      return [];
    }
  }

  Future checkAuth() async {
    try {
      var infoData = await sqlQuery(
          "SELECT * FROM dblink( 'host=${DBConnection.Host} port=${DBConnection.Port} dbname= ${CheckDB.database[selectedIndex]['pg_database']['datname']} user=${DBConnection.UserName} password=${DBConnection.Password}','SELECT username,password FROM user_master') AS t(username character varying,password character varying) WHERE username='${CtrlUsername.text.trim()}' AND password='${CtrlPassword.text.trim()}';",
          []);

      var userInfo = infoData[0]['']['username'];

      var passInfo = infoData[0]['']['password'];

      if (userInfo == CtrlUsername.text.trim() &&
          passInfo == CtrlPassword.text.trim()) {
        try {
          EasyLoading.show(status: 'Successfully LoggedIn');
          await PostGresSqlConnect.connection.close();
          DBConnection.DBName = CheckDB.database[selectedIndex]['pg_database']
                  ['datname']
              .toString();
          await PostGresSqlConnect.dbconnection.open().then((value) async {
            debugPrint("connect");
            PostGresSqlConnect.connectionWithDB = true;
          });
          await insertDefaultQueries();
          await themeSetting();
          EasyLoading.dismiss();
          Company.companyName =
              await sqlQueryDB("SELECT company_name FROM company_master;", []);

          Company.noOfRecord = Company.companyName.length;
          Navigator.of(context).popAndPushNamed("/FrmCompanyList");
          bool loginFileExist = await Connect.loginFile.exists();
          contents = CtrlUsername.text;

          if (loginFileExist == true) {
            await Connect.loginFile.writeAsString(contents.toString());
          } else {
            await Connect.loginFile.create();
            await Connect.loginFile.writeAsString(contents.toString());
          }
        } catch (e) {
          return [];
        }
      }
    } catch (e) {
      return showDialogBox(context, 'Please enter correct details', '', [
        buttonElevated(true, () {
          Navigator.pop(context);
        }, 'Exit')
      ]);
    }
  }

  Future companyDetail() async {
    Company.companyName = await sqlQuery(
        "SELECT * FROM dblink( 'host=${DBConnection.Host} port=${DBConnection.Port} dbname= ${CheckDB.database[selectedIndex]['pg_database']['datname']} user=${DBConnection.UserName} password=${DBConnection.Password}','SELECT company_name,address_1,mobile FROM company_master') AS t(company_name character varying,address_1 character varying,mobile character varying);",
        []);
    Company.noOfRecord = Company.companyName.length;
    CtrlUsername.text = Common.UserName.toString();
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
              content: Builder(
                builder: (context) {
                  var height = MediaQuery.of(context).size.height;
                  var width = MediaQuery.of(context).size.width;

                  return SizedBox(
                    height: height * 0.5,
                    width: width * 0.5,
                    child: Row(
                      children: [
                        Column(
                          children: [
                            Text('COMPANY DETAILS'),
                            Container(
                              height: height * 0.45,
                              width: width * 0.25,
                              padding: EdgeInsets.all(20),
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: Company.noOfRecord ?? 0,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Name:-   ${Company.companyName[index]['']['company_name']}',
                                        ),
                                        Text(
                                          'Address:-   ${Company.companyName[index]['']['address_1']}',
                                        ),
                                        Text(
                                          'Mobile :-   ${Company.companyName[index]['']['mobile']}',
                                        ),
                                        Divider(),
                                      ],
                                    );
                                  }),
                            ),
                          ],
                        ),
                        VerticalDivider(),
                        Container(
                          height: height * 0.40,
                          width: width * 0.23,
                          child: Column(children: [
                            Text('LOGIN'),
                            SizedBox(
                              height: height * 0.03,
                            ),
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  funcTextFormField(true, false, CtrlUsername,
                                      (value) {
                                    return (value!.isEmpty)
                                        ? 'Please enter UserName'
                                        : null;
                                  }, 'UserName', tmpFocusNode: NodeUsername),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  funcTextFormField(true, true, CtrlPassword,
                                      (value) {
                                    return (value!.isEmpty)
                                        ? 'Please enter Host'
                                        : null;
                                  }, 'Password'),
                                  SizedBox(
                                    height: height * 0.05,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        child: Text('Login'),
                                        onPressed: () {
                                          checkAuth();
                                        },
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Cancel')),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        )
                      ],
                    ),
                  );
                },
              ),
            ));
    setState(() {});
  }

  void jumpToLast() {
    _controller!.jumpTo(_controller!.position.maxScrollExtent);
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    // setWindowTitle("Year List");
    return Scaffold(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'YEAR LIST',
              style: TextStyle(fontSize: 40),
            ),
            Container(
              alignment: Alignment.center,
              width: width * 0.3,
              height: height * 0.5,
              padding: EdgeInsets.all(20),
              child: Material(
                child: ListView.builder(
                    controller: _controller,
                    itemCount: CheckDB.noOfRecord ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              CheckDB.database[index]['pg_database']['datname']
                                  .toString(),
                            ),
                            onTap: () async {
                              setState(() {
                                selectedIndex = index;
                              });
                              Connect.checkIfLoginFileexist =
                                  await Connect.loginFile.exists();

                              if (Connect.checkIfLoginFileexist == true) {
                                var tmpConnectCnnValue =
                                    await Connect.loginFile.readAsLines();
                                (tmpConnectCnnValue.isEmpty)
                                    ? Common.UserName = ''
                                    : Common.UserName = tmpConnectCnnValue[0];
                              }

                              await companyDetail();
                            },
                            autofocus: (CheckDB.noOfRecord - 1 == index)
                                ? true
                                : false,
                          ),
                          Divider(),
                        ],
                      );
                    }),
              ),
            ),
          ],
        ),
      ],
    ));
  }
}
