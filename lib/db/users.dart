import 'dart:math';

import 'package:chat/app.dart';
import 'package:chat/configs/setting.dart';
import 'package:chat/models/user.dart';
import 'package:finch/finch_mysql.dart';
import 'package:finch/finch_tools.dart';

class UsersTable extends MysqlTable {
  @override
  DatabaseDriver get db => app.mysqlDriver;

  @override
  String get tableName => 'users';

  UsersTable();

  @override
  MTable get table => MTable(
        name: tableName,
        fields: [
          MFieldInt(
            name: 'id',
            isAutoIncrement: true,
            isPrimaryKey: true,
            isNullable: false,
          ),
          MFieldVarchar(
            name: 'username',
            isNullable: false,
            isPrimaryKey: true,
          ),
          MFieldVarchar(
            name: 'email',
            isNullable: false,
            isPrimaryKey: true,
          ),
          MFieldVarchar(
            name: 'password',
            isNullable: false,
          ),
          MFieldVarchar(
            name: 'login_secret',
            isNullable: false,
          ),
          MFieldTimestamp(
            name: 'created_at',
            defaultValue: 'CURRENT_TIMESTAMP',
          ),
        ],
      );

  @override
  Future<({int count, SqlDatabaseResult<dynamic, dynamic, dynamic> rows})>
      findAll(
          {String orderBy = 'id',
          bool orderReverse = true,
          Map<String, dynamic> filters = const {},
          int? pageSize,
          int? offset}) {
    var sqlAll = Sqler()
        .selects(table.allSelectFields())
        .from(qName)
        .orderBy(QOrder(orderBy, desc: orderReverse));

    if (pageSize != null) {
      sqlAll = sqlAll.limit(pageSize, offset);
    }

    var countQuery = sqlAll.copyWith(
      selects: [
        SQL.count(QField('id', as: 'count_records')),
      ],
    )
      ..clearGroupBy()
      ..clearOrderBy()
      ..clearLimit();
    var resAll = db.execute(sqlAll);
    var resCount = db.execute(countQuery);

    return Future.wait([resAll, resCount]).then((results) {
      var resAll = results[0];
      var resCount = results[1];
      return (count: resCount.countRecords, rows: resAll);
    });
  }

  @override
  Sqler updateFilters(Sqler query, Map<String, dynamic> filter) {
    throw UnimplementedError();
  }

  Future<User?> getUserBySecret(String secret) async {
    Sqler sql = Sqler()
        .selects(
          table.allSelectFields(),
        )
        .from(this.qName)
        .whereOne(QField('login_secret'), QO.EQ, QVar(secret));
    var result = await table.select(db, sql);
    if (result.success && result.rows.length == 1) {
      User user = User(result.assocFirst);
      return user;
    }

    return null;
  }

  Future<User?> getUser(
    String username,
    String password,
  ) async {
    password = password.toMd5().toSafe(MainConfigs.safePassword);
    Sqler sql = Sqler()
        .selects(
          table.allSelectFields(),
        )
        .from(this.qName)
        .whereAnd([
      Condition(QField('username'), QO.EQ, QVar(username)),
      Condition(QField('password'), QO.EQ, QVar(password)),
    ]);
    var result = await table.select(db, sql);

    if (result.success && result.rows.length == 1) {
      User user = User(result.assocFirst);
      return user;
    }

    return null;
  }

  Future<SqlDatabaseResult> newUser({
    required String email,
    required String username,
    required String password,
  }) {
    password = password.toMd5().toSafe(MainConfigs.safePassword);
    Sqler sql = Sqler().insert(this.qName, [
      {
        'email': QVar(email),
        'username': QVar(username),
        'password': QVar(password),
        'login_secret':
            QVar.password(Random.secure().nextInt(1 << 32).toString()),
      }
    ]);
    return table.execute(db, sql);
  }

  Future<String> setSecretLogin(String username) async {
    var randomSecret = List.generate(
      48,
      (_) => 'abcdefghijklmnopqrstuvwxyz0123456789'[Random().nextInt(36)],
    ).join().toSafe(MainConfigs.safePassword);

    Sqler sql = Sqler()
        .update(this.qName)
        .updateSet('login_secret', QVar(randomSecret))
        .whereOne(QField('username'), QO.EQ, QVar(username));
    var result = await table.execute(db, sql);
    if (result.success) {
      return randomSecret;
    }
    return '';
  }
}
