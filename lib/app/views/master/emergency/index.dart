import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import 'emergency_list_controller.dart';
import 'emergency_list_model.dart';

class EmergencyListPage extends StatelessWidget {
  const EmergencyListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(EmergencyListController());

    return Scaffold(
      backgroundColor:
          const Color(0xFFF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Emergency List',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ),

      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: () {
          controller.resetForm();

          _showForm(
            context,
            controller,
          );
        },
        backgroundColor:
            const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Tambah Kontak',
          style: TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value &&
            controller.emergencyList.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (controller.emergencyList.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.getData,
            child: ListView(
              physics:
                  const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 130),

                Icon(
                  Icons.contact_phone_outlined,
                  size: 70,
                  color: Colors.grey.shade400,
                ),

                const SizedBox(height: 15),

                const Center(
                  child: Text(
                    'Belum ada kontak emergency',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          Color(0xFF374151),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                const Center(
                  child: Text(
                    'Tambahkan kontak yang dapat '
                    'dihubungi saat keadaan darurat.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color:
                          Color(0xFF6B7280),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return RefreshIndicator(
          color: const Color(0xFF2563EB),
          onRefresh: controller.getData,
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(
              16,
              16,
              16,
              100,
            ),
            itemCount:
                controller.emergencyList.length,
            separatorBuilder:
                (_, __) =>
                    const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data =
                  controller.emergencyList[index];

              return _EmergencyCard(
                data: data,
                onEdit: () {
                  controller.setEditData(data);

                  _showForm(
                    context,
                    controller,
                  );
                },
                onDelete: () {
                  controller.deleteData(
                    data.id,
                  );
                },
                onWhatsapp: () {
                  _openWhatsApp(
                    data.whatsapp,
                  );
                },
              );
            },
          ),
        );
      }),
    );
  }

  // ======================================================
  // FORM
  // ======================================================

  static void _showForm(
    BuildContext context,
    EmergencyListController controller,
  ) {
    Get.dialog(
      Dialog(
        insetPadding:
            const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 24,
        ),
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // HEADER
                  // ==================================================

                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration:
                            BoxDecoration(
                          color:
                              const Color(
                            0xFFFEF2F2,
                          ),
                          borderRadius:
                              BorderRadius.circular(
                            12,
                          ),
                        ),
                        child: const Icon(
                          Icons
                              .contact_phone_rounded,
                          color:
                              Color(0xFFDC2626),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Obx(
                          () => Text(
                            controller
                                    .isEdit.value
                                ? 'Edit Kontak Emergency'
                                : 'Tambah Kontak Emergency',
                            style:
                                const TextStyle(
                              fontSize: 18,
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.close,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // NAME
                  // ==================================================

                  _TextField(
                    controller:
                        controller.nameController,
                    label: 'Nama',
                    hint:
                        'Contoh: Supervisor',
                    icon:
                        Icons.person_outline,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Nama wajib diisi';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 16),

                  // ==================================================
                  // WHATSAPP
                  // ==================================================

                  _TextField(
                    controller:
                        controller
                            .whatsappController,
                    label: 'Nomor WhatsApp',
                    hint:
                        'Contoh: 628123456789',
                    icon:
                        Icons.phone_outlined,
                    keyboardType:
                        TextInputType.phone,
                    validator: (value) {
                      if (value == null ||
                          value.trim().isEmpty) {
                        return 'Nomor WhatsApp wajib diisi';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Gunakan format internasional, '
                    'contoh: 628123456789.',
                    style: TextStyle(
                      fontSize: 11,
                      color:
                          Color(0xFF6B7280),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ==================================================
                  // SAVE
                  // ==================================================

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed:
                            controller
                                    .isLoading
                                    .value
                                ? null
                                : () {
                                    if (controller
                                        .isEdit
                                        .value) {
                                      controller
                                          .updateData();
                                    } else {
                                      controller
                                          .saveData();
                                    }
                                  },
                        style:
                            ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(
                            0xFF2563EB,
                          ),
                          foregroundColor:
                              Colors.white,
                          elevation: 0,
                          shape:
                              RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(
                              12,
                            ),
                          ),
                        ),
                        child:
                            controller
                                    .isLoading
                                    .value
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child:
                                        CircularProgressIndicator(
                                      strokeWidth:
                                          2.5,
                                      color:
                                          Colors.white,
                                    ),
                                  )
                                : Text(
                                    controller
                                            .isEdit
                                            .value
                                        ? 'Simpan Perubahan'
                                        : 'Simpan',
                                    style:
                                        const TextStyle(
                                      fontWeight:
                                          FontWeight.w700,
                                    ),
                                  ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ======================================================
  // WHATSAPP
  // ======================================================

  static Future<void> _openWhatsApp(
    String number,
  ) async {
    final phone =
        number.replaceAll(
      RegExp(r'[^0-9]'),
      '',
    );

    final url = Uri.parse(
      'https://wa.me/$phone',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(
        url,
        mode:
            LaunchMode.externalApplication,
      );
    } else {
      Get.snackbar(
        'Gagal',
        'WhatsApp tidak dapat dibuka.',
        snackPosition:
            SnackPosition.BOTTOM,
      );
    }
  }
}

// ======================================================
// EMERGENCY CARD
// ======================================================

class _EmergencyCard
    extends StatelessWidget {
  final EmergencyListModel data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;
  final VoidCallback onWhatsapp;

  const _EmergencyCard({
    required this.data,
    required this.onEdit,
    required this.onDelete,
    required this.onWhatsapp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color:
              const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color:
                Colors.black.withOpacity(
              0.025,
            ),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // ==================================================
          // ICON
          // ==================================================

          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color:
                  const Color(0xFFFEF2F2),
              borderRadius:
                  BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons
                  .contact_phone_rounded,
              color:
                  Color(0xFFDC2626),
            ),
          ),

          const SizedBox(width: 13),

          // ==================================================
          // DATA
          // ==================================================

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  data.name,
                  style:
                      const TextStyle(
                    fontSize: 15,
                    fontWeight:
                        FontWeight.w700,
                    color:
                        Color(0xFF111827),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  data.whatsapp,
                  style:
                      const TextStyle(
                    fontSize: 13,
                    color:
                        Color(0xFF6B7280),
                  ),
                ),

                const SizedBox(height: 8),

                InkWell(
                  onTap: onWhatsapp,
                  child: const Row(
                    mainAxisSize:
                        MainAxisSize.min,
                    children: [
                      Icon(
                        Icons
                            .chat_outlined,
                        size: 16,
                        color:
                            Color(0xFF16A34A),
                      ),
                      SizedBox(width: 5),
                      Text(
                        'Hubungi WhatsApp',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                          color:
                              Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ==================================================
          // MENU
          // ==================================================

          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'edit') {
                onEdit();
              }

              if (value == 'delete') {
                onDelete();
              }
            },
            itemBuilder: (_) => const [
              PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(
                      Icons.edit_outlined,
                      size: 19,
                    ),
                    SizedBox(width: 10),
                    Text('Edit'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(
                      Icons.delete_outline,
                      size: 19,
                      color: Colors.red,
                    ),
                    SizedBox(width: 10),
                    Text('Hapus'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ======================================================
// TEXT FIELD
// ======================================================

class _TextField
    extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)?
      validator;

  const _TextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.keyboardType,
    this.validator,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration:
          InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            12,
          ),
        ),
        enabledBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            12,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(0xFFE5E7EB),
          ),
        ),
        focusedBorder:
            OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(
            12,
          ),
          borderSide:
              const BorderSide(
            color:
                Color(0xFF2563EB),
            width: 1.5,
          ),
        ),
      ),
    );
  }
}