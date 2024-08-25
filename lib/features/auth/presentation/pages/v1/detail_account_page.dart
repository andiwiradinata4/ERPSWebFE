import 'package:erps/core/utils/email_util.dart';
import 'package:erps/features/auth/domain/entities/v1/register_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../../app/components/us_date_picker.dart';
import '../../../../../app/components/us_dialog_builder.dart';
import '../../../../../app/components/us_snack_bar_builder.dart';
import '../../../../../app/components/us_text_form_field.dart';
import '../../../../../core/config/constants.dart';
import '../../../../../core/config/responsive.dart';
import '../../../../../core/config/size_config.dart';
import '../../../../../routes/v1.dart';
import '../../../data/models/user.dart';
import '../../bloc/v1/auth_bloc.dart';

class DetailAccountPage extends StatelessWidget {
  final String id;

  const DetailAccountPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Responsive(
      desktop: Desktop(id: id),
      tablet: Desktop(id: id),
      mobile: Desktop(id: id),
    );
  }
}

class Desktop extends StatefulWidget {
  final String id;

  const Desktop({super.key, required this.id});

  @override
  State<Desktop> createState() => _DesktopState();
}

class _DesktopState extends State<Desktop> {
  late AuthBloc authBloc;

  /// Fields
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();
  DateTime birthDate = DateTime(DateTime.now().year);
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();

  @override
  void initState() {
    authBloc = context.read<AuthBloc>();
    if (widget.id.isNotEmpty) {
      authBloc.add(GetDetailEvent(id: widget.id.trim()));
    }
    super.initState();
  }

  void getDetail(User data) {
    firstNameController.text = data.firstName;
    lastNameController.text = data.lastName;
    birthDate = data.birthDate;
    birthDateController.text = DateFormat(fDateSmall).format(birthDate);
    usernameController.text = data.userName;
    emailController.text = data.email;
    phoneNumberController.text = data.phoneNumber;
  }

  void save() async {
    if (!formKey.currentState!.validate()) return;
    if (await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => LoadConfirmDialog(
            title: 'Pertanyaan',
            asset: '',
            message: 'Simpan Data ?',
            repeat: false,
            showButton: true,
            width: 100,
          ),
        ) ==
        false) return;
    if (widget.id.isEmpty) {
      authBloc.add(RegisterEvent(
          data: RegisterEntity(
              userName: usernameController.text.trim(),
              password: passwordController.text.trim(),
              firstName: firstNameController.text.trim(),
              lastName: lastNameController.text.trim(),
              email: emailController.text.trim(),
              phoneNumber: phoneNumberController.text.trim(),
              birthDate: birthDate)));
    }
  }

  void delete() async {
    if (await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) => LoadConfirmDialog(
            title: 'Pertanyaan',
            asset: '',
            message: 'Anda yakin ingin menghapus data ini ?',
            repeat: false,
            showButton: true,
            width: 100,
          ),
        ) ==
        false) return;

    authBloc.add(DeleteEvent(id: widget.id));
  }

  void close() => context.goNamed(routeNameListAccountPage);

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previousState, state) {
        if (previousState is LoginLoadingState) {
          UsDialogBuilder.dispose();
        }
        return true;
      },
      listener: (context, state) {
        if (state is LoginErrorState) {
          Future.delayed(Duration.zero, () {
            UsSnackBarBuilder.showErrorSnackBar(context, state.message);
          });
        } else if (state is LoginLoadingState) {
          Future.delayed(
              Duration.zero, () => UsDialogBuilder.loadLoadingDialog(context));
        } else if (state is GetDetailErrorState) {
          Future.delayed(Duration.zero, () {
            UsSnackBarBuilder.showErrorSnackBar(context, state.message);
          });
        } else if (state is GetDetailSuccessState) {
          if (mounted) {
            setState(() {
              getDetail(state.data);
            });
          }
        } else if (state is RegisterSuccessState) {
          Future.delayed(Duration.zero, () {
            UsSnackBarBuilder.showSuccessSnackBar(
                context, 'Data berhasil disimpan.');
          });
          Future.delayed(const Duration(seconds: 1), () => close());
        } else if (state is RegisterErrorState) {
          Future.delayed(Duration.zero, () {
            UsSnackBarBuilder.showErrorSnackBar(context, state.message);
          });
        } else if (state is DeleteSuccessState) {
          Future.delayed(Duration.zero, () {
            UsSnackBarBuilder.showSuccessSnackBar(
                context, 'Data berhasil dihapus.');
          });
          Future.delayed(const Duration(seconds: 1), () => close());
        } else if (state is DeleteErrorState) {
          Future.delayed(Duration.zero, () {
            UsSnackBarBuilder.showErrorSnackBar(context, state.message);
          });
        }
      },
      child: SizedBox(
        width: SizeConfig.screenWidth * 0.8,
        height: SizeConfig.screenHeight,
        child: SafeArea(
            child: Form(
          key: formKey,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.id.isEmpty ? 'Register' : 'Detail'} User',
                            style: TextStyle(
                                fontSize:
                                    (Responsive.isDesktop(context)) ? 35 : 20,
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
                                    Icons.save,
                                    size: 20,
                                  ),
                                  label: const Text(
                                    'Simpan',
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  onPressed: save,
                                ),
                              ),
                              Container(
                                height: 38,
                                alignment: Alignment.center,
                                padding: const EdgeInsets.only(left: 9),
                                child: OutlinedButton.icon(
                                  icon: Icon(Icons.close,
                                      size: 20,
                                      color: Theme.of(context).primaryColor),
                                  label: Text(
                                    'Tutup',
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Theme.of(context).primaryColor),
                                  ),
                                  onPressed: close,
                                ),
                              ),
                              (widget.id.isEmpty)
                                  ? const SizedBox()
                                  : Container(
                                      height: 38,
                                      alignment: Alignment.center,
                                      padding: const EdgeInsets.only(left: 9),
                                      child: ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: bgError),
                                        icon: const Icon(
                                            Icons.delete_outline_rounded,
                                            size: 20),
                                        label: const Text(
                                          'Hapus',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                        onPressed: delete,
                                      ),
                                    ),
                              const SizedBox(
                                width: 18,
                              )
                            ],
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),

              /// Body
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
                          birthDate = DateFormat(fDateSmall)
                                  .tryParse(birthDateController.text.trim()) ??
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

              (widget.id.isEmpty)
                  ? Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        children: [
                          /// Password
                          Expanded(
                            child: UsTextFormField(
                              fieldName: 'Password',
                              usController: passwordController,
                              textInputType: TextInputType.text,
                              useSuffixIcon: true,
                              activeSuffixIcon: Icons.visibility_outlined,
                              deActiveSuffixIcon: Icons.visibility_off_outlined,
                              isPasswordHandle: true,
                              validateValue: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan password terlebih dahulu';
                                } else if (value !=
                                    confirmPasswordController.text.trim()) {
                                  return 'Password dan konfirmasi password tidak sama';
                                }

                                return null;
                              },
                            ),
                          ),

                          const SizedBox(
                            width: 18,
                          ),

                          /// Confirm Password
                          Expanded(
                            child: UsTextFormField(
                              fieldName: 'Konfirmasi Password',
                              usController: confirmPasswordController,
                              textInputType: TextInputType.text,
                              useSuffixIcon: true,
                              activeSuffixIcon: Icons.visibility_outlined,
                              deActiveSuffixIcon: Icons.visibility_off_outlined,
                              isPasswordHandle: true,
                              validateValue: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Masukan konfirmasi password terlebih dahulu';
                                } else if (value !=
                                    passwordController.text.trim()) {
                                  return 'Password dan konfirmasi password tidak sama';
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
                    )
                  : const SizedBox(),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    /// Email
                    Expanded(
                      child: UsTextFormField(
                        fieldName: 'Email',
                        usController: emailController,
                        textInputType: TextInputType.emailAddress,
                        validateValue: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukan email terlebih dahulu';
                          } else if (!EmailUtil().isValidEmail(value.trim())) {
                            return 'Email tidak valid';
                          }
                          return null;
                        },
                      ),
                    ),

                    const SizedBox(
                      width: 18,
                    ),

                    /// Phone Number
                    Expanded(
                      child: UsTextFormField(
                        fieldName: 'Nomor Telepon',
                        usController: phoneNumberController,
                        textInputType: TextInputType.number,
                        validateValue: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukan nomor telepon terlebih dahulu';
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
        )),
      ),
    );
  }
}
