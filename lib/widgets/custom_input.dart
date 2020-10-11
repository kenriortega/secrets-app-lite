import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/global/environment.dart';

class CustomInput extends StatelessWidget {
  final IconData icon;
  final String placeholder;
  final TextEditingController textController;
  final TextInputType keyboardType;
  final bool isPassword;
  const CustomInput({
    Key key,
    @required this.icon,
    @required this.placeholder,
    @required this.textController,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5, left: 5, bottom: 5, right: 20),
      margin: EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
          color: GFColors.kPrimarySpotify700Color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.20),
              offset: Offset(0, 5),
              blurRadius: 5,
            )
          ]),
      child: TextField(
        cursorColor: GFColors.kPrimarySpotifyLabels,
        style: TextStyle(color: GFColors.kPrimarySpotify400Color),
        controller: this.textController,
        autocorrect: false,
        keyboardType: this.keyboardType,
        obscureText: this.isPassword,
        decoration: InputDecoration(
          focusColor: GFColors.kPrimarySpotifyLabels,
          fillColor: GFColors.kPrimarySpotifyLabels,
          prefixIcon: Icon(
            this.icon,
            color: GFColors.kPrimarySpotifyLabels,
          ),
          focusedBorder: InputBorder.none,
          border: InputBorder.none,
          hintText: this.placeholder,
          hintStyle: TextStyle(color: GFColors.kPrimarySpotifyLabels),
        ),
      ),
    );
  }
}
