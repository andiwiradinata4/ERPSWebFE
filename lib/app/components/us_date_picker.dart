import 'dart:developer';

import 'package:flutter/material.dart';

class UsDatePicker extends StatefulWidget {
  final TextEditingController usController;
  final String fieldName;
  final Function(String?) validateValue;
  final bool readOnly;
  final bool useSuffixIcon;
  final IconData? activeSuffixIcon;
  final IconData? deActiveSuffixIcon;
  final bool isPasswordHandle;
  final String hintText;
  final bool autoFocus;
  final Function(String?)? onFieldSubmitted;

  const UsDatePicker(
      {super.key,
      required this.usController,
      required this.fieldName,
      required this.validateValue,
      this.readOnly = false,
      this.useSuffixIcon = false,
      this.activeSuffixIcon,
      this.deActiveSuffixIcon,
      this.isPasswordHandle = false,
      this.hintText = '',
      this.autoFocus = false,
      this.onFieldSubmitted});

  @override
  State<UsDatePicker> createState() => _UsDatePickerState();
}

class _UsDatePickerState extends State<UsDatePicker> {
  bool isActive = false;
  bool obscureText = false;

  @override
  void initState() {
    super.initState();
    (widget.isPasswordHandle) ? obscureText = true : obscureText = false;
  }

  Future<void> _selectDate(BuildContext context, DateTime selectedDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year - 200, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != selectedDate) {
      if (mounted) {
        setState(() {
          selectedDate = picked;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.usController,
      keyboardType: TextInputType.datetime,
      readOnly: widget.readOnly,
      cursorColor: Theme.of(context).primaryColor,
      obscureText: obscureText,
      autofocus: widget.autoFocus,
      onFieldSubmitted: widget.onFieldSubmitted,
      decoration: InputDecoration(
          label: Text(widget.fieldName),
          hintText: widget.hintText,
          focusedBorder: defaultOutlineInputBorder(),
          enabledBorder: defaultOutlineInputBorder(),
          errorBorder: defaultOutlineInputBorder(),
          focusedErrorBorder: defaultOutlineInputBorder(),
          contentPadding:
              const EdgeInsets.only(left: 30, right: 10, top: 13, bottom: 13),
          suffixIcon: GestureDetector(
            onTap: () {
              log('Test Date');
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Icon(
                Icons.calendar_month,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )),
      validator: (String? value) => widget.validateValue(value),
      onTap: () => _selectDate(context, DateTime(2000)),
    );
  }
}

OutlineInputBorder defaultOutlineInputBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Color.fromRGBO(0, 117, 230, 1)));
