import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/global/environment.dart';
import 'package:mntd_pass_lite/helpers/mostrar_alerta.dart';
import 'package:mntd_pass_lite/services/auth_service.dart';
import 'package:mntd_pass_lite/services/secrets_service.dart';
import 'package:mntd_pass_lite/widgets/custom_logo.dart';
import 'package:provider/provider.dart';

class DetailSecretPage extends StatefulWidget {
  @override
  _DetailSecretPageState createState() => _DetailSecretPageState();
}

class _DetailSecretPageState extends State<DetailSecretPage> {
  @override
  void initState() {
    this._cargarSecret();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final secretService = Provider.of<SecretService>(context);
    final usuario = authService.user;
    return Scaffold(
      backgroundColor: GFColors.kPrimarySpotify700Color,
      appBar: AppBar(
        title: Text(
          usuario.username,
          style: TextStyle(
            color: GFColors.kPrimarySpotifyLabels,
          ),
        ),
        elevation: 1,
        backgroundColor: GFColors.kPrimarySpotify700Color,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black54,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'secrets');
          },
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: Icon(
              Icons.check_circle,
              color: GFColors.kPrimarySpotifyLabels,
            ),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * .9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CustomLogo(
                  srcImage: 'assets/user.png',
                  textTitle: secretService.scretDetail.name,
                ),
                // _Form(),
                Container(
                  child: Column(
                    children: <Widget>[
                      Text(
                        "Created ${Environment.getTimeStamp(secretService.scretDetail)}",
                        style: TextStyle(
                          color: GFColors.kPrimarySpotifyLabels,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Catagory ${secretService.scretDetail.category}",
                        style: TextStyle(
                          color: GFColors.kPrimarySpotifyLabels,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Value ${secretService.scretDetail.value}",
                        style: TextStyle(
                          color: GFColors.kPrimarySpotifyLabels,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: GFColors.kPrimarySpotifyLabels,
        child: Icon(
          Icons.edit,
          color: GFColors.colorPrimary900,
        ),
        elevation: 1,
        onPressed: editSecret,
      ),
    );
  }

  editSecret() {
    final textController = new TextEditingController();
    final secretService = Provider.of<SecretService>(context, listen: false);

    if (Platform.isAndroid) {
      return showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text("Edit: ${secretService.scretDetail.name}"),
          content: TextField(
            controller: textController,
          ),
          actions: <Widget>[
            MaterialButton(
              child: Text("Add"),
              elevation: 5,
              textColor: Colors.blue,
              onPressed: () => _editSecret(textController.text),
            ),
          ],
        ),
      );
    }
    showCupertinoDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: Text("Edit: ${secretService.scretDetail.name}"),
        content: CupertinoTextField(
          controller: textController,
        ),
        actions: <Widget>[
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Edit'),
            onPressed: () => _editSecret(textController.text),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            child: Text('Dismiss'),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  _editSecret(String value) async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final autenticado = await authService.isLoggedIn();
    if (autenticado) {
      final secretService = Provider.of<SecretService>(context, listen: false);
      final updateSecretOk = await secretService.updateSecret(
        secretService.scretDetail.username,
        secretService.scretDetail.name,
        value,
      );
      if (updateSecretOk is String) {
        // Mostara alerta
        mostrarAlerta(
          context,
          'Wrong! update Secret ',
          'Token Expired',
        );
      } else {
        _cargarSecret();
        Navigator.pop(context);
      }
    }
  }

  _cargarSecret() async {
    final secretService = Provider.of<SecretService>(context, listen: false);

    secretService.scretDetail = await secretService.getSecret(
        secretService.scretDetail.username, secretService.scretDetail.name);
    setState(() {});
  }
}
