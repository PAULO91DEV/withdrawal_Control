import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:controleRetirada/commons/constants.dart';
import 'package:controleRetirada/domain/entities/activation_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:controleRetirada/domain/repositories/device_location_repository.dart';
import 'package:get_mac/get_mac.dart';
part 'device_location_controller.g.dart';

class DeviceLocationController = DeviceLocationControllerBase
    with _$DeviceLocationController;

abstract class DeviceLocationControllerBase with Store {
  // ignore: unused_field
  final ActivationEntity _activationEntity;
  final DeviceLocationRepository _deviceLocationRepository;

  DeviceLocationControllerBase(
    this._activationEntity,
    this._deviceLocationRepository,
  );

  @observable
  bool isLoading = false;

  @observable
  String errorMessage = '';

  @action
  activation(Function onError) async {
    this.isLoading = true;
    this.errorMessage = "";
    String macAddress;
    try {
      macAddress = await GetMac.macAddress;
    } on PlatformException {}
    SharedPreferences.getInstance().then((prefs) {
      var tokenAPI = prefs.getString(kTokenSharedPref);
      var activateCode = prefs.getString(kMacAddress);

      this
          ._deviceLocationRepository
          .postDeviceLocalByDeviceCode(
            tokenAPI,
            macAddress,
            activateCode,
          )
          .then((value) {
        this.isLoading = false;
        onError(null);
      }).catchError((error) {
        print("#### error=$error");
        onError(error);
        if (error is DioError) {
          this.errorMessage = error.response.data;
        }
        this.isLoading = false;
      });
      prefs.setString(
        kDeviceLocationSharedPref,
        activationEntityToJson(this._activationEntity),
      );
    });
  }
}
