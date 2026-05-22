import 'package:finch/finch_route.dart';

class WorkspaceController extends Controller {
  WorkspaceController();

  Future<String> index() async {
    return renderTemplate('workspace');
  }

  Future<String> renderTemplate(String widget, {bool toData = false}) async {
    return rq.renderView(path: widget, toData: toData);
  }
}
