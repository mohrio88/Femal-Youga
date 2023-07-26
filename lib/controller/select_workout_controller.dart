import 'package:get/get.dart';

import '../onlineData/dummy_data.dart';

class SelectWorkoutController extends GetxController {
  RxList<String> exerciseIdList = <String>[].obs;

  RxString categoryId = "1".obs;

  RxList<String> idList = <String>[].obs;

  onAddValue(String value) {
    if (!exerciseIdList.contains(value)) {
      exerciseIdList.add(value);

      update();
    }

    print("0nAdd----${exerciseIdList.length}");
  }

  onChangeIdList(var value) {
    exerciseIdList = value;
    update();
  }

  onRemoveValue(String value) {
    exerciseIdList.remove(value);
    idList.remove(value);
    update();
    print("onRemove----${exerciseIdList.length}");
  }

  onNotify() {
    update();
  }

  onOldIdList(List<String> value) {
    idList.value = value;
    update();
  }

  onChange(RxString value) {
    categoryId.value = value.value;
    update();
  }

  // onMakeList(int value) {
  //   duration = List<int>.generate(value, (index) => 10);
  //   update();
  // }

  addDuration(int index, String key, int data) {
    DummyData.setDuration(key, (data + 1));
    // duration[index] = duration[index] + 1;
    update();
  }

  minusDuration(int index, String key, int data) {
    if ((data - 1) >= 10) {
      DummyData.setDuration(key, (data - 1));
    }

    // duration[index] = duration[index] - 1;
    update();
  }
}
