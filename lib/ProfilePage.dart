import 'dart:convert';
import 'dart:io';

import 'package:country_pickers/country.dart';
import 'package:country_pickers/country_picker_dialog.dart';
import 'package:country_pickers/utils/utils.dart';
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:numberpicker/numberpicker.dart';
import '../util/dialog_util.dart';

import 'ColorCategory.dart';
import 'ConstantWidget.dart';
import 'Constants.dart';
import 'edit_profile_sub_pages/IntensivelyPage.dart';
import 'PrefData.dart';
import 'SignInPage.dart';
import 'SizeConfig.dart';
import 'Widgets.dart';
import 'edit_profile_sub_pages/SelectAreasPage.dart';
import 'generated/l10n.dart';

import 'models/EditProfileModel.dart';
import 'onlineData/ConstantUrl.dart';
import 'onlineData/SelectState.dart';
import 'online_models/UserDetail.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePage createState() {
    return _ProfilePage();
  }
}

class _ProfilePage extends State<ProfilePage> {
  TextEditingController firstNameController = new TextEditingController();
  TextEditingController ageController = new TextEditingController();
  TextEditingController heightController = new TextEditingController();
  TextEditingController weightController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController referralController = new TextEditingController();
  TextEditingController removeProfileController = new TextEditingController();

  int intensivelyPosition = 0;

  String? name;
  String? email;
  String focusedAreasString = "";
  List<bool> areasBool = [];
  List<String> listFocusedAreas = [
    "Complete Body Contouring",
    "Toned Arms",
    "Trim Torso",
    "Shapely Butt",
    "Toned Legs"
  ];
  int age = 0;
  int height = 0;
  int weight = 0;
  bool isEdit = false;
  String? imageUrl;
  Country? _selectedDialogCountry;

  Future<bool> _requestPop() {
    Navigator.of(context).pop();
    return new Future.value(false);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUser();
  }

  PickedFile? _image;

  Future getImage(int type) async {
    // ignore: deprecated_member_use
    PickedFile? pickedImage = await ImagePicker().getImage(
        source: type == 1 ? ImageSource.camera : ImageSource.gallery,
        imageQuality: 50);
    return pickedImage;
  }

  // getProfileImage() {
  getProfileImage() {
    if (_image != null) {
      return Image.file(File(_image!.path));
    } else if (imageUrl != null) {
      return Image.network(ConstantUrl.uploadUrl + imageUrl!);
    } else {
      //
      return Image.asset(Constants.assetsImagePath + "profile.png");
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return WillPopScope(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: new AppBar(
              bottom: TabBar(
                indicatorColor: textColor,
                labelColor: textColor,
                unselectedLabelColor: subTextColor,
                tabs: [
                  Tab(
                      child: GestureDetector(
                          child: Text(S.of(context).profile),
                          onTap: null)), //disabled
                  Tab(
                      child: GestureDetector(
                          child: Text(S.of(context).personalInfo),
                          onTap: null)), //disabled
                ],
              ),
              elevation: 0,
              backgroundColor: bgDarkWhite,
              toolbarHeight: ConstantWidget.getScreenPercentSize(context, 7),
              title: getCustomText(
                  "", Colors.white, 1, TextAlign.start, FontWeight.w500, 20),
              leading: Padding(
                padding: EdgeInsets.all(
                    ConstantWidget.getScreenPercentSize(context, 2.2)),
                child: getDefaultBackButton(context, function: () {
                  Navigator.of(context).pop();
                }),
              ),
            ),
            body: TabBarView(
              children: [
                getFirstProfile(),
                getSecondProfile(),
              ],
            ),
          ),
        ),
        onWillPop: _requestPop);
  }

  getSecondProfile() {
    double leftMargin = ConstantWidget.getScreenPercentSize(context, 2);
    double height = ConstantWidget.getScreenPercentSize(context, 7);
    double fontSize = ConstantWidget.getPercentSize(height, 25);

    double radius = ConstantWidget.getPercentSize(height, 20);
    return Column(
      children: [
        Expanded(
          child: ListView(
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.symmetric(horizontal: leftMargin),
            children: [
              SizedBox(
                height: (leftMargin / 2),
              ),
              ConstantWidget.getTextWidget(
                  S.of(context).intensively,
                  Colors.grey.shade500,
                  TextAlign.start,
                  FontWeight.w600,
                  ConstantWidget.getScreenPercentSize(context, 2)),
              SizedBox(
                height: (leftMargin / 2),
              ),
              GestureDetector(
                onTap: () {
                  if (isEdit) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              IntensivelyPage(intensivelyPosition, (value) {
                            setState(() {
                              intensivelyPosition = value;
                            });
                          }),
                        ));
                  }
                },
                child: ConstantWidget.getShadowWidget(
                  radius: radius,
                  widget: Container(
                    padding: EdgeInsets.all(
                        ConstantWidget.getWidthPercentSize(context, 2.5)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ConstantWidget.getTextWidget(
                            ConstantUrl.getIntensivelyModel()[
                                    intensivelyPosition]
                                .title!,
                            Colors.black,
                            TextAlign.start,
                            FontWeight.w600,
                            ConstantWidget.getScreenPercentSize(context, 2)),
                        SizedBox(
                          height: 5,
                        ),
                        ConstantWidget.getTextWidget(
                            ConstantUrl.getIntensivelyModel()[
                                    intensivelyPosition]
                                .desc!,
                            Colors.black,
                            TextAlign.start,
                            FontWeight.w400,
                            fontSize)
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: (leftMargin),
              ),
              ConstantWidget.getTextWidget(
                  "Focused Areas",
                  Colors.grey.shade500,
                  TextAlign.start,
                  FontWeight.w600,
                  ConstantWidget.getScreenPercentSize(context, 2)),
              SizedBox(
                height: (leftMargin / 2),
              ),
              GestureDetector(
                onTap: () {
                  if (isEdit) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SelectAreasPage(areasBool, (value) {
                            setState(() {
                              areasBool = value;
                              updateSelectedAreas();
                            });
                          }),
                        ));
                  }
                },
                child: ConstantWidget.getShadowWidget(
                  radius: radius,
                  widget: Container(
                    padding: EdgeInsets.all(
                        ConstantWidget.getWidthPercentSize(context, 2.5)),
                    child: ConstantWidget.getTextWidget(
                        focusedAreasString,
                        Colors.black,
                        TextAlign.start,
                        FontWeight.w400,
                        fontSize),
                  ),
                ),
              ),
              SizedBox(
                height: (leftMargin / 2),
              ),
              ConstantWidget.editProfileWidget(context, S.of(context).age,
                  Icons.arrow_drop_down_circle, isEdit, ageController, () {
                showAgeDialog(context);
              }),
              ConstantWidget.editProfileWidget(context, S.of(context).height,
                  Icons.arrow_drop_down_circle, isEdit, heightController, () {
                showHeightDialog(context);
              }),
              ConstantWidget.editProfileWidget(context, S.of(context).weight,
                  Icons.arrow_drop_down_circle, isEdit, weightController, () {
                showWeightDialog(context);
              }),
              getCountryWidget(context, isHorizontal: true),
              ConstantWidget.editProfileWidget(
                  context,
                  S.of(context).removeProfile,
                  Icons.arrow_drop_down_circle,
                  isEdit,
                  removeProfileController, () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Are you sure?'),
                    content: const Text(
                        'This action will permanently delete this profile'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );

                if (result == null || !result) {
                  return;
                }

                deleteAccount();

                debugPrint(result.toString());
              }),
              SizedBox(
                height: ConstantWidget.getScreenPercentSize(context, 2),
              )
            ],
          ),
        ),
        Container(
          child: ConstantWidget.getButtonWidget(
              context, isEdit ? S.of(context).done : 'Edit', accentColor, () {
            setState(() {
              if (!isEdit) {
                isEdit = true;
              } else {
                checkNetwork();
              }
            });
            // checkValidation();
          }),
          margin: EdgeInsets.symmetric(
              horizontal: ConstantWidget.getScreenPercentSize(context, 2)),
          padding: EdgeInsets.only(
              bottom: ConstantWidget.getScreenPercentSize(context, 2)),
        )
      ],
    );
  }

  Widget getCountryWidget(BuildContext context, {isHorizontal}) {
    double height = ConstantWidget.getScreenPercentSize(context, 7);
    double radius = ConstantWidget.getPercentSize(height, 20);
    double fontSize = ConstantWidget.getPercentSize(height, 25);

    return StatefulBuilder(
      builder: (context, setState) {
        return ConstantWidget.getShadowWidget(
          radius: radius,
          verticalMargin: ConstantWidget.getScreenPercentSize(context, 1.2),
          widget: Container(
            height: height,
            alignment: Alignment.centerLeft,
            child: Row(
              children: [
                SizedBox(
                  width: ConstantWidget.getWidthPercentSize(context, 4.5),
                ),
                Text("Country"),
                SizedBox(
                  width: ConstantWidget.getWidthPercentSize(context, 4.5),
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: InkWell(
                      onTap: () {
                        isEdit ? _openCountryPickerDialog() : null;
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(
                            Radius.circular(radius),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            CountryPickerUtils.getDefaultFlagImage(
                                _selectedDialogCountry!),
                            SizedBox(width: 20),
                            Text("${_selectedDialogCountry!.name}"),
                            // SizedBox(width: 8),
                            // Flexible(child: Text(_selectedDialogCountry.name))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Icon(Icons.arrow_drop_down_circle,
                    size: ConstantWidget.getScreenPercentSize(context, 3),
                    color: Colors.grey),
                SizedBox(
                  width: ConstantWidget.getWidthPercentSize(context, 2),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openCountryPickerDialog() => showDialog(
        context: context,
        builder: (context) => Theme(
          data: Theme.of(context).copyWith(primaryColor: Colors.pink),
          child: CountryPickerDialog(
            titlePadding: EdgeInsets.all(8.0),
            searchCursorColor: Colors.pinkAccent,
            searchInputDecoration: InputDecoration(hintText: 'Search...'),
            isSearchable: true,
            title: Text(' Please select your country'),
            onValuePicked: (Country country) =>
                setState(() => _selectedDialogCountry = country),
            itemBuilder: _buildDialogItem,
            priorityList: [
              CountryPickerUtils.getCountryByIsoCode('TR'),
              CountryPickerUtils.getCountryByIsoCode('US'),
            ],
          ),
        ),
      );
  Widget _buildDialogItem(Country country) => Row(
        children: <Widget>[
          CountryPickerUtils.getDefaultFlagImage(country),
          SizedBox(width: 8),
          Flexible(child: Text(country.name))
        ],
      );

  void showHeightDialog(BuildContext mainContext) {
    int defValue = height;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: 300,
                  padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getCustomText(S.of(mainContext).height, Colors.black87, 1,
                          TextAlign.start, FontWeight.w600, 20),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: ConstantWidget.getScreenPercentSize(
                                mainContext, 2.5)),
                        child: Align(
                          alignment: Alignment.center,
                          child: NumberPicker(
                            value: defValue,
                            minValue: 80,
                            maxValue: 350,
                            textStyle: TextStyle(
                                fontSize: ConstantWidget.getScreenPercentSize(
                                    mainContext, 1.5),
                                color: Colors.black,
                                fontFamily: Constants.fontsFamily),
                            selectedTextStyle: TextStyle(
                                fontSize: ConstantWidget.getScreenPercentSize(
                                    mainContext, 3),
                                color: redColor,
                                fontFamily: Constants.fontsFamily),
                            step: 1,
                            haptics: true,
                            onChanged: (value) => setState(() {
                              defValue = value;
                            }),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: [
              new TextButton(
                  child: Text(
                    S.of(mainContext).save,
                    style: TextStyle(
                        fontFamily: Constants.fontsFamily,
                        fontSize: 15,
                        color: accentColor,
                        fontWeight: FontWeight.normal),
                  ),
                  onPressed: () {
                    // PrefData().setIsMute(isSwitched);
                    Navigator.pop(context);
                    setState(() {
                      height = defValue;
                      heightController.text = "Height : " + height.toString();
                    });
                  }),
            ],
          );
        });
  }

  void showWeightDialog(BuildContext mainContext) {
    int defValue = weight;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: 300.0,
                  padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getCustomText(S.of(mainContext).weight, Colors.black87, 1,
                          TextAlign.start, FontWeight.w600, 20),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: ConstantWidget.getScreenPercentSize(
                                mainContext, 2.5)),
                        child: Align(
                          alignment: Alignment.center,
                          child: NumberPicker(
                            value: defValue,
                            minValue: 20,
                            maxValue: 250,
                            textStyle: TextStyle(
                                fontSize: ConstantWidget.getScreenPercentSize(
                                    mainContext, 1.5),
                                color: Colors.black,
                                fontFamily: Constants.fontsFamily),
                            selectedTextStyle: TextStyle(
                                fontSize: ConstantWidget.getScreenPercentSize(
                                    mainContext, 3),
                                color: redColor,
                                fontFamily: Constants.fontsFamily),
                            step: 1,
                            haptics: true,
                            onChanged: (value) => setState(() {
                              defValue = value;
                            }),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: [
              new TextButton(
                  child: Text(
                    S.of(mainContext).save,
                    style: TextStyle(
                        fontFamily: Constants.fontsFamily,
                        fontSize: 15,
                        color: accentColor,
                        fontWeight: FontWeight.normal),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      weight = defValue;
                      weightController.text = "Weight  : " + weight.toString();
                    });
                  }),
            ],
          );
        });
  }

  void showAgeDialog(BuildContext mainContext) {
    int defValue = age;
    // int defValue =int.parse(ageController.text);
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))),
            contentPadding: EdgeInsets.only(top: 10.0),
            content: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: 300.0,
                  padding: EdgeInsets.only(bottom: 15, left: 15, right: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      getCustomText(S.of(mainContext).age, Colors.black87, 1,
                          TextAlign.start, FontWeight.w600, 20),
                      SizedBox(
                        height: 15,
                      ),
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: ConstantWidget.getScreenPercentSize(
                                mainContext, 2.5)),
                        child: Align(
                          alignment: Alignment.center,
                          child: NumberPicker(
                            value: defValue,
                            minValue: 15,
                            maxValue: 90,
                            textStyle: TextStyle(
                                fontSize: ConstantWidget.getScreenPercentSize(
                                    mainContext, 1.5),
                                color: Colors.black,
                                fontFamily: Constants.fontsFamily),
                            selectedTextStyle: TextStyle(
                                fontSize: ConstantWidget.getScreenPercentSize(
                                    mainContext, 3),
                                color: redColor,
                                fontFamily: Constants.fontsFamily),
                            step: 1,
                            haptics: true,
                            onChanged: (value) => setState(() {
                              defValue = value;
                            }),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 7,
                      ),
                    ],
                  ),
                );
              },
            ),
            actions: [
              new TextButton(
                  child: Text(
                    S.of(mainContext).save,
                    style: TextStyle(
                        fontFamily: Constants.fontsFamily,
                        fontSize: 15,
                        color: accentColor,
                        fontWeight: FontWeight.normal),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    setState(() {
                      age = defValue;
                      ageController.text = "Age : " + age.toString();
                    });
                  }),
            ],
          );
        });
  }

  getFirstProfile() {
    double firstHeight = SizeConfig.safeBlockVertical! * 45;
    double leftMargin = ConstantWidget.getScreenPercentSize(context, 2);

    double circleSize = ConstantWidget.getPercentSize(firstHeight, 30);
    double editSize = ConstantWidget.getPercentSize(circleSize, 24);
    return ListView(
      scrollDirection: Axis.vertical,
      padding: EdgeInsets.symmetric(horizontal: leftMargin),
      children: [
        Container(
            margin: EdgeInsets.only(
                top: ConstantWidget.getScreenPercentSize(context, 2),
                bottom: ConstantWidget.getScreenPercentSize(context, 2)),
            height: circleSize,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: <Widget>[
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Container(
                      height: circleSize,
                      width: circleSize,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          border: Border.all(color: accentColor, width: 2)),
                      child: ClipOval(
                        child: Material(
                          color: Colors.white,
                          child: getProfileImage(),
                        ),
                      ),
                    ),
                  ),
                  Visibility(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: GestureDetector(
                        child: Container(
                          margin: EdgeInsets.only(
                              left: ConstantWidget.getScreenPercentSize(
                                  context, 10),
                              bottom: ConstantWidget.getScreenPercentSize(
                                  context, 0.5)),
                          height: editSize,
                          width: editSize,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: accentColor,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.photo_camera_back,
                                color: Colors.white,
                                size:
                                    ConstantWidget.getPercentSize(editSize, 48),
                              ),
                            ),
                          ),
                        ),
                        onTap: () async {
                          final tmpFile = await getImage(2);
                          setState(() {
                            _image = tmpFile;
                          });
                        },
                      ),
                    ),
                    visible: isEdit,
                  )
                ],
              ),
            )),
        Container(
            width: double.infinity,
            child: Wrap(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(bottom: (leftMargin - (leftMargin / 2))),
                  child: ListView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    children: [
                      ConstantWidget.textFieldProfileWidget(
                          context,
                          S.of(context).firstName,
                          Icons.account_circle,
                          isEdit,
                          firstNameController,
                          () {}),
                    ],
                  ),
                )
              ],
            )),
        Container(
          child: ConstantWidget.getButtonWidget(
              context, isEdit ? S.of(context).done : 'Edit', accentColor, () {
            setState(() {
              if (!isEdit) {
                isEdit = true;
              } else {
                checkNetwork();
              }
            });
            // checkValidation();
          }),
        )
      ],
    );
  }

  Future<void> checkNetwork() async {
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      uploadBitmap();
    } else {
      getNoInternet(context);
    }
  }

  Future<void> deleteAccount() async {
    bool isNetwork = await ConstantUrl.getNetwork();
    if (isNetwork) {
      String s = await PrefData.getUserDetail();
      if (s.isNotEmpty) {
        UserDetail userDetail = await ConstantUrl.getUserDetail();
        Map data = await ConstantUrl.getCommonParams();
        data[ConstantUrl.paramUserId] = userDetail.userId;

        final response = await http
            .post(Uri.parse(ConstantUrl.deleteAccountUrl), body: data);

        if (response.statusCode == 200) {
          final result = json.decode(response.body)['data'];
          if (result['success'] == 1) {
            ConstantUrl.showToast(result['error'], context);
            ConstantUrl.sendLoginPage(
              context,
              function: () {},
            );
          } else {
            ConstantUrl.showToast(result['error'], context);
          }
        } else {
          ConstantUrl.showToast('Please Try Again', context);
        }
      }
    } else {
      getNoInternet(context);
    }
  }

  void uploadBitmap() async {
    String s = await PrefData.getUserDetail();
    if (s.isNotEmpty) {
      UserDetail userDetail = await ConstantUrl.getUserDetail();

      String deviceId = await ConstantUrl.getDeviceId();
      String session = await PrefData.getSession();

      DialogUtil dialogUtil = new DialogUtil(context);
      dialogUtil.showLoadingDialog();

      var request =
          http.MultipartRequest("POST", Uri.parse(ConstantUrl.urlEditProfile));
      request.fields[ConstantUrl.paramUserId] = userDetail.userId!;
      request.fields[ConstantUrl.paramSession] = session;
      request.fields[ConstantUrl.paramDeviceId] = deviceId;
      request.fields[ConstantUrl.paramFirstName] = firstNameController.text;
      request.fields[ConstantUrl.paramCountry] = _selectedDialogCountry!.name;
      request.fields[ConstantUrl.paramAge] = age.toString();
      request.fields[ConstantUrl.paramHeight] = height.toString();
      request.fields[ConstantUrl.paramWeight] = weight.toString();
      request.fields[ConstantUrl.paramIntensively] =
          intensivelyPosition.toString();
      request.fields[ConstantUrl.paramAreas] = areasBool.join(",");
      print(request.fields);

      if (_image != null) {
        var pic = await http.MultipartFile.fromPath(
            ConstantUrl.paramImage, _image!.path);
        request.files.add(pic);
      }
      var response = await request.send();

      if (response.statusCode == 200) {
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);

        Map<String, dynamic> map = json.decode(responseString);

        dialogUtil.dismissLoadingDialog();

        EditProfileModel editModel = EditProfileModel.fromJson(map);
        print("response------$responseString");
        print("editModel------$editModel");

        if (editModel.data!.success == 1) {
          print("response------12$responseString");

          if (editModel.data!.editProfile != null) {
            PrefData.setUserDetail("");
            PrefData.setUserDetail(json.encode(editModel.data!.editProfile));

            setState(() {
              isEdit = false;
              getUser();
            });
          }
        }
      }
    }
  }

  void getUser() async {
    String s = await PrefData.getUserDetail();
    if (s.isNotEmpty) {
      UserDetail userDetail = await ConstantUrl.getUserDetail();

      setState(() {
        firstNameController.text = userDetail.firstName!;
        age = int.parse(userDetail.age!);
        height = int.parse(userDetail.height!);
        weight = int.parse(userDetail.weight!);
        ageController.text = "Age : " + userDetail.age!;
        heightController.text = "Height : " + userDetail.height!;
        weightController.text = "Weight  : " + userDetail.weight!;
        String initCountry = userDetail.country ?? "United States";
        if (initCountry.length <= 1) {
          initCountry = "United States";
        }
        print(initCountry);
        _selectedDialogCountry =
            CountryPickerUtils.getCountryByName(initCountry);
        List<String> areas = userDetail.areas!.split(",");
        areasBool = [];
        areas.forEach((element) {
          areasBool.add(element == "true" ? true : false);
        });
        print(areasBool);
        updateSelectedAreas();

        if (userDetail.intensively != null &&
            userDetail.intensively!.isNotEmpty) {
          intensivelyPosition = int.parse(userDetail.intensively!);
        }

        if (userDetail.image != null) {
          if (userDetail.image!.isNotEmpty) {
            imageUrl = userDetail.image;
          }
        }

        print("imageURl----${userDetail.image}");
      });
    }
  }

  updateSelectedAreas() {
    focusedAreasString = "";
    for (var i = 0; i < areasBool.length; i++) {
      if (areasBool[i] == true) {
        if (focusedAreasString.length > 0) focusedAreasString += "\n";
        focusedAreasString += listFocusedAreas[i];
      }
    }
    setState(() {});
  }
}
