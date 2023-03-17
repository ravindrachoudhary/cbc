// ignore_for_file: constant_identifier_names, camel_case_types, use_build_context_synchronously, non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:tamannaretail/FormSettings.dart/publicSettingVariable.dart';

import 'package:tamannaretail/funcTextFormField.dart';

import 'package:tamannaretail/publicMethod.dart';
import 'package:tamannaretail/publicVariable.dart';
import 'package:tamannaretail/FormSettings.dart/themeSettings.dart';
import 'package:window_size/window_size.dart';

class FrmCountryMaster extends StatefulWidget {
  const FrmCountryMaster({super.key});

  @override
  State<FrmCountryMaster> createState() => _FrmCountryMasterState();
}

class _FrmCountryMasterState extends State<FrmCountryMaster> {
  final FocusScopeNode _node = FocusScopeNode();
  final CtrlCountryName = TextEditingController();
  final CtrlCountryShortName = TextEditingController();
  final CtrlCountryCode = TextEditingController();
  final CtrlContinent = TextEditingController();
  final CtrlCurrency = TextEditingController();
  final CtrlCurrencySymbol = TextEditingController();
  final CtrlCurrencyPlacement = TextEditingController();
  FocusNode NodeCountryName = FocusNode();
  FocusNode NodeAdd = FocusNode();
  FocusNode NodeView = FocusNode();
  final _formKeyScreen1 = GlobalKey<FormState>();

  @override
  void initState() {
    FilterConstant.isAdd = true;
    FilterConstant.buttonView = true;
    FilterConstant.buttonUpdate = false;
    setState(() {});
    clearTextField();
    (FilterConstant.isEdit) ? fetchCountryMasterDetail() : clearTextField();
    super.initState();
  }

  reset() {
    FilterConstant.isAdd = true;
    FilterConstant.buttonView = true;
    FilterConstant.isEdit = false;
    FilterConstant.buttonAddSave = true;
    FilterConstant.buttonUpdate = false;
    FilterConstant.buttonCancel = false;
    setState(() {});
    clearTextField();
    (FilterConstant.isEdit) ? fetchCountryMasterDetail() : clearTextField();
  }

  @override
  void dispose() {
    _node.dispose();
    NodeCountryName.dispose();
    NodeAdd.dispose();
    NodeView.dispose();
    super.dispose();
  }

  void clearTextField() {
    CtrlContinent.clear();
    CtrlCountryCode.clear();
    CtrlCountryShortName.clear();
    CtrlCountryName.clear();
    CtrlCurrency.clear();
    CtrlCurrencyPlacement.clear();
    CtrlCurrencySymbol.clear();
  }

  Future saveCountryMaster() async {
    var a = await sqlQueryDB(
        "INSERT INTO public.country_master(country_name, country_short_name, country_code, currency_code, currency_symbol,currency_placement, continent, lat, long) values('${toUpperCaseAndReplace(CtrlCountryName.text)}','${toUpperCaseAndReplace(CtrlCountryShortName.text)}','${CtrlCountryCode.text}','${CtrlCurrency.text}','${CtrlCurrencySymbol.text}','${CtrlCurrencyPlacement.text}','${toUpperCaseAndReplace(CtrlContinent.text)}','ff','uh')Returning country_id;",
        []);

    if (a.isNotEmpty) {
      return showDialogBox(context, '', 'Data has recorded successfully!', [
        buttonElevated(true, () {
          FilterConstant.buttonCancel = false;
          Navigator.of(context).pushAndRemoveUntil<void>(
            MaterialPageRoute<void>(
                builder: (BuildContext context) => const FrmCountryMaster()),
            ModalRoute.withName('/FrmMdi'),
          );
        }, 'OK')
      ]);
    } else {
      return showDialogBox(context, '', 'Error!', [
        buttonElevated(true, () {
          Navigator.of(context).pop();
          FocusScope.of(context).requestFocus(NodeCountryName);
        }, 'OK')
      ]);
    }
  }

  fetchCountryMasterDetail() async {
    Common.query = await sqlQueryDB(
        'Select country_name, country_short_name, country_code, currency_code, currency_symbol,currency_placement, continent from country_master where country_id= ${Edit.id.toString()};',
        []);

    CtrlCountryName.text = countryDetail('country_name');
    CtrlCountryName.selection =
        TextSelection.collapsed(offset: CtrlCountryName.text.length);
    CtrlCountryShortName.text = countryDetail('country_short_name');
    CtrlCountryCode.text = countryDetail('country_code');
    CtrlCurrency.text = countryDetail('currency_code');
    CtrlCurrencySymbol.text = countryDetail('currency_symbol');
    CtrlCurrencyPlacement.text = countryDetail('currency_placement');
    CtrlContinent.text = countryDetail('continent');
  }

  updateCountryMaster() async {
    var a = await sqlQueryDB(
        "UPDATE public.country_master SET country_name='${toUpperCaseAndReplace(CtrlCountryName.text)}', country_short_name='${toUpperCaseAndReplace(CtrlCountryShortName.text)}',country_code='${CtrlCountryCode.text}',currency_code='${CtrlCurrency.text}',currency_symbol='${CtrlCurrencySymbol.text}',currency_placement='${CtrlCurrencyPlacement.text}',continent='${toUpperCaseAndReplace(CtrlContinent.text)}' where country_id= '${Edit.id.toString()}' RETURNING country_id;",
        []);

    if (a.isNotEmpty) {
      return showDialogBox(context, '', 'Successfully Updated', [
        buttonElevated(true, () {
          reset();
          FocusScope.of(context).requestFocus(NodeView);
          Navigator.of(context).pop();
        }, 'ok')
      ]);
    } else {
      return showDialogBox(context, '', 'Invalid Username/Password', [
        buttonElevated(true, () {
          FocusScope.of(context).requestFocus(NodeCountryName);
          Navigator.of(context).pop();
        }, 'ok')
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    setWindowTitle('Country Master');
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Center(
        child: Container(
          decoration: BoxDecoration(
            color: backGroundColor(),
            border: Border.all(),
          ),
          child: Form(
            key: _formKeyScreen1,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  funcTextFormField1(
                      height,
                      width,
                      'Country Name',
                      (FilterConstant.isEdit) ? false : true,
                      CtrlCountryName,
                      100,
                      true,
                      tmpFocusNode: NodeCountryName),
                  Visibility(
                    visible: SettingsCountry.continent == 'false',
                    child: funcTextFormField1(height, width, 'Continent', false,
                        CtrlContinent, 50, textFormEnableOrDisable()),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: SettingsCountry.countryShortName == 'false',
                    child: funcTextFormField1(
                        height,
                        width,
                        'Short Name',
                        false,
                        CtrlCountryShortName,
                        5,
                        textFormEnableOrDisable()),
                  ),
                  Visibility(
                    visible: SettingsCountry.currencyCode == 'false',
                    child: funcTextFormField1(height, width, 'Currency', false,
                        CtrlCurrency, 5, textFormEnableOrDisable()),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: SettingsCountry.countryCode == 'false',
                    child: funcTextFormField1(height, width, 'Country Code',
                        false, CtrlCountryCode, 5, textFormEnableOrDisable()),
                  ),
                  Visibility(
                    visible: SettingsCountry.currencySymbol == 'false',
                    child: funcTextFormField1(
                        height,
                        width,
                        'Currency Symbol',
                        false,
                        CtrlCurrencySymbol,
                        5,
                        textFormEnableOrDisable()),
                  )
                ],
              ),
              SizedBox(
                height: height * 0.01,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Visibility(
                    visible: SettingsCountry.currencyPlacement == 'false',
                    child: funcTextFormField1(
                        height,
                        width,
                        'Currency Placement',
                        false,
                        CtrlCurrencyPlacement,
                        5,
                        textFormEnableOrDisable()),
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonButton(width, height, context, NodeCountryName,
                      setState, NodeAdd, 'Add',
                      saveMaster: saveCountryMaster),
                  SizedBox(
                    width: width * 0.002,
                  ),
                  commonButton(width, height, context, NodeCountryName,
                      setState, NodeView, 'View',
                      view_gridFile: '/MainGrid'),
                  commonButton(
                      width, height, context, '', setState, '', 'Update',
                      saveMaster: updateCountryMaster),
                  SizedBox(
                    width: width * 0.002,
                  ),
                  commonButton(
                      width, height, context, NodeAdd, setState, '', 'Cancel',
                      cancel_clearTextField: clearTextField,
                      cancel_reset: reset),
                  SizedBox(
                    width: width * 0.002,
                  ),
                  commonButton(
                      width, height, context, '', setState, '', 'Exit'),
                ],
              ),
            ]),
          ),
        ),
      ),
    );
  }
}
