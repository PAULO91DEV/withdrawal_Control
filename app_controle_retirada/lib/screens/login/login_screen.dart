import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/data/datasources/cart/local/cart_local_datasource_impl.dart';
import 'package:controleRetirada/data/repositories/cart_repository_impl.dart';
import 'package:controleRetirada/domain/usecases/clear_cart_usecase.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controleRetirada/data/datasources/login/remote/login_remote_datasource.dart';
import 'package:controleRetirada/data/repositories/login_repository_impl.dart';
import 'package:controleRetirada/screens/activationdevice/activation_device_screen.dart';
import 'package:controleRetirada/screens/login/login_controller.dart';
import 'package:controleRetirada/screens/qrcodescreen/scanner_screen.dart';
import 'package:controleRetirada/widgets/input_text_widget.dart';
import 'package:controleRetirada/widgets/rounded_button_widget.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  var loginController;

  Dio createDio() {
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
    ));
    return dio;
  }

  @override
  void initState() {
    super.initState();
    this.loginController = LoginController(
      LoginRepositoryImpl(LoginRemoteDataSource(createDio())),
      ClearCartUseCase(CartRepositoryImpl(CartLocalDataSourceImpl())),
    );
    this.loginController.init();
    //LoginRepositoryImpl(LoginMockDataSource()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 26.0, right: 26.0),
        color: Colors.indigo[900],
        alignment: Alignment.center,
        child: Form(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    right: 88.0, left: 88.0, bottom: 140.0, top: 140.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.0),
                    border: Border.all(color: Colors.grey[300]),
                  ),
                  padding: EdgeInsets.only(top: 30.0, bottom: 30.0),
                  child: Column(children: [
                    Image.asset(
                      "assets/image/logo_vidraria.png",
                      width: 250.0,
                    ),
                  ]),
                ),
              ),
              Observer(
                builder: (_) {
                  return InputTextWidget(
                    onTextChanged: this.loginController.setUser,
                    isReadOnly: this.loginController.isLoading == true,
                    textLabel: 'Usuario',
                    icon: Icon(
                      Icons.person,
                      color: Colors.indigo,
                      size: 24.0,
                    ),
                  );
                },
              ),
              SizedBox(
                height: 30.0,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9.0),
                  color: Colors.white,
                ),
                margin: EdgeInsets.symmetric(horizontal: 16),
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Observer(builder: (_) {
                  return TextFormField(
                    readOnly: this.loginController.isLoading == true,
                    decoration: InputDecoration(
                        labelText: 'Senha',
                        labelStyle: TextStyle(
                          fontSize: 20,
                          color: Colors.indigo,
                        ),
                        icon: Icon(
                          Icons.lock_outline,
                          color: Colors.indigo,
                          size: 24.0,
                        )),
                    onChanged: this.loginController.setPass,
                    obscureText: true,
                  );
                }),
              ),
              Observer(builder: (_) {
                return chackErrorMessenger(
                    this.loginController.errorMessage.isNotEmpty);
              }),
              SizedBox(
                height: 50.0,
              ),
              Observer(
                builder: (_) {
                  if (this.loginController.isLoading) {
                    return Container(
                      height: 48,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  return RoundedButtonWidget(
                    text: 'ENTRAR',
                    isEnabled: this.loginController.isLoginBottonEnabled,
                    onPressed: () {
                      this.loginController.login((result) {
                        SharedPreferences.getInstance().then((prefs) {
                          var deviceLocation =
                              prefs.getString(kDeviceLocationSharedPref);
                          if (deviceLocation != null) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ActivationDeviceScreen()),
                            );
                          } else {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScannerScreen()),
                            );
                          }
                        });
                      });
                    },
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget chackErrorMessenger(bool isShow) {
    if (isShow) {
      return Padding(
        padding: const EdgeInsets.only(left: 24, top: 8),
        child: Row(
          children: [
            Icon(
              Icons.error,
              color: Colors.redAccent,
            ),
            SizedBox(
              width: 8,
            ),
            Text(
              this.loginController.errorMessage,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
