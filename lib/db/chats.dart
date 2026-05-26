import 'package:chat/app.dart';
import 'package:chat/models/chat.dart';
import 'package:finch/finch_mysql.dart';

class ChatsTable extends MysqlTable {
  @override
  DatabaseDriver get db => app.mysqlDriver;

  @override
  String get tableName => 'chats';

  @override
  MTable get table => MTable(name: this.tableName, fields: []);

  @override
  Future<({int count, SqlDatabaseResult<dynamic, dynamic, dynamic> rows})>
      findAll(
          {String orderBy = 'id',
          bool orderReverse = true,
          Map<String, dynamic> filters = const {},
          int? pageSize,
          int? offset}) {
    throw UnimplementedError();
  }

  @override
  Sqler updateFilters(Sqler query, Map<String, dynamic> filter) {
    throw UnimplementedError();
  }

  Future<List<Map<String, dynamic>>> getChatsByChannelId(
    String channelId, {
    required int page,
    int pageSize = 20,
  }) async {
    var res = <Map<String, dynamic>>[];

    Sqler sql = Sqler()
        .selects([
          QSelect('chats.id', as: 'id'),
          QSelect('chats.message', as: 'message'),
          QSelect('chats.is_read', as: 'is_read'),
          QSelect('chats.created_at', as: 'created_at'),
          QSelect('user.id', as: 'user_id'),
          QSelect('user.username', as: 'user_username'),
          QSelect('receiver.id', as: 'receiver_id'),
          QSelect('receiver.username', as: 'receiver_username'),
          QSelect('channel.id', as: 'channel_id'),
          QSelect('channel.slug', as: 'channel_slug'),
        ])
        .from(QField(tableName, as: 'chats'))
        .join(LeftJoin(
          'users',
          On([Condition(QField('chats.user_id'), QO.EQ, QField('user.id'))]),
          as: 'user',
        ))
        .join(LeftJoin(
          'users',
          On([
            Condition(QField('chats.receiver_id'), QO.EQ, QField('receiver.id'))
          ]),
          as: 'receiver',
        ))
        .join(LeftJoin(
          'channels',
          On([
            Condition(QField('chats.channel_id'), QO.EQ, QField('channel.id'))
          ]),
          as: 'channel',
        ))
        .whereOne(QField('chats.channel_id'), QO.EQ, QVar(channelId))
        .orderBy(QOrder('chats.id', desc: true))
        .limit(pageSize, (page - 1) * pageSize);

    var queryResult = await db.execute(sql);
    queryResult.assoc.forEach((row) {
      res.add(Chat(row).assoc);
    });
    return res;
  }

  Future<List<Map<String, dynamic>>> getOneChatUsers(
    List users, {
    required int page,
    int pageSize = 20,
  }) async {
    var res = <Map<String, dynamic>>[];

    Sqler sql = Sqler()
        .selects([
          QSelect('chats.id', as: 'id'),
          QSelect('chats.message', as: 'message'),
          QSelect('chats.is_read', as: 'is_read'),
          QSelect('chats.created_at', as: 'created_at'),
          QSelect('user.id', as: 'user_id'),
          QSelect('user.username', as: 'user_username'),
          QSelect('receiver.id', as: 'receiver_id'),
          QSelect('receiver.username', as: 'receiver_username'),
        ])
        .from(QField(tableName, as: 'chats'))
        .join(LeftJoin(
          'users',
          On([Condition(QField('chats.user_id'), QO.EQ, QField('user.id'))]),
          as: 'user',
        ))
        .join(LeftJoin(
          'users',
          On([
            Condition(QField('chats.receiver_id'), QO.EQ, QField('receiver.id'))
          ]),
          as: 'receiver',
        ))
        .whereAnd([
          Condition(QField('chats.user_id'), QO.IN, QVar(users)),
          Condition(QField('chats.receiver_id'), QO.IN, QVar(users)),
          Condition(
              QField('chats.user_id'), QO.NEQ, QField('chats.receiver_id'))
        ])
        .orderBy(QOrder('chats.id', desc: true))
        .limit(pageSize, (page - 1) * pageSize);
    var queryResult = await db.execute(sql);
    queryResult.assoc.forEach((row) {
      res.add(Chat(row).assoc);
    });
    return res;
  }

  Future<int> insertChat({
    required String userId,
    required String message,
    String? receiverId,
    String? channelId,
  }) async {
    Sqler sqler = Sqler().insert(
      qName,
      [
        {
          'user_id': QVar(userId),
          'message': QVar(message),
          'receiver_id': QVar(receiverId),
          'channel_id': QVar(channelId),
        }
      ],
    );

    var queryResult = await db.execute(sqler);
    return queryResult.insertId;
  }

  /// Returns { sender_user_id → unread_count } for messages addressed to [receiverId].
  Future<Map<String, int>> getUnreadCountsForUser(String receiverId) async {
    var sql = Sqler()
        .selects([QSelect('user_id', as: 'user_id')])
        .from(QField(tableName, as: 'chats'))
        .whereAnd([
          Condition(QField('receiver_id'), QO.EQ, QVar(receiverId)),
          Condition(QField('is_read'), QO.EQ, QVar(0)),
        ]);

    var result = await db.execute(sql);
    var counts = <String, int>{};
    for (var row in result.assoc) {
      final uid = row['user_id'].toString();
      counts[uid] = (counts[uid] ?? 0) + 1;
    }
    return counts;
  }

  /// Marks all messages from [senderId] to [receiverId] as read.
  Future<void> markAsRead(String receiverId, String senderId) async {
    var sql = Sqler().update(qName).updateSet('is_read', QVar(1)).whereAnd([
      Condition(QField('receiver_id'), QO.EQ, QVar(receiverId)),
      Condition(QField('user_id'), QO.EQ, QVar(senderId)),
    ]);
    await db.execute(sql);
  }
}
