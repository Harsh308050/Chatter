import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/API/APIs.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/widgets/dialog/ProfileDialog.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../Screens/ChatScreen.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({super.key, required this.user});

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 6, vertical: 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.blueAccent[100],
      elevation: 0.5,
      child: InkWell(
          onTap: () {
            //to navigate to chat screen
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ChatScreen(
                          user: widget.user,
                        )));
          },
          child: StreamBuilder(
            stream: APIs.getLastMessage(widget.user),
            builder: (context, snapshot) {
              return ListTile(
                  leading: InkWell(
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (_) => ProfileDialog(
                                user: widget.user,
                              ));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size.height * .3),
                      child: CachedNetworkImage(
                        fit: BoxFit.cover,
                        width: size.height * .055,
                        height: size.height * .055,
                        imageUrl: widget.user.image,
                        errorWidget: (context, url, error) =>
                            Icon(CupertinoIcons.person),
                      ),
                    ),
                  ),
                  title: Text(widget.user.name),
                  subtitle: Text(
                    widget.user.about,
                    maxLines: 1,
                  ),
                  trailing: widget.user.isOnline == 'true'
                      ? Container(
                          width: 15,
                          height: 15,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(12)))
                      : Container(
                          width: 15,
                          height: 15,
                        )
                  // trailing: Text(
                  //   '10:10 PM',
                  //   style: TextStyle(color: Colors.black54),
                  // ),
                  );
            },
          )),
    );
  }
}
