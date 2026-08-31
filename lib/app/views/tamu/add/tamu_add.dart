import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/views/tamu/add/tamu_add_controller.dart';

class TamuAddPage extends StatelessWidget {
  const TamuAddPage({super.key});

  static const Color primaryColor = Color(0xFF0F172A);
  static const Color blueColor = Color(0xFF2563EB);
  static const Color greenColor = Color(0xFF16A34A);
  static const Color backgroundColor = Color(0xFFF6F8FC);

  @override
  Widget build(BuildContext context) {
    final c = Get.put(TamuAddController());

    return Scaffold(
      backgroundColor: backgroundColor,

      // =========================================================
      // APP BAR
      // =========================================================
      appBar: AppBar(
        backgroundColor: primaryColor,
        elevation: 0,
        titleSpacing: 18,
        title: const Row(
          children: [
            Icon(Icons.person_add_alt_1_rounded, color: Colors.white, size: 21),
            SizedBox(width: 10),
            Text(
              'Tambah Data Tamu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      // =========================================================
      // BODY
      // =========================================================
      body: Form(
        key: c.formKey,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // =================================================
              // HEADER
              // =================================================
              _buildHeader(),

              const SizedBox(height: 14),

              // =================================================
              // DATA TAMU
              // =================================================
              _buildSection(
                icon: Icons.person_outline_rounded,
                iconColor: blueColor,
                title: 'Informasi Tamu',
                subtitle: 'Lengkapi informasi tamu yang berkunjung.',
                children: [
                  _inputField(
                    label: 'Nama Tamu',
                    hint: 'Masukkan nama lengkap',
                    icon: Icons.person_outline_rounded,
                    onChanged: c.setNamaTamu,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Nama Tamu wajib diisi';
                      }
                      return null;
                    },
                  ),

                  _inputField(
                    label: 'Jumlah Tamu',
                    hint: 'Masukkan jumlah tamu',
                    icon: Icons.groups_outlined,
                    keyboardType: TextInputType.number,
                    onChanged: c.setJumlahTamu,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Jumlah Tamu wajib diisi';
                      }
                      return null;
                    },
                  ),

                  _inputField(
                    label: 'Tujuan',
                    hint: 'Tujuan kunjungan',
                    icon: Icons.location_on_outlined,
                    onChanged: c.setTujuan,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return 'Tujuan wajib diisi';
                      }
                      return null;
                    },
                  ),

                  _inputField(
                    label: 'Whatsapp',
                    hint: 'Nomor Whatsapp',
                    icon: Icons.phone_outlined,
                    keyboardType: TextInputType.phone,
                    onChanged: c.setWhatsapp,
                  ),

                  _inputField(
                    label: 'Catatan',
                    hint: 'Tambahkan catatan jika diperlukan',
                    icon: Icons.notes_outlined,
                    maxLines: 3,
                    textInputAction: TextInputAction.newline,
                    onChanged: c.setCatatan,
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // =================================================
              // FOTO
              // =================================================
              _buildSection(
                icon: Icons.camera_alt_outlined,
                iconColor: greenColor,
                title: 'Dokumentasi',
                subtitle: 'Tambahkan foto sebagai dokumentasi kunjungan.',
                children: [Obx(() => _buildPhotoSection(c))],
              ),

              const SizedBox(height: 20),

              // =================================================
              // BUTTON SIMPAN
              // =================================================
              Obx(() => _buildSaveButton(c)),

              const SizedBox(height: 12),

              Center(
                child: Text(
                  'Pastikan data tamu sudah benar sebelum disimpan.',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // HEADER
  // ===========================================================

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0F172A), Color(0xFF1E293B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
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
              Icons.badge_outlined,
              color: Colors.white,
              size: 26,
            ),
          ),

          const SizedBox(width: 13),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Registrasi Tamu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Catat setiap tamu yang memasuki area perusahaan.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 10.5,
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

  // ===========================================================
  // SECTION
  // ===========================================================

  Widget _buildSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE8ECF2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          ...children,
        ],
      ),
    );
  }

  // ===========================================================
  // INPUT
  // ===========================================================

  Widget _inputField({
    required String label,
    required IconData icon,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
    TextInputAction textInputAction = TextInputAction.next,
    FormFieldValidator<String>? validator,
    ValueChanged<String>? onChanged,
  }) {
    final bool isMultiline = maxLines > 1;

    return Padding(
      padding: const EdgeInsets.only(bottom: 13),
      child: TextFormField(
        textInputAction: isMultiline
            ? TextInputAction.newline
            : textInputAction,

        keyboardType: isMultiline ? TextInputType.multiline : keyboardType,

        maxLines: maxLines,
        validator: validator,
        onChanged: onChanged,

        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Color(0xFF334155),
        ),

        decoration: InputDecoration(
          labelText: label,
          hintText: hint,

          labelStyle: TextStyle(fontSize: 11, color: Colors.grey.shade600),

          hintStyle: TextStyle(fontSize: 11, color: Colors.grey.shade400),

          prefixIcon: Padding(
            padding: EdgeInsets.only(bottom: isMultiline ? 45 : 0),
            child: Icon(icon, size: 19, color: Colors.grey.shade500),
          ),

          filled: true,
          fillColor: const Color(0xFFF8FAFC),

          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 14,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: BorderSide(color: Colors.grey.shade200),
          ),

          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.3),
          ),

          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Colors.redAccent),
          ),

          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(13),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.3),
          ),

          errorStyle: const TextStyle(
            fontSize: 9.5,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // PHOTO SECTION
  // ===========================================================

  Widget _buildPhotoSection(TamuAddController c) {
    final hasPhoto = c.foto.value != null;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 190,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: hasPhoto ? const Color(0xFFBBF7D0) : Colors.grey.shade200,
            ),
          ),
          child: hasPhoto
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Image.file(c.foto.value!, fit: BoxFit.cover),

                      // OVERLAY
                      Positioned(
                        left: 10,
                        bottom: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.55),
                            borderRadius: BorderRadius.circular(9),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.check_circle,
                                color: Colors.white,
                                size: 14,
                              ),
                              SizedBox(width: 5),
                              Text(
                                'Foto siap',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: greenColor.withOpacity(0.08),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.add_a_photo_outlined,
                        size: 27,
                        color: greenColor,
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Belum ada foto',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF334155),
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Ambil foto menggunakan kamera atau gallery',
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
        ),

        const SizedBox(height: 12),

        // =====================================================
        // BUTTON FOTO
        // =====================================================
        Row(
          children: [
            Expanded(
              child: _photoButton(
                icon: Icons.camera_alt_outlined,
                label: 'Kamera',
                color: blueColor,
                onPressed: c.pickFotoCamera,
              ),
            ),

            const SizedBox(width: 10),

            Expanded(
              child: _photoButton(
                icon: Icons.photo_library_outlined,
                label: 'Gallery',
                color: greenColor,
                onPressed: c.pickFoto,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ===========================================================
  // PHOTO BUTTON
  // ===========================================================

  Widget _photoButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      height: 45,
      child: OutlinedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, size: 18, color: color),
        label: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        style: OutlinedButton.styleFrom(
          backgroundColor: color.withOpacity(0.04),
          side: BorderSide(color: color.withOpacity(0.20)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  // ===========================================================
  // SAVE BUTTON
  // ===========================================================

  Widget _buildSaveButton(TamuAddController c) {
    final loading = c.isLoading.value;

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: loading
            ? null
            : () {
                if (c.validateForm()) {
                  c.saveData();
                } else {
                  Get.snackbar(
                    'Data Belum Lengkap',
                    'Masih ada data yang wajib diisi.',
                    backgroundColor: const Color(0xFFDC2626),
                    colorText: Colors.white,
                    snackPosition: SnackPosition.TOP,
                    margin: const EdgeInsets.all(14),
                    borderRadius: 12,
                  );
                }
              },
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          disabledBackgroundColor: Colors.grey.shade400,
          foregroundColor: Colors.white,
          elevation: 0,
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.save_outlined, size: 20),
                  SizedBox(width: 9),
                  Text(
                    'Simpan Data Tamu',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
