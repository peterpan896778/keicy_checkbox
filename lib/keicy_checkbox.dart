library keicy_checkbox;

import 'package:flutter/material.dart';

class KeicyCheckBox extends FormField<Map<String, dynamic>> {
  KeicyCheckBox({
    Key key,
    @required double width,
    @required double height,
    bool value = false,
    IconData trueIcon = Icons.check_box,
    IconData falseIcon = Icons.check_box_outline_blank,
    double iconSize = 25,
    Color iconColor = Colors.blue,
    Color trueIconColor,
    Color falseIconColor,
    Color disabledColor = Colors.grey,
    String label = "",
    double labelFontSize = 20,
    Color labelColor = Colors.black,
    bool autovalidate = false,
    bool enabled = true,
    bool readOnly = false,
    bool fixedHeightState = true,
    bool stateChangePossible = false,
    Function onSaveHandler,
    Function onChangeHandler,
    FormFieldValidator<bool> onValidateHandler,
  }) : super(
          key: key,
          initialValue: {"value": value, "oldValue": value},
          autovalidate: autovalidate,
          validator: (value) {
            if (onValidateHandler != null) return onValidateHandler(value["value"]);
            return null;
          },
          onSaved: (value) {
            onSaveHandler(value["value"]);
          },
          builder: (FormFieldState<Map<String, dynamic>> state) {
            trueIconColor = trueIconColor ?? iconColor;
            falseIconColor = falseIconColor ?? iconColor;
            WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
              if (value != state.value["oldValue"]) {
                state.didChange({"value": value, "oldValue": value});
              }
            });
            return Padding(
              padding: EdgeInsets.zero,
              child: state.value["value"]
                  ? _createTappableIcon(state, enabled, readOnly, trueIcon, trueIconColor, disabledColor, iconSize, label, labelFontSize, labelColor,
                      width, height, fixedHeightState, stateChangePossible, onChangeHandler)
                  : _createTappableIcon(state, enabled, readOnly, falseIcon, falseIconColor, disabledColor, iconSize, label, labelFontSize,
                      labelColor, width, height, fixedHeightState, stateChangePossible, onChangeHandler),
            );
          },
        );

  static Widget _createTappableIcon(
    FormFieldState<Map<String, dynamic>> state,
    bool enabled,
    bool readOnly,
    IconData icon,
    Color iconColor,
    Color disabledColor,
    double iconSize,
    String label,
    double labelFontSize,
    Color labelColor,
    double width,
    double height,
    bool fixedHeightState,
    bool stateChangePossible,
    Function onChangeHandler,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: (enabled && !readOnly) ? () => tapHandler(state, stateChangePossible, onChangeHandler) : null,
          child: Container(
            width: width,
            height: height,
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(icon, color: enabled ? iconColor : disabledColor, size: iconSize),
                SizedBox(width: 10),
                (width == null)
                    ? Text(label, style: TextStyle(fontSize: labelFontSize, color: labelColor))
                    : Expanded(
                        child: Text(label, style: TextStyle(fontSize: labelFontSize, color: labelColor)),
                      )
              ],
            ),
          ),
        ),
        (state.hasError)
            ? Container(
                height: labelFontSize + 5,
                child: Text(
                  (state.errorText ?? ""),
                  style: TextStyle(fontSize: labelFontSize * 0.8, color: Colors.red),
                ),
              )
            : (fixedHeightState) ? SizedBox(height: labelFontSize + 5) : SizedBox(),
      ],
    );
  }
}

void tapHandler(FormFieldState<Map<String, dynamic>> state, bool stateChangePossible, Function onChangeHandler) {
  bool newState = !state.value["value"];
  state.didChange({"value": newState, "oldValue": state.value["oldValue"]});
  if (onChangeHandler != null) onChangeHandler(newState);
}
