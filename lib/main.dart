import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/routes/routes.dart';
import 'package:mntd_pass_lite/services/auth_service.dart';
import 'package:mntd_pass_lite/services/secrets_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => SecretService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Secrets',
        initialRoute: 'loading',
        routes: appRoutes,
      ),
    );
  }
}
