import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/global/environment.dart';
import 'package:mntd_pass_lite/helpers/mostrar_alerta.dart';
import 'package:mntd_pass_lite/services/auth_service.dart';
import 'package:mntd_pass_lite/services/secrets_service.dart';
import 'package:mntd_pass_lite/widgets/custom_btn.dart';
import 'package:mntd_pass_lite/widgets/custom_input.dart';
import 'package:mntd_pass_lite/widgets/custom_logo.dart';
import 'package:provider/provider.dart';

class AddSecretPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.user;
    return Scaffold(
      backgroundColor: GFColors.kPrimarySpotify700Color,
      appBar: AppBar(
        title: Text(
          usuario.username,
          style: TextStyle(color: GFColors.kPrimarySpotifyLabels),
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
            child:
                Icon(Icons.check_circle, color: GFColors.kPrimarySpotifyLabels),
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
                  srcImage: 'assets/shell.png',
                  textTitle: 'Add Secret',
                ),
                _Form(),
                Container(),
                Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  @override
  __FormState createState() => __FormState();
}

class __FormState extends State<_Form> {
  final usernameCtrl = TextEditingController();
  final nameCtrl = TextEditingController();
  final valueCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final secretService = Provider.of<SecretService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.supervised_user_circle,
            placeholder: 'Name',
            keyboardType: TextInputType.text,
            textController: nameCtrl,
          ),
          CustomInput(
            icon: Icons.supervised_user_circle,
            placeholder: 'Value',
            keyboardType: TextInputType.text,
            textController: valueCtrl,
          ),
          CustomInput(
            icon: Icons.supervised_user_circle,
            placeholder: 'Category',
            keyboardType: TextInputType.text,
            textController: categoryCtrl,
          ),
          CustomBtnAction(
            btnColor: GFColors.kPrimarySpotifyLabels,
            btnText: "ADD",
            onPressed: () async {
              final authService =
                  Provider.of<AuthService>(context, listen: false);
              final autenticado = await authService.isLoggedIn();
              if (autenticado) {
                final username = await AuthService.getUsername();
                final addSecretOk = await secretService.addSecret(
                  username,
                  nameCtrl.text.trim(),
                  valueCtrl.text.trim(),
                  categoryCtrl.text.trim(),
                );
                if (addSecretOk == true) {
                  Navigator.pushReplacementNamed(context, 'secrets');
                } else {
                  // Mostara alerta
                  mostrarAlerta(
                    context,
                    'Add secrets ',
                    "wrong",
                  );
                  Navigator.pushReplacementNamed(context, 'loading');
                  // AuthService.deleteToken();
                }
              }
            },
          )
        ],
      ),
    );
  }
}
