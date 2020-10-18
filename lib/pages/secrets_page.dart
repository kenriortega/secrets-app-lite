import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mntd_pass_lite/global/environment.dart';
import 'package:mntd_pass_lite/helpers/mostrar_alerta.dart';
import 'package:mntd_pass_lite/models/login_response.dart';
import 'package:mntd_pass_lite/models/secret.dart';
import 'package:mntd_pass_lite/services/auth_service.dart';
import 'package:mntd_pass_lite/services/secrets_service.dart';
import 'package:mntd_pass_lite/widgets/menu_items.dart';
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
  bool sidebarOpen = false;
  double yoffset = 0;
  double xoffset = 0;
  double pageScale = 1;
  int itemSelected = 0;
  String pageTitle = 'secrets';

  setPageTitle() {
    switch (itemSelected) {
      case 0:
        pageTitle = 'secrets';
        break;
      case 1:
        pageTitle = 'home';
        break;
    }
  }

  setSidebarState() {
    setState(() {
      xoffset = sidebarOpen ? 265 : 0;
      yoffset = sidebarOpen ? 130 : 0;
      pageScale = sidebarOpen ? 0.8 : 1;
    });
  }

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
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: GFColors.kPrimarySpotify700Color,
      appBar: AppBar(
        title: Text(
          pageTitle,
          style: TextStyle(color: GFColors.kPrimarySpotify400Color),
        ),
        elevation: 1,
        backgroundColor: GFColors.kPrimarySpotify700Color,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: GFColors.kPrimarySpotify400Color,
          ),
          onPressed: () {
            // Navigator.pushReplacementNamed(context, 'login');
            // AuthService.deleteToken();
            sidebarOpen = !sidebarOpen;
            setSidebarState();
          },
        ),
        actions: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 10),
            child: IconButton(
              icon: Icon(
                Icons.lightbulb_outline,
                color: GFColors.kPrimarySpotify400Color,
              ),
              onPressed: () {
                print('change theme');
              },
            ),
          )
        ],
      ),
      body: Stack(
        children: [
          // zona Sidebar
          Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Container(
                  margin: EdgeInsets.only(top: 24),
                  color: GFColors.kPrimarySpotify700Color,
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(20),
                        child: CircleAvatar(
                          child: Text(
                            usuario.username.substring(0, 2),
                            style: TextStyle(
                              color: GFColors.colorPrimary900,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          backgroundColor: GFColors.kPrimarySpotifyLabels,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(20),
                        child: Text(
                          usuario.fullName == ""
                              ? usuario.username
                              : usuario.fullName,
                          style: TextStyle(
                            color: GFColors.kPrimarySpotify400Color,
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Expanded(
                    child: ListView.builder(
                      itemCount: Environment.menuItems.length,
                      itemBuilder: (context, i) => GestureDetector(
                        onTap: () {
                          sidebarOpen = false;
                          itemSelected = i;
                          setSidebarState();
                          setPageTitle();
                        },
                        child: MenuItem(
                          item: Environment.menuItems[i],
                          selected: itemSelected,
                          position: i,
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacementNamed(context, 'login');
                      AuthService.deleteToken();
                    },
                    child: MenuItem(
                      item: "Logout",
                      selected: itemSelected,
                      position: Environment.menuItems.length + 1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Zona Secrets APP
          AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: 200),
            transform: Matrix4.translationValues(xoffset, yoffset, 1.0)
              ..scale(pageScale),
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: GFColors.kPrimarySpotify700Color,
              borderRadius: sidebarOpen
                  ? BorderRadius.circular(20)
                  : BorderRadius.circular(0),
            ),
            child: pageTitle == 'secrets'
                ? buildSecretsSmartRefrsh()
                : buildProfileContainer(context, size, usuario),
          ),
        ],
      ),
      floatingActionButton: pageTitle == 'secrets'
          ? FloatingActionButton(
              backgroundColor: GFColors.kPrimarySpotifyLabels,
              child: Icon(
                Icons.add,
                color: GFColors.colorPrimary900,
              ),
              elevation: 1,
              onPressed: addNewSecret,
            )
          : null,
    );
  }

  SmartRefresher buildSecretsSmartRefrsh() {
    return SmartRefresher(
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
    );
  }

  Container buildProfileContainer(
      BuildContext context, Size size, LoginResponse usuario) {
    return Container(
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
                          Icons.lock_open,
                          color: GFColors.kPrimarySpotify400Color,
                        ),
                        onPressed: () {
                          // TODO: change password
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
                      color: GFColors.kPrimarySpotify800Color.withOpacity(0.29),
                    ),
                  ],
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    alignment: Alignment.center,
                    image: AssetImage("assets/user.png"),
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
                        text: "Name: ${usuario.username}\n",
                        style: TextStyle(
                          fontSize: 18,
                          color: GFColors.kPrimarySpotify400Color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                            "Create At: ${Environment.getTimeStampUser(usuario)}",
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
                      "# ${usuario.role}",
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
            child: usuario.fullName == " "
                ? Text(
                    "I`m ${usuario.fullName}",
                    style: TextStyle(
                        color: GFColors.kPrimarySpotify400Color, fontSize: 18),
                  )
                : Text(
                    "I`m ${usuario.username}",
                    style: TextStyle(
                        color: GFColors.kPrimarySpotify400Color, fontSize: 18),
                  ),
          )
        ],
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
              "# ${secret.category}",
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
