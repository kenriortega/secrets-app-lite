import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/global/environment.dart';
import 'package:mntd_pass_lite/helpers/mostrar_alerta.dart';
import 'package:mntd_pass_lite/services/auth_service.dart';
import 'package:mntd_pass_lite/services/secrets_service.dart';
import 'package:provider/provider.dart';

class DetailSecretPage extends StatefulWidget {
  @override
  _DetailSecretPageState createState() => _DetailSecretPageState();
}

class _DetailSecretPageState extends State<DetailSecretPage> {
  bool showSecret = false;
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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: GFColors.kPrimarySpotify700Color,
      appBar: AppBar(
        title: Text(
          usuario.username,
          style: TextStyle(
            color: GFColors.kPrimarySpotify400Color,
          ),
        ),
        elevation: 1,
        backgroundColor: GFColors.kPrimarySpotify700Color,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: GFColors.kPrimarySpotify400Color,
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'secrets');
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height * .9,
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: Icon(
                                Icons.edit,
                                color: GFColors.kPrimarySpotify400Color,
                              ),
                              onPressed: editSecret,
                            ),
                          ),
                          Align(
                            alignment: Alignment.center,
                            child: IconButton(
                              icon: showSecret
                                  ? Icon(
                                      Icons.lock,
                                      color: GFColors.kPrimarySpotify400Color,
                                    )
                                  : Icon(
                                      Icons.lock_open,
                                      color: GFColors.kPrimarySpotify400Color,
                                    ),
                              onPressed: () {
                                showSecret = !showSecret;
                                setState(() {});
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: size.height * 0.7,
                      width: size.width * 0.75,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(63),
                          bottomLeft: Radius.circular(63),
                        ),
                        boxShadow: [
                          BoxShadow(
                            offset: Offset(0, 10),
                            blurRadius: 60,
                            color: GFColors.kPrimarySpotify800Color
                                .withOpacity(0.29),
                          ),
                        ],
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          alignment: Alignment.centerLeft,
                          image: AssetImage("assets/lock1.jpg"),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 23),
                  child: Row(
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: "Name: ${secretService.scretDetail.name}\n",
                              style: TextStyle(
                                fontSize: 18,
                                color: GFColors.kPrimarySpotify400Color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextSpan(
                              text:
                                  "Fecha: ${Environment.getTimeStamp(secretService.scretDetail)}",
                              style: TextStyle(
                                fontSize: 12,
                                color: GFColors.kPrimarySpotify400Color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Spacer(),
                      Container(
                        width: 80,
                        height: 20,
                        child: Center(
                          child: Text(
                            "# ${secretService.scretDetail.category}",
                            style: TextStyle(
                              fontSize: 14,
                              color: GFColors.kPrimarySpotify700Color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: GFColors.kPrimarySpotifyLabels,
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                      // Spacer(),
                    ],
                  ),
                ),
                SizedBox(height: 23),
                Center(
                  child: showSecret
                      ? Text(
                          secretService.scretDetail.value,
                          style: TextStyle(
                            color: GFColors.kPrimarySpotify400Color,
                            fontSize: 18,
                          ),
                        )
                      : Text(
                          "Secret ****** ",
                          style: TextStyle(
                              color: GFColors.kPrimarySpotify400Color,
                              fontSize: 18),
                        ),
                )
              ],
            ),
          ),
        ),
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
