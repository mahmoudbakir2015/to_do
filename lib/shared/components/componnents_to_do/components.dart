import 'package:flutter/material.dart';

Widget defaultTextForm({
  required String label,
  required TextEditingController controller,
  bool obscureText = false,
  required TextInputType textInputType,
  required IconData iconData,
  bool isSuffix = false,
  void Function(String)? onSubmitted,
  void Function(String)? onChange,
  required String? Function(String?)? onValidate,
  void Function()? showIcon,
  void Function()? onTap,
  bool readonly = false,
}) =>
    TextFormField(
      readOnly: readonly,
      onTap: onTap,
      onFieldSubmitted: onSubmitted,
      onChanged: onChange,
      validator: onValidate,
      controller: controller,
      obscureText: obscureText,
      keyboardType: textInputType,
      decoration: InputDecoration(
        prefixIcon: Icon(
          iconData,
        ),
        labelText: label,
        suffixIcon: isSuffix
            ? GestureDetector(
                onTap: showIcon,
                child: obscureText
                    ? const Icon(
                        Icons.visibility_off,
                      )
                    : const Icon(
                        Icons.visibility,
                      ),
              )
            : null,
        border: const OutlineInputBorder(),
      ),
    );

void navigateTo({
  required BuildContext context,
  required Widget widget,
}) {
  Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => widget,
    ),
  );
}
