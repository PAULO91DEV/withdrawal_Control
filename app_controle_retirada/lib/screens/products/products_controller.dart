import 'package:controleRetirada/commons/item_value.dart';
import 'package:controleRetirada/core/exceptions.dart';
import 'package:controleRetirada/core/usecase.dart';
import 'package:controleRetirada/data/entities/confirm_request_entity.dart';
import 'package:controleRetirada/domain/entities/activation_entity.dart';
import 'package:controleRetirada/domain/entities/confirm_entity.dart';
import 'package:controleRetirada/domain/entities/items_entity.dart';
import 'package:controleRetirada/domain/entities/login_entity.dart';
import 'package:controleRetirada/domain/repositories/confirm_repository.dart';
import 'package:controleRetirada/domain/usecases/add_Item_cart_usecase.dart';
import 'package:controleRetirada/domain/usecases/clear_cart_usecase.dart';
import 'package:controleRetirada/domain/usecases/delete_item_cart_usecase.dart';
import 'package:controleRetirada/domain/usecases/get_all_items_cart_usecase.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/domain/entities/employee_entity.dart';
import 'package:controleRetirada/domain/entities/event_entity.dart';
import 'package:controleRetirada/domain/entities/products_entity.dart';
import 'package:controleRetirada/domain/repositories/products_repository.dart';
part 'products_controller.g.dart';

typedef OnResultAddItemCard = void Function(
  String error,
  bool isFinishedItemsCart,
  bool isGoNextLevel,
  String returnDescription,
);

class ProductsController = ProductsControllerBase with _$ProductsController;

abstract class ProductsControllerBase with Store {
  final EventEntity _eventEntity;
  final ConfirmRepository confirmRepository;
  final ProductRepository _productRepository;
  final EmployeeEntity _employeeEntity;
  final ConfirmEntity confirmEntity;
  final AddItemCardUseCase _addItemCardUseCase;
  final GetAllItemsCartUseCase _getAllItemsCartUseCase;
  final ClearCartUseCase _clearCartUseCase;
  final DeleteItemCartUseCase _deleteItemCartUseCase;

  ProductsControllerBase(
    this._eventEntity,
    this.confirmEntity,
    this._productRepository,
    this._employeeEntity,
    this.confirmRepository,
    this._addItemCardUseCase,
    this._getAllItemsCartUseCase,
    this._clearCartUseCase,
    this._deleteItemCartUseCase,
  );

  @observable
  bool isLoading = false;

  @observable
  String returnMessage = '';

  @observable
  String message = '';

  @observable
  ObservableList<ProductEntity> entitie = ObservableList();

  @observable
  ObservableList<ItemValue> listCart = ObservableList();

  @action
  void load() {
    this.isLoading = true;
    SharedPreferences.getInstance().then((prefs) {
      var tokenAPI = prefs.getString(kTokenSharedPref);
      this
          ._productRepository
          .getProducts(
            tokenAPI,
            this._employeeEntity.code,
            this._eventEntity.companyId,
            this._eventEntity.siteId,
            this._eventEntity.eventId,
            this._eventEntity.accumulative,
            this._eventEntity.pulloutSingle.toString(),
          )
          .then((products) {
        this.entitie = products.asObservable();
        return this._getAllItemsCartUseCase.call(NoParams());
      }).then((cartItems) {
        this.listCart = cartItems.asObservable();
        this.isLoading = false;
      }).catchError((error) {
        this.isLoading = false;
      });
    });
  }

  @action
  void addItemToCart(ProductEntity ite, OnResultAddItemCard onResult) {
    this._addItemCardUseCase.call(AddItemCartUseCaseParam(ite)).then((_) {
      return this._getAllItemsCartUseCase.call(NoParams());
    }).then((items) {
      this.listCart = items.asObservable();
      if (ite.automaticDown == 1) {
        this.confirmButtonClicked(
          onResult,
        );
      }
    }).catchError((error) {
      // Saldo Insuficiente
      if (error is DisplayReturnMessage) {
        onResult(
          "Atenção.",
          false,
          false,
          ite.descriptionReturn,
        );
      }

      if (error is InsufficientFundsException) {
        onResult(
          "Você inseriu o seu saldo maximo no carrinho para esse item.",
          false,
          false,
          ite.descriptionReturn,
        );
      }
      // Ir para o proximo nivel
      else if (error is ForSelectionOnlyException) {
        onResult(
          null,
          false,
          true,
          null,
        );
      }
      // Baixa Automatica
      else {}
    });
  }

  @action
  void deleteItemToCart(ItemValue itemValue) {
    this
        ._deleteItemCartUseCase
        .call(DeleteItemCartUseCaseParams(itemValue))
        .then((_) {
      return this._getAllItemsCartUseCase.call(NoParams());
    }).then((cartItems) {
      this.listCart = cartItems.asObservable();
    });
  }

  @action
  void setListcart(List<ItemValue> items) {
    this.listCart = items.asObservable();
  }

  @action
  void viewProductEntity(ProductEntity productEntity) {
    for (var idx = 0; idx < this.listCart.length; idx++) {
      var itemCart = this.listCart[idx];
      productEntity = itemCart.value;
    }
  }

  @action
  void viewItemEntity(ItemEntity itemEntity) {
    for (var idx = 0; idx < this.listCart.length; idx++) {
      var itemCart = this.listCart[idx];
      itemEntity = itemCart.value;
    }
  }

  @action
  void confirmButtonClicked(
    OnResultAddItemCard onResult,
  ) {
    this.isLoading = true;
    SharedPreferences.getInstance().then(
      (prefs) {
        LoginResponseEntity loginResponse =
            loginResponseEntityFromJson(prefs.getString(kLoginDataSharedPref));
        ActivationEntity localId = activationEntityFromJson(
          prefs.getString(kDeviceLocationSharedPref),
        );
        this._finishCardItems(
          loginResponse,
          localId,
          onResult,
        );
      },
    );
  }

  void _finishCardItems(
    LoginResponseEntity loginResponse,
    ActivationEntity localId,
    OnResultAddItemCard onResult,
  ) {
    var items = <ConfirmRequestEntity>[];

    for (var idx = 0; idx < this.listCart.length; idx++) {
      var itemCart = this.listCart[idx];
      items.add(ConfirmRequestEntity(
        companyId: itemCart.value["company_id"],
        siteId: itemCart.value["site_id"],
        eventId: itemCart.value[
            "event_id"], //eventId: "0", para testar indisponivel ao funcionario.
        productId: itemCart.value["product_id"],
        itemId: itemCart.value["item_id"],
        partId: itemCart.value["part_id"],
        partUnit: itemCart.value["part_id"],
        personId: this._employeeEntity.code,
        localId: localId.locationId,
        userId: loginResponse.login,
        qtyPullout: "1",
        inventoryControl: itemCart.value["inventory_control"].toString(),
        costPrice: itemCart.value["cost_price"],
        costPriceHoliday: itemCart.value["cost_price_holiday"],
      ));
    }
    this
        .confirmRepository
        .postInsertLaunchEvent(
          loginResponse.token,
          items,
        )
        .then((confirmValue) async {
      await this._clearCartUseCase.call(NoParams());
      this.returnMessage = confirmValue.descriptionReturn;
      this.isLoading = false;
      if (confirmValue.codeReturn != 0) {
        onResult(
          null,
          false,
          false,
          confirmValue.descriptionReturn,
        );
      } else {
        onResult(
          null,
          true,
          false,
          confirmValue.descriptionReturn,
        );
      }
    }).catchError((onError) {
      this.isLoading = false;
      this.message = "Atenção";
      onResult(
        "Atenção",
        true,
        false,
        this.returnMessage,
      );
    });
  }
}
