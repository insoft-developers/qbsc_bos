import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';

class SliderpageController extends GetxController {
  final ApiProvider api = Get.find<ApiProvider>();

  RxList<String> sliderImages = <String>[].obs;
  RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchSliderImages();
  }

  Future<void> fetchSliderImages() async {
    try {
      isLoading.value = true;

      final res = await api.post(ApiEndpoint.slider);

      if (res.data['success']) {
        sliderImages.value = List<String>.from(
          res.data['data'].map((e) => e['image']),
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
