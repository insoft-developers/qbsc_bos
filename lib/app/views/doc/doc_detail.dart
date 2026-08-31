import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/utils/fungsi.dart';
import 'package:qbsc_saas/app/views/doc/doc_controller.dart';
import 'package:qbsc_saas/app/views/doc/doc_model.dart';
import 'package:qbsc_saas/app/views/patroli/patroli_foto_preview.dart';

class DocDetail extends StatelessWidget {
  final DocModel data;

  const DocDetail({
    super.key,
    required this.data,
  });

  // ==========================================================
  // COLOR
  // ==========================================================

  static const Color primary = Color(0xFF0F172A);
  static const Color blue = Color(0xFF2563EB);
  static const Color green = Color(0xFF16A34A);
  static const Color orange = Color(0xFFF59E0B);
  static const Color background = Color(0xFFF6F8FC);

  @override
  Widget build(BuildContext context) {
    Get.find<DocController>();

    final boxOptions = _parseDocBoxOption(
      data.docBoxOptionJson,
    );

    return Scaffold(
      backgroundColor: background,

      // ========================================================
      // APP BAR
      // ========================================================

      appBar: AppBar(
        backgroundColor: primary,
        elevation: 0,
        titleSpacing: 18,
        title: const Text(
          'Detail DOC Keluar',
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),

      // ========================================================
      // BODY
      // ========================================================

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            _buildHeader(context),

            Padding(
              padding: const EdgeInsets.fromLTRB(
                14,
                14,
                14,
                30,
              ),
              child: Column(
                children: [
                  // =================================================
                  // SUMMARY
                  // =================================================

                  _buildSummary(),

                  const SizedBox(height: 14),

                  // =================================================
                  // INFORMASI TRANSAKSI
                  // =================================================

                  _sectionCard(
                    icon: Icons.receipt_long_outlined,
                    title: 'Informasi Transaksi',
                    child: Column(
                      children: [
                        _infoRow(
                          icon: Icons.tag_outlined,
                          label: 'ID',
                          value: data.id.toString(),
                        ),
                        _infoRow(
                          icon: Icons.calendar_today_outlined,
                          label: 'Tanggal',
                          value: Fungsi.tanggalIndo(
                            data.tanggal,
                          ),
                        ),
                        _infoRow(
                          icon: Icons.access_time_outlined,
                          label: 'Jam',
                          value: data.jam,
                        ),
                        _infoRow(
                          icon: Icons.person_outline_rounded,
                          label: 'Satpam',
                          value: data.satpamName,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // =================================================
                  // DETAIL DOC
                  // =================================================

                  _sectionCard(
                    icon: Icons.local_shipping_outlined,
                    title: 'Detail DOC',
                    child: Column(
                      children: [
                        _infoRow(
                          icon: Icons.local_shipping_outlined,
                          label: 'Ekspedisi',
                          value: data.ekspedisiName,
                        ),
                        _infoRow(
                          icon: Icons.inventory_2_outlined,
                          label: 'Total Box',
                          value: '${data.jumlah} Box',
                        ),
                        _infoRow(
                          icon: Icons.egg_alt_outlined,
                          label: 'Total Ekor',
                          value: '${data.totalEkor} Ekor',
                        ),
                        _infoRow(
                          icon: Icons.wc_outlined,
                          label: 'Jenis DOC',
                          valueWidget: _genderBadge(
                            data.jenis,
                          ),
                        ),
                        _infoRow(
                          icon: Icons.location_on_outlined,
                          label: 'Tujuan',
                          value: data.tujuan ?? '-',
                        ),
                        _infoRow(
                          icon: Icons.directions_car_outlined,
                          label: 'No Polisi',
                          value: data.noPolisi ?? '-',
                        ),
                        _infoRow(
                          icon: Icons.person_outline,
                          label: 'Nama Supir',
                          value: data.namaSupir,
                        ),
                        _infoRow(
                          icon: Icons.verified_outlined,
                          label: 'Nomor Segel',
                          value: data.nomorSegel,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  // =================================================
                  // DETAIL BOX
                  // =================================================

                  if (boxOptions.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _buildBoxSection(boxOptions),
                  ],

                  const SizedBox(height: 12),

                  // =================================================
                  // CATATAN
                  // =================================================

                  _buildNoteSection(),

                  const SizedBox(height: 12),

                  // =================================================
                  // METADATA
                  // =================================================

                  _sectionCard(
                    icon: Icons.info_outline_rounded,
                    title: 'Metadata',
                    child: Column(
                      children: [
                        _infoRow(
                          icon: Icons.event_available_outlined,
                          label: 'Tanggal Input',
                          value: Fungsi.formatDateTime(
                            data.inputDate ?? '',
                          ),
                        ),
                        _infoRow(
                          icon: Icons.schedule_outlined,
                          label: 'Dibuat',
                          value: Fungsi.formatDateTime(
                            data.createdAt,
                          ),
                        ),
                        _infoRow(
                          icon: Icons.business_outlined,
                          label: 'Perusahaan',
                          value: data.comName,
                          isLast: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // HEADER
  // ==========================================================

  Widget _buildHeader(BuildContext context) {
    final fotos = _parseFotoDynamic(data.foto);

    return Container(
      width: double.infinity,
      color: primary,
      padding: const EdgeInsets.fromLTRB(
        14,
        10,
        14,
        22,
      ),
      child: Column(
        children: [
          _buildFotoSection(context),

          const SizedBox(height: 15),

          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: const Icon(
                  Icons.local_shipping_outlined,
                  color: Colors.white,
                  size: 21,
                ),
              ),

              const SizedBox(width: 11),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data.tujuan ?? 'DOC Keluar',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${Fungsi.tanggalIndo(data.tanggal)} • ${data.jam}',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.60),
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              if (fotos.length > 1)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.10),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.photo_library_outlined,
                        size: 13,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${fotos.length}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SUMMARY
  // ==========================================================

  Widget _buildSummary() {
    return Row(
      children: [
        Expanded(
          child: _summaryCard(
            icon: Icons.inventory_2_outlined,
            label: 'Total Box',
            value: '${data.jumlah}',
            suffix: ' Box',
            color: blue,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _summaryCard(
            icon: Icons.egg_alt_outlined,
            label: 'Total Ekor',
            value: '${data.totalEkor}',
            suffix: ' Ekor',
            color: green,
          ),
        ),
      ],
    );
  }

  Widget _summaryCard({
    required IconData icon,
    required String label,
    required String value,
    required String suffix,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.035),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(
              icon,
              size: 19,
              color: color,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: value,
                        style: TextStyle(
                          fontSize: 16,
                          color: color,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      TextSpan(
                        text: suffix,
                        style: TextStyle(
                          fontSize: 9,
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // SECTION CARD
  // ==========================================================

  Widget _sectionCard({
    required IconData icon,
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.025),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  icon,
                  size: 16,
                  color: const Color(0xFF475569),
                ),
              ),

              const SizedBox(width: 9),

              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: primary,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          child,
        ],
      ),
    );
  }

  // ==========================================================
  // INFO ROW
  // ==========================================================

  Widget _infoRow({
    required IconData icon,
    required String label,
    String? value,
    Widget? valueWidget,
    bool isLast = false,
  }) {
    return Container(
      padding: EdgeInsets.only(
        top: 2,
        bottom: isLast ? 0 : 11,
      ),
      margin: EdgeInsets.only(
        bottom: isLast ? 0 : 9,
      ),
      decoration: isLast
          ? null
          : const BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: Color(0xFFF1F5F9),
                ),
              ),
            ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: 16,
            color: const Color(0xFF94A3B8),
          ),

          const SizedBox(width: 10),

          SizedBox(
            width: 90,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 9.5,
                color: Color(0xFF94A3B8),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 8),

          Expanded(
            child: valueWidget ??
                Text(
                  value ?? '-',
                  textAlign: TextAlign.right,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: Color(0xFF334155),
                    fontWeight: FontWeight.w700,
                    height: 1.35,
                  ),
                ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // GENDER
  // ==========================================================

  Widget _genderBadge(int jenis) {
    final bool male = jenis == 1;

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 5,
        ),
        decoration: BoxDecoration(
          color: male
              ? blue.withOpacity(0.08)
              : const Color(0xFFEC4899).withOpacity(0.08),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Text(
          male ? 'Male' : 'Female',
          style: TextStyle(
            fontSize: 9,
            color: male
                ? blue
                : const Color(0xFFDB2777),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }

  // ==========================================================
  // DETAIL BOX
  // ==========================================================

  Widget _buildBoxSection(
    List<Map<String, dynamic>> options,
  ) {
    return _sectionCard(
      icon: Icons.inventory_2_outlined,
      title: 'Detail Box',
      child: Column(
        children: options.asMap().entries.map(
          (entry) {
            final index = entry.key;
            final opt = entry.value;

            return _buildBoxItem(
              opt,
              index,
              index == options.length - 1,
            );
          },
        ).toList(),
      ),
    );
  }

  Widget _buildBoxItem(
    Map<String, dynamic> opt,
    int index,
    bool isLast,
  ) {
    return Container(
      margin: EdgeInsets.only(
        bottom: isLast ? 0 : 9,
      ),
      padding: const EdgeInsets.all(11),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(13),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontSize: 10,
                  color: blue,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),

          const SizedBox(width: 9),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${opt['option_name']}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  '${opt['jumlah_box']} box × ${opt['isi']} ekor/box',
                  style: const TextStyle(
                    fontSize: 8.5,
                    color: Color(0xFF94A3B8),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: green.withOpacity(0.08),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(
              '${opt['total_ekor']} ekor',
              style: const TextStyle(
                fontSize: 9,
                color: green,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // NOTE
  // ==========================================================

  Widget _buildNoteSection() {
    final note = data.note?.trim();

    if (note == null || note.isEmpty) {
      return _sectionCard(
        icon: Icons.sticky_note_2_outlined,
        title: 'Catatan',
        child: const Text(
          'Tidak ada catatan',
          style: TextStyle(
            fontSize: 10,
            color: Color(0xFF94A3B8),
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFFDE68A),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: orange.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.sticky_note_2_outlined,
              size: 16,
              color: orange,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Catatan',
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF92400E),
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  note,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.45,
                    color: Color(0xFF78350F),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================================
  // FOTO SECTION
  // ==========================================================

  Widget _buildFotoSection(
    BuildContext context,
  ) {
    final fotos = _parseFotoDynamic(
      data.foto,
    );

    if (fotos.isEmpty) {
      return _fotoDoc(
        context,
        null,
      );
    }

    if (fotos.length == 1) {
      return _fotoDoc(
        context,
        '${ApiProvider.imageUrl}/${fotos.first}',
      );
    }

    return SizedBox(
      height: 210,
      child: PageView.builder(
        physics: const BouncingScrollPhysics(),
        itemCount: fotos.length,
        itemBuilder: (context, index) {
          final imageUrl =
              '${ApiProvider.imageUrl}/${fotos[index]}';

          return _fotoDoc(
            context,
            imageUrl,
          );
        },
      ),
    );
  }

  Widget _fotoDoc(
    BuildContext context,
    String? imageUrl,
  ) {
    final hasImage =
        imageUrl != null &&
        imageUrl.trim().isNotEmpty;

    return GestureDetector(
      onTap: hasImage
          ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      PatroliFotoPreview(
                    imageUrl: imageUrl!,
                  ),
                ),
              );
            }
          : null,
      child: Container(
        width: double.infinity,
        height: 210,
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: Colors.white.withOpacity(0.08),
          ),
        ),
        child: hasImage
            ? ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder:
                          (
                            context,
                            child,
                            progress,
                          ) {
                        if (progress == null) {
                          return child;
                        }

                        return const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        );
                      },
                      errorBuilder:
                          (
                            context,
                            error,
                            stackTrace,
                          ) {
                        return _iconPlaceholder();
                      },
                    ),

                    // Overlay
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.20),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Tombol lihat foto
                    Positioned(
                      right: 10,
                      bottom: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 9,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.45),
                          borderRadius:
                              BorderRadius.circular(10),
                        ),
                        child: const Row(
                          children: [
                            Icon(
                              Icons.zoom_in,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(width: 5),
                            Text(
                              'Lihat',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
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
            : _iconPlaceholder(),
      ),
    );
  }

  Widget _iconPlaceholder() {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.image_not_supported_outlined,
          size: 42,
          color: Color(0xFF64748B),
        ),
        SizedBox(height: 8),
        Text(
          'Tidak ada foto',
          style: TextStyle(
            fontSize: 10,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  // ==========================================================
  // FOTO PARSER
  // ==========================================================

  List<String> _parseFotoDynamic(
    dynamic foto,
  ) {
    if (foto == null) {
      return [];
    }

    if (foto is List) {
      return foto
          .map((e) => e.toString())
          .toList();
    }

    if (foto is String) {
      try {
        final decoded = jsonDecode(foto);

        if (decoded is List) {
          return decoded
              .map((e) => e.toString())
              .toList();
        }

        return foto.trim().isNotEmpty
            ? [foto]
            : [];
      } catch (_) {
        return foto.trim().isNotEmpty
            ? [foto]
            : [];
      }
    }

    return [];
  }

  // ==========================================================
  // BOX PARSER
  // ==========================================================

  List<Map<String, dynamic>> _parseDocBoxOption(
    String? jsonStr,
  ) {
    if (jsonStr == null ||
        jsonStr.trim().isEmpty) {
      return [];
    }

    try {
      final decoded = jsonDecode(jsonStr);

      if (decoded is! List) {
        return [];
      }

      return decoded
          .whereType<Map>()
          .map(
            (item) => Map<String, dynamic>.from(item),
          )
          .toList();
    } catch (_) {
      return [];
    }
  }
}