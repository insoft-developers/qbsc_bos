import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/home/card_controller.dart';
import 'package:qbsc_saas/app/views/home/satpam_absensi_model.dart';

class CardAbsensi extends StatelessWidget {
  const CardAbsensi({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CardController());
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F172A),
        title: const Text(
          'Satpam Bertugas',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        child: const Icon(Icons.refresh, color: Colors.white),
        onPressed: () {
          controller.refreshData();
        },
      ),

      backgroundColor: Colors.white,
      body: Obx(() {
        // 1️⃣ Loading pertama kali
        return controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.absensiList.length,

                itemBuilder: (context, index) {
                  if (index < controller.absensiList.length) {
                    final SatpamAbsensiModel dataShow =
                        controller.absensiList[index];

                    return InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        // Get.to(() => NotifikasiDetail(data: dataShow));

                        controller.openWhatsApp(
                          dataShow.whatsapp,
                          dataShow.satpamName,
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildRow(
                                name: dataShow.satpamName,
                                whatsapp: dataShow.whatsapp,
                                jamMasuk: dataShow.jamMasuk ?? '',
                                foto: dataShow.foto,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }
                },
              );
      }),
    );
  }

  Widget _buildRow({
    required String name,
    required String whatsapp,
    String? foto,
    required String jamMasuk,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// FOTO SATPAM
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: foto != null && foto.isNotEmpty
                ? NetworkImage("${ApiProvider.imageUrl}/$foto")
                : null,
            child: foto == null || foto.isEmpty
                ? Icon(Icons.person, color: Colors.grey.shade600)
                : null,
          ),

          const SizedBox(width: 12),

          /// NAMA + WHATSAPP
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    const Icon(
                      Icons.message_outlined,
                      size: 14,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      whatsapp,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          /// STATUS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
            child: Text(
              Fungsi.formatDateTime(jamMasuk),
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

String limitWords(String text, int maxWords) {
  final words = text.split(RegExp(r'\s+'));
  if (words.length <= maxWords) return text;
  return '${words.take(maxWords).join(' ')}...';
}
