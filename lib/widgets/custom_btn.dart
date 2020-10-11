import 'package:flutter/material.dart';

class CustomBtnAction extends StatelessWidget {
  final Color btnColor;
  final String btnText;
  final Function onPressed;

  const CustomBtnAction(
      {Key key,
      this.btnColor = Colors.red,
      this.btnText = "Accion",
      @required this.onPressed})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return RaisedButton(
      onPressed: this.onPressed,
      elevation: 2,
      highlightElevation: 5,
      color: this.btnColor,
      shape: StadiumBorder(),
      child: Container(
        width: double.infinity,
        height: 55,
        child: Center(
          child: Text(
            this.btnText,
            style: TextStyle(color: Colors.white, fontSize: 17),
          ),
        ),
      ),
    );
  }
}
