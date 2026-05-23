import 'package:chat/languages/language_dart.g.dart';
import 'package:chat/widgets/widget_dart.g.dart';
import 'package:finch/finch_app.dart';
import 'package:finch/finch_model.dart';
import 'package:finch/finch_tools.dart';

class Setting {
  static const languages = {
    "en": {
      "name": "English",
      "flag":
          "https://cdn.jsdelivr.net/gh/twitter/twemoji@14.0.3/assets/svg/1f1ec-1f1e7.svg"
    },
  };
}

FinchConfigs configs = FinchConfigs(
  jinjaMapTemplate: mapTemplates,
  widgetsPath: pathTo(env['WIDGETS_PATH'] ?? "./lib/widgets"),
  widgetsType: env['WIDGETS_TYPE'] ?? 'j2.html',
  languagePath: pathTo(env['LANGUAGE_PATH'] ?? "./lib/languages"),
  pathMigrationMySQL: env['MIGRATION_MYSQL'] ?? "./migrations",
  languageSource: LanguageSource.dart,
  dartLanguages: languageDart,
  publicDir: pathTo(env['PUBLIC_DIR'] ?? './public'),
  dbConfig: FinchDBConfig(
    enable: false,
  ),
  port: (env['DOMAIN_PORT'] ?? '2020').toInt(def: 2020),
  mysqlConfig: FinchMysqlConfig(
    enable: true,
    host: env['MYSQL_HOST'] ?? 'localhost',
    port: (env['MYSQL_PORT'] ?? '3306').toInt(def: 3306),
    user: env['MYSQL_USER'] ?? 'example_user',
    pass: env['MYSQL_PASSWORD'] ?? 'example_password',
    databaseName: env['MYSQL_DATABASE'] ?? 'example_db',
  ),

  /// Enable local debugger
  enableLocalDebugger:
      false, //(env['ENABLE_LOCAL_DEBUGGER'] ?? true).toString().toBool,
);

class MainConfigs {
  static const String safePassword = 'a3b!C9#dE';
}
