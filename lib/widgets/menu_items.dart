import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/global/environment.dart';

class MenuItem extends StatelessWidget {
  final String item;
  final int selected;
  final int position;
  const MenuItem({
    Key key,
    this.item,
    this.selected,
    this.position,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: selected == position
          ? GFColors.colorPrimary900
          : GFColors.kPrimarySpotify700Color,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Icon(
              (item == 'secrets'
                  ? Icons.tag
                  : item == "Logout"
                      ? Icons.logout
                      : Icons.home),
              color: GFColors.kPrimarySpotify400Color,
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            child: Text(
              item,
              style: TextStyle(
                color: GFColors.kPrimarySpotify400Color,
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
