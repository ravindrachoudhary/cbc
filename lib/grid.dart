import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:pluto_grid/pluto_grid.dart';
import 'package:tamannaretail/publicMethod.dart';
import 'package:tamannaretail/publicVariable.dart';

class MainGrid extends StatefulWidget {
  const MainGrid({Key? key}) : super(key: key);

  @override
  State<MainGrid> createState() => _MainGridState();
}

class _MainGridState extends State<MainGrid> {
  @override
  void initState() {
    Future.delayed(Duration(seconds: 1), () async {
      await countryDetails();
      await ac();

      setState(() {});
    });

    super.initState();
  }

  countryDetails() async {
    Country.detail = await sqlQueryDB(
        'SELECT country_id,continent,currency_placement,currency_symbol,currency_code,country_code,country_short_name,country_name FROM country_master order by country_id asc;',
        []);
    print(Country.detail);
  }

  final List<PlutoColumn> columns = <PlutoColumn>[
    PlutoColumn(
      title: 'Country ID',
      field: 'country_id',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Country Name',
      field: 'country_name',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Country Short Name',
      field: 'country_short_name',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Country Code',
      field: 'country_code',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Currency Code',
      field: 'currency_code',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Currency Symbol',
      field: 'currency_symbol',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Currency Placement ',
      field: 'currency_placement',
      type: PlutoColumnType.text(),
    ),
    PlutoColumn(
      title: 'Continent',
      field: 'continent',
      type: PlutoColumnType.text(),
    ),
  ];

  final List<PlutoRow> rows = <PlutoRow>[];
  ac() {
    EasyLoading.show(status: "Creating Year...");
    for (int index = 0; index < Country.detail.length; index++) {
      rows.add(
        PlutoRow(
          cells: {
            'country_id': PlutoCell(
                value: Country.detail[index]["country_master"]['country_id']),
            'country_name': PlutoCell(
                value: Country.detail[index]["country_master"]['country_name']),
            'country_short_name': PlutoCell(
                value: Country.detail[index]["country_master"]
                    ['country_short_name']),
            'country_code': PlutoCell(
                value: Country.detail[index]["country_master"]['country_code']),
            'currency_code': PlutoCell(
                value: Country.detail[index]["country_master"]
                    ['currency_code']),
            'currency_symbol': PlutoCell(
                value: Country.detail[index]["country_master"]
                    ['currency_symbol']),
            'currency_placement': PlutoCell(
                value: Country.detail[index]["country_master"]
                    ['currency_placement']),
            'continent': PlutoCell(
                value: Country.detail[index]["country_master"]['continent']),
          },
        ),
      );
      EasyLoading.dismiss();
    }
    PlutoGridStateManager.initializeRowsAsync(
      columns,
      rows,
    ).then((value) {
      stateManager.rows.addAll(FilteredList(initialList: value));
      stateManager.notifyListeners();
    });
  }

  // final List<PlutoColumnGroup> columnGroups = [
  //   PlutoColumnGroup(title: 'Id', fields: ['id'], expandedColumn: true),
  //   PlutoColumnGroup(title: 'User information', fields: ['name']),
  // ];

  late final PlutoGridStateManager stateManager;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(15),
        child: PlutoGrid(
          columns: columns,
          rows: rows,
          // columnGroups: columnGroups,
          onLoaded: (PlutoGridOnLoadedEvent event) {
            stateManager = event.stateManager;
            stateManager.gridFocusNode;
            stateManager.setShowColumnFilter(true);
            PlutoGridStateManager.initializeRowsAsync(
              columns,
              rows,
            ).then((value) {
              stateManager.rows.addAll(FilteredList(initialList: value));
              stateManager.notifyListeners();
            });
          },

          onSelected: (event) {
            Edit.id = stateManager.currentRow!.cells['country_id']!.value;
            FilterConstant.isEdit = true;
            FilterConstant.buttonCancel = true;
            FilterConstant.buttonAddSave = false;
            Navigator.of(context).popAndPushNamed('/FrmCountryMaster');
          },
          onRowDoubleTap: (event) {
            print("object");
          },
          onChanged: (PlutoGridOnChangedEvent event) {},
          configuration: const PlutoGridConfiguration(),
          mode: PlutoGridMode.select,
        ),
      ),
    );
  }
}
