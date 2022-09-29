import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';

class RoundedRaisedButton extends StatelessWidget {
  final bool isLoading;
  final String title;
  final Color titleColor, buttonColor;
  final IconData iconLeft, iconRight;
  final Widget imageIcon;

  final double width;
  final Function onPress;
  RoundedRaisedButton(
      {this.title,
      this.onPress,
      this.titleColor = Colors.white,
      this.buttonColor = kPrimaryColor,
      this.isLoading = false,
      this.width,
      this.iconLeft,
      this.iconRight,
      this.imageIcon});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: width,
      child: ElevatedButton(
        child: isLoading
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  width: 20,
                  height: 20,
                  child:
                      CircularProgressIndicator(backgroundColor: Colors.white),
                ),
              )
            : imageIcon != null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 10.0),
                        child: imageIcon,
                      ),
                      Text(
                        this.title,
                        style: TextStyle(color: titleColor, fontSize: 18),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      iconLeft != null
                          ? Padding(
                              padding: const EdgeInsets.only(right: 10.0),
                              child: Icon(
                                iconLeft,
                                size: 18,
                                color: titleColor,
                              ),
                            )
                          : Text(""),
                      Text(
                        this.title,
                        style: TextStyle(color: titleColor, fontSize: 18),
                      ),
                      iconRight != null
                          ? Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Icon(
                                iconRight,
                                size: 18,
                                color: titleColor,
                              ),
                            )
                          : Text(""),
                    ],
                  ),
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          disabledBackgroundColor:
              Theme.of(context).primaryColor.withOpacity(0.7),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: isLoading ? null : this.onPress,
      ),
    );
  }
}
