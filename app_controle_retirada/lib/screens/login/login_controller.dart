import 'package:controleRetirada/core/usecase.dart';
import 'package:controleRetirada/domain/usecases/clear_cart_usecase.dart';
import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/domain/entities/login_entity.dart';
import 'package:controleRetirada/domain/repositories/login_repository.dart';
part 'login_controller.g.dart';

class LoginController = LoginControllerBase with _$LoginController;

abstract class LoginControllerBase with Store {
  final LoginRepository _loginRepository;
  final ClearCartUseCase _clearCartUseCase;
  LoginControllerBase(this._loginRepository, this._clearCartUseCase);

  @observable
  String user = "";

  @observable
  String pass = "";

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = '';

  @computed
  bool get isLoginBottonEnabled => this.user.isNotEmpty && this.pass.isNotEmpty;

  @action
  void setPass(String value) => this.pass = value;

  @action
  void setUser(String value) => this.user = value;

  @action
  void init() {
    this._clearCartUseCase.call(NoParams());
  }

  @action
  void login(Function onResult) {
    this.isLoading = true;

    this
        ._loginRepository
        .signin(
          this.user,
          this.pass,
        )
        .then((result) {
      SharedPreferences.getInstance().then((pref) {
        print('sucess $result');

        

        String data = loginResponseEntityToJson(result);
        
        pref.setString(kTokenSharedPref, result.token);
        pref.setString(kLoginDataSharedPref, data);

        onResult(result);
      });
    }).catchError((error) {
      this.isLoading = false;
      this.errorMessage = error;
    });
  }
}
