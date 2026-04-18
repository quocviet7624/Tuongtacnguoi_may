import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'models/global_data.dart';
import 'services/storage_service.dart';

// Screens (giữ nguyên imports của bạn)
import 'screens/splash_screen.dart';
import 'screens/onboarding1_screen.dart';
import 'screens/onboarding2_screen.dart';
import 'screens/who_are_you_screen.dart';
import 'screens/login_screen.dart';
import 'screens/quen_mat_khau_screen.dart';
import 'screens/dat_lai_mat_khau_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/register_choice_screen.dart';
import 'screens/register_sv_step1_screen.dart';
import 'screens/register_sv_step2_screen.dart';
import 'screens/register_sv_step3_screen.dart';
import 'screens/register_ntd_screen.dart';
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
import 'screens/ho_so_sv_screen.dart';
import 'screens/chinh_sua_ho_so_screen.dart';
import 'screens/cv_cua_toi_screen.dart';
import 'screens/ung_tuyen_screen.dart';
import 'screens/viec_da_ung_tuyen_screen.dart';
import 'screens/chat_list_screen.dart';
import 'screens/chat_detail_screen.dart';
import 'screens/help_center_screen.dart';
import 'screens/report_job_screen.dart';
import 'screens/ho_so_uv_screen.dart';
import 'screens/thong_bao_screen.dart';
import 'screens/cai_dat_screen.dart';
import 'screens/doi_mat_khau_screen.dart';
import 'screens/tao_thong_bao_viec_lam_screen.dart';
import 'screens/diem_thuong_screen.dart';
import 'screens/goi_premium_screen.dart';
import 'screens/employer_home_screen.dart';
import 'screens/post_job_screen.dart';
import 'screens/manage_candidates_screen.dart';
import 'screens/candidate_detail_screen.dart';
import 'screens/interview_schedule_screen.dart';
import 'screens/company_profile_edit_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  await GlobalData.init();
  runApp(
    ChangeNotifierProvider(
      create: (_) => UserProvider(), 
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
      home: const AuthWrapper(),
      routes: {
        '/onboarding1': (context) => const Onboarding1Screen(),
        '/onboarding2': (context) => const Onboarding2Screen(),
        '/who-are-you': (context) => const WhoAreYouScreen(),
        '/login': (context) => const LoginScreen(),
        '/quen-mat-khau': (context) => const QuenMatKhauScreen(),
        '/dat-lai-mat-khau': (context) => const DatLaiMatKhauScreen(),
        '/otp': (context) => const OtpScreen(),
        '/register-choice': (context) => const RegisterChoiceScreen(),
        '/register-sv-1': (context) => const RegisterSvStep1Screen(),
        '/register-sv-2': (context) => const RegisterSvStep2Screen(),
        '/register-sv-3': (context) => const RegisterSvStep3Screen(),
        '/register-ntd': (context) => const RegisterNtdScreen(),
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
        '/ho-so-sv': (context) => const HoSoSVScreen(),
        '/chinh-sua-ho-so': (context) => const ChinhSuaHoSoScreen(),
        '/cv-cua-toi': (context) => const CvCuaToiScreen(),
        '/ung-tuyen': (context) => const UngTuyenScreen(),
        '/viec-da-ung-tuyen': (context) => const ViecDaUngTuyenScreen(),
        '/chat-list': (context) => const ChatListScreen(),
        '/chat-detail': (context) => const ChatDetailScreen(),
        '/help-center': (context) => const HelpCenterScreen(),
        '/report-job': (context) => const ReportJobScreen(),
        '/ho-so-uv': (context) => const HoSoUVScreen(),
        '/thong-bao': (context) => const ThongBaoScreen(),
        '/cai-dat': (context) => const CaiDatScreen(),
        '/doi-mat-khau': (context) => const DoiMatKhauScreen(),
        '/tao-thong-bao-viec-lam': (context) => const TaoThongBaoViecLamScreen(),
        '/diem-thuong': (context) => const DiemThuongScreen(),
        '/goi-premium': (context) => const GoiPremiumScreen(),
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

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        if (userProvider.isLoggedIn) {
          if (userProvider.isEmployer) {
            return const EmployerHomeScreen();
          } else {
            return const StudentHomeScreen();
          }
        } else {
          return const SplashScreen();
        }
      },
    );
  }
}