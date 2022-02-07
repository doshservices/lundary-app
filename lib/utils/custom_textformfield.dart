import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  String labelText, initialValue, hintText;
  Widget icon, suffixIcon;
  bool obscureText, enabled;
  TextInputType keyboardType;
  TextEditingController controller;
  bool isTextArea;
  Function iconPressed, validator, onSaved, suffixIconPressed;

  CustomTextFormField(
      {this.labelText,
      this.icon,
      this.suffixIcon,
      this.obscureText = false,
      this.enabled = true,
      this.isTextArea = false,
      this.iconPressed = null,
      this.hintText,
      this.suffixIconPressed,
      this.initialValue,
      this.keyboardType = TextInputType.text,
      this.controller,
      this.onSaved,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$labelText"),
        SizedBox(
          height: 5,
        ),
        icon != null
            ? TextFormField(
                controller: controller,
                onSaved: onSaved,
                validator: validator,
                keyboardType: keyboardType,
                enabled: enabled,
                minLines: isTextArea ? 5 : 1,
                maxLines: isTextArea ? 5 : 1,
                initialValue: initialValue,
                obscureText: this.obscureText,
                decoration: InputDecoration(
                  prefixIcon: IconButton(
                    icon: this.icon,
                    onPressed: this.iconPressed,
                  ),
                  suffixIcon: suffixIcon != null
                      ? GestureDetector(
                          onTap: this.suffixIconPressed, child: suffixIcon)
                      : Text(""),
                  hintText: hintText,
                  // prefixIconConstraints: BoxConstraints(minWidth: 20),
                  // border: InputBorder.none,
                  // contentPadding: EdgeInsets.only(left: 20, top: 15),
                  // disabledBorder: InputBorder.none,
                  // enabledBorder: InputBorder.none,
                  // errorBorder: InputBorder.none,
                  // focusedBorder: InputBorder.none,
                  // focusedErrorBorder: InputBorder.none,
                ),
              )
            : TextFormField(
                controller: controller,
                onSaved: onSaved,
                validator: validator,
                keyboardType: keyboardType,
                initialValue: initialValue,
                minLines: isTextArea ? 5 : 1,
                maxLines: isTextArea ? 5 : 1,
                enabled: enabled,
                obscureText: this.obscureText,
                decoration: InputDecoration(
                  // prefixIcon: IconButton(
                  //   icon: this.icon,
                  //   onPressed: this.iconPressed,
                  // ),
                  suffixIcon: suffixIcon != null
                      ? GestureDetector(
                          onTap: this.suffixIconPressed, child: suffixIcon)
                      : Text(""),

                  hintText: hintText,
                  // border: InputBorder.none,
                  // contentPadding: EdgeInsets.only(left: 30),
                  // contentPadding: EdgeInsets.only(left: 5, top: 15),
                  // prefixIconConstraints: BoxConstraints(minWidth: 50),
                  // disabledBorder: InputBorder.none,
                  // enabledBorder: InputBorder.none,
                  // errorBorder: InputBorder.none,
                  // focusedBorder: InputBorder.none,
                  // focusedErrorBorder: InputBorder.none,
                ),
              ),
      ],
    );
  }
}
