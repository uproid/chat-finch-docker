import 'package:finch/finch_tools.dart';
import 'package:finch/model_less.dart';

class Chat extends ModelLess {
  Chat(Map<String, dynamic>? fields) : super(fields: fields);

  String get id => this.get<String>('id');
  String get userId => this.get<String>('user_id');
  String get message => this.get<String>('message');
  String? get receiverId => this.get<String?>('receiver_id');
  String? get channelId => this.get<String?>('channel_id');
  String get createdAt => this.get<String>('created_at');
  bool get isRead => this.get<String>('is_read').toBool;

  // Relations
  String get userUsername => this.get<String>('user_username');
  String? get receiverUsername => this.get<String?>('receiver_username');
  String? get channelSlug => this.get<String?>('channel_slug');

  // check has receiver
  bool get hasReceiver => receiverId != null;
  bool get hasChannel => channelId != null;

  // Datetime get createdAtDateTime => DateTime.parse(createdAt);
  DateTime? get createdAtDateTime =>
      DateTime.tryParse(createdAt) ?? DateTime(1970);

  Map<String, dynamic> get assoc {
    return {
      ...fields,
      'user_username': userUsername,
      'receiver_username': receiverUsername,
      'channel_slug': channelSlug,
      'has_receiver': hasReceiver,
      'has_channel': hasChannel,
      'datetime': createdAtDateTime.toString(),
    };
  }
}
