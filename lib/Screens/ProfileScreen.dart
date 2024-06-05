import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/helper/dialogs.dart';
import 'package:chat_app/models/chat_user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../API/APIs.dart';
import '../main.dart';

class ProfileScreen extends StatefulWidget {
  final ChatUser user;
  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final key = GlobalKey<FormState>();
  String? _image;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        body: Form(
          key: key,
          child: Padding(
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
                      //Profile Picture
                      _image != null
                          //local image
                          ? ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(size.height * .3),
                              child: Image.file(
                                File(_image!),
                                width: size.height * .2,
                                height: size.height * .2,
                                fit: BoxFit.cover,
                              ),
                            )
                          //image from db
                          : ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(size.height * .3),
                              child: CachedNetworkImage(
                                width: size.height * .2,
                                height: size.height * .2,
                                fit: BoxFit.cover,
                                imageUrl: widget.user.image,
                                errorWidget: (context, url, error) =>
                                    const Icon(CupertinoIcons.person),
                              ),
                            ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: MaterialButton(
                          elevation: 3,
                          onPressed: () {
                            _showBottomSheet();
                          },
                          padding: const EdgeInsets.all(8),
                          color: Colors.white,
                          shape: CircleBorder(),
                          child: Icon(
                            Icons.edit,
                            color: Colors.blue,
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: size.height * .03,
                  ),
                  Text(
                    widget.user.email,
                    style: const TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                  SizedBox(
                    height: size.height * .03,
                  ),
                  TextFormField(
                      onSaved: (val) => APIs.me.name = val ?? '',
                      initialValue: widget.user.name,
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.person,
                          color: Colors.blue,
                        ),
                        hintText: "eg. Harsh Parmar",
                        label: Text(
                          "Name",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      )),
                  SizedBox(
                    height: size.height * .03,
                  ),
                  TextFormField(
                      initialValue: widget.user.about,
                      onSaved: (val) => APIs.me.about = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : "Required Field",
                      decoration: const InputDecoration(
                        prefixIcon: Icon(
                          Icons.info_outlined,
                          color: Colors.blue,
                        ),
                        hintText: "eg. Happy",
                        label: Text(
                          "About",
                          style: TextStyle(color: Colors.black, fontSize: 18),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                      )),
                  SizedBox(
                    height: size.height * .05,
                  ),
                  ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(146, 0, 110, 255),
                        shape: ContinuousRectangleBorder(
                            borderRadius: BorderRadius.circular(18)),
                        minimumSize:
                            Size(size.width / 2.5, size.height / 6 - 80),
                      ),
                      onPressed: () {
                        if (key.currentState!.validate()) {
                          key.currentState!.save();
                          APIs.updateUserInfo().then((value) {
                            dialogs.showSnackBar(
                                context, 'Profile Updated Successfully');
                          });
                        }
                      },
                      icon: Icon(
                        Icons.upload,
                        size: 28,
                      ),
                      label: Text(
                        'Update',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      )),
                  //logout
                ],
              ),
            ),
          ),
        ),

        //appbar
        appBar: AppBar(
          title: const Text(
            "Profile Screen",
          ),
        ),

        //floating action button
      ),
    );
  }

  //to pick profile image
  void _showBottomSheet() {
    showModalBottomSheet(
        context: context,
        backgroundColor: Colors.blue[50],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20), topRight: Radius.circular(20))),
        builder: (_) {
          return ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(
                top: size.height * .03, bottom: size.height * .05),
            children: [
              Text(
                'Pick Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: size.height * .02,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  //gallery
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: Colors.blue,
                          elevation: 1,
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(size.width * .3, size.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.gallery, imageQuality: 90);
                        if (image != null) {
                          log('Image Path::---${image.path}');
                          Navigator.pop(context);
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                        }
                      },
                      child: Image.asset(
                        'assets/images/add_image.png',
                      )),
                  //camera
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shadowColor: Colors.blue,
                          elevation: 1,
                          backgroundColor: Colors.white,
                          shape: const CircleBorder(),
                          fixedSize: Size(size.width * .3, size.height * .15)),
                      onPressed: () async {
                        final ImagePicker picker = ImagePicker();
                        // Pick an image.
                        final XFile? image = await picker.pickImage(
                            source: ImageSource.camera, imageQuality: 90);
                        if (image != null) {
                          log('Image Path::---${image.path}');
                          Navigator.pop(context);
                          setState(() {
                            _image = image.path;
                          });
                          APIs.updateProfilePicture(File(_image!));
                        }
                      },
                      child: Image.asset('assets/images/camera.png'))
                ],
              )
            ],
          );
        });
  }
}
