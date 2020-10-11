import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/pages/add_secret_page.dart';
import 'package:mntd_pass_lite/pages/loading_page.dart';
import 'package:mntd_pass_lite/pages/login_page.dart';
import 'package:mntd_pass_lite/pages/register_page.dart';
import 'package:mntd_pass_lite/pages/secret_detail_page.dart';
import 'package:mntd_pass_lite/pages/secrets_page.dart';

final Map<String, Widget Function(BuildContext)> appRoutes = {
  'login': (_) => LoginPage(),
  'register': (_) => RegisterPage(),
  'secrets': (_) => SecretsPage(),
  'loading': (_) => LoadingPage(),
  'addSecret': (_) => AddSecretPage(),
  'detailSecret': (_) => DetailSecretPage(),
};
