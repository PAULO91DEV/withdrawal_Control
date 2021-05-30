import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:controleRetirada/data/datasources/activation/remote/activation_remote_datasource.dart';
import 'package:controleRetirada/data/repositories/activation_repository_impl.dart';
import 'package:controleRetirada/screens/activationdevice/activation_device_controller.dart';
import 'package:controleRetirada/screens/deviceResponse/device_location_screen.dart';
import 'package:controleRetirada/widgets/input_text_widget.dart';
import 'package:controleRetirada/widgets/rounded_button_widget.dart';

class ActivationDeviceScreen extends StatefulWidget {
  ActivationDeviceScreen({Key key}) : super(key: key);

  @override
  _ActivationDeviceScreenState createState() => _ActivationDeviceScreenState();
}

Dio createDio() {
  Dio dio = Dio();
  dio.interceptors.add(LogInterceptor(
    requestHeader: true,
    requestBody: true,
    responseBody: true,
  ));
  return dio;
}

class _ActivationDeviceScreenState extends State<ActivationDeviceScreen> {
  final ActivationDeviceController _controller = ActivationDeviceController(
    //ActivationRepositoryImpl(ActivationMockDataSource()),
    ActivationRepositoryImpl(ActivationRemoteDatasource(createDio())),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Container(
        padding: EdgeInsets.only(top: 46, left: 22, right: 22),
        child: Column(
          children: [
            SizedBox(
              height: 78,
            ),
            Icon(
              Icons.devices,
              color: Colors.white,
              size: 114.0,
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0, right: 16.0),
              child: Text(
                'Esse dispositivo ainda não foi ativado, Por favor informe o codigo da ativação .',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                ),
              ),
            ),
            SizedBox(
              height: 32,
            ),
            Observer(builder: (_) {
              return InputTextWidget(
                onTextChanged: (value) {
                  this._controller.setCodeActivation(value);
                },
                isReadOnly: this._controller.isLoading,
                textLabel: 'Codigo',
                icon: null,
              );
            }),
            Observer(
              builder: (_) {
                return errorMessenger(this._controller.errorMessage.isNotEmpty);
              },
            ),
            Spacer(),
            Observer(builder: (_) {
              if (this._controller.isLoading) {
                FocusScope.of(context).unfocus();
                return Container(
                  height: 48,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Row(
                children: [
                  Expanded(
                    child: RoundedButtonWidget(
                      isEnabled: this._controller.isEnabledButton,
                      text: 'Confirmar',
                      onPressed: () {
                        this._controller.activationButtonClicked((result) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => DeviceLocationScreen(
                                      localEntity: result,
                                    )),
                          );
                        });
                      },
                    ),
                  ),
                ],
              );
            }),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }

  Widget errorMessenger(bool isShow) {
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
              this._controller.errorMessage,
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
