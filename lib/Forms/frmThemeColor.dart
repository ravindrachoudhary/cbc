// ignore_for_file: use_build_context_synchronously
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamannaretail/pickers/hsv_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:tamannaretail/publicVariable.dart';
import '../publicMethod.dart';

class FrmThemeColor extends StatefulWidget {
  const FrmThemeColor({super.key, required this.title});

  final String title;

  @override
  State<FrmThemeColor> createState() => _FrmThemeColorState();
}

class _FrmThemeColorState extends State<FrmThemeColor> {
  bool fontItalic = ThemeColor.labelFontStyle == 'true';
  bool fontBold = ThemeColor.labelFontWeight == 'true';
  FocusNode NodeFontColor = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  void changeFontColor(Color color) {
    setState(() {
      DefaultTheme.defaultFontColor = color;
      ThemeColor.fontColor = substring(DefaultTheme.defaultFontColor, 6, 16);
    });
  }

  void changeButtonColor(Color color) {
    setState(() {
      DefaultTheme.defaultButtonColor = color;
      ThemeColor.buttonColor =
          substring(DefaultTheme.defaultButtonColor, 6, 16);
    });
  }

  void changeButtonFontColor(Color color) {
    setState(() {
      DefaultTheme.defaultButtonFontColor = color;
      ThemeColor.buttonFontColor =
          substring(DefaultTheme.defaultButtonFontColor, 6, 16);
    });
  }

  void changeFieldBackColor(Color color) {
    setState(() {
      DefaultTheme.defaultFieldBackColor = color;
      ThemeColor.fieldBackColor =
          substring(DefaultTheme.defaultFieldBackColor, 6, 16);
    });
  }

  void changeFieldBorderColor(Color color) {
    setState(() {
      DefaultTheme.defaultFieldBorderColor = color;
      ThemeColor.fieldBorderColor =
          substring(DefaultTheme.defaultFieldBorderColor, 6, 16);
    });
  }

  void changeBackgroundColor(Color color) {
    setState(() {
      DefaultTheme.defaultBackgroundColor = color;
      ThemeColor.backgroundColor =
          substring(DefaultTheme.defaultBackgroundColor, 6, 16);
    });
  }

  void changeFieldBorderFocusColor(Color color) {
    setState(() {
      DefaultTheme.defaultFieldBorderFocusColor = color;
      ThemeColor.fieldBorderFocusColor =
          substring(DefaultTheme.defaultFieldBorderFocusColor, 6, 16);
    });
  }

  insertThemeSettings() async {
    await sqlQueryDB("DELETE FROM public.theme_setting", []);
    var a = await sqlQueryDB(
        "INSERT into theme_setting(theme_type,theme_value) VALUES ('FONT COLOUR', '${ThemeColor.fontColor}'), ('BUTTON COLOUR', '${ThemeColor.buttonColor}'),('BUTTON FONT COLOUR', '${ThemeColor.buttonFontColor}'),('FIELD BACKGROUND COLOUR', '${ThemeColor.fieldBackColor}'),('FIELD BORDER COLOUR', '${ThemeColor.fieldBorderColor}'),('BACKGROUND COLOUR', '${ThemeColor.backgroundColor}'),('FIELD BORDER FOCUS COLOUR', '${ThemeColor.fieldBorderFocusColor}'),('LABLE FONT STYLE', '${ThemeColor.labelFontStyle}'),('LABLE FONT WEIGHT', '${ThemeColor.labelFontWeight}')Returning theme_value;",
        []);
    if (a.isNotEmpty) {
      return showDialogBox(context, '', 'Data has Added Successfully', [
        buttonElevated(true, () {
          Navigator.of(context).popAndPushNamed('/FrmMdi');
        }, 'OK')
      ]);
    } else {
      return showDialogBox(context, '', 'Error!', [
        buttonElevated(true, () {
          // Navigator.of(context).pop();
          FocusScope.of(context).requestFocus(NodeFontColor);
        }, 'OK')
      ]);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 400, top: 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Font Color :'),
                const SizedBox(
                  width: 10,
                ),
                HSVColorPickerExample(
                    pickerColor: fontColordfg(),
                    onColorChanged: changeFontColor,
                    enableAlpha: true),
                const SizedBox(
                  width: 150,
                ),
                const Text('Button Color :'),
                const SizedBox(
                  width: 10,
                ),
                HSVColorPickerExample(
                    pickerColor: buttonColor(),
                    onColorChanged: changeButtonColor,
                    enableAlpha: true),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Button Font Color :'),
                const SizedBox(
                  width: 10,
                ),
                HSVColorPickerExample(
                    pickerColor: buttonFontColor(),
                    onColorChanged: changeButtonFontColor,
                    enableAlpha: true),
                const SizedBox(
                  width: 100,
                ),
                const Text('Field Background Color :'),
                const SizedBox(
                  width: 10,
                ),
                HSVColorPickerExample(
                    pickerColor: fieldBackgroundColor(),
                    onColorChanged: changeFieldBackColor,
                    enableAlpha: true),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Field Border Color :'),
                const SizedBox(
                  width: 10,
                ),
                HSVColorPickerExample(
                    pickerColor: fieldBorderColor(),
                    onColorChanged: changeFieldBorderColor,
                    enableAlpha: true),
                const SizedBox(
                  width: 100,
                ),
                const Text('Background Color :'),
                const SizedBox(
                  width: 10,
                ),
                HSVColorPickerExample(
                    pickerColor: backGroundColor(),
                    onColorChanged: changeBackgroundColor,
                    enableAlpha: true),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                const Text('Field Border Focus Color :'),
                const SizedBox(
                  width: 10,
                ),
                HSVColorPickerExample(
                    pickerColor: fieldBorderFocusColor(),
                    onColorChanged: changeFieldBorderFocusColor,
                    enableAlpha: true),
              ],
            ),
            Row(
              children: [
                const Text('Lable Font Style Italic:'),
                const SizedBox(
                  width: 10,
                ),
                Checkbox(
                  checkColor: Colors.greenAccent,
                  activeColor: Colors.red,
                  value: fontItalic,
                  onChanged: (bool? value) {
                    setState(() {
                      fontItalic = value!;
                      ThemeColor.labelFontStyle = value.toString();
                    });
                  },
                ),
                const Text('Lable Font Bold:'),
                const SizedBox(
                  width: 10,
                ),
                Checkbox(
                  checkColor: Colors.greenAccent,
                  activeColor: Colors.red,
                  value: fontBold,
                  onChanged: (bool? value) {
                    setState(() {
                      fontBold = value!;
                      ThemeColor.labelFontWeight = value.toString();
                    });
                  },
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 180),
                  child: ElevatedButton(
                      onPressed: () async {
                        // saveTheme();

                        await insertThemeSettings();
                      },
                      child: const Text(
                        'Save',
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                      onPressed: () async {
                        await resetTheme(setState);
                        setState(() {
                          Future.delayed(Duration.zero, () async {
                            await themeSetting();
                            fontItalic = ThemeColor.labelFontStyle == 'true';
                            fontBold = ThemeColor.labelFontWeight == 'true';
                          });
                        });
                      },
                      child: const Text(
                        'Reset',
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                      onPressed: () async {
                        setState(() {
                          Future.delayed(Duration.zero, () async {
                            await themeSetting();
                            fontItalic = ThemeColor.labelFontStyle == 'true';
                            fontBold = ThemeColor.labelFontWeight == 'true';
                          });
                        });
                      },
                      child: const Text(
                        'Cancel',
                      )),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: ElevatedButton(
                    onPressed: () {
                      Future.delayed(Duration(seconds: 1), () async {
                        await themeSetting();
                      });

                      Navigator.pop(context);
                    },
                    child: Text('EXIT'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
