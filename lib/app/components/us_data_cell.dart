import 'package:erps/app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

DataCell usDataCell(dynamic value, ColumnType columnType) {
  if (columnType == ColumnType.gSmallDate) {
    return DataCell(SelectableText(DateFormat(fDateSmall).format(value)));
  } else if (columnType == ColumnType.gFullDate) {
    return DataCell(SelectableText(DateFormat(fDateFull).format(value)));
  } else if (columnType == ColumnType.gIntNum) {
    return DataCell(SelectableText(NumberFormat(fIntNum).format(value)));
  } else if (columnType == ColumnType.gBoolean) {
    return DataCell(Checkbox(
      value: value,
      onChanged: (bool? value) {},
    ));
  } else if (columnType == ColumnType.gReal1Num) {
    return DataCell(SelectableText(NumberFormat(fReal1Num).format(value)));
  } else if (columnType == ColumnType.gReal2Num) {
    return DataCell(SelectableText(NumberFormat(fReal2Num).format(value)));
  } else if (columnType == ColumnType.gReal3Num) {
    return DataCell(SelectableText(NumberFormat(fReal3Num).format(value)));
  } else if (columnType == ColumnType.gReal4Num) {
    return DataCell(SelectableText(NumberFormat(fReal4Num).format(value)));
  } else if (columnType == ColumnType.gReal5Num) {
    return DataCell(SelectableText(NumberFormat(fReal5Num).format(value)));
  } else if (columnType == ColumnType.gReal6Num) {
    return DataCell(SelectableText(NumberFormat(fReal6Num).format(value)));
  } else if (columnType == ColumnType.gDateMonth) {
    return DataCell(SelectableText(DateFormat(fDateMonth).format(value)));
  } else if (columnType == ColumnType.gDateMonthYear) {
    return DataCell(SelectableText(DateFormat(fDateMonthYear).format(value)));
  }
  return DataCell(SelectableText(value.toString()));
}
