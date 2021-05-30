import 'package:controleRetirada/data/datasources/confirm/remote/confirm_remote_data.dart';
import 'package:controleRetirada/data/datasources/event/remote/event_remote_datasource.dart';
import 'package:controleRetirada/data/datasources/products/remote/product_remote_datasource.dart';
import 'package:controleRetirada/data/repositories/confirm_repository_impl.dart';
import 'package:controleRetirada/data/repositories/products_repositorio_impl.dart';
import 'package:controleRetirada/domain/entities/products_entity.dart';
import 'package:controleRetirada/screens/itemsproduct/items_controller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:controleRetirada/data/repositories/event_repository_impl.dart';
import 'package:controleRetirada/domain/entities/employee_entity.dart';
import 'package:controleRetirada/domain/entities/event_entity.dart';
import 'package:controleRetirada/screens/events/events_controller.dart';
import 'package:controleRetirada/screens/products/products_screen.dart';

class EventsScreen extends StatefulWidget {
  final EmployeeEntity employeeEntity;
  final EventEntity eventEntity;
  final ProductEntity productEntity;
  final ItemsController itemsController;

  const EventsScreen({
    Key key,
    this.employeeEntity,
    this.eventEntity,
    this.itemsController,
    this.productEntity,
  }) : super(key: key);

  @override
  _EventsScreenState createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  EventsController controller;

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
    ProductEntity productEntity;
    super.initState();
    this.controller = EventsController(
      this.widget.employeeEntity,
      EventRepositoryImpl(EventRemoteDataSource(createDio())),
      ProductsRepositorioImpl(ProductRemoteDataSource(createDio())),
      this.widget.productEntity,
      ConfirmRepositoryImpl(ConfirmRemoteDataSource(createDio())),
    );
    //EventRepositoryImpl(EventMockDataSource()));
    this.controller.load(productEntity);
    //this.controller.loadProduct(productEntity);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop();
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Eventos"),
          elevation: 0,
          backgroundColor: Colors.indigo[900],
        ),
        body: Container(
          color: Colors.indigo[900],
          padding:
              EdgeInsets.only(top: 16.0, bottom: 90.0, left: 10, right: 10),
          width: double.infinity,
          child: Observer(
            builder: (_) {
              return _body();
            },
          ),
        ),
      ),
    );
  }

  Widget _body() {
    if (this.controller.isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Text(
          "${this.widget.employeeEntity.name}",
          style: TextStyle(
            fontSize: 24,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Text(
          "${this.widget.employeeEntity.entityTypeLanguage}",
          style: TextStyle(
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        SizedBox(
          height: 15.0,
        ),
        Expanded(
          child: GridView.count(
            // Create a grid with 2 columns. If you change the scrollDirection to
            // horizontal, this produces 2 rows.
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: this.createItems(),
            // Generate 100 widgets that display their index in the List.
          ),
        ),
      ],
    );
  }

  List<Widget> createItems() {
    List<Widget> widgets = <Widget>[];
    this.controller.entities?.forEach((element) {
      widgets.add(
        createItem(
          "",
          element.description,
          element,
          this.widget.productEntity,
        ),
      );
    });
    return widgets;
  }

  Container createItem(
    String image,
    String text,
    EventEntity eventEntity,
    ProductEntity productEntity,
  ) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      color: Colors.lightBlue,
      child: TextButton(
        onPressed: () {
          if (eventEntity.codeReturn == 0) {
            if (eventEntity.showEvent == 0) {
              this.controller.loadProduct(productEntity, eventEntity, (result) {
                if (result.length <= 1) {
                  for (var idx = 0; idx < result.length; idx++) {
                    var product = result[idx];
                    productEntity = product;
                    if (productEntity.qtyRemaining > 0) {
                      this.controller.addItemToCart(productEntity);
                      this.controller.confirmButtonClicked(productEntity,
                          (result) {
                        Navigator.pop(context);

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Padding(
                                padding: const EdgeInsets.only(
                                    top: 280, bottom: 230, right: 40, left: 40),
                                child: AlertDialog(
                                  title: Padding(
                                    padding: const EdgeInsets.only(top: 40),
                                    child: Center(
                                      child: Text(
                                        'Operação efetuada com sucesso',
                                      ),
                                    ),
                                  ),
                                  content: Column(
                                    children: [
                                      Text(
                                        'O produto foi debitado do saldo.',
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            });
                      });
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  top: 220, bottom: 220, right: 20, left: 20),
                              child: AlertDialog(
                                title: Padding(
                                  padding: const EdgeInsets.only(top: 90),
                                  child: Center(
                                    child: Text(
                                      'Atenção :',
                                    ),
                                  ),
                                ),
                                content: Column(
                                  children: [
                                    Text(
                                      'Você não tem saldo para esse Item ou já retirou o mesmo hoje',
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    }
                  }
                }
              });
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductsScreen(
                    eventEntity: eventEntity,
                    employeeEntity: this.widget.employeeEntity,
                    productEntity: this.widget.productEntity,
                  ),
                ),
              );
            }
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Padding(
                    padding: const EdgeInsets.only(
                        top: 220, bottom: 220, right: 20, left: 20),
                    child: AlertDialog(
                      title: Padding(
                        padding: const EdgeInsets.only(top: 90),
                        child: Center(
                          child: Text(
                            'Atenção :',
                          ),
                        ),
                      ),
                      content: Column(
                        children: [
                          Text(
                            '${eventEntity.descriptionReturn}',
                          ),
                        ],
                      ),
                    ),
                  );
                });
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //_createImage(image),
            Row(
              children: [
                Expanded(
                  child: Text(
                    text,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
/*
  Widget _createImage(String image) {
    if (image == null || image.isEmpty) {
      return Container();
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgPicture.asset(
          image,
          height: 80,
          color: Colors.white,
        ),
        SizedBox(
          height: 16,
        ),
      ],
    );
  }
*/

}
