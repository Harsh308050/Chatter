import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helper/my_data_util.dart';

import 'package:chat_app/models/chat_user.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ViewProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ViewProfileScreen({super.key, required this.user});

  @override
  State<ViewProfileScreen> createState() => _ViewProfileScreenState();
}

class _ViewProfileScreenState extends State<ViewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        floatingActionButton: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Joined At: ",
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              MyDateUtil.getLastMessageTime(
                  context: context,
                  time: widget.user.createdAt,
                  showYear: true),
              style: const TextStyle(color: Colors.black54, fontSize: 18),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: size.height * .02),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: size.width,
                  height: size.height * .03,
                ),
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(size.height * .3),
                      child: CachedNetworkImage(
                        width: size.height * .2,
                        height: size.height * .2,
                        fit: BoxFit.cover,
                        imageUrl: widget.user.image,
                        errorWidget: (context, url, error) =>
                            const Icon(CupertinoIcons.person),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: size.height * .03,
                ),
                Text(
                  widget.user.email,
                  style: const TextStyle(color: Colors.black87, fontSize: 16),
                ),
                SizedBox(
                  height: size.height * .02,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "About: ",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.user.about,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 18),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Current Status: ",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.user.isOnline == 'true' ? 'Online' : 'Offline',
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 18),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        //appbar
        appBar: AppBar(
          title: Text(
            widget.user.name,
          ),
        ),
      ),
    );
  }

  //to pick profile image
}
