import 'package:controleRetirada/data/datasources/confirm/remote/confirm_remote_data.dart';
import 'package:controleRetirada/data/repositories/confirm_repository_impl.dart';
import 'package:controleRetirada/domain/entities/confirm_entity.dart';
import 'package:controleRetirada/screens/events/events_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beep/flutter_beep.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/data/datasources/employee/remote/employeee_remote_datasource.dart';
import 'package:controleRetirada/data/repositories/employee_repositories_impl.dart';
import 'package:controleRetirada/screens/qrcodescreen/scanner_controller.dart';
import 'package:controleRetirada/domain/entities/employee_entity.dart';
import 'package:controleRetirada/domain/entities/products_entity.dart';
import 'package:controleRetirada/data/repositories/event_repository_impl.dart';
import 'package:controleRetirada/data/datasources/event/remote/event_remote_datasource.dart';

class ScannerScreen extends StatefulWidget {
  final EmployeeEntity employeeEntity;
  final ProductEntity productEntity;
  final ConfirmEntity confirmEntity;

  const ScannerScreen({
    Key key,
    this.employeeEntity,
    this.productEntity,
    this.confirmEntity,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  ScannerController scannerController;

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
    this.scannerController = ScannerController(
      EmployeeRepositoryImpl(EmployeeRemoteDataSource(createDio())),
      //this.widget.employeeEntity,
      this.widget.productEntity,
      EventRepositoryImpl(EventRemoteDataSource(createDio())),
      ConfirmRepositoryImpl(ConfirmRemoteDataSource(createDio())),
    );
  }

  String qrCode = "";
  QRViewController controller;

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo,
        title: Center(
          child: Text('Leia o QR code do Colaborador'),
        ),
      ),
      body: Stack(
        children: [
          _body(),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              width: 48,
              height: 48,
              margin: EdgeInsets.all(16),
              child: TextButton(
                onPressed: () {
                  this.controller?.toggleFlash();
                  this.scannerController?.toogleFlash();
                },
                child: Center(
                  child: Observer(
                    builder: (_) {
                      return Icon(
                        (this.scannerController.isFlashOn
                            ? Icons.flash_off
                            : Icons.flash_on),
                        color: Colors.white,
                        size: 28,
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Observer(
            builder: (_) {
              return _createLoading();
            },
          ),
        ],
      ),
    );
  }

  Widget _body() {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
            overlay: QrScannerOverlayShape(
              borderColor: Colors.red,
              borderRadius: 10,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300,
            ),
          ),
        ),
      ],
    );
  }

  Widget _createLoading() {
    if (this.scannerController.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Container();
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print("#### codigo: $scanData");
      if (scanData == this.qrCode) {
        return;
      }
      this.qrCode = scanData;
      this.controller.pauseCamera();

      FlutterBeep.beep();

      this.scannerController.setGetCode(scanData, (employee) {
        if (employee.codeReturn == 0) {
          this.scannerController.loadEvent(
            employee,
            (result) {
              if (result.length <= 1) {
                for (var idx = 0; idx < result.length; idx++) {
                  var event = result[idx];
                  var eventEntity = event;
                  if (eventEntity.showEvent == 0) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ScannerScreen(employeeEntity: employee),
                      ),
                    ).then(
                      (result) {
                        this.qrCode = "";
                        this.controller.resumeCamera();
                      },
                    );
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                top: 280, bottom: 230, right: 10, left: 10),
                            child: AlertDialog(
                              title: Padding(
                                padding: const EdgeInsets.only(top: 40),
                                child: Center(
                                  child: Text(
                                    employee.name,
                                  ),
                                ),
                              ),
                              content: Column(
                                children: [
                                  Text(eventEntity.descriptionReturn),
                                ],
                              ),
                            ),
                          );
                        });
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EventsScreen(employeeEntity: employee),
                      ),
                    ).then(
                      (result) {
                        this.qrCode = "";
                        this.controller.resumeCamera();
                      },
                    );
                  }
                }
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ScannerScreen(employeeEntity: employee),
                  ),
                ).then(
                  (result) {
                    this.qrCode = "";
                    this.controller.resumeCamera();
                  },
                );
              }
            },
          );
        } else {
          Fluttertoast.showToast(
                  msg: kEmployeeErrorText,
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0)
              .then((value) {
            this.qrCode = "";
            this.controller.resumeCamera();
          });
        }
      });
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
