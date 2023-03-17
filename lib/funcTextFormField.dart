import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tamannaretail/publicMethod.dart';
import 'package:tamannaretail/publicVariable.dart';

funcTextFormField(bool tmpAutoFocus, bool tmpObscureText,
    TextEditingController tmpCtrl, var tmpValidatorValue, String tmpLabelText,
    {var tmpFocusNode, var tmpInputFormatters, var tmpOnEditingComplete}) {
  return TextFormField(
    autofocus: tmpAutoFocus,
    obscureText: tmpObscureText,
    focusNode: tmpFocusNode,
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
      labelText: tmpLabelText,
    ),
    controller: tmpCtrl,
    validator: tmpValidatorValue,
    inputFormatters: tmpInputFormatters,
    onEditingComplete: tmpOnEditingComplete,
  );
}

funcTextFormField1(double height, double width, String label, bool autofocus,
    TextEditingController controller1, int length, bool enabled,
    {var tmpFocusNode}) {
  return SizedBox(
    height: height * 0.07,
    width: width * 0.3,
    child: Padding(
      padding: const EdgeInsets.all(5),
      child: TextFormField(
        inputFormatters: [
          ToUpperCase(),
          LengthLimitingTextInputFormatter(length),
        ],
        controller: controller1,
        autofocus: autofocus,
        textInputAction: TextInputAction.next,
        obscureText: false,
        decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor()),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: fieldBorderFocusColor()),
            ),
            filled: true,
            fillColor: fieldBackgroundColor(),
            label: Text(label,
                style: TextStyle(
                    // fontWeight: fontBold(),
                    color: fontColordfg(),
                    fontStyle: fontItalic())),
            border: const OutlineInputBorder()),
        enabled: enabled,
        focusNode: tmpFocusNode,
      ),
    ),
  );
}
