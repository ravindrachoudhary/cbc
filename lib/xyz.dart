// // ignore_for_file: use_build_context_synchronously, prefer_const_constructors
// import 'package:flutter/material.dart';

// import 'package:flutter_easyloading/flutter_easyloading.dart';
// import 'package:pluto_grid/pluto_grid.dart';

// import 'package:tamannaretail/funcCreateDatabase.dart';
// import 'package:tamannaretail/publicMethod.dart';
// import 'package:tamannaretail/publicVariable.dart';

// class FrmSelectDatabase extends StatefulWidget {
//   const FrmSelectDatabase({super.key});

//   @override
//   State<FrmSelectDatabase> createState() => _FrmSelectDatabaseState();
// }

// class _FrmSelectDatabaseState extends State<FrmSelectDatabase> {
//   ScrollController controller = ScrollController();

//   @override
//   void initState() {
//     super.initState();

//     Future.delayed(Duration(seconds: 0), () async {
//       await loadBatch();

//       await dbRows();
//       setState(() {});
//     });
//   }

//   Future loadBatch() async {
//     try {
//       CheckDB.database = await sqlQuery(
//           "SELECT datname FROM pg_database where datname LIKE 'tamanna_%' ;",
//           []);

//       CheckDB.noOfRecord = CheckDB.database.length;
//       if (CheckDB.noOfRecord == 0) {
//         List<String> list = <String>[
//           (DateTime.now().month <= 3)
//               ? '${DateTime.now().year - 2}-${(DateTime.now().year - 1).toString().substring(2, 4)}'
//               : '${DateTime.now().year - 1}-${(DateTime.now().year).toString().substring(2, 4)}',
//           (DateTime.now().month <= 3)
//               ? '${DateTime.now().year - 1}-${DateTime.now().year.toString().substring(2, 4)}'
//               : '${DateTime.now().year}-${(DateTime.now().year + 1).toString().substring(2, 4)}',
//           (DateTime.now().month <= 3)
//               ? '${DateTime.now().year}-${(DateTime.now().year + 1).toString().substring(2, 4)}'
//               : '${DateTime.now().year + 1}-${(DateTime.now().year + 2).toString().substring(2, 4)}',
//         ];
//         String? dropdownValue = list.first;
//         return showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return StatefulBuilder(
//               builder: (BuildContext context, StateSetter setState) {
//                 return AlertDialog(
//                   title: Text("No Year Found!"),
//                   content:
//                       Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
//                     Text('Do you want to create Year'),
//                     SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         // ignore: unnecessary_new
//                         child: DropdownButton<String>(
//                           value: dropdownValue,
//                           underline: Container(),
//                           items: list
//                               .map<DropdownMenuItem<String>>((String value) {
//                             return DropdownMenuItem<String>(
//                               value: value,
//                               child: Text(value),
//                             );
//                           }).toList(),
//                           onChanged: (String? value) {
//                             setState(() {
//                               dropdownValue = value!;
//                             });
//                           },
//                         )),
//                   ]),
//                   actions: <Widget>[
//                     ElevatedButton(
//                       child: Text(
//                         'CreateDatabase',
//                         style: TextStyle(color: Colors.white),
//                       ),
//                       onPressed: () async {
//                         EasyLoading.show(status: "Creating Year...");
//                         await createDatabaseYear(
//                             dropdownValue!.replaceAll('-', ''));

//                         EasyLoading.dismiss();
//                         Navigator.of(context)
//                             .popAndPushNamed('/FrmSelectDatabase');
//                       },
//                     ),
//                   ],
//                 );
//               },
//             );
//           },
//         );
//       }
//     } catch (e) {
//       return [];
//     }
//   }

//   Future companyDetail() async {
//     Company.companyName = await sqlQuery(
//         "SELECT * FROM dblink( 'host=${DBConnection.Host} port=${DBConnection.Port} dbname= ${CheckDB.database[0]['pg_database']['datname']} user=${DBConnection.UserName} password=${DBConnection.Password}','SELECT company_name FROM company_master') AS t(company_name character varying);",
//         []);
//     Company.noOfRecord = Company.companyName.length;
//     print(Company.companyName);
//   }

//   final List<PlutoColumn> columns = <PlutoColumn>[
//     PlutoColumn(
//       title: 'Database Name',
//       field: 'db_name',
//       type: PlutoColumnType.text(),
//     ),
//   ];

//   final List<PlutoRow> rows = <PlutoRow>[];
//   dbRows() {
//     for (int index = 0; index < CheckDB.database.length; index++) {
//       rows.add(
//         PlutoRow(
//           cells: {
//             'db_name': PlutoCell(
//                 value: CheckDB.database[index]['pg_database']['datname']
//                     .toString()),
//           },
//         ),
//       );
//     }
//     PlutoGridStateManager.initializeRowsAsync(
//       columns,
//       rows,
//     ).then((value) {
//       stateManager.rows.addAll(FilteredList(initialList: value));
//       stateManager.notifyListeners();
//     });
//   }

//   late final PlutoGridStateManager stateManager;
//   @override
//   Widget build(BuildContext context) {
//     var width = MediaQuery.of(context).size.width;
//     var height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       body: Container(
//         padding: const EdgeInsets.all(15),
//         child: PlutoGrid(
//           columns: columns,
//           rows: rows,
//           onSelected: (event) async {
//             print("object");
//           },
//           onRowsMoved: (event) {
//             print("ju");
//           },
//           // columnGroups: columnGroups,
//           onLoaded: (PlutoGridOnLoadedEvent event) {
//             stateManager = event.stateManager;
//             stateManager.setShowColumnFilter(true);

//             //stateManager = event.stateManager;
//           },
         
//           onChanged: (PlutoGridOnChangedEvent event) {},
//           configuration: const PlutoGridConfiguration(),
//           mode: PlutoGridMode.normal,
//         ),
//       ),
//     );
//   }
// }
