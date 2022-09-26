import 'package:flutter/material.dart';
import 'package:laundry_app/constants.dart';
import 'package:laundry_app/providers/auth.dart';
import 'package:laundry_app/providers/cart.dart';
import 'package:laundry_app/providers/service_provider.dart';
import 'package:laundry_app/screens/auth/otp_verification.dart';
import 'package:laundry_app/screens/auth/recover_password.dart';
import 'package:laundry_app/screens/auth/recover_password_token.dart';
import 'package:laundry_app/screens/auth/walkthrough.dart';
import 'package:laundry_app/screens/dashboard/account_info.dart';
import 'package:laundry_app/screens/dashboard/adds_on.dart';
import 'package:laundry_app/screens/dashboard/change_password.dart';
import 'package:laundry_app/screens/dashboard/dry_cleaning.dart';
import 'package:laundry_app/screens/dashboard/edit_location.dart';
import 'package:laundry_app/screens/dashboard/feedback.dart';
import 'package:laundry_app/screens/dashboard/make_payment.dart';
import 'package:laundry_app/screens/dashboard/mybag.dart';
import 'package:laundry_app/screens/dashboard/mylocations.dart';
import 'package:laundry_app/screens/dashboard/notifications.dart';
import 'package:laundry_app/screens/dashboard/order_detail.dart';
import 'package:laundry_app/screens/dashboard/privacy_policy.dart';
import 'package:laundry_app/screens/dashboard/refer.dart';
import 'package:laundry_app/screens/dashboard/schedule_pickup.dart';
import 'package:laundry_app/screens/dashboard/special_order.dart';
import 'package:laundry_app/screens/splashscreen.dart';
import 'package:laundry_app/screens/auth/login.dart';
import 'package:laundry_app/screens/auth/register.dart';
import 'package:laundry_app/screens/dashboard/dashboard.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ServiceProvider>(
          //this is what I want to try
          create: (ctx) => ServiceProvider('', ''),

          //original code present
          update: (ctx, auth, previousServiceProvider) {
            return ServiceProvider(
              auth.token,
              previousServiceProvider != null
                  ? previousServiceProvider.state
                  : "LAGOS",
            );
          },
        ),
        ChangeNotifierProxyProvider<Auth, CartProvider>(
          //this is what I want to try
          create: (ctx) => CartProvider('', {}, 0.0),

          //original code present
          update: (ctx, auth, previousCartProvider) {
            return CartProvider(
                auth.token,
                previousCartProvider != null
                    ? previousCartProvider.cartItems
                    : {},
                previousCartProvider != null
                    ? previousCartProvider.cartTotalAmount
                    : 0);
          },
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) {
          return GetMaterialApp(
            title: 'Nathans Laundry App',
            theme: ThemeData(
              primaryColor: kPrimaryColor,
            ),
            home: auth.isAuth == true
                ? Dashboard(
                    initialIndex: 0,
                  )
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapShot) =>
                        authResultSnapShot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : WalkThrough(),
                  ),
            routes: {
              kSplashScreen: (ctx) => SplashScreen(),
              kLoginScreen: (ctx) => LoginScreen(),
              kRegisterScreen: (ctx) => RegisterScreen(),
              kRecoverPassword: (ctx) => RecoverPasswordScreen(),
              kOtpVerification: (ctx) => OtpVerificationScreen(),
              kResetPasswordToken: (ctx) => RecoverPasswordTokenScreen(),
              kDashboardScreen: (ctx) => Dashboard(
                    initialIndex: 0,
                  ),
              kAccountInfoScreen: (ctx) => AccountInfoScreen(),
              kPrivacyPolicy: (ctx) => PrivacyPolicyScreen(),
              kMyLocationsScreen: (ctx) => MyLocationsScreen(),
              kFeedbackScreen: (ctx) => FeedbackScreen(),
              kReferScreen: (ctx) => ReferScreen(),
              kChangePasswordScreen: (ctx) => ChangePasswordScreen(),
              kSpecialOrderScreen: (ctx) => SpecialOrderScreen(),
              kNotificationScreen: (ctx) => NotificationScreen(),
              kOrderDetailScreen: (ctx) => OrderDetailScreen(),
              kDryCleaning: (ctx) => DryCleaningScreen(),
              kMyBag: (ctx) => MyBagScreen(),
              kAddsOn: (ctx) => AddsOnScreen(),
              kSchedulePickup: (ctx) => SchedulePickUp(),
              kEditLocation: (ctx) => EditLocation(),
              kMakePayment: (ctx) => MakePayment(),
            },
          );
        },
      ),
    );
  }
}
