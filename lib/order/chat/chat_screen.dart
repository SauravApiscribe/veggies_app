
import 'package:dash_chat/dash_chat.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../networking/fetch.dart' as http;
import '../../networking/urls.dart' as urls;
import '../../helpers/shared_preferences_helper.dart';
import '../../my_account/user_dto.dart';
import '../../theme/dialog.dart';
import '../../theme/full_screen_loader.dart';
import 'chat_dto.dart';




class ChatScreen extends StatefulWidget {
  final int orderId;

  ChatScreen(this.orderId);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<ChatMessage> _messages;
  late UserDto _currentUser;

  Future<List<ChatMessage>> _fetchOrderChats() async {
    dynamic response =
        await http.get(urls.query + '?orderId=${widget.orderId}', {});
    List<ChatDto> chats = (response['responseData']['queries'] as List<dynamic>)
        .map((chat) => ChatDto.fromJson(chat))
        .toList();
    var messages = chats
        .map(
          (chat) => ChatMessage(
            text: chat.message,
            createdAt: DateTime.fromMillisecondsSinceEpoch(chat.createdOn),
            user: ChatUser(
              firstName: chat.sender.firstName,
              name: chat.sender.firstName,
              uid: chat.sender.mobile,
            ),
          ),
        )
        .toList();
    setState(() {
      _messages = messages;
    });
    return messages;
  }

  Future<void> _fetchCurrentUser() async {
    UserDto userDto = await SharedPreferencesHelper.getUserDetails();
    setState(() {
      _currentUser = userDto;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCurrentUser();
  }

  void postMessage(ChatMessage chatMessage) {
    http.post(urls.query, {}, {
      'order': widget.orderId,
      'message': chatMessage.text,
    }).catchError((onError) {
      displayToastMessage('Something went wrong', color: Colors.red);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(),
        iconTheme: new IconThemeData(color: Theme.of(context).primaryColor),
        backgroundColor: Theme.of(context).colorScheme.secondary,
        title: Text(
          'CHAT WITH US',
          style: TextStyle(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ),
      body: (_currentUser == null)
          ? SizedBox()
          : StreamBuilder(
              stream: _fetchOrderChats().asStream(),
              builder: (context, snapshot) => (!snapshot.hasData)
                  ? FullScreenLoader()
                  : DashChat(
                      messages: _messages,
                      inputDecoration: InputDecoration.collapsed(
                          hintText: "Tell us your problem/feedback..."),
                      dateFormat: DateFormat('dd-MM-yyyy'),
                      timeFormat: DateFormat('hh:mm aa'),
                      inverted: true,
                      user: ChatUser(
                          name: _currentUser.firstName,
                          uid: _currentUser.mobile),
                      onSend: (ChatMessage chatMessage) {
                        _messages.add(chatMessage);
                        setState(() {});
                        postMessage(chatMessage);
                      },
                      inputCursorColor: Theme.of(context).primaryColor,
                      inputTextStyle: TextStyle(fontSize: 16.0),
                      inputContainerStyle: BoxDecoration(
                        border: Border.all(width: 0.0),
                        color: Colors.white,
                      ),
                      messageDecorationBuilder: ( msg,  isUser) {
                        return BoxDecoration(
                          color: isUser! ? Colors.green : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(10),
                        );
                      },
                    ),
            ),
    );
  }
}
