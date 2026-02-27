import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/views/master/satpam/add.dart';
import 'package:qbsc_saas/app/views/master/satpam/edit.dart';
import 'package:qbsc_saas/app/views/master/satpam/satpam_controller.dart';

class SatpamPage extends StatefulWidget {
  const SatpamPage({super.key});

  @override
  State<SatpamPage> createState() => _SatpamPageState();
}

class _SatpamPageState extends State<SatpamPage> {
  final SatpamController controller = Get.put(SatpamController());

  @override
  void initState() {
    super.initState();
    controller.getDataSatpam();
  }

  Future<void> _onRefresh() async {
    await controller.getDataSatpam();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 53, 53),
        title: const Text(
          'Data Satpam',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // warna back button
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value && controller.satpamList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: controller.satpamList.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 300),
                    Center(child: Text("Data tidak tersedia")),
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.satpamList.length,
                  itemBuilder: (context, index) {
                    final satpam = controller.satpamList[index];

                    final active = satpam.isActive
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
                    return Card(
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
                              leading: CircleAvatar(
                                radius: 25,
                                backgroundImage:
                                    satpam.foto != null &&
                                        satpam.foto!.isNotEmpty
                                    ? NetworkImage(
                                        "${ApiProvider.imageUrl}/${satpam.foto}",
                                      )
                                    : null,
                                child:
                                    satpam.foto == null || satpam.foto!.isEmpty
                                    ? const Icon(Icons.person)
                                    : null,
                              ),
                              title: Text(
                                satpam.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(satpam.whatsapp),
                                  Text(satpam.isDanru ? 'Danru' : 'Anggota'),
                                  Text(satpam.comName),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: satpam.isActive
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  satpam.isActive ? 'Aktif' : 'Non Aktif',
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
                                      backgroundColor: satpam.isActive
                                          ? Colors.orange
                                          : Colors.green,
                                    ),
                                    onPressed: () async {
                                      if (satpam.isActive) {
                                        await controller.ubahStatusSatpam(
                                          satpam.id,
                                          0,
                                        );
                                      } else {
                                        await controller.ubahStatusSatpam(
                                          satpam.id,
                                          1,
                                        );
                                      }
                                    },
                                    child: Text(
                                      satpam.isActive ? "Nonaktif" : "Aktifkan",
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
                                        () => SatpamEditPage(satpam: satpam),
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
                                            satpam.id.toString(),
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
                    );
                  },
                ),
        );
      }),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Get.to(() => SatpamAddPage());
        },
      ),
    );
  }
}
