import 'package:flutter/material.dart';
import 'package:laundry_app/models/user_model.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:laundry_app/utils/custom_textformfield.dart';
import 'package:laundry_app/utils/rounded_raisedbutton.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:image_picker_gallery_camera/image_picker_gallery_camera.dart';
import 'package:cloudinary_sdk/cloudinary_sdk.dart';
import 'dart:io';

class AccountInfoScreen extends StatefulWidget {
  @override
  _AccountInfoScreenState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends State<AccountInfoScreen> {
  bool _isInit = true;
  UserModel user = UserModel();
  GlobalKey<FormState> _formKey = GlobalKey();
  bool _isLoading = false;
  bool _isUploadingProfilePicture = false;
  bool _isLocalProfilePicture = false;

  File _image;
  var base64Image;
  String tempBase64Image;

  // final cloudinary =
  //     Cloudinary("579251194598375", "mURSzkqRNR8_JHjuPJKjMjX3wK0", "dasek9hic");
  // final response = await cloudinary.uploadFile(
  //     filePath: _image.path,
  //     resourceType: CloudinaryResourceType.image,
  //     folder: 'image',
  //   );
  //   if (response.isSuccessful ?? false)
  //     setState(() {
  //       final String imag1 = response.secureUrl;
  //       print(imag1);
  //       postFiles.add('$imag1');
  //       print(postFiles.length);
  //     });

  // Future getImagechris(ImgSource source) async {
  //   var image = await ImagePickerGC.pickImage(
  //     context: context,
  //     source: source,
  //     maxHeight: 400,
  //     maxWidth: 300,
  //     imageQuality: 100,
  //     cameraIcon: Icon(
  //       Icons.add,
  //       color: Colors.red,
  //     ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
  //   );
  // }

  Future getImage(ImgSource source) async {
    var image = await ImagePickerGC.pickImage(
      context: context,
      source: source,
      maxHeight: 150,
      maxWidth: 150,

      cameraIcon: Icon(
        Icons.add,
        color: Colors.red,
      ), //cameraIcon and galleryIcon can change. If no icon provided default icon will be present
    );
    setState(() {
      _image = File(image.path);
      base64Image = base64Encode(_image.readAsBytesSync());
      _isUploadingProfilePicture = true;
      _isLocalProfilePicture = true;
    });
    try {
      final cloudinary = Cloudinary(
          "579251194598375", "mURSzkqRNR8_JHjuPJKjMjX3wK0", "dasek9hic");

      final response = await cloudinary.uploadFile(
        filePath: _image.path,
        resourceType: CloudinaryResourceType.image,
        folder: 'image',
      );
      String imag1 = "";
      if (response.isSuccessful ?? false) imag1 = response.secureUrl;
      await Provider.of<Auth>(context, listen: false)
          .uploadProfilePicture(url: imag1);
      await Provider.of<Auth>(context, listen: false).fetchProfile();
      Get.snackbar('Success!', 'Profile picture updated',
          barBlur: 0,
          dismissDirection: SnackDismissDirection.VERTICAL,
          backgroundColor: Colors.green,
          overlayBlur: 0,
          animationDuration: Duration(milliseconds: 500),
          duration: Duration(seconds: 2));
    } catch (error) {
      Get.snackbar('Error!', '${error.toString()}',
          barBlur: 0,
          dismissDirection: SnackDismissDirection.VERTICAL,
          backgroundColor: Colors.red,
          overlayBlur: 0,
          animationDuration: Duration(milliseconds: 500),
          duration: Duration(seconds: 2));
    } finally {
      setState(() {
        _isUploadingProfilePicture = false;
      });
    }
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (_isInit) {
      try {
        user = await Provider.of<Auth>(context, listen: false).fetchProfile();
      } catch (error) {
        Get.snackbar('Error!', '${error.toString()}',
            barBlur: 0,
            dismissDirection: SnackDismissDirection.VERTICAL,
            backgroundColor: Colors.red,
            overlayBlur: 0,
            animationDuration: Duration(milliseconds: 500),
            duration: Duration(seconds: 2));
      } finally {
        setState(() {
          _isInit = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account Info"),
        centerTitle: true,
      ),
      body: _isInit
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //
                          Container(
                            height: MediaQuery.of(context).size.height * 0.2,
                            // color: Colors.white,
                            width: double.infinity,
                            child: Center(
                              child: GestureDetector(
                                onTap: () {
                                  getImage(ImgSource.Both);
                                },
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.05,
                                        ),
                                        CircleAvatar(
                                          backgroundColor:
                                              Colors.grey.withOpacity(0.2),
                                          radius: 30,
                                          backgroundImage: _isLocalProfilePicture
                                              ? FileImage(_image)
                                              : NetworkImage(
                                                  "${user.profilePhoto != null ? user.profilePhoto : ''}"),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Tap to change picture",
                                          style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                    _isUploadingProfilePicture
                                        ? Positioned.fill(
                                            child: Align(
                                            alignment: Alignment.center,
                                            child: Container(
                                                width: 20,
                                                height: 20,
                                                child:
                                                    CircularProgressIndicator()),
                                          ))
                                        : Text(""),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextFormField(
                                          labelText: "First name",
                                          initialValue: user.firstName,
                                          icon: Icon(Icons.person_outline,
                                              color: Colors.black),
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Firstname required";
                                            }
                                          },
                                          onSaved: (value) {
                                            user.firstName = value;
                                          },
                                        ),
                                      ),
                                      SizedBox(width: 20),
                                      Expanded(
                                        child: CustomTextFormField(
                                          labelText: "Last name",
                                          initialValue: user.lastName,
                                          validator: (value) {
                                            if (value.isEmpty) {
                                              return "Lastname required";
                                            }
                                          },
                                          onSaved: (value) {
                                            user.lastName = value;
                                          },

                                          // icon: Icon(Icons.person_outline,
                                          //     color: Colors.black),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  CustomTextFormField(
                                    labelText: "Phone number",
                                    keyboardType: TextInputType.number,
                                    initialValue: user.phoneNumber,
                                    icon: Icon(Icons.phone_outlined,
                                        color: Colors.black),
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return "Phone number required";
                                      }
                                    },
                                    onSaved: (value) {
                                      user.phoneNumber = value;
                                    },
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  CustomTextFormField(
                                    labelText: "Email address",
                                    initialValue: user.email,
                                    enabled: false,
                                    icon: Icon(Icons.email_outlined,
                                        color: Colors.black),
                                  ),
                                  SizedBox(
                                    height: 20,
                                  ),
                                  // CustomTextFormField(
                                  //   labelText: "Password",
                                  //   icon: Image.asset(
                                  //     "assets/images/lock.png",
                                  //     width: 25,
                                  //     color: Colors.black,
                                  //   ),
                                  //   suffixIcon: Icon(
                                  //     Icons.visibility_off,
                                  //     color: Colors.black,
                                  //   ),
                                  //   obscureText: true,
                                  // ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: RoundedRaisedButton(
                      title: "Save",
                      isLoading: _isLoading,
                      onPress: () async {
                        try {
                          if (!_formKey.currentState.validate()) {
                            return;
                          }
                          _formKey.currentState.save();
                          setState(() {
                            _isLoading = true;
                          });
                          await Provider.of<Auth>(context, listen: false)
                              .updateUser(user);

                          Navigator.of(context).pop(true);

                          Get.snackbar('Success!', 'User updated successfully',
                              barBlur: 0,
                              dismissDirection: SnackDismissDirection.VERTICAL,
                              backgroundColor: Colors.green,
                              overlayBlur: 0,
                              animationDuration: Duration(milliseconds: 500),
                              duration: Duration(seconds: 2));
                        } catch (error) {
                          Get.snackbar('Error!', '${error.toString()}',
                              barBlur: 0,
                              dismissDirection: SnackDismissDirection.VERTICAL,
                              backgroundColor: Colors.red,
                              overlayBlur: 0,
                              animationDuration: Duration(milliseconds: 500),
                              duration: Duration(seconds: 2));
                        } finally {
                          setState(() {
                            _isLoading = false;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
