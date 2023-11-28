import 'package:flutter/material.dart';

enum ValidatorType { string, email }

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final ValidatorType validatorType;
  final Function() onValueChanged;
  final int maxLength;
  final String labelText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int? maxLines;

  CustomTextField({
    Key? key,
    required this.controller,
    required this.validatorType,
    required this.onValueChanged,
    required this.maxLength,
    required this.labelText,
    this.keyboardType,
    this.maxLines,
  })  : validator = _getValidatorFunction(validatorType),
        super(key: key);

  static String? Function(String?)? _getValidatorFunction(
    ValidatorType type,
  ) {
    switch (type) {
      case ValidatorType.string:
        return _validateString;
      case ValidatorType.email:
        return _validateEmail;
      default:
        return null;
    }
  }

  static String? _validateString(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field cannot be empty';
    }
    return null;
  }

  static String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(value)) {
      return 'Enter a valid email address';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    bool isValid = validator!(controller.text) == null;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          Container(
            width: 35,
            height: 35,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isValid
                  ? Colors.green
                  : const Color.fromARGB(197, 255, 211, 136).withOpacity(0.3),
            ),
            child: Icon(
              isValid ? Icons.check : Icons.lock,
              color: isValid ? Colors.white : Colors.amber.withOpacity(0.6),
              size: 17,
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: TextFormField(
              controller: controller,
              validator: validator,
              keyboardType: keyboardType,
              textAlign: TextAlign.start,
              maxLength: maxLength,
              // remove if we need only submit button validation
              onChanged: (value) {
                onValueChanged();
              },
              style: const TextStyle(fontSize: 16),
              decoration: InputDecoration(
                counterText: '',
                labelText: labelText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
