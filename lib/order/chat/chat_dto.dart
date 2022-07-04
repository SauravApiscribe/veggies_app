

import '../../my_account/user_dto.dart';

class ChatDto {
  final int id;
  final int createdOn;
  final String message;
  final UserDto receiver;
  final UserDto sender;

  ChatDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdOn = json['created_on'],
        message = json['message'],
        receiver = UserDto.fromJson(json['receiver']),
        sender = UserDto.fromJson(json['sender']);
}
