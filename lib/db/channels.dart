import 'package:chat/app.dart';
import 'package:finch/finch_mysql.dart';

class ChannelsTable extends MysqlTable {
  @override
  DatabaseDriver get db => app.mysqlDriver;

  @override
  String get tableName => 'channels';

  ChannelsTable();

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
            name: 'slug',
            isNullable: false,
            isPrimaryKey: true,
          ),
          MFieldTimestamp(
            name: 'created_at',
            defaultValue: 'CURRENT_TIMESTAMP',
          ),
        ],
      );

  @override
  Future<({int count, SqlDatabaseResult<dynamic, dynamic, dynamic> rows})>
      findAll({
    String orderBy = 'id',
    bool orderReverse = true,
    Map<String, dynamic> filters = const {},
    int? pageSize,
    int? offset,
  }) async {
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
    var resAll = await db.execute(sqlAll);
    var resCount = await db.execute(countQuery);

    return (count: resCount.countRecords, rows: resAll);
  }

  @override
  Sqler updateFilters(Sqler query, Map<String, dynamic> filter) {
    throw UnimplementedError();
  }

  Future<int> insertChannel(String slug) async {
    var sql = Sqler().insert(qName, [
      {'slug': QVar(slug)}
    ]);
    var res = await db.execute(sql);
    return res.insertId;
  }
}
