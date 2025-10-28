import 'package:chat_app/constant.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/chat_buble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatelessWidget {
  static String id = 'ChatPage';

  CollectionReference messages = FirebaseFirestore.instance.collection(kMessagesCollection);
  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: messages.get(),
      builder: (context , snapshot){
        if(snapshot.hasData){
          List<Message> messagesList = [];
          for (int i = 0 ; i< snapshot.data!.docs.length; i++){
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
          }
          return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset( kLogo,
                  height: 50,),
                Text('Scholar Page', 
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontFamily: 'pacifico',
                ),),
              ],
            ),
            centerTitle: true,
            backgroundColor: kPrimaryColor,
          ),
          body: Column(
            children:[ Expanded(
              child: ListView.builder(
                itemCount: messagesList.length,
                itemBuilder: (context, index){
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: ChatBuble(message: messagesList[index],),
                );
              },),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: controller,
                onSubmitted: (data)
                {
                  messages.add({
                    'message':data,

                    });
                  controller.clear();  
                },
                decoration: InputDecoration(
                  hintText: 'Type your message here...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  suffixIcon: Icon(Icons.send),
                ),
              ),
            )
            ],
          ),
        );
        } else {
          return Text('Loading...');
        }
      },
      );
  }
}

