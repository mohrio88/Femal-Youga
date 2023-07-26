import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt index = 0.obs;

  RxInt progressIndex = 0.obs;


  HomeController(){
    onChange(0.obs);
  }

  onProgressChange(RxInt value) {
    progressIndex.value = value.value;
    update();
  }

  onChange(RxInt value) {
    index.value = value.value;
    update();
  }
}