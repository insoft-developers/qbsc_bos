import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/add.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/detail/jadwal_patroli_detail_controller.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/edit.dart';

class JadwalPatroliDetailPage extends StatefulWidget {
  final int jadwalId;
  const JadwalPatroliDetailPage({super.key, required this.jadwalId});

  @override
  State<JadwalPatroliDetailPage> createState() =>
      _JadwalPatroliDetailPageState();
}

class _JadwalPatroliDetailPageState extends State<JadwalPatroliDetailPage> {
  final controller = Get.put(JadwalPatroliDetailController());

  @override
  void initState() {
    super.initState();
    controller.getJadwalDetail(widget.jadwalId);
  }

  Future<void> _onRefresh() async {
    await controller.getJadwalDetail(widget.jadwalId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 53, 53),
        title: const Text(
          'Jadwal Patroli Detail',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // warna back button
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value &&
            controller.jadwalPatroliDetailList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: controller.jadwalPatroliDetailList.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 300),
                    Center(child: Text("Data tidak tersedia")),
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.jadwalPatroliDetailList.length,
                  itemBuilder: (context, index) {
                    final lokasi = controller.jadwalPatroliDetailList[index];

                    return GestureDetector(
                      onLongPress: () {},
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
                                  lokasi.locationName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("(${lokasi.patroliName})"),
                                    const SizedBox(height: 4),
                                    Text(
                                      "urutan ke ${lokasi.urutan.toString()}",
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      "${lokasi.jamAwal} - ${lokasi.jamAkhir}",
                                    ),
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
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "",
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

                                  /// EDIT
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blue,
                                      ),
                                      onPressed: () {
                                        // Get.to(
                                        //   () => JadwalPatroliEditPage(
                                        //     jadwalPatroli: lokasi,
                                        //   ),
                                        // );
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
                                            // Get.back();
                                            // await controller.deleteData(
                                            //   lokasi.id.toString(),
                                            // );
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
