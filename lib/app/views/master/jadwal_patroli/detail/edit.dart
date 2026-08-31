import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:qbsc_saas/app/views/master/jadwal_patroli/detail/jadwal_patroli_detail_controller.dart';
import 'package:qbsc_saas/app/views/master/jadwal_patroli/detail/jadwal_patroli_detail_model.dart';

class JadwalPatroliDetailEditPage
    extends StatefulWidget {
  final JadwalPatroliDetailModel detail;

  const JadwalPatroliDetailEditPage({
    super.key,
    required this.detail,
  });

  @override
  State<JadwalPatroliDetailEditPage>
      createState() =>
          _JadwalPatroliDetailEditPageState();
}

class _JadwalPatroliDetailEditPageState
    extends State<JadwalPatroliDetailEditPage> {
  final c =
      Get.find<JadwalPatroliDetailController>();

  @override
  void initState() {
    super.initState();

    c.setEditData(
      widget.detail,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFFF6F7FB),

      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            const Color(0xFF111827),
        foregroundColor: Colors.white,
        title: const Text(
          'Edit Detail Patroli',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: Form(
        key: c.formKey,

        child: SingleChildScrollView(
          padding:
              const EdgeInsets.all(16),

          child: Column(
            children: [
              // ==================================================
              // HEADER
              // ==================================================

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(18),
                decoration:
                    BoxDecoration(
                  color:
                      const Color(0xFF111827),
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons
                          .edit_location_alt_outlined,
                      color: Colors.white,
                      size: 28,
                    ),
                    SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          Text(
                            'Edit Lokasi Patroli',
                            style:
                                TextStyle(
                              color:
                                  Colors.white,
                              fontSize: 16,
                              fontWeight:
                                  FontWeight
                                      .w800,
                            ),
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            'Perbarui lokasi, urutan dan waktu patroli.',
                            style:
                                TextStyle(
                              color:
                                  Colors.white70,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 20,
              ),

              // ==================================================
              // FORM
              // ==================================================

              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.all(16),
                decoration:
                    BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(
                    20,
                  ),
                  border: Border.all(
                    color:
                        const Color(
                      0xFFE5E7EB,
                    ),
                  ),
                ),

                child: Column(
                  children: [
                    // =================================================
                    // LOKASI
                    // =================================================

                    Obx(() {
                      if (c.isLocationLoading
                          .value) {
                        return const Padding(
                          padding:
                              EdgeInsets.all(
                            20,
                          ),
                          child:
                              CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        );
                      }

                      return DropdownButtonFormField<
                          int>(
                        value:
                            c.locationId.value ==
                                    0
                                ? null
                                : c.locationId
                                    .value,

                        isExpanded:
                            true,

                        decoration:
                            _inputDecoration(
                          label:
                              'Lokasi Patroli',
                          icon: Icons
                              .location_on_outlined,
                        ),

                        items: c
                            .locationList
                            .map(
                              (
                                lokasi,
                              ) {
                                return DropdownMenuItem<
                                    int>(
                                  value:
                                      lokasi.id,
                                  child:
                                      Text(
                                    lokasi
                                        .locationName,
                                    overflow:
                                        TextOverflow
                                            .ellipsis,
                                  ),
                                );
                              },
                            )
                            .toList(),

                        onChanged:
                            c.setLocation,

                        validator:
                            (value) {
                          if (value ==
                                  null ||
                              value ==
                                  0) {
                            return 'Lokasi wajib dipilih';
                          }

                          return null;
                        },
                      );
                    }),

                    const SizedBox(
                      height: 16,
                    ),

                    // =================================================
                    // URUTAN
                    // =================================================

                    TextFormField(
                      controller:
                          c.urutanController,

                      keyboardType:
                          TextInputType.number,

                      onChanged:
                          c.setUrutan,

                      validator:
                          (value) {
                        if (value ==
                                null ||
                            value
                                .trim()
                                .isEmpty) {
                          return 'Urutan wajib diisi';
                        }

                        final number =
                            int.tryParse(
                          value,
                        );

                        if (number ==
                                null ||
                            number <
                                1) {
                          return 'Urutan minimal 1';
                        }

                        return null;
                      },

                      decoration:
                          _inputDecoration(
                        label:
                            'Urutan',
                        icon: Icons
                            .format_list_numbered_rounded,
                        suffixIcon:
                            const Icon(
                          Icons
                              .edit_outlined,
                          size: 18,
                          color:
                              Color(
                            0xFF2563EB,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 16,
                    ),

                    // =================================================
                    // JAM
                    // =================================================

                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () =>
                                _timeField(
                              context:
                                  context,
                              label:
                                  'Jam Awal',
                              value:
                                  c.jamAwal
                                      .value,
                              onTap: () {
                                c.pilihJamAwal(
                                  context,
                                );
                              },
                            ),
                          ),
                        ),

                        const SizedBox(
                          width: 10,
                        ),

                        Expanded(
                          child: Obx(
                            () =>
                                _timeField(
                              context:
                                  context,
                              label:
                                  'Jam Akhir',
                              value:
                                  c.jamAkhir
                                      .value,
                              onTap: () {
                                c.pilihJamAkhir(
                                  context,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // ==================================================
              // SAVE
              // ==================================================

              Obx(
                () {
                  final loading =
                      c.isLoading.value;

                  return SizedBox(
                    width:
                        double.infinity,
                    height: 54,

                    child:
                        ElevatedButton(
                      onPressed: loading
                          ? null
                          : c.updateData,

                      style:
                          ElevatedButton
                              .styleFrom(
                        elevation: 0,
                        backgroundColor:
                            const Color(
                          0xFF2563EB,
                        ),
                        disabledBackgroundColor:
                            const Color(
                          0xFFCBD5E1,
                        ),
                        shape:
                            RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius
                                  .circular(
                            15,
                          ),
                        ),
                      ),

                      child: loading
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
                          : const Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                              children: [
                                Icon(
                                  Icons
                                      .save_outlined,
                                  size: 19,
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Text(
                                  'Simpan Perubahan',
                                  style:
                                      TextStyle(
                                    color:
                                        Colors.white,
                                    fontSize:
                                        13,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),

              const SizedBox(
                height: 10,
              ),

              Text(
                'Mengubah urutan akan menyesuaikan urutan lokasi lainnya.',
                textAlign:
                    TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  color:
                      Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // =============================================================
  // TIME FIELD
  // =============================================================

  Widget _timeField({
    required BuildContext context,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius:
          BorderRadius.circular(13),

      child: InputDecorator(
        decoration:
            _inputDecoration(
          label: label,
          icon: Icons
              .access_time_outlined,
        ),

        child: Text(
          value.isEmpty
              ? 'Pilih jam'
              : value,

          style: TextStyle(
            fontSize: 13,
            fontWeight:
                FontWeight.w600,
            color: value.isEmpty
                ? const Color(
                    0xFF94A3B8,
                  )
                : const Color(
                    0xFF111827,
                  ),
          ),
        ),
      ),
    );
  }

  // =============================================================
  // INPUT DECORATION
  // =============================================================

  InputDecoration _inputDecoration({
    required String label,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    return InputDecoration(
      labelText: label,

      prefixIcon: Icon(
        icon,
        size: 20,
        color:
            const Color(0xFF64748B),
      ),

      suffixIcon:
          suffixIcon,

      filled: true,
      fillColor:
          const Color(0xFFF8FAFC),

      border:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(13),
        borderSide:
            BorderSide.none,
      ),

      enabledBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(13),
        borderSide:
            const BorderSide(
          color:
              Color(0xFFE5E7EB),
        ),
      ),

      focusedBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(13),
        borderSide:
            const BorderSide(
          color:
              Color(0xFF2563EB),
          width: 1.5,
        ),
      ),

      errorBorder:
          OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(13),
        borderSide:
            const BorderSide(
          color:
              Color(0xFFDC2626),
        ),
      ),

      contentPadding:
          const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
    );
  }
}