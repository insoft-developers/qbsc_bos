import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/add.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/detail/index.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/edit.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/jadwal_patroli_controller.dart';

class JadwalPatroliPage extends StatefulWidget {
  const JadwalPatroliPage({super.key});

  @override
  State<JadwalPatroliPage> createState() => _JadwalPatroliPageState();
}

class _JadwalPatroliPageState extends State<JadwalPatroliPage> {
  final controller = Get.put(JadwalPatroliController());

  @override
  void initState() {
    super.initState();
    controller.getDataJadwal();
  }

  Future<void> _onRefresh() async {
    await controller.getDataJadwal();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 53, 53),
        title: const Text(
          'Jadwal Patroli',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // warna back button
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value &&
            controller.jadwalPatroliList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: controller.jadwalPatroliList.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 300),
                    Center(child: Text("Data tidak tersedia")),
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.jadwalPatroliList.length,
                  itemBuilder: (context, index) {
                    final lokasi = controller.jadwalPatroliList[index];

                    final active = lokasi.isActive == 1
                        ? Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Text(
                              'Aktif',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          )
                        : Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(10),
                            ),

                            child: Text(
                              'Non Aktif',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                    return GestureDetector(
                      onLongPress: () {
                        Get.to(
                          () => JadwalPatroliDetailPage(jadwalId: lokasi.id),
                        );
                      },
                      child: Card(
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /// ====== DATA ATAS ======
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  lokasi.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("(${lokasi.description})"),
                                    const SizedBox(height: 4),
                                    Text(
                                      lokasi.comName,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: lokasi.isActive == 1
                                        ? Colors.green
                                        : Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    lokasi.isActive == 1
                                        ? 'Aktif'
                                        : 'Non Aktif',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 12),
                              const Divider(),
                              const SizedBox(height: 8),

                              /// ====== 3 TOMBOL DI PALING BAWAH ======
                              Row(
                                children: [
                                  /// AKTIF / NONAKTIF
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: lokasi.isActive == 1
                                            ? Colors.orange
                                            : Colors.green,
                                      ),
                                      onPressed: () async {
                                        if (lokasi.isActive == 1) {
                                          await controller.ubahStatusJadwal(
                                            lokasi.id,
                                            0,
                                          );
                                        } else {
                                          await controller.ubahStatusJadwal(
                                            lokasi.id,
                                            1,
                                          );
                                        }
                                      },
                                      child: Text(
                                        lokasi.isActive == 1
                                            ? "Nonaktif"
                                            : "Aktifkan",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  /// EDIT
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      onPressed: () {
                                        Get.to(
                                          () => JadwalPatroliEditPage(
                                            jadwalPatroli: lokasi,
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        "Edit",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  /// HAPUS
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                      ),
                                      onPressed: () {
                                        Get.defaultDialog(
                                          title: "Konfirmasi",
                                          middleText:
                                              "Yakin ingin menghapus data ini?",
                                          textConfirm: "Ya",
                                          textCancel: "Batal",
                                          confirmTextColor: Colors.white,
                                          onConfirm: () async {
                                            Get.back();
                                            await controller.deleteData(
                                              lokasi.id.toString(),
                                            );
                                          },
                                        );
                                      },
                                      child: const Text(
                                        "Hapus",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
        );
      }),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Get.to(() => JadwalPatroliAddPage());
        },
      ),
    );
  }
}
