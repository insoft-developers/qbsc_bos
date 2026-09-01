import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'jam_shift_controller.dart';
import 'jam_shift_model.dart';

class JamShiftPage extends StatelessWidget {
  const JamShiftPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(JamShiftController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Jam Shift',
          style: TextStyle(
            fontSize: 19,
            fontWeight: FontWeight.w700,
            color: Color(0xFF111827),
          ),
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          controller.resetForm();

          _showForm(context, controller);
        },
        backgroundColor: const Color(0xFF2563EB),
        foregroundColor: Colors.white,
        icon: const Icon(Icons.add),
        label: const Text(
          'Tambah Shift',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),

      body: Obx(() {
        if (controller.isLoading.value && controller.jamShiftList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.jamShiftList.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.getData,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 130),

                Icon(
                  Icons.schedule_outlined,
                  size: 70,
                  color: Colors.grey.shade400,
                ),

                const SizedBox(height: 15),

                const Center(
                  child: Text(
                    'Belum ada jam shift',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ),

                const SizedBox(height: 6),

                const Center(
                  child: Text(
                    'Tambahkan jam shift untuk digunakan '
                    'pada pengaturan absensi.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: Color(0xFF6B7280)),
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
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
            itemCount: controller.jamShiftList.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final data = controller.jamShiftList[index];

              return _ShiftCard(
                data: data,
                onEdit: () {
                  controller.setEditData(data);

                  _showForm(context, controller);
                },
                onDelete: () {
                  controller.deleteData(data.id);
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

  static void _showForm(BuildContext context, JamShiftController controller) {
    Get.dialog(
      Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: controller.formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ==================================================
                  // HEADER
                  // ==================================================
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEFF6FF),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.schedule_rounded,
                          color: Color(0xFF2563EB),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Obx(
                          () => Text(
                            controller.isEdit.value
                                ? 'Edit Jam Shift'
                                : 'Tambah Jam Shift',
                            style: const TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // NAMA SHIFT
                  // ==================================================
                  _TextField(
                    controller: controller.nameController,
                    label: 'Nama Shift',
                    hint: 'Contoh: Shift Pagi',
                    icon: Icons.label_outline,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Nama shift wajib diisi';
                      }

                      return null;
                    },
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // JAM MASUK
                  // ==================================================
                  const Text(
                    'Jam Masuk',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),

                  const SizedBox(height: 10),

                  _TimeField(
                    controller: controller.jamMasukAwalController,
                    label: 'Jam Masuk Awal',
                  ),

                  const SizedBox(height: 12),

                  _TimeField(
                    controller: controller.jamMasukController,
                    label: 'Jam Masuk *',
                    required: true,
                  ),

                  const SizedBox(height: 12),

                  _TimeField(
                    controller: controller.jamMasukAkhirController,
                    label: 'Jam Masuk Akhir',
                  ),

                  const SizedBox(height: 22),

                  // ==================================================
                  // JAM PULANG
                  // ==================================================
                  const Text(
                    'Jam Pulang',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF374151),
                    ),
                  ),

                  const SizedBox(height: 10),

                  _TimeField(
                    controller: controller.jamPulangAwalController,
                    label: 'Jam Pulang Awal',
                  ),

                  const SizedBox(height: 12),

                  _TimeField(
                    controller: controller.jamPulangController,
                    label: 'Jam Pulang *',
                    required: true,
                  ),

                  const SizedBox(height: 12),

                  _TimeField(
                    controller: controller.jamPulangAkhirController,
                    label: 'Jam Pulang Akhir',
                  ),

                  const SizedBox(height: 10),

                  // ==================================================
                  // INFO
                  // ==================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF9FAFB),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFE5E7EB)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.info_outline_rounded,
                          size: 18,
                          color: Color(0xFF6B7280),
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Jam awal dan jam akhir boleh dikosongkan. '
                            'Jika kosong, sistem akan menghitungnya '
                            'secara otomatis.',
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF6B7280),
                              height: 1.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // ==================================================
                  // BUTTON SIMPAN
                  // ==================================================
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: Obx(
                      () => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () {
                                if (controller.isEdit.value) {
                                  controller.updateData();
                                } else {
                                  controller.saveData();
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2563EB),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF93C5FD),
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                width: 22,
                                height: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2.5,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                controller.isEdit.value
                                    ? 'Simpan Perubahan'
                                    : 'Simpan',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
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
}

// ======================================================
// SHIFT CARD
// ======================================================

class _ShiftCard extends StatelessWidget {
  final JamShiftModel data;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ShiftCard({
    required this.data,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.schedule_rounded,
                  color: Color(0xFF2563EB),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111827),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${data.jamMasuk}  →  ${data.jamPulang}',
                      style: const TextStyle(
                        fontSize: 13,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),

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
                        Icon(Icons.edit_outlined, size: 19),
                        SizedBox(width: 10),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete_outline, size: 19, color: Colors.red),
                        SizedBox(width: 10),
                        Text('Hapus'),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 15),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _TimeInfo(
                    title: 'Masuk',
                    awal: data.jamMasukAwal,
                    utama: data.jamMasuk,
                    akhir: data.jamMasukAkhir,
                  ),
                ),

                Container(width: 1, height: 45, color: const Color(0xFFE5E7EB)),

                Expanded(
                  child: _TimeInfo(
                    title: 'Pulang',
                    awal: data.jamPulangAwal,
                    utama: data.jamPulang,
                    akhir: data.jamPulangAkhir,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// TIME INFO
// ======================================================

class _TimeInfo extends StatelessWidget {
  final String title;
  final String? awal;
  final String utama;
  final String? akhir;

  const _TimeInfo({
    required this.title,
    required this.awal,
    required this.utama,
    required this.akhir,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, color: Color(0xFF6B7280)),
          ),
          const SizedBox(height: 4),
          Text(
            utama,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            '${awal ?? '-'}  •  ${akhir ?? '-'}',
            style: const TextStyle(fontSize: 10, color: Color(0xFF9CA3AF)),
          ),
        ],
      ),
    );
  }
}

// ======================================================
// TEXT FIELD
// ======================================================

class _TextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;

  const _TextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      textCapitalization: TextCapitalization.words,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),
    );
  }
}

// ======================================================
// TIME FIELD
// ======================================================

class _TimeField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool required;

  const _TimeField({
    required this.controller,
    required this.label,
    this.required = false,
  });

  Future<void> _pickTime(BuildContext context) async {
    TimeOfDay initialTime = TimeOfDay.now();

    if (controller.text.isNotEmpty) {
      final parts = controller.text.split(':');

      if (parts.length >= 2) {
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);

        if (hour != null && minute != null) {
          initialTime = TimeOfDay(hour: hour, minute: minute);
        }
      }
    }

    final selected = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (selected != null) {
      final hour = selected.hour.toString().padLeft(2, '0');

      final minute = selected.minute.toString().padLeft(2, '0');

      controller.text = '$hour:$minute:00';
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: () => _pickTime(context),
      validator: required
          ? (value) {
              if (value == null || value.isEmpty) {
                return 'Wajib';
              }
              return null;
            }
          : null,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.access_time_rounded, size: 19),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 13,
        ),
      ),
    );
  }
}
