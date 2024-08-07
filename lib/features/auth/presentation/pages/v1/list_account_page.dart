import 'dart:developer';

import 'package:erps/app/components/us_data_cell.dart';
import 'package:erps/app/components/us_dialog_builder.dart';
import 'package:erps/app/components/us_snackbar_builder.dart';
import 'package:erps/app/utils/config.dart';
import 'package:erps/core/config/responsive.dart';
import 'package:erps/core/config/size_config.dart';
import 'package:erps/core/models/pagination.dart';
import 'package:erps/features/auth/data/models/user.dart';
import 'package:erps/features/auth/presentation/bloc/v1/auth_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
  List<User> data = [];
  PerPageValue selectedPerPageValue = initPerPageValue();

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    authBloc.add(ListDataEvent());
    horizontalController = ScrollController();
    verticalController = ScrollController();
    super.initState();
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
    data = [];
    authBloc.add(ListDataEvent());
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
              data += state.data;
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
                              fontSize: (Responsive.isDesktop(context)) ? 20 : 20, fontWeight: FontWeight.w700),
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
                                onPressed: () {},
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
                    width: (Responsive.isDesktop(context) ) ? SizeConfig.screenWidth * 0.4 : SizeConfig.screenWidth * 0.2,
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
                        rows: data.map((e) => setDataRow(e)).toList(),
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
                  IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.arrow_back_ios_rounded,
                        color: Theme.of(context).primaryColor.withOpacity(0.8),
                      )),
                  const Text('1 - 100'),
                  IconButton(
                      onPressed: () {},
                      icon: Icon(Icons.arrow_forward_ios_rounded,
                          color:
                              Theme.of(context).primaryColor.withOpacity(0.8))),
                  Padding(
                    padding: const EdgeInsets.only(left: 9.0),
                    child: DropdownButton<PerPageValue>(
                      style: Theme.of(context).textTheme.labelLarge,
                      value: selectedPerPageValue,
                      items: dataPerPageValue()
                          .map<DropdownMenuItem<PerPageValue>>(
                              (PerPageValue value) {
                        return DropdownMenuItem<PerPageValue>(
                          value: value,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 9.0),
                            child: Text(value.label),
                          ),
                        );
                      }).toList(),
                      onChanged: (PerPageValue? value) {
                        if (mounted) {
                          setState(() {
                            selectedPerPageValue = value!;
                          });
                        }
                      },
                    ),
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

//
// class Desktop extends StatefulWidget {
//   const Desktop({super.key});
//
//   @override
//   State<Desktop> createState() => _DesktopState();
// }
//
// class _DesktopState extends State<Desktop> {
//   final MyData dataSource = MyData()..setData(episodes, 0, true);
//   final defaultRowPerPage = 10;
//   int _columnIndex = 0;
//   bool _columnAscending = true;
//   int rowPerPage = 10;
//   final ScrollController horizontalController = ScrollController();
//
//   void _sort(int columnIndex, bool ascending) {
//     setState(() {
//       _columnIndex = columnIndex;
//       _columnAscending = ascending;
//       dataSource.setData(episodes, _columnIndex, _columnAscending);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: [
//         SizedBox(
//           height: SizeConfig.screenHeight * 0.15,
//           child: const Center(child: Text("Title, Action Button, Search Bar and Navigation Back")),
//         ),
//         Scrollbar(
//           thumbVisibility: true,
//           trackVisibility: false,
//           controller: horizontalController,
//           child: SingleChildScrollView(
//             controller: horizontalController,
//             scrollDirection: Axis.horizontal,
//             child: SizedBox(
//               width: SizeConfig.screenWidth * 0.83,
//               child: PaginatedDataTable(
//                 // header: Row(
//                 //   children: [
//                 //     SvgPicture.asset(
//                 //       'lib/assets/svg/people_black.svg',
//                 //     ),
//                 //     const SizedBox(width: 30,),
//                 //     const Text('List Account'),
//                 //   ],
//                 // ),
//                 sortColumnIndex: _columnIndex,
//                 sortAscending: _columnAscending,
//                 showEmptyRows: false,
//                 // actions: [
//                 //   ElevatedButton.icon(
//                 //     icon: SvgPicture.asset('lib/assets/svg/add_white.svg'),
//                 //     label: const Text('Add'),
//                 //     onPressed: () {},
//                 //   ),
//                 //   ElevatedButton.icon(
//                 //     icon: SvgPicture.asset('lib/assets/svg/refresh_white.svg'),
//                 //     label: const Text('Refresh'),
//                 //     onPressed: () {},
//                 //   )
//                 // ],
//                 onPageChanged: (int index) {
//                   log(index.toString());
//                 },
//                 availableRowsPerPage: [10, 15, dataSource.totalRow()],
//                 onRowsPerPageChanged: (int? index) {
//                   log(index.toString());
//                   setState(() {
//                     rowPerPage = index!;
//                   });
//                 },
//                 rowsPerPage: rowPerPage,
//                 columns: [
//                   DataColumn(
//                     label: const Text('Episode'),
//                     onSort: _sort,
//                   ),
//                   DataColumn(
//                     label: const Text('Title'),
//                     onSort: _sort,
//                   ),
//                   DataColumn(
//                     label: const Text('Director'),
//                     onSort: _sort,
//                   ),
//                   DataColumn(
//                     label: const Text('Writer(s)'),
//                     onSort: _sort,
//                   ),
//                   DataColumn(
//                     label: const Text('Air Date'),
//                     onSort: _sort,
//                   ),
//                 ],
//                 source: dataSource,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//     // return DataTable(columns: const [
//     //   DataColumn(label: Text('First Name')),
//     //   DataColumn(label: Text('Last Name')),
//     //   DataColumn(label: Text('Birth Date')),
//     //   DataColumn(label: Text('User Name')),
//     //   DataColumn(label: Text('Email')),
//     //   DataColumn(label: Text('Email Confirmed')),
//     //   DataColumn(label: Text('Phone Number')),
//     //   DataColumn(label: Text('Phone Number Confirmed'))
//     // ], rows: const []);
//   }
// }
//
// class MyData extends DataTableSource {
//   static const List<int> _displayIndexToRawIndex = <int>[0, 3, 4, 5, 6];
//
//   late List<List<Comparable<Object>>> sortedData;
//
//   void setData(List<List<Comparable<Object>>> rawData, int sortColumn,
//       bool sortAscending) {
//     sortedData = rawData.toList()
//       ..sort((List<Comparable<Object>> a, List<Comparable<Object>> b) {
//         final Comparable<Object> cellA = a[_displayIndexToRawIndex[sortColumn]];
//         final Comparable<Object> cellB = b[_displayIndexToRawIndex[sortColumn]];
//         return cellA.compareTo(cellB) * (sortAscending ? 1 : -1);
//       });
//     notifyListeners();
//   }
//
//   int totalRow() => episodes.length;
//
//   @override
//   int get rowCount => sortedData.length;
//
//   static DataCell cellFor(Object data) {
//     String value;
//     if (data is DateTime) {
//       value =
//           '${data.year}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}';
//     } else {
//       value = data.toString();
//     }
//     return DataCell(Text(value));
//   }
//
//   @override
//   DataRow? getRow(int index) {
//     return DataRow.byIndex(
//       index: sortedData[index][0] as int,
//       cells: <DataCell>[
//         cellFor(
//             'S${sortedData[index][1]}E${sortedData[index][2].toString().padLeft(2, '0')}'),
//         cellFor(sortedData[index][3]),
//         cellFor(sortedData[index][4]),
//         cellFor(sortedData[index][5]),
//         cellFor(sortedData[index][6]),
//       ],
//     );
//   }
//
//   @override
//   bool get isRowCountApproximate => false;
//
//   @override
//   int get selectedRowCount => 0;
// }
//
// final List<List<Comparable<Object>>> episodes = <List<Comparable<Object>>>[
//   <Comparable<Object>>[
//     1,
//     1,
//     1,
//     'Strange New Worlds',
//     'Akiva Goldsman',
//     'Akiva Goldsman, Alex Kurtzman, Jenny Lumet',
//     DateTime(2022, 5, 5),
//   ],
//   <Comparable<Object>>[
//     2,
//     1,
//     2,
//     'Children of the Comet',
//     'Maja Vrvilo',
//     'Henry Alonso Myers, Sarah Tarkoff',
//     DateTime(2022, 5, 12),
//   ],
//   <Comparable<Object>>[
//     3,
//     1,
//     3,
//     'Ghosts of Illyria',
//     'Leslie Hope',
//     'Akela Cooper, Bill Wolkoff',
//     DateTime(2022, 5, 19),
//   ],
//   <Comparable<Object>>[
//     4,
//     1,
//     4,
//     'Memento Mori',
//     'Dan Liu',
//     'Davy Perez, Beau DeMayo',
//     DateTime(2022, 5, 26),
//   ],
//   <Comparable<Object>>[
//     5,
//     1,
//     5,
//     'Spock Amok',
//     'Rachel Leiterman',
//     'Henry Alonso Myers, Robin Wasserman',
//     DateTime(2022, 6, 2),
//   ],
//   <Comparable<Object>>[
//     6,
//     1,
//     6,
//     'Lift Us Where Suffering Cannot Reach',
//     'Andi Armaganian',
//     'Robin Wasserman, Bill Wolkoff',
//     DateTime(2022, 6, 9),
//   ],
//   <Comparable<Object>>[
//     7,
//     1,
//     7,
//     'The Serene Squall',
//     'Sydney Freeland',
//     'Beau DeMayo, Sarah Tarkoff',
//     DateTime(2022, 6, 16),
//   ],
//   <Comparable<Object>>[
//     8,
//     1,
//     8,
//     'The Elysian Kingdom',
//     'Amanda Row',
//     'Akela Cooper, Onitra Johnson',
//     DateTime(2022, 6, 23),
//   ],
//   <Comparable<Object>>[
//     9,
//     1,
//     9,
//     'All Those Who Wander',
//     'Christopher J. Byrne',
//     'Davy Perez',
//     DateTime(2022, 6, 30),
//   ],
//   <Comparable<Object>>[
//     10,
//     2,
//     10,
//     'A Quality of Mercy',
//     'Chris Fisher',
//     'Henry Alonso Myers, Akiva Goldsman',
//     DateTime(2022, 7, 7),
//   ],
//   <Comparable<Object>>[
//     11,
//     2,
//     1,
//     'The Broken Circle',
//     'Chris Fisher',
//     'Henry Alonso Myers, Akiva Goldsman',
//     DateTime(2023, 6, 15),
//   ],
//   <Comparable<Object>>[
//     12,
//     2,
//     2,
//     'Ad Astra per Aspera',
//     'Valerie Weiss',
//     'Dana Horgan',
//     DateTime(2023, 6, 22),
//   ],
//   <Comparable<Object>>[
//     13,
//     2,
//     3,
//     'Tomorrow and Tomorrow and Tomorrow',
//     'Amanda Row',
//     'David Reed',
//     DateTime(2023, 6, 29),
//   ],
//   <Comparable<Object>>[
//     14,
//     2,
//     4,
//     'Among the Lotus Eaters',
//     'Eduardo SÃ¡nchez',
//     'Kirsten Beyer, Davy Perez',
//     DateTime(2023, 7, 6),
//   ],
//   <Comparable<Object>>[
//     15,
//     2,
//     5,
//     'Charades',
//     'Jordan Canning',
//     'Kathryn Lyn, Henry Alonso Myers',
//     DateTime(2023, 7, 13),
//   ],
//   <Comparable<Object>>[
//     16,
//     2,
//     6,
//     'Lost in Translation',
//     'Dan Liu',
//     'Onitra Johnson, David Reed',
//     DateTime(2023, 7, 20),
//   ],
//   <Comparable<Object>>[
//     17,
//     2,
//     7,
//     'Those Old Scientists',
//     'Jonathan Frakes',
//     'Kathryn Lyn, Bill Wolkoff',
//     DateTime(2023, 7, 22),
//   ],
//   <Comparable<Object>>[
//     18,
//     2,
//     8,
//     'Under the Cloak of War',
//     '',
//     'Davy Perez',
//     DateTime(2023, 7, 27),
//   ],
//   <Comparable<Object>>[
//     19,
//     2,
//     9,
//     'Subspace Rhapsody',
//     '',
//     'Dana Horgan, Bill Wolkoff',
//     DateTime(2023, 8, 3),
//   ],
//   <Comparable<Object>>[
//     20,
//     2,
//     10,
//     'Hegemony',
//     '',
//     'Henry Alonso Myers',
//     DateTime(2023, 8, 10),
//   ]
// ];
