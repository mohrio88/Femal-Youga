import 'package:audioplayers/audioplayers.dart' as audio;
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

import '../PrefData.dart';



class AudioPlayer{

  BuildContext? context;


  audio.AudioPlayer? audioCache = audio.AudioPlayer();

  bool? _isSound = true;



  AudioPlayer(BuildContext context){
    this.context = context;
    setSound();
  }


  setSound()async{
    _isSound = await PrefData().getIsSoundOn();
  }

  void playAudio(String s) async {

  await  setSound();
    if (_isSound! && audioCache != null) {
      try{
        await audioCache!.play(AssetSource(s));
        await audioCache!.setReleaseMode(ReleaseMode.loop);
      }on Exception  catch(_) {
      }
    }
  }

  void stopAudio() async {
    if (_isSound! && audioCache != null) {
      await audioCache!.dispose();
    }
  }


}