// import 'dart:async';
//
// import 'package:chewie/chewie.dart';
// import 'package:flutter/cupertino.dart';
// import 'dart:math' as math;
// import 'package:flutter/material.dart';
//
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:flutter_tts/flutter_tts.dart';
//
// import 'package:video_player/video_player.dart';
//
// import 'package:get/get.dart';
// import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';
// import 'package:percent_indicator/circular_percent_indicator.dart';
// import 'package:youtube_player_flutter/youtube_player_flutter.dart';
// import '../PrefData.dart';
// import '../models/ModelDummySend.dart';
// import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
// import 'package:flutter_share/flutter_share.dart';
//
// import 'package:step_progress_indicator/step_progress_indicator.dart';
// import '../models/ModelHistory.dart';
// import '../onlineData/ConstantUrl.dart';
//
// import 'ColorCategory.dart';
// import 'ConstantWidget.dart';
// import 'Constants.dart';
// import 'SizeConfig.dart';
// import 'Widgets.dart';
// import 'ads/ads_file.dart';
// import 'controller/home_controller.dart';
// import 'db/audio_file.dart';
// import 'generated/l10n.dart';
// import 'models/ModelDetailExerciseList.dart';
// import 'onlineData/ServiceProvider.dart';
//
//
// ChewieController? chewieController;
// VideoPlayerController? videoController;
//
// class WidgetWorkout1 extends StatefulWidget {
//   final ModelDummySend _modelDummySend;
//   final List<Exercise> _modelExerciseList;
//
//   final double totalCal;
//   final int time;
//
//   WidgetWorkout1(
//       this._modelExerciseList, this._modelDummySend, this.totalCal, this.time);
//
//   @override
//   _WidgetWorkout1 createState() => _WidgetWorkout1();
// }
//
// class WidgetSkipData extends StatefulWidget {
//   final Exercise _modelExerciseDetail;
//   final Function _functionSkip;
//   final Function _functionSkipTick;
//
//   final int totalPos;
//   final int currentPos;
//
//   WidgetSkipData(this._modelExerciseDetail, this._functionSkip, this.currentPos,
//       this.totalPos, this._functionSkipTick);
//
//   @override
//   _WidgetSkipData createState() => _WidgetSkipData();
// }
//
// class _WidgetSkipData extends State<WidgetSkipData>
//     with WidgetsBindingObserver {
//   int skipTime = 10;
//   Timer? _timer;
//   int totalTime = 10;
//   String currentTime = "0";
//
//   _getRestTimes() async {
//     skipTime = await PrefData().getRestTime();
//     totalTime = await PrefData().getRestTime();
//     setState(() {});
//   }
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     _getRestTimes();
//     super.initState();
//   }
//
//   void cancelSkipTimer() {
//     _timer!.cancel();
//     _timer = null;
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       pauseSkip();
//     } else if (state == AppLifecycleState.resumed) {
//       if (!isSkipDialogOpen) {
//         resumeSkip();
//       }
//     }
//   }
//
//   void setSkipTimer() {
//     const oneSec = const Duration(seconds: 1);
//     _timer = new Timer.periodic(
//         oneSec,
//         (Timer timer) => {
//               if (mounted)
//                 {
//                   setState(
//                     () {
//                       if (skipTime < 1) {
//                         cancelSkipTimer();
//                         widget._functionSkip();
//                       } else {
//                         skipTime = skipTime - 1;
//                       }
//                       if (skipTime < Constants.maxTime &&
//                           skipTime > Constants.minTime) {
//                         widget._functionSkipTick(skipTime.toString());
//                       }
//
//                       currentTime = skipTime.toString();
//                     },
//                   ),
//                 }
//             });
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     if (_timer != null) {
//       cancelSkipTimer();
//     }
//     super.dispose();
//   }
//
//   PageController controller = PageController();
//   GlobalKey<ScaffoldState> scaffoldState = GlobalKey();
//
//   bool isSkipDialogOpen = false;
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//
//     if (_timer == null) {
//       setSkipTimer();
//     }
//     double radius = Constants.getScreenPercentSize(context, 2);
//     double margin = Constants.getScreenPercentSize(context, 2);
//     double cellSize = ConstantWidget.getScreenPercentSize(context, 9);
//
//     double firstHeight = ConstantWidget.getScreenPercentSize(context, 50);
//     double remainHeight =
//         ConstantWidget.getScreenPercentSize(context, 100) - firstHeight;
//     return Container(
//       key: scaffoldState,
//       width: double.infinity,
//       height: double.infinity,
//       color: bgDarkWhite,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Container(
//             width: double.infinity,
//             height: firstHeight,
//             decoration: getDecorationWithSide(
//                 radius: ConstantWidget.getScreenPercentSize(context, 4.5),
//                 bgColor: bgColor,
//                 isBottomLeft: true,
//                 isBottomRight: true),
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: ConstantWidget.getScreenPercentSize(context, 4),
//                 ),
//                 ConstantWidget.getTextWidget(
//                     "Rest",
//                     textColor,
//                     TextAlign.start,
//                     FontWeight.bold,
//                     ConstantWidget.getPercentSize(firstHeight, 6)),
//                 SizedBox(
//                   height: ConstantWidget.getScreenPercentSize(context, 1),
//                 ),
//                 ConstantWidget.getTextWidget(
//                     "$totalTime seconds",
//                     textColor,
//                     TextAlign.start,
//                     FontWeight.w500,
//                     ConstantWidget.getPercentSize(firstHeight, 4)),
//                 Expanded(
//                   child: Center(
//                     child: new CircularPercentIndicator(
//                       radius: ConstantWidget.getPercentSize(firstHeight, 27),
//                       lineWidth:
//                           ConstantWidget.getPercentSize(firstHeight, 2.5),
//                       circularStrokeCap: CircularStrokeCap.round,
//
//                       // percent: 0.3,
//                       percent: (double.parse(currentTime) / totalTime),
//
//                       center: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           new Text(
//                             currentTime,
//                             style: TextStyle(
//                                 fontFamily: Constants.fontsFamily,
//                                 color: textColor,
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: ConstantWidget.getPercentSize(
//                                     firstHeight, 8)),
//                           ),
//                           ConstantWidget.getTextWidget(
//                               "Seconds",
//                               textColor,
//                               TextAlign.start,
//                               FontWeight.w500,
//                               ConstantWidget.getPercentSize(firstHeight, 4)),
//                         ],
//                       ),
//                       progressColor: accentColor,
//                       backgroundColor: cellColor,
//                     ),
//                   ),
//                   flex: 1,
//                 )
//               ],
//             ),
//           ),
//           Expanded(
//             flex: 1,
//             child: Container(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   SizedBox(
//                     height: ConstantWidget.getScreenPercentSize(context, 1),
//                   ),
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: margin),
//                     child: ConstantWidget.getTextWidget(
//                         "Coming Up",
//                         textColor,
//                         TextAlign.start,
//                         FontWeight.bold,
//                         ConstantWidget.getPercentSize(remainHeight, 5)),
//                   ),
//                   SizedBox(
//                     height: ConstantWidget.getScreenPercentSize(context, 1.5),
//                   ),
//                   ConstantWidget.getShadowWidget(
//                       widget: GestureDetector(
//                         child: Card(
//                           color: Colors.transparent,
//                           elevation: 0,
//                           shape: RoundedRectangleBorder(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(radius))),
//                           margin: EdgeInsets.symmetric(
//                               horizontal: margin, vertical: margin),
//                           child: Container(
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 Container(
//                                   padding: EdgeInsets.all(
//                                       Constants.getPercentSize(cellSize, 5)),
//                                   height: cellSize,
//                                   width: cellSize,
//                                   decoration: getDefaultDecoration(
//                                       bgColor: cellColor, radius: radius),
//                                   child: Image.network(
//                                     "${ConstantUrl.uploadUrl}${widget._modelExerciseDetail.image}",
//                                     width: double.infinity,
//                                     height: double.infinity,
//                                     fit: BoxFit.contain,
//                                     errorBuilder: (context, error, stackTrace) {
//
//
//                                       return getPlaceHolder();
//                                     },
//                                   ),
//                                 ),
//                                 SizedBox(
//                                   width: ConstantWidget.getWidthPercentSize(
//                                       context, 3.5),
//                                 ),
//                                 Expanded(
//                                   child: Column(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       ConstantWidget.getCustomTextWidget(
//                                           widget._modelExerciseDetail
//                                               .exerciseName!,
//                                           textColor,
//                                           ConstantWidget.getScreenPercentSize(
//                                               context, 1.8),
//                                           FontWeight.bold,
//                                           TextAlign.start,
//                                           1),
//                                       SizedBox(
//                                         height:
//                                             ConstantWidget.getScreenPercentSize(
//                                                 context, 0.5),
//                                       ),
//                                       ConstantWidget.getTextWidget(
//                                           "${widget._modelExerciseDetail.exerciseTime!} ${S.of(context).seconds}",
//                                           subTextColor,
//                                           TextAlign.start,
//                                           FontWeight.w500,
//                                           ConstantWidget.getScreenPercentSize(
//                                               context, 1.6)),
//                                     ],
//                                   ),
//                                   flex: 1,
//                                 ),
//                                 IconButton(
//                                   onPressed: () {
//                                     Exercise exerciseDetail =
//                                         widget._modelExerciseDetail;
//                                     isSkipDialogOpen = true;
//
//                                     pauseSkip();
//                                     showBottomDialog(exerciseDetail);
//                                   },
//                                   padding: EdgeInsets.all(7),
//                                   icon: Icon(
//                                     Icons.more_vert_rounded,
//                                     color: Colors.black,
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                         onTap: () {},
//                       ),
//                       margin: margin,
//                       radius: ConstantWidget.getScreenPercentSize(context, 2)),
//                   Container(
//                     margin: EdgeInsets.symmetric(vertical: margin),
//                     child: StepProgressIndicator(
//                       totalSteps: widget.totalPos,
//                       currentStep: widget.currentPos,
//                       selectedColor: textColor,
//                       customStep: (int, Color, double) {
//                         return Container(
//                           height: 2,
//                           decoration: BoxDecoration(
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(5)),
//                               color: (int < widget.currentPos)
//                                   ? textColor
//                                   : Colors.transparent),
//                         );
//                       },
//                       unselectedColor: Colors.transparent,
//                     ),
//                   ),
//                   Expanded(
//                     child: Container(),
//                     flex: 1,
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: margin),
//                     child: Row(
//                       children: [
//                         GestureDetector(
//                           onTap: () {
//                             skipTime = skipTime + 20;
//                             totalTime = totalTime + 20;
//                           },
//                           child: Container(
//                             padding: EdgeInsets.symmetric(
//                                 horizontal: margin, vertical: (margin / 2)),
//                             decoration: BoxDecoration(
//                                 borderRadius: BorderRadius.all(
//                                   Radius.circular(20),
//                                 ),
//                                 color: cellColor),
//                             child: ConstantWidget.getTextWidget(
//                                 "+ 20 sec",
//                                 textColor,
//                                 TextAlign.start,
//                                 FontWeight.bold,
//                                 ConstantWidget.getPercentSize(remainHeight, 4)),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: margin / 2,
//                   ),
//                   Container(
//                     margin: EdgeInsets.symmetric(horizontal: margin),
//                     child: ConstantWidget.getBorderButtonWidget(context, "Skip",
//                         () {
//                       widget._functionSkip();
//                     }),
//                   ),
//                   SizedBox(
//                     height: margin / 2,
//                   )
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void showBottomDialog(Exercise exerciseDetail) {
//     showModalBottomSheet<void>(
//       enableDrag: true,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       context: context,
//       builder: (context) {
//         return Container(
//           width: double.infinity,
//           height: SizeConfig.safeBlockVertical! * 72,
//           decoration: getDecorationWithSide(
//               radius: ConstantWidget.getScreenPercentSize(context, 4.5),
//               bgColor: bgDarkWhite,
//               isTopLeft: true,
//               isTopRight: true),
//           child: ListView(
//             padding: EdgeInsets.symmetric(
//                 horizontal: ConstantWidget.getScreenPercentSize(context, 1.6)),
//             shrinkWrap: true,
//             scrollDirection: Axis.vertical,
//             primary: false,
//             children: [
//               SizedBox(height: ConstantWidget.getScreenPercentSize(context, 4)),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: ConstantWidget.getCustomTextWidget(
//                         exerciseDetail.exerciseName!,
//                         Colors.black,
//                         ConstantWidget.getScreenPercentSize(context, 2.5),
//                         FontWeight.bold,
//                         TextAlign.start,
//                         1),
//                   ),
//                   getDefaultButton(context, function: () {
//                     Navigator.pop(context);
//                   })
//                 ],
//               ),
//               SizedBox(
//                   height: ConstantWidget.getScreenPercentSize(context, 1.5)),
//               Container(
//                 width: double.infinity,
//                 height: SizeConfig.safeBlockVertical! * 45,
//                 child: Center(
//                   child: Container(
//                     width: double.infinity,
//                     height: double.infinity,
//                     child: Stack(children: [
//                       Image.network(
//                         "${ConstantUrl.uploadUrl}${exerciseDetail.image}",
//                         height: double.infinity,
//                         width: double.infinity,
//                         fit: BoxFit.contain,
//                         errorBuilder: (context, error, stackTrace) {
//                           return getPlaceHolder();
//                         },
//                       ),
//                     ]),
//                   ),
//                 ),
//               ),
//               Container(
//                 decoration: getDefaultDecoration(
//                     radius: ConstantWidget.getScreenPercentSize(context, 2),
//                     bgColor: cellColor),
//                 padding: EdgeInsets.all(
//                     ConstantWidget.getScreenPercentSize(context, 2)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ConstantWidget.getCustomTextWidget(
//                         'How to perform',
//                         textColor,
//                         ConstantWidget.getScreenPercentSize(context, 2),
//                         FontWeight.bold,
//                         TextAlign.start,
//                         1),
//                     SizedBox(
//                       height: ConstantWidget.getScreenPercentSize(context, 1.2),
//                     ),
//                     HtmlWidget(
//                       Constants.decode(exerciseDetail.description ?? ""),
//                       textStyle: TextStyle(
//                           wordSpacing: 2,
//                           color: textColor,
//                           fontSize:
//                               ConstantWidget.getScreenPercentSize(context, 1.8),
//                           fontFamily: Constants.fontsFamily,
//                           fontWeight: FontWeight.w400),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     ).whenComplete(() {
//       isSkipDialogOpen = false;
//       resumeSkip();
//     });
//   }
//
//   void pauseSkip() {
//     if (_timer != null) {
//       cancelSkipTimer();
//     }
//   }
//
//   void resumeSkip() {
//     if (_timer == null) {
//       setSkipTimer();
//     }
//   }
// }
//
// // ignore: must_be_immutable
// class WidgetDetailData extends StatefulWidget {
//   Exercise _modelExerciseList;
//   Exercise _modelExerciseDetail;
//   bool fromFirst;
//   Function timerPreOverCallback;
//   Function timerOverCallback;
//   Function muteOverCallback;
//   Function backClick;
//   final int readyDuration;
//   final bool isReady;
//   Function setReadyFunction;
//   Function _functionSkipTick;
//   AudioPlayer audioPlayer;
//
//   WidgetDetailData(
//       this._modelExerciseList,
//       this._modelExerciseDetail,
//       this.timerOverCallback,
//       this.timerPreOverCallback,
//       this.fromFirst,
//       this.isReady,
//       this.readyDuration,
//       this.setReadyFunction,
//       this.muteOverCallback,
//       this._functionSkipTick,
//       this.audioPlayer,
//       this.backClick);
//
//   @override
//   State<StatefulWidget> createState() => _WidgetDetailData();
// }
//
// class _WidgetDetailData extends State<WidgetDetailData>
//     with WidgetsBindingObserver {
//   int totalTimerTime = 0;
//   String currentTime = "";
//   Timer? _timer;
//   AdsFile? adsFile;
//   YoutubePlayerController? _controller;
//
//   RxBool isVideoPlaying =false.obs;
//
//   @override
//   void initState() {
//     Future.delayed(Duration.zero, () {
//       adsFile = new AdsFile(context);
//       adsFile!.createAnchoredBanner(context, setState);
//     });
//     _timer = null;
//     WidgetsBinding.instance.addObserver(this);
//     print("_modelExerciseList===${widget._modelExerciseList.videoUrl}");
//
//     if (widget._modelExerciseList.videoUrl != null &&
//         widget._modelExerciseList.videoUrl!.isNotEmpty) {
//       // _controller = YoutubePlayerController(
//       //   initialVideoId: widget._modelExerciseList.videoUrl!,
//       //   flags: const YoutubePlayerFlags(
//       //       mute: false,
//       //       autoPlay: true,
//       //       disableDragSeek: false,
//       //       loop: false,
//       //       isLive: false,
//       //       forceHD: false,
//       //       enableCaption: true,
//       //       showLiveFullscreenButton: false),
//       // );
//       initVideo();
//     }
//
//     super.initState();
//   }
//
//   initVideo() async {
//     // VideoPlayerController
//     videoController =
//         // VideoPlayerController.network("https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4");
//         VideoPlayerController.network(
//             ConstantUrl.uploadUrl + widget._modelExerciseList.videoUrl!);
//     await videoController!.initialize().then((value) {});
//
//     videoController!.addListener(() {
//       if (videoController!.value.isPlaying) {
//         print('video Ended');
//         isVideoPlaying.value = true;
//       } else {
//
//
//       }
//
//     });
//
//     chewieController = ChewieController(
//       videoPlayerController: videoController!,
//       autoPlay: true,
//       looping: true,
//
//     );
//
//     if (widget.audioPlayer != null) {
//       widget.audioPlayer.stopAudio();
//     }
//   }
//
//   void showSoundDialog() async {
//     bool isSwitched = await PrefData().getIsMute();
//     bool isSwitchedSound = await PrefData().getIsSoundOn();
//
//     double margin = ConstantWidget.getWidthPercentSize(context, 4);
//     if (widget.audioPlayer != null) {
//       widget.audioPlayer.stopAudio();
//     }
//     showModalBottomSheet<void>(
//       enableDrag: true,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       context: context,
//       builder: (context) {
//         return Container(
//           width: double.infinity,
//           height: SizeConfig.safeBlockVertical! * 40,
//           decoration: getDecorationWithSide(
//               radius: ConstantWidget.getScreenPercentSize(context, 4.5),
//               bgColor: bgDarkWhite,
//               isTopLeft: true,
//               isTopRight: true),
//           child: StatefulBuilder(builder: (context, setState) {
//             return ListView(
//               padding: EdgeInsets.symmetric(horizontal: margin),
//               shrinkWrap: true,
//               scrollDirection: Axis.vertical,
//               primary: false,
//               children: [
//                 SizedBox(
//                     height: ConstantWidget.getScreenPercentSize(context, 4)),
//                 Row(
//                   children: [
//                     Expanded(
//                       flex: 1,
//                       child: ConstantWidget.getCustomTextWidget(
//                           'Sound',
//                           Colors.black,
//                           ConstantWidget.getScreenPercentSize(context, 2.5),
//                           FontWeight.bold,
//                           TextAlign.start,
//                           1),
//                     ),
//                     getDefaultButton(context, function: () {
//                       Navigator.pop(context);
//                     })
//                   ],
//                 ),
//                 SizedBox(
//                     height: ConstantWidget.getScreenPercentSize(context, 1.5)),
//                 SizedBox(
//                     height: ConstantWidget.getScreenPercentSize(context, 2.5)),
//                 ConstantWidget.getShadowWidget(
//                     widget: Row(
//                       children: [
//                         SvgPicture.asset(
//                           Constants.assetsImagePath + 'volume.svg',
//                           height:
//                               ConstantWidget.getScreenPercentSize(context, 3),
//                         ),
//                         SizedBox(
//                           width: margin / 2,
//                         ),
//                         Expanded(
//                           child: ConstantWidget.getCustomTextWidget(
//                               'TTS Voice',
//                               textColor,
//                               ConstantWidget.getScreenPercentSize(context, 2),
//                               FontWeight.w500,
//                               TextAlign.start,
//                               1),
//                           flex: 1,
//                         ),
//                         Transform.scale(
//                           scale: 0.8,
//                           child: CupertinoSwitch(
//                             value: isSwitched,
//                             onChanged: (value) {
//                               setState(() {
//                                 isSwitched = value;
//                               });
//                             },
//                             trackColor: bgColor,
//                             thumbColor: Colors.white,
//                             activeColor: accentColor,
//                           ),
//                         )
//                       ],
//                     ),
//                     radius: ConstantWidget.getScreenPercentSize(context, 2),
//                     leftPadding: margin,
//                     rightPadding: margin,
//                     bottomPadding: (margin / 2),
//                     topPadding: (margin / 2)),
//                 SizedBox(
//                     height: ConstantWidget.getScreenPercentSize(context, 2.5)),
//                 ConstantWidget.getShadowWidget(
//                     widget: Row(
//                       children: [
//                         SvgPicture.asset(
//                           Constants.assetsImagePath + 'volume.svg',
//                           height:
//                               ConstantWidget.getScreenPercentSize(context, 3),
//                         ),
//                         SizedBox(
//                           width: margin / 2,
//                         ),
//                         Expanded(
//                           child: ConstantWidget.getCustomTextWidget(
//                               'Sound',
//                               textColor,
//                               ConstantWidget.getScreenPercentSize(context, 2),
//                               FontWeight.w500,
//                               TextAlign.start,
//                               1),
//                           flex: 1,
//                         ),
//                         Transform.scale(
//                           scale: 0.8,
//                           child: CupertinoSwitch(
//                             value: isSwitchedSound,
//                             onChanged: (value) {
//                               setState(() {
//                                 isSwitchedSound = value;
//                               });
//                             },
//                             trackColor: bgColor,
//                             thumbColor: Colors.white,
//                             activeColor: accentColor,
//                           ),
//                         )
//                       ],
//                     ),
//                     radius: ConstantWidget.getScreenPercentSize(context, 2),
//                     leftPadding: margin,
//                     rightPadding: margin,
//                     topPadding: (margin / 2),
//                     bottomPadding: (margin / 2)),
//                 SizedBox(
//                   height: ConstantWidget.getScreenPercentSize(context, 1.3),
//                 ),
//                 ConstantWidget.getButtonWidget(context, 'Save', blueButton,
//                     () async {
//                   widget.muteOverCallback();
//                   PrefData().setIsMute(isSwitched);
//                   PrefData().setIsSoundOn(isSwitchedSound);
//
//                   if (widget._modelExerciseList.videoUrl == null ||
//                       widget._modelExerciseList.videoUrl!.isEmpty) {
//                     if (widget.audioPlayer != null) {
//                       widget.audioPlayer.playAudio("audio1.mp3");
//                     }
//                   }
//                   Navigator.pop(context);
//                 }),
//                 SizedBox(
//                   height: margin,
//                 ),
//               ],
//             );
//           }),
//         );
//       },
//     ).then((value) => pauseTimer());
//   }
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     print('state = $state');
//     if (state == AppLifecycleState.paused) {
//       if (_timer != null) {
//         pauseTimer();
//       }
//     } else if (state == AppLifecycleState.resumed) {
//       pauseTimer();
//     }
//   }
//
//   IconData getPlayPauseIcon() {
//     if (_timer == null) {
//       return Icons.play_arrow_rounded;
//     } else {
//       return Icons.pause_rounded;
//     }
//   }
//
//
//
//   void cancelTimer() {
//     if (_timer != null) {
//       _timer!.cancel();
//       _timer = null;
//     }
//   }
//
//   void startTimer() {
//     const oneSec = const Duration(seconds: 1);
//     _timer = new Timer.periodic(
//         oneSec,
//         (Timer timer) => {
//               if (mounted)
//                 {
//                   setState(
//                     () {
//                       if (totalTimerTime < 1) {
//                         if (!widget.isReady) {
//                           widget.setReadyFunction();
//                         } else {
//                           cancelTimer();
//                           widget.timerOverCallback(widget._modelExerciseDetail);
//                         }
//                       } else {
//                         totalTimerTime = totalTimerTime - 1;
//                       }
//                       if (!widget.isReady) {
//                         if (totalTimerTime < Constants.maxTime &&
//                             totalTimerTime > Constants.minTime) {
//                           widget._functionSkipTick(totalTimerTime.toString());
//                         }
//                       }
//                       currentTime = totalTimerTime.toString();
//                     },
//                   ),
//                 }
//             });
//   }
//
//   @override
//   void dispose() {
//     disposeBannerAd(adsFile);
//     WidgetsBinding.instance.removeObserver(this);
//     cancelTimer();
//     if (chewieController != null) {
//       chewieController!.dispose();
//       chewieController = null;
//     }  if (videoController != null) {
//       videoController!.dispose();
//       videoController = null;
//     }
//     super.dispose();
//   }
//
//   void showBottomDialog(Exercise exerciseDetail, bool isVideo) {
//     showModalBottomSheet<void>(
//       enableDrag: true,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       context: context,
//       builder: (context) {
//         return Container(
//           width: double.infinity,
//           height: SizeConfig.safeBlockVertical! * 72,
//           decoration: getDecorationWithSide(
//               radius: ConstantWidget.getScreenPercentSize(context, 4.5),
//               bgColor: bgDarkWhite,
//               isTopLeft: true,
//               isTopRight: true),
//           child: ListView(
//             padding: EdgeInsets.symmetric(
//                 horizontal: ConstantWidget.getScreenPercentSize(context, 1.6)),
//             shrinkWrap: true,
//             scrollDirection: Axis.vertical,
//             primary: false,
//             children: [
//               SizedBox(height: ConstantWidget.getScreenPercentSize(context, 4)),
//               Row(
//                 children: [
//                   Expanded(
//                     flex: 1,
//                     child: ConstantWidget.getCustomTextWidget(
//                         exerciseDetail.exerciseName!,
//                         Colors.black,
//                         ConstantWidget.getScreenPercentSize(context, 2.5),
//                         FontWeight.bold,
//                         TextAlign.start,
//                         1),
//                   ),
//                   getDefaultButton(context, function: () {
//                     Navigator.pop(context);
//                   })
//                 ],
//               ),
//               SizedBox(
//                   height: ConstantWidget.getScreenPercentSize(context, 1.5)),
//               Container(
//                 width: double.infinity,
//                 height: SizeConfig.safeBlockVertical! * 45,
//                 child: Center(
//                   child: Container(
//                     width: double.infinity,
//                     height: double.infinity,
//                     child: Stack(children: [
//                       Image.network(
//                         "${ConstantUrl.uploadUrl}${exerciseDetail.image}",
//                         height: double.infinity,
//                         width: double.infinity,
//                         fit: BoxFit.contain,
//                         errorBuilder: (context, error, stackTrace) {
//
//
//                           return getPlaceHolder();
//                         },
//                       ),
//                     ]),
//                   ),
//                 ),
//               ),
//               Container(
//                 decoration: getDefaultDecoration(
//                     radius: ConstantWidget.getScreenPercentSize(context, 2),
//                     bgColor: cellColor),
//                 padding: EdgeInsets.all(
//                     ConstantWidget.getScreenPercentSize(context, 2)),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     ConstantWidget.getCustomTextWidget(
//                         'How to perform',
//                         textColor,
//                         ConstantWidget.getScreenPercentSize(context, 2),
//                         FontWeight.bold,
//                         TextAlign.start,
//                         1),
//                     SizedBox(
//                       height: ConstantWidget.getScreenPercentSize(context, 1.2),
//                     ),
//                     HtmlWidget(
//                       Constants.decode(exerciseDetail.description ?? ""),
//                       textStyle: TextStyle(
//                           wordSpacing: 2,
//                           color: textColor,
//                           fontSize:
//                               ConstantWidget.getScreenPercentSize(context, 1.8),
//                           fontFamily: Constants.fontsFamily,
//                           fontWeight: FontWeight.w400),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         );
//       },
//     ).then((value) => pauseTimer());
//   }
//
//   ValueNotifier<int> selectedPage = ValueNotifier(0);
//
//   @override
//   Widget build(BuildContext context) {
//     if (!widget.isReady) {
//       if (_timer == null) {
//         currentTime = widget.readyDuration.toString();
//         totalTimerTime = widget.readyDuration;
//         startTimer();
//       }
//     } else {
//       if (widget.fromFirst) {
//         widget.fromFirst = false;
//
//         if (widget._modelExerciseList.exerciseTime == null ||
//             widget._modelExerciseList.exerciseTime!.isEmpty) {
//           currentTime = "0";
//           totalTimerTime = 0;
//         } else {
//           currentTime = widget._modelExerciseList.exerciseTime!;
//           totalTimerTime = int.parse(widget._modelExerciseList.exerciseTime!);
//         }
//
//         if (_timer == null) {
//           startTimer();
//         }
//       }
//     }
//     double progressCircle = ConstantWidget.getScreenPercentSize(context, 18);
//
//     double margin = ConstantWidget.getWidthPercentSize(context, 3);
//
//     return Container(
//       height: double.infinity,
//       width: double.infinity,
//       color: bgColor,
//       child: Stack(
//         children: [
//           Column(
//             children: [
//               Expanded(
//                 child: Container(),
//                 flex: 1,
//               ),
//               Container(
//                 height: ConstantWidget.getScreenPercentSize(context, 20),
//                 color: bgDarkWhite,
//               )
//             ],
//           ),
//           Column(
//             children: [
//               Expanded(
//                 flex: 1,
//                 child: Container(
//                   child: Stack(
//                     children: [
//                       // Center(
//                       //   child: Image.network(
//                       //     "${ConstantUrl.uploadUrl}${widget._modelExerciseDetail.image}",
//                       //     fit: BoxFit.contain,
//                       //     height: double.infinity,
//                       //     width: double.infinity,
//                       //   ),
//                       // ),
//
//                       widget._modelExerciseList.videoUrl != null &&
//                               widget._modelExerciseList.videoUrl!.isNotEmpty
//                           ? Center(
//                               child: PageView.builder(
//                                 onPageChanged: (page) {
//                                   selectedPage.value = page;
//                                 },
//                                 itemBuilder: (context, index) {
//                                   return index == 0
//                                       ? Image.network(
//                                           ConstantUrl.uploadUrl +
//                                               widget._modelExerciseList.image!,
//                                           fit: BoxFit.contain,
//                                           height: double.infinity,
//                                           width: double.infinity,
//
//                                     errorBuilder: (context, error, stackTrace) {
//
//
//                                       return getPlaceHolder();
//                                     },
//
//                                         )
//                                       : Center(
//                                           child: Container(
//                                             margin: EdgeInsets.symmetric(
//                                                 vertical: ConstantWidget
//                                                     .getScreenPercentSize(
//                                                         context, 3)),
//                                             // child: YoutubePlayer(
//                                             //     controller: _controller!,
//                                             //     showVideoProgressIndicator: true,
//                                             //     progressIndicatorColor: Colors.amber,
//                                             //     width: double.infinity,
//                                             //     onReady: () {},
//                                             //   ),
//                                             child:
//                                             Obx(() => !isVideoPlaying.value||chewieController == null
//                                                 ?
//                                             getVideoProgressDialog()
//                                                 :
//                                             Chewie(
//                                               controller: chewieController!,
//                                             )),
//                                           ),
//                                         );
//                                 },
//                               ),
//                             )
//                           : Image.network(
//                               ConstantUrl.uploadUrl +
//                                   widget._modelExerciseList.image!,
//                               fit: BoxFit.contain,
//                               height: double.infinity,
//                               width: double.infinity,
//                         errorBuilder: (context, error, stackTrace) {
//
//
//                           return getPlaceHolder();
//                         },
//                             ),
//
//                       Visibility(
//                         visible: widget._modelExerciseList.videoUrl != null &&
//                             widget._modelExerciseList.videoUrl!.isNotEmpty,
//                         child: ValueListenableBuilder(
//                           valueListenable: selectedPage,
//                           builder: (context, value, child) {
//                             return Align(
//                               alignment: Alignment.bottomCenter,
//                               child: Padding(
//                                 padding: EdgeInsets.symmetric(
//                                     vertical:
//                                         ConstantWidget.getScreenPercentSize(
//                                             context, 2.5)),
//                                 child: PageViewDotIndicator(
//                                   currentItem: selectedPage.value,
//                                   count: 2,
//                                   unselectedColor: Colors.black26,
//                                   selectedColor: Colors.black,
//                                   duration: Duration(milliseconds: 200),
//                                   boxShape: BoxShape.circle,
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       ),
//
//                       Align(
//                         alignment: Alignment.topRight,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.start,
//                           crossAxisAlignment: CrossAxisAlignment.end,
//                           children: [
//                             Padding(
//                               padding: EdgeInsets.symmetric(
//                                   horizontal: margin, vertical: margin),
//                               child: Stack(
//                                 children: [
//                                   Center(
//                                     child: Container(
//                                       child:
//                                           ConstantWidget.getCustomTextWithFontFamilyWidget(
//                                               widget._modelExerciseDetail
//                                                   .exerciseName!,
//                                               textColor,
//                                               ConstantWidget
//                                                   .getScreenPercentSize(
//                                                       context, 2.2),
//                                               FontWeight.bold,
//                                               TextAlign.center,
//                                               1),
//                                     ),
//                                   ),
//                                   Align(
//                                     alignment: Alignment.centerLeft,
//                                     child: Visibility(
//                                       child: getDefaultBackButton(context,
//                                           function: () {
//                                         widget.backClick();
//                                       }),
//                                       visible: widget.isReady,
//                                     ),
//                                   ),
//                                   Align(
//                                     alignment: Alignment.centerRight,
//                                     child: GestureDetector(
//                                       onTap: () {
//                                         pauseTimer();
//                                         showSoundDialog();
//                                       },
//                                       child: SvgPicture.asset(
//                                         Constants.assetsImagePath +
//                                             'volume.svg',
//                                         height:
//                                             ConstantWidget.getScreenPercentSize(
//                                                 context, 3),
//                                       ),
//                                     ),
//                                   )
//                                 ],
//                               ),
//                             ),
//                             Padding(
//                               padding: EdgeInsets.symmetric(horizontal: margin),
//                               child: GestureDetector(
//                                 onTap: () {
//                                   pauseTimer();
//                                   showBottomDialog(
//                                       widget._modelExerciseDetail,
//                                       (widget._modelExerciseList.videoUrl !=
//                                               null &&
//                                           widget._modelExerciseList.videoUrl!
//                                               .isNotEmpty));
//                                 },
//                                 child: SvgPicture.asset(
//                                   Constants.assetsImagePath + 'Info.svg',
//                                   height: ConstantWidget.getScreenPercentSize(
//                                       context, 3),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       )
//                     ],
//                   ),
//                 ),
//               ),
//               Visibility(
//                 visible: !widget.isReady,
//                 child: Column(
//                   children: [
//                     Container(
//                       height: ConstantWidget.getScreenPercentSize(context, 3.8),
//                       margin: EdgeInsets.symmetric(
//                           horizontal:
//                               ConstantWidget.getWidthPercentSize(context, 4)),
//                     ),
//                     ConstantWidget.getShadowWidget(
//                         widget: Column(
//                           children: [
//                             ConstantWidget.getTextWidget(
//                                 currentTime,
//                                 Colors.black,
//                                 TextAlign.start,
//                                 FontWeight.bold,
//                                 ConstantWidget.getScreenPercentSize(
//                                     context, 4)),
//                             SizedBox(
//                               height: ConstantWidget.getScreenPercentSize(
//                                   context, 2),
//                             ),
//                             ConstantWidget.getTextWidget(
//                                 "Ready to go!",
//                                 Colors.black,
//                                 TextAlign.start,
//                                 FontWeight.w500,
//                                 ConstantWidget.getScreenPercentSize(
//                                     context, 2)),
//                             SizedBox(
//                               height: ConstantWidget.getScreenPercentSize(
//                                   context, 2),
//                             ),
//                             Container(
//                               margin:
//                                   EdgeInsets.symmetric(horizontal: margin * 2),
//                               child: ConstantWidget.getButtonWidget(
//                                   context, 'Skip', blueButton, () {
//                                 setState(() {
//                                   cancelTimer();
//                                   widget.setReadyFunction();
//                                 });
//                               }),
//                             ),
//                             SizedBox(
//                               height: ConstantWidget.getScreenPercentSize(
//                                   context, 1),
//                             )
//                           ],
//                         ),
//                         margin: ConstantWidget.getWidthPercentSize(context, 4),
//                         radius: ConstantWidget.getScreenPercentSize(context, 2),
//                         topPadding:
//                             ConstantWidget.getScreenPercentSize(context, 2)),
//                   ],
//                 ),
//               ),
//               Visibility(
//                 // visible: true,
//                 visible: widget.isReady,
//                 child: Stack(
//                   children: [
//                     Container(
//                       margin: EdgeInsets.only(
//                           top: ConstantWidget.getScreenPercentSize(
//                               context, 3.8)),
//                       child: ConstantWidget.getShadowWidget(
//                           widget: Opacity(opacity: 0, child: getActionWidget()),
//                           margin:
//                               ConstantWidget.getWidthPercentSize(context, 4),
//                           radius:
//                               ConstantWidget.getScreenPercentSize(context, 2)),
//                     ),
//                     Align(
//                       alignment: Alignment.topCenter,
//                       child: Container(
//                           height: progressCircle,
//                           width: progressCircle,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: bgDarkWhite,
//                           ),
//                           padding: EdgeInsets.all(ConstantWidget.getPercentSize(
//                               progressCircle, 13)),
//                           child: Stack(
//                             children: [
//                               Align(
//                                 alignment: Alignment.topCenter,
//                                 child: new CircularPercentIndicator(
//                                   radius: ConstantWidget.getPercentSize(
//                                       progressCircle, 36),
//                                   lineWidth: ConstantWidget.getPercentSize(
//                                       progressCircle, 3),
//                                   circularStrokeCap: CircularStrokeCap.round,
//                                   percent: (double.parse(currentTime) /
//                                       double.parse((widget
//                                           ._modelExerciseList.exerciseTime!))),
//                                   center: new Text(currentTime,
//                                       style: TextStyle(
//                                           fontFamily: Constants.fontsFamily,
//                                           color: Colors.black,
//                                           fontWeight: FontWeight.bold,
//                                           fontSize:
//                                               ConstantWidget.getPercentSize(
//                                                   progressCircle, 24))),
//                                   progressColor: accentColor,
//                                   backgroundColor: bgColor,
//                                 ),
//                               )
//                             ],
//                           )),
//                     ),
//                     getActionWidget(isActive: true),
//                   ],
//                 ),
//               ),
//               SizedBox(
//                 height: ConstantWidget.getScreenPercentSize(context, 5),
//               ),
//               Visibility(
//                 // visible: true,
//                 visible: widget.isReady, child: showBanner(adsFile),
//               )
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   getActionWidget({bool? isActive}) {
//     double subHeight = ConstantWidget.getScreenPercentSize(context, 4.2);
//     double circleSize = ConstantWidget.getScreenPercentSize(context, 6);
//     return Container(
//       padding:
//           EdgeInsets.only(top: ConstantWidget.getScreenPercentSize(context, 5)),
//       child: Column(
//         children: [
//           SizedBox(
//             height: ConstantWidget.getScreenPercentSize(context, 13),
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               GestureDetector(
//                 onTap: () {
//                   if (isActive != null) {
//                     cancelTimer();
//                     widget.timerPreOverCallback();
//                   }
//                 },
//                 child: Container(
//                   height: subHeight,
//                   width: subHeight,
//                   decoration: BoxDecoration(
//                       border: Border.all(
//                           color: Colors.grey.shade500,
//                           width: ConstantWidget.getPercentSize(subHeight, 6)),
//                       borderRadius: BorderRadius.all(Radius.circular(
//                           ConstantWidget.getPercentSize(subHeight, 44)))),
//                   child: Center(
//                     child: Icon(
//                       Icons.keyboard_backspace,
//                       color: Colors.grey.shade500,
//                       size: ConstantWidget.getPercentSize(subHeight, 70),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: ConstantWidget.getWidthPercentSize(context, 15),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   if (isActive != null) {
//                     pauseTimer();
//                   }
//                 },
//                 child: Container(
//                   height: circleSize,
//                   width: circleSize,
//                   decoration: BoxDecoration(
//                       color: textColor,
//                       border: Border.all(
//                           color: textColor,
//                           width: ConstantWidget.getPercentSize(circleSize, 6)),
//                       borderRadius: BorderRadius.all(Radius.circular(
//                           ConstantWidget.getPercentSize(circleSize, 40)))),
//                   child: Center(
//                     child: Icon(
//                       getPlayPauseIcon(),
//                       color: Colors.white,
//                       size: ConstantWidget.getPercentSize(circleSize, 70),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 width: ConstantWidget.getWidthPercentSize(context, 15),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   if (isActive != null) {
//                     cancelTimer();
//                     widget.timerOverCallback(widget._modelExerciseDetail);
//                   }
//                 },
//                 child: Container(
//                   height: subHeight,
//                   width: subHeight,
//                   decoration: BoxDecoration(
//                       border: Border.all(
//                           color: textColor,
//                           width: ConstantWidget.getPercentSize(subHeight, 6)),
//                       borderRadius: BorderRadius.all(Radius.circular(
//                           ConstantWidget.getPercentSize(subHeight, 44)))),
//                   child: Center(
//                     child: Transform.rotate(
//                       angle: math.pi,
//                       child: Icon(
//                         Icons.keyboard_backspace,
//                         color: textColor,
//                         size: ConstantWidget.getPercentSize(subHeight, 70),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   void pauseTimer() {
//     if (_timer != null) {
//       _timer!.cancel();
//       _timer = null;
//     } else {
//       startTimer();
//     }
//     setState(() {});
//   }
// }
//
// class _WidgetWorkout1 extends State<WidgetWorkout1> with WidgetsBindingObserver {
//   int pos = 0;
//   bool isSkip = false;
//   double getCal = 0;
//   int getTotalWorkout = 0;
//   List<ModelHistory> priceList = [];
//   int getTime = 0;
//
//   FlutterTts? flutterTts;
//
//   double volume = 0.5;
//   double pitch = 1.0;
//   double rate = 0.5;
//   int totalDuration = 0;
//   double totalCal = 0;
//   int exerciseDuration = 0;
//   String startTime = "";
//
//   bool isTtsOn = true;
//   bool isSoundOn = false;
//   bool isReady = false;
//
//   getMutes() async {
//     isTtsOn = await PrefData().getIsMute();
//     isSoundOn = await PrefData().getIsSoundOn();
//     setState(() {});
//   }
//
//   getMutesNoRefresh() async {
//     isTtsOn = await PrefData().getIsMute();
//     isSoundOn = await PrefData().getIsSoundOn();
//   }
//
//   void _calcTotal() async {
//     setState(() {
//       getTotalWorkout = 5;
//       getCal = 15 + getCal;
//       getTime = 10 + getTime;
//     });
//   }
//
//   void setDataByPos(Exercise detail) {
//     if (pos < widget._modelExerciseList.length) {
//       pos++;
//       isSkip = true;
//     } else {
//       isSkip = false;
//     }
//     exerciseDuration = 0;
//     playSound(false);
//     setState(() {});
//   }
//
//   void setPrevDataByPos() {
//     if (pos > 0) {
//       pos--;
//       isSkip = false;
//     }
//     setState(() {});
//   }
//
//   void setAfterSkip() {
//     isSkip = false;
//     playSound(true);
//
//     setState(() {});
//   }
//
//   @override
//   void dispose() {
//     adsFile!.disposeInterstitialAd();
//     disposeInterstitialAd(adsFile);
//     WidgetsBinding.instance.removeObserver(this);
//     if (audioPlayer != null) {
//       audioPlayer!.stopAudio();
//     }
//
//
//     if(chewieController!= null){
//       chewieController!.dispose();
//       chewieController=null;
//     }
//
//     if (videoController != null) {
//       videoController!.dispose();
//       videoController = null;
//     }
//     flutterTts!.stop();
//     try {
//       periodicAlDuration!.cancel();
//     } catch (e) {
//       print(e);
//     }
//     super.dispose();
//   }
//
//   void initTts() {}
//
//   iosTTs() async {
//     await flutterTts!.awaitSpeakCompletion(true);
//     await flutterTts!.setSharedInstance(true);
//     await flutterTts!
//         .setIosAudioCategory(IosTextToSpeechAudioCategory.playAndRecord, [
//       IosTextToSpeechAudioCategoryOptions.allowBluetooth,
//       IosTextToSpeechAudioCategoryOptions.allowBluetoothA2DP,
//       IosTextToSpeechAudioCategoryOptions.mixWithOthers
//     ]);
//   }
//
//   Timer? periodicAlDuration;
//
//   @override
//   void didChangeAppLifecycleState(AppLifecycleState state) {
//     if (state == AppLifecycleState.paused) {
//       try {} catch (e) {
//         print(e);
//       }
//     } else if (state == AppLifecycleState.resumed) {
//       getMutesNoRefresh();
//     }
//   }
//
//   AdsFile? adsFile;
//   AudioPlayer? audioPlayer;
//
//   @override
//   void initState() {
//     WidgetsBinding.instance.addObserver(this);
//     startTime = Constants.addDateFormat.format(new DateTime.now());
//     getMutes();
//     flutterTts = FlutterTts();
//     iosTTs();
//
//     Future.delayed(Duration.zero, () {
//       audioPlayer = new AudioPlayer(context);
//       adsFile = new AdsFile(context);
//       adsFile!.createInterstitialAd();
//     });
//
//     _calcTotal();
//     super.initState();
//
//     periodicAlDuration = Timer.periodic(Duration(seconds: 1), (timer) {
//       totalDuration++;
//       exerciseDuration++;
//     });
//   }
//
//   playSound(bool isSkip) async {}
//
//   playBgSound(String isSkip) async {
//
//     Exercise _modelExerciseDetail = widget._modelExerciseList[pos];
//
//     bool isSound = _modelExerciseDetail.videoUrl ==null || _modelExerciseDetail.videoUrl!.isEmpty;
//
//     if (audioPlayer != null && isSound) {
//
//
//
//       audioPlayer!.playAudio(isSkip);
//     }
//   }
//
//   void playSoundTicks(String val) {
//     playTickSound();
//     _speak(val);
//   }
//
//   playTickSound() async {}
//
//   Future<void> share() async {
//     String share = "${S.of(context).app_name}\n${Constants.getAppLink()}";
//     await FlutterShare.share(
//       title: 'Share',
//       text: share,
//     );
//   }
//
//   Future _speak(String txt) async {
//     isTtsOn = await PrefData().getIsMute();
//     if (isTtsOn) {
//       if (prevSpeak != txt) {
//         prevSpeak = txt;
//         await flutterTts!.speak(txt);
//       }
//     }
//   }
//
//   String prevSpeak = "";
//
//   void setReady() {
//     isReady = true;
//     setState(() {});
//   }
//
//   int readyDuration = 10;
//
//   getDetailWidget() {
//     Exercise _modelExerciseDetail = widget._modelExerciseList[pos];
//
//     if (isSkip) {
//       _speak("Take a rest");
//       // playBgSound("audio3.mp3");
//
//       return WidgetSkipData(_modelExerciseDetail, setAfterSkip, pos,
//           widget._modelExerciseList.length, playSoundTicks);
//     } else {
//       if (!isReady) {
//         _speak("Ready to go start with ${_modelExerciseDetail.exerciseName}");
//         playBgSound("audio1.mp3");
//       } else {
//         _speak(_modelExerciseDetail.exerciseName!);
//         playBgSound("audio2.mp3");
//       }
//
//       if (audioPlayer == null) {
//         return Container();
//       }
//       return WidgetDetailData(
//           widget._modelExerciseList[pos],
//           _modelExerciseDetail,
//           setDataByPos,
//           setPrevDataByPos,
//           true,
//           isReady,
//           readyDuration,
//           setReady,
//           getMutesNoRefresh,
//           playSoundTicks,
//           audioPlayer!,
//           backDialog);
//     }
//   }
//
//   double margin = 0;
//   HomeController controller = Get.put(HomeController());
//
//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     margin = ConstantWidget.getScreenPercentSize(context, 2);
//
//     return WillPopScope(
//       child: Scaffold(
//           appBar: getColorStatusBar(
//               (pos < widget._modelExerciseList.length) ? bgColor : bgDarkWhite),
//           body: SafeArea(
//             child: (pos < widget._modelExerciseList.length)
//                 ? getDetailWidget()
//                 : Container(
//                     height: double.infinity,
//                     width: double.infinity,
//                     color: bgDarkWhite,
//                     child: FutureBuilder(
//                       future: null,
//                       builder: (context, snapshot) {
//                         addWholeHistory(
//                             context,
//                             widget.totalCal,
//                             totalDuration,
//                             widget._modelDummySend.type,
//                             widget._modelDummySend.id);
//
//                         addHistoryData(
//                             context,
//                             "${widget._modelDummySend.name}",
//                             startTime,
//                             totalDuration,
//                             widget.totalCal,
//                             widget._modelDummySend.id,
//                             Constants.addDateFormat.format(new DateTime.now()));
//
//
//                         if(chewieController!=null){
//                           chewieController!.dispose();
//                           chewieController =null;
//                         }
//
//                         if (videoController != null) {
//                           videoController!.dispose();
//                           videoController = null;
//                         }
//
//                         if(audioPlayer!=null){
//                           audioPlayer!.stopAudio();
//                         }
//
//
//
//                         return Container(
//                           height: double.infinity,
//                           width: double.infinity,
//                           color: bgDarkWhite,
//                           child: Column(
//                             children: [
//                               Container(
//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: margin, vertical: margin),
//                                 child: Align(
//                                   alignment: Alignment.topRight,
//                                   child: GestureDetector(
//                                     child: SvgPicture.asset(
//                                       Constants.assetsImagePath + "share.svg",
//                                       height:
//                                           ConstantWidget.getScreenPercentSize(
//                                               context, 3),
//                                       color: textColor,
//                                     ),
//                                     onTap: () {
//                                       share();
//                                     },
//                                   ),
//                                 ),
//                               ),
//                               Container(
//                                 height: ConstantWidget.getScreenPercentSize(
//                                     context, 20),
//                                 margin: EdgeInsets.only(
//                                     bottom: ConstantWidget.getScreenPercentSize(
//                                         context, 4)),
//                                 child: Stack(
//                                   children: [
//                                     Center(
//                                       child: SvgPicture.asset(
//                                         Constants.assetsImagePath +
//                                             "vector.svg",
//                                         height:
//                                             ConstantWidget.getScreenPercentSize(
//                                                 context, 8),
//                                       ),
//                                     ),
//                                     Center(
//                                       child: Image.asset(
//                                         Constants.assetsImagePath +
//                                             "trophy_icon.png",
//                                         height: double.infinity,
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                               SvgPicture.asset(
//                                 Constants.assetsImagePath + "rating.svg",
//                                 height: ConstantWidget.getScreenPercentSize(
//                                     context, 7),
//                                 // width: SizeConfig.safeBlockHorizontal! * 50,
//                                 fit: BoxFit.contain,
//                               ),
//                               Expanded(
//                                 child: Container(),
//                                 flex: 1,
//                               ),
//                               ConstantWidget.getCustomText(
//                                   widget._modelDummySend.name,
//                                   textColor,
//                                   1,
//                                   TextAlign.start,
//                                   FontWeight.bold,
//                                   ConstantWidget.getScreenPercentSize(
//                                       context, 2.6)),
//                               Container(
//                                 margin: EdgeInsets.symmetric(
//                                     vertical:
//                                         ConstantWidget.getScreenPercentSize(
//                                             context, 2)),
//                                 child: Stack(
//                                   children: [
//                                     Align(
//                                       alignment: Alignment.topCenter,
//                                       child: SvgPicture.asset(
//                                         Constants.assetsImagePath +
//                                             "frame_view.svg",
//                                         height:
//                                             SizeConfig.safeBlockHorizontal! *
//                                                 23,
//                                         // width: SizeConfig.safeBlockHorizontal! * 50,
//                                         fit: BoxFit.contain,
//                                       ),
//                                     ),
//                                     Align(
//                                       alignment: Alignment.topCenter,
//                                       child: Container(
//                                         margin: EdgeInsets.only(
//                                             top: ConstantWidget
//                                                 .getScreenPercentSize(
//                                                     context, 1.3)),
//                                         child: ConstantWidget.getCustomText(
//                                             'Completed',
//                                             Colors.white,
//                                             1,
//                                             TextAlign.start,
//                                             FontWeight.bold,
//                                             ConstantWidget.getScreenPercentSize(
//                                                 context, 2.6)),
//                                       ),
//                                     )
//                                   ],
//                                 ),
//                               ),
//                               Container(
//                                 margin: EdgeInsets.symmetric(
//                                     horizontal: (margin / 2), vertical: margin),
//                                 child: Row(
//                                   children: [
//                                     getCompleteContent(
//                                         widget._modelExerciseList.length
//                                             .toString(),
//                                         S.of(context).exercises,
//                                         category2),
//                                     getCompleteContent(
//                                         Constants.calFormatter
//                                             .format(widget.totalCal),
//                                         S.of(context).kcal,
//                                         category3),
//                                     getCompleteContent(
//                                         Constants.getTimeFromSec(widget.time),
//                                         S.of(context).duration,
//                                         category4),
//                                   ],
//                                 ),
//                               ),
//                               Padding(
//                                 padding: EdgeInsets.all(margin),
//                                 child: GetBuilder<HomeController>(
//                                   init: HomeController(),
//                                   builder: (controller) =>
//                                       ConstantWidget.getButtonWidget(
//                                           context, "Continue", accentColor,
//                                           () async {
//                                     adsFile!.showInterstitialAd(
//                                       sendToNext,
//                                     );
//                                   }),
//                                 ),
//                               )
//                             ],
//                           ),
//                         );
//                       },
//                     ),
//                     // color: Colors.red,
//                   ),
//           )),
//       onWillPop: () async {
//         backDialog();
//         return false;
//       },
//     );
//   }
//
//   getCompleteContent(String s, String s1, Color color) {
//     return Expanded(
//       child: Container(
//         padding: EdgeInsets.symmetric(
//             vertical: ConstantWidget.getScreenPercentSize(context, 2)),
//         margin: EdgeInsets.symmetric(horizontal: (margin / 2)),
//         decoration: getDefaultDecoration(
//             radius: ConstantWidget.getScreenPercentSize(context, 1.8),
//             bgColor: color),
//         child: Column(
//           children: [
//             ConstantWidget.getTextWidget(
//                 s,
//                 textColor,
//                 TextAlign.start,
//                 FontWeight.bold,
//                 ConstantWidget.getScreenPercentSize(context, 2.2)),
//             SizedBox(
//               height: ConstantWidget.getScreenPercentSize(context, 0.3),
//             ),
//             ConstantWidget.getTextWidget(
//                 s1,
//                 textColor,
//                 TextAlign.start,
//                 FontWeight.w500,
//                 ConstantWidget.getScreenPercentSize(context, 1.8)),
//           ],
//         ),
//       ),
//       flex: 1,
//     );
//   }
//
//   void sendToNext() {
//     HomeController controller = Get.put(HomeController());
//     controller.onChange(3.obs);
//     sendHomePage(context, 3);
//   }
//
//   void backDialog() {
//     showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext contexts) {
//         return WillPopScope(
//           onWillPop: () async => false,
//           child: AlertDialog(
//             title: Text('Exit'),
//             content: Text('Do you really want to quite?'),
//             actions: <Widget>[
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(contexts).pop();
//                   Navigator.of(context).pop();
//                 },
//                 child: getSmallNormalText("YES", Colors.red, TextAlign.start),
//               ),
//               TextButton(
//                 onPressed: () {
//                   Navigator.of(contexts).pop();
//                 },
//                 child: getSmallNormalText("N0", Colors.red, TextAlign.start),
//               )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
