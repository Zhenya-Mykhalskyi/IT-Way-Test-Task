import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../widgets/custom_text_field.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  bool _isButtonDisabled = true;
  bool _isSubmitting = false;

  void _validateForm() {
    setState(() {
      _isButtonDisabled = !_formKey.currentState!.validate();
    });
  }

  void _submitForm() async {
    setState(() {
      _isSubmitting = true;
    });
    // uncomment if we dont't need to validate by onChanged

    // if (_formKey.currentState!.validate()) {
    Map<String, dynamic> formData = {
      "name": _nameController.text,
      "email": _emailController.text,
      "message": _messageController.text,
    };

    try {
      final response = await http.post(
        Uri.parse('https://api.byteplex.info/api/test/contact/'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(formData),
      );

      if (response.statusCode == 201) {
        _showSnackBar('Success: sent successfully!', false);
        _clearForm();
      } else {
        _showSnackBar('Error: ${response.reasonPhrase}', true);
      }
    } catch (error) {
      _showSnackBar('Error: Unable to send the message', true);
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
    // }
    //  else {
    //   _showSnackBar('Error: Please fix the validation errors', true);

    //   setState(() {
    //     _isSubmitting = false;
    //   });
    // }
  }

  void _showSnackBar(String message, bool isError) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: isError ? Colors.red : Colors.green,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _messageController.clear();
    setState(() {
      _isButtonDisabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CustomTextField(
                controller: _nameController,
                validatorType: ValidatorType.string,
                onValueChanged: _validateForm,
                maxLength: 40,
                labelText: 'Name',
              ),
              CustomTextField(
                controller: _emailController,
                validatorType: ValidatorType.email,
                onValueChanged: _validateForm,
                maxLength: 40,
                labelText: 'Email',
              ),
              CustomTextField(
                controller: _messageController,
                validatorType: ValidatorType.string,
                onValueChanged: _validateForm,
                maxLength: 250,
                labelText: 'Message',
              ),
              const SizedBox(height: 45),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                    _isButtonDisabled
                        ? Colors.grey
                        : const Color.fromARGB(255, 138, 79, 149),
                  ),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  fixedSize: MaterialStateProperty.all<Size>(
                    const Size.fromHeight(50.0),
                  ),
                ),
                onPressed: _isButtonDisabled ? null : _submitForm,
                child: _isSubmitting
                    ? const CircularProgressIndicator()
                    : Text(
                        _isSubmitting ? 'Please wait...' : 'Send',
                        style: const TextStyle(color: Colors.white),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
