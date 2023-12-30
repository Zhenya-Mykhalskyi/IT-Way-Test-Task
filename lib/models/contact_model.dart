class ContactModel {
  String name;
  String email;
  String message;

  ContactModel(
      {required this.name, required this.email, required this.message});

  ContactModel copyWith({String? name, String? email, String? message}) {
    return ContactModel(
      name: name ?? this.name,
      email: email ?? this.email,
      message: message ?? this.message,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'message': message,
    };
  }
}
