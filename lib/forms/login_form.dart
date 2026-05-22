import 'package:finch/finch_ui.dart';

class LoginForm extends AdvancedForm {
  @override
  String get widget => 'forms/form_login.j2.html';

  @override
  String get name => 'form_login';
  LoginForm();

  @override
  List<Field> fields() {
    return [
      csrf(),
      Field(
        'username',
        validators: [
          FieldValidator.requiredField(),
        ],
      ),
      Field(
        'password',
        validators: [
          FieldValidator.requiredField(),
          FieldValidator.isPasswordField(),
        ],
      ),
    ];
  }
}
