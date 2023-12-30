import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '/utils/app_colors.dart';
import '../providers/contact_provider.dart';

import '../widgets/custom_text_field.dart';

class ContactPage extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  ContactPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SingleChildScrollView(
          child: Consumer<ContactProvider>(
            builder: (context, contactProvider, child) {
              return Form(
                key: contactProvider.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    CustomTextField(
                      controller: contactProvider.nameController,
                      onValueChanged: (value) {
                        contactProvider.updateContact(name: value);
                        contactProvider.validateForm();
                      },
                      maxLength: 40,
                      labelText: 'Name',
                      validatorType: ValidatorType.string,
                    ),
                    CustomTextField(
                      controller: contactProvider.emailController,
                      onValueChanged: (value) {
                        contactProvider.updateContact(email: value);
                        contactProvider.validateForm();
                      },
                      maxLength: 40,
                      labelText: 'Email',
                      validatorType: ValidatorType.email,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    CustomTextField(
                      controller: contactProvider.messageController,
                      onValueChanged: (value) {
                        contactProvider.updateContact(message: value);
                        contactProvider.validateForm();
                      },
                      maxLength: 100,
                      labelText: 'Message',
                      validatorType: ValidatorType.string,
                    ),
                    const SizedBox(height: 45),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                          contactProvider.isButtonDisabled
                              ? AppColors.greyColor
                              : AppColors.buttonColor,
                        ),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        fixedSize: MaterialStateProperty.all<Size>(
                          const Size.fromHeight(50.0),
                        ),
                      ),
                      onPressed: contactProvider.isButtonDisabled
                          ? null
                          : () {
                              contactProvider.submitForm(context);
                            },
                      child: contactProvider.isSubmitting
                          ? const CircularProgressIndicator()
                          : const Text('Send'),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
