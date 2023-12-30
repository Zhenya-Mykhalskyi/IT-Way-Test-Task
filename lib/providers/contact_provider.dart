import 'package:flutter/material.dart';

import '../models/contact_model.dart';
import '../services/api_service.dart';
import '../utils/snackbar_utils.dart';

class ContactProvider extends ChangeNotifier {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController messageController = TextEditingController();
  final ApiService apiService;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ContactProvider(this.apiService);

  ContactModel _contact = ContactModel(name: '', email: '', message: '');
  bool _isButtonDisabled = true;
  bool _isSubmitting = false;

  ContactModel get contact => _contact;
  bool get isButtonDisabled => _isButtonDisabled;
  bool get isSubmitting => _isSubmitting;

  void updateContact({String? name, String? email, String? message}) {
    _contact = _contact.copyWith(
      name: name ?? _contact.name,
      email: email ?? _contact.email,
      message: message ?? _contact.message,
    );
    notifyListeners();
  }

  void validateForm() {
    if (formKey.currentState != null) {
      _isButtonDisabled = !formKey.currentState!.validate();
      notifyListeners();
    }
  }

  Future<void> submitForm(BuildContext context) async {
    _isSubmitting = true;
    notifyListeners();

    try {
      final response = await apiService.postContact(_contact);
      if (response['success']) {
        if (!context.mounted) return;
        SnackbarUtils.showSnackbar(context, 'Sent successfully');
        clearForm();
      } else {
        if (!context.mounted) return;
        SnackbarUtils.showSnackbar(context, 'Error: ${response['message']}',
            isSuccess: false);
      }
    } catch (error) {
      SnackbarUtils.showSnackbar(context, 'Error during request',
          isSuccess: false);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  void clearForm() {
    _contact = ContactModel(name: '', email: '', message: '');
    _isButtonDisabled = true;
    nameController.clear();
    emailController.clear();
    messageController.clear();

    notifyListeners();
  }
}
