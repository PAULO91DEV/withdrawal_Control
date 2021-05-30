import 'package:controleRetirada/core/exceptions.dart';
import 'package:controleRetirada/core/usecase.dart';
import 'package:controleRetirada/domain/entities/activation_entity.dart';
import 'package:controleRetirada/domain/entities/items_entity.dart';
import 'package:controleRetirada/domain/usecases/add_Item_cart_usecase.dart';
import 'package:controleRetirada/domain/usecases/clear_cart_usecase.dart';
import 'package:controleRetirada/domain/usecases/delete_item_cart_usecase.dart';
import 'package:controleRetirada/domain/usecases/get_all_items_cart_usecase.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/data/entities/confirm_request_entity.dart';
import 'package:controleRetirada/domain/entities/confirm_entity.dart';
import 'package:controleRetirada/domain/entities/employee_entity.dart';
import 'package:controleRetirada/domain/entities/event_entity.dart';
import 'package:controleRetirada/domain/entities/login_entity.dart';
import 'package:controleRetirada/domain/entities/products_entity.dart';
import 'package:controleRetirada/domain/repositories/confirm_repository.dart';
import 'package:controleRetirada/domain/repositories/items_repository.dart';
import 'package:controleRetirada/commons/item_value.dart';
part 'items_controller.g.dart';

typedef OnResultAddItemCard = void Function(
  String error,
  bool isFinishedItemsCart,
  bool isGoNextLevel,
  String returnDescription,
);

class ItemsController = ItemsControllerBase with _$ItemsController;

abstract class ItemsControllerBase with Store {
  final ProductEntity _productEntity;
  final ItemsRepository _itemsRepository;
  final EmployeeEntity _employeeEntity;
  final EventEntity _eventEntity;
  final ConfirmRepository confirmRepository;
  final ConfirmEntity confirmEntity;
  final AddItemCardUseCase _addItemCardUseCase;
  final GetAllItemsCartUseCase _getAllItemsCartUseCase;
  final DeleteItemCartUseCase _deleteItemCartUseCase;
  final ClearCartUseCase _clearCartUseCase;

  ItemsControllerBase(
    this._productEntity,
    this._itemsRepository,
    this._employeeEntity,
    this._eventEntity,
    this.confirmRepository,
    this.confirmEntity,
    this._addItemCardUseCase,
    this._getAllItemsCartUseCase,
    this._deleteItemCartUseCase,
    this._clearCartUseCase,
  );

  @observable
  bool isLoading = false;

  @observable
  String returnMessage = '';

  @observable
  String message = '';

  @observable
  String confirmVal = '';

  @observable
  ObservableList<ItemEntity> itemsEntitiees = ObservableList();

  @observable
  ConfirmEntity confirmEntitiees = ConfirmEntity();

  @observable
  ObservableList<ItemValue> listCart = ObservableList();

  @action
  void load(List<ItemValue> list) {
    this.listCart = list.asObservable();
    this.isLoading = true;
    SharedPreferences.getInstance().then((prefs) {
      var tokenAPI = prefs.getString(kTokenSharedPref);
      this
          ._itemsRepository
          .getItems(
            this._productEntity.productId,
            this._employeeEntity.code,
            tokenAPI,
            this._productEntity.companyId,
            this._productEntity.siteId,
            this._productEntity.eventId,
            this._eventEntity.accumulative,
            this._eventEntity.pulloutSingle.toString(),
          )
          .then((value) {
        this.isLoading = false;
        this.itemsEntitiees = value.asObservable();
      }).catchError((onError) {
        this.isLoading = false;
      });
    });
  }

  @action
  void addItemToCart(ItemEntity ite, OnResultAddItemCard onResult) {
    this._addItemCardUseCase.call(AddItemCartUseCaseParam(ite)).then((_) {
      return this._getAllItemsCartUseCase.call(NoParams());
    }).then((items) {
      this.listCart = items.asObservable();
      if (ite.automaticDown == 1) {
        this.confirmButtonClicked(
          // ite,
          onResult,
        );
      }
    }).catchError((onError) {
      if (onError is DisplayReturnMessage) {
        onResult(
          "Atenção",
          false,
          false,
          ite.descriptionReturn,
        );
      }
      if (onError is InsufficientFundsException) {
        onResult(
          "Você inseriu o seu saldo maximo no carrinho para esse item.",
          false,
          false,
          ite.descriptionReturn,
        );
      } else if (onError is ForSelectionOnlyException) {
        onResult(
          null,
          false,
          true,
          null,
        );
      } else {}
    });
  }

  @action
  void deleteItemToCart(ItemValue itemValue) {
    this
        ._deleteItemCartUseCase
        .call(DeleteItemCartUseCaseParams(itemValue))
        .then((_) {
      return this._getAllItemsCartUseCase.call(NoParams());
    }).then((value) {
      this.listCart = value.asObservable();
    });
  }

  @action
  void setListcart(List<ItemValue> items) {
    this.listCart = items.asObservable();
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
