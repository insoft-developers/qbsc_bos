import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/master/satpam/satpam_controller.dart';
import 'package:qbsc_saas/app/views/master/satpam/satpam_model.dart';

class SatpamEditPage extends StatefulWidget {
  final SatpamModel satpam;
  const SatpamEditPage({super.key, required this.satpam});

  @override
  State<SatpamEditPage> createState() => _SatpamEditPageState();
}

class _SatpamEditPageState extends State<SatpamEditPage> {
  final c = Get.find<SatpamController>();

  @override
  void initState() {
    super.initState();
    c.setEditData(widget.satpam);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 53, 53),
        title: const Text(
          'Edit Data Satpam',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),

      body: Form(
        key: c.formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _inputField(
                label: "Nama Satpam",
                icon: Icons.person,
                controller: c.nameController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nama wajib diisi' : null,
              ),

              _inputField(
                keyboardType: TextInputType.phone,
                label: "Whatsapp",
                icon: Icons.chat,
                controller: c.whatsappController,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Whatsapp wajib diisi' : null,
              ),

              _inputField(
                label: "Password",
                icon: Icons.lock,
                controller: c.passwordController,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return null;
                  }
                  if (v.length < 6) {
                    return 'Password minimal 6 karakter';
                  }
                  return null;
                },
              ),

              Obx(
                () => Padding(
                  padding: const EdgeInsets.only(bottom: 18),
                  child: DropdownButtonFormField<String>(
                    value: c.jabatan.value.isEmpty ? null : c.jabatan.value,
                    decoration: InputDecoration(
                      labelText: "Pilih Jabatan",
                      prefixIcon: const Icon(Icons.badge),
                      filled: true,
                      fillColor: Colors.grey.shade50,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: "0", child: Text("Anggota")),
                      DropdownMenuItem(value: "1", child: Text("Danru")),
                    ],
                    onChanged: c.setJabatan,
                    validator: (v) =>
                        v == null ? "Jabatan wajib dipilih" : null,
                  ),
                ),
              ),

              _sectionTitle("Foto Satpam"),

              Obx(
                () => Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.grey.shade50,
                  ),
                  child: Column(
                    children: [
                      // 🔥 PRIORITAS 1: Kalau ada foto baru
                      if (c.foto.value != null)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            c.foto.value!,
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      // 🔥 PRIORITAS 2: Kalau tidak ada foto baru tapi ada URL lama
                      else if (c.fotoUrl.value.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            "${ApiProvider.imageUrl}/${c.fotoUrl.value}",
                            height: 160,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        )
                      // 🔥 PRIORITAS 3: Tidak ada apa-apa
                      else
                        Container(
                          height: 160,
                          width: double.infinity,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'Belum ada gambar',
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),

                      const SizedBox(height: 12),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          OutlinedButton.icon(
                            onPressed: c.pickFotoCamera,
                            icon: const Icon(Icons.camera_alt_outlined),
                            label: const Text("Kamera"),
                          ),
                          OutlinedButton.icon(
                            onPressed: c.pickFoto,
                            icon: const Icon(Icons.browse_gallery),
                            label: const Text("Gallery"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 36),

              Obx(
                () => SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: c.isLoading.value
                        ? null
                        : () {
                            if (c.validateForm()) {
                              c.updateData();
                            } else {
                              SnackbarHelper.error(
                                'Gagal',
                                'Masih ada data yang kosong!!',
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black87,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: c.isLoading.value
                        ? const SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Update Data',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.5,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _sectionTitle(String text) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.black87,
      ),
    ),
  );
}

Widget _inputField({
  required String label,
  required IconData icon,
  TextEditingController? controller,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  FormFieldValidator<String>? validator,
  ValueChanged<String>? onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      keyboardType: keyboardType,
      maxLines: maxLines,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.grey.shade50,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
      ),
    ),
  );
}
