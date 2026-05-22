import 'package:finch/finch_model_less.dart';

class Channel extends ModelLess {
  Channel(Map<String, dynamic>? fields) : super(fields: fields);

  String get id => this.get<String>('id');
  String get createAt => this.get<String>('created_at');
  String get slug => this.get<String>('slug');
}
