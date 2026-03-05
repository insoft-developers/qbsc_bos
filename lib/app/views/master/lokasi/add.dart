import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/utils/snackbar_helper.dart';
import 'package:qbsc_saas/app/views/master/lokasi/lokasi_controller.dart';

class LokasiAddPage extends StatefulWidget {
  const LokasiAddPage({super.key});

  @override
  State<LokasiAddPage> createState() => _LokasiAddPageState();
}

class _LokasiAddPageState extends State<LokasiAddPage> {
  final c = Get.find<LokasiController>();

  @override
  void initState() {
    super.initState();
    c.resetForm();
    c.isEdit(false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 60, 53, 53),
        title: const Text(
          'Tambah Data Lokasi',
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
                label: "Nama Lokasi",
                icon: Icons.location_history,
                onChanged: c.setNamaLokasi,
                validator: (v) =>
                    v == null || v.isEmpty ? 'Nama Lokasi wajib diisi' : null,
              ),

              _inputField(
                keyboardType: TextInputType.number,
                label: "Latitude",
                icon: Icons.location_on,
                onChanged: c.setLatitude,
              ),

              _inputField(
                keyboardType: TextInputType.number,
                label: "Longitude",
                icon: Icons.location_on,
                onChanged: c.setLongitude,
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
                              c.saveData();
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
                            'Simpan Data',
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

Widget _inputField({
  required String label,
  required IconData icon,
  TextInputType keyboardType = TextInputType.text,
  int maxLines = 1,
  FormFieldValidator<String>? validator,
  ValueChanged<String>? onChanged,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 18),
    child: TextFormField(
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
