import 'package:controleRetirada/commons/item_value.dart';
import 'package:controleRetirada/data/entities/confirm_request_entity.dart';
import 'package:controleRetirada/domain/entities/confirm_entity.dart';
import 'package:controleRetirada/domain/entities/products_entity.dart';
import 'package:controleRetirada/domain/repositories/confirm_repository.dart';
import 'package:controleRetirada/domain/repositories/products_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/domain/entities/employee_entity.dart';
import 'package:controleRetirada/domain/entities/event_entity.dart';
import 'package:controleRetirada/domain/entities/login_entity.dart';
import 'package:controleRetirada/domain/repositories/event_repository.dart';

import '../../domain/entities/activation_entity.dart';

part 'events_controller.g.dart';

class EventsController = _EventsControllerBase with _$EventsController;

abstract class _EventsControllerBase with Store {
  final EmployeeEntity _employeeEntity;
  final EventRepository _repository;
  final ProductRepository _productRepository;
  final ProductEntity productEntity;
  final ConfirmRepository confirmRepository;

  _EventsControllerBase(
    this._employeeEntity,
    this._repository,
    this._productRepository,
    this.productEntity,
    this.confirmRepository,
  );

  @observable
  bool isLoading = true;

  @observable
  String message = '';

  @observable
  String errorMessage = '';

  @observable
  ObservableList<EventEntity> entities = ObservableList();

  @observable
  ObservableList<ProductEntity> entitie = ObservableList();

  @observable
  ObservableList<ItemValue> listCart = ObservableList();

  @observable
  ConfirmEntity confirmEntitiees = ConfirmEntity();

  @action
  void load(ProductEntity productEntity) {
    SharedPreferences.getInstance().then((prefs) {
      ActivationEntity localId =
          activationEntityFromJson(prefs.getString(kDeviceLocationSharedPref));
      LoginResponseEntity loginResponse =
          loginResponseEntityFromJson(prefs.getString(kLoginDataSharedPref));
      this
          ._repository
          .getEvents(
            loginResponse.company,
            localId.locationId,
            this._employeeEntity.businessId,
            this._employeeEntity.businessEntityType,
            this._employeeEntity.departamentId,
            loginResponse.login,
            loginResponse.token,
          )
          .then((events) {
        this.isLoading = false;
        this.entities = events.asObservable();
      }).catchError((error) {
        this.isLoading = false;
      });
    });
  }

  @action
  void loadProduct(
    ProductEntity entityProduct,
    EventEntity _eventEntity,
    Function onResult,
  ) {
    this.isLoading = true;
    SharedPreferences.getInstance().then((prefs) {
      var tokenAPI = prefs.getString(kTokenSharedPref);

      this
          ._productRepository
          .getProducts(
            tokenAPI,
            this._employeeEntity.code,
            _eventEntity.companyId,
            _eventEntity.siteId,
            _eventEntity.eventId,
            _eventEntity.accumulative,
            _eventEntity.pulloutSingle.toString(),
          )
          .then((products) {
        this.isLoading = false;
        this.entitie = products.asObservable();
        onResult(products);
      }).catchError((error) {
        this.isLoading = false;
        onResult(false);
      });
    });
  }

  @action
  void viewProductEntity(ProductEntity productEntity) {
    for (var idx = 0; idx < this.listCart.length; idx++) {
      var itemCart = this.listCart[idx];
      productEntity = itemCart.value;
    }
  }

  @action
  void addItemToCart(ProductEntity ite) {
    this.listCart.add(ItemValue(
          label: ite.partDescription,
          detail: ite.productDescription,
          value: ite,
        ));
  }

  @action
  void confirmButtonClicked(
    ProductEntity productEntity,
    Function onResult,
    //List<ConfirmRequestEntity> confirmRequestEntity,
  ) {
    this.isLoading = true;
    SharedPreferences.getInstance().then((prefs) {
      LoginResponseEntity loginResponse =
          loginResponseEntityFromJson(prefs.getString(kLoginDataSharedPref));
      ActivationEntity localId =
          activationEntityFromJson(prefs.getString(kDeviceLocationSharedPref));
      var items = <ConfirmRequestEntity>[];

      for (var idx = 0; idx < this.listCart.length; idx++) {
        var itemCart = this.listCart[idx];
        var productEntity = itemCart.value;

        items.add(ConfirmRequestEntity(
          companyId: productEntity.companyId,
          siteId: productEntity.siteId,
          eventId: productEntity
              .eventId, //eventId: "0", para testar indisponivel ao funcionario.
          productId: productEntity.productId,
          itemId: productEntity.itemId,
          partId: productEntity.partId,
          partUnit: productEntity.partUnit,
          personId: this._employeeEntity.code,
          localId: localId.locationId,
          userId: loginResponse.login,
          qtyPullout: "1",
          inventoryControl: productEntity.inventoryControl.toString(),
          costPrice: productEntity.costPrice,
          costPriceHoliday: productEntity.costPriceHoliday,
        ));
        onResult(productEntity);
      }
      this
          .confirmRepository
          .postInsertLaunchEvent(
            loginResponse.token,
            items,
          )
          .then((confirmValue) {
        if (confirmValue.codeReturn == 0) {
          this.isLoading = false;
          this.confirmEntitiees = confirmValue;
          onResult(productEntity);
        } else {
          this.isLoading = false;
          this.errorMessage = confirmValue.descriptionReturn;
          onResult(false);
        }
      }).catchError((onError) {
        this.isLoading = false;
        this.message = "Ops! tente novamente mais tarde.";
      });
    });
  }
}
