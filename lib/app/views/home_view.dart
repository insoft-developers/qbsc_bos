import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:qbsc_saas/app/controllers/absen_controller.dart';
import 'package:qbsc_saas/app/controllers/auth_controller.dart';
import 'package:qbsc_saas/app/controllers/home_controller.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/app_prefs.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final AuthController authC = Get.put(AuthController());
  final HomeController homeC = Get.put(HomeController());
  final AbsenController absenC = Get.put(AbsenController());

  final String? isPeternakan = AppPrefs.getIsPeternakan();

  final PageController _pageController = PageController();
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
    absenC.getLocationData();
    _initMenu();
    _autoSlide();
    _prefetchImages();
  }

  void _prefetchImages() {
    for (final url in sliderImages) {
      precacheImage(CachedNetworkImageProvider(url), context);
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _autoSlide() {
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  void _initMenu() {
    final baseMenu = [
      {'icon': 'assets/images/absensi.png', 'label': 'Absensi'},
      {'icon': 'assets/images/patroli.png', 'label': 'Patroli'},
      {'icon': 'assets/images/laporan.png', 'label': 'Laporan'},
      {'icon': 'assets/images/kejadian.png', 'label': 'Kejadian'},
      {'icon': 'assets/images/tamu.png', 'label': 'Tamu'},
      {'icon': 'assets/images/setting.png', 'label': 'Pengaturan'},
    ];

    if (isPeternakan == '1') {
      baseMenu.insertAll(2, [
        {'icon': 'assets/images/kandang.png', 'label': 'Kontrol Kandang'},
        {'icon': 'assets/images/doc.png', 'label': 'Catat DOC'},
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
    final routes = {
      'Absensi': '/shift',
      'Patroli': '/patroli',
      'Pengaturan': '/pengaturan',
      'Laporan': '/laporan',
      'Kontrol Kandang': '/patroli/kandang',
      'Catat DOC': '/doc',
      'Kejadian': '/kejadian',
      'Tamu': '/tamu',
    };

    if (routes.containsKey(label)) {
      Get.toNamed(routes[label]!);
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
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF0F172A),
      elevation: 0,
      title: const Text(
        'CEO Dashboard',
        style: TextStyle(fontWeight: FontWeight.w600),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_none),
          onPressed: () => Get.toNamed('/notifikasi'),
        ),
        IconButton(icon: const Icon(Icons.logout), onPressed: authC.logout),
      ],
    );
  }

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
                    'Welcome back',
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

  Widget _buildImageSlider() {
    return Column(
      children: [
        SizedBox(
          height: 160,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: PageView.builder(
              controller: _pageController,
              itemCount: null, // infinite
              onPageChanged: (index) {
                setState(() => _currentSlide = index % sliderImages.length);
              },
              itemBuilder: (_, index) {
                final imageUrl = sliderImages[index % sliderImages.length];
                return CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  fadeInDuration: const Duration(milliseconds: 300),
                  placeholder: (_, __) => const _HighContrastShimmer(),
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.image_not_supported, size: 40),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(sliderImages.length, (i) {
            final active = _currentSlide == i;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: active ? 18 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? const Color(0xFF0F172A) : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(6),
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildSummarySection() {
    return Row(
      children: const [
        _SummaryCard(title: 'Satpam Aktif', value: '12'),
        SizedBox(width: 12),
        _SummaryCard(title: 'Patroli Hari Ini', value: '48'),
      ],
    );
  }

  Widget _buildMonitoringMenu() {
    return Column(
      children: menuItems.map((item) {
        return Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
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
        );
      }).toList(),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  const _SummaryCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

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
      duration: const Duration(milliseconds: 900),
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
      fit: StackFit.expand,
      children: [
        Container(color: Colors.black.withOpacity(0.28)),
        AnimatedBuilder(
          animation: _controller,
          builder: (_, __) {
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-1.5 + _controller.value * 3, 0),
                  end: const Alignment(1.5, 0),
                  colors: [
                    Colors.grey.shade900.withOpacity(0.25),
                    Colors.white.withOpacity(0.65),
                    Colors.grey.shade900.withOpacity(0.25),
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
