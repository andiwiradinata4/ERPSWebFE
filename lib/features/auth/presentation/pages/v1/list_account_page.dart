import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../app/components/us_data_cell.dart';
import '../../../../../app/components/us_date_picker.dart';
import '../../../../../app/components/us_dialog_builder.dart';
import '../../../../../app/components/us_snack_bar_builder.dart';
import '../../../../../app/components/us_text_form_field.dart';
import '../../../../../core/config/constants.dart';
import '../../../../../core/config/responsive.dart';
import '../../../../../core/config/size_config.dart';
import '../../../../../core/models/data_column.dart';
import '../../../../../core/models/pagination.dart';
import '../../../../../routes/v1.dart';
import '../../../data/models/user.dart';
import '../../bloc/v1/auth_bloc.dart';

class ListAccountPage extends StatelessWidget {
  const ListAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return const Responsive(
      desktop: Desktop(),
      mobile: Desktop(),
      tablet: Desktop(),
    );
  }
}

class Desktop extends StatefulWidget {
  const Desktop({super.key});

  @override
  State<Desktop> createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  late AuthBloc authBloc;
  late ScrollController horizontalController, verticalController;

  Pagination<User> data = Pagination();
  PerPageValue selectedPerPageValue = initPerPageValue();
  Map<String, String> queries = {};
  int page = 1;
  int perPage = 10;
  int startAmount = 1;
  int endAmount = 10;
  int count = 0;
  int totalPage = 0;

  /// Fields
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  DateTime birthDate = DateTime(DateTime.now().year);
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  List<UsDataColumn> allColumns() => [
        UsDataColumn(label: '#', name: '#', columnType: ColumnType.gString),
        UsDataColumn(
            label: 'Nama Depan',
            name: 'FirstName',
            columnType: ColumnType.gString),
        UsDataColumn(
            label: 'Nama Belakang',
            name: 'LastName',
            columnType: ColumnType.gString),
        UsDataColumn(
            label: 'Tanggal Lahir',
            name: 'BirthDate',
            columnType: ColumnType.gSmallDate),
        UsDataColumn(
            label: 'Username',
            name: 'UserName',
            columnType: ColumnType.gString),
        UsDataColumn(
            label: 'Normalized Username',
            name: 'NormalizedUserName',
            columnType: ColumnType.gString),
        UsDataColumn(
            label: 'Email', name: 'Email', columnType: ColumnType.gString),
        UsDataColumn(
            label: 'Normalized Email',
            name: 'NormalizedEmail',
            columnType: ColumnType.gString),
        UsDataColumn(
            label: 'Verifikasi Email?',
            name: 'EmailConfirmed',
            columnType: ColumnType.gBoolean),
        UsDataColumn(
            label: 'Phone Number',
            name: 'PhoneNumber',
            columnType: ColumnType.gString),
      ];

  @override
  void initState() {
    perPage = selectedPerPageValue.pageValue;
    setQueries();

    authBloc = context.read<AuthBloc>();
    authBloc.add(ListDataEvent(queries: queries));
    horizontalController = ScrollController();
    verticalController = ScrollController();
    super.initState();
  }

  void setQueries() {
    queries['Page'] = page.toString();
    queries['PageSize'] = perPage.toString();
  }

  List<Widget> setActionRowButton(User data) => [
        IconButton(
            iconSize: 18,
            onPressed: () => detailData(data.id),
            tooltip: 'Lihat',
            icon: Icon(
              Icons.app_registration_outlined,
              color: Theme.of(context).primaryColor,
            )),
      ];

  List<DataRow> allRows(Pagination<User> data) {
    if (data.jsonResults == null) return [];
    return data.jsonResults!.map((e) {
      List<DataCell> allCells = [];
      allCells.addAll(allColumns()
          .map((col) => (col.name == "#")
              ? DataCell(Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: setActionRowButton(
                      data.results.elementAt(data.jsonResults!.indexOf(e))),
                ))
              : usDataCell(e[col.name], col.columnType))
          .toList());
      return DataRow(cells: allCells);
    }).toList();
  }

  void refresh() {
    data.results = [];
    authBloc.add(ListDataEvent(queries: queries));
  }

  void refreshRange() {
    if (page == 1) {
      startAmount = 1;
      if (selectedPerPageValue.label == "All") {
        endAmount = count;
      } else {
        endAmount = perPage;
      }
    } else {
      startAmount = ((page - 1) * perPage) + 1;
      if (selectedPerPageValue.label == "All") {
        endAmount = count;
      } else {
        endAmount = startAmount + perPage;
      }
    }
  }

  void detailData(String id) =>
      context.goNamed(routeNameDetailAccountPage, extra: {'id': id});

  Future _showSearchDialogBuilder(BuildContext context, String title) {
    Map<String, dynamic> selectedFilter = {};
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            scrollable: true,
            content: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      /// First Name
                      Expanded(
                        child: UsTextFormField(
                          fieldName: 'Nama Depan',
                          usController: firstNameController,
                          textInputType: TextInputType.text,
                          validateValue: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan nama depan terlebih dahulu';
                            }

                            return null;
                          },
                        ),
                      ),

                      const SizedBox(
                        width: 18,
                      ),

                      /// Last Name
                      Expanded(
                        child: UsTextFormField(
                          fieldName: 'Nama Belakang',
                          usController: lastNameController,
                          textInputType: TextInputType.text,
                          validateValue: (String? value) {
                            // if (value == null || value.isEmpty) {
                            //   return 'Masukan nama belakang terlebih dahulu';
                            // }

                            return null;
                          },
                        ),
                      ),

                      const SizedBox(
                        width: 18,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: [
                      /// Birth Date
                      Expanded(
                        child: UsDatePicker(
                          value: birthDate,
                          fieldName: 'Tanggal Lahir',
                          usController: birthDateController,
                          readOnly: true,
                          validateValue: (String? value) {
                            birthDate = DateFormat(fDateSmall).tryParse(
                                    birthDateController.text.trim()) ??
                                DateTime.now();
                            if (value == null || value.isEmpty) {
                              return 'Masukan tanggal lahir terlebih dahulu';
                            } else if (DateTime.now().year - birthDate.year <=
                                10) {
                              return 'Usia harus lebih besar dari 10 tahun';
                            }

                            return null;
                          },
                        ),
                      ),

                      const SizedBox(
                        width: 18,
                      ),

                      /// Username
                      Expanded(
                        child: UsTextFormField(
                          fieldName: 'Username',
                          usController: usernameController,
                          textInputType: TextInputType.text,
                          validateValue: (String? value) {
                            if (value == null || value.isEmpty) {
                              return 'Masukan username terlebih dahulu';
                            }

                            return null;
                          },
                        ),
                      ),

                      const SizedBox(
                        width: 18,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  selectedFilter['FirstName'] = firstNameController.text.trim();
                  selectedFilter['LastName'] = lastNameController.text.trim();
                  selectedFilter['UserName'] = usernameController.text.trim();
                  context.pop(selectedFilter);
                },
                child: const Text('Lanjut'),
              ),
              TextButton(
                onPressed: () => context.pop(selectedFilter),
                child: const Text('Kembali'),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previousState, state) {
        if (previousState is LoginLoadingState) {
          UsDialogBuilder.dispose();
        }
        return true;
      },
      listener: ((context, state) {
        if (state is LoginErrorState) {
          Future.delayed(Duration.zero, () {
            UsSnackBarBuilder.showErrorSnackBar(context, state.message);
          });
        } else if (state is LoginLoadingState) {
          Future.delayed(
              Duration.zero, () => UsDialogBuilder.loadLoadingDialog(context));
        } else if (state is ListDataErrorState) {
          Future.delayed(Duration.zero, () {
            UsSnackBarBuilder.showErrorSnackBar(context, state.message);
          });
        } else if (state is ListDataSuccessState) {
          if (mounted) {
            setState(() {
              data = state.data;
              count = state.data.count;
              totalPage = state.data.totalPage;
              refreshRange();
            });
          }
        }
      }),
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Header
            Container(
              alignment: Alignment.bottomLeft,
              height: 80,
              child: Row(
                children: [
                  Text(
                    "List User",
                    style: TextStyle(
                        fontSize: (Responsive.isDesktop(context)) ? 35 : 20,
                        fontWeight: FontWeight.w700),
                  ),
                  Row(
                    children: [
                      Container(
                        height: 38,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 18),
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.add,
                            size: 20,
                          ),
                          label: const Text(
                            'Baru',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: () => detailData(''),
                        ),
                      ),
                      Container(
                        height: 38,
                        alignment: Alignment.center,
                        padding: const EdgeInsets.only(left: 9),
                        child: ElevatedButton.icon(
                          icon: const Icon(
                            Icons.refresh,
                            size: 20,
                          ),
                          label: const Text(
                            'Refresh',
                            style: TextStyle(fontSize: 15),
                          ),
                          onPressed: refresh,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            /// Search Bar
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 18, top: 8),
              child: Tooltip(
                message: "Cari / Filter Data",
                child: InkWell(
                  onTap: () async {
                    var value = await _showSearchDialogBuilder(
                        context, "Cari / Filter Data");
                    if (value == null)
                      {
                        log('NULL');
                      }
                    else
                      {
                        if (value is Map)
                          {
                            log(value.keys.map((e) => '$e -> ${value[e]}').toList().join(','));
                          }
                      }
                  },
                  borderRadius: BorderRadius.circular(18),
                  splashColor: Theme.of(context).primaryColor.withOpacity(0.2),
                  child: Container(
                      width: 120,
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Theme.of(context).primaryColor),
                          borderRadius: BorderRadius.circular(18)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(
                            width: 8,
                          ),
                          const Text('Cari'),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.search))
                        ],
                      )),
                ),
              ),
            ),

            /// Body
            SizedBox(
              width: SizeConfig.screenWidth * 0.85,
              height: SizeConfig.screenHeight * 0.8,
              child: Scrollbar(
                thumbVisibility: true,
                trackVisibility: false,
                controller: horizontalController,
                child: SingleChildScrollView(
                  controller: horizontalController,
                  scrollDirection: Axis.horizontal,
                  child: Scrollbar(
                    thumbVisibility: true,
                    trackVisibility: false,
                    controller: verticalController,
                    child: SingleChildScrollView(
                      controller: verticalController,
                      scrollDirection: Axis.vertical,
                      child: DataTable(
                        columns: allColumns()
                            .map((e) => DataColumn(
                                  label: Expanded(
                                      child: SelectableText(e.label,
                                          style: TextStyle(
                                              color: Theme.of(context)
                                                  .primaryColor,
                                              fontWeight: FontWeight.bold))),
                                ))
                            .toList(),
                        rows: allRows(data),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            /// Footer
            SizedBox(
              height: SizeConfig.screenHeight * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Page $page'),
                  IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      onPressed: (page == 1)
                          ? null
                          : () {
                              page--;
                              setQueries();
                              refresh();
                              refreshRange();
                            },
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: (page == 1)
                            ? Colors.grey
                            : Theme.of(context).primaryColor.withOpacity(0.8),
                      )),
                  Text('$startAmount - $endAmount'),
                  IconButton(
                      padding: const EdgeInsets.symmetric(horizontal: 9),
                      onPressed: (page == totalPage)
                          ? null
                          : () {
                              page++;
                              setQueries();
                              refresh();
                              refreshRange();
                            },
                      icon: Icon(Icons.arrow_forward_ios_rounded,
                          color: (page == totalPage)
                              ? Colors.grey
                              : Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.8))),
                  DropdownButton<PerPageValue>(
                    style: Theme.of(context).textTheme.labelLarge,
                    value: selectedPerPageValue,
                    items: dataPerPageValue()
                        .map<DropdownMenuItem<PerPageValue>>(
                            (PerPageValue value) {
                      return DropdownMenuItem<PerPageValue>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 9.0),
                          child: Text(value.label),
                        ),
                      );
                    }).toList(),
                    onChanged: (PerPageValue? value) {
                      selectedPerPageValue = value!;
                      perPage = selectedPerPageValue.pageValue;
                      if (selectedPerPageValue.label == 'All') {
                        page = 1;
                        queries['Page'] = '0';
                      } else {
                        refreshRange();
                        setQueries();
                      }
                      refresh();
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
