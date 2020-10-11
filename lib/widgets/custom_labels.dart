import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/global/environment.dart';

class CustomLabels extends StatelessWidget {
  final String firstQuestion;
  final String secondQuestion;
  final String ruta;
  const CustomLabels({
    Key key,
    @required this.firstQuestion,
    @required this.secondQuestion,
    @required this.ruta,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            this.firstQuestion,
            style: TextStyle(
              color: GFColors.kPrimarySpotifyLabels,
              fontSize: 15,
              fontWeight: FontWeight.w300,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          GestureDetector(
            onTap: () {
              Navigator.pushReplacementNamed(context, this.ruta);
            },
            child: Text(
              this.secondQuestion,
              style: TextStyle(
                  color: GFColors.kPrimarySpotifyLabels,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
