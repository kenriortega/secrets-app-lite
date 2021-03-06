import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/global/environment.dart';
import 'package:mntd_pass_lite/helpers/mostrar_alerta.dart';
import 'package:mntd_pass_lite/services/auth_service.dart';
import 'package:mntd_pass_lite/widgets/custom_btn.dart';
import 'package:mntd_pass_lite/widgets/custom_input.dart';
import 'package:mntd_pass_lite/widgets/custom_labels.dart';
import 'package:mntd_pass_lite/widgets/custom_logo.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GFColors.kPrimarySpotify700Color,
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
                  textTitle: 'Secrets',
                ),
                _Form(),
                CustomLabels(
                  firstQuestion: "Dont`t have an account?",
                  secondQuestion: "Create one!",
                  ruta: 'register',
                ),
                Text(
                  "Conditions and terms of uses",
                  style: TextStyle(
                    fontWeight: FontWeight.w200,
                    color: GFColors.kPrimarySpotifyLabels,
                  ),
                ),
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
  final passCtrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return Container(
      margin: EdgeInsets.only(top: 40),
      padding: EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: <Widget>[
          CustomInput(
            icon: Icons.supervised_user_circle,
            placeholder: 'Username...',
            keyboardType: TextInputType.text,
            textController: usernameCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Password...',
            keyboardType: TextInputType.text,
            textController: passCtrl,
            isPassword: true,
          ),
          CustomBtnAction(
            onPressed: authService.autenticando
                ? null
                : () async {
                    if (usernameCtrl.text.length > 0 &&
                        passCtrl.text.length > 0) {
                      FocusScope.of(context).unfocus();
                      final loginOk = await authService.login(
                        usernameCtrl.text.trim(),
                        passCtrl.text.trim(),
                      );
                      if (loginOk) {
                        Navigator.pushReplacementNamed(context, 'secrets');
                      } else {
                        // Mostara alerta
                        mostrarAlerta(context, 'Wrong! Login ',
                            'Check yours credentials');
                      }
                    } else {
                      mostrarAlerta(context, 'Please ', 'Fill all inputs');
                    }
                  },
            btnColor: GFColors.kPrimarySpotifyLabels,
            btnText: "Sign in",
          )
        ],
      ),
    );
  }
}
