import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'models/global_data.dart';
import 'services/storage_service.dart'; // ✅ Thêm import

// Luồng 1: Onboarding & Auth
import 'screens/splash_screen.dart';
import 'screens/onboarding1_screen.dart';
import 'screens/onboarding2_screen.dart';
import 'screens/who_are_you_screen.dart';
import 'screens/login_screen.dart';
import 'screens/quen_mat_khau_screen.dart';
import 'screens/dat_lai_mat_khau_screen.dart';
import 'screens/otp_screen.dart';

// Đăng ký
import 'screens/register_choice_screen.dart';
import 'screens/register_sv_step1_screen.dart';
import 'screens/register_sv_step2_screen.dart';
import 'screens/register_sv_step3_screen.dart';
import 'screens/register_ntd_screen.dart';

// Luồng 2: Sinh viên - Tìm việc & Ứng tuyển
import 'screens/student_home_screen.dart';
import 'screens/job_search_screen.dart';
import 'screens/job_filter_screen.dart';
import 'screens/job_detail_screen.dart';
import 'screens/job_benefits_screen.dart';
import 'screens/company_profile_screen.dart';
import 'screens/saved_jobs_screen.dart';
import 'screens/map_view_screen.dart';
import 'screens/applied_jobs_screen.dart';
import 'screens/apply_detail_screen.dart';

// Luồng 3: Hồ sơ sinh viên
import 'screens/ho_so_sv_screen.dart';
import 'screens/chinh_sua_ho_so_screen.dart';
import 'screens/cv_cua_toi_screen.dart';
import 'screens/ung_tuyen_screen.dart';
import 'screens/viec_da_ung_tuyen_screen.dart';

// Tương tác & Hỗ trợ
import 'screens/chat_list_screen.dart';
import 'screens/chat_detail_screen.dart';
import 'screens/help_center_screen.dart';
import 'screens/report_job_screen.dart';

// Màn hình cũ
import 'screens/ho_so_uv_screen.dart';
import 'screens/thong_bao_screen.dart';
import 'screens/cai_dat_screen.dart';
import 'screens/doi_mat_khau_screen.dart';
import 'screens/tao_thong_bao_viec_lam_screen.dart';
import 'screens/diem_thuong_screen.dart';
import 'screens/goi_premium_screen.dart';

// Luồng NTD
import 'screens/employer_home_screen.dart';
import 'screens/post_job_screen.dart';
import 'screens/manage_candidates_screen.dart';
import 'screens/candidate_detail_screen.dart';
import 'screens/interview_schedule_screen.dart';
import 'screens/company_profile_edit_screen.dart';

void main() async {  // ✅ Thêm async
  // ✅ QUAN TRỌNG: Đảm bảo Flutter binding được khởi tạo trước khi dùng native plugins
  WidgetsFlutterBinding.ensureInitialized();
  
  // ✅ Khởi tạo SharedPreferences
  await StorageService.init();
  
  // ✅ Load dữ liệu từ storage (KHÔNG còn seedDemoData nữa)
  await GlobalData.init();
  
  // ❌ XÓA: GlobalData.seedDemoData(); 

  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(), // UserProvider giờ tự load currentUser từ storage
      child: const ViecNowApp(),
    ),
  );
}

class ViecNowApp extends StatelessWidget {
  const ViecNowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ViecNow',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Inter',
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFEB7E35),
          primary: const Color(0xFFEB7E35),
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
      ),
      // ✅ Tự động chuyển hướng dựa trên trạng thái đăng nhập
      home: const AuthWrapper(), // ✅ Thay initialRoute bằng home với AuthWrapper
      routes: {
        // Onboarding
        '/onboarding1': (context) => const Onboarding1Screen(),
        '/onboarding2': (context) => const Onboarding2Screen(),
        '/who-are-you': (context) => const WhoAreYouScreen(),

        // Auth
        '/login': (context) => const LoginScreen(),
        '/quen-mat-khau': (context) => const QuenMatKhauScreen(),
        '/dat-lai-mat-khau': (context) => const DatLaiMatKhauScreen(),
        '/otp': (context) => const OtpScreen(),

        // Đăng ký
        '/register-choice': (context) => const RegisterChoiceScreen(),
        '/register-sv-1': (context) => const RegisterSvStep1Screen(),
        '/register-sv-2': (context) => const RegisterSvStep2Screen(),
        '/register-sv-3': (context) => const RegisterSvStep3Screen(),
        '/register-ntd': (context) => const RegisterNtdScreen(),

        // Sinh viên
        '/student-home': (context) => const StudentHomeScreen(),
        '/job-search': (context) => const JobSearchScreen(),
        '/job-filter': (context) => const JobFilterScreen(),
        '/job-detail': (context) => const JobDetailScreen(),
        '/job-benefits': (context) => const JobBenefitsScreen(),
        '/company-profile': (context) => const CompanyProfileScreen(),
        '/saved-jobs': (context) => const SavedJobsScreen(),
        '/map-view': (context) => const MapViewScreen(),
        '/applied-jobs': (context) => const AppliedJobsScreen(),
        '/apply-detail': (context) => const ApplyDetailScreen(),

        // Hồ sơ SV
        '/ho-so-sv': (context) => const HoSoSVScreen(),
        '/chinh-sua-ho-so': (context) => const ChinhSuaHoSoScreen(),
        '/cv-cua-toi': (context) => const CvCuaToiScreen(),
        '/ung-tuyen': (context) => const UngTuyenScreen(),
        '/viec-da-ung-tuyen': (context) => const ViecDaUngTuyenScreen(),

        // Chat & Hỗ trợ
        '/chat-list': (context) => const ChatListScreen(),
        '/chat-detail': (context) => const ChatDetailScreen(),
        '/help-center': (context) => const HelpCenterScreen(),
        '/report-job': (context) => const ReportJobScreen(),

        // Misc
        '/ho-so-uv': (context) => const HoSoUVScreen(),
        '/thong-bao': (context) => const ThongBaoScreen(),
        '/cai-dat': (context) => const CaiDatScreen(),
        '/doi-mat-khau': (context) => const DoiMatKhauScreen(),
        '/tao-thong-bao-viec-lam': (context) => const TaoThongBaoViecLamScreen(),
        '/diem-thuong': (context) => const DiemThuongScreen(),
        '/goi-premium': (context) => const GoiPremiumScreen(),

        // NTD
        '/employer-home': (context) {
          final args = ModalRoute.of(context)?.settings.arguments;
          int initialTab = 0;
          if (args is Map && args['initialTab'] != null) {
            initialTab = args['initialTab'] as int;
          }
          return EmployerHomeScreen(initialTab: initialTab);
        },
        '/post-job': (context) => const PostJobScreen(),
        '/manage-candidates': (context) => const ManageCandidatesScreen(),
        '/candidate-detail': (context) => const CandidateDetailScreen(),
        '/interview-schedule': (context) => const InterviewScheduleScreen(),
        '/company-profile-edit': (context) => const CompanyProfileEditScreen(),
      },
      onUnknownRoute: (settings) => MaterialPageRoute(
        builder: (_) => const StudentHomeScreen(),
      ),
    );
  }
}

// ✅ THÊM MỚI: Widget kiểm tra trạng thái đăng nhập
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        // Đang kiểm tra trạng thái / loading
        if (userProvider.isLoggedIn) {
          // Đã đăng nhập -> vào app tương ứng role
          if (userProvider.isEmployer) {
            return const EmployerHomeScreen();
          } else {
            return const StudentHomeScreen();
          }
        } else {
          // Chưa đăng nhập -> Splash/Onboarding
          return const SplashScreen();
        }
      },
    );
  }
}