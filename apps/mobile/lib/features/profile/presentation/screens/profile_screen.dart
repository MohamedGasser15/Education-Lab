import 'package:flutter/material.dart';
import 'package:mobile/core/theme/app_theme.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('الملف الشخصي'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => Navigator.pushNamed(context, '/settings'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // User Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Stack(
                    children: [
                      const CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200',
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'عمر أحمد',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'طالب متميز • مطور برمجيات واعد',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('تعديل الملف الشخصي'),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Metrics Bar
            Row(
              children: [
                _buildStatItem(
                  'ساعات التعلم',
                  '48 س',
                  Icons.access_time,
                  Colors.blue,
                ),
                _buildStatItem(
                  'دورات منجزة',
                  '4',
                  Icons.book_outlined,
                  Colors.green,
                ),
                _buildStatItem(
                  'شهادات',
                  '3',
                  Icons.verified_outlined,
                  Colors.amber,
                ),
                _buildStatItem(
                  'حماس',
                  '14 يوم',
                  Icons.local_fire_department,
                  Colors.red,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Tab Bar
            TabBar(
              controller: _tabController,
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
              tabs: const [
                Tab(text: 'نظرة عامة'),
                Tab(text: 'الشهادات (3)'),
                Tab(text: 'الأوسمة'),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 280,
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(),
                  _buildCertificatesTab(),
                  _buildBadgesTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 150),
      children: [
        ListTile(
          leading: const Icon(Icons.bookmark_border, color: Colors.blue),
          title: const Text('قائمة الرغبات والمحفوظات'),
          trailing: const Icon(Icons.chevron_left),
          onTap: () => Navigator.pushNamed(context, '/wishlist'),
        ),
        ListTile(
          leading: const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.green,
          ),
          title: const Text('سلة المشتريات'),
          trailing: const Icon(Icons.chevron_left),
          onTap: () => Navigator.pushNamed(context, '/cart'),
        ),
        ListTile(
          leading: const Icon(Icons.settings_outlined, color: Colors.grey),
          title: const Text('إعدادات التطبيق والمظهر'),
          trailing: const Icon(Icons.chevron_left),
          onTap: () => Navigator.pushNamed(context, '/settings'),
        ),
      ],
    );
  }

  Widget _buildCertificatesTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 150),
      children: [
        _buildCertificateCard(
          'شهادة إتقان تطوير React.js',
          'EduLab Academy',
          'امتياز 98%',
        ),
        _buildCertificateCard(
          'الشهادة الاحترافية في UI/UX',
          'Design Guild',
          'امتياز 95%',
        ),
      ],
    );
  }

  Widget _buildCertificateCard(String title, String issuer, String grade) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: const Icon(Icons.verified, color: Colors.blue, size: 36),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
        subtitle: Text(
          '$issuer • $grade',
          style: const TextStyle(fontSize: 11),
        ),
        trailing: const Icon(Icons.download, size: 20),
      ),
    );
  }

  Widget _buildBadgesTab() {
    return GridView.count(
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: const [
        Card(child: Center(child: Text('🔥 بطل الالتزام'))),
        Card(child: Center(child: Text('🏆 صائد الشهادات'))),
      ],
    );
  }
}
