import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/global/environment.dart';
import 'package:mntd_pass_lite/helpers/mostrar_alerta.dart';
import 'package:mntd_pass_lite/models/secret.dart';
import 'package:mntd_pass_lite/services/auth_service.dart';
import 'package:mntd_pass_lite/services/secrets_service.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class SecretsPage extends StatefulWidget {
  @override
  _SecretsPageState createState() => _SecretsPageState();
}

class _SecretsPageState extends State<SecretsPage> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final secretService = new SecretService();
  List<Secret> secrets = [];

  @override
  void initState() {
    this._cargarSecrets();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

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
            Navigator.pushReplacementNamed(context, 'login');
            AuthService.deleteToken();
          },
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                Icons.settings,
                color: GFColors.kPrimarySpotifyLabels,
              ),
              onPressed: () {
                print('object');
              },
            ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        enablePullDown: true,
        onRefresh: _cargarSecrets,
        header: WaterDropHeader(
          complete: Icon(
            Icons.check,
            color: GFColors.kPrimarySpotifyLabels,
          ),
          waterDropColor: GFColors.kPrimarySpotifyLabels,
        ),
        child: _secretsListView(),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: GFColors.kPrimarySpotifyLabels,
        child: Icon(
          Icons.add,
          color: GFColors.colorPrimary900,
        ),
        elevation: 1,
        onPressed: addNewSecret,
      ),
    );
  }

  ListView _secretsListView() {
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      itemBuilder: (_, i) => _secretsListTile(secrets[i]),
      separatorBuilder: (_, i) => Divider(),
      itemCount: secrets.length,
    );
  }

  Widget _secretsListTile(Secret secret) {
    final secretService = Provider.of<SecretService>(context);

    return Dismissible(
      key: Key(secret.name),
      direction: DismissDirection.startToEnd,
      onDismissed: (_) async {
        final authService = Provider.of<AuthService>(context, listen: false);
        final autenticado = await authService.isLoggedIn();
        if (autenticado) {
          final deleteSecretOk =
              await secretService.deleteSecret(secret.username, secret.name);
          if (deleteSecretOk == true) {
            _cargarSecrets();
          } else {
            // Mostara alerta
            mostrarAlerta(
              context,
              'Wrong! delete ',
              'Check yours connection',
            );
          }
        }
      },
      background: Container(
        padding: EdgeInsets.only(left: 8.0),
        color: GFColors.DANGER,
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.delete_forever, color: Colors.white),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Delete",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      child: ListTile(
        title: Text(
          secret.name,
          style: TextStyle(
            color: GFColors.kPrimarySpotify400Color,
          ),
        ),
        subtitle: Text(
          Environment.getTimeStamp(secret),
          style: TextStyle(
            color: GFColors.kPrimarySpotify400Color,
          ),
        ),
        leading: CircleAvatar(
          child: Text(
            secret.category.substring(0, 2),
            style: TextStyle(
              color: GFColors.colorPrimary900,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: GFColors.kPrimarySpotifyLabels,
        ),
        trailing: Container(
          width: 80,
          height: 20,
          child: Center(
            child: Text(
              secret.category,
              style: TextStyle(
                fontSize: 12,
                color: GFColors.colorPrimary900,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          decoration: BoxDecoration(
            color: GFColors.kPrimarySpotifyLabels,
            borderRadius: BorderRadius.circular(100),
          ),
        ),
        onTap: () async {
          final authService = Provider.of<AuthService>(context, listen: false);
          final autenticado = await authService.isLoggedIn();
          if (autenticado) {
            // todo send to secretDetail
            final getSecretOk =
                await secretService.getSecret(secret.username, secret.name);

            if (getSecretOk is String) {
              // Mostara alerta
              mostrarAlerta(
                context,
                'Wrong! get Secret ',
                'Token Expired',
              );
            } else {
              Navigator.pushNamed(context, 'detailSecret');
            }
          }
        },
      ),
    );
  }

  _cargarSecrets() async {
    this.secrets = await secretService.getSecrets();
    setState(() {});
    _refreshController.refreshCompleted();
  }

  addNewSecret() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    final autenticado = await authService.isLoggedIn();
    if (autenticado) {
      Navigator.pushReplacementNamed(context, 'addSecret');
    } else {}
  }
}
