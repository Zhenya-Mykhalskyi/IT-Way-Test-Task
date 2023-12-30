import 'package:flutter/material.dart';

import 'app_colors.dart';

class SnackbarUtils {
  static void showSnackbar(BuildContext context, String message,
      {bool isSuccess = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor:
            isSuccess ? AppColors.successColor : AppColors.errorColor,
      ),
    );
  }
}
