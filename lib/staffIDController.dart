import 'package:get/get.dart';
import 'package:haul_a_day_mobile/shared.dart';

class StaffIdController extends GetxController {
  RxString _staffId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Load staff ID from SharedPreferences when the controller is initialized
    loadStaffId();
  }

  Future<void> loadStaffId() async {
    String? storedStaffId = await Shared.getStaffId();
    if (storedStaffId != null) {
      _staffId.value = storedStaffId;
    }
  }

  void setStaffId(String id) async {
    _staffId.value = id;
    // Save staffId to SharedPreferences
    await Shared.saveStaffId(id);
  }

  String getStaffId() {
    print("STAFFID: ${_staffId.value}");
    return _staffId.value;
  }
}