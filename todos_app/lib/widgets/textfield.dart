import 'package:flutter/material.dart';
import 'package:todos_app/constant/taxonomy.dart';
import 'package:flutter/services.dart';

TextFormField textField(isObscure, isNumeric, label, textController, maxLine, minLine, type) {
  return TextFormField(
    style: AppTypography.labelSmall,

    controller: textController,
    minLines: minLine,
    maxLines: maxLine,

    //isObsecure
    obscureText: isObscure,

    // isNumeric | isNumeric ? TextInputType.number : TextInputType.text,
    keyboardType: type,
    inputFormatters: isNumeric ? [FilteringTextInputFormatter.allow(RegExp("[0-9]"))] : [],
    decoration: InputDecoration(
      border: OutlineInputBorder(),
      // label
      labelText: label,
      labelStyle: AppTypography.labelSmall,
      alignLabelWithHint: true, // Add this line
    ),
  );
}
