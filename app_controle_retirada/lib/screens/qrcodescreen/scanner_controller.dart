import 'package:controleRetirada/commons/item_value.dart';
import 'package:controleRetirada/domain/entities/confirm_entity.dart';
import 'package:controleRetirada/domain/repositories/confirm_repository.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/domain/repositories/employee_repository.dart';
import 'package:controleRetirada/domain/entities/login_entity.dart';
import 'package:controleRetirada/domain/entities/employee_entity.dart';
import 'package:controleRetirada/domain/entities/event_entity.dart';
import 'package:controleRetirada/domain/entities/activation_entity.dart';
import 'package:controleRetirada/domain/entities/products_entity.dart';
import 'package:controleRetirada/domain/repositories/event_repository.dart';
part 'scanner_controller.g.dart';

class ScannerController = ScannerControllerBase with _$ScannerController;

abstract class ScannerControllerBase with Store {
  final EmployeeRepository _employeeRepository;
  final ProductEntity productEntity;
  final EventRepository _repository;

  final ConfirmRepository confirmRepository;

  ScannerControllerBase(
    this._employeeRepository,
    this.productEntity,
    this._repository,
    this.confirmRepository,
  );

  @observable
  String code = "";

  @observable
  String errorMessage = '';

  @observable
  bool isFlashOn = false;

  @observable
  bool isLoading = false;

  @observable
  String message = '';

  @observable
  ObservableList<EventEntity> entities = ObservableList();

  @observable
  ObservableList<ProductEntity> entitie = ObservableList();

  @action
  void toogleFlash() => this.isFlashOn = !this.isFlashOn;

  @observable
  ObservableList<ItemValue> listCart = ObservableList();

  @observable
  ConfirmEntity confirmEntitiees = ConfirmEntity();

  @action
  void setGetCode(String value, Function onResult) {
    this.code = "";
    if (value != this.code) {
      this.code = value;
      this.isLoading = true;
      SharedPreferences.getInstance().then((prefs) {
        var tokenAPI = prefs.getString(kTokenSharedPref);
        this
            ._employeeRepository
            .getEmployee(
              this.code,
              tokenAPI,
            )
            .then((result) {
          this.code = result.code;
          this.isLoading = false;
          this.errorMessage = result.descriptionReturn;
          onResult(result);
        }).catchError((error) {
          this.code = "";
          this.isLoading = false;
          print("#### error : $error");
        });
      });
    }
  }

  @action
  void loadEvent(
    EmployeeEntity employeeEntity,
    Function onResult,
  ) {
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
            employeeEntity.businessId,
            employeeEntity.businessEntityType,
            employeeEntity.departamentId,
            loginResponse.login,
            loginResponse.token,
          )
          .then((events) {
        this.isLoading = false;
        this.entities = events.asObservable();
        onResult(events);
      }).catchError((error) {
        this.isLoading = false;
      });
    });
  }

  /*
  @action
  void loadProduct(
    ProductEntity entityProduct,
    EventEntity _eventEntity,
    EmployeeEntity employeeEntity,
    Function onResult,
  ) {
    this.isLoading = true;
    SharedPreferences.getInstance().then((prefs) {
      var tokenAPI = prefs.getString(kTokenSharedPref);

      this
          ._productRepository
          .getProducts(
            tokenAPI,
            this.code,
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
  void addItemToCart(ProductEntity ite) {
    this.listCart.add(ItemValue(
          ite.partDescription,
          ite,
          ite.productDescription,
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
          personId: this.code,
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
          this.errorMessage = confirmValue.descriptionReturn;
          onResult(productEntity);
        } else {
          this.isLoading = false;
          this.errorMessage = confirmValue.descriptionReturn;
          onResult(false);
        }
      }).catchError((onError) {
        this.isLoading = false;
        this.message = onError.descriptionReturn;
      });
    });
  }*/
}
