import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/Screens/ViewProfileScreen.dart';
import 'package:chat_app/helper/my_data_util.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:chat_app/models/message.dart';
import 'package:chat_app/widgets/message_card.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../API/APIs.dart';
import '../main.dart';

class ChatScreen extends StatefulWidget {
  final ChatUser user;
  const ChatScreen({super.key, required this.user});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //to store messages
  List<Message> list = [];
  bool _showEmoji = false;
  bool isUploading = false;

  //to handle message changes
  final TextEditingController _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: SafeArea(
        child: WillPopScope(
          onWillPop: () {
            if (_showEmoji) {
              setState(() {
                _showEmoji = !_showEmoji;
              });
              return Future.value(false);
            } else {
              return Future.value(true);
            }
          },
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 234, 248, 255),
            appBar: AppBar(
              automaticallyImplyLeading: false,
              flexibleSpace: _appBar(),
            ),
            body: Column(children: [
              Expanded(
                child: StreamBuilder(
                    stream: APIs.getAllMessages(widget.user),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return const SizedBox();
                        case ConnectionState.active:
                        case ConnectionState.done:
                          final data = snapshot.data?.docs;

                          list = data
                                  ?.map((e) => Message.fromJson(e.data()))
                                  .toList() ??
                              [];

                          if (list.isNotEmpty) {
                            return ListView.builder(
                                reverse: true,
                                itemCount: list.length,
                                padding: const EdgeInsets.only(top: 5),
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return MessageCard(
                                    message: list[index],
                                  );
                                });
                          } else {
                            return const Center(
                                child: Text(
                              "Say Hii 😄👋",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ));
                          }
                      }
                    }),
              ),
              if (isUploading)
                const Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 25, vertical: 8),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )),
              _chatInput(),
              const SizedBox(
                height: 10,
              ),
              if (_showEmoji)
                SizedBox(
                  height: size.height * .35,
                  child: EmojiPicker(
                    textEditingController: _textController,
                    config: Config(
                      bgColor: const Color.fromARGB(255, 234, 248, 255),
                      columns: 8,
                      initCategory: Category.SMILEYS,
                      emojiSizeMax: 32 * (Platform.isIOS ? 1.30 : 1.0),
                    ),
                  ),
                )
            ]),
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => ViewProfileScreen(user: widget.user)));
        },
        child: StreamBuilder(
          stream: APIs.getUserInfo(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list =
                data?.map((e) => ChatUser.fromJson(e.data())).toList() ?? [];

            return Row(
              children: [
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color.fromARGB(255, 247, 247, 247),
                    )),
                const SizedBox(
                  width: 5,
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(size.height * .3),
                  child: CachedNetworkImage(
                    fit: BoxFit.cover,
                    width: size.height * .05,
                    height: size.height * .05,
                    imageUrl:
                        list.isNotEmpty ? list[0].image : widget.user.image,
                    errorWidget: (context, url, error) =>
                        const Icon(CupertinoIcons.person),
                  ),
                ),
                const SizedBox(
                  width: 15,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      list.isNotEmpty ? list[0].name : widget.user.name,
                      style: const TextStyle(
                          letterSpacing: 1,
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 1,
                    ),
                    Text(
                      widget.user.isOnline == 'true'
                          ? 'Online'
                          : MyDateUtil.getLastActiveTime(
                              context: context,
                              lastActive: widget.user.lastActive),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    )
                  ],
                )
              ],
            );
          },
        ));
  }

  Widget _chatInput() {
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: size.height * .01, horizontal: size.width * .020),
      child: Row(
        children: [
          Expanded(
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Row(
                children: [
                  //emojiButton
                  IconButton(
                      onPressed: () {
                        setState(() {
                          FocusScope.of(context).unfocus();
                          _showEmoji = !_showEmoji;
                        });
                      },
                      icon: const Icon(
                        Icons.emoji_emotions,
                        size: 28,
                        color: Color.fromARGB(146, 0, 110, 255),
                      )),
                  Expanded(
                      child: TextField(
                          onTap: () {
                            if (_showEmoji)
                              setState(() {
                                _showEmoji = !_showEmoji;
                              });
                          },
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          style: const TextStyle(color: Colors.blue),
                          decoration: const InputDecoration(
                              hintText: 'Type Something..',
                              border: InputBorder.none,
                              hintStyle: TextStyle(
                                color: Colors.blue,
                              )),
                          controller: _textController)),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick Multiple images.
                        final List<XFile> images =
                            await picker.pickMultiImage(imageQuality: 80);

                        for (var i in images) {
                          log('Image Path::---${i.path}');
                          setState(() {
                            isUploading = true;
                          });
                          await APIs.sendChatImage(widget.user, File(i.path));
                          setState(() {
                            isUploading = false;
                          });
                        }
                      },
                      icon: const Icon(
                        //Icons.image,
                        CupertinoIcons.photo, size: 28,
                        color: Color.fromARGB(146, 0, 110, 255),
                      )),
                  IconButton(
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 80);
                        if (image != null) {
                          log('Image Path::---${image.path}');
                          setState(() {
                            isUploading = true;
                          });
                          APIs.sendChatImage(widget.user, File(image.path));
                          setState(() {
                            isUploading = false;
                          });
                        }
                      },
                      icon: const Icon(
                        CupertinoIcons.camera_fill,
                        size: 28,
                        color: Color.fromARGB(146, 0, 110, 255),
                      )),
                  SizedBox(
                    width: size.width * .02,
                  )
                ],
              ),
            ),
          ),

          MaterialButton(
            minWidth: 0,
            padding:
                const EdgeInsets.only(top: 10, bottom: 10, right: 5, left: 10),
            shape: const CircleBorder(),
            color: Colors.green,
            onPressed: () {
              if (_textController.text.isNotEmpty) {
                if (list.isEmpty) {
                  APIs.sendFirstMessage(
                      widget.user, _textController.text, Type.text);
                } else {
                  APIs.sendMessage(
                      widget.user, _textController.text, Type.text);
                }

                _textController.text = '';
              }
            },
            child: const Icon(
              Icons.send_rounded,
              color: Colors.white,
            ),
          ),

          // SizedBox(
          //   width: 10,
          // )
        ],
      ),
    );
  }
}
