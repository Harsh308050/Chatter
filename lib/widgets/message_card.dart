import 'package:chat_app/API/APIs.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/helper/my_data_util.dart';
import 'package:chat_app/models/message.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../main.dart';

class MessageCard extends StatefulWidget {
  const MessageCard({super.key, required this.message});
  final Message message;

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    bool isMe = APIs.user.uid == widget.message.fromId;
    return InkWell(
      onTap: () {
        _showBottomSheet(isMe);
      },
      child: isMe ? _greenMessage() : _blueMessage(),
    );
  }

  //other's Msg
  Widget _blueMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: const Color.fromARGB(255, 221, 245, 255),
                border: Border.all(color: Colors.blue, width: 2),
                //for making border curve
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomRight: Radius.circular(28),
                )),
            padding: EdgeInsets.all(widget.message.msg == Type.image
                ? size.width * .04
                : size.width * .025),
            margin: EdgeInsets.symmetric(
                horizontal: size.width * .04, vertical: size.height * .01),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      // width: size.height * .05,
                      // height: size.height * .05,
                      placeholder: (context, url) => const Center(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )),
                      imageUrl: widget.message.msg,
                      errorWidget: (context, url, error) => const Icon(
                        CupertinoIcons.photo_fill,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
        Padding(
          padding: EdgeInsets.only(right: size.width * .05),
          child: Text(
            MyDateUtil.getFormattedTime(
                context: context, time: widget.message.sent),
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
        ),
      ],
    );
  }

  //our Msg
  Widget _greenMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: size.width * .04,
            ),
            //double tick blue for msg read
            if (widget.message.read.isNotEmpty)
              const Icon(
                Icons.done_all_rounded,
                color: Colors.blue,
                size: 20,
              ),
            const SizedBox(
              width: 2,
            ),
            //sent time
            Text(
              MyDateUtil.getFormattedTime(
                  context: context, time: widget.message.sent),
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ],
        ),
        Flexible(
          child: Container(
            decoration: BoxDecoration(
                color: Colors.lightGreen[100],
                border: Border.all(color: Colors.green, width: 2),
                //for making border curve
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                  bottomLeft: Radius.circular(28),
                )),
            padding: EdgeInsets.all(widget.message.msg == Type.image
                ? size.width * .04
                : size.width * .025),
            margin: EdgeInsets.symmetric(
                horizontal: size.width * .04, vertical: size.height * .01),
            child: widget.message.type == Type.text
                ? Text(
                    widget.message.msg,
                    style: const TextStyle(fontSize: 16, color: Colors.black87),
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      // width: size.height * .05,
                      // height: size.height * .05,
                      placeholder: (context, url) => const Center(
                          child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )),
                      imageUrl: widget.message.msg,
                      errorWidget: (context, url, error) => const Icon(
                        CupertinoIcons.photo_fill,
                        size: 70,
                      ),
                    ),
                  ),
          ),
        ),
      ],
    );
  }

  void _showBottomSheet(bool isMe) {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.blue[50],
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            children: [
              Container(
                  height: 4,
                  margin: EdgeInsets.symmetric(
                      horizontal: size.width * .4,
                      vertical: size.height * .015),
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(5))),
              if (widget.message.type == Type.text)
                _OptionItem(
                    icon: Icon(
                      Icons.copy,
                      color: Colors.blue,
                      size: 26,
                    ),
                    name: 'Copy Text',
                    onTap: () async {
                      await Clipboard.setData(
                              ClipboardData(text: widget.message.msg))
                          .then((value) {
                        Navigator.pop(context);
                        dialogs.showSnackBar(context, 'Text Copied!');
                      });
                    }),
              Divider(
                color: Colors.black,
                endIndent: size.width * .04,
                indent: size.width * .04,
              ),
              _OptionItem(
                  icon: Icon(
                    Icons.remove_red_eye,
                    color: Colors.blue,
                    size: 26,
                  ),
                  name:
                      'Sent At: ${MyDateUtil.getMessageTime(context: context, time: widget.message.sent)}',
                  onTap: () {}),
            ],
          );
        });
  }

  void _showMessageUpdateDialog() {
    String updatedMsg = widget.message.msg;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            contentPadding:
                EdgeInsets.only(top: 20, bottom: 8, left: 24, right: 24),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: Row(
              children: [
                Icon(
                  Icons.message,
                  color: Colors.blue,
                  size: 28,
                ),
                Text(
                  '  Update Message',
                  style: TextStyle(
                      color: Colors.blue,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5),
                )
              ],
            ),
            content: TextFormField(
              initialValue: updatedMsg,
              maxLines: null,
              onChanged: (value) => updatedMsg = value,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15))),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              ),
              MaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                  APIs.updateMessage(widget.message, updatedMsg);
                },
                child: Text(
                  'Update',
                  style: TextStyle(color: Colors.blue, fontSize: 16),
                ),
              )
            ],
          );
        });
  }
}

class _OptionItem extends StatelessWidget {
  final Icon icon;
  final String name;
  final VoidCallback onTap;

  const _OptionItem(
      {required this.icon, required this.name, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(
            left: size.width * .05,
            top: size.height * .015,
            bottom: size.height * .02),
        child: Row(children: [
          icon,
          Flexible(
              child: Text(
            '    $name',
            style: TextStyle(
                fontSize: 17, color: Colors.black54, letterSpacing: 0.5),
          ))
        ]),
      ),
    );
  }
}
