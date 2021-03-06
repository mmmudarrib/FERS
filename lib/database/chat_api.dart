import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:digiloger/models/chats.dart';
import 'package:digiloger/models/messages.dart';
import 'package:digiloger/services/user_local_data.dart';

class ChatAPI {
  static const String _colloction = 'chats';
  static const String _subColloction = 'messages';
  static final FirebaseFirestore _instance = FirebaseFirestore.instance;
  // functions
  static String getChatID({required String othersUID}) {
    int _isGreaterThen = UserLocalData.getUID.compareTo(othersUID);
    if (_isGreaterThen > 0) {
      return '${UserLocalData.getUID}-chats-$othersUID';
    } else {
      return '$othersUID-chats-${UserLocalData.getUID}';
    }
  }

  Future<void> sendMessage(Chat chat, Messages messages) async {
    // ignore: always_specify_types
    Future.wait([
      _instance
          .collection(_colloction)
          .doc(chat.chatID)
          .collection(_subColloction)
          .doc(messages.messageID)
          .set(messages.toMap()),
      _instance.collection(_colloction).doc(chat.chatID).set(chat.toMap()),
    ]);
  }

  Future<Chat?> fetchChat(String chatID) async {
    final DocumentSnapshot<Map<String, dynamic>> doc =
        await _instance.collection(_colloction).doc(chatID).get();
    if (!doc.exists) return null;
    Chat _chat = Chat.fromDoc(doc);
    return _chat;
  }

  Future<Stream<QuerySnapshot<Map<String, dynamic>>>> fetchMessages(
      String chatID) async {
    return _instance
        .collection(_colloction)
        .doc(chatID)
        .collection(_subColloction)
        .orderBy('timestamp', descending: true)
        .snapshots();
    // List<Messages> _messages = <Messages>[];
    // // print(docs.docs);
    // for (DocumentSnapshot<Map<String, dynamic>> doc in docs.docs) {
    //   _messages.add(Messages.fromDoc(doc));
    // }
    // return _messages;
  }
}
