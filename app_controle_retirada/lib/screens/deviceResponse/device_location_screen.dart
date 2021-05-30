import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:controleRetirada/data/datasources/deviceLocation/remote/device_location_remote_data.dart';
import 'package:controleRetirada/data/repositories/device_location_repository_impl.dart';
import 'package:controleRetirada/domain/entities/activation_entity.dart';
import 'package:controleRetirada/screens/deviceResponse/device_location_controller.dart';
import 'package:controleRetirada/screens/qrcodescreen/scanner_screen.dart';
import 'package:controleRetirada/widgets/input_text_widget.dart';
import 'package:controleRetirada/widgets/rounded_button_widget.dart';

class DeviceLocationScreen extends StatefulWidget {
  final ActivationEntity localEntity;
  DeviceLocationScreen({
    Key key,
    this.localEntity,
  }) : super(key: key);

  @override
  _DeviceLocationScreenState createState() => _DeviceLocationScreenState();
}

class _DeviceLocationScreenState extends State<DeviceLocationScreen> {
  DeviceLocationController _deviceLocationController;

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
    this._deviceLocationController = DeviceLocationController(
      this.widget.localEntity,
      DeviceLocationRepositoryImpl(
        DeviceRemoteDataSource(
          createDio(),
        ),
      ),
    );
    //this._deviceLocationController.activation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        elevation: 0,
        title: Text('Confirme se o local está correto'),
        actions: [],
      ),
      body: Observer(builder: (_) {
        return createBody();
      }),
    );
  }

  Widget createBody() {
    if (this._deviceLocationController.errorMessage != null &&
        this._deviceLocationController.errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.add_location_alt,
              color: Colors.white,
              size: 94.0,
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 38.0),
              child: Column(
                children: [
                  Text(
                    this._deviceLocationController.errorMessage,
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(top: 18.0, left: 15.0, right: 15.0),
      child: Container(
        child: Column(
          children: [
            Icon(
              Icons.add_location_alt,
              color: Colors.white,
              size: 94.0,
            ),
            SizedBox(
              height: 24,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InputTextWidget(
                      isReadOnly: true,
                      textLabel: "Empresa : ",
                      initialValue: this.widget.localEntity.company,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    InputTextWidget(
                      isReadOnly: true,
                      textLabel: "Unidade : ",
                      initialValue: this.widget.localEntity.site,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    InputTextWidget(
                      isReadOnly: true,
                      textLabel: "Setor : ",
                      initialValue: this.widget.localEntity.description,
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: this.widget.localEntity.parameters.length,
                        itemBuilder: (context, index) {
                          Parameter parameter =
                              this.widget.localEntity.parameters[index];
                          return Column(
                            children: [
                              InputTextWidget(
                                isReadOnly: true,
                                textLabel: parameter.key,
                                initialValue: parameter.value,
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          );
                        }),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Row(
              children: [
                Expanded(
                  child: RoundedButtonWidget(
                    text: 'Ativar localização',
                    onPressed: () {
                      this._deviceLocationController.activation((error) {
                        if (error == null) {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScannerScreen()));
                        }
                      });
                    },
                    isEnabled: true,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 32,
            ),
          ],
        ),
      ),
    );
  }
}
