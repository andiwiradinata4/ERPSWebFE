import 'package:erps/app/utils/config.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UsDatePicker extends StatefulWidget {
  final DateTime value;
  final TextEditingController usController;
  final String fieldName;
  final Function(String?) validateValue;
  final bool readOnly;
  final String hintText;
  final bool autoFocus;
  final Function(String?)? onFieldSubmitted;

  const UsDatePicker(
      {super.key,
      required this.value,
      required this.usController,
      required this.fieldName,
      required this.validateValue,
      this.readOnly = false,
      this.hintText = '',
      this.autoFocus = false,
      this.onFieldSubmitted});

  @override
  State<UsDatePicker> createState() => _UsDatePickerState();
}

class _UsDatePickerState extends State<UsDatePicker> {
  Future<void> _selectDate(BuildContext context, DateTime selectedDate) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(DateTime.now().year - 200, 1),
        lastDate: DateTime.now(),
        barrierColor: Theme.of(context).primaryColor.withOpacity(0.1));
    if (picked != null && picked != selectedDate) {
      if (mounted) {
        setState(() {
          selectedDate = picked;
          widget.usController.text =
              DateFormat(fDateSmall).format(selectedDate);
        });
      }
    }
  }

  @override
  void initState() {
    widget.usController.text = DateFormat(fDateSmall).format(widget.value);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.usController,
      keyboardType: TextInputType.datetime,
      readOnly: widget.readOnly,
      cursorColor: Theme.of(context).primaryColor,
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
            onTap: () => _selectDate(context, widget.value),
            child: Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Icon(
                Icons.calendar_month,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )),
      validator: (String? value) => widget.validateValue(value),
      onTap: () => _selectDate(context, widget.value),
    );
  }
}

OutlineInputBorder defaultOutlineInputBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Color.fromRGBO(0, 117, 230, 1)));
