import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/slider/slider_model.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';

class SliderpageController extends GetxController {
  final ApiProvider api = Get.find<ApiProvider>();

  final RxList<SliderModel> sliderImages = <SliderModel>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSliderImages();
  }

  Future<void> fetchSliderImages() async {
    try {
      isLoading.value = true;
      int comid = int.parse(AppPrefs.getComId() ?? '0');

      final res = await api.post(ApiEndpoint.slider, data: {'comid': comid});

      if (res.data['success'] == true) {
        final List data = res.data['data'] ?? [];

        sliderImages.value = data
            .map((e) => SliderModel.fromJson(e))
            .toList();

        print("========== SLIDER IMAGES ==============");
        print(data);
        print("=======================================");
      }
    } catch (e) {
      debugPrint('Slider Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
