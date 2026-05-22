import 'package:chat/app.dart';
import 'package:chat/db/users.dart';
import 'package:finch/finch_ui.dart';

class RegisterForm extends AdvancedForm {
  @override
  String get widget => 'forms/form_register.j2.html';

  @override
  String get name => 'form_register';
  RegisterForm();

  @override
  List<Field> fields() {
    return [
      csrf(),
      Field('email', validators: [
        FieldValidator.requiredField(),
        FieldValidator.isEmailField(),
        FieldValidator.isUniqueSQLField(
          db: app.mysqlDriver,
          table: UsersTable().tableName,
          field: 'email',
        ),
      ]),
      Field(
        'username',
        validators: [
          FieldValidator.requiredField(),
          FieldValidator.isUniqueSQLField(
            db: app.mysqlDriver,
            table: UsersTable().tableName,
            field: 'username',
          ),
        ],
      ),
      Field(
        'password',
        validators: [
          FieldValidator.requiredField(),
          FieldValidator.isPasswordField(),
        ],
      ),
      Field(
        'confirm_password',
        validators: [
          FieldValidator.requiredField(),
          FieldValidator.isPasswordField(),
          (value) async {
            var password = this.rq.get<String>('password', def: '');
            if (value != password) {
              return FieldValidateResult(
                success: false,
                error: 'Passwords do not match',
              );
            }
            return FieldValidateResult(success: true);
          }
        ],
      ),
    ];
  }
}
