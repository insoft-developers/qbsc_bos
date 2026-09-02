import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/views/blogs/blog_model.dart';

class BlogDetailPage extends StatelessWidget {
  final BlogModel blog;

  const BlogDetailPage({super.key, required this.blog});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

     

      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),

          padding: const EdgeInsets.only(bottom: 30),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,

            children: [
              // =====================================
              // IMAGE UTAMA
              // =====================================
              if (blog.image != null && blog.image!.isNotEmpty)
                Image.network(
                  ApiProvider.imageUrl + '/' + blog.image!,
                  width: double.infinity,
                  height: 230,
                  fit: BoxFit.cover,

                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Container(
                      width: double.infinity,
                      height: 230,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    );
                  },

                  errorBuilder: (context, error, stackTrace) {
                    return _imagePlaceholder();
                  },
                ),

              // =====================================
              // CONTENT
              // =====================================
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    // =================================
                    // TANGGAL
                    // =================================
                    if (blog.createdAt != null)
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 14,
                            color: Colors.grey.shade500,
                          ),

                          const SizedBox(width: 6),

                          Text(
                            _formatDate(blog.createdAt!),
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),

                    const SizedBox(height: 10),

                    // =================================
                    // JUDUL
                    // =================================
                    Text(
                      blog.title,
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        height: 1.25,
                        color: Colors.black87,
                      ),
                    ),

                    const SizedBox(height: 20),

                    // =================================
                    // GARIS
                    // =================================
                    Divider(color: Colors.grey.shade200),

                    const SizedBox(height: 10),

                    // =================================
                    // ARTICLE CONTENT
                    // =================================
                    HtmlWidget(
                      blog.content ?? '',
                      textStyle: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF334155),
                        height: 1.7,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: 230,
      color: Colors.grey.shade200,

      child: Icon(
        Icons.article_outlined,
        size: 60,
        color: Colors.grey.shade400,
      ),
    );
  }

  

  static String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'Mei',
      'Jun',
      'Jul',
      'Agu',
      'Sep',
      'Okt',
      'Nov',
      'Des',
    ];

    return '${date.day} '
        '${months[date.month - 1]} '
        '${date.year}';
  }
}
