import 'dart:convert';
import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:laundry_app/models/address_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/http_exception.dart';
import '../models/user_model.dart';

import '../config.dart' as config;

class Auth with ChangeNotifier {
  String _token;
  // String _accessTokenType;
  // DateTime _expiryDate;
  String _userId;
  String fullName, phoneNumber, userEmail;
  UserModel user = UserModel();

  bool get isAuth {
    return token != null;
  }

  String get token {
    if (_token != null) {
      return _token;
    }
    return null;
  }

  String get userId {
    if (_userId != null) {
      return _userId;
    }
    return null;
  }

  Future<void> signUp(UserModel registerModel, String otp) async {
    var data;

    data = jsonEncode({
      "email": registerModel.email,
      "firstName": registerModel.firstName,
      "lastName": registerModel.lastName,
      "phoneNumber": registerModel.phoneNumber,
      "otp": otp,
      "googleSigned": "false",
      "password": registerModel.password
    });

    try {
      final response = await http.post(
        "${config.baseUrl}/api/users",
        headers: {"content-type": "application/json"},
        body: data,
      );
      var resData = jsonDecode(response.body);

      print(response.statusCode);
      print(resData);
      if (response.statusCode != 200) {
        print(resData["message"]["message"].toString());
        throw HttpException(resData["message"]["message"].toString());
      }
    } catch (error) {
      print("error $error");
      throw error;
    }
  }

  Future<void> updateProfile(UserModel currentUser) async {
    var data;
    print(currentUser.email);
    if (currentUser.role == "INDIVIDUAL_USER") {
      data = jsonEncode({
        "phone": currentUser.phoneNumber,
        "role": currentUser.role,
        "individualUser": {
          // "fullName": currentUser.individualFullName,
        }
      });
    }

    if (currentUser.role == "COMPANY") {
      data = jsonEncode({
        "phone": currentUser.phoneNumber,
        "role": currentUser.role,
      });
    }

    try {
      final response = await http.put(
        "${config.baseUrl}/auth/users",
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: data,
      );

      var resData = jsonDecode(response.body);

      print(resData);
      if (resData["status"] != "ACTIVE") {
        throw HttpException(resData["message"]);
      }
    } on HttpException catch (error) {
      throw error;
    }
  }

  Future<void> signIn(String email, String password) async {
    var data = jsonEncode({
      "loginId": email.trim(),
      "password": password,
    });
    try {
      final response = await http.post(
        "${config.baseUrl}/api/users/login",
        headers: {"content-type": "application/json"},
        body: data,
      );

      var resData = jsonDecode(response.body);
      print(response.statusCode);
      print(resData);

      if (response.statusCode != 200) {
        throw HttpException(resData["message"]);
      }

      _token = resData["data"]["token"];

      user.id = resData["data"]["userDetails"]["_id"];

      user.email = resData["data"]["userDetails"]["email"];
      user.firstName = resData["data"]["userDetails"]["firstName"];
      user.lastName = resData["data"]["userDetails"]["lastName"];
      user.phoneNumber = resData["data"]["userDetails"]["phoneNumber"];
      user.profilePhoto = resData["data"]["userDetails"]["profilePictureUrl"];

      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': token,
        'id': user.id,
        'email': user.email,
        'firstName': user.firstName,
        'lastName': user.lastName,
        'phoneNumber': user.phoneNumber,
        'profilePhoto': user.profilePhoto,
      });
      print("we want");
      prefs.setString("userData", userData);
    } catch (error) {
      print("error $error");
      throw error;
    }
  }

  Future<void> sendOtp(String email) async {
    var data = jsonEncode({
      "email": email,
    });
    try {
      final response = await http.post(
        "${config.baseUrl}/api/send-token",
        headers: {"content-type": "application/json"},
        body: data,
      );

      var resData = jsonDecode(response.body);
      print(response.statusCode);
      print(resData);

      if (response.statusCode != 200) {
        throw HttpException(resData["message"]);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<String> forgotPassword(String email) async {
    var data = jsonEncode({
      "email": email.trim(),
    });
    try {
      final response = await http.post(
        "${config.baseUrl}/api/users/forgot-password",
        headers: {"content-type": "application/json"},
        body: data,
      );
      var resData = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(resData["message"]);
      }
      return resData["message"];
    } catch (error) {
      throw error;
    }
  }

  Future<String> forgotPasswordCompletion(
      String token, String newPassword) async {
    var data = jsonEncode({"token": token, "newPassword": newPassword});
    try {
      final response = await http.post(
        "${config.baseUrl}/api/users/reset-password",
        headers: {"content-type": "application/json"},
        body: data,
      );
      var resData = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(resData["message"]);
      }
      return resData["message"];
    } catch (error) {
      throw error;
    }
  }

  Future<String> changePassword(String oldPassword, String newPassword) async {
    var data =
        jsonEncode({"oldPassword": oldPassword, "newPassword": newPassword});
    try {
      final response = await http.post(
        "${config.baseUrl}/api/users/change-password",
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: data,
      );
      var resData = jsonDecode(response.body);
      if (response.statusCode != 200) {
        throw HttpException(resData["message"]);
      }
      return resData["message"];
    } catch (error) {
      throw error;
    }
  }

  Future<String> resendVerificationCode(String email) async {
    var data = jsonEncode({
      "email": email.trim(),
    });
    try {
      final response = await http.post(
        "${config.baseUrl}/users/$email/resend-email-verification-code",
        headers: {"content-type": "application/json"},
        body: data,
      );
      print(response.statusCode);

      var resData = jsonDecode(response.body);
      print(resData);
      if (response.statusCode != 200) {
        throw HttpException(resData["message"]);
      }
      return resData["message"];
    } catch (error) {
      throw error;
    }
  }

  Future<String> verifyEmail(String email, String code) async {
    var data = jsonEncode({"email": email.trim(), "code": code});
    try {
      final response = await http.post(
        "${config.baseUrl}/users/verify-email",
        headers: {"content-type": "application/json"},
        body: data,
      );
      print(response.statusCode);

      var resData = jsonDecode(response.body);
      print(resData);
      if (response.statusCode != 200) {
        throw HttpException(resData["message"]);
      }
      return resData["message"];
    } catch (error) {
      throw error;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await Future.delayed(Duration(milliseconds: 2000), () {
      if (!prefs.containsKey("userData")) {
        return false;
      }

      final extractedUserData = json.decode(prefs.getString("userData"));

      _token = extractedUserData["token"];
      user.id = extractedUserData["id"];
      user.email = extractedUserData["email"];
      user.firstName = extractedUserData["firstName"];
      user.lastName = extractedUserData["lastName"];
      user.phoneNumber = extractedUserData["phoneNumber"];
      user.profilePhoto = extractedUserData["profilePhoto"];
      notifyListeners();
      // _autoLogout();
      return true;
    });
  }

  Future<UserModel> fetchProfile() async {
    try {
      final response = await http.get(
        "${config.baseUrl}/api/users/${user.id}",
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      );

      var resData = jsonDecode(response.body);
      print(resData);
      print(response.statusCode);
      if (response.statusCode == 401) {
        throw HttpException("401");
      }

      if (response.statusCode != 200) {
        throw HttpException(resData["message"]);
      }

      user.phoneNumber = resData["data"]["user"]["phoneNumber"];
      user.email = resData["data"]["user"]["email"];
      user.firstName = resData["data"]["user"]["firstName"];
      user.lastName = resData["data"]["user"]["lastName"];

      user.profilePhoto = resData["data"]["user"]["profilePictureUrl"];
      user.id = resData["data"]["user"]["_id"];
      user.role = resData["data"]["user"]["role"];

      notifyListeners();
      return user;
    } catch (error) {
      throw error;
    }
  }

  Future<List<AddressModel>> fetchAddresses() async {
    String url = "${config.baseUrl}/address";
    print("JHJJH");
    try {
      List<AddressModel> addresses = [];
      final response = await http.get(
        url,
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      var resData = jsonDecode(response.body.toString());
      print(resData);
      print(response.statusCode);
      if (response.statusCode == 401) {
        throw HttpException("401");
      }
      List<dynamic> entities = resData["data"]["addresses"];
      entities.forEach((entity) {
        AddressModel address = AddressModel();
        address.id = entity['_id'];
        address.address = entity["address"];
        address.city = entity["city"];
        address.contact = entity["contact"];
        address.deliverTo = entity["deliverTo"];
        address.state = entity["state"];

        addresses.add(address);
      });

      return addresses;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> createAddress(AddressModel address) async {
    var data;

    data = jsonEncode({
      "state": address.state,
      "city": " ",
      "address": address.address,
      "contact": address.contact,
      "deliverTo": address.deliverTo
    });

    try {
      final response = await http.post(
        "${config.baseUrl}/address",
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: data,
      );
      var resData = jsonDecode(response.body);

      print(response.statusCode);
      print(resData);
      if (response.statusCode != 200) {
        print(resData["message"].toString());
        throw HttpException(resData["message"].toString());
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateAddress(AddressModel address) async {
    var data;

    data = jsonEncode({
      "state": address.state,
      "city": address.city,
      "address": address.address,
      "contact": address.contact,
      "deliverTo": address.deliverTo
    });

    try {
      final response = await http.put(
        "${config.baseUrl}/address/${address.id}",
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: data,
      );
      var resData = jsonDecode(response.body);

      print(response.statusCode);
      print(resData);
      if (response.statusCode != 200) {
        print(resData["message"].toString());
        throw HttpException(resData["message"].toString());
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> updateUser(UserModel userModel) async {
    var data;

    data = jsonEncode({
      "firstName": userModel.firstName,
      "lastName": userModel.lastName,
      "email": userModel.email,
      "phoneNumber": userModel.phoneNumber
    });

    try {
      final response = await http.put(
        "${config.baseUrl}/users",
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: data,
      );
      var resData = jsonDecode(response.body);
      print(resData.toString());

      print(response.statusCode);
      print(resData);
      if (response.statusCode != 200) {
        print(resData["message"].toString());
        throw HttpException(resData["message"].toString());
      }
      user.email = userModel.email;
      user.phoneNumber = userModel.phoneNumber;
      user.firstName = userModel.firstName;
      user.lastName = userModel.lastName;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> uploadProfilePicture({
    String url,
  }) async {
    var data;

    data = jsonEncode({
      "imageUrl": url,
    });
    try {
      final response = await http.put(
        "${config.baseUrl}/users/upload/user/image",
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: data,
      );
      // var resData = jsonDecode(response.body);

      print(response.body);

      if (response.statusCode != 200) {
        throw HttpException("Error Uploading Image");
      }

      notifyListeners();
    } catch (error) {
      print(error.toString());
      throw error;
    }
  }

  void logout() async {
    _token = null;
    _userId = "";
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("userData");
  }
}
