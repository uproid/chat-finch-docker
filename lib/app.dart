import 'package:chat/configs/setting.dart';
import 'package:chat/route/socket_route.dart';
import 'package:finch/finch_console.dart';
import 'core/local_events.dart';
import 'package:finch/finch_route.dart';
import 'package:finch/finch_app.dart';
import 'route/web_route.dart';

final app = FinchApp(configs: configs);
final socketManager = SocketManager(
  app,
  event: SocketEvent(
    onConnect: (socket) =>
        Print.info('Socket connected: ${socket.manager.session}'),
    onDisconnect: (socket) => Print.info('Socket disconnected: ${socket.id}'),
    onError: (socket, data) => Print.error(
      'Socket error on ${socket.id}: $data',
    ),
    onMessage: (socket, data) => Print.info('Message from ${socket.id}: $data'),
  ),
  routes: getSocketRoute(),
);

void main([List<String>? args]) async {
  app.addRouting(getWebRoute);
  Request.localEvents.addAll(localEvents);
  Request.addLocalLayoutFilters(localLayoutFilters);
  app.socketManager = socketManager;
  app.start(args);
}
