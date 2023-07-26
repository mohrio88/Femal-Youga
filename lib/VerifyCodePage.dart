// import 'dart:async';
//
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:pin_input_text_field/pin_input_text_field.dart';
//
// import '../ColorCategory.dart';
// import '../Constants.dart';
// import '../onlineData/ConstantUrl.dart';
//
// import 'ConstantWidget.dart';
// import 'SizeConfig.dart';
//
// import 'generated/l10n.dart';
//
// class VerifyCodePage extends StatefulWidget {
//   final String email;
//   final ValueChanged<String> function;
//
//   VerifyCodePage(this.email, this.function);
//
//   @override
//   _VerifyCodePage createState() {
//     return _VerifyCodePage();
//   }
// }
//
// class _VerifyCodePage extends State<VerifyCodePage>
//     with WidgetsBindingObserver {
//   TextEditingController emailController = new TextEditingController();
//   FirebaseAuth auth = FirebaseAuth.instance;
//   final GlobalKey<FormFieldState<String>> _formKey =
//       GlobalKey<FormFieldState<String>>(debugLabel: '_formkey');
//   TextEditingController _pinEditingController = TextEditingController(text: '');
//   bool _enable = true;
//
//   String? appSignature;
//
//   String? verificationId;
//   String resendString = " ";
//   int _countDown = 60;
//
//   Timer? _timer;
//   bool timeout = false;
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       _cancelTimer();
//     } else if (state == AppLifecycleState.resumed) {
//       startTimer();
//     }
//   }
//
//   void _cancelTimer() {
//     print("timer---true");
//     if (_timer != null) {
//       _timer!.cancel();
//     }
//   }
//
//   @override
//   void dispose() {
//     _cancelTimer();
//     super.dispose();
//   }
//
//   void startTimer() {
//     _cancelTimer();
//     print("_countDown12" + _countDown.toString());
//     var oneSec = Duration(seconds: 1);
//     _timer = new Timer.periodic(oneSec, (Timer timer) {
//       if (_countDown < 1) {
//         if (mounted) {
//           setState(() {
//             timer.cancel();
//             resendString = S.of(context).resend;
//           });
//         }
//       } else {
//         if (mounted) {
//           setState(() {
//             _countDown = _countDown - 1;
//             resendString = S.of(context).resendSms +
//                 " " +
//                 _countDown.toString() +
//                 " " +
//                 S.of(context).sec;
//           });
//         }
//       }
//     });
//   }
//
//   Future<bool> _requestPop() {
//     if (mounted) {
//       setState(() {});
//     }
//     _cancelTimer();
//     Navigator.of(context).pop();
//     return new Future.value(true);
//   }
//
//   PhoneAuthCredential? phoneAuthCredential;
//
//   void setNumber() async {
//     _countDown = 60;
//     startTimer();
//     await auth.verifyPhoneNumber(
//       verificationFailed: (FirebaseAuthException e) {
//         print("codeSend---fail---$e");
//         print(
//             "Phone number verification failed. Code: ${e.code}. Message: ${e.message}");
//         if (e.code == 'invalid-phone-number') {
//           print('The provided phone number is not valid.');
//         }
//
//         // Handle other errors
//       },
//       verificationCompleted: (PhoneAuthCredential credential) async {
//         print("codeComplete---true");
//         await auth.signInWithCredential(credential);
//       },
//       codeSent: (String? id, int? resendToken) async {
//         verificationId = id;
//
//         setState(() {});
//         print("codeSend---true");
//       },
//       phoneNumber: widget.email,
//       timeout: const Duration(seconds: 60),
//       codeAutoRetrievalTimeout: (String verificationId) {
//         // Auto-resolution timed out...
//       },
//     );
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     setNumber();
//
//     setState(() {
//       emailController.text = widget.email;
//     });
//     WidgetsBinding.instance.addObserver(this);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//
//     return WillPopScope(
//         child: Scaffold(
//           backgroundColor: bgDarkWhite,
//           appBar: AppBar(
//             backgroundColor: bgDarkWhite,
//             elevation: 0,
//             toolbarHeight: 0,
//           ),
//           body: Container(
//             color: bgDarkWhite,
//             child: Column(
//               children: [
//                 ConstantWidget.getLoginAppBar(context, function: _requestPop),
//                 Expanded(
//                   flex: 1,
//                   child: ListView(
//                     padding: EdgeInsets.symmetric(
//                         horizontal:
//                             ConstantWidget.getWidthPercentSize(context, 3)),
//                     children: [
//                       SizedBox(
//                         height:
//                             ConstantWidget.getScreenPercentSize(context, 2.5),
//                       ),
//                       ConstantWidget.getTextWidget(
//                           S.of(context).verifyCode,
//                           textColor,
//                           TextAlign.left,
//                           FontWeight.bold,
//                           ConstantWidget.getScreenPercentSize(context, 3)),
//                       SizedBox(
//                         height:
//                             ConstantWidget.getScreenPercentSize(context, 1.4),
//                       ),
//                       ConstantWidget.getTextWidget(
//                           S.of(context).verifyMsg,
//                           textColor,
//                           TextAlign.left,
//                           FontWeight.w400,
//                           ConstantWidget.getScreenPercentSize(context, 2)),
//                       SizedBox(
//                         height: ConstantWidget.getScreenPercentSize(context, 3),
//                       ),
//                       Container(
//                         height: SizeConfig.safeBlockVertical! * 6.6,
//                         margin: EdgeInsets.symmetric(
//                             vertical: ConstantWidget.getScreenPercentSize(
//                                 context, 3)),
//                         child: PinInputTextFormField(
//                           key: _formKey,
//                           pinLength: 6,
//                           decoration: new BoxLooseDecoration(
//                             textStyle: TextStyle(
//                                 color: Colors.black,
//                                 fontSize: ConstantWidget.getScreenPercentSize(
//                                     context, 2.2),
//                                 fontWeight: FontWeight.w400),
//                             radius: Radius.circular(
//                                 ConstantWidget.getScreenPercentSize(
//                                     context, 0.8)),
//                             strokeColorBuilder: PinListenColorBuilder(
//                                 blueButton, Colors.grey.shade300),
//                             obscureStyle: ObscureStyle(
//                               isTextObscure: false,
//                               obscureText: '🤪',
//                             ),
//                           ),
//                           controller: _pinEditingController,
//                           textInputAction: TextInputAction.go,
//                           enabled: _enable,
//                           keyboardType: TextInputType.number,
//                           textCapitalization: TextCapitalization.characters,
//                           onSubmit: (pin) {
//                             print("gtepin===$pin");
//                             if (_formKey.currentState!.validate()) {
//                               _formKey.currentState!.save();
//                             }
//                           },
//                           onChanged: (pin) {
//                             setState(() {
//                               debugPrint('onChanged execute. pin:$pin');
//                             });
//                           },
//                           onSaved: (pin) {
//                             debugPrint('onSaved pin:$pin');
//                           },
//                           validator: (pin) {
//                             if (pin!.isEmpty) {
//                               setState(() {});
//                               return 'Pin cannot empty.';
//                             }
//                             setState(() {});
//                             return null;
//                           },
//                           cursor: Cursor(
//                             width: 2,
//                             color: Colors.white,
//                             radius: Radius.circular(1),
//                             enabled: true,
//                           ),
//                         ),
//                       ),
//                       ConstantWidget.getButtonWidget(
//                           context, 'Verify', blueButton, () {
//
//
//
//
//                         if (_pinEditingController.text.isNotEmpty) {
//                           if (verificationId == null) {
//                             ConstantUrl.showToast("code not match", context);
//                           } else {
//                             if (timeout == true) {
//                               ConstantUrl.showToast(
//                                   "The sms code has expired. Please re-send the verification code to try again.",
//                                   context);
//                             } else {
//                               _signInWithPhoneNumber(
//                                   _pinEditingController.text);
//                             }
//                           }
//                         } else {
//                           print("error----swssssssssssssssss");
//                           ConstantUrl.showToast(S.of(context).fillOtp, context);
//                         }
//                       }),
//                       SizedBox(
//                         height:
//                             ConstantWidget.getScreenPercentSize(context, 2.3),
//                       ),
//                       Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           ConstantWidget.getTextWidget(
//                               "Didn't receive code?",
//                               Colors.black,
//                               TextAlign.left,
//                               FontWeight.w500,
//                               ConstantWidget.getScreenPercentSize(
//                                   context, 1.8)),
//                           SizedBox(
//                             width: ConstantWidget.getScreenPercentSize(
//                                 context, 0.5),
//                           ),
//                           GestureDetector(
//                             child: ConstantWidget.getTextWidget(
//                                 resendString,
//                                 accentColor,
//                                 TextAlign.start,
//                                 FontWeight.bold,
//                                 ConstantWidget.getScreenPercentSize(
//                                     context, 2)),
//                             onTap: () {
//                               if (resendString == (S.of(context).resend)) {
//                                 setNumber();
//                               }
//                             },
//                           )
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//         onWillPop: _requestPop);
//   }
//
//   void _signInWithPhoneNumber(String smsCode) async {
//     PhoneAuthCredential phoneAuthCredential =
//         await PhoneAuthProvider.credential(
//             verificationId: verificationId!, smsCode: smsCode);
//     User? user = (await auth.signInWithCredential(phoneAuthCredential)).user;
//
//     if (user != null) {
//       checkValidation();
//       FirebaseAuth.instance.currentUser!.delete();
//     } else {
//       ConstantUrl.showToast(S.of(context).userError, context);
//     }
//   }
//
//   Widget textFieldWidget(BuildContext context, String s, var keyboardType,
//       bool isPassWord, var icon, TextEditingController textEditingController) {
//     double height = ConstantWidget.getScreenPercentSize(context, 6.8);
//     double borderWidth = ConstantWidget.getScreenPercentSize(context, 0.05);
//     double borderRadius = ConstantWidget.getScreenPercentSize(context, 0.7);
//
//     return Container(
//       margin: EdgeInsets.only(
//         top: ConstantWidget.getScreenPercentSize(context, 1.3),
//         bottom: ConstantWidget.getScreenPercentSize(context, 3),
//       ),
//       height: height,
//       child: new Theme(
//           data: new ThemeData(
//               primaryColor: blueButton,
//               hintColor: Colors.grey,
//               colorScheme:
//                   ColorScheme.fromSwatch().copyWith(secondary: blueButton)),
//           child: Align(
//             alignment: Alignment.centerLeft,
//             child: TextFormField(
//               enabled: false,
//               controller: textEditingController,
//               maxLines: 1,
//               keyboardType: keyboardType,
//               obscureText: isPassWord,
//               textAlign: TextAlign.start,
//               textAlignVertical: TextAlignVertical.center,
//               cursorColor: blueButton,
//               style: TextStyle(
//                   fontFamily: Constants.fontsFamily,
//                   color: Colors.black,
//                   fontWeight: FontWeight.w400,
//                   fontSize: ConstantWidget.getScreenPercentSize(context, 1.8)),
//               decoration: new InputDecoration(
//                 contentPadding: EdgeInsets.only(
//                     left: ConstantWidget.getScreenPercentSize(context, 1)),
//                 suffixIcon: Icon(
//                   icon,
//                   size: ConstantWidget.getPercentSize(height, 50),
//                   color: Colors.grey,
//                 ),
//                 border: ConstantWidget.getOutlineBorder(
//                     Colors.grey, borderWidth, borderRadius),
//                 focusedBorder: ConstantWidget.getOutlineBorder(
//                     blueButton, borderWidth, borderRadius),
//                 enabledBorder: ConstantWidget.getOutlineBorder(
//                     Colors.grey, borderWidth, borderRadius),
//                 errorBorder: ConstantWidget.getOutlineBorder(
//                     Colors.red, borderWidth, borderRadius),
//                 disabledBorder: ConstantWidget.getOutlineBorder(
//                     Colors.grey, borderWidth, borderRadius),
//                 hintText: s,
//                 hintStyle: TextStyle(
//                     fontFamily: Constants.fontsFamily,
//                     color: Colors.grey,
//                     fontWeight: FontWeight.w400,
//                     fontSize:
//                         ConstantWidget.getScreenPercentSize(context, 1.8)),
//               ),
//             ),
//           )),
//     );
//   }
//
//   void checkNetWork() {}
//
//   void checkValidation() {
//     print("text---${_pinEditingController.text}");
//
//     if (ConstantUrl.isNotEmpty(_pinEditingController.text)) {
//       Navigator.of(context).pop();
//       widget.function(_pinEditingController.text);
//     } else {
//       ConstantUrl.showToast(S.of(context).fillDetails, context);
//     }
//   }
//
//   //
//   Future<void> verifyCode() async {
//     FocusScopeNode currentFocus = FocusScope.of(context);
//     if (!currentFocus.hasPrimaryFocus) {
//       currentFocus.unfocus();
//     }
//   }
//
//   void sendSignInPage() {
//     Navigator.pop(context);
//   }
// }
