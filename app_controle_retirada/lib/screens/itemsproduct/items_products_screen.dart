import 'package:controleRetirada/data/datasources/cart/local/cart_local_datasource_impl.dart';
import 'package:controleRetirada/data/repositories/cart_repository_impl.dart';
import 'package:controleRetirada/domain/entities/items_entity.dart';
import 'package:controleRetirada/domain/repositories/cart_repository.dart';
import 'package:controleRetirada/domain/usecases/add_Item_cart_usecase.dart';
import 'package:controleRetirada/domain/usecases/clear_cart_usecase.dart';
import 'package:controleRetirada/domain/usecases/delete_item_cart_usecase.dart';
import 'package:controleRetirada/domain/usecases/get_all_items_cart_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:controleRetirada/commons/item_value.dart';
import 'package:controleRetirada/data/datasources/confirm/remote/confirm_remote_data.dart';
import 'package:controleRetirada/data/datasources/items/remote/items_remote_datasource.dart';
import 'package:controleRetirada/data/repositories/confirm_repository_impl.dart';
import 'package:controleRetirada/data/repositories/items_repository_impl.dart';
import 'package:controleRetirada/domain/entities/confirm_entity.dart';
import 'package:controleRetirada/domain/entities/employee_entity.dart';
import 'package:controleRetirada/domain/entities/event_entity.dart';
import 'package:controleRetirada/domain/entities/products_entity.dart';
import 'package:controleRetirada/screens/itemsproduct/items_controller.dart';
import 'package:controleRetirada/widgets/bottom_confirm_items.dart';
import 'package:controleRetirada/commons/extensions.dart';

class ItemsProductScreen extends StatefulWidget {
  final ProductEntity productEntity;
  final EmployeeEntity employeeEntity;
  final EventEntity eventEntity;
  final ItemEntity itemsEntity;
  final ConfirmEntity confirmEntity;
  final List<ItemValue> listCartProduct;

  ItemsProductScreen({
    Key key,
    this.productEntity,
    this.employeeEntity,
    this.eventEntity,
    this.itemsEntity,
    this.confirmEntity,
    this.listCartProduct,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ItemsProductScreenState();
}

class _ItemsProductScreenState extends State<ItemsProductScreen> {
  ItemsController _controller;

  Dio _dio; //instanciou o DIO para poder usar no construtor duas instancias.

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
    this._dio = createDio();
    CartRepository cartRepository =
        new CartRepositoryImpl(CartLocalDataSourceImpl());

    this._controller = ItemsController(
      this.widget.productEntity,
      ItemsRepositoryImpl(
        ItemsRemoteDataSource(
          this._dio,
        ),
      ),
      this.widget.employeeEntity,
      this.widget.eventEntity,
      ConfirmRepositoryImpl(
        ConfirmRemoteDataSource(
          this._dio,
        ),
      ),
      this.widget.confirmEntity,
      AddItemCardUseCase(cartRepository),
      GetAllItemsCartUseCase(cartRepository),
      DeleteItemCartUseCase(cartRepository),
      ClearCartUseCase(cartRepository),
    );
    this._controller.load(this.widget.listCartProduct);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pop(true);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.indigo[900],
          elevation: 0,
          title: Text('Itens'),
          actions: [
            Row(
              children: [
                IconButton(
                  padding: EdgeInsets.only(),
                  icon: Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                    size: 38.0,
                  ),
                  onPressed: () {
                    confirmBottomSheet();
                  },
                ),
                Observer(builder: (_) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 22, top: 12),
                    child: Text(
                      "${this._controller.listCart.length}",
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                  );
                }),
              ],
            )
          ],
        ),
        body: Container(
          color: Colors.indigo[900],
          padding:
              EdgeInsets.only(top: 16.0, bottom: 90.0, left: 10, right: 10),
          width: double.infinity,
          child: Observer(builder: (_) {
            return _body();
          }),
        ),
      ),
    );
  }

  Widget _body() {
    if (this._controller.isLoading) {
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
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: this.createItems(),
          ),
        ),
      ],
    );
  }

  List<Widget> createItems() {
    List<Widget> widgets = <Widget>[];
    this._controller.itemsEntitiees?.forEach((element) {
      widgets.add(
        createItem(element),
      );
    });
    return widgets;
  }

  Container createItem(ItemEntity item) {
    return Container(
      padding: EdgeInsets.only(top: 15, bottom: 15),
      color: Colors.lightBlue,
      child: TextButton(
        onPressed: () {
          this._controller.addItemToCart(item, (
            error,
            isFinishedItemsCart,
            isGoNextLevel,
            returnDescription,
          ) {
            if (error != null) {
              this.showAlertDialog(
                title: error,
                subtitle: returnDescription,
              );
              return;
            }

            if (isFinishedItemsCart) {
              this
                  .showAlertDialog(
                      title: 'Operação efetuada com sucesso!',
                      subtitle: this._controller.returnMessage)
                  .then((_) {
                Navigator.pop(context);
                Navigator.pop(context);
              });
              return;
            }

            if (returnDescription.isNotEmpty && returnDescription != null) {
              this.showAlertDialog(
                  title: "Atenção", subtitle: returnDescription);
              return;
            }
          });
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Text(
                  item.partDescription,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Saldo: ${item.qtyRemaining.toString()}",
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void confirmBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return Observer(builder: (_) {
          if (this._controller.listCart.isEmpty) {
            return createEmptyCartList();
          }
          return createCartItemsList(this.widget.itemsEntity);
        });
      },
    );
  }

  SingleChildScrollView createCartItemsList(
    ItemEntity item,
  ) {
    return SingleChildScrollView(
      child: Observer(builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 16,
            ),
            Text(
              "Items adicionados",
              style: TextStyle(
                fontSize: 20,
                color: Colors.indigo[900],
              ),
              // style: Colors.blue,
            ),
            SizedBox(
              height: 16,
            ),
            ListView.builder(
              padding: EdgeInsets.only(left: 20),
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              itemCount: this._controller.listCart.length,
              itemBuilder: (context, index) {
                ItemValue itemValue = this._controller.listCart[index];
                return ListTile(
                  leading: new Icon(
                    Icons.add_shopping_cart,
                    color: Colors.indigo[900],
                  ),
                  trailing: TextButton(
                    child: Icon(
                      Icons.delete,
                      color: Colors.indigo[900],
                    ),
                    onPressed: () {
                      this._controller.deleteItemToCart(itemValue);
                    },
                  ),
                  title: new Text(
                    "${itemValue.label} - ${itemValue.detail}",
                  ),
                );
              },
            ),
            SizedBox(
              height: 16,
            ),
            Observer(
              builder: (_) {
                if (this._controller.isLoading) {
                  return Column(
                    children: [
                      Container(
                        height: 48,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ],
                  );
                }

                if (this._controller.message.isNotEmpty) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: ButtonConfirmWidget(
                          text: "Confirmar",
                          onPressed: () {
                            this._controller.confirmButtonClicked(
                              (
                                error,
                                isFinishedItemsCart,
                                isGoNextLevel,
                                returnDescription,
                              ) {
                                if (error != null) {
                                  this.showAlertDialog(
                                      title: "Atenção", subtitle: error);
                                  return;
                                }

                                if (isFinishedItemsCart) {
                                  this
                                      .showAlertDialog(
                                          title:
                                              'Operação efetuada com sucesso!',
                                          subtitle:
                                              this._controller.returnMessage)
                                      .then((_) {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  });
                                  return;
                                }
                              },
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 65),
                        child: Column(
                          children: [
                            Center(
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.error,
                                    color: Colors.redAccent,
                                  ),
                                  Text(
                                    this._controller.message,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 48,
                                child: RaisedButton(
                                  disabledColor: Colors.indigo[200],
                                  color: Colors.indigo[900],
                                  child: Text(
                                    "Scanner QRcode",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white,
                                      fontSize: 24.0,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                  ),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                    ],
                  );
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ButtonConfirmWidget(
                    text: "Confirmar",
                    onPressed: () {
                      this._controller.confirmButtonClicked(
                        (
                          error,
                          isFinishedItemsCart,
                          isGoNextLevel,
                          returnDescription,
                        ) {
                          if (error != null) {
                            this.showAlertDialog(
                                title: "Atenção", subtitle: error);
                            return;
                          }

                          if (isFinishedItemsCart) {
                            this
                                .showAlertDialog(
                                    title: 'Operação efetuada com sucesso!',
                                    subtitle: this._controller.returnMessage)
                                .then((_) {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            });
                            return;
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
            SizedBox(
              height: 16,
            ),
          ],
        );
      }),
    );
  }

  Container createEmptyCartList() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Items adicionados",
            style: TextStyle(
              fontSize: 12,
              color: Colors.indigo[900],
            ),
          ),
          SizedBox(height: 16),
          Icon(
            Icons.remove_shopping_cart,
            color: Colors.indigo[900],
            size: 86,
          ),
          SizedBox(height: 16),
          Text(
            "Lista vazia",
            style: TextStyle(
              fontSize: 26,
              color: Colors.indigo[900],
            ),
          )
        ],
      ),
    );
  }

  Widget chackErrorMessenger(bool isShow) {
    if (isShow) {
      return Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          children: [
            Icon(
              Icons.error,
              color: Colors.redAccent,
            ),
            SizedBox(
              width: 8,
            ),
            Center(
              child: Text(
                "Indisponivel ao funcionario",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.red,
                ),
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      child: RaisedButton(
                        disabledColor: Colors.indigo[200],
                        color: Colors.indigo[900],
                        child: Text(
                          "Scanner QRcode",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                            fontSize: 24.0,
                          ),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28.0),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
          ],
        ),
      );
    }
    return Container();
  }
}
