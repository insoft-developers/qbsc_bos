import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/views/master/satpam/add.dart';
import 'package:qbsc_saas/app/views/master/satpam/edit.dart';
import 'package:qbsc_saas/app/views/master/satpam/satpam_controller.dart';
import 'package:qbsc_saas/app/views/master/user/user_controller.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final controller = Get.put(UserController());

  @override
  void initState() {
    super.initState();
    controller.getDataUser();
  }

  Future<void> _onRefresh() async {
    await controller.getDataUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 53, 53),
        title: const Text(
          'Data User',
          style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white, // warna back button
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value && controller.userList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return RefreshIndicator(
          onRefresh: _onRefresh,
          child: controller.userList.isEmpty
              ? ListView(
                  children: const [
                    SizedBox(height: 300),
                    Center(child: Text("Data tidak tersedia")),
                  ],
                )
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  itemCount: controller.userList.length,
                  itemBuilder: (context, index) {
                    final satpam = controller.userList[index];

                    final active = satpam.isActive == 1
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
                                    satpam.profileImage != null &&
                                        satpam.profileImage!.isNotEmpty
                                    ? NetworkImage(
                                        "${ApiProvider.imageUrl}/${satpam.profileImage}",
                                      )
                                    : null,
                                child:
                                    satpam.profileImage == null ||
                                        satpam.profileImage!.isEmpty
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

                                  Text(satpam.comName),
                                ],
                              ),
                              trailing: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 5,
                                ),
                                decoration: BoxDecoration(
                                  color: satpam.isActive == 1
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  satpam.isActive == 1 ? 'Aktif' : 'Non Aktif',
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
                                      backgroundColor: satpam.isActive == 1
                                          ? Colors.orange
                                          : Colors.green,
                                    ),
                                    onPressed: () async {
                                      if (satpam.isActive == 1) {
                                        await controller.ubahStatusUser(
                                          satpam.id,
                                          0,
                                        );
                                      } else {
                                        await controller.ubahStatusUser(
                                          satpam.id,
                                          1,
                                        );
                                      }
                                    },
                                    child: Text(
                                      satpam.isActive == 1
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
                                      // Get.to(
                                      //   () => SatpamEditPage(satpam: satpam),
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
                                          Get.back();
                                          // await controller.deleteData(
                                          //   satpam.id.toString(),
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
