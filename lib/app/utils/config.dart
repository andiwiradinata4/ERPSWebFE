import 'package:flutter/material.dart';

const primaryColor = Color.fromRGBO(0, 117, 230, 1);
const bodyColor = Color.fromRGBO(0, 0, 0, 1);
const bgColor = Colors.white;
const bgPrimary = Color.fromRGBO(222, 229, 243, 1);
const bgError = Color.fromRGBO(220, 35, 35, 1);
const bgSuccess = Color.fromRGBO(25, 135, 84, 1);

const defaultPadding = 16.0;

enum ColumnType {
  gString,
  gSmallDate,
  gFullDate,
  gIntNum,
  gBoolean,
  gReal1Num,
  gReal2Num,
  gReal3Num,
  gReal4Num,
  gReal5Num,
  gReal6Num,
  gDateMonth,
  gDateMonthYear
}

const fDateFull = "dd/MM/yyyy HH:mm:ss";
const fDateSmall = "dd/MM/yyyy";
const fDateMonth = "MMMM";
const fDateMonthYear = "MMMM yyyy";
const fReal1Num = "#,##0.0";
const fReal2Num = "#,##0.00";
const fReal3Num = "#,##0.000";
const fReal4Num = "#,##0.0000";
const fReal5Num = "#,##0.00000";
const fReal6Num = "#,##0.000000";
const fIntNum = "#,##0";
