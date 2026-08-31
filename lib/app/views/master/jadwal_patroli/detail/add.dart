import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/detail/jadwal_patroli_detail_controller.dart';

class JadwalPatroliDetailAddPage extends StatefulWidget {
  final int jadwalId;

  const JadwalPatroliDetailAddPage({super.key, required this.jadwalId});

  @override
  State<JadwalPatroliDetailAddPage> createState() =>
      _JadwalPatroliDetailAddPageState();
}

class _JadwalPatroliDetailAddPageState
    extends State<JadwalPatroliDetailAddPage> {
  final c = Get.find<JadwalPatroliDetailController>();

  @override
  void initState() {
    super.initState();
    c.prepareAddData(widget.jadwalId);
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
              'Tambah Lokasi Patroli',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            SizedBox(height: 2),
            Text(
              'Tambahkan lokasi ke jadwal patroli',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: Form(
        key: c.formKey,

        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.fromLTRB(16, 18, 16, 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ===================================================
              // HEADER CARD
              // ===================================================
              _buildHeader(),

              const SizedBox(height: 22),

              // ===================================================
              // SECTION TITLE
              // ===================================================
              const Text(
                'DETAIL LOKASI',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: Color(0xFF64748B),
                ),
              ),

              const SizedBox(height: 10),

              // ===================================================
              // FORM CARD
              // ===================================================
              Container(
                width: double.infinity,

                padding: const EdgeInsets.fromLTRB(16, 18, 16, 4),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),

                  border: Border.all(color: const Color(0xFFE5E7EB)),

                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.035),
                      blurRadius: 16,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    // =================================================
                    // LOCATION
                    // =================================================
                    Obx(() {
                      if (c.isLocationLoading.value) {
                        return _buildLoadingField();
                      }

                      return _buildLocationDropdown();
                    }),

                    // =================================================
                    // URUTAN
                    // =================================================
                    Obx(() => _buildUrutanField(c.urutan.value)),

                    // =================================================
                    // JAM
                    // =================================================
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Obx(
                            () => _buildTimeField(
                              label: 'Jam Awal',
                              value: c.jamAwal.value,
                              onTap: () {
                                c.pilihJamAwal(context);
                              },
                            ),
                          ),
                        ),

                        const SizedBox(width: 10),

                        Expanded(
                          child: Obx(
                            () => _buildTimeField(
                              label: 'Jam Akhir',
                              value: c.jamAkhir.value,
                              onTap: () {
                                c.pilihJamAkhir(context);
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 26),

              // ===================================================
              // SAVE BUTTON
              // ===================================================
              Obx(() {
                final loading = c.isLoading.value;

                return SizedBox(
                  width: double.infinity,
                  height: 54,

                  child: ElevatedButton(
                    onPressed: loading
                        ? null
                        : () {
                            if (!c.validateForm()) {
                              SnackbarHelper.error(
                                'Data belum lengkap',
                                'Silakan lengkapi data terlebih dahulu.',
                              );
                              return;
                            }

                            if (c.locationId.value == 0) {
                              SnackbarHelper.error(
                                'Lokasi belum dipilih',
                                'Silakan pilih lokasi patroli.',
                              );
                              return;
                            }

                            if (c.jamAwal.value.isEmpty) {
                              SnackbarHelper.error(
                                'Jam awal belum dipilih',
                                'Silakan tentukan jam awal patroli.',
                              );
                              return;
                            }

                            if (c.jamAkhir.value.isEmpty) {
                              SnackbarHelper.error(
                                'Jam akhir belum dipilih',
                                'Silakan tentukan jam akhir patroli.',
                              );
                              return;
                            }

                            c.saveData();
                          },

                    style: ElevatedButton.styleFrom(
                      elevation: 0,

                      backgroundColor: const Color(0xFF2563EB),

                      disabledBackgroundColor: const Color(0xFFCBD5E1),

                      foregroundColor: Colors.white,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.save_outlined, size: 19),
                              SizedBox(width: 8),
                              Text(
                                'Simpan Lokasi',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                  ),
                );
              }),

              const SizedBox(height: 12),

              // ===================================================
              // INFO
              // ===================================================
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
                    'Urutan ditentukan otomatis',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // HEADER
  // =============================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(20),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,

            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.10),
              borderRadius: BorderRadius.circular(15),
            ),

            child: const Icon(
              Icons.add_location_alt_outlined,
              color: Colors.white,
              size: 25,
            ),
          ),

          const SizedBox(width: 14),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Lokasi Baru',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: 5),

                Text(
                  'Pilih lokasi dan tentukan waktu patroli.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 11,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // LOCATION DROPDOWN
  // =============================================================

  Widget _buildLocationDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: DropdownButtonFormField<int>(
        value: c.locationId.value == 0 ? null : c.locationId.value,

        isExpanded: true,

        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: Color(0xFF64748B),
        ),

        decoration: _inputDecoration(
          label: 'Lokasi Patroli',
          hint: 'Pilih lokasi patroli',
          icon: Icons.location_on_outlined,
        ),

        items: c.locationList.map((lokasi) {
          return DropdownMenuItem<int>(
            value: lokasi.id,

            child: Text(
              lokasi.locationName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,

              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF111827),
              ),
            ),
          );
        }).toList(),

        onChanged: c.setLocation,

        validator: (value) {
          if (value == null || value == 0) {
            return 'Lokasi patroli wajib dipilih';
          }

          return null;
        },
      ),
    );
  }

  // =============================================================
  // READ ONLY FIELD
  // =============================================================

  Widget _buildReadOnlyField({
    required String label,
    required String value,
    required IconData icon,
    required IconData suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: TextFormField(
        readOnly: true,

        initialValue: value,

        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w700,
          color: Color(0xFF111827),
        ),

        decoration: _inputDecoration(
          label: label,
          hint: '-',
          icon: icon,

          suffixIcon: Icon(
            suffixIcon,
            size: 18,
            color: const Color(0xFF2563EB),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // TIME FIELD
  // =============================================================

  Widget _buildTimeField({
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),

      child: InkWell(
        onTap: onTap,

        borderRadius: BorderRadius.circular(13),

        child: InputDecorator(
          decoration: _inputDecoration(
            label: label,
            hint: 'Pilih jam',
            icon: Icons.schedule_outlined,

            suffixIcon: const Icon(
              Icons.access_time_rounded,
              size: 18,
              color: Color(0xFF2563EB),
            ),
          ),

          child: Text(
            value.isEmpty ? 'Pilih jam' : value,

            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,

              color: value.isEmpty
                  ? const Color(0xFF94A3B8)
                  : const Color(0xFF111827),
            ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // LOADING FIELD
  // =============================================================
  Widget _buildUrutanField(int value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c.urutanController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        onChanged: c.setUrutan,

        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Urutan wajib diisi';
          }

          final number = int.tryParse(value.trim());

          if (number == null || number < 1) {
            return 'Urutan harus berupa angka minimal 1';
          }

          return null;
        },

        decoration: InputDecoration(
          labelText: 'Urutan',

          prefixIcon: const Icon(
            Icons.format_list_numbered_rounded,
            size: 20,
            color: Color(0xFF64748B),
          ),

          suffixIcon: const Icon(
            Icons.edit_outlined,
            size: 18,
            color: Color(0xFF2563EB),
          ),

          filled: true,
          fillColor: const Color(0xFFF8FAFC),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide.none,
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Colors.red),
          ),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingField() {
    return Container(
      height: 58,

      margin: const EdgeInsets.only(bottom: 16),

      padding: const EdgeInsets.symmetric(horizontal: 16),

      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(13),

        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),

      child: Row(
        children: [
          const SizedBox(
            width: 18,
            height: 18,

            child: CircularProgressIndicator(
              strokeWidth: 2,
              color: Color(0xFF2563EB),
            ),
          ),

          const SizedBox(width: 12),

          Text(
            'Memuat daftar lokasi...',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // =============================================================
  // INPUT DECORATION
  // =============================================================

  InputDecoration _inputDecoration({
    required String label,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,

      prefixIcon: Icon(icon, size: 20, color: const Color(0xFF64748B)),

      suffixIcon: suffixIcon,

      filled: true,
      fillColor: const Color(0xFFF8FAFC),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: BorderSide.none,
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
      ),

      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),

      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(13),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.5),
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
    );
  }
}
