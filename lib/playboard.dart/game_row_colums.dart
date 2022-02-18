import 'package:flutter/material.dart';

class LudoRow extends StatelessWidget {
  final int row;
  final List<GlobalKey> rowKeys;
  LudoRow(this.row, this.rowKeys);

  List<Flexible> _getColumns() {
    List<Flexible> _columns = [];
    for (var i = 0; i < 15; i++) {
      _columns.add(Flexible(
          key: rowKeys[i],
          child: AspectRatio(
            aspectRatio: 1 / 1,
            child: Container(),
          )));
    }
    return _columns;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [..._getColumns()],
    );
  }
}
