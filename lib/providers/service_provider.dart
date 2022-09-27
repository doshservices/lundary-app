import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:laundry_app/config.dart' as config;
import 'package:laundry_app/models/cart.dart';
import 'package:laundry_app/models/http_exception.dart';
import 'package:laundry_app/models/notifications.dart';
import 'package:laundry_app/models/order.dart';
import 'package:laundry_app/models/service_model.dart';
import 'package:laundry_app/models/take_order.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ServiceProvider with ChangeNotifier {
  String token;
  String state = "";
  ServiceProvider(this.token, this.state);

  Future<void> setState(String st) async {
    state = st;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("location", state);
    notifyListeners();
  }

  Future<void> getState() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey("location")) {
      state = "LAGOS";
    } else {
      String extractedLocation = prefs.getString("location");
      state = extractedLocation;
    }

    notifyListeners();
  }

  Future<List<ServiceModel>> fetchServiceProviders(
      String category, String type) async {
    String url =
        "${config.baseUrl}/services?state=$state&category=$category&type=$type";
    print("JHJJH");
    try {
      List<ServiceModel> services = [];
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
      List<dynamic> entities = resData["data"]["services"];
      entities.forEach((entity) {
        ServiceModel service = ServiceModel();
        service.id = entity['_id'];
        service.category = entity["category"];
        service.image = entity["image"];
        service.name = entity["name"];
        service.price = double.parse(entity["price"].toString());
        service.state = entity["state"];

        services.add(service);
      });

      return services;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> createSpecialOrder({
    String userId,
    String addressId,
    String pickupDate,
    // String pickupTime,
    // String deliveryDate,
    // String deliveryTime,
  }) async {
    var data;

    data = jsonEncode({
      "userId": userId,
      "addressId": addressId,
      "pickupDate": pickupDate,
      "pickupTime": " ",
      "deliveryDate": " ",
      "deliveryTime": " ",
      "isSpecialOrder": "YES",
    });

    try {
      final response = await http.post(
        "${config.baseUrl}/orders",
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

  Future<Map<String, dynamic>> createOrder({
    String userId,
    String addressId,
    String pickupDate,
    // String pickupTime,
    // String deliveryDate,
    // String deliveryTime,
    String paymentType,
    TakeOrderModel order,
    double price,
    List<CartModel> carts,
  }) async {
    var data;
    List<Map<String, dynamic>> items = carts
        .map((e) => {
              "name": e.productName,
              "quantity": e.productQuantity,
              "totalPrice": e.productTotalPrice
            })
        .toList();
    if (order.isIroning) {
      items.add({
        "name": "Ironing & Folding",
        "totalPrice": 500,
      });
    }
    if (order.extraStarch) {
      items.add({
        "name": "Extra Starch",
        "totalPrice": 500,
      });
    }
    if (order.express) {
      items.add({
        "name": "Extra Starch",
        "totalPrice": price * 2,
      });
    }
    data = jsonEncode({
      "userId": userId,
      "addressId": addressId,
      "pickupDate": pickupDate,
      "pickupTime": " ",
      "deliveryDate": " ",
      "deliveryTime": " ",
      "isSpecialOrder": "NO",
      "isLightStarch": order.selectedStarch == "light" ? true : false,
      "isHeavyStarch": order.selectedStarch == "heavy" ? true : false,
      "noStarch": order.selectedStarch == "none" ? true : false,
      // "ironingAndFolding": order.isIroning ? "YES" : "NO",
      "extraStarch": order.extraStarch ? "YES" : "NO",
      "express": order.express ? "YES" : "NO",
      "totalPrice": price,
      "paymentMethod": paymentType,
      "items": items
    });

    try {
      final response = await http.post(
        "${config.baseUrl}/orders",
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
      Map<String, dynamic> values = {};
      values["orderNumber"] = resData["data"]["orderNumber"];
      values["referenceNumber"] = resData["data"]["referenceNumber"];
      values["confirmationUrl"] = resData["data"]["confirmationUrl"];
      return values;
    } catch (error) {
      throw error;
    }
  }

  Future<List<NotificationModel>> fetchNotifications() async {
    String url = "${config.baseUrl}/orders/all/notifications";
    print("JHJJH");
    try {
      List<NotificationModel> notifications = [];
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
      List<dynamic> entities = resData["data"];
      entities.forEach((entity) {
        NotificationModel notification = NotificationModel();
        notification.id = entity["_id"];
        notification.createdAt = entity["createdAt"];
        notification.message = entity["message"];
        notification.title = entity["title"];
        notification.orderNumber = entity["orderId"]["orderNumber"];
        notification.orderStatus = entity["orderId"]["orderStatus"];

        notifications.add(notification);
      });

      return notifications;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List<OrderModel>> fetchSpecialOrders() async {
    String url = "${config.baseUrl}/orders/all/by-status?isSpecialOrder=YES";
    print("JHJJH");
    try {
      List<OrderModel> orders = [];
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
      List<dynamic> entities = resData["data"];
      entities.forEach((entity) {
        OrderModel order = OrderModel();
        order.id = entity["_id"];
        order.orderNumber = entity["orderNumber"];
        order.orderStatus = entity["orderStatus"];
        order.pickupDate = entity["pickupDate"];
        order.pickupTime = entity["pickupTime"];
        order.deliveryDate = entity["deliveryDate"];
        order.deliveryTime = entity["deliveryTime"];

        orders.add(order);
      });

      return orders;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List<OrderModel>> fetchConfirmedOrders() async {
    String url =
        "${config.baseUrl}/orders/all/by-status?orderStatus=DELIVERED&isSpecialOrder=NO";
    print("JHJJH");
    try {
      List<OrderModel> orders = [];
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
      List<dynamic> entities = resData["data"];
      entities.forEach((entity) {
        OrderModel order = OrderModel();
        order.id = entity["_id"];
        order.orderNumber = entity["orderNumber"];
        order.orderStatus = entity["orderStatus"];
        order.pickupDate = entity["pickupDate"];
        order.pickupTime = entity["pickupTime"];
        order.deliveryDate = entity["deliveryDate"];
        order.deliveryTime = entity["deliveryTime"];
        order.totalPrice = entity["totalPrice"] != null
            ? double.parse(entity["totalPrice"].toString())
            : null;
        List<dynamic> items = entity["items"] != null ? entity["items"] : [];
        List<CartModel> cartItems = [];
        items.forEach((element) {
          CartModel item = CartModel();
          item.productName = element["name"];
          item.productTotalPrice = element["totalPrice"] != null
              ? double.parse(element["totalPrice"].toString())
              : null;
          item.productQuantity = element["quantity"];
          // item.productPrice = element["amount"] != null
          //     ? double.parse(element["amount"].toString())
          //     : null;
          cartItems.add(item);
        });
        order.items = cartItems;

        orders.add(order);
      });

      return orders;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List<OrderModel>> fetchProcessingOrders() async {
    String url = "${config.baseUrl}/orders/all/by-status?isSpecialOrder=NO";
    print("JHJJH");
    try {
      List<OrderModel> orders = [];
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
      List<dynamic> entities = resData["data"];
      entities.forEach((entity) {
        print("1234 " + entity["orderStatus"].toString());
        OrderModel order = OrderModel();
        order.id = entity["_id"];
        order.orderNumber = entity["orderNumber"];
        order.orderStatus = entity["orderStatus"];
        order.pickupDate = entity["pickupDate"];
        order.pickupTime = entity["pickupTime"];
        order.deliveryDate = entity["deliveryDate"];
        order.deliveryTime = entity["deliveryTime"];
        order.totalPrice = entity["totalPrice"] != null
            ? double.parse(entity["totalPrice"].toString())
            : null;
        List<dynamic> items = entity["items"] != null ? entity["items"] : [];
        List<CartModel> cartItems = [];
        items.forEach((element) {
          CartModel item = CartModel();
          item.productName = element["name"];
          item.productTotalPrice = element["totalPrice"] != null
              ? double.parse(element["totalPrice"].toString())
              : null;
          item.productQuantity = element["quantity"];
          // item.productPrice = element["amount"] != null
          //     ? double.parse(element["amount"].toString())
          //     : null;
          cartItems.add(item);
        });
        order.items = cartItems;
        if (entity["orderStatus"] == "DELIVERED") {
        } else {
          orders.add(order);
        }
      });

      return orders;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<List<OrderModel>> fetchActiveOrders() async {
    String url =
        "${config.baseUrl}/orders/all/by-status?orderStatus=IN_PROCESS&isSpecialOrder=NO";
    print("JHJJH");
    try {
      List<OrderModel> orders = [];
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
      List<dynamic> entities = resData["data"];
      entities.forEach((entity) {
        OrderModel order = OrderModel();
        order.id = entity["_id"];
        order.orderNumber = entity["orderNumber"];
        order.orderStatus = entity["orderStatus"];
        order.pickupDate = entity["pickupDate"];
        order.pickupTime = entity["pickupTime"];
        order.deliveryDate = entity["deliveryDate"];
        order.deliveryTime = entity["deliveryTime"];
        order.totalPrice = entity["totalPrice"] != null
            ? double.parse(entity["totalPrice"].toString())
            : null;
        List<dynamic> items = entity["items"] != null ? entity["items"] : [];
        List<CartModel> cartItems = [];
        items.forEach((element) {
          CartModel item = CartModel();
          item.productName = element["name"];
          item.productTotalPrice = element["totalPrice"] != null
              ? double.parse(element["totalPrice"].toString())
              : null;
          item.productQuantity = element["quantity"];
          // item.productPrice = element["amount"] != null
          //     ? double.parse(element["amount"].toString())
          //     : null;
          cartItems.add(item);
        });
        order.items = cartItems;
        if (entity["orderStatus"] == "DELIVERED") {
        } else {
          orders.add(order);
        }
      });

      return orders;
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> verifyOrder(String ref) async {
    String url = "${config.baseUrl}/orders/verify/$ref";
    print("JHJJH");
    try {
      final response = await http.get(
        url,
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $token"
        },
      );
      var resData = jsonDecode(response.body.toString());
      if (response.statusCode != 200) {
        print(resData["message"].toString());
        throw HttpException(resData["message"].toString());
      }
    } catch (error) {
      print(error);
      throw error;
    }
  }
}
