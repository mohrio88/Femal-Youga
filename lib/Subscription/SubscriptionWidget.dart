import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_yoga_workout_4_all_new/ColorCategory.dart';
import 'package:flutter_yoga_workout_4_all_new/Subscription/SubscriptionItemWidget.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';
import 'package:in_app_purchase_storekit/in_app_purchase_storekit.dart';
import 'package:in_app_purchase_storekit/store_kit_wrappers.dart';

import '../ConstantWidget.dart';
import '../onlineData/ConstantUrl.dart';
import '../onlineData/ServiceProvider.dart';
import '../online_models/model_package_plan.dart';
import '../util/dialog_util.dart';
import 'consumable_store.dart';

// Auto-consume must be true on iOS.
// To try without auto-consume on another platform, change `true` to `false` here.
final bool _kAutoConsume = Platform.isIOS || true;

List<String> _kProductIds = <String>[];
List<Packageplan>? plans = [];

class SubscriptionWidget extends StatefulWidget {
  final Function? isClose;
  const SubscriptionWidget({Key? key, this.isClose}) : super(key: key);

  @override
  State<SubscriptionWidget> createState() => _SubscriptionWidgetState();
}

class _SubscriptionWidgetState extends State<SubscriptionWidget> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  List<String> _notFoundIds = <String>[];
  List<ProductDetails> _products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  bool _isAvailable = false;
  bool _purchasePending = false;
  bool _loading = true;
  String? _queryProductError;
  String currentSelectedSubscribeItem = "";
  Packageplan? selectedPackagePlan = null;
  ProductDetails? selectedProductDetail = null;
  PurchaseDetails? selectedPreviousProductdetail = null;
  Map<String, PurchaseDetails>? selectedPurchases = null;
  bool isProUser = false;

  late DialogUtil dialogUtil;

  @override
  void initState() {
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        _inAppPurchase.purchaseStream;
    _subscription =
        purchaseUpdated.listen((List<PurchaseDetails> purchaseDetailsList) {
      _listenToPurchaseUpdated(purchaseDetailsList);
    }, onDone: () {
      _subscription.cancel();
      ConstantUrl.showToast("Subscription Done", context);
    }, onError: (Object error) {
      // handle error here.
      print("subscrip==errrr");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString()),
          action: SnackBarAction(
            label: 'Purchase Updated Error!',
            onPressed: () {
              // Code to execute.
            },
          ),
        ),
      );
    });
    dialogUtil = new DialogUtil(context);
    initStoreInfo();
    super.initState();
  }

  Future<bool> _requestPop() {
    Navigator.pop(context);
    return new Future.value(false);
  }

  Widget youAreProMemberWidget() {
    return ConstantWidget.getCustomText("You are a pro member!", Colors.black,
        1, TextAlign.center, FontWeight.w700, 25);
  }

  Widget continueButtonWidget() {
    return ConstantWidget.getCustomText(
        "Continue", Colors.black, 1, TextAlign.center, FontWeight.w700, 25);
  }

  Widget commentTextWidget() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        top: 10,
      ),
      child: ConstantWidget.getCustomText(
          "Upgrade now to get full access to all Challenges",
          Colors.black,
          1,
          TextAlign.center,
          FontWeight.w600,
          15),
    );
  }

  Widget continueButton() {
    return ConstantWidget.getIconButtonWidget(context, 'Continue',
        borderColor: redColor,
        fillColor: redColor,
        fontColor: Colors.white,
        asset: "", () {
      if (selectedPackagePlan != null) {
        selectedPreviousProductdetail != null
            ? confirmPriceChange(context)
            : purchaseNewItem();
      } else {
        ConstantUrl.showToast("Please select a plan to purchase", context);
      }
    });
  }

  purchaseNewItem() {
    late PurchaseParam purchaseParam;

    if (Platform.isAndroid) {
      // NOTE: If you are making a subscription purchase/upgrade/downgrade, we recommend you to
      // verify the latest status of you your subscription by using server side receipt validation
      // and update the UI accordingly. The subscription purchase status shown
      // inside the app may not be accurate.
      final GooglePlayPurchaseDetails? oldSubscription = _getOldSubscription(
          selectedProductDetail!,
          selectedPurchases!,
          currentSelectedSubscribeItem);

      purchaseParam = GooglePlayPurchaseParam(
          productDetails: selectedProductDetail!,
          changeSubscriptionParam: (oldSubscription != null)
              ? ChangeSubscriptionParam(
                  oldPurchaseDetails: oldSubscription,
                  prorationMode: ProrationMode.immediateWithTimeProration,
                )
              : null);
    } else {
      purchaseParam = PurchaseParam(
        productDetails: selectedProductDetail!,
      );
    }

    // if (productDetails.id == _kConsumableId) {
    //   _inAppPurchase.buyConsumable(
    //       purchaseParam: purchaseParam,
    //       autoConsume: _kAutoConsume);
    // } else {
    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    //}
  }

  subscriptionItemClicked(
      Packageplan packageplan,
      PurchaseDetails? previousPurchase,
      ProductDetails? productDetails,
      Map<String, PurchaseDetails> purchases) {
    print("item clicked");
    currentSelectedSubscribeItem = packageplan.planId!;
    selectedPackagePlan = packageplan;
    selectedPreviousProductdetail = previousPurchase;
    selectedProductDetail = productDetails;
    selectedPurchases = purchases;
    setState(() {});
  }

  changeTimestampToDate(String? timestamp) {
    if (timestamp != null && timestamp.length > 5) {
      int ts = int.parse(timestamp);
      DateTime tsdate = DateTime.fromMillisecondsSinceEpoch(ts);
      String datetime = tsdate.day.toString() +
          "-" +
          tsdate.month.toString() +
          "-" +
          tsdate.year.toString();
      return datetime;
    } else {
      return timestamp;
    }
  }

  Future<void> initStoreInfo() async {
    PlanData? planData = await getAllPackagesPlanNew();
    if (planData != null && planData.packageplan != null)
      plans = planData.packageplan;
    if (planData != null && planData.isPro != null && planData.isPro == "1") {
      isProUser = true;
      currentSelectedSubscribeItem = planData.planId!;
    }
    _kProductIds = [];
    plans!.forEach((element) {
      if (Platform.isIOS) {
        _kProductIds.add(element.skuIdIOS!);
      } else {
        _kProductIds.add(element.skuIdAndroid!);
      }
    });
    // _kProductIds.add("firstproduct");
    // _kProductIds.add("1_month");
    //_kProductIds = ["1year","1year-membership","1 year","1month-access","7days-membership"];

    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        _isAvailable = isAvailable;
        _products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
        _notFoundIds = <String>[];
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iosPlatformAddition.setDelegate(ExamplePaymentQueueDelegate());
    }

    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (productDetailResponse.error != null) {
      setState(() {
        _queryProductError = productDetailResponse.error!.message;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    if (productDetailResponse.productDetails.isEmpty) {
      setState(() {
        _queryProductError = null;
        _isAvailable = isAvailable;
        _products = productDetailResponse.productDetails;
        _purchases = <PurchaseDetails>[];
        _notFoundIds = productDetailResponse.notFoundIDs;
        _purchasePending = false;
        _loading = false;
      });
      return;
    }

    final List<String> consumables = await ConsumableStore.load();
    setState(() {
      _isAvailable = isAvailable;
      _products = productDetailResponse.productDetails;
      _notFoundIds = productDetailResponse.notFoundIDs;
      //_consumables = consumables;
      _purchasePending = false;
      _loading = false;
    });
  }

  @override
  void dispose() {
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iosPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      iosPlatformAddition.setDelegate(null);
    }
    _subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> stack = <Widget>[];
    // if (_queryProductError == null) {
    //   stack.add(_buildConnectionCheckTile());
    //   stack.add(_buildProductList());
    //   //stack.add(_buildRestoreButton());
    // } else {
    //   stack.add(Center(
    //     child: Text(_queryProductError!),
    //   ));
    // }
    if (_purchasePending) {
      //if(dialogUtil!=null )  dialogUtil.showLoadingDialog();
      stack.add(
        //   // TODO(goderbauer): Make this const when that's available on stable.
        //   ignore: prefer_const_constructors
        //   Stack(
        //     children: const <Widget>[
        //       Opacity(
        //         opacity: 0.3,
        //         child: ModalBarrier(dismissible: false, color: Colors.grey),
        //       ),
        //       Center(
        //         child: CircularProgressIndicator(),
        //       ),
        //     ],
        //   ),
        Center(
          child: CircularProgressIndicator(),
        ),
      );
      //}else{
      //if(dialogUtil!=null )  dialogUtil.dismissLoadingDialog();
      //}
    } else {
      if (_queryProductError == null) {
        stack.add(_buildConnectionCheckTile());
        stack.add(_buildProductList());
        stack.add(_termsRestore());

      } else {
        stack.add(Center(
          child: Text(_queryProductError!),
        ));
      }
    }

    var size = MediaQuery.of(context).size;

    return WillPopScope(
      onWillPop: _requestPop,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getColorStatusBar(Colors.white),
        resizeToAvoidBottomInset: false,
        body: Column(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: size.height * 0.4,
                    color: "#ffffff".toColor(),
                    child: Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 20, bottom: 50),
                          child: getAssetImage("bg_purchase.png",
                              height: size.height * 0.4,
                              width: MediaQuery.of(context).size.width,
                              boxFit: BoxFit.contain),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: ConstantWidget.getCustomText(
                              "Shape Up With Your\nPersonalized Plan!",
                              Colors.black,
                              2,
                              TextAlign.center,
                              FontWeight.bold,
                              35),
                        ),
                        Align(
                            alignment: Alignment.topLeft,
                            child: GestureDetector(
                                onTap: () {
                                  _requestPop();
                                },
                                child: Icon(
                                  Icons.arrow_back,
                                ).marginOnly(left: 10))),
                        Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                                onTap: () {
                                  _requestPop();
                                },
                                child: _buildRestoreButton()))
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: stack,
                      ).paddingSymmetric(horizontal: 20),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Card _buildConnectionCheckTile() {
    if (_loading) {
      return const Card(child: ListTile(title: Text('Trying to connect...')));
    }
    final Widget storeHeader = ListTile(
      leading: Icon(_isAvailable ? Icons.check : Icons.block,
          color: _isAvailable
              ? Colors.green
              : ThemeData.light().colorScheme.error),
      title:
          Text('The store is ${_isAvailable ? 'available' : 'unavailable'}.'),
    );
    List<Widget> children = <Widget>[storeHeader];
    if (_isAvailable) children = [];
    if (!_isAvailable) {
      children.addAll(<Widget>[
        const Divider(),
        ListTile(
          title: Text('Not connected',
              style: TextStyle(color: ThemeData.light().colorScheme.error)),
          subtitle: const Text(
              'Unable to connect to the payments processor. Has this app been configured correctly? See the example README for instructions.'),
        ),
      ]);
    }
    return Card(child: Column(children: children));
  }

  Widget _buildProductList() {
    if (_loading) {
      return const Card(
          child: ListTile(
              leading: CircularProgressIndicator(),
              title: Text('Fetching Items...')));
    }
    if (!_isAvailable) {
      return const SizedBox();
    }
    //const ListTile productHeader = ListTile(title: Text('Products for Sale'));
    final List<Widget> productList = <Widget>[];
    if (_notFoundIds.isNotEmpty) {
      productList.add(ListTile(
          title: Text('[${_notFoundIds.join(", ")}] not found',
              style: TextStyle(color: ThemeData.light().colorScheme.error)),
          subtitle: const Text(
              'This app needs special configuration to run. Please see example/README.md for instructions.')));
    }

    // This loading previous purchases code is just a demo. Please do not use this as it is.
    // In your app you should always verify the purchase data using the `verificationData` inside the [PurchaseDetails] object before trusting it.
    // We recommend that you use your own server to verify the purchase data.
    final Map<String, PurchaseDetails> purchases =
        Map<String, PurchaseDetails>.fromEntries(
            _purchases.map((PurchaseDetails purchase) {
      if (purchase.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchase);
      }
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));

    List<Widget> priceItemWidgets = [];
    for (int i = 0; i < _products.length; i++) {
      bool isBest = false;
      if (i == 2) isBest = true;
      if (i <= plans!.length) {
        final PurchaseDetails? previousPurchase = purchases[_products[i].id];
        priceItemWidgets.add(SubscriptionItemWidget(
            _products[i],
            previousPurchase,
            plans![i],
            currentSelectedSubscribeItem,
            isBest,
            purchases,
            subscriptionItemClicked));
      }
    }
    print("plans===" + priceItemWidgets.length.toString());
    Widget subscribeButtons = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: priceItemWidgets,
    );

    productList.add(subscribeButtons);

    productList.add(commentTextWidget());
    if (isProUser == false) productList.add(continueButton());

    return Column(children: productList);
  }

  Widget _termsRestore() {



    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),

          child: Wrap(

            alignment: WrapAlignment.spaceAround,

            children: <Widget>[
              Text('Terms & Privacy Policy', style: TextStyle(color: bmiDarkBgColor),),
              SizedBox(width: 50,),
              Text('Restore Purchase', style: TextStyle(color: bmiDarkBgColor),),
            ],
          ),
        ),
        
      ],
    );
  }

  Widget _buildRestoreButton() {
    if (_loading) {
      return Container();
    }

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 3, 10, 0),
      // child: GestureDetector(
      //   onTap: () => _inAppPurchase.restorePurchases(),
      //   child: const Text('Restore'),
      // ),
    );
  }

  void showPendingUI() {
    setState(() {
      _purchasePending = true;
    });
  }

  Future<void> deliverProduct(PurchaseDetails purchaseDetails) async {
    // IMPORTANT!! Always verify purchase details before delivering the product.
    // if (purchaseDetails.productID == _kConsumableId) {
    //   await ConsumableStore.save(purchaseDetails.purchaseID!);
    //   final List<String> consumables = await ConsumableStore.load();
    //   setState(() {
    //     _purchasePending = false;
    //     _consumables = consumables;
    //   });
    // } else {
    await addPurchasePlan(
        currentSelectedSubscribeItem,
        changeTimestampToDate(purchaseDetails.transactionDate),
        purchaseDetails.status.toString(),
        purchaseId: purchaseDetails.purchaseID ?? "noId");
    ConstantUrl.showToast("You purchased successfully", context);
    if (widget.isClose != null) {
      widget.isClose;
    }
    // addPurchasePlan(purchaseDetails.productID, purchaseDetails.transactionDate??"no Date", purchaseId: purchaseDetails.purchaseID??"noId").then((value) async {
    //   ConstantUrl.showToast("You purchased successfully", context);
    //   if (widget.isClose != null) {
    //     widget.isClose;
    //   }
    // });
    isProUser = true;
    setState(() {
      _purchases.add(purchaseDetails);
      _purchasePending = false;
      _loading = false;
    });

    //}
  }

  void handleError(IAPError error) {
    ConstantUrl.showToast("Subscription Handle Error" + error.message, context);
    setState(() {
      _purchasePending = false;
      _loading = false;
    });
  }

  Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) {
    // IMPORTANT!! Always verify a purchase before delivering the product.
    // For the purpose of an example, we directly return true.
    return Future<bool>.value(true);
  }

  void _handleInvalidPurchase(PurchaseDetails purchaseDetails) {
    // handle invalid purchase here if  _verifyPurchase` failed.
    print("invalid purchase handle=====");
  }

  Future<void> _listenToPurchaseUpdated(
      List<PurchaseDetails> purchaseDetailsList) async {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        ConstantUrl.showToast("Subscription Pending", context);
        showPendingUI();
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.canceled) {
          handleError(purchaseDetails.error!);
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          final bool valid = await _verifyPurchase(purchaseDetails);
          if (valid) {
            deliverProduct(purchaseDetails);
          } else {
            _handleInvalidPurchase(purchaseDetails);
            return;
          }
        } else if (purchaseDetails.status == PurchaseStatus.restored) {
          ConstantUrl.showToast("Subscription Restored", context);
          isProUser = true;
          setState(() {});
          // final bool valid = await _verifyPurchase(purchaseDetails);
          // if (valid) {
          //   deliverProduct(purchaseDetails);
          // } else {
          //   _handleInvalidPurchase(purchaseDetails);
          //   return;
          // }
        }
        // if (Platform.isAndroid) {
        //   if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
        //     final InAppPurchaseAndroidPlatformAddition androidAddition =
        //     _inAppPurchase.getPlatformAddition<
        //         InAppPurchaseAndroidPlatformAddition>();
        //     await androidAddition.consumePurchase(purchaseDetails);
        //   }
        // }
        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  Future<void> confirmPriceChange(BuildContext context) async {
    if (Platform.isAndroid) {
      final InAppPurchaseAndroidPlatformAddition androidAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseAndroidPlatformAddition>();
      final BillingResultWrapper priceChangeConfirmationResult =
          await androidAddition.launchPriceChangeConfirmationFlow(
        sku: 'purchaseId',
      );
      if (context.mounted) {
        if (priceChangeConfirmationResult.responseCode == BillingResponse.ok) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Text('Price change accepted'),
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              priceChangeConfirmationResult.debugMessage ??
                  'Price change failed with code ${priceChangeConfirmationResult.responseCode}',
            ),
          ));
        }
      }
    }
    if (Platform.isIOS) {
      final InAppPurchaseStoreKitPlatformAddition iapStoreKitPlatformAddition =
          _inAppPurchase
              .getPlatformAddition<InAppPurchaseStoreKitPlatformAddition>();
      await iapStoreKitPlatformAddition.showPriceConsentIfNeeded();
    }
  }

  GooglePlayPurchaseDetails? _getOldSubscription(ProductDetails productDetails,
      Map<String, PurchaseDetails> purchases, String? oldSubscriptinoId) {
    // This is just to demonstrate a subscription upgrade or downgrade.
    // This method assumes that you have only 2 subscriptions under a group, 'subscription_silver' & 'subscription_gold'.
    // The 'subscription_silver' subscription can be upgraded to 'subscription_gold' and
    // the 'subscription_gold' subscription can be downgraded to 'subscription_silver'.
    // Please remember to replace the logic of finding the old subscription Id as per your app.
    // The old subscription is only required on Android since Apple handles this internally
    // by using the subscription group feature in iTunesConnect.
    if (oldSubscriptinoId == null || oldSubscriptinoId.length == 0) {
      return null;
    }
    GooglePlayPurchaseDetails? oldSubscription;
    // if (productDetails.id == _kSilverSubscriptionId &&
    //     purchases[_kGoldSubscriptionId] != null) {
    //   oldSubscription =
    //   purchases[_kGoldSubscriptionId]! as GooglePlayPurchaseDetails;
    // } else if (productDetails.id == _kGoldSubscriptionId &&
    //     purchases[_kSilverSubscriptionId] != null) {
    //   oldSubscription =
    //   purchases[_kSilverSubscriptionId]! as GooglePlayPurchaseDetails;
    // }
    oldSubscription =
        purchases[oldSubscriptinoId]! as GooglePlayPurchaseDetails;
    ;
    return oldSubscription;
  }
}

/// Example implementation of the
/// [`SKPaymentQueueDelegate`](https://developer.apple.com/documentation/storekit/skpaymentqueuedelegate?language=objc).
///
/// The payment queue delegate can be implementated to provide information
/// needed to complete transactions.
class ExamplePaymentQueueDelegate implements SKPaymentQueueDelegateWrapper {
  @override
  bool shouldContinueTransaction(
      SKPaymentTransactionWrapper transaction, SKStorefrontWrapper storefront) {
    return true;
  }

  @override
  bool shouldShowPriceConsent() {
    return false;
  }
}
