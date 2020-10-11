import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/global/environment.dart';
import 'package:mntd_pass_lite/helpers/mostrar_alerta.dart';
import 'package:mntd_pass_lite/services/auth_service.dart';
import 'package:mntd_pass_lite/widgets/custom_btn.dart';
import 'package:mntd_pass_lite/widgets/custom_input.dart';
import 'package:mntd_pass_lite/widgets/custom_labels.dart';
import 'package:mntd_pass_lite/widgets/custom_logo.dart';
import 'package:provider/provider.dart';

class RegisterPage extends StatelessWidget {
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
                  firstQuestion: "Already have an account?",
                  secondQuestion: "Sign in!",
                  ruta: 'login',
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
  final fullnameCtrl = TextEditingController();
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
            placeholder: 'Username',
            keyboardType: TextInputType.text,
            textController: usernameCtrl,
          ),
          CustomInput(
            icon: Icons.person,
            placeholder: 'FullName',
            keyboardType: TextInputType.text,
            textController: fullnameCtrl,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            placeholder: 'Password',
            keyboardType: TextInputType.text,
            textController: passCtrl,
            isPassword: true,
          ),
          CustomBtnAction(
            onPressed: authService.autenticando
                ? null
                : () async {
                    if (usernameCtrl.text.length > 0 &&
                        passCtrl.text.length > 0 &&
                        fullnameCtrl.text.length > 0) {
                      FocusScope.of(context).unfocus();
                      final registerOk = await authService.register(
                        usernameCtrl.text.trim(),
                        fullnameCtrl.text.trim(),
                        passCtrl.text.trim(),
                      );
                      if (registerOk == true) {
                        Navigator.pushReplacementNamed(context, 'login');
                      } else {
                        // Mostara alerta
                        mostrarAlerta(
                            context, 'Wrong! register ', 'Check yours inpusts');
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
