import 'package:finch/finch_tools.dart';

var localEvents = <String, Object>{};

var localLayoutFilters = <String, Function>{
  'tr': (String text) {
    return text.tr;
  },
  'translate': (String text) {
    return text.tr;
  },
};
