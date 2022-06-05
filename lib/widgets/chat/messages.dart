import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import './message_bubble.dart';

class Messages extends StatelessWidget {
  //const Messages({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FutureBuilder(
        future: FirebaseAuth.instance.currentUser(),
        builder: (ctx, futureSnapshot) {
          if (futureSnapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return StreamBuilder(
              stream: Firestore.instance
                  .collection('chat')
                  .orderBy(
                    'createdAt',
                    descending: true, //ustawia malejaco
                  )
                  .snapshots(),
              builder: (ctx, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatDocs = chatSnapshot.data.documents;
                if (chatDocs == null) {
                  return Text('No messages yet.');
                } else
                  return ListView.builder(
                    reverse: true,
                    itemCount: chatDocs.length,
                    itemBuilder: (ctx, index) => MessageBubble(
                      chatDocs[index]['text'],
                      chatDocs[index]['username'],
                      chatDocs[index]['image_url'],
                      chatDocs[index]['userId'] == futureSnapshot.data.uid,
                      key: ValueKey(chatDocs[index].documentID),
                    ),
                  );
              });
        });
  }
}
