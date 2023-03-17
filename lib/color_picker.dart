import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// Just an example of how to use/interpret/format text input's result.
void copyToClipboard(String input) {
  String textToCopy = input.replaceFirst('#', '').toUpperCase();
  if (textToCopy.startsWith('FF') && textToCopy.length == 8) {
    textToCopy = textToCopy.replaceFirst('FF', '');
  }
  Clipboard.setData(ClipboardData(text: '#$textToCopy'));
}

class HSVColorPickerExample extends StatefulWidget {
  const HSVColorPickerExample({
    Key? key,
    required this.pickerColor,
    required this.onColorChanged,
    this.colorHistory,
    this.onHistoryChanged,
    required bool enableAlpha,
  }) : super(key: key);

  final Color pickerColor;
  final ValueChanged<Color> onColorChanged;
  final List<Color>? colorHistory;
  final ValueChanged<List<Color>>? onHistoryChanged;

  @override
  State<HSVColorPickerExample> createState() => _HSVColorPickerExampleState();
}

class _HSVColorPickerExampleState extends State<HSVColorPickerExample> {
  // Picker 1

  // Picker 2
  final bool _displayThumbColor2 = true;
  final bool _enableAlpha2 = true;

  // Picker 4

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // const SizedBox(height: 20),
        Container(
          height: 100,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        titlePadding: const EdgeInsets.all(0),
                        contentPadding: const EdgeInsets.all(0),
                        shape: RoundedRectangleBorder(
                          borderRadius: MediaQuery.of(context).orientation ==
                                  Orientation.portrait
                              ? const BorderRadius.vertical(
                                  top: Radius.circular(500),
                                  bottom: Radius.circular(100),
                                )
                              : const BorderRadius.horizontal(
                                  right: Radius.circular(500)),
                        ),
                        content: SingleChildScrollView(
                          child: HueRingPicker(
                            pickerColor: widget.pickerColor,
                            onColorChanged: widget.onColorChanged,
                            enableAlpha: _enableAlpha2,
                            displayThumbColor: _displayThumbColor2,
                          ),
                        ),
                      );
                    },
                  );
                },
                child: Text(
                  'color',
                  style: TextStyle(
                      color: useWhiteForeground(widget.pickerColor)
                          ? Colors.white
                          : Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: widget.pickerColor,
                  shadowColor: widget.pickerColor.withOpacity(1),
                  elevation: 10,
                ),
              ),
              const SizedBox(width: 20),
              //             ElevatedButton(
              //               onPressed: () {
              //                 showDialog(
              //                   context: context,
              //                   builder: (BuildContext context) {
              //                     return AlertDialog(
              //                       content: SingleChildScrollView(
              //                         child: Text(
              //                           '''
              // HueRingPicker(
              //   pickerColor: color,
              //   onColorChanged: changeColor,
              //   enableAlpha: $_enableAlpha2,
              //   displayThumbColor: $_displayThumbColor2,
              // )
              //                           ''',
              //                         ),
              //                       ),
              //                     );
              //                   },
              //                 );
              //               },
              //               child: Icon(Icons.code,
              //                   color: useWhiteForeground(widget.pickerColor)
              //                       ? Colors.white
              //                       : Colors.black),
              //               style: ElevatedButton.styleFrom(
              //                 backgroundColor: widget.pickerColor,
              //                 shadowColor: widget.pickerColor.withOpacity(1),
              //                 elevation: 10,
              //               ),
              //             ),
            ],
          ),
        ),
        // SwitchListTile(
        //   title: const Text('Enable Alpha Slider'),
        //   value: _enableAlpha2,
        //   onChanged: (bool value) =>
        //       setState(() => _enableAlpha2 = !_enableAlpha2),
        // ),
        // SwitchListTile(
        //   title: const Text('Display Thumb Color in Slider'),
        //   value: _displayThumbColor2,
        //   onChanged: (bool value) =>
        //       setState(() => _displayThumbColor2 = !_displayThumbColor2),
        // ),
        // const Divider(),
        // const SizedBox(height: 5),
        // const SizedBox(height: 80),
      ],
    );
  }
}
