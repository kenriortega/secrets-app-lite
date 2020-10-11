import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/global/environment.dart';

class CustomLogo extends StatelessWidget {
  final String srcImage;
  final String textTitle;

  const CustomLogo({
    Key key,
    @required this.srcImage,
    this.textTitle = "MyApp",
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 170,
        margin: EdgeInsets.only(top: 50),
        child: Column(
          children: <Widget>[
            Image(image: AssetImage(this.srcImage)),
            SizedBox(
              height: 20,
            ),
            Text(
              this.textTitle,
              style: TextStyle(
                fontSize: 30,
                color: GFColors.kPrimarySpotifyLabels,
              ),
            )
          ],
        ),
      ),
    );
  }
}
