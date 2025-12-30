import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/controllers/auth_controller.dart';
import 'package:qbsc_saas/app/controllers/home_controller.dart';
import 'package:qbsc_saas/app/controllers/paket_controller.dart';
import 'package:qbsc_saas/app/data/api_endpoint.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/slider/sliderpage_controller.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';
import 'package:qbsc_saas/app/views/home/card_absensi.dart';
import 'package:qbsc_saas/app/views/home/card_controller.dart';
import 'package:qbsc_saas/app/views/home/card_satpam_detail.dart';
import 'package:qbsc_saas/app/views/laporan/resume_kandang.dart';
import 'package:qbsc_saas/app/views/user_area/user_area.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AuthController authC = Get.put(AuthController());
  final HomeController homeC = Get.put(HomeController());
  final PaketController _paket = Get.put(PaketController());

  final String? isPeternakan = AppPrefs.getIsPeternakan();

  final PageController _pageController = PageController(
    initialPage: 1000,
  ); // infinite
  int _currentSlide = 0;
  Timer? _timer;

  final List<String> sliderImages = [
    'https://images.unsplash.com/photo-1581090700227-1e37b190418e',
    'https://images.unsplash.com/photo-1581092160607-ee22621dd758',
    'https://images.unsplash.com/photo-1581092795360-fd1ca04f0952',
  ];

  late List<Map<String, dynamic>> menuItems;

  @override
  void initState() {
    super.initState();
    _loadUserPhoto();

    _initMenu();
    _autoSlide();
    _paket.checkPaket();
    _paket.checkUserArea();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _autoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    });
  }

  void _initMenu() {
    final baseMenu = [
      {'icon': 'assets/images/absensi.png', 'label': 'Monitoring Absensi'},
      {'icon': 'assets/images/patroli.png', 'label': 'Monitoring Patroli'},
      {'icon': 'assets/images/broadcast.png', 'label': 'Buat Broadcast'},

      {'icon': 'assets/images/kejadian.png', 'label': 'Laporan Situasi'},
      {'icon': 'assets/images/tamu.png', 'label': 'Monitoring Tamu'},
      {'icon': 'assets/images/setting.png', 'label': 'Pengaturan'},
    ];

    if (isPeternakan == '1') {
      baseMenu.insertAll(2, [
        {'icon': 'assets/images/kandang.png', 'label': 'Monitoring Kandang'},
        {'icon': 'assets/images/doc.png', 'label': 'Lihat Catatan DOC'},
        {
          'icon': 'assets/images/laporan.png',
          'label': 'Resume Laporan Kandang',
        },
      ]);
    }

    menuItems = baseMenu;
  }

  void _loadUserPhoto() {
    final photo = AppPrefs.getUserPhoto();
    if (photo != null && photo.isNotEmpty) {
      authC.userPhoto.value = photo;
    }
  }

  void _onMenuTap(String label) {
    final isArea = AppPrefs.getIsUserArea() ?? '0';
    if (label == 'Monitoring Absensi') {
      isArea == '1'
          ? Get.to(() => UserArea(menu: 'absensi'))
          : Get.toNamed('/absensi');
    } else if (label == 'Monitoring Patroli') {
      isArea == '1'
          ? Get.to(() => UserArea(menu: 'patroli'))
          : Get.toNamed('/patroli');
    } else if (label == 'Monitoring Kandang') {
      isArea == '1'
          ? Get.to(() => UserArea(menu: 'kandang'))
          : Get.toNamed('/kandang');
    } else if (label == 'Lihat Catatan DOC') {
      // Get.toNamed('/doc');

      isArea == '1' ? Get.to(() => UserArea(menu: 'doc')) : Get.toNamed('/doc');
    } else if (label == 'Buat Broadcast') {
      // Get.toNamed('/broadcast');
      isArea == '1'
          ? Get.to(() => UserArea(menu: 'broadcast'))
          : Get.toNamed('/broadcast');
    } else if (label == 'Laporan Situasi') {
      // Get.toNamed('/situasi');
      isArea == '1'
          ? Get.to(() => UserArea(menu: 'situasi'))
          : Get.toNamed('/situasi');
    } else if (label == 'Monitoring Tamu') {
      // Get.toNamed('/tamu');
      isArea == '1'
          ? Get.to(() => UserArea(menu: 'tamu'))
          : Get.toNamed('/tamu');
    } else if (label == 'Resume Laporan Kandang') {
      String comid = AppPrefs.getComId() ?? '0';
      isArea == '1'
          ? Get.to(() => UserArea(menu: 'resume'))
          : Get.to(
              () => ResumeKandang(
                url: '${ApiEndpoint.webviewResumeKandang}/$comid',
                title: "Resume Kandang",
              ),
            );
    } else if (label == 'Pengaturan') {
      Get.toNamed('/pengaturan');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileCard(),
            const SizedBox(height: 20),
            _buildImageSlider(),
            const SizedBox(height: 24),
            _buildSummarySection(),
            const SizedBox(height: 24),
            _buildMonitoringMenu(),
            const SizedBox(height: 44),
          ],
        ),
      ),
    );
  }

  // ================= APPBAR =================
  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0F172A),
      elevation: 0,
      title: const Text(
        'BOS Dashboard',
        style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
      ),
      actions: [
        Obx(
          () => Stack(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.notifications_outlined,
                  color: Colors.white,
                ),
                onPressed: () {
                  homeC.clear();
                  Get.toNamed('/notifikasi');
                },
              ),
              if (homeC.unreadCount.value > 0)
                Positioned(
                  right: 8,
                  top: 8,
                  child: CircleAvatar(
                    radius: 9,
                    backgroundColor: Colors.red,
                    child: Text(
                      homeC.unreadCount.value.toString(),
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
                ),
            ],
          ),
        ),
        IconButton(
          icon: const Icon(Icons.logout),
          onPressed: authC.logout,
          color: Colors.white,
        ),
      ],
    );
  }

  // ================= PROFILE =================
  Widget _buildProfileCard() {
    return Obx(() {
      final photo = "${ApiProvider.imageUrl}/${authC.userPhoto.value}";

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundImage: authC.userPhoto.value.isNotEmpty
                  ? NetworkImage(photo)
                  : const AssetImage('assets/images/satpam_default.png')
                        as ImageProvider,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    AppPrefs.getUserName() ?? '-',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    AppPrefs.getCompanyName() ?? '-',
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF34C759),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ================= SLIDER =================
  Widget _buildImageSlider() {
    final controller = Get.put(SliderpageController());

    return Obx(() {
      if (controller.isLoading.value) {
        return const SizedBox(height: 160, child: _HighContrastShimmer());
      }

      if (controller.sliderImages.isEmpty) {
        return const SizedBox(
          height: 160,
          child: Center(child: Text('Tidak ada gambar')),
        );
      }

      return Column(
        children: [
          SizedBox(
            height: 160,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentSlide = index % controller.sliderImages.length;
                  });
                },
                itemBuilder: (_, index) {
                  final imageUrl =
                      "${ApiProvider.imageUrl}/${controller.sliderImages[index % controller.sliderImages.length]}";
                  print(imageUrl);

                  return CachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    placeholder: (_, __) => const _HighContrastShimmer(),
                    errorWidget: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Icon(Icons.image_not_supported, size: 40),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 8),

          // indicator
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(controller.sliderImages.length, (i) {
              final active = _currentSlide == i;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 18 : 6,
                height: 6,
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFF0F172A)
                      : Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(6),
                ),
              );
            }),
          ),
        ],
      );
    });
  }

  // ================= SUMMARY =================
  Widget _buildSummarySection() {
    final dashboard = Get.put(CardController());

    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _SummaryCard(
            title: 'Satpam Masuk',
            value: dashboard.jumlahAbsensi.toString(),
          ),
          SizedBox(width: 12),
          _SummaryCard(
            title: 'Satpam Aktif',
            value: dashboard.jumlahSatpamAktif.toString(),
          ),
        ],
      ),
    );
  }

  // ================= MENU =================
  Widget _buildMonitoringMenu() {
    return Column(
      children: menuItems.map((item) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Card(
            color: const Color.fromARGB(255, 230, 231, 231),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              leading: Image.asset(item['icon'], width: 32),
              title: Text(
                item['label'],
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _onMenuTap(item['label']),
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ================= COMPONENTS =================
class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          final isArea = AppPrefs.getIsUserArea() ?? '0';
          if (title == 'Satpam Masuk') {
            isArea == '1'
                ? Get.to(() => UserArea(menu: 'card-absensi'))
                : Get.to(() => CardAbsensi());
          } else if (title == 'Satpam Aktif') {
            isArea == '1'
                ? Get.to(() => UserArea(menu: 'card-satpam'))
                : Get.to(() => CardSatpamDetail());
          }
        },
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= SHIMMER =================
class _HighContrastShimmer extends StatefulWidget {
  const _HighContrastShimmer();

  @override
  State<_HighContrastShimmer> createState() => _HighContrastShimmerState();
}

class _HighContrastShimmerState extends State<_HighContrastShimmer>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          color: Colors.black.withOpacity(0.25),
        ), // overlay lebih kontras
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1.5 + _controller.value * 3, 0),
                  end: const Alignment(1.5, 0),
                  colors: [
                    Colors.grey.shade400.withOpacity(0.35),
                    Colors.white.withOpacity(0.55),
                    Colors.grey.shade400.withOpacity(0.35),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
