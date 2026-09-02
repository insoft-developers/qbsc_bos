import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qbsc_saas/app/data/api_provider.dart';
import 'package:qbsc_saas/app/views/blogs/blog_controller.dart';
import 'package:qbsc_saas/app/views/blogs/blog_detail_page.dart';
import 'package:qbsc_saas/app/views/blogs/blog_model.dart';

class BlogPage extends StatelessWidget {
  const BlogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BlogController());

    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Blog',
          style: TextStyle(
            color: Colors.black87,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),

      body: Obx(() {
        // ============================
        // LOADING PERTAMA
        // ============================
        if (controller.isLoading.value && controller.blogList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        // ============================
        // DATA KOSONG
        // ============================
        if (controller.blogList.isEmpty) {
          return RefreshIndicator(
            onRefresh: controller.refreshData,
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.35),

                Icon(
                  Icons.article_outlined,
                  size: 70,
                  color: Colors.grey.shade400,
                ),

                const SizedBox(height: 15),

                Center(
                  child: Text(
                    'Belum ada artikel',
                    style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
                  ),
                ),
              ],
            ),
          );
        }

        // ============================
        // LIST BLOG
        // ============================
        return RefreshIndicator(
          onRefresh: controller.refreshData,

          child: NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              if (notification.metrics.pixels >=
                  notification.metrics.maxScrollExtent - 300) {
                controller.loadMore();
              }

              return false;
            },

            child: ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),

              itemCount:
                  controller.blogList.length +
                  (controller.isMoreDataAvailable.value ? 1 : 0),

              itemBuilder: (context, index) {
                // ============================
                // LOADING MORE
                // ============================
                if (index >= controller.blogList.length) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  );
                }

                final blog = controller.blogList[index];

                return _BlogCard(
                  blog: blog,
                  onTap: () {
                    Get.to(() => BlogDetailPage(blog: blog));
                  },
                );
              },
            ),
          ),
        );
      }),
    );
  }
}

class _BlogCard extends StatelessWidget {
  final BlogModel blog;
  final VoidCallback onTap;

  const _BlogCard({required this.blog, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),

        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ============================
            // IMAGE
            // ============================
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(16),
              ),

              child: AspectRatio(
                aspectRatio: 16 / 9,

                child: blog.image != null && blog.image!.isNotEmpty
                    ? Image.network(
                        '${ApiProvider.imageUrl}/${blog.image!}',
                        width: double.infinity,
                        fit: BoxFit.cover,

                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }

                          return Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },

                        errorBuilder: (context, error, stackTrace) {
                          return _imagePlaceholder();
                        },
                      )
                    : _imagePlaceholder(),
              ),
            ),

            // ============================
            // CONTENT
            // ============================
            Padding(
              padding: const EdgeInsets.all(16),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  // TANGGAL
                  if (blog.createdAt != null)
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 13,
                          color: Colors.grey.shade500,
                        ),

                        const SizedBox(width: 5),

                        Text(
                          _formatDate(blog.createdAt!),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),

                  const SizedBox(height: 8),

                  // TITLE
                  Text(
                    blog.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,

                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      height: 1.3,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 8),

                  // CONTENT / EXCERPT
                  if (blog.content != null && blog.content!.isNotEmpty)
                    Text(
                      _stripHtml(blog.content!),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: 14,
                        height: 1.5,
                        color: Colors.grey.shade600,
                      ),
                    ),

                  const SizedBox(height: 14),

                  // READ MORE
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Baca selengkapnya',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),

                      const SizedBox(width: 5),

                      Icon(
                        Icons.arrow_forward_rounded,
                        size: 17,
                        color: Theme.of(context).primaryColor,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      color: Colors.grey.shade200,

      child: Icon(
        Icons.article_outlined,
        size: 55,
        color: Colors.grey.shade400,
      ),
    );
  }

  static String _stripHtml(String html) {
    return html
        .replaceAll(RegExp(r'<[^>]*>'), ' ')
        .replaceAll('&nbsp;', ' ')
        .replaceAll('&amp;', '&')
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
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
