import 'package:dio/dio.dart';

import 'package:mobx/mobx.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:controleRetirada/commons/constants.dart';

import 'package:controleRetirada/domain/repositories/activation_repository.dart';

part 'activation_device_controller.g.dart';

class ActivationDeviceController = ActivationDeviceControllerBase
    with _$ActivationDeviceController;

abstract class ActivationDeviceControllerBase with Store {
  final ActivationRepository _activationRepository;
  ActivationDeviceControllerBase(this._activationRepository);

  @observable
  String codeActivation = "";

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = '';

  @computed
  bool get isEnabledButton => this.codeActivation.isNotEmpty;

  @action
  void setCodeActivation(String value) => this.codeActivation = value;

  @action
  void activationButtonClicked(Function onResult) {
    this.isLoading = true;
    SharedPreferences.getInstance().then((prefs) {
      var tokenAPI = prefs.getString(kTokenSharedPref);
      this
          ._activationRepository
          .getLocalByActivationCode(
            tokenAPI,
            this.codeActivation,
          )
          .then((value) {
        onResult(value);
        this.isLoading = false;
      }).catchError((error) {
        if (error is DioError) {
          this.errorMessage = error.response.statusMessage;
        }
        this.isLoading = false;
      });
      prefs.setString(
        kMacAddress,
        codeActivation,
      );
    });
  }
}

onResult(result) {}
