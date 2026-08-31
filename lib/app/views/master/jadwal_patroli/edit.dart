
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/jadwal_patroli_controller.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/jadwal_patroli_model.dart';

class JadwalPatroliEditPage extends StatefulWidget {
  final JadwalPatroliModel jadwalPatroli;

  const JadwalPatroliEditPage({
    super.key,
    required this.jadwalPatroli,
  });

  @override
  State<JadwalPatroliEditPage> createState() =>
      _JadwalPatroliEditPageState();
}

class _JadwalPatroliEditPageState
    extends State<JadwalPatroliEditPage> {
  final c = Get.find<JadwalPatroliController>();

  @override
  void initState() {
    super.initState();

    c.setEditData(widget.jadwalPatroli);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),

      // =========================================================
      // APP BAR
      // =========================================================

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF111827),
        foregroundColor: Colors.white,

        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Edit Jadwal Patroli',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Perbarui informasi jadwal patroli',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================

      body: Form(
        key: c.formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(
            18,
            20,
            18,
            30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =================================================
              // HEADER CARD
              // =================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.035),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(
                        Icons.edit_road_rounded,
                        color: Color(0xFF2563EB),
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 13),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Perbarui Jadwal',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF111827),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Ubah informasi jadwal patroli sesuai kebutuhan.',
                            style: TextStyle(
                              fontSize: 11,
                              height: 1.4,
                              color: Color(0xFF6B7280),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 22),

              // =================================================
              // SECTION TITLE
              // =================================================

              const Text(
                'DETAIL JADWAL',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                  color: Color(0xFF6B7280),
                ),
              ),

              const SizedBox(height: 10),

              // =================================================
              // FORM CARD
              // =================================================

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  16,
                  18,
                  16,
                  6,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE5E7EB),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.025),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    // =================================================
                    // NAMA
                    // =================================================

                    _inputField(
                      label: 'Nama Jadwal Patroli',
                      hint: 'Contoh: Patroli Shift Pagi',
                      icon: Icons.route_outlined,
                      controller: c.nameController,
                      validator: (v) {
                        if (v == null || v.trim().isEmpty) {
                          return 'Nama jadwal wajib diisi';
                        }

                        return null;
                      },
                    ),

                    // =================================================
                    // DESKRIPSI
                    // =================================================

                    _inputField(
                      label: 'Deskripsi',
                      hint:
                          'Tambahkan keterangan jadwal (opsional)',
                      icon: Icons.description_outlined,
                      controller: c.descriptionController,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // =================================================
              // UPDATE BUTTON
              // =================================================

              Obx(
                () {
                  final loading = c.isLoading.value;

                  return SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: loading
                          ? null
                          : () {
                              if (c.validateForm()) {
                                c.updateData();
                              } else {
                                SnackbarHelper.error(
                                  'Gagal',
                                  'Masih ada data yang kosong.',
                                );
                              }
                            },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xFF2563EB),
                        disabledBackgroundColor:
                            Colors.grey.shade300,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: loading
                          ? const SizedBox(
                              width: 23,
                              height: 23,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.save_outlined,
                                  size: 19,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'Perbarui Jadwal',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // =================================================
              // FOOTER
              // =================================================

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    size: 13,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'Periksa kembali perubahan sebelum menyimpan',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===============================================================
// INPUT FIELD
// ===============================================================

Widget _inputField({
  required String label,
  required IconData icon,
  String? hint,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  FormFieldValidator<String>? validator,
  ValueChanged<String>? onChanged,
  TextEditingController? controller,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 16),
    child: TextFormField(
      controller: controller,

      textInputAction: maxLines == 1
          ? TextInputAction.next
          : null,

      keyboardType: keyboardType,
      maxLines: maxLines,

      validator: validator,
      onChanged: onChanged,

      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: Color(0xFF111827),
      ),

      decoration: InputDecoration(
        labelText: label,
        hintText: hint,

        labelStyle: TextStyle(
          fontSize: 12,
          color: Colors.grey.shade600,
        ),

        hintStyle: TextStyle(
          fontSize: 11,
          color: Colors.grey.shade400,
        ),

        prefixIcon: Padding(
          padding: const EdgeInsets.only(
            left: 4,
            right: 4,
          ),
          child: Icon(
            icon,
            size: 20,
            color: const Color(0xFF64748B),
          ),
        ),

        prefixIconConstraints: const BoxConstraints(
          minWidth: 48,
        ),

        filled: true,
        fillColor: const Color(0xFFF8FAFC),

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 16,
        ),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide.none,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFFE5E7EB),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFF2563EB),
            width: 1.5,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFFDC2626),
          ),
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: const BorderSide(
            color: Color(0xFFDC2626),
            width: 1.5,
          ),
        ),

        errorStyle: const TextStyle(
          fontSize: 10,
          height: 1.3,
        ),
      ),
    ),
  );
}