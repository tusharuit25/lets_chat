import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../models/chat.dart';
import '../../../models/message.dart';
import '../../../models/user.dart' as app;
import '../../../utils/common/providers/current_user_provider.dart';
import '../repositories/chat_repository.dart';

final chatControllerProvider = Provider<ChatController>(
  (ref) {
    final chatRepository = ref.watch(chatRepositoryProvider);
    return ChatController(chatRepository: chatRepository, ref: ref);
  },
);

class ChatController {
  ChatController({
    required ChatRepository chatRepository,
    required ProviderRef ref,
  })  : _chatRepository = chatRepository,
        _ref = ref;

  final ChatRepository _chatRepository;
  final ProviderRef _ref;

  Future<void> sendTextMessage(
    BuildContext context, {
    required String lastMessage,
    required String receiverUserId,
  }) async {
    app.User senderUser = _ref.watch(currentUserProvider!);
    _chatRepository.sendTextMessage(
      context,
      lastMessage: lastMessage,
      receiverUserId: receiverUserId,
      senderUser: senderUser,
    );
  }

  Stream<List<Chat>> getChatsList() {
    app.User senderUser = _ref.watch(currentUserProvider!);
    return _chatRepository.getChatsList(senderUserId: senderUser.uid);
  }

  /// invoke to get single chat (messages)
  Stream<List<Message>> getMessagesList({required receiverUserId}) {
    app.User senderUser = _ref.watch(currentUserProvider!);
    return _chatRepository.getMessagesList(
      senderUserId: senderUser.uid,
      receiverUserId: receiverUserId,
    );
  }
}