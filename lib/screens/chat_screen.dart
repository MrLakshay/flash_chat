import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
late User loggedinUser;
class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController=TextEditingController();
  late String message;
  bool spinner = false;

  void initState() {
    super.initState();
    getCurrentUser();
  }
  void getMessages() async{
    await for (var snaps in _firestore.collection('messages').snapshots()){
      for(var message in snaps.docs){
        print(message.data);
      }
    }
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
        print(loggedinUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                getMessages();
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder(
              stream: _firestore.collection('messages').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.lightBlueAccent,
                    ),
                  );
                }
                final messages = snapshot.data?.docs.reversed;
                List<MessageBubble> messageBubbles=[];
                for(var message in messages!){
                  final messagetext=message.data()['text'];
                  final messagesender=message.data()['sender'];

                  final messageBubble=MessageBubble(messagesender: messagesender, messagetext: messagetext,isMe: messagesender==loggedinUser.email);
                  messageBubbles.add(messageBubble);
                }
                return  Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 20.0),
                    children: messageBubbles,
                  ),
                );
                return Column();
              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      style: TextStyle(
                        color: Colors.black,
                      ),
                      onChanged: (value) {
                        //Do something with the user input.
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'sender': loggedinUser.email,
                        'text': message,
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
            
          ],
        ),
      ),
                               
    );
  }
}

class MessageBubble extends StatelessWidget{
  late var messagetext;
  late var messagesender;
  late bool isMe;
  MessageBubble({required this.messagesender,required this.messagetext,required this.isMe});

  @override
  Widget build(BuildContext context){
    return Padding(
      padding: EdgeInsets.all(8.0),

      child: Column(
        crossAxisAlignment: isMe? CrossAxisAlignment.end:CrossAxisAlignment.start,
        children: [
          Text('$messagesender',
            style: TextStyle(
              color: Colors.black45,
              fontSize: 12.0,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: BorderRadius.only(
                topLeft: isMe? Radius.circular(30.0):Radius.circular(0.0),
                topRight: isMe? Radius.circular(0.0):Radius.circular(30.0),
                bottomLeft: Radius.circular(30.0),
                bottomRight: Radius.circular(30.0),
            ),
            color: isMe? Colors.lightBlueAccent:Colors.white,
            child : Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0,horizontal: 20.0),
              child: Text(
                '$messagetext',
                style: TextStyle(
                  color: isMe? Colors.white:Colors.black,
                  fontSize: 15.0,
                ),
              ),
            )
          ),
        ],
      ),
    );
  }
}