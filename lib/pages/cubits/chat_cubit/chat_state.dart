import 'package:chat_app/models/message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState{}

class ChatSuccess extends ChatState{
  final List<Message> messages;

  ChatSuccess({required this.messages});
}