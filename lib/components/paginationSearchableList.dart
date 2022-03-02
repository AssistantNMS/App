import 'package:assistantapps_flutter_common/assistantapps_flutter_common.dart';
import 'package:flutter/material.dart';

class PaginationSearchableList<T> extends StatefulWidget {
  final Future<PaginationResultWithValue<List<T>>> Function(int page)
      listGetter;
  final Future<ResultWithValue<List<T>>> Function() backupListGetter;
  final Widget Function(BuildContext context, T) listItemDisplayer;
  final bool Function(T, String) listItemSearch;
  final void Function() deleteAll;
  final int minListForSearch;
  final String customKey;
  final String hintText;
  final bool addFabPadding;
  final Widget firstListItemWidget;
  final Widget lastListItemWidget;

  const PaginationSearchableList(
    this.listGetter,
    this.listItemDisplayer,
    this.listItemSearch, {
    Key key,
    this.customKey,
    this.hintText,
    this.deleteAll,
    this.minListForSearch = 10,
    this.addFabPadding = false,
    this.backupListGetter,
    this.firstListItemWidget,
    this.lastListItemWidget,
  }) : super(key: key);
  @override
  PaginationSearchableListWidget<T> createState() =>
      // ignore: no_logic_in_create_state
      PaginationSearchableListWidget<T>(
        listGetter,
        listItemDisplayer,
        listItemSearch,
        customKey,
        hintText,
        minListForSearch,
        addFabPadding,
      );
}

class PaginationSearchableListWidget<T>
    extends State<PaginationSearchableList<T>> {
  final Future<PaginationResultWithValue<List<T>>> Function(int page)
      listGetter;
  int currentPage = 1;
  int totalPages = 1;
  final Widget Function(BuildContext context, T) listItemDisplayer;
  final bool Function(T, String) listItemSearch;
  final int minListForSearch;
  final String key;
  final String hintText;
  final bool addFabPadding;

  PaginationSearchableListWidget(
    this.listGetter,
    this.listItemDisplayer,
    this.listItemSearch,
    this.key,
    this.hintText,
    this.minListForSearch,
    this.addFabPadding,
  );

  Future<ResultWithValue<List<T>>> hookIntoListGetter() async {
    final temp = await listGetter(currentPage);
    if (temp.isSuccess) {
      setState(() {
        currentPage = temp.currentPage;
        totalPages = temp.totalPages;
      });
      return ResultWithValue<List<T>>(true, temp.value, '');
    }
    return ResultWithValue<List<T>>(false, temp.value, temp.errorMessage);
  }

  void nextPage() {
    setState(() {
      currentPage = currentPage + 1;
    });
  }

  void prevPage() {
    setState(() {
      currentPage = currentPage - 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    var firstListItemWidget =
        InkWell(child: widget.firstListItemWidget, onTap: prevPage);
    var lastListItemWidget =
        InkWell(child: widget.lastListItemWidget, onTap: nextPage);
    return SearchableList<T>(
      () => hookIntoListGetter(),
      listItemDisplayer: listItemDisplayer,
      listItemSearch: listItemSearch,
      minListForSearch: minListForSearch,
      addFabPadding: widget.addFabPadding,
      backupListGetter: widget.backupListGetter,
      deleteAll: widget.deleteAll,
      hintText: widget.hintText,
      key: Key('${widget.key}-$currentPage'),
      firstListItemWidget:
          (currentPage > 1 && widget.firstListItemWidget != null)
              ? firstListItemWidget
              : null,
      lastListItemWidget:
          (currentPage < totalPages && widget.lastListItemWidget != null)
              ? lastListItemWidget
              : null,
    );
  }
}
