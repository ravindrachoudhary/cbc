import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamannaretail/publicMethod.dart';
import 'package:tamannaretail/publicVariable.dart';
import 'package:window_size/window_size.dart';

class FrmCompanyList extends StatefulWidget {
  const FrmCompanyList({super.key});

  @override
  State<FrmCompanyList> createState() => _FrmCompanyListState();
}

class _FrmCompanyListState extends State<FrmCompanyList> {
  ScrollController controller = ScrollController();

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 0), () async {
      //await loadBatch();

      setState(() {});
    });
  }

  Future loadBatch() async {
    try {
      // Company.companyName =
      //     await sqlQueryDB("SELECT company_name FROM company_master;", []);

      // Company.noOfRecord = Company.companyName.length;
    } catch (e) {
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    setWindowTitle('Company List');
    return Scaffold(
        body: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'COMPANY LIST',
              style: TextStyle(fontSize: 40),
            ),
            Container(
              alignment: Alignment.center,
              width: width * 0.3,
              height: height * 0.5,
              padding: const EdgeInsets.all(20),
              child: ListView.builder(
                  controller: controller,
                  itemCount: Company.noOfRecord ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      children: [
                        ListTile(
                          title: Text(
                            Company.companyName[index]['company_master']
                                    ['company_name']
                                .toString(),
                          ),
                          onTap: () {
                            Company.name = Company.companyName[index]
                                    ['company_master']['company_name']
                                .toString();
                            Navigator.of(context).popAndPushNamed('/FrmMdi');
                          },
                          autofocus: true,
                        ),
                        Divider(),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ],
    ));
  }
}
