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
        var page = (data['page'] ?? 1) as int;
        var channelId = data['channel_id'].toString();
        var chats =
            await ChatsTable().getChatsByChannelId(channelId, page: page);
        socket.send({
          'items': chats,
          'page': page,
          'channel_id': channelId,
        }, path: 'channel_chats');
      },
    ),
    'send_chat': SocketEvent(
      onMessage: (socket, payload) async {
        var data = payload['data'];
        var channelId = data['channel_id'].toString();
        var res = await ChatsTable().insertChat(
          userId: data['user_id'],
          message: data['message'],
          receiverId: data['receiver_id'],
          channelId: channelId,
        );

        // Always broadcast page 1 so all clients reset to latest messages
        var chats = await ChatsTable().getChatsByChannelId(channelId, page: 1);
        socket.manager.sendToAll({
          'items': chats,
          'page': 1,
          'channel_id': channelId,
        }, path: 'channel_chats');

        socket.send(
          {'new_chat': res},
          path: 'send_chat',
        );
      },
    ),
    'users_messages': SocketEvent(
      onMessage: (socket, payload) async {
        var data = payload['data'];
        var users = data['users'] ?? [];
        var page = (data['page'] ?? 1) as int;
        var messages = await ChatsTable().getOneChatUsers(users, page: page);
        socket.send({
          'items': messages,
          'page': page,
          'users': users,
        }, path: 'users_messages');
      },
    ),
    'send_message_to_user': SocketEvent(
      onMessage: (socket, payload) async {
        var data = payload['data'];
        var secretChat = socket.rq.getCookie('chat_secret', safe: true);
        print(secretChat);
        var senderUser = await UsersTable().getUserBySecret(secretChat);
        var receiverUser = data['to'].toString();

        await ChatsTable().insertChat(
          userId: senderUser!.id,
          message: data['message'],
          receiverId: receiverUser,
        );

        // Broadcast page 1 to both participants so their pagination resets
        var users = [senderUser.id, receiverUser];
        var messages = await ChatsTable().getOneChatUsers(users, page: 1);
        var responseData = {
          'items': messages,
          'page': 1,
          'users': users,
        };
        socket.manager
            .sendToUser(senderUser.id, responseData, path: 'users_messages');
        socket.manager
            .sendToUser(receiverUser, responseData, path: 'users_messages');

        // Push fresh unread counts to the receiver so their sidebar badge updates
        var receiverCounts =
            await ChatsTable().getUnreadCountsForUser(receiverUser);
        socket.manager.sendToUser(
          receiverUser,
          {'counts': receiverCounts},
          path: 'unread_counts',
        );
      },
    ),
    'unread_counts': SocketEvent(
      onMessage: (socket, payload) async {
        var secretChat = socket.rq.getCookie('chat_secret', safe: true);
        var currentUser = await UsersTable().getUserBySecret(secretChat);
        if (currentUser == null) {
          socket.send({'counts': {}}, path: 'unread_counts');
          return;
        }
        var counts = await ChatsTable().getUnreadCountsForUser(currentUser.id);
        socket.send({'counts': counts}, path: 'unread_counts');
      },
    ),
    'mark_read': SocketEvent(
      onMessage: (socket, payload) async {
        var data = payload['data'];
        var secretChat = socket.rq.getCookie('chat_secret', safe: true);
        var currentUser = await UsersTable().getUserBySecret(secretChat);
        if (currentUser == null) return;

        var senderId = data['user_id'].toString();
        await ChatsTable().markAsRead(currentUser.id, senderId);

        // Return updated counts so the sidebar badge clears immediately
        var counts = await ChatsTable().getUnreadCountsForUser(currentUser.id);
        socket.send({'counts': counts}, path: 'unread_counts');
      },
    ),
  };
}
