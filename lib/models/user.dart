import 'package:finch/finch_model_less.dart';

class User extends ModelLess {
  User(Map<String, dynamic>? fields) : super(fields: fields);

  String get id => this.get<String>('id');
  String get username => this.get<String>('username');
  String get name => this.get<String>('name');
  String get email => this.get<String>('email');
  String get secretLogin => this.get<String>('login_secret');
}
