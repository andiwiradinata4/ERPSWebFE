import 'package:flutter/material.dart';

class UsTextFormField extends StatefulWidget {
  final TextEditingController usController;
  final String fieldName;
  final Function(String?) validateValue;
  final TextInputType textInputType;
  final bool readOnly;
  final bool useSuffixIcon;
  final IconData? activeSuffixIcon;
  final IconData? deActiveSuffixIcon;
  final bool isPasswordHandle;
  final String hintText;
  final bool autoFocus;

  const UsTextFormField(
      {super.key,
        required this.usController,
        required this.fieldName,
        required this.validateValue,
        this.textInputType = TextInputType.text,
        this.readOnly = false,
        this.useSuffixIcon = false,
        this.activeSuffixIcon,
        this.deActiveSuffixIcon,
        this.isPasswordHandle = false,
        this.hintText = '',
        this.autoFocus = false});

  @override
  State<UsTextFormField> createState() => _UsTextFormFieldState();
}

class _UsTextFormFieldState extends State<UsTextFormField> {
  bool isActive = false;
  bool obscureText = false;

  @override
  void initState() {
    super.initState();
    (widget.isPasswordHandle) ? obscureText = true : obscureText = false;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.usController,
      keyboardType: widget.textInputType,
      readOnly: widget.readOnly,
      cursorColor: Theme.of(context).primaryColor,
      obscureText: obscureText,
      autofocus: widget.autoFocus,
      decoration: InputDecoration(
          label: Text(widget.fieldName),
          hintText: widget.hintText,
          focusedBorder: defaultOutlineInputBorder(),
          enabledBorder: defaultOutlineInputBorder(),
          errorBorder: defaultOutlineInputBorder(),
          focusedErrorBorder: defaultOutlineInputBorder(),
          contentPadding:
          const EdgeInsets.only(left: 30, right: 10, top: 13, bottom: 13),
          suffixIcon: (widget.useSuffixIcon)
              ? GestureDetector(
            onTap: () {
              setState(() {
                isActive = !isActive;
                (widget.isPasswordHandle)
                    ? obscureText = !isActive
                    : obscureText = false;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(right: 18),
              child: Icon(
                (isActive)
                    ? widget.activeSuffixIcon
                    : widget.deActiveSuffixIcon,
                color: Theme.of(context).primaryColor,
              ),
            ),
          )
              : null),
      validator: (String? value) => widget.validateValue(value),
    );
  }
}

OutlineInputBorder defaultOutlineInputBorder() => OutlineInputBorder(
    borderRadius: BorderRadius.circular(10),
    borderSide: const BorderSide(color: Color.fromRGBO(0, 117, 230, 1)));
