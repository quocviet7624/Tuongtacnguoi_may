import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';

class CaiDatScreen extends StatelessWidget {
  final bool isTab;
  const CaiDatScreen({super.key, this.isTab = false});

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final user = userProvider.currentUser;
    final isEmployer = user?.role == UserRole.nhaTuyenDung;

    String getInitials(String? name) {
      if (name == null || name.isEmpty) return 'U';
      final parts = name.trim().split(' ');
      if (parts.length >= 2) return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
      return name[0].toUpperCase();
    }

    final displayName = isEmployer
        ? (user?.companyName ?? user?.fullName ?? 'Doanh nghiệp')
        : (user?.fullName ?? 'Sinh viên');

    final subtitle = isEmployer
        ? (user?.businessType ?? 'Nhà tuyển dụng')
        : (user?.school ?? 'Sinh viên');

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: !isTab,
        leading: isTab
            ? null
            : IconButton(
                icon: const Icon(Icons.arrow_back_ios,
                    color: Color(0xFF2196F3), size: 20),
                onPressed: () => Navigator.pop(context),
              ),
        centerTitle: true,
        title: Text(
          'Cài đặt',
          style: TextStyle(
            color: isTab ? const Color(0xFF111827) : const Color(0xFF1565C0),
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Profile Card ──────────────────────────────────────────────
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                children: [
                  user?.avatarFile != null
                      ? CircleAvatar(
                          radius: 45,
                          backgroundImage: FileImage(user!.avatarFile!),
                        )
                      : CircleAvatar(
                          radius: 45,
                          backgroundColor: const Color(0xFFEB7E35),
                          child: Text(
                            getInitials(displayName),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                  const SizedBox(height: 12),
                  Text(
                    displayName,
                    style: const TextStyle(
                        color: Color(0xFF111111),
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(subtitle,
                      style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  const SizedBox(height: 4),
                  Text(user?.email ?? '',
                      style: const TextStyle(color: Colors.grey, fontSize: 14)),
                  const SizedBox(height: 8),
                  // Badge role
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isEmployer
                          ? const Color(0xFFEFF6FF)
                          : const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isEmployer ? '🏢 Nhà tuyển dụng' : '🎓 Sinh viên',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: isEmployer
                            ? const Color(0xFF1E40AF)
                            : const Color(0xFF15803D),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ══════════════════════════════════════════════════════════════
            // PHÂN NHÁNH HOÀN TOÀN THEO ROLE
            // ══════════════════════════════════════════════════════════════

            if (!isEmployer) ...[
              // ── SINH VIÊN ─────────────────────────────────────────────

              // Group 1: Tài khoản cá nhân
              _buildSectionLabel('Tài khoản'),
              _buildSettingsGroup(context, [
                _SettingsItem(
                  icon: Icons.person_outline,
                  label: 'Thông tin cá nhân',
                  onTap: () =>
                      Navigator.pushNamed(context, '/chinh-sua-ho-so'),
                ),
                _SettingsItem(
                  icon: Icons.lock_outline,
                  label: 'Đổi mật khẩu',
                  onTap: () =>
                      Navigator.pushNamed(context, '/doi-mat-khau'),
                ),
              ]),

              const SizedBox(height: 12),

              // Group 2: Hồ sơ & Việc làm
              _buildSectionLabel('Hồ sơ & Việc làm'),
              _buildSettingsGroup(context, [
                _SettingsItem(
                  icon: Icons.description_outlined,
                  label: 'CV của tôi',
                  onTap: () => Navigator.pushNamed(context, '/cv-cua-toi'),
                ),
                _SettingsItem(
                  icon: Icons.work_history_outlined,
                  label: 'Việc đã ứng tuyển',
                  onTap: () =>
                      Navigator.pushNamed(context, '/viec-da-ung-tuyen'),
                ),
                _SettingsItem(
                  icon: Icons.bookmark_outline,
                  label: 'Việc đã lưu',
                  onTap: () => Navigator.pushNamed(context, '/saved-jobs'),
                ),
              ]),

            ] else ...[
              // ── NHÀ TUYỂN DỤNG ────────────────────────────────────────

              // Group 1: Thông tin doanh nghiệp (thay cho "thông tin cá nhân")
              _buildSectionLabel('Doanh nghiệp'),
              _buildSettingsGroup(context, [
                _SettingsItem(
                  icon: Icons.business_outlined,
                  label: 'Thông tin công ty',
                  onTap: () =>
                      Navigator.pushNamed(context, '/company-profile-edit'),
                ),
                _SettingsItem(
                  icon: Icons.lock_outline,
                  label: 'Đổi mật khẩu',
                  onTap: () =>
                      Navigator.pushNamed(context, '/doi-mat-khau'),
                ),
              ]),

              const SizedBox(height: 12),

              // Group 2: Quản lý tuyển dụng
              _buildSectionLabel('Quản lý tuyển dụng'),
              _buildSettingsGroup(context, [
                _SettingsItem(
                  icon: Icons.post_add_outlined,
                  label: 'Tin tuyển dụng của tôi',
                  onTap: () =>
                      Navigator.pushNamed(context, '/manage-candidates',
                          arguments: null),
                  // ✅ Nếu đang là tab thì chuyển tab, nếu không thì push
                  // Dùng cách đơn giản nhất: luôn pushNamed, ManageJobsTab tự xử lý
                ),
                _SettingsItem(
                  icon: Icons.people_outline,
                  label: 'Hồ sơ ứng viên',
                  onTap: () =>
                      Navigator.pushNamed(context, '/manage-candidates'),
                ),
                _SettingsItem(
                  icon: Icons.calendar_month_outlined,
                  label: 'Lịch phỏng vấn',
                  onTap: () =>
                      Navigator.pushNamed(context, '/interview-schedule'),
                ),
                _SettingsItem(
                  icon: Icons.chat_outlined,
                  label: 'Tin nhắn',
                  onTap: () => Navigator.pushNamed(context, '/chat-list'),
                ),
              ]),
            ],

            const SizedBox(height: 12),

            // ── Cài đặt chung (cả 2 role) ─────────────────────────────────
            _buildSectionLabel('Cài đặt chung'),
            _buildSettingsGroup(context, [
              _SettingsItem(
                icon: Icons.notifications_outlined,
                label: 'Thông báo',
                onTap: () => Navigator.pushNamed(context, '/thong-bao'),
              ),
              _SettingsItem(
                icon: Icons.language,
                label: 'Ngôn ngữ',
                trailing: const Text('Tiếng Việt',
                    style: TextStyle(color: Color(0xFF999999), fontSize: 13)),
                onTap: () => _showLanguageDialog(context),
              ),
              _SettingsItem(
                icon: Icons.star_outline,
                label: 'Gói Premium',
                trailing: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFF3E0),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text(
                    'Nâng cấp',
                    style: TextStyle(
                        color: Color(0xFFEB7E35),
                        fontSize: 11,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                onTap: () => Navigator.pushNamed(context, '/goi-premium'),
              ),
            ]),

            const SizedBox(height: 12),

            // ── Hỗ trợ & Pháp lý (cả 2 role) ────────────────────────────
            _buildSectionLabel('Hỗ trợ'),
            _buildSettingsGroup(context, [
              _SettingsItem(
                icon: Icons.help_outline,
                label: 'Trung tâm hỗ trợ',
                onTap: () => Navigator.pushNamed(context, '/help-center'),
              ),
              _SettingsItem(
                icon: Icons.description_outlined,
                label: 'Điều khoản sử dụng',
                onTap: () {},
              ),
              _SettingsItem(
                icon: Icons.shield_outlined,
                label: 'Chính sách bảo mật',
                onTap: () {},
              ),
            ]),

            const SizedBox(height: 12),

            // ── Đăng xuất ────────────────────────────────────────────────
            _buildSettingsGroup(context, [
              _SettingsItem(
                icon: Icons.logout,
                label: 'Đăng xuất',
                labelColor: const Color(0xFFD32F2F),
                iconColor: const Color(0xFFD32F2F),
                showArrow: false,
                onTap: () => _showLogoutDialog(context, userProvider),
              ),
            ]),

            const SizedBox(height: 32),
            Text(
              'ViecNow v1.0.0',
              style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 6),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Colors.grey,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(BuildContext context, List<_SettingsItem> items) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFEEEEEE)),
          bottom: BorderSide(color: Color(0xFFEEEEEE)),
        ),
      ),
      child: Column(
        children: items.asMap().entries.map((entry) {
          final idx = entry.key;
          final item = entry.value;
          return Column(
            children: [
              ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 2),
                leading: Icon(item.icon,
                    size: 24,
                    color: item.iconColor ?? const Color(0xFF555555)),
                title: Text(
                  item.label,
                  style: TextStyle(
                    color: item.labelColor ?? const Color(0xFF222222),
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: item.trailing ??
                    (item.showArrow
                        ? const Icon(Icons.chevron_right,
                            color: Color(0xFFBBBBBB), size: 22)
                        : null),
                onTap: item.onTap,
              ),
              if (idx < items.length - 1)
                const Divider(
                    height: 1, indent: 56, color: Color(0xFFF0F0F0)),
            ],
          );
        }).toList(),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context, UserProvider userProvider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Đăng xuất',
            style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Bạn có chắc muốn đăng xuất khỏi hệ thống?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              userProvider.logout();
              Navigator.pushNamedAndRemoveUntil(
                  context, '/login', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEB7E35),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Đăng xuất',
                style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Chọn ngôn ngữ',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        children: [
          _buildLanguageOption(ctx, 'Tiếng Việt', '🇻🇳', true),
          _buildLanguageOption(ctx, 'English', '🇬🇧', false),
        ],
      ),
    );
  }

  Widget _buildLanguageOption(
      BuildContext context, String lang, String flag, bool isSelected) {
    return SimpleDialogOption(
      onPressed: () => Navigator.pop(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 20)),
            const SizedBox(width: 12),
            Text(lang, style: const TextStyle(fontSize: 16)),
            const Spacer(),
            if (isSelected)
              const Icon(Icons.check_circle,
                  color: Color(0xFFEB7E35), size: 20),
          ],
        ),
      ),
    );
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final Color? labelColor;
  final Color? iconColor;
  final Widget? trailing;
  final bool showArrow;
  final VoidCallback onTap;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.iconColor,
    this.trailing,
    this.showArrow = true,
  });
}