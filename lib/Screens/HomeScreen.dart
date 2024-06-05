import 'dart:developer';

import 'package:chat_app/Screens/ProfileScreen.dart';
import 'package:chat_app/widgets/chat_user_card.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../API/APIs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ChatUser> list = [];
  final List<ChatUser> _searchList = [];
  bool isSearching = false;
  @override
  void initState() {
    super.initState();
    APIs.getSelfInfo();

    SystemChannels.lifecycle.setMessageHandler((message) {
      log('message::----$message');
      if (APIs.auth.currentUser != null) {}
      return Future.value(message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: WillPopScope(
        onWillPop: () {
          if (isSearching) {
            setState(() {
              isSearching = !isSearching;
            });
            return Future.value(false);
          } else {
            return Future.value(true);
          }
        },
        child: Scaffold(
          body: StreamBuilder(
            stream: APIs.getMyUsersId(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.none:
                case ConnectionState.active:
                case ConnectionState.done:
                  return StreamBuilder(
                      stream: APIs.getAllUsers(
                          snapshot.data?.docs.map((e) => e.id).toList() ?? []),
                      builder: (context, snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.waiting:
                          case ConnectionState.none:
                            return const Center(
                                child: CircularProgressIndicator());
                          case ConnectionState.active:
                          case ConnectionState.done:
                            final data = snapshot.data?.docs;
                            list = data
                                    ?.map((e) => ChatUser.fromJson(e.data()))
                                    .toList() ??
                                [];

                            if (list.isNotEmpty) {
                              return ListView.builder(
                                  itemCount: isSearching
                                      ? _searchList.length
                                      : list.length,
                                  padding: const EdgeInsets.only(top: 5),
                                  physics: const BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    return ChatUserCard(
                                        user: isSearching
                                            ? _searchList[index]
                                            : list[index]);
                                  });
                            } else {
                              return const Center(
                                  child: Text(
                                "No Connections Found !!\n Tere To Yaha Bhi Connections Nahi Hai 😝",
                                style: TextStyle(
                                    color: Color.fromARGB(255, 0, 140, 255),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold),
                              ));
                            }
                        }
                      });
              }
            },
          ),
          appBar: AppBar(
            leading: isSearching
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isSearching = !isSearching;
                      });
                    },
                    icon: isSearching
                        ? const Icon(CupertinoIcons.arrow_left)
                        : const Icon(
                            Icons.search_outlined,
                          ))
                : null,
            centerTitle: false,
            title: isSearching
                ? TextField(
                    autofocus: true,
                    style: const TextStyle(
                        fontSize: 16,
                        letterSpacing: 1,
                        color: Color.fromARGB(255, 247, 247, 247)),
                    onChanged: (val) {
                      //search logic
                      _searchList.clear();
                      for (var i in list) {
                        if (i.name.toLowerCase().contains(val.toLowerCase()) ||
                            i.email.toLowerCase().contains(val.toLowerCase())) {
                          _searchList.add(i);
                        }
                        setState(() {
                          _searchList;
                        });
                      }
                    },
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 247, 247, 247)),
                      hintText: 'Name Or Email',
                    ),
                  )
                : Container(
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/images/icon.png',
                          width: 40,
                          height: 40,
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          "Let's Chat ",
                        ),
                      ],
                    ),
                  ),
            actions: [
              //search
              isSearching
                  ? const Icon(
                      Icons.search_outlined,
                    )
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          isSearching = !isSearching;
                        });
                      },
                      icon: const Icon(
                        Icons.search_outlined,
                      )),
              // more
              IconButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                                  user: APIs.me,
                                )));
                  },
                  icon: const Icon(
                    Icons.person,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
