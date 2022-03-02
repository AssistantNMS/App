import 'dart:convert';

import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

import 'dependencyInjection.dart';

class RemoteConfigs extends BaseApiService {
  String apiKey;
  String _configurationsUrl;
  String remoteConfigsUrl = 'https://api.remoteconfigs.com/';

  final String _configurationsEndpoint = 'Configurations';
  final String _headerKey = 'apikey';

  RemoteConfigs({this.apiKey}) : super(getEnv().baseApi) {
    this._configurationsUrl =
        "${this.remoteConfigsUrl}${this._configurationsEndpoint}";
  }

  Future<ResultWithValue<List<Configuration>>> getAllConfigurations(
      BuildContext context) async {
    var response = await this.webGet(this._configurationsUrl,
        headers: {this._headerKey: this.apiKey});

    if (response.hasFailed) {
      return ResultWithValue<List<Configuration>>(
          false, List.empty(growable: true), response.errorMessage);
    }

    try {
      final List configsList = json.decode(response.value);
      var configs = configsList.map((r) => Configuration.fromJson(r)).toList();
      return ResultWithValue(true, configs, '');
    } catch (exception) {
      getLog().e("RemoteConfigs Api Exception: ${exception.toString()}");
      return ResultWithValue<List<Configuration>>(
          false, List.empty(growable: true), exception.toString());
    }
  }

  Future<ResultWithValue<Configuration>> getConfiguration(
      BuildContext context, String configId) async {
    var url = "${this._configurationsUrl}/$configId";
    var response =
        await this.webGet(url, headers: {this._headerKey: this.apiKey});

    if (response.hasFailed) {
      return ResultWithValue<Configuration>(
          false, Configuration(), response.errorMessage);
    }

    try {
      return ResultWithValue(
          true, Configuration.fromRawJson(response.value), '');
    } catch (exception) {
      getLog().e("RemoteConfigs Api Exception: ${exception.toString()}");
      return ResultWithValue<Configuration>(
          false, Configuration(), exception.toString());
    }
  }

  Future<ResultWithValue<ConfigurationObject<T>>> getConfigurationObject<T>(
      BuildContext context,
      String configId,
      T Function(String) settingsFromJson) async {
    var url = "${this._configurationsUrl}/$configId/Object";
    var response =
        await this.webGet(url, headers: {this._headerKey: this.apiKey});

    if (response.hasFailed) {
      return ResultWithValue<ConfigurationObject<T>>(
          false, ConfigurationObject<T>(), response.errorMessage);
    }

    try {
      return ResultWithValue(
          true,
          ConfigurationObject<T>.fromRawJson(response.value, settingsFromJson),
          '');
    } catch (exception) {
      getLog().e("RemoteConfigs Api Exception: ${exception.toString()}");
      return ResultWithValue<ConfigurationObject<T>>(
          false, ConfigurationObject<T>(), exception.toString());
    }
  }

  // GetConfiguration(configId: string): Promise<IConfiguration>;
  // GetConfigurationObject<T>(configId: string): Promise<IConfigurationObject<T>>;
  // CreateConfiguration(configuration: INewConfiguration): Promise<IConfiguration>;
  // UpdateConfiguration(configId: string, configuration: INewConfiguration): Promise<IConfiguration>;
  // DeleteConfiguration(configId: string): Promise<IConfiguration>;
}

class Configuration {
  String uniqueID;
  String name;
  String description;
  String createDate;
  String lastModifiedOn;
  List<ConfigurationSettings> settings;

  Configuration({
    this.uniqueID,
    this.name,
    this.description,
    this.createDate,
    this.lastModifiedOn,
    this.settings,
  });

  factory Configuration.fromRawJson(String str) =>
      Configuration.fromJson(json.decode(str));

  factory Configuration.fromJson(Map<String, dynamic> json) => Configuration(
        uniqueID: json["uniqueID"],
        name: json["name"],
        description: json["description"],
        createDate: json["createDate"],
        lastModifiedOn: json["lastModifiedOn"],
        settings: List<ConfigurationSettings>.from(
          json["settings"].map((x) => ConfigurationSettings.fromJson(x)),
        ),
      );
}

class ConfigurationSettings {
  String key;
  String value;

  ConfigurationSettings({
    this.key,
    this.value,
  });

  factory ConfigurationSettings.fromRawJson(String str) =>
      ConfigurationSettings.fromJson(json.decode(str));

  factory ConfigurationSettings.fromJson(Map<String, dynamic> json) =>
      ConfigurationSettings(
        key: json["key"],
        value: json["value"],
      );
}

class ConfigurationObject<T> {
  String name;
  String description;
  T settings;

  ConfigurationObject({
    this.name,
    this.description,
    this.settings,
  });

  factory ConfigurationObject.fromRawJson(
          String str, T Function(String) settingsFromJson) =>
      ConfigurationObject.fromJson(json.decode(str), settingsFromJson);

  factory ConfigurationObject.fromJson(
          Map<String, dynamic> json, T Function(String) settingsFromJson) =>
      ConfigurationObject(
        name: json["name"],
        description: json["description"],
        settings: settingsFromJson(json["settings"]),
      );
}
