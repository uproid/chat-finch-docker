import 'package:chat/app.dart';
import 'package:chat/db/channels.dart';
import 'package:chat/db/users.dart';
import 'package:chat/route/web_route.dart';

import '../configs/setting.dart';
import 'package:finch/finch_route.dart';

class HomeController extends Controller {
  ChannelsTable channelsTable = ChannelsTable();
  UsersTable usersTable = UsersTable();

  HomeController();

  @override
  Future<String> index() async {
    final channels = await channelsTable.findAll(orderReverse: false);
    final users = await usersTable.findAll();
    rq.addParam('channels', channels.rows.assoc);
    rq.addParam('countChannels', channels.count);
    rq.addParam('users', users.rows.assoc);
    rq.addParam('countUsers', users.count);
    return renderTemplate('home');
  }

  Future<String> register() async {
    return renderTemplate('register');
  }

  Future<String> renderTemplate(String widget, {bool toData = false}) async {
    rq.addParam('languages', Setting.languages);

    return rq.renderView(path: widget, toData: toData);
  }

  Future<String> socket() async {
    var user = await authController.getLoggedInUser();
    socketManager.requestHandle(rq, userId: user!.id);
    return rq.renderSocket();
  }
}
