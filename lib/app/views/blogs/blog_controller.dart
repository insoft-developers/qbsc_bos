import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/blogs/blog_model.dart';

class BlogController extends GetxController {
  var isLoading = false.obs;
  var blogList = <BlogModel>[].obs;
  var isMoreDataAvailable = true.obs;

  final ApiProvider api = Get.find<ApiProvider>();

  int _page = 1;
  final int _limit = 20;

  @override
  void onInit() {
    super.onInit();
    fetchBlog();
  }

  // =========================
  // FETCH BLOG
  // =========================
  Future<void> fetchBlog({bool loadMore = false}) async {
    if (isLoading.value) return;

    if (!loadMore) {
      _page = 1;
      blogList.clear();
      isMoreDataAvailable.value = true;
    }

    if (!isMoreDataAvailable.value) return;

    isLoading.value = true;

    try {
      final response = await api.post(
        ApiEndpoint.blog,
        data: {
          'page': _page,
          'limit': _limit,
        },
      );

      final body = response.data;

      if (body['success'] == true) {
        final pagination = body['data'];

        final List<dynamic> listData = pagination['data'] ?? [];

        final int currentPage =
            pagination['current_page'] ?? _page;

        final int lastPage =
            pagination['last_page'] ?? _page;

        final fetchedData = listData
            .map((json) => BlogModel.fromJson(json))
            .toList();

        blogList.addAll(fetchedData);

        // =========================
        // STOP INFINITE SCROLL
        // =========================

        if (currentPage >= lastPage) {
          isMoreDataAvailable.value = false;
        } else {
          _page++;
        }
      } else {
        SnackbarHelper.error(
          'Warning',
          body['message'] ?? 'Data blog tidak ditemukan',
        );
      }
    } catch (e) {
      SnackbarHelper.error(
        'Warning',
        e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // =========================
  // LOAD MORE
  // =========================

  void loadMore() {
    if (!isLoading.value &&
        isMoreDataAvailable.value) {
      fetchBlog(loadMore: true);
    }
  }

  // =========================
  // REFRESH
  // =========================

  Future<void> refreshData() async {
    _page = 1;
    blogList.clear();
    isMoreDataAvailable.value = true;

    await fetchBlog();
  }
}