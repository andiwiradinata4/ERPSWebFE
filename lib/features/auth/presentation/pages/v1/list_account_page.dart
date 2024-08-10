import 'dart:developer';

import 'package:erps/app/components/us_data_cell.dart';
import 'package:erps/app/components/us_date_picker.dart';
import 'package:erps/app/components/us_dialog_builder.dart';
import 'package:erps/app/components/us_snackbar_builder.dart';
import 'package:erps/app/components/us_text_form_field.dart';
import 'package:erps/app/utils/config.dart';
import 'package:erps/core/config/responsive.dart';
import 'package:erps/core/config/size_config.dart';
import 'package:erps/core/models/pagination.dart';
import 'package:erps/features/auth/data/models/user.dart';
import 'package:erps/features/auth/presentation/bloc/v1/auth_bloc.dart';
import 'package:erps/routes/v1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

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
  late List<DataColumn> allColumns = [];
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

  List<DataColumn> setDataColumns() => const [
        DataColumn(
          label: Expanded(child: SelectableText('#')),
        ),
        DataColumn(
          label: Expanded(child: SelectableText('First Name')),
        ),
        DataColumn(
          label: Expanded(child: SelectableText('Last Name')),
        ),
        DataColumn(
          label: Expanded(child: SelectableText('Birth Date')),
        ),
        DataColumn(
          label: Expanded(child: SelectableText('Username')),
        ),
        DataColumn(
          label: Expanded(child: SelectableText('Normalized Username')),
        ),
        DataColumn(
          label: Expanded(child: SelectableText('Email')),
        ),
        DataColumn(
          label: Expanded(child: SelectableText('Normalized Email')),
        ),
        DataColumn(
          label: Expanded(child: SelectableText('Email Confirmed')),
        ),
        DataColumn(
          label: Expanded(child: SelectableText('Phone Number')),
        ),
      ];

  List<Widget> setActionRowButton(User data) => [
        IconButton(
            iconSize: 18,
            onPressed: () {
              log('${data.firstName} ${data.lastName} - ${data.userName}');
            },
            tooltip: 'Edit',
            icon: Icon(
              Icons.edit_rounded,
              color: Theme.of(context).primaryColor,
            )),
        IconButton(
            iconSize: 18,
            onPressed: () {},
            tooltip: 'Hapus',
            icon: const Icon(
              Icons.delete,
              color: bgError,
            )),
      ];

  DataRow setDataRow(User e) {
    return DataRow(selected: e.isSelected, cells: [
      DataCell(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: setActionRowButton(e),
      )),
      usDataCell(e.firstName, ColumnType.gString),
      usDataCell(e.lastName, ColumnType.gString),
      usDataCell(e.birthDate, ColumnType.gSmallDate),
      usDataCell(e.userName, ColumnType.gString),
      usDataCell(e.normalizedUsername, ColumnType.gString),
      usDataCell(e.email, ColumnType.gString),
      usDataCell(e.normalizedEmail, ColumnType.gString),
      usDataCell(e.emailConfirmed, ColumnType.gBoolean),
      usDataCell(e.phoneNumber, ColumnType.gString),
    ]);
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

  Future<void> _dialogBuilder(BuildContext context, String id) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text((id == '') ? 'Register' : 'Edit Account'),
          content: SizedBox(
            width: SizeConfig.screenWidth * 0.3,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// First Name
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
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

                  /// Last Name
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: UsTextFormField(
                      fieldName: 'Nama Belakang',
                      usController: lastNameController,
                      textInputType: TextInputType.text,
                      validateValue: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukan nama belakang terlebih dahulu';
                        }

                        return null;
                      },
                    ),
                  ),

                  /// Birth Date
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: UsDatePicker(
                      fieldName: 'Tanggal Lahir',
                      usController: birthDateController,
                      readOnly: true,
                      validateValue: (String? value) {
                        if (value == null || value.isEmpty) {
                          return 'Masukan tanggal lahir terlebih dahulu';
                        }

                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {},
              child: const Text('Simpan'),
            ),
            OutlinedButton(
              child: const Text('Tutup'),
              onPressed: () => context.pop(),
            ),
          ],
        );
      },
    );
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
            SizedBox(
              height: SizeConfig.screenHeight * 0.15,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          "List User",
                          style: TextStyle(
                              fontSize:
                                  (Responsive.isDesktop(context)) ? 35 : 20,
                              fontWeight: FontWeight.w700),
                        ),
                        Row(
                          children: [
                            Container(
                              height: 35,
                              padding: const EdgeInsets.only(left: 18),
                              child: ElevatedButton.icon(
                                icon: SvgPicture.asset(
                                    'lib/assets/svg/new_white.svg'),
                                label: const Text('Baru'),
                                onPressed: () => _dialogBuilder(context, ''),
                              ),
                            ),
                            Container(
                              height: 35,
                              padding: const EdgeInsets.only(left: 9),
                              child: ElevatedButton.icon(
                                icon: SvgPicture.asset(
                                    'lib/assets/svg/refresh_white.svg'),
                                label: const Text('Refresh'),
                                onPressed: refresh,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: (Responsive.isDesktop(context))
                        ? SizeConfig.screenWidth * 0.4
                        : SizeConfig.screenWidth * 0.2,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Search',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (String? value) {
                        log(value ?? 'Search');
                      },
                    ),
                  )
                ],
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
                        columns: setDataColumns(),
                        rows: data.results.map((e) => setDataRow(e)).toList(),
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
