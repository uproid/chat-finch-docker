import 'package:chat/db/channels.dart';
import 'package:chat/db/chats.dart';
import 'package:chat/db/users.dart';
import 'package:finch/finch_app.dart';
import 'package:finch/finch_console.dart';
import 'package:finch/finch_tools.dart';

Map<String, SocketEvent> getSocketRoute() {
  return {
    'test': SocketEvent(
      onMessage: (socket, data) {
        Console.e(data);
        socket.send([socket.rq.headers], path: 'test');
      },
    ),
    'close': SocketEvent(
      onMessage: (socket, data) {
        socket.close();
      },
    ),
    'channels': SocketEvent(
      onMessage: (socket, data) async {
        var listChannels = await ChannelsTable().findAll(orderReverse: false);
        socket.send(
          {'items': listChannels.rows.assoc},
          path: 'channels',
        );
      },
    ),
    'new_channel': SocketEvent(
      onMessage: (socket, payload) async {
        var data = payload['data'];
        await ChannelsTable().insertChannel(
          data['slug'].toString().trim().toSlug(),
        );
        var listChannels = await ChannelsTable().findAll(orderReverse: false);
        socket.manager.sendToAll(
          {'items': listChannels.rows.assoc},
          path: 'channels',
        );
      },
    ),
    'users': SocketEvent(
      onMessage: (socket, data) async {
        var listUsers = await UsersTable().findAll(orderReverse: false);
        socket.send(
          {'items': listUsers.rows.assoc},
          path: 'users',
        );
      },
    ),
    'channel_chats': SocketEvent(
      onMessage: (socket, payload) async {
        var data = payload['data'];
        var chats = await ChatsTable().getChatsByChannelId(data['channel_id']);
        socket.send({'items': chats}, path: 'channel_chats');
      },
    ),
    'send_chat': SocketEvent(
      onMessage: (socket, payload) async {
        var data = payload['data'];
        var res = await ChatsTable().insertChat(
          userId: data['user_id'],
          message: data['message'],
          receiverId: data['receiver_id'],
          channelId: data['channel_id'],
        );

        var chats = await ChatsTable().getChatsByChannelId(data['channel_id']);
        socket.manager.sendToAll({'items': chats}, path: 'channel_chats');

        socket.send(
          {'new_chat': res},
          path: 'send_chat',
        );
      },
    ),
    'users_messages': SocketEvent(
      onMessage: (socket, payload) async {
        var users = payload['data']['users'] ?? [];
        var messages = await ChatsTable().getOneChatUsers(users);
        socket.send({'items': messages}, path: 'users_messages');
      },
    ),
    'send_message_to_user': SocketEvent(
      onMessage: (socket, payload) async {
        var data = payload['data'];
        var secretChat = socket.rq.getCookie('chat_secret', safe: true);
        print(secretChat);
        var senderUser = await UsersTable().getUserBySecret(secretChat);
        var receiverUser = data['to'];

        ChatsTable()
            .insertChat(
          userId: senderUser!.id,
          message: data['message'],
          receiverId: receiverUser,
        )
            .then((_) async {
          socket.manager
              .sendToUser(senderUser.id, {}, path: 'new_message_from_user');
          socket.manager
              .sendToUser(receiverUser, {}, path: 'new_message_from_user');
        });
      },
    ),
  };
}
