import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';
import '../../../contracts/genericPageItem.dart';

class IGenericRepository {
  Future<ResultWithValue<List<GenericPageItem>>> getAll(
      BuildContext context) async {
    return ResultWithValue<List<GenericPageItem>>(
      false,
      List.empty(growable: true),
      '',
    );
  }

  Future<ResultWithValue<GenericPageItem>> getById(
    BuildContext context,
    String id,
  ) async {
    return ResultWithValue<GenericPageItem>(
      false,
      GenericPageItem.fromJson(<String, dynamic>{}),
      '',
    );
  }

  Future<ResultWithValue<List<GenericPageItem>>> getByInputsId(
    BuildContext context,
    String id,
  ) async {
    return ResultWithValue<List<GenericPageItem>>(
      false,
      List.empty(growable: true),
      '',
    );
  }
}
