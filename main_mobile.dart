import 'dart:math' as math;
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as latlng;
import 'package:url_launcher/url_launcher.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:overlay_support/overlay_support.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const SmartBinDesktopApp());
}

class SmartBinDesktopApp extends StatefulWidget {
  const SmartBinDesktopApp({super.key});

  @override
  State<SmartBinDesktopApp> createState() => _SmartBinDesktopAppState();
}

class _SmartBinDesktopAppState extends State<SmartBinDesktopApp> {
  ThemeMode _themeMode = ThemeMode.dark;
  bool _isLoggedIn = false;
  final databaseRef = FirebaseDatabase.instance.ref("smartbin/bin1");
  Timer? _firebaseTimer;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _handleLoginSuccess() {
    setState(() {
      _isLoggedIn = true;
    });
  }
  

  void _handleLogout() {
    setState(() {
      _isLoggedIn = false;
    });
  }
  @override
  Widget build(BuildContext context) {
    return OverlaySupport.global(
      child: MaterialApp(
      title: 'Smart Bin Dashboard',
      debugShowCheckedModeBanner: false,
      themeMode: _themeMode,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF1F5FB),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF07111D),
        textTheme: GoogleFonts.interTextTheme(),
        useMaterial3: true,
      ),
home: _isLoggedIn
    ? DashboardDesktopPage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
        onLogout: _handleLogout,
      )
    : LoginPage(
        isDarkMode: _themeMode == ThemeMode.dark,
        onThemeChanged: _toggleTheme,
        onLoginSuccess: _handleLoginSuccess,
      ),
            ),
    );
  }
}

class AppC {
  static const bg = Color(0xFF07111D);
  static const bg2 = Color(0xFF091526);
  static const panel = Color(0xFF0D1827);
  static const panel2 = Color(0xFF101D2F);
  static const panel3 = Color(0xFF122238);
  static const border = Color(0xFF1C2B42);

  static const text = Color(0xFFF3F7FF);
  static const sub = Color(0xFF9AA8BF);
  static const muted = Color(0xFF7C8BA4);

  static const blue = Color(0xFF3A84FF);
  static const blue2 = Color(0xFF2458D3);
  static const green = Color(0xFF1FD36B);
  static const green2 = Color(0xFF0FB15A);
  static const yellow = Color(0xFFFFB020);
  static const orange = Color(0xFFFF8A1F);
  static const red = Color(0xFFFF4D57);
  static const purple = Color(0xFF8B5CFF);
  static const teal = Color(0xFF16C4A4);

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  static Color scaffold(BuildContext context) {
    return isDark(context)
        ? const Color(0xFF07111D)
        : const Color(0xFFF1F5FB);
  }

  static Color sidebar(BuildContext context) {
    return isDark(context)
        ? const Color(0xFF081321)
        : const Color(0xFFFFFFFF);
  }

  static Color panelBg(BuildContext context) {
    return isDark(context)
        ? const Color(0xFF0D1827)
        : const Color(0xFFFFFFFF);
  }

  static Color panelBgSoft(BuildContext context) {
    return isDark(context)
        ? const Color(0xFF101D2F)
        : const Color(0xFFF7FAFE);
  }

  static Color borderColor(BuildContext context) {
    return isDark(context)
        ? Colors.white.withOpacity(0.05)
        : const Color(0xFFD7E2F0);
  }

  static Color textColor(BuildContext context) {
    return isDark(context)
        ? const Color(0xFFF3F7FF)
        : const Color(0xFF23395B);
  }

  static Color subColor(BuildContext context) {
    return isDark(context)
        ? const Color(0xFF9AA8BF)
        : const Color(0xFF6E7F99);
  }

  static Color mutedColor(BuildContext context) {
    return isDark(context)
        ? const Color(0xFF7C8BA4)
        : const Color(0xFF9AA9BF);
  }

  static Gradient pageBg(BuildContext context) {
    if (isDark(context)) {
      return const RadialGradient(
        center: Alignment.topLeft,
        radius: 1.15,
        colors: [Color(0xFF0B1B35), Color(0xFF07111D)],
      );
    }

    return const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Color(0xFFEAF1F9),
        Color(0xFFF6F9FD),
      ],
    );
  }

  static Gradient topHeaderBg(BuildContext context) {
    if (isDark(context)) {
      return const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Color(0xFF0B1B35),
          Color(0xFF07111D),
        ],
      );
    }

    return const LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Color(0xFF2E5F9F),
        Color(0xFF4A89D8),
      ],
    );
  }

  static BoxShadow strongLightShadow() {
    return BoxShadow(
      color: const Color(0xFFB8C7DB).withOpacity(0.42),
      blurRadius: 28,
      offset: const Offset(0, 10),
      spreadRadius: 1,
    );
  }

  static List<BoxShadow> panelShadow(BuildContext context) {
    if (isDark(context)) {
      return [
        BoxShadow(
          color: Colors.blue.withOpacity(0.05),
          blurRadius: 24,
          spreadRadius: 2,
        ),
      ];
    }

    return [
      strongLightShadow(),
    ];
  }
}

class LoginPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onLoginSuccess;

  const LoginPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLoginSuccess,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late final AnimationController _animationController;
  late final Animation<double> _vehicleAnimation;
  late final Animation<double> _wheelAnimation;

  bool _obscurePassword = true;
  bool _isLoading = false;
  String? _errorText;

  final String _validUsername = 'admin';
  final String _validPassword = 'smartbin19';

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat();

    _vehicleAnimation = Tween<double>(begin: 1.15, end: -1.15).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _wheelAnimation = Tween<double>(begin: 0, end: math.pi * 2).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );
  }

  void _login() async {
    FocusScope.of(context).unfocus();

    setState(() {
      _errorText = null;
    });

    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      setState(() {
        _errorText = 'Username dan password wajib diisi.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(milliseconds: 800));

    if (username == _validUsername && password == _validPassword) {
      if (!mounted) return;
      widget.onLoginSuccess();
    } else {
      setState(() {
        _isLoading = false;
        _errorText = 'Username atau password salah.';
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  InputDecoration _inputDecoration({
    required BuildContext context,
    required String hint,
    required IconData icon,
    Widget? suffixIcon,
  }) {
    final isDark = AppC.isDark(context);

    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        color: AppC.subColor(context),
        fontWeight: FontWeight.w500,
      ),
      prefixIcon: Icon(
        icon,
        color: AppC.subColor(context),
      ),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: isDark
          ? const Color(0xFF0F1B2D)
          : const Color(0xFFF7FAFE),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: AppC.borderColor(context),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: BorderSide(
          color: AppC.borderColor(context),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(18),
        borderSide: const BorderSide(
          color: AppC.blue,
          width: 1.5,
        ),
      ),
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppC.isDark(context);

return Scaffold(
  resizeToAvoidBottomInset: false,
  body: Container(
        width: double.infinity,
    height: double.infinity,
    decoration: BoxDecoration(
      gradient: AppC.pageBg(context),
    ),
        child: Stack(
          children: [
            Positioned(
              top: -120,
              left: -120,
              child: Container(
                width: 320,
                height: 320,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppC.blue.withOpacity(0.10),
                ),
              ),
            ),
            Positioned(
              bottom: -140,
              right: -100,
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppC.green.withOpacity(0.08),
                ),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(22),
child: Row(
  mainAxisAlignment: MainAxisAlignment.center,
  children: [
if (MediaQuery.of(context).size.width >= 700)
  Expanded(
    flex: 6,
    child: Container(
                              padding: const EdgeInsets.fromLTRB(26, 26, 26, 22),
                        decoration: BoxDecoration(
                          gradient: isDark
                              ? const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFF08192E),
                                    Color(0xFF05111F),
                                  ],
                                )
                              : const LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Color(0xFFFFFFFF),
                                    Color(0xFFF4F8FD),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(34),
                          border: Border.all(
                            color: AppC.borderColor(context),
                            width: 1.2,
                          ),
                          boxShadow: AppC.panelShadow(context),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 74,
                                  height: 74,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppC.blue, Color(0xFF64B6FF)],
                                    ),
                                    borderRadius: BorderRadius.circular(22),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppC.blue.withOpacity(0.28),
                                        blurRadius: 22,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.recycling_rounded,
                                    color: Colors.white,
                                    size: 36,
                                  ),
                                ),
                                const SizedBox(width: 18),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Smart Bin Dashboard',
                                        style: TextStyle(
                                          color: AppC.textColor(context),
                                          fontSize: 28,
                                          fontWeight: FontWeight.w900,
                                          height: 1.1,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Monitoring tempat sampah pintar untuk membantu petugas memantau kepenuhan bin, menerima notifikasi, dan melihat rute pengambilan secara lebih jelas.',
                                        style: TextStyle(
                                          color: AppC.subColor(context),
                                          fontSize: 15,
                                          height: 1.6,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 34),

Expanded(
      child: Container(
                                        width: double.infinity,
                                padding: const EdgeInsets.all(26),
                                decoration: BoxDecoration(
                                  color: isDark
                                      ? const Color(0xFF09172A).withOpacity(0.92)
                                      : Colors.white.withOpacity(0.75),
                                  borderRadius: BorderRadius.circular(28),
                                  border: Border.all(
                                    color: AppC.borderColor(context),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 14,
                                        vertical: 8,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppC.blue.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(999),
                                      ),
                                      child: const Text(
                                        'SMART WASTE MONITORING SYSTEM',
                                        style: TextStyle(
                                          color: AppC.blue,
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w800,
                                          letterSpacing: 0.8,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Text(
                                      'Pantau kondisi tempat sampah dan bantu pengambilan lebih terarah.',
                                      style: TextStyle(
                                        color: AppC.textColor(context),
                                        fontSize: 24,
                                        fontWeight: FontWeight.w900,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 14),
                                    Text(
                                      'Dashboard ini menampilkan informasi penting seperti status kepenuhan, notifikasi bin penuh, riwayat pengambilan, serta peta rute untuk mendukung petugas kebersihan.',
                                      style: TextStyle(
                                        color: AppC.subColor(context),
                                        fontSize: 14.5,
                                        height: 1.7,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 28),

                                    Row(
                                      children: const [
                                        Expanded(
                                          child: _LoginFeatureCard(
                                            icon: Icons.delete_outline_rounded,
                                            title: 'Monitoring Bin',
                                            subtitle:
                                                'Melihat kondisi setiap tempat sampah secara real-time.',
                                          ),
                                        ),
                                        SizedBox(width: 14),
                                        Expanded(
                                          child: _LoginFeatureCard(
                                            icon: Icons.notifications_active_outlined,
                                            title: 'Notifikasi Cepat',
                                            subtitle:
                                                'Peringatan saat bin hampir penuh atau penuh.',
                                          ),
                                        ),
                                        SizedBox(width: 14),
                                        Expanded(
                                          child: _LoginFeatureCard(
                                            icon: Icons.alt_route_rounded,
                                            title: 'Peta & Rute',
                                            subtitle:
                                                'Membantu petugas melihat tujuan pengambilan.',
                                          ),
                                        ),
                                      ],
                                    ),

                                    const Spacer(),

                                    Container(
                                      height: 120,
                                      width: double.infinity,
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 14,
                                      ),
                                      decoration: BoxDecoration(
                                        color: isDark
                                            ? const Color(0xFF0D1B30)
                                            : const Color(0xFFF4F8FD),
                                        borderRadius: BorderRadius.circular(24),
                                        border: Border.all(
                                          color: AppC.borderColor(context),
                                        ),
                                      ),
                                      child: Stack(
                                        children: [
                                          Positioned(
                                            left: 10,
                                            top: 8,
                                            child: Text(
                                              'Aktivitas Pengambilan',
                                              style: TextStyle(
                                                color: AppC.textColor(context),
                                                fontWeight: FontWeight.w800,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 10,
                                            top: 34,
                                            child: Text(
                                              'Simulasi kendaraan petugas bergerak',
                                              style: TextStyle(
                                                color: AppC.subColor(context),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 12.5,
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            left: 0,
                                            right: 0,
                                            bottom: 28,
                                            child: Container(
                                              height: 8,
                                              decoration: BoxDecoration(
                                                color: isDark
                                                    ? Colors.white.withOpacity(0.08)
                                                    : const Color(0xFFD7E2F0),
                                                borderRadius:
                                                    BorderRadius.circular(999),
                                              ),
                                            ),
                                          ),
                                          AnimatedBuilder(
                                            animation: _animationController,
                                            builder: (context, _) {
                                              return Align(
                                                alignment: Alignment(
                                                  _vehicleAnimation.value,
                                                  0.65,
                                                ),
                                                child: _AnimatedTruck(
                                                  wheelRotation:
                                                      _wheelAnimation.value,
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

if (MediaQuery.of(context).size.width >= 700)
  const SizedBox(width: 24),
Expanded(
  child: Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: 360,
          height: 500,
          child: Container(
                padding: const EdgeInsets.fromLTRB(34, 80, 34, 34),
                            decoration: BoxDecoration(
                          color: AppC.panelBg(context),
                          borderRadius: BorderRadius.circular(34),
                          border: Border.all(
                            color: AppC.borderColor(context),
                            width: 1.2,
                          ),
                          boxShadow: AppC.panelShadow(context),
                        ),
child: Center(
  child: ConstrainedBox(
    constraints: const BoxConstraints(maxWidth: 520),
child: FittedBox(
  fit: BoxFit.scaleDown,
  child: SizedBox(
    width: 300,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
                                        Container(
                                  width: 74,
                                  height: 74,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [AppC.blue, Color(0xFF64B6FF)],
                                    ),
                                    borderRadius: BorderRadius.circular(24),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppC.blue.withOpacity(0.28),
                                        blurRadius: 22,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.lock_outline_rounded,
                                    color: Colors.white,
                                    size: 32,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Masuk ke Sistem',
                                  style: TextStyle(
                                    color: AppC.textColor(context),
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Login untuk membuka dashboard Smart Bin',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: AppC.subColor(context),
                                    fontSize: 14,
                                    height: 1.5,
                                  ),
                                ),
                                const SizedBox(height: 22),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Username',
                                    style: TextStyle(
                                      color: AppC.textColor(context),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _usernameController,
                                  style: TextStyle(
                                    color: AppC.textColor(context),
                                  ),
                                  decoration: _inputDecoration(
                                    context: context,
                                    hint: 'Masukkan username',
                                    icon: Icons.person_outline_rounded,
                                  ),
                                ),

                                const SizedBox(height: 18),

                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    'Password',
                                    style: TextStyle(
                                      color: AppC.textColor(context),
                                      fontWeight: FontWeight.w700,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                                TextField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  onSubmitted: (_) => _login(),
                                  style: TextStyle(
                                    color: AppC.textColor(context),
                                  ),
                                  decoration: _inputDecoration(
                                    context: context,
                                    hint: 'Masukkan password',
                                    icon: Icons.lock_outline_rounded,
                                    suffixIcon: IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _obscurePassword = !_obscurePassword;
                                        });
                                      },
                                      icon: Icon(
                                        _obscurePassword
                                            ? Icons.visibility_off_outlined
                                            : Icons.visibility_outlined,
                                        color: AppC.subColor(context),
                                      ),
                                    ),
                                  ),
                                ),

                                if (_errorText != null) ...[
                                  const SizedBox(height: 14),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 12,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppC.red.withOpacity(0.10),
                                      borderRadius: BorderRadius.circular(14),
                                      border: Border.all(
                                        color: AppC.red.withOpacity(0.20),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.error_outline_rounded,
                                          color: AppC.red,
                                          size: 18,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            _errorText!,
                                            style: const TextStyle(
                                              color: AppC.red,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],

                                const SizedBox(height: 18),

                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppC.blue,
                                      foregroundColor: Colors.white,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.4,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'Masuk ke Dashboard',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                  ),
                                ),

                                const SizedBox(height: 16),
                                const SizedBox(height: 18),

                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Dark Mode',
                                      style: TextStyle(
                                        color: AppC.textColor(context),
                                        fontWeight: FontWeight.w700,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Switch(
                                      value: widget.isDarkMode,
                                      onChanged: widget.onThemeChanged,
                                      activeThumbColor: AppC.blue,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),

SizedBox(
  width: 300,
  height: 70,
  child: Stack(
    children: [
      Positioned(
        left: 0,
        right: 0,
        bottom: 18,
        child: Container(
          height: 5,
          decoration: BoxDecoration(
            color: AppC.blue.withOpacity(0.18),
            borderRadius: BorderRadius.circular(999),
          ),
        ),
      ),

      AnimatedBuilder(
        animation: _animationController,
        builder: (context, _) {
          return Align(
            alignment: Alignment(
              _vehicleAnimation.value,
              0.65,
            ),
            child: _AnimatedTruck(
              wheelRotation: _wheelAnimation.value,
            ),
          );
        },
      ),
    ],
  ),
),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
),
),
      ],
),
),
),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AppScaleWrapper extends StatelessWidget {
  final Widget child;
  final double scale;

  const AppScaleWrapper({
    super.key,
    required this.child,
    this.scale = 0.67,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final scaledWidth = constraints.maxWidth / scale;
        final scaledHeight = constraints.maxHeight / scale;

        return Container(
          width: constraints.maxWidth,
          height: constraints.maxHeight,
          color: AppC.scaffold(context),
          child: OverflowBox(
            alignment: Alignment.topLeft,
            minWidth: scaledWidth,
            maxWidth: scaledWidth,
            minHeight: scaledHeight,
            maxHeight: scaledHeight,
            child: Transform.scale(
              scale: scale,
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: scaledWidth,
                height: scaledHeight,
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _LoginFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _LoginFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppC.isDark(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark
            ? const Color(0xFF0D1A2C)
            : const Color(0xFFF8FBFF),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppC.borderColor(context),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppC.blue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: AppC.blue,
              size: 22,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            title,
            style: TextStyle(
              color: AppC.textColor(context),
              fontSize: 15,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: TextStyle(
              color: AppC.subColor(context),
              fontSize: 12.5,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedTruck extends StatelessWidget {
  final double wheelRotation;

  const _AnimatedTruck({
    required this.wheelRotation,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 170,
      height: 70,
      child: Stack(
        alignment: Alignment.centerLeft,
        children: [
          Positioned(
            left: 20,
            bottom: 18,
            child: Container(
              width: 82,
              height: 26,
              decoration: BoxDecoration(
                color: AppC.blue,
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          Positioned(
            left: 92,
            bottom: 22,
            child: Container(
              width: 34,
              height: 22,
              decoration: BoxDecoration(
                color: const Color(0xFF6EC1FF),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.person,
                size: 14,
                color: Colors.white,
              ),
            ),
          ),
          Positioned(
            left: 10,
            bottom: 38,
            child: Container(
              width: 22,
              height: 18,
              decoration: BoxDecoration(
                color: AppC.green,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: Colors.white,
                size: 12,
              ),
            ),
          ),
          Positioned(
            left: 30,
            bottom: 2,
            child: Transform.rotate(
              angle: wheelRotation,
              child: const Icon(
                Icons.settings,
                color: Colors.black87,
                size: 22,
              ),
            ),
          ),
          Positioned(
            left: 90,
            bottom: 2,
            child: Transform.rotate(
              angle: wheelRotation,
              child: const Icon(
                Icons.settings,
                color: Colors.black87,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoginInfoChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _LoginInfoChip({
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppC.blue.withOpacity(0.10),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: AppC.blue.withOpacity(0.16),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: AppC.blue,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: const TextStyle(
              color: AppC.blue,
              fontWeight: FontWeight.w700,
              fontSize: 12.5,
            ),
          ),
        ],
      ),
    );
  }
}

enum SidebarMenu {
  dashboard,
  petaRute,
  tempatSampah,
  riwayat,
  notifikasi,
  pengaturanSistem,
}

class SmartBinNode {
  final String id;
  final String name;
  final latlng.LatLng position;
  final double fillPercent;
  final String googleMapsPlaceUrl;
  final String imagePath;
  final String imgDepan;
  final String imgKanan;
  final String imgKiri;
  final String imgAtas;

  const SmartBinNode({
    required this.id,
    required this.name,
    required this.position,
    required this.fillPercent,
    required this.googleMapsPlaceUrl,
    required this.imagePath,
    required this.imgDepan,
    required this.imgKanan,
    required this.imgKiri,
    required this.imgAtas,
  });

  SmartBinNode copyWith({
    String? id,
    String? name,
    latlng.LatLng? position,
    double? fillPercent,
    String? googleMapsPlaceUrl,
    String? imagePath,
    String? imgDepan,
    String? imgKanan,
    String? imgKiri,
    String? imgAtas,
  }) {
    return SmartBinNode(
      id: id ?? this.id,
      name: name ?? this.name,
      position: position ?? this.position,
      fillPercent: fillPercent ?? this.fillPercent,
      googleMapsPlaceUrl: googleMapsPlaceUrl ?? this.googleMapsPlaceUrl,
      imagePath: imagePath ?? this.imagePath,
      imgDepan: imgDepan ?? this.imgDepan,
      imgKanan: imgKanan ?? this.imgKanan,
      imgKiri: imgKiri ?? this.imgKiri,
      imgAtas: imgAtas ?? this.imgAtas,
    );
  }

  bool get isFull => fillPercent >= 92;
  bool get isAlmostFull => fillPercent >= 50 && fillPercent < 92;
  bool get isNotFull => fillPercent < 50;

  String get status {
    if (isFull) return 'Penuh';
    if (isAlmostFull) return 'Hampir Penuh';
    return 'Belum Penuh';
  }

  Color get color {
    if (isFull) return AppC.red;
    if (isAlmostFull) return AppC.yellow;
    return AppC.green;
  }
}

class NotifikasiItem {
  final String namaBin;
  final double persentase;
  final DateTime waktu;
  final String pesan;

  const NotifikasiItem({
    required this.namaBin,
    required this.persentase,
    required this.waktu,
    required this.pesan,
  });
}

class RiwayatPengambilan {
  final String namaBin;
  final DateTime waktu;
  final double jarakKm;
  final String status;

  const RiwayatPengambilan({
    required this.namaBin,
    required this.waktu,
    required this.jarakKm,
    required this.status,
  });
}

class AktivitasBinItem {
  final String title;
  final String subtitle;
  final DateTime waktu;
  final Color color;
  final IconData icon;

  const AktivitasBinItem({
    required this.title,
    required this.subtitle,
    required this.waktu,
    required this.color,
    required this.icon,
  });
}

class RouteResult {
  final List<latlng.LatLng> points;
  final List<SmartBinNode> orderedBins;
  final double totalDistanceKm;

  const RouteResult({
    required this.points,
    required this.orderedBins,
    required this.totalDistanceKm,
  });
}

double _distanceKm(latlng.LatLng a, latlng.LatLng b) {
  const d = latlng.Distance();
  return d.as(latlng.LengthUnit.Kilometer, a, b);
}

class FirebaseRouteNode {
  final String id;
  final String label;
  final String type;
  final latlng.LatLng position;

  const FirebaseRouteNode({
    required this.id,
    required this.label,
    required this.type,
    required this.position,
  });
}

class FirebaseRouteTableRow {
  final String node;
  final double? g;
  final double? h;
  final double? f;
  final String status;

  const FirebaseRouteTableRow({
    required this.node,
    required this.g,
    required this.h,
    required this.f,
    required this.status,
  });
}
class FirebaseRouteData {
  final String fullBin;
  final double distanceKm;
  final List<String> route;
  final List<String> forwardRoute;
  final List<String> returnRoute;
  final Map<String, FirebaseRouteNode> nodes;
  final List<FirebaseRouteTableRow> tableRows;

  const FirebaseRouteData({
    required this.fullBin,
    required this.distanceKm,
    required this.route,
    required this.forwardRoute,
    required this.returnRoute,
    required this.nodes,
    required this.tableRows,
  });

factory FirebaseRouteData.empty() {
  return const FirebaseRouteData(
    fullBin: '',
    distanceKm: 0,
    route: [],
    forwardRoute: [],
    returnRoute: [],
    nodes: {},
    tableRows: [],
  );
}
factory FirebaseRouteData.fromFirebase({
  required Map<String, dynamic> rootData,
  required List<SmartBinNode> bins,
}) {
  Map<String, dynamic>? tps;

  // ===============================
  // AMBIL DATA ROUTING DARI FIREBASE
  // ===============================
if (rootData['routing'] is Map) {
  final routing = Map<String, dynamic>.from(rootData['routing']);

  if (routing['currentRoute'] is Map) {
    tps = Map<String, dynamic>.from(routing['currentRoute']);
  } else {
    tps = routing;
  }
  } else if (rootData['route'] != null) {
    tps = rootData;
  } else if (rootData['tps1'] is Map) {
    tps = Map<String, dynamic>.from(rootData['tps1']);
  } else if (rootData['smartbin'] is Map) {
    final smartbin = Map<String, dynamic>.from(rootData['smartbin']);

    if (smartbin['tps1'] is Map) {
      tps = Map<String, dynamic>.from(smartbin['tps1']);
    } else if (smartbin['route'] != null) {
      tps = smartbin;
    }
  }

  if (tps == null) {
    debugPrint('DATA ROUTE TIDAK DITEMUKAN DI FIREBASE');
    return FirebaseRouteData.empty();
  }

  debugPrint('ROUTING KEYS TERBACA = ${tps.keys.toList()}');

  final fullBin = '${tps['fullBin'] ?? ''}'.trim().toLowerCase();

  final rawDistance = double.tryParse('${tps['distance'] ?? 0}') ?? 0.0;

  final distanceKm = rawDistance > 100
      ? rawDistance / 1000
      : rawDistance;

final forwardRoute = _parseRoute(tps['forwardRoute']);
final returnRoute = _parseRoute(tps['returnRoute']);

final route = _parseCurrentRoute(tps);
  final nodes = _buildNodesFromFirebaseOrFallback(
    rootData: rootData,
    tpsData: tps,
    bins: bins,
  );

final tableRows = _buildTableRowsFromFirebaseDebug(
  tps,
  route,
);

return FirebaseRouteData(
  fullBin: fullBin,
  distanceKm: distanceKm,
  route: route,
  forwardRoute: forwardRoute,
  returnRoute: returnRoute,
  nodes: nodes,
  tableRows: tableRows,
);
}
static List<String> _parseRoute(dynamic rawRoute) {
  if (rawRoute is List) {
    return rawRoute
        .map((e) => '$e'.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  if (rawRoute is Map) {
    final entries = rawRoute.entries.toList();

    entries.sort((a, b) {
      final ai = int.tryParse('${a.key}') ?? 0;
      final bi = int.tryParse('${b.key}') ?? 0;
      return ai.compareTo(bi);
    });

    return entries
        .map((e) => '${e.value}'.trim().toLowerCase())
        .where((e) => e.isNotEmpty)
        .toList();
  }

  return [];
}
static List<String> _parseCurrentRoute(Map<String, dynamic> tps) {
  final forwardRoute = _parseRoute(tps['forwardRoute']);
  final returnRoute = _parseRoute(tps['returnRoute']);

  if (forwardRoute.isEmpty && returnRoute.isEmpty) {
    return _parseRoute(tps['route']);
  }

  if (forwardRoute.isNotEmpty && returnRoute.isNotEmpty) {
    return [
      ...forwardRoute,
      ...returnRoute.skip(1),
    ];
  }

  if (forwardRoute.isNotEmpty) {
    return forwardRoute;
  }

  return returnRoute;
}
  static Map<String, FirebaseRouteNode> _buildNodesFromFirebaseOrFallback({
    required Map<String, dynamic> rootData,
    required Map<String, dynamic> tpsData,
    required List<SmartBinNode> bins,
  }) {
    final result = <String, FirebaseRouteNode>{};

    // ============================
    // 1. NODE DARI FIREBASE tps1/nodes
    // ============================
    final rawNodes = tpsData['nodes'];

    if (rawNodes is Map) {
      rawNodes.forEach((key, value) {
        if (value is Map) {
          final map = Map<String, dynamic>.from(value);

          final lat = double.tryParse(
                '${map['lat'] ?? map['latitude'] ?? 0}',
              ) ??
              0.0;

          final lon = double.tryParse(
                '${map['lon'] ?? map['lng'] ?? map['longitude'] ?? 0}',
              ) ??
              0.0;

          if (lat != 0 && lon != 0) {
            result['$key'] = FirebaseRouteNode(
              id: '$key',
              label: '${map['label'] ?? key}',
              type: '${map['type'] ?? 'node'}',
              position: latlng.LatLng(lat, lon),
            );
          }
        }
      });
    }

    // ============================
    // 2. FALLBACK NODE TPS / DEPOT
    // ============================
    result.putIfAbsent(
      'tps',
      () => const FirebaseRouteNode(
        id: 'tps',
        label: 'TPS / Depot',
        type: 'depot',
        position: latlng.LatLng(-7.4352631, 109.2490926),
      ),
    );

    // ============================
    // 3. FALLBACK BIN DARI DATA APLIKASI
    // ============================
    for (final bin in bins) {
      final firebaseId = bin.id.toLowerCase().replaceAll('-', '');

      result.putIfAbsent(
        firebaseId,
        () => FirebaseRouteNode(
          id: firebaseId,
          label: bin.name,
          type: 'bin',
          position: bin.position,
        ),
      );
    }

    // ============================
    // 4. FALLBACK NODE JALAN 3 BIN
    // GANTI KOORDINAT DI SINI DENGAN NODE ASLI ANDA
    // ============================

    // Jalur BIN-1
    result.putIfAbsent(
      's0',
      () => const FirebaseRouteNode(
        id: 's0', //pertigaan jln sidodadi
        label: 'S0',
        type: 'node',
        position: latlng.LatLng(-7.430649655537240, 109.25163759905200 ),
      ),
    );

    // Jalur BIN-2
    result.putIfAbsent(
      'p2',
      () => const FirebaseRouteNode(
        id: 'p2',
        label: 'P2', //perempatan sidodadi & pancurawis
        type: 'node',
        position: latlng.LatLng(-7.430386818260330, 109.25355362705800),
      ),
    );

    result.putIfAbsent(
      'p3',
      () => const FirebaseRouteNode(
        id: 'p3',
        label: 'P3', //lawson pertigaan arah jendral sudirman
        type: 'node',
        position: latlng.LatLng(-7.429979046737700, 109.25553654926800),
      ),
    );

    result.putIfAbsent(
      'p4',
      () => const FirebaseRouteNode(
        id: 'p4',
        label: 'P4', //masuk bundaran adipura
        type: 'node',
        position: latlng.LatLng(-7.437098320128613, 109.26230334865872),
      ),
    );
    result.putIfAbsent(
      'p4a',
      () => const FirebaseRouteNode(
        id: 'p4a',
        label: 'P4a', //keluar bundaran adipura arah ke tps
        type: 'node',
        position: latlng.LatLng(-7.437114942909819, 109.26223025846414),
      ),
    );

    result.putIfAbsent(
      'p5',
      () => const FirebaseRouteNode(
        id: 'p5',
        label: 'P5', //keluar bundaran adipura
        type: 'node',
        position: latlng.LatLng(-7.437244594451760, 109.26249831315400),
      ),
    );
    result.putIfAbsent(
      'p5a',
      () => const FirebaseRouteNode(
        id: 'p5a',
        label: 'P5a', //jalan pulang bundaran adipura
        type: 'node',
        position: latlng.LatLng(-7.437335383444089, 109.26250319065721 ),
      ),
    );

    result.putIfAbsent(
      'p6',
      () => const FirebaseRouteNode(
        id: 'p6',
        label: 'P6', //masuk bundaran patung kuda
        type: 'node',
        position: latlng.LatLng(-7.438569197518580, 109.26772716352300 ),
      ),
    );

    result.putIfAbsent(
      'p6a',
      () => const FirebaseRouteNode(
        id: 'p6a',
        label: 'P6a', //simpang jl sunan kalijaga gg1 dari jalan besar
        type: 'node',
        position: latlng.LatLng(-7.439361807557044, 109.26853303738648 ),
      ),
    );
    result.putIfAbsent(
      'p7',
      () => const FirebaseRouteNode(
        id: 'p7',
        label: '7', //keluar bundaran patung kuda
        type: 'node',
        position: latlng.LatLng(-7.438678407425730, 109.26767849487000 ),
      ),
    );
    result.putIfAbsent(
      'p8',
      () => const FirebaseRouteNode(
        id: 'p8',
        label: 'P8', //pertigaan sunan kalijaga
        type: 'node',
        position: latlng.LatLng(-7.437954501000300, 109.26610246560700),
      ),
    );
    result.putIfAbsent(
      'p9',
      () => const FirebaseRouteNode(
        id: 'p9',
        label: 'P9', //pertigaan sunan kalijaga gg 1
        type: 'node',
        position: latlng.LatLng(-7.438570956667230, 109.26623603903300),
      ),
    );
    result.putIfAbsent(
      'p10',
      () => const FirebaseRouteNode(
        id: 'p10',
        label: '10', //simpang jl sunan kalijaga gg1 dari jalan besar
        type: 'node',
        position: latlng.LatLng(-7.439115108280830, 109.2663562576390),
      ),
    );
    result.putIfAbsent(
      'p11',
      () => const FirebaseRouteNode(
        id: 'p11',
        label: 'P11', //simpang jl sunan kalijaga gg1 dari jalan besar
        type: 'node',
        position: latlng.LatLng(-7.439709426739840, 109.2674986877580),
      ),
    );
    result.putIfAbsent(
      'p12',
      () => const FirebaseRouteNode(
        id: 'p12',
        label: 'P12', //simpang jl sunan kalijaga gg1 dari jalan besar
        type: 'node',
        position: latlng.LatLng(-7.440398513038150, 109.2666403426170),
      ),
    );
    result.putIfAbsent(
      'p13',
      () => const FirebaseRouteNode(
        id: 'p13',
        label: 'P13', //simpang jl sunan kalijaga gg1 dari jalan besar
        type: 'node',
        position: latlng.LatLng(-7.439361989403610, 109.2685296372440),
      ),
    );
    result.putIfAbsent(
      'p15',
      () => const FirebaseRouteNode(
        id: 'p15',
        label: 'P15', //simpang jl sunan kalijaga gg1 dari jalan besar
        type: 'node',
        position: latlng.LatLng(-7.438836463739980, 109.2489163720090),
      ),
    );
    result.putIfAbsent(
      'p16',
      () => const FirebaseRouteNode(
        id: 'p16',
        label: 'P16', //simpang jl sunan kalijaga gg1 dari jalan besar
        type: 'node',
        position: latlng.LatLng(-7.437326135525846, 109.26217577098235),
      ),
    );
    result.putIfAbsent(
      'p16a',
      () => const FirebaseRouteNode(
        id: 'p16a',
        label: 'P16a', //simpang jl sunan kalijaga gg1 dari jalan besar
        type: 'node',
        position: latlng.LatLng(-7.437386427876526, 109.26223556283732),
      ),
    );
    result.putIfAbsent(
      'p17',
      () => const FirebaseRouteNode(
        id: 'p17',
        label: 'P17', //simpang jl sunan kalijaga gg1 dari jalan besar
        type: 'node',
        position: latlng.LatLng(-7.4291032719955385, 109.25473518128814),
      ),
    );

    // Jalur BIN-3
    result.putIfAbsent(
      'c2',
      () => const FirebaseRouteNode(
        id: 'c2',
        label: 'C2',
        type: 'node',
        position: latlng.LatLng(-7.430935858094490, 109.24875756438500),
      ),
    );

    result.putIfAbsent(
      'c3',
      () => const FirebaseRouteNode(
        id: 'c3',
        label: 'C3',
        type: 'node',
        position: latlng.LatLng(-7.427629595876430, 109.24866692366800),
      ),
    );
    result.putIfAbsent(
      'c4',
      () => const FirebaseRouteNode(
        id: 'c4',
        label: 'C4',
        type: 'node',
        position: latlng.LatLng(-7.427615983544590, 109.24876485446900),
      ),
    );

    result.putIfAbsent(
      'c5',
      () => const FirebaseRouteNode(
        id: 'c5',
        label: 'C5',
        type: 'node',
        position: latlng.LatLng(-7.424976129901880, 109.24859085157700),
      ),
    );
    result.putIfAbsent(
      'c6',
      () => const FirebaseRouteNode(
        id: 'c6',
        label: 'C6',
        type: 'node',
        position: latlng.LatLng(-7.424988643425380, 109.24599126802800),
      ),
    );
    result.putIfAbsent(
      'c7',
      () => const FirebaseRouteNode(
        id: 'c7',
        label: 'C7',
        type: 'node',
        position: latlng.LatLng(-7.425406258295280, 109.24606547043900),
      ),
    );
    result.putIfAbsent(
      'c8',
      () => const FirebaseRouteNode(
        id: 'c8',
        label: 'C8',
        type: 'node',
        position: latlng.LatLng(-7.427803689915750, 109.24370189752900),
      ),
    );
    result.putIfAbsent(
      'c9',
      () => const FirebaseRouteNode(
        id: 'c9',
        label: 'C9',
        type: 'node',
        position: latlng.LatLng(-7.425813378155790, 109.24370870142700),
      ),
    );
    result.putIfAbsent(
      'c10',
      () => const FirebaseRouteNode(
        id: 'c10',
        label: 'C10',
        type: 'node',
        position: latlng.LatLng(-7.430854658116340, 109.24714760388900),
      ),
    );
    result.putIfAbsent(
      'c11',
      () => const FirebaseRouteNode(
        id: 'c11',
        label: 'C11',
        type: 'node',
        position: latlng.LatLng(-7.430801464437000, 109.24375729168500 ),
      ),
    );
    result.putIfAbsent(
      'c12',
      () => const FirebaseRouteNode(
        id: 'c12',
        label: 'C12',
        type: 'node',
        position: latlng.LatLng(-7.429110103066550, 109.24374561361500),
      ),
    );
    result.putIfAbsent(
      'c13',
      () => const FirebaseRouteNode(
        id: 'c13',
        label: 'C13',
        type: 'node',
        position: latlng.LatLng(-7.429659823923560, 109.24873810103900),
      ),
    );


    return result;
  }
static double _toDoubleValue(dynamic value) {
  if (value == null) return 0.0;

  if (value is num) {
    return value.toDouble();
  }

  return double.tryParse('$value') ?? 0.0;
}

static String _defaultStatusFromNode(String nodeId) {
  final id = nodeId.toLowerCase();

  if (id.contains('tps')) {
    return 'Depot';
  }

  if (id.startsWith('bin')) {
    return 'Tujuan';
  }

  return 'Node Aktif';
}

static List<FirebaseRouteTableRow> _buildTableRowsFromFirebase({
  required Map<String, dynamic> tps,
  required List<String> route,
  required String fullBin,
}) {
  dynamic rawTable =
      tps['table'] ??
      tps['tables'] ??
      tps['perhitungan'] ??
      tps['calculation'] ??
      tps['nodeTable'] ??
      tps['astarTable'] ??
      tps['astarSteps'] ??
      tps['astarDebug'];

  if (rawTable == null) {
    return [];
  }

  final rows = <FirebaseRouteTableRow>[];

  // ==========================================
  // FORMAT 1:
  // astarSteps: [
  //   { node: "tps", g: 0, h: 2, f: 2 },
  //   { node: "s0",  g: 1, h: 2, f: 3 }
  // ]
  // ==========================================
  if (rawTable is List) {
    for (int i = 0; i < rawTable.length; i++) {
      final item = rawTable[i];

      if (item is! Map) continue;

      final map = Map<String, dynamic>.from(item);

      final nodeId = '${map['node'] ?? map['id'] ?? map['current'] ?? (i < route.length ? route[i] : i)}'
          .trim()
          .toLowerCase();

      final g = _toDoubleValue(
        map['g'] ??
            map['gn'] ??
            map['g(n)'] ??
            map['gScore'] ??
            map['g_score'],
      );

      final h = _toDoubleValue(
        map['h'] ??
            map['hn'] ??
            map['h(n)'] ??
            map['hScore'] ??
            map['h_score'],
      );

      final f = _toDoubleValue(
        map['f'] ??
            map['fn'] ??
            map['f(n)'] ??
            map['fScore'] ??
            map['f_score'],
      );

      rows.add(
        FirebaseRouteTableRow(
          node: nodeId,
          g: g,
          h: h,
          f: f,
          status: '${map['status'] ?? _defaultStatusFromNode(nodeId)}',
        ),
      );
    }

    return rows;
  }

  // ==========================================
  // FORMAT 2:
  // astarSteps: {
  //   tps: { g: 0, h: 2, f: 2 },
  //   s0:  { g: 1, h: 2, f: 3 }
  // }
  // ==========================================
  if (rawTable is Map) {
    final map = Map<String, dynamic>.from(rawTable);

    // Kalau ada rows di dalamnya
    if (map['rows'] is Map || map['rows'] is List) {
      return _buildTableRowsFromFirebase(
        tps: {
          'table': map['rows'],
        },
        route: route,
        fullBin: fullBin,
      );
    }

    // Kalau ada astarSteps di dalam astarDebug
    if (map['astarSteps'] is Map || map['astarSteps'] is List) {
      return _buildTableRowsFromFirebase(
        tps: {
          'table': map['astarSteps'],
        },
        route: route,
        fullBin: fullBin,
      );
    }

    // Kalau formatnya gScore/hScore/fScore berupa map
    if (map['gScore'] is Map || map['gScores'] is Map) {
      final gMap = Map<String, dynamic>.from(
        (map['gScore'] ?? map['gScores']) as Map,
      );

      final hMap = map['hScore'] is Map || map['hScores'] is Map
          ? Map<String, dynamic>.from((map['hScore'] ?? map['hScores']) as Map)
          : <String, dynamic>{};

      final fMap = map['fScore'] is Map || map['fScores'] is Map
          ? Map<String, dynamic>.from((map['fScore'] ?? map['fScores']) as Map)
          : <String, dynamic>{};

      for (final nodeId in route) {
        rows.add(
          FirebaseRouteTableRow(
            node: nodeId,
            g: _toDoubleValue(gMap[nodeId]),
            h: _toDoubleValue(hMap[nodeId]),
            f: _toDoubleValue(fMap[nodeId]),
            status: _defaultStatusFromNode(nodeId),
          ),
        );
      }

      return rows;
    }

    final entries = map.entries.toList();

    entries.sort((a, b) {
      final ai = int.tryParse('${a.key}');
      final bi = int.tryParse('${b.key}');

      if (ai != null && bi != null) {
        return ai.compareTo(bi);
      }

      final ar = route.indexOf('${a.key}'.toLowerCase());
      final br = route.indexOf('${b.key}'.toLowerCase());

      if (ar != -1 && br != -1) {
        return ar.compareTo(br);
      }

      return '${a.key}'.compareTo('${b.key}');
    });

    for (int i = 0; i < entries.length; i++) {
      final key = '${entries[i].key}'.trim().toLowerCase();
      final value = entries[i].value;

      if (value is! Map) continue;

      final item = Map<String, dynamic>.from(value);

      final nodeId = '${item['node'] ?? item['id'] ?? item['current'] ?? key}'
          .trim()
          .toLowerCase();

      rows.add(
        FirebaseRouteTableRow(
          node: nodeId,
          g: _toDoubleValue(
            item['g'] ??
                item['gn'] ??
                item['g(n)'] ??
                item['gScore'] ??
                item['g_score'],
          ),
          h: _toDoubleValue(
            item['h'] ??
                item['hn'] ??
                item['h(n)'] ??
                item['hScore'] ??
                item['h_score'],
          ),
          f: _toDoubleValue(
            item['f'] ??
                item['fn'] ??
                item['f(n)'] ??
                item['fScore'] ??
                item['f_score'],
          ),
          status: '${item['status'] ?? _defaultStatusFromNode(nodeId)}',
        ),
      );
    }

    return rows;
  }

  return [];
}
static List<FirebaseRouteTableRow> _buildTableRowsFromFirebaseDebug(
  Map<String, dynamic> tps,
  List<String> route,
) {
  final rawDebug =
      tps['astarDebug'] ?? tps['debug'] ?? tps['astarSteps'];

  if (route.isEmpty) {
    return [];
  }

  final debugItems = <Map<String, dynamic>>[];

  double? readDoubleOrNull(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toDouble();
    return double.tryParse('$value');
  }

  String clean(String value) {
    return value.trim().toLowerCase().replaceAll('-', '');
  }

  int compareKeys(dynamic a, dynamic b) {
    final ai = int.tryParse('$a');
    final bi = int.tryParse('$b');

    if (ai != null && bi != null) {
      return ai.compareTo(bi);
    }

    return '$a'.compareTo('$b');
  }

  void collectDebugItems(dynamic value) {
    if (value == null) return;

    if (value is List) {
      for (final item in value) {
        collectDebugItems(item);
      }
      return;
    }

    if (value is Map) {
      final map = Map<String, dynamic>.from(value);

      final hasDebugValue =
          map.containsKey('from') &&
          map.containsKey('to') &&
          (map.containsKey('g') ||
              map.containsKey('h') ||
              map.containsKey('f'));

      if (hasDebugValue) {
        debugItems.add(map);
        return;
      }

      final entries = map.entries.toList()
        ..sort((a, b) => compareKeys(a.key, b.key));

      for (final entry in entries) {
        collectDebugItems(entry.value);
      }
    }
  }

  collectDebugItems(rawDebug);

  final usedDebugIndexes = <int>{};

  Map<String, dynamic>? findDebugForStep({
    required String fromNode,
    required String toNode,
  }) {
    final cleanFromNode = clean(fromNode);
    final cleanToNode = clean(toNode);

    // Prioritas 1: harus sama persis from -> to
    for (int i = 0; i < debugItems.length; i++) {
      if (usedDebugIndexes.contains(i)) continue;

      final item = debugItems[i];
      final from = clean('${item['from'] ?? ''}');
      final to = clean('${item['to'] ?? ''}');

      if (from == cleanFromNode && to == cleanToNode) {
        usedDebugIndexes.add(i);
        return item;
      }
    }

    // Prioritas 2: kalau pasangan from -> to tidak ada,
    // ambil berdasarkan node tujuan saja.
    // Ini tetap dari Firebase, bukan hitungan manual.
    for (int i = 0; i < debugItems.length; i++) {
      if (usedDebugIndexes.contains(i)) continue;

      final item = debugItems[i];
      final to = clean('${item['to'] ?? ''}');

      if (to == cleanToNode) {
        usedDebugIndexes.add(i);
        return item;
      }
    }

    return null;
  }

  final rows = <FirebaseRouteTableRow>[];

  for (int i = 0; i < route.length; i++) {
    final nodeName = clean(route[i]);

    double? g;
    double? h;
    double? f;

    if (i == 0) {
      g = 0.0;
      h = 0.0;
      f = 0.0;
    } else {
      final debug = findDebugForStep(
        fromNode: route[i - 1],
        toNode: route[i],
      );

      if (debug != null) {
        g = readDoubleOrNull(debug['g']);
        h = readDoubleOrNull(debug['h']);
        f = readDoubleOrNull(debug['f']);
      } else {
        g = null;
        h = null;
        f = null;
      }
    }

    String status = 'Node Aktif';

    if (nodeName.contains('tps')) {
      status = 'Depot';
    } else if (nodeName.startsWith('bin')) {
      status = 'Tujuan';
    } else {
      status = 'Node Aktif';
    }

    rows.add(
      FirebaseRouteTableRow(
        node: nodeName,
        g: g,
        h: h,
        f: f,
        status: status,
      ),
    );
  }

  return rows;
}
}

class DashboardDesktopPage extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final VoidCallback onLogout;

  const DashboardDesktopPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.onLogout,
  });

  @override
  State<DashboardDesktopPage> createState() => _DashboardDesktopPageState();
}

class _DashboardDesktopPageState extends State<DashboardDesktopPage> {
  SidebarMenu _selectedMenu = SidebarMenu.dashboard;
  FirebaseRouteData _firebaseRouteData = FirebaseRouteData.empty();
  final AudioPlayer _alertPlayer = AudioPlayer();
  final Set<String> _alreadyNotifiedBins = {};
  final List<RiwayatPengambilan> _riwayat = [];
  final List<AktivitasBinItem> _aktivitasBin = [];
  final List<NotifikasiItem> _notifikasi = [];
  int _unreadNotificationCount = 0;
  bool _bin1WasFull = false;
bool _bin2WasFull = false;
bool _bin3WasFull = false;
  late final DateTime _trendStartDate;
  final databaseRef =
  FirebaseDatabase.instance.ref("smartbin");
    Timer? _firebaseTimer;

List<SmartBinNode> _bins = [
  SmartBinNode(
    id: 'BIN-1',
    name: 'BIN-1 (KOST MAYA)',
    position: latlng.LatLng(-7.4306973, 109.2498555),
    fillPercent: 0,
    googleMapsPlaceUrl: 'https://maps.app.goo.gl/hPVnYQWfBvBioYsz8',
    imagePath: 'assets/images/bin1.JPEG',

      imgDepan: 'assets/images/bin1_depan.jpg',
      imgKanan: 'assets/images/bin1_kanan.jpg',
      imgKiri: 'assets/images/bin1_kiri.jpg',
      imgAtas: 'assets/images/bin1_atas.jpg',
  ),
  const SmartBinNode(
    id: 'BIN-2',
    name: 'BIN-2 (KOST AI)',
    position: latlng.LatLng(-7.4391365, 109.2675827),
    fillPercent: 0,
    googleMapsPlaceUrl: 'https://maps.app.goo.gl/XaDmHjJRmWEBP7gw9',
    imagePath: 'assets/images/bin2.JPEG',

    imgDepan: 'assets/images/bin2_depan.jpg',
    imgKanan: 'assets/images/bin2_kanan.jpg',
    imgKiri: 'assets/images/bin2_kiri.jpg',
    imgAtas: 'assets/images/bin2_atas.jpg',
  ),
  const SmartBinNode(
    id: 'BIN-3',
    name: 'BIN-3 (KOST ZIDAN)',
    position: latlng.LatLng(-7.4254058, 109.2456986),
    fillPercent: 0,
    googleMapsPlaceUrl: 'https://maps.app.goo.gl/ycwG2MsXyF7aWwBi8',
    imagePath: 'assets/images/bin3.JPEG',

    imgDepan: 'assets/images/bin3_depan.jpg',
    imgKanan: 'assets/images/bin3_kanan.jpg',
    imgKiri: 'assets/images/bin3_kiri.jpg',
    imgAtas: 'assets/images/bin3_atas.jpg',
  ),
];
void _playAlert() async {
  await _alertPlayer.play(AssetSource('sounds/alert.mp3'));
}
void _tambahAktivitas(AktivitasBinItem item) {
  _aktivitasBin.insert(0, item);

  if (_aktivitasBin.length > 5) {
    _aktivitasBin.removeRange(5, _aktivitasBin.length);
  }
}
void _showPopupNotification(
  String title,
  String message,
) {
  showSimpleNotification(
    Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 12,
      ),
      child: Row(
        children: [
          const Icon(
            Icons.delete_forever,
            color: Colors.white,
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  message,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    background: Colors.redAccent,
    duration: const Duration(seconds: 4),
position: NotificationPosition.top,
  );
}

void _updateBinPercent(int index, double value) {

  final double newValue =
      value.clamp(0, 100).roundToDouble();

  final SmartBinNode oldBin = _bins[index];

  final bool nowFull = newValue >= 92;

  setState(() {

    _bins[index] = oldBin.copyWith(
      fillPercent: newValue,
    );

    // ===============================
    // AKTIVITAS
    // ===============================
    _tambahAktivitas(
      AktivitasBinItem(
        title:
            '${oldBin.id} Level ${newValue.toStringAsFixed(0)}%',
        subtitle: nowFull
            ? 'Masuk kategori penuh'
            : newValue >= 50
                ? 'Masuk kategori hampir penuh'
                : 'Kondisi aman',
        waktu: DateTime.now(),
        color: nowFull
            ? AppC.red
            : newValue >= 50
                ? AppC.yellow
                : AppC.green,
        icon: nowFull
            ? Icons.warning_rounded
            : Icons.check_circle_rounded,
      ),
    );

    // ===============================
    // NOTIFIKASI
    // ===============================
    if (nowFull &&
        !_alreadyNotifiedBins.contains(oldBin.id)) {

      debugPrint(
          "NOTIFIKASI BARU: ${oldBin.id}");

      _notifikasi.insert(
        0,
        NotifikasiItem(
          namaBin: oldBin.name,
          persentase: newValue,
          waktu: DateTime.now(),
          pesan:
              'Tempat sampah penuh dan siap untuk pengambilan.',
        ),
      );

      // BADGE
      if (_selectedMenu != SidebarMenu.notifikasi) {
        _unreadNotificationCount++;
      }

      // SUARA
      _playAlert();

      // SIMPAN STATUS
      _alreadyNotifiedBins.add(oldBin.id);
    }

    // ===============================
    // RESET STATUS
    // ===============================
    if (!nowFull) {
      _alreadyNotifiedBins.remove(oldBin.id);
    }
  });
}
void _selesaikanPengambilan(RouteResult routeResult) {
  final fullBins = _bins.where((bin) => bin.isFull).toList();

  if (fullBins.isEmpty) return;

  final waktuPengambilan = DateTime.now();

  setState(() {
    for (final bin in fullBins) {
      _riwayat.insert(
        0,
        RiwayatPengambilan(
          namaBin: bin.name,
          waktu: waktuPengambilan,
          jarakKm: routeResult.totalDistanceKm,
          status: 'Selesai',
        ),
      );
    }
    _tambahAktivitas(
  AktivitasBinItem(
    title: 'Rute Pengambilan Selesai',
    subtitle: '${fullBins.length} bin berhasil dikosongkan',
    waktu: DateTime.now(),
    color: AppC.blue,
    icon: Icons.location_on_rounded,
  ),
);

    _bins = _bins.map((bin) {
      if (bin.isFull) {
        return bin.copyWith(fillPercent: 0);
      }
      return bin;
    }).toList();
  });
}
@override
void dispose() {
  _firebaseTimer?.cancel();
  _alertPlayer.dispose();
  super.dispose();
}
Widget _buildPage() {
  switch (_selectedMenu) {
    case SidebarMenu.dashboard:
      return MainDashboardContent(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
        bins: _bins,
        onBinChanged: _updateBinPercent,
        unreadNotificationCount: _unreadNotificationCount,
        riwayat: _riwayat,
        aktivitasBin: _aktivitasBin,
        trendStartDate: _trendStartDate,
        firebaseRouteData: _firebaseRouteData
      );

    case SidebarMenu.petaRute:
      return PetaRutePage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
        bins: _bins,
        firebaseRouteData: _firebaseRouteData,
        onSelesaiPengambilan: _selesaikanPengambilan,
        unreadNotificationCount: _unreadNotificationCount,
      );

case SidebarMenu.tempatSampah:
  return TempatSampahPage(
    isDarkMode: widget.isDarkMode,
    onThemeChanged: widget.onThemeChanged,
    bins: _bins,
    onBinChanged: _updateBinPercent,
    unreadNotificationCount: _unreadNotificationCount,
  );

    case SidebarMenu.riwayat:
      return RiwayatPage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
        riwayat: _riwayat,
        unreadNotificationCount: _unreadNotificationCount,
      );

    case SidebarMenu.notifikasi:
      return NotifikasiPage(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
        notifikasi: _notifikasi,
        unreadNotificationCount: _unreadNotificationCount,
      );

case SidebarMenu.pengaturanSistem:
  return PengaturanSistemPage(
    isDarkMode: widget.isDarkMode,
    onThemeChanged: widget.onThemeChanged,
  );
    }
}
@override
void initState() {
  super.initState();

  _trendStartDate = DateTime.now();

  _firebaseTimer = Timer.periodic(
    const Duration(seconds: 2),
    (_) async {
      final url = Uri.parse(
        'https://percobaan-tup3-default-rtdb.asia-southeast1.firebasedatabase.app/.json',
      );

      final response = await http.get(url);

      if (response.statusCode == 200 && response.body != 'null') {
        final rootData = Map<String, dynamic>.from(
          jsonDecode(response.body),
        );

        final smartbinData = rootData['smartbin'] is Map
            ? Map<String, dynamic>.from(rootData['smartbin'])
            : rootData;

        final firebaseRouteData = FirebaseRouteData.fromFirebase(
          rootData: rootData,
          bins: _bins,
        );

        final persen1 = double.tryParse(
              smartbinData['bin1']['percent'].toString(),
            ) ??
            0;

        final persen2 = double.tryParse(
              smartbinData['bin2']['percent'].toString(),
            ) ??
            0;

        final persen3 = double.tryParse(
              smartbinData['bin3']['percent'].toString(),
            ) ??
            0;

        debugPrint('ROOT KEYS = ${rootData.keys.toList()}');
        debugPrint('SMARTBIN KEYS = ${smartbinData.keys.toList()}');
        debugPrint('ROUTE FIREBASE = ${firebaseRouteData.route}');

        print("BIN1 = $persen1");
        print("BIN2 = $persen2");
        print("BIN3 = $persen3");

        _updateBinPercent(0, persen1);
        _updateBinPercent(1, persen2);
        _updateBinPercent(2, persen3);

        setState(() {
          _firebaseRouteData = firebaseRouteData;
        });

        // =========================
        // NOTIFIKASI BIN PENUH
        // =========================

        if (persen1 >= 92 && !_bin1WasFull) {
          _bin1WasFull = true;

          _showFullNotification(
            "⚠ BIN-1 sudah penuh!",
            "Segera lakukan pengangkutan untuk menjaga kebersihan lingkungan",
          );
        }

        if (persen1 < 92) {
          _bin1WasFull = false;
        }

        if (persen2 >= 92 && !_bin2WasFull) {
          _bin2WasFull = true;

          _showFullNotification(
            "⚠ BIN-2 sudah penuh!",
            "Segera lakukan pengangkutan untuk menjaga kebersihan lingkungan",
          );
        }

        if (persen2 < 92) {
          _bin2WasFull = false;
        }

        if (persen3 >= 92 && !_bin3WasFull) {
          _bin3WasFull = true;

          _showFullNotification(
            "⚠ BIN-3 sudah penuh!",
            "Segera lakukan pengangkutan untuk menjaga kebersihan lingkungan",
          );
        }

        if (persen3 < 92) {
          _bin3WasFull = false;
        }
      }
    },
  );
}
void _showFullNotification(
  String title,
  String subtitle,
) {
  final overlay = Overlay.of(context);

  late OverlayEntry overlayEntry;

  final animationController = AnimationController(
    vsync: Navigator.of(context),
    duration: const Duration(milliseconds: 450),
  );

  final animation = CurvedAnimation(
    parent: animationController,
    curve: Curves.easeOutQuart,
  );

  overlayEntry = OverlayEntry(
    builder: (context) {
      return Positioned(
        top: 22,
        right: 28,

        child: FadeTransition(
          opacity: animation,

          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, -0.08),
              end: Offset.zero,
            ).animate(animation),

            child: Material(
              color: Colors.transparent,

              child: GestureDetector(
                onTap: () {
                  overlayEntry.remove();

                  setState(() {
                    _selectedMenu =
                        SidebarMenu.notifikasi;
                  });
                },

                child: ClipRRect(
                  borderRadius:
                      BorderRadius.circular(24),

                  child: BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 18,
                      sigmaY: 18,
                    ),

                    child: Container(
                      width: 500,
                      height: 96,

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                      ),

                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.circular(24),

                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,

                          colors: [

                            const Color(0xFF111827)
                                .withOpacity(0.86),

                            const Color(0xFF0B1220)
                                .withOpacity(0.76),
                          ],
                        ),

                        border: Border.all(
                          color: const Color(0xFFFFD66B)
                              .withOpacity(0.14),
                        ),

                        boxShadow: [

                          /// glow kuning soft
                          BoxShadow(
                            color:
                                const Color(0xFFFFD66B)
                                    .withOpacity(0.08),

                            blurRadius: 30,
                            spreadRadius: 1,
                          ),

                          /// shadow bawah
                          BoxShadow(
                            color:
                                Colors.black.withOpacity(
                              0.28,
                            ),

                            blurRadius: 28,
                            offset:
                                const Offset(0, 14),
                          ),
                        ],
                      ),

                      child: Row(
                        children: [

                          /// ICON
                          Container(
                            width: 48,
                            height: 48,

                            decoration: BoxDecoration(
                              shape: BoxShape.circle,

                              gradient: LinearGradient(
                                colors: [

                                  const Color(
                                    0xFFFFD66B,
                                  ).withOpacity(0.18),

                                  const Color(
                                    0xFFFFB547,
                                  ).withOpacity(0.05),
                                ],
                              ),

                              border: Border.all(
                                color:
                                    const Color(
                                      0xFFFFD66B,
                                    ).withOpacity(0.24),
                              ),
                            ),

                            child: const Icon(
                              Icons.warning_amber_rounded,

                              color:
                                  Color(0xFFFFD66B),

                              size: 24,
                            ),
                          ),

                          const SizedBox(width: 16),

                          /// TEXT
                          Expanded(
                            child: Column(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,

                              crossAxisAlignment:
                                  CrossAxisAlignment
                                      .start,

                              children: [

                                Text(
                                  title,

                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,

                                    fontSize: 15.5,

                                    fontWeight:
                                        FontWeight
                                            .w800,
                                  ),
                                ),

                                const SizedBox(
                                    height: 5),

                                Text(
                                  subtitle,

                                  maxLines: 2,

                                  overflow:
                                      TextOverflow
                                          .ellipsis,

                                  style: TextStyle(
                                    color: Colors
                                        .white
                                        .withOpacity(
                                            0.68),

                                    fontSize: 12.5,

                                    height: 1.4,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 16),

                          /// BUTTON
                          Container(
                            padding:
                                const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 9,
                            ),

                            decoration: BoxDecoration(
                              color: const Color(
                                0xFFFFD66B,
                              ).withOpacity(0.10),

                              borderRadius:
                                  BorderRadius.circular(
                                      999),

                              border: Border.all(
                                color: const Color(
                                  0xFFFFD66B,
                                ).withOpacity(0.10),
                              ),
                            ),

                            child: Row(
                              children: [

                                Text(
                                  "Lihat",

                                  style: TextStyle(
                                    color:
                                        const Color(
                                      0xFFFFD66B,
                                    ),

                                    fontSize: 12,

                                    fontWeight:
                                        FontWeight
                                            .w700,
                                  ),
                                ),

                                const SizedBox(
                                    width: 4),

                                const Icon(
                                  Icons
                                      .chevron_right_rounded,

                                  color: Color(
                                    0xFFFFD66B,
                                  ),

                                  size: 17,
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(width: 8),

                          /// CLOSE
                          InkWell(
                            borderRadius:
                                BorderRadius.circular(
                                    999),

                            onTap: () {
                              overlayEntry.remove();
                            },

                            child: Padding(
                              padding:
                                  const EdgeInsets.all(
                                      5),

                              child: Icon(
                                Icons.close_rounded,

                                color: Colors.white
                                    .withOpacity(0.34),

                                size: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    },
  );

  overlay.insert(overlayEntry);

  animationController.forward();

  Future.delayed(
    const Duration(seconds: 4),
    () async {

      await animationController.reverse();

      if (overlayEntry.mounted) {
        overlayEntry.remove();
      }

      animationController.dispose();
    },
  );
}

@override
Widget build(BuildContext context) {
  int currentIndex = 0;

  if (_selectedMenu == SidebarMenu.dashboard) {
    currentIndex = 0;
  } else if (_selectedMenu == SidebarMenu.petaRute) {
    currentIndex = 1;
  } else if (_selectedMenu == SidebarMenu.riwayat) {
    currentIndex = 2;
  } else if (_selectedMenu == SidebarMenu.notifikasi) {
    currentIndex = 3;
  }

  return Scaffold(
    backgroundColor: AppC.scaffold(context),

body: SafeArea(
  child: _buildPage(),
),    
bottomNavigationBar: SafeArea(
      child: Container(
        margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        decoration: BoxDecoration(
          color: AppC.panelBg(context),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AppC.borderColor(context),
          ),
          boxShadow: AppC.panelShadow(context),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            backgroundColor: AppC.panelBg(context),
            elevation: 0,
            selectedItemColor: AppC.blue,
            unselectedItemColor: AppC.subColor(context),
            showUnselectedLabels: true,

            selectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 11,
            ),

            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 10,
            ),

            onTap: (index) {
              setState(() {
                if (index == 0) {
                  _selectedMenu = SidebarMenu.dashboard;
                } else if (index == 1) {
                  _selectedMenu = SidebarMenu.petaRute;
                } else if (index == 2) {
                  _selectedMenu = SidebarMenu.riwayat;
                } else if (index == 3) {
                  _selectedMenu = SidebarMenu.notifikasi;
                  _unreadNotificationCount = 0;
                }
              });
            },

            items: [
              const BottomNavigationBarItem(
                icon: Icon(Icons.dashboard_rounded),
                label: 'Dashboard',
              ),

              const BottomNavigationBarItem(
                icon: Icon(Icons.map_rounded),
                label: 'Peta Rute',
              ),

              const BottomNavigationBarItem(
                icon: Icon(Icons.history_rounded),
                label: 'Riwayat',
              ),

              BottomNavigationBarItem(
                icon: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.notifications_none_rounded),

                    if (_unreadNotificationCount > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: const BoxDecoration(
                            color: AppC.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                  ],
                ),
                label: 'Notifikasi',
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}
void showBinImages(BuildContext context, SmartBinNode bin) {
  showDialog(
    context: context,
    builder: (_) {
      return Dialog(
        insetPadding: const EdgeInsets.all(40),
        backgroundColor: Colors.transparent,
        child: Center(
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppC.panelBg(context),
              borderRadius: BorderRadius.circular(20),
            ),

            // 🔥 FIX UTAMA ADA DI SINI
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Text(
                    'Detail ${bin.id}',
                    style: TextStyle(
                      color: AppC.textColor(context),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 12),

                  GridView(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1,
                    ),
                    children: [
                      _imgItem(bin.imgDepan, 'Depan'),
                      _imgItem(bin.imgKanan, 'Kanan'),
                      _imgItem(bin.imgKiri, 'Kiri'),
                      _imgItem(bin.imgAtas, 'Atas'),
                    ],
                  ),

                  const SizedBox(height: 10),

                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Tutup'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}
Widget _imgItem(String path, String title) {
  return Column(
    children: [
      Expanded(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.asset(
              path,
              width: double.infinity,
              fit: BoxFit.cover, // 🔥 WAJIB biar full & rapi
            ),
          ),
        ),
      ),
      const SizedBox(height: 6),
      Text(
        title,
        style: const TextStyle(fontSize: 12),
      ),
    ],
  );
}

class _MenuPlaceholderPage extends StatelessWidget { //Blok kode ini digunakan untuk membuat halaman placeholder atau halaman sementara pada menu dashboard. Halaman ini biasanya digunakan ketika sebuah menu belum memiliki isi atau fitur lengkap, sehingga sistem hanya menampilkan nama halaman sesuai menu yang dipilih.
  final String title;

  const _MenuPlaceholderPage({
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppC.pageBg(context),
      ),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          decoration: BoxDecoration(
            color: AppC.panelBg(context),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppC.borderColor(context)),
            boxShadow: AppC.panelShadow(context),
          ),
          child: Text(
            '$title Page',
            style: TextStyle(
              color: AppC.textColor(context),
              fontSize: 26,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
      ),
    );
  }
}

class LeftSidebar extends StatelessWidget {
  final SidebarMenu selectedMenu;
  final int unreadNotificationCount;
  final ValueChanged<SidebarMenu> onMenuSelected;
  final VoidCallback onLogout;

  const LeftSidebar({
    super.key,
    required this.selectedMenu,
    required this.unreadNotificationCount,
    required this.onMenuSelected,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppC.isDark(context)
            ? null
            : const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF2E5F9F),
                  Color(0xFF4A89D8),
                ],
              ),
        color: AppC.isDark(context) ? const Color(0xFF081321) : null,
        border: Border(
          right: BorderSide(
            color: AppC.isDark(context)
                ? Colors.white.withOpacity(0.05)
                : const Color(0xFFD7E2F0),
            width: 1.2,
          ),
        ),
        boxShadow: AppC.isDark(context)
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.08),
                  blurRadius: 30,
                  spreadRadius: 2,
                ),
              ]
            : [
                BoxShadow(
                  color: const Color(0xFFB8C7DB).withOpacity(0.38),
                  blurRadius: 24,
                  offset: const Offset(4, 0),
                ),
              ],
      ),
      child: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 22, 18, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const _BrandHeader(),
                      const SizedBox(height: 28),

                      _SidebarMenuTile(
                        icon: Icons.dashboard_rounded,
                        label: 'Dashboard',
                        isActive: selectedMenu == SidebarMenu.dashboard,
                        onTap: () => onMenuSelected(SidebarMenu.dashboard),
                      ),

                      const SizedBox(height: 22),
                      const _SidebarSectionLabel('MAIN MENU'),
                      const SizedBox(height: 12),

                      _SidebarMenuTile(
                        icon: Icons.map_outlined,
                        label: 'Peta & Rute',
                        isActive: selectedMenu == SidebarMenu.petaRute,
                        onTap: () => onMenuSelected(SidebarMenu.petaRute),
                      ),
                      _SidebarMenuTile(
                        icon: Icons.delete_outline_rounded,
                        label: 'Tempat Sampah',
                        isActive: selectedMenu == SidebarMenu.tempatSampah,
                        onTap: () => onMenuSelected(SidebarMenu.tempatSampah),
                      ),
                      _SidebarMenuTile(
                        icon: Icons.history_rounded,
                        label: 'Riwayat',
                        isActive: selectedMenu == SidebarMenu.riwayat,
                        onTap: () => onMenuSelected(SidebarMenu.riwayat),
                      ),
                      _SidebarMenuTile(
                        icon: Icons.notifications_none_rounded,
                        label: 'Notifikasi',
                        isActive: selectedMenu == SidebarMenu.notifikasi,
                        trailing: unreadNotificationCount > 0
                            ? Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: AppC.red,
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  unreadNotificationCount > 99
                                      ? '99+'
                                      : unreadNotificationCount.toString(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              )
                            : null,
                        onTap: () => onMenuSelected(SidebarMenu.notifikasi),
                      ),

                      const SizedBox(height: 10),
                      const _SidebarSectionLabel('PERANGKAT'),
                      const SizedBox(height: 12),

                      _SidebarMenuTile(
                        icon: Icons.settings_outlined,
                        label: 'Pengaturan Sistem',
                        isActive: selectedMenu == SidebarMenu.pengaturanSistem,
                        onTap: () =>
                            onMenuSelected(SidebarMenu.pengaturanSistem),
                      ),

                      const SizedBox(height: 24),
                      _StatusConnectionCard(),
                      const SizedBox(height: 10),
                      _AdminProfileCard(
                        onLogout: onLogout,
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BrandHeader extends StatelessWidget {
  const _BrandHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppC.blue, Color(0xFF53B0FF)],
            ),
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: AppC.blue.withOpacity(0.35),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.shield_outlined, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
  'Smart Bin',
  style: TextStyle(
    color: AppC.isDark(context) ? AppC.textColor(context) : Colors.white,
    fontSize: 18,
    fontWeight: FontWeight.w900,
  ),
),
              const SizedBox(height: 2),
              Text(
  'IoT Waste Management',
  style: TextStyle(
    color: AppC.isDark(context) ? AppC.subColor(context) : Colors.white,
    fontSize: 12.5,
    fontWeight: FontWeight.w700,
  ),
),
            ],
          ),
        ),
        Text(
          '=',
          style: TextStyle(
            color: AppC.isDark(context)
                ? Colors.white70
                : AppC.textColor(context),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _SidebarSectionLabel extends StatelessWidget {
  final String text;
  const _SidebarSectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: AppC.mutedColor(context),
        fontSize: 12,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.7,
      ),
    );
  }
}

class _SidebarMenuTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isActive;
  final Widget? trailing;
  final VoidCallback onTap;
  

const _SidebarMenuTile({
  required this.icon,
  required this.label,
  required this.isActive,
  required this.onTap,
  this.trailing,
});

  @override
  Widget build(BuildContext context) {
    final isDark = AppC.isDark(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            gradient: isActive
                ? const LinearGradient(
                    colors: [AppC.blue, Color(0xFF4667FF)],
                  )
                : null,
            color: isActive
                ? null
                : (isDark ? AppC.panelBg(context) : Colors.transparent),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isActive
                  ? Colors.transparent
                  : (isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.35)),
              width: 1.2,
            ),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppC.blue.withOpacity(0.28),
                      blurRadius: 18,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : null,
          ),
child: Row(
  children: [
    const SizedBox(width: 16),

    Icon(
      icon,
      color: isActive
          ? Colors.white
          : (isDark
              ? const Color(0xFFD7E1F3)
              : const Color(0xFF24406A)),
      size: 22,
    ),

    const SizedBox(width: 12),

    Expanded(
      child: Text(
        label,
        style: TextStyle(
          color: isActive
              ? Colors.white
              : (isDark ? AppC.textColor(context) : Colors.white),
          fontSize: 15,
          fontWeight: isActive ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    ),

    if (trailing != null) ...[
      trailing!,
      const SizedBox(width: 14),
    ],
  ],
),
        ),
      ),
    );
  }
}


 class _StatusConnectionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 230,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
  color: AppC.isDark(context)
      ? AppC.panel
      : Colors.white,
  borderRadius: BorderRadius.circular(18),
  border: Border.all(
    color: AppC.isDark(context)
        ? Colors.white.withOpacity(0.05)
        : const Color(0xFFD7E2F0),
    width: 1.2,
  ),
  boxShadow: AppC.isDark(context)
      ? null
      : [
          AppC.strongLightShadow(),
        ],
),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: AppC.green.withOpacity(0.14),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.wifi_tethering_rounded,
              color: AppC.green,
              size: 30,
            ),
          ),
          const SizedBox(height: 16),
          Text(
  'Sistem Terhubung',
  style: TextStyle(
    color: AppC.isDark(context) ? AppC.text : Colors.black,
    fontWeight: FontWeight.w900,
    fontSize: 20,
  ),
),
          const SizedBox(height: 6),
          const Text(
            '3 / 3 Perangkat Online',
            style: TextStyle(
              color: AppC.green,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 8,
              value: 32 / 35,
              backgroundColor: Colors.white.withOpacity(0.08),
              color: AppC.green,
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminProfileCard extends StatelessWidget {
  final VoidCallback onLogout;

  const _AdminProfileCard({
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 86,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppC.isDark(context) ? AppC.panel : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppC.isDark(context)
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFD7E2F0),
          width: 1.2,
        ),
        boxShadow: AppC.isDark(context)
            ? null
            : [
                AppC.strongLightShadow(),
              ],
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 22,
            backgroundColor: Color(0xFF2B3A51),
            child: Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin',
                  style: TextStyle(
                    color: AppC.textColor(context),
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Smart City',
                  style: TextStyle(color: AppC.subColor(context)),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onLogout,
            icon: Icon(
              Icons.logout_rounded,
              color: AppC.isDark(context)
                  ? Colors.white70
                  : AppC.subColor(context),
            ),
          ),
        ],
      ),
    );
  }
}

class MainDashboardContent extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final List<SmartBinNode> bins;
  final void Function(int index, double value) onBinChanged;
  final int unreadNotificationCount;
  final List<RiwayatPengambilan> riwayat;
  final List<AktivitasBinItem> aktivitasBin;
  final DateTime trendStartDate;
  final FirebaseRouteData firebaseRouteData;

  const MainDashboardContent({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.bins,
    required this.onBinChanged,
    required this.unreadNotificationCount,
    required this.riwayat,
    required this.aktivitasBin,
    required this.trendStartDate,
     required this.firebaseRouteData,
  });

@override
Widget build(BuildContext context) {
  final isDark = AppC.isDark(context);
  final bool isHp = MediaQuery.of(context).size.width < 700;

Widget wideContent({
  required Widget child,
  double width = 850,
}) {
  if (!isHp) {
    return child;
  }

  return SizedBox(
    width: double.infinity,
    child: FittedBox(
      fit: BoxFit.scaleDown,
      alignment: Alignment.topLeft,
      child: SizedBox(
        width: width,
        child: child,
      ),
    ),
  );
}

  return Container(
    decoration: BoxDecoration(
      gradient: AppC.pageBg(context),
    ),
    child: Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            isHp ? 18 : 24,
            isHp ? 18 : 22,
            isHp ? 18 : 24,
            isHp ? 14 : 18,
          ),
          decoration: BoxDecoration(
            gradient: AppC.topHeaderBg(context),
            boxShadow: isDark
                ? null
                : [
                    BoxShadow(
                      color: const Color(0xFFB8C7DB).withOpacity(0.28),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: TopBar(
            isDarkMode: isDarkMode,
            onThemeChanged: onThemeChanged,
            title: 'Dashboard',
            subtitle:
                'Pantau kondisi tempat sampah secara real-time dan optimalkan rute pengambilan',
            unreadNotificationCount: unreadNotificationCount,
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              isHp ? 18 : 24,
              isHp ? 16 : 18,
              isHp ? 18 : 24,
              isHp ? 90 : 22,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                wideContent(
                  child: StatsRow(
                    bins: bins,
                    onBinChanged: onBinChanged,
                  ),
                ),

                const SizedBox(height: 18),

                wideContent(
                  child: MainMapAndList(
                    bins: bins,
                  ),
                ),

                const SizedBox(height: 18),

                wideContent(
                  child: BottomPanelsRow(
                    bins: bins,
                    riwayat: riwayat,
                    aktivitasBin: aktivitasBin,
                    trendStartDate: trendStartDate,
                     firebaseRouteData: firebaseRouteData,
                  ),
                ),

                const SizedBox(height: 18),

wideContent(
  child: const SizedBox.shrink(),
),
              ],
            ),
          ),
        ),
      ],
    ),
  );
}
}
class PetaRutePage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final List<SmartBinNode> bins;
  final FirebaseRouteData firebaseRouteData;
  final void Function(RouteResult routeResult) onSelesaiPengambilan;
  final int unreadNotificationCount;

  const PetaRutePage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.bins,
    required this.firebaseRouteData,
    required this.onSelesaiPengambilan,
    required this.unreadNotificationCount,
  });

  @override
  Widget build(BuildContext context) {
final routePoints = firebaseRouteData.route
    .map((nodeId) => firebaseRouteData.nodes[nodeId])
    .whereType<FirebaseRouteNode>()
    .map((node) => node.position)
    .toList();

final orderedBins = bins.where((bin) {
  final binId = bin.id.toLowerCase().replaceAll('-', '');
  return firebaseRouteData.route.contains(binId);
}).toList();

final RouteResult routeResult = RouteResult(
  points: routePoints,
  orderedBins: orderedBins,
  totalDistanceKm: firebaseRouteData.distanceKm,
);final double firebaseDistance = firebaseRouteData.distanceKm;

final String distanceText = firebaseDistance > 0
    ? '${firebaseDistance.toStringAsFixed(2)} KM'
    : '-';

final String estimatedTimeText = '-';

final String exploredNodeText = firebaseRouteData.tableRows.isNotEmpty
    ? '${firebaseRouteData.tableRows.length}'
    : '-';

final String pointCountText = firebaseRouteData.route.isNotEmpty
    ? '${firebaseRouteData.route.length}'
    : '-';
    return DefaultTabController(
      length: 2,
      child: Container(
        decoration: BoxDecoration(
          gradient: AppC.pageBg(context),
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
              decoration: BoxDecoration(
                gradient: AppC.topHeaderBg(context),
              ),
              child: TopBar(
                isDarkMode: isDarkMode,
                onThemeChanged: onThemeChanged,
                title: 'Peta & Rute',
                subtitle:
                    'Rekomendasi rute pengambilan sampah berdasarkan algoritma A*',
                unreadNotificationCount: unreadNotificationCount,
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            'Rekomendasi Rute - Algoritma A*',
                            style: TextStyle(
                              color: AppC.textColor(context),
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),

                        _AStarTopMetricCard(
                          icon: Icons.route,
                          title: 'Jarak Total',
                          value: distanceText,
                        ),

                        const SizedBox(width: 12),

                        _AStarTopMetricCard(
                          icon: Icons.access_time_rounded,
                          title: 'Estimasi Waktu',
                          value: estimatedTimeText,
                        ),

                        const SizedBox(width: 12),

                        _AStarTopMetricCard(
                          icon: Icons.account_tree_outlined,
                          title: 'Node Dieksplorasi',
                          value: exploredNodeText,
                        ),

                        const SizedBox(width: 12),

                        _AStarTopMetricCard(
                          icon: Icons.location_on_outlined,
                          title: 'Jumlah Titik',
                          value: pointCountText,
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppC.panelBg(context),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppC.borderColor(context),
                        ),
                        boxShadow: AppC.panelShadow(context),
                      ),
                      child: const TabBar(
                        isScrollable: true,
                        dividerColor: Colors.transparent,
                        labelColor: AppC.blue,
                        unselectedLabelColor: AppC.sub,
                        indicatorColor: AppC.blue,
                        labelStyle: TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                        tabs: [
                          Tab(text: 'VISUALISASI RUTE'),
                          Tab(text: 'TABEL NODES'),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    Expanded(
                      child: TabBarView(
                        children: [
                          _AStarVisualTab(
                            bins: bins,
                            firebaseRouteData: firebaseRouteData,
                            routeResult: routeResult,
                            onSelesaiPengambilan:
                                onSelesaiPengambilan,
                          ),

                          _AStarNodesTab(
                            firebaseRouteData: firebaseRouteData,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _AStarVisualTab extends StatelessWidget {
  final List<SmartBinNode> bins;
  final FirebaseRouteData firebaseRouteData;
  final RouteResult routeResult;
  final void Function(RouteResult routeResult) onSelesaiPengambilan;

  const _AStarVisualTab({
    required this.bins,
    required this.firebaseRouteData,
    required this.routeResult,
    required this.onSelesaiPengambilan,
  });

@override
Widget build(BuildContext context) {
  return SingleChildScrollView(
    scrollDirection: Axis.vertical,
    child: SizedBox(
      height: 880, // tinggi total halaman, jadi bisa discroll
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // =========================
          // PANEL KIRI
          // =========================
          SizedBox(
            width: 220,
            child: SingleChildScrollView(
              child: Column(
                children: [
_RouteOrderPanel(
firebaseRouteData: firebaseRouteData,),
                  const SizedBox(height: 16),
                  SizedBox(
                    height: 300,
                    child: _LegendPanel(),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 16),

Expanded(
  child: SizedBox(
    height: 780,
    child: _GraphRoutePanel(
      bins: bins,
      firebaseRouteData: firebaseRouteData,
    ),
  ),
),
          const SizedBox(width: 16),

          // =========================
          // PANEL KANAN
          // =========================
          SizedBox(
            width: 285,
            child: SingleChildScrollView(
              child: Column(
                children: [
Container(
  width: double.infinity,
  padding: const EdgeInsets.all(16),
  decoration: _panelBox(context),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Informasi Rute Firebase',
        style: TextStyle(
          color: AppC.textColor(context),
          fontWeight: FontWeight.w800,
          fontSize: 18,
        ),
      ),
      const SizedBox(height: 14),
      Text(
        'Jarak: ${firebaseRouteData.distanceKm > 0 ? firebaseRouteData.distanceKm.toStringAsFixed(2) : '-'} KM',
        style: TextStyle(
          color: AppC.subColor(context),
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Jumlah Titik: ${firebaseRouteData.route.length}',
        style: TextStyle(
          color: AppC.subColor(context),
          fontWeight: FontWeight.w600,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        'Node Tabel: ${firebaseRouteData.tableRows.length}',
        style: TextStyle(
          color: AppC.subColor(context),
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  ),
),
                  const SizedBox(height: 16),

                  _RecommendationPanel(
                    routeResult: routeResult,
                    onSelesaiPengambilan: onSelesaiPengambilan,
                    bins: bins,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
  Widget _infoLine(String left, String right) {
    return Row(
      children: [
        Expanded(
          child: Text(
            left,
            style: const TextStyle(
              color: AppC.sub,
              fontSize: 13,
            ),
          ),
        ),
        Text(
          right,
          style: const TextStyle(
            color: AppC.text,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _dotLine(Color color, String label, String value) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(color: AppC.sub),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            color: AppC.text,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _AStarNodesTab extends StatelessWidget {
  final FirebaseRouteData firebaseRouteData;

  const _AStarNodesTab({
    required this.firebaseRouteData,
  });

  @override
  Widget build(BuildContext context) {
    final rows = firebaseRouteData.tableRows;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: _panelBox(context),
      child: rows.isEmpty
          ? Center(
              child: Text(
                'Tabel perhitungan dari route Firebase belum tersedia.',
                style: TextStyle(
                  color: AppC.subColor(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          : SingleChildScrollView(
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  AppC.isDark(context)
                      ? const Color(0xFF0B1730)
                      : const Color(0xFFF3F7FC),
                ),
                columns: [
                  _dt('Node', context),
                  _dt('g(n)', context),
                  _dt('h(n)', context),
                  _dt('f(n)', context),
                  _dt('Status', context),
                ],
                rows: rows.map((row) {
                  Color statusColor = AppC.green;

                  if (row.status.toLowerCase().contains('depot')) {
                    statusColor = AppC.blue;
                  } else if (row.status.toLowerCase().contains('tujuan')) {
                    statusColor = AppC.red;
                  }

                  return DataRow(
                    cells: [
                      DataCell(
                        Text(
                          row.node,
                          style: TextStyle(
                            color: AppC.textColor(context),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      DataCell(
                        Text(
                          row.g == null ? '-' : row.g!.toStringAsFixed(2),
                          style: TextStyle(color: AppC.textColor(context)),
                        ),
                      ),
                      DataCell(
                        Text(
                          row.h == null ? '-' : row.h!.toStringAsFixed(2),
                          style: TextStyle(color: AppC.textColor(context)),
                        ),
                      ),
                      DataCell(
                        Text(
                          row.f == null ? '-' : row.f!.toStringAsFixed(2),
                          style: TextStyle(color: AppC.textColor(context)),
                        ),
                      ),
                      DataCell(
                        Text(
                          row.status,
                          style: TextStyle(
                            color: statusColor,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
    );
  }

  DataColumn _dt(String text, BuildContext context) {
    return DataColumn(
      label: Text(
        text,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppC.textColor(context),
        ),
      ),
    );
  }
}
class _AStarTopMetricCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _AStarTopMetricCard({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 170,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: _panelBox(context),
      child: Row(
        children: [
          Icon(icon, color: AppC.blue, size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AppC.subColor(context),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    color: AppC.textColor(context),
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _RouteOrderPanel extends StatelessWidget {
  final FirebaseRouteData firebaseRouteData;

  const _RouteOrderPanel({
    required this.firebaseRouteData,
  });

  @override
  Widget build(BuildContext context) {
    final route = firebaseRouteData.route;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelBox(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Urutan Pengambilan (A*)',
            style: TextStyle(
              color: AppC.textColor(context),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 16),

          if (route.isEmpty)
            Text(
              'Route Firebase belum tersedia.',
              style: TextStyle(
                color: AppC.subColor(context),
                fontWeight: FontWeight.w600,
              ),
            ),

          ...List.generate(route.length, (index) {
            final nodeId = route[index];
            final node = firebaseRouteData.nodes[nodeId];

            Color color = AppC.green;

            if (node?.type == 'depot' || nodeId.toLowerCase().contains('tps')) {
              color = AppC.blue;
            } else if (node?.type == 'bin' || nodeId.toLowerCase().startsWith('bin')) {
              color = AppC.red;
            }

            return Padding(
              padding: EdgeInsets.only(
                bottom: index == route.length - 1 ? 0 : 10,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: color,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Text(
                      node?.label ?? nodeId,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppC.textColor(context),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),

          const SizedBox(height: 18),

          Center(
            child: Text(
              'Total Jarak: ${firebaseRouteData.distanceKm.toStringAsFixed(2)} KM',
              style: TextStyle(
                color: AppC.textColor(context),
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _LegendPanel extends StatelessWidget {
  const _LegendPanel();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelBox(context),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Legenda',
            style: TextStyle(
              color: AppC.text,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),

          SizedBox(height: 16),

          _LegendRow(
            color: AppC.blue,
            label: 'Depot / Pos Awal',
          ),

          SizedBox(height: 10),

          _LegendRow(
            color: AppC.green,
            label: 'Bin Prioritas',
          ),

          SizedBox(height: 10),

          _LegendRow(
            color: Colors.grey,
            label: 'Node Jalan',
          ),

          SizedBox(height: 10),

          _LegendLineRow(
            color: AppC.green,
            label: 'Rute Optimal A*',
          ),

          SizedBox(height: 10),

          _LegendDashedLineRow(
            color: AppC.blue,
            label: 'Rute Alternatif',
          ),

          SizedBox(height: 10),

          _LegendRow(
            color: AppC.purple,
            label: 'Node Dieksplorasi',
          ),

          SizedBox(height: 10),

          _LegendRow(
            color: Colors.grey,
            label: 'Node Belum Dieksplorasi',
          ),
        ],
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendRow({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 6,
          backgroundColor: color,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: AppC.sub,
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _LegendLineRow extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendLineRow({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 24,
          height: 3,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(999),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: const TextStyle(color: AppC.sub))),
      ],
    );
  }
}

class _LegendDashedLineRow extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDashedLineRow({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Row(
          children: List.generate(
            4,
            (index) => Container(
              margin: const EdgeInsets.only(right: 3),
              width: 5,
              height: 3,
              color: color,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: const TextStyle(color: AppC.sub))),
      ],
    );
  }
}
class _RealNodeTableItem {
  final String node;
  final double g;
  final double h;
  final double f;
  final String status;
  final Color statusColor;
  final String percent;

  const _RealNodeTableItem({
    required this.node,
    required this.g,
    required this.h,
    required this.f,
    required this.status,
    required this.statusColor,
    required this.percent,
  });
}

Map<String, latlng.LatLng> _realNodePoints(List<SmartBinNode> bins) {
  final binMap = {
    for (final bin in bins) bin.id: bin,
  };

  return {
    // =========================
    // DEPOT ASLI
    // =========================
    'DEPOT': const latlng.LatLng(-7.433336471204092,109.25204780729659,),

    // =========================
    // NODE ASLI MENUJU BIN-1
    // GANTI koordinat ini sesuai node asli Anda
    // =========================
    'B1_N1': const latlng.LatLng(-7.430626237398160, 109.25162154009400),

    // =========================
    // NODE ASLI MENUJU BIN-2
    // GANTI koordinat ini sesuai node asli Anda
    // =========================
      'B2_N1': const latlng.LatLng(-7.430649655537240, 109.25163759905200),
      'B2_N2': const latlng.LatLng(-7.430386818260330, 109.25355362705800),
      'B2_N3': const latlng.LatLng(-7.429979046737700, 109.25553654926800),
      'B2_N4': const latlng.LatLng(-7.437096096887500, 109.26231329787300),
      'B2_N5': const latlng.LatLng(-7.437244594451760, 109.26249831315400),
      'B2_N6': const latlng.LatLng(-7.438569197518580, 109.26772716352300),
      'B2_N7': const latlng.LatLng(-7.438678407425730, 109.26767849487000),
      'B2_N8': const latlng.LatLng(-7.437954501000300, 109.26610246560700),
      'B2_N9': const latlng.LatLng(-7.438570956667230, 109.26623603903300),
      'B2_N10': const latlng.LatLng(-7.429979046737700, 109.2555365492680),
      'B2_N11': const latlng.LatLng(-7.439115108280830, 109.2663562576390),
      'B2_N13': const latlng.LatLng(-7.439709426739840, 109.2674986877580),
      'B2_N14': const latlng.LatLng(-7.440398513038150, 109.2666403426170),
      'B2_N15': const latlng.LatLng(-7.430918600260240, 109.24872324820500),
      'B2_N16': const latlng.LatLng(-7.438836463739980, 109.24891637200900),
      'B2_N17': const latlng.LatLng(-7.437324808420020, 109.26218284798100),
      'B2_N18': const latlng.LatLng(-7.438570956667230, 109.26623603903300),
      'B2_N19': const latlng.LatLng(-7.438836463739980, 109.24891637200900),
      'B2_N20': const latlng.LatLng(-7.440398513038150, 109.26664034261700),

    // =========================
    // NODE ASLI MENUJU BIN-3
    // GANTI koordinat ini sesuai node asli Anda
    // =========================
      'B3_N1': const latlng.LatLng(-7.430639341895300, 109.25161072123000),
      'B3_N2': const latlng.LatLng(-7.430935858094490, 109.24875756438500),
      'B3_N3': const latlng.LatLng(-7.427629595876430, 109.24866692366800),
      'B3_N4': const latlng.LatLng(-7.427615983544590, 109.24876485446900),
      'B3_N5': const latlng.LatLng(-7.424976129901880, 109.24859085157700),
      'B3_N6': const latlng.LatLng(-7.424988643425380, 109.24599126802800),
      'B3_N7': const latlng.LatLng(-7.425406258295280, 109.24606547043900),
      'B3_N8': const latlng.LatLng(-7.427803689915750, 109.24370189752900),
      'B3_N9': const latlng.LatLng(-7.425813378155790, 109.2437087014270),
      'B3_N10': const latlng.LatLng(-7.430801464437000, 109.24375729168500),
      'B3_N11': const latlng.LatLng(-7.42911010306655, 109.24374561361500),

    // =========================
    // BIN ASLI DARI DATA APLIKASI
    // =========================
    if (binMap['BIN-1'] != null) 'BIN-1': binMap['BIN-1']!.position,
    if (binMap['BIN-2'] != null) 'BIN-2': binMap['BIN-2']!.position,
    if (binMap['BIN-3'] != null) 'BIN-3': binMap['BIN-3']!.position,
  };
}

Map<String, List<String>> _realPathPerBin() {
  return {
    'BIN-1': [
      'DEPOT',
      'B1_N1',
      'BIN-1',
    ],
    'BIN-2': [
      'DEPOT',
        'B2_N1',
        'B2_N2',
        'B2_N3',
        'B2_N4',
        'B2_N5',
        'B2_N6',
        'B2_N7',
        'B2_N8',
        'B2_N9',
        'B2_N10',
        'B2_N11',
        'B2_N12',
        'B2_N13',
        'B2_N14',
        'B2_N15',
        'B2_N16',
        'B2_N17',
        'B2_N18',
        'B2_N19',
        'B2_N20',
      'BIN-2',
    ],
    'BIN-3': [
      'DEPOT',
        'B3_N1',
        'B3_N2',
        'B3_N3',
        'B2_N4',
        'B2_N5',
        'B2_N6',
        'B2_N7',
        'B2_N8',
        'B2_N9',
        'B2_N10',
        'B2_N11',
      'BIN-3',
    ],
  };
}

List<_RealNodeTableItem> _realNodeTableRows(List<SmartBinNode> bins) {
  final nodePoints = _realNodePoints(bins);
  final pathPerBin = _realPathPerBin();

  final binMap = {
    for (final bin in bins) bin.id: bin,
  };

  final fullBins = bins.where((bin) => bin.isFull).toList();

  final rows = <_RealNodeTableItem>[];

  if (fullBins.isEmpty) {
    rows.add(
      const _RealNodeTableItem(
        node: 'DEPOT',
        g: 0.0,
        h: 0.0,
        f: 0.0,
        status: 'Depot',
        statusColor: AppC.blue,
        percent: '-',
      ),
    );

    return rows;
  }

  final distance = latlng.Distance();

  final addedRows = <String>{};

  for (final targetBin in fullBins) {
    final path = pathPerBin[targetBin.id];

    if (path == null) continue;

    double gValue = 0.0;

    for (int i = 0; i < path.length; i++) {
      final nodeId = path[i];

      final currentPoint = nodePoints[nodeId];
      final goalPoint = nodePoints[targetBin.id];

      if (currentPoint == null || goalPoint == null) continue;

      if (i > 0) {
        final previousNodeId = path[i - 1];
        final previousPoint = nodePoints[previousNodeId];

        if (previousPoint != null) {
          gValue += distance.as(
            latlng.LengthUnit.Kilometer,
            previousPoint,
            currentPoint,
          );
        }
      }

      final double hValue = distance.as(
        latlng.LengthUnit.Kilometer,
        currentPoint,
        goalPoint,
      );

      final double fValue = gValue + hValue;

      String status = 'Node Aktif';
      Color statusColor = AppC.green;
      String percent = '-';

      if (nodeId == 'DEPOT') {
        status = 'Depot';
        statusColor = AppC.blue;
      }

      if (nodeId.startsWith('BIN-')) {
        final bin = binMap[nodeId];

        status = 'Tujuan';
        statusColor = bin?.color ?? AppC.red;
        percent = bin == null
            ? '-'
            : '${bin.fillPercent.toStringAsFixed(0)}%';
      }

      final uniqueKey = '${targetBin.id}-$nodeId';

      if (addedRows.contains(uniqueKey)) continue;
      addedRows.add(uniqueKey);

      rows.add(
        _RealNodeTableItem(
          node: nodeId,
          g: gValue,
          h: hValue,
          f: fValue,
          status: status,
          statusColor: statusColor,
          percent: percent,
        ),
      );
    }
  }

  return rows;
}
class _GraphRoutePanel extends StatelessWidget {
  final List<SmartBinNode> bins;
  final FirebaseRouteData firebaseRouteData;

  const _GraphRoutePanel({
    super.key,
    required this.bins,
    required this.firebaseRouteData,
  });

  Widget _nodeDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            '$label:',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _openSingleNodeInGoogleMaps(
    BuildContext context,
    FirebaseRouteNode node,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    final lat = node.position.latitude;
    final lng = node.position.longitude;

    final url = Uri.https(
      'www.google.com',
      '/maps/search/',
      {
        'api': '1',
        'query': '$lat,$lng',
      },
    );

    final opened = await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    );

    if (!opened) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Gagal membuka titik node di Google Maps'),
        ),
      );
    }
  }

  void _showNodeDetailDialog({
    required BuildContext context,
    required FirebaseRouteNode node,
    required String subtitle,
    required Color color,
    required IconData icon,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0B1730),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: Row(
            children: [
              Icon(
                icon,
                color: color,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  node.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _nodeDetailRow('ID Node', node.id),
                const SizedBox(height: 10),
                _nodeDetailRow('Status', subtitle),
                const SizedBox(height: 10),
                _nodeDetailRow('Tipe', node.type),
                const SizedBox(height: 10),
                _nodeDetailRow(
                  'Latitude',
                  node.position.latitude.toStringAsFixed(7),
                ),
                const SizedBox(height: 10),
                _nodeDetailRow(
                  'Longitude',
                  node.position.longitude.toStringAsFixed(7),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Tutup'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(dialogContext);
                _openSingleNodeInGoogleMaps(context, node);
              },
              icon: const Icon(Icons.map_rounded),
              label: const Text('Buka Titik di Google Maps'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppC.blue,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final route = firebaseRouteData.route;
    final nodes = firebaseRouteData.nodes;

Future<void> openAStarInGoogleMaps(List<String> routeIds) async {
  final points = routeIds
      .map((id) => nodes[id.toLowerCase()]?.position)
      .whereType<latlng.LatLng>()
      .toList();

  if (points.length < 2) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rute A* belum lengkap untuk dibuka di Google Maps'),
      ),
    );
    return;
  }

  String pointToText(latlng.LatLng point) {
    return '${point.latitude},${point.longitude}';
  }

  final origin = pointToText(points.first);
  final destination = pointToText(points.last);

  final waypoints = points.length > 2
      ? points.sublist(1, points.length - 1)
      : <latlng.LatLng>[];

  final queryParameters = <String, String>{
    'api': '1',
    'origin': origin,
    'destination': destination,
    'travelmode': 'driving',
  };

  if (waypoints.isNotEmpty) {
    queryParameters['waypoints'] = waypoints
        .map(pointToText)
        .join('|');
  }

  final url = Uri.https(
    'www.google.com',
    '/maps/dir/',
    queryParameters,
  );
final tts = FlutterTts();

await tts.setLanguage('id-ID');
await tts.setSpeechRate(0.4);
await tts.setPitch(1.0);
await tts.setVolume(1.0);

final tujuan = firebaseRouteData.fullBin.isEmpty
    ? 'tempat sampah penuh'
    : firebaseRouteData.fullBin.toUpperCase();

await tts.speak(
  'Navigasi rute A Star akan dibuka di Google Maps. '
  'Rute dimulai dari TPS menuju $tujuan. '
);

await Future.delayed(
  const Duration(milliseconds: 1500),
);
  final opened = await launchUrl(
    url,
    mode: LaunchMode.externalApplication,
  );

  if (!opened) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Gagal membuka Google Maps'),
      ),
    );
  }
}

final polylines = <Polyline>[];
final markers = <Marker>[];

void addRoutePolyline({
  required List<String> routeData,
  required Color color,
  required double offsetLat,
  required double offsetLng,
  double strokeWidth = 5,
}) {
  for (int i = 0; i < routeData.length - 1; i++) {
    final fromNode = nodes[routeData[i]];
    final toNode = nodes[routeData[i + 1]];

    if (fromNode == null || toNode == null) continue;

    final fromPoint = latlng.LatLng(
      fromNode.position.latitude + offsetLat,
      fromNode.position.longitude + offsetLng,
    );

    final toPoint = latlng.LatLng(
      toNode.position.latitude + offsetLat,
      toNode.position.longitude + offsetLng,
    );

    polylines.add(
      Polyline(
        points: [
          fromPoint,
          toPoint,
        ],
        strokeWidth: strokeWidth,
        color: color,
      ),
    );
  }
}

// GARIS PERGI / FORWARD = HIJAU
addRoutePolyline(
  routeData: firebaseRouteData.forwardRoute,
  color: AppC.green,
  offsetLat: 0.000025,
  offsetLng: -0.000025,
  strokeWidth: 5,
);

// GARIS PULANG / RETURN = MERAH
addRoutePolyline(
  routeData: firebaseRouteData.returnRoute,
  color: const Color(0xFFFF2DFF),
  offsetLat: -0.000025,
  offsetLng: 0.000025,
  strokeWidth: 6,
);

// Jika Firebase lama hanya punya route biasa
if (polylines.isEmpty) {
  addRoutePolyline(
    routeData: route,
    color: AppC.green,
    offsetLat: 0.0,
    offsetLng: 0.0,
    strokeWidth: 5,
  );
}
final passedNodeIds = <String>{
  ...firebaseRouteData.forwardRoute,
  ...firebaseRouteData.returnRoute,
  ...route,
}.map((e) => e.toLowerCase()).toSet();

// Ambil bin yang penuh dari data real-time aplikasi
final fullBinIds = bins
    .where((bin) => bin.fillPercent >= 92)
    .map((bin) => bin.id.toLowerCase().replaceAll('-', ''))
    .toSet();

// Cadangan kalau Firebase mengirim fullBin
if (fullBinIds.isEmpty && firebaseRouteData.fullBin.isNotEmpty) {
  fullBinIds.add(
    firebaseRouteData.fullBin.toLowerCase().replaceAll('-', ''),
  );
}

Set<String> nodeGroupForBin(String binId) {
  switch (binId) {
    case 'bin1':
      return {
        'tps',
        's0',
        'bin1',
      };

    case 'bin2':
      return {
        'tps',
        's0',
        'p2',
        'p3',
        'p4',
        'p4a',
        'p5',
        'p5a',
        'p6',
        'p6a',
        'p7',
        'p8',
        'p9',
        'p10',
        'p11',
        'p12',
        'p13',
        'p15',
        'p16',
        'p16a',
        'p17',
        'bin2',
      };

    case 'bin3':
      return {
        'tps',
        's0',
        'c2',
        'c3',
        'c5',
        'c6',
        'c7',
        'c8',
        'c9',
        'c10',
        'c11',
        'c12',
        'c13',
        'bin3',
      };

    default:
      return {};
  }
}

final visibleNodeIds = <String>{};

// Tampilkan semua node yang termasuk jalur menuju bin penuh
for (final binId in fullBinIds) {
  visibleNodeIds.addAll(nodeGroupForBin(binId));
}

// Node yang dilewati route tetap dianggap aktif
visibleNodeIds.addAll(
  passedNodeIds.where((id) {
    for (final binId in fullBinIds) {
      if (nodeGroupForBin(binId).contains(id)) {
        return true;
      }
    }
    return false;
  }),
);

for (final entry in nodes.entries) {
  final nodeId = entry.key.toLowerCase();
  final node = entry.value;

  // Node yang bukan menuju bin penuh tidak ditampilkan
  if (!visibleNodeIds.contains(nodeId)) {
    continue;
  }

  final isPassed = passedNodeIds.contains(nodeId);

  Color color = Colors.grey;
  IconData icon = Icons.circle;
  String subtitle = 'Node Tidak Dilewati';

  if (node.type == 'depot' || nodeId.contains('tps')) {
    color = isPassed ? AppC.blue : Colors.grey;
    icon = Icons.location_on_rounded;
    subtitle = isPassed ? 'Titik Awal' : 'Depot Tidak Dilewati';
  } else if (node.type == 'bin' || nodeId.startsWith('bin')) {
    color = isPassed ? AppC.red : Colors.grey;
    icon = Icons.delete_outline_rounded;
    subtitle = isPassed ? 'Tujuan' : 'Bin Tidak Dilewati';
  } else {
    color = isPassed ? AppC.green : Colors.grey;
    icon = Icons.circle;
    subtitle = isPassed ? 'Node Dilewati' : 'Node Tidak Dilewati';
  }

markers.add(
  Marker(
    point: node.position,
    width: 150,
    height: 125,
    child: MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          _showNodeDetailDialog(
            context: context,
            node: node,
            subtitle: subtitle,
            color: color,
            icon: icon,
          );
        },
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: _RealMapMarker(
            label: node.label,
            subtitle: subtitle,
            color: color,
            icon: icon,
          ),
        ),
      ),
    ),
  ),
);
}
    final initialCenter = markers.isNotEmpty
        ? markers.first.point
        : const latlng.LatLng(-7.4352631, 109.2490926);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelBox(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Visualisasi Peta & Node Firebase',
            style: TextStyle(
              color: AppC.textColor(context),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
Row(
  children: [
    Expanded(
      child: ElevatedButton.icon(
        onPressed: firebaseRouteData.forwardRoute.isEmpty
            ? null
            : () {
                openAStarInGoogleMaps(
                  firebaseRouteData.forwardRoute,
                );
              },
        icon: const Icon(Icons.map_rounded),
        label: const Text('Buka A* di Google Maps'),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppC.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: ElevatedButton.icon(
        onPressed: firebaseRouteData.returnRoute.isEmpty
            ? null
            : () {
                openAStarInGoogleMaps(
                  firebaseRouteData.returnRoute,
                );
              },
        icon: const Icon(Icons.keyboard_return_rounded),
        label: const Text('Rute Pulang'),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFB45CFF),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
      ),
    ),
  ],
),

const SizedBox(height: 12),

          const SizedBox(height: 12),

          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: initialCenter,
                  initialZoom: 15.5,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.smartbin',
                  ),

                  if (polylines.isNotEmpty)
                    PolylineLayer(
                      polylines: polylines,
                    ),

                  MarkerLayer(
                    markers: markers,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          Text(
            route.isEmpty
                ? 'Route Firebase belum tersedia.'
                : 'Route dan node mengikuti data Firebase tps1.',
            style: TextStyle(
              color: AppC.subColor(context),
              fontWeight: FontWeight.w600,
            ),
          ),        ],
      ),
    );
  }
}
class _RealMapMarker extends StatelessWidget {
  final String label;
  final String subtitle;
  final Color color;
  final IconData icon;

  const _RealMapMarker({
    required this.label,
    required this.subtitle,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 145,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            constraints: const BoxConstraints(
              maxWidth: 135,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: const Color(0xFF0B1625).withOpacity(0.92),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Colors.white.withOpacity(0.10),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),

          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.38),
                  blurRadius: 14,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: icon == Icons.circle ? 12 : 19,
            ),
          ),
        ],
      ),
    );
  }
}

class _AStarNodesMiniTable extends StatelessWidget {
  final List<SmartBinNode> bins;

  const _AStarNodesMiniTable({
    required this.bins,
  });

  @override
  Widget build(BuildContext context) {
    final rows = _realNodeTableRows(bins);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelBox(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tabel Nodes',
            style: TextStyle(
              color: AppC.textColor(context),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),

          const SizedBox(height: 12),

          Expanded(
            child: SingleChildScrollView(
              child: Table(
                border: TableBorder.all(
                  color: AppC.borderColor(context),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(1.5),
                  1: FlexColumnWidth(1),
                  2: FlexColumnWidth(1),
                  3: FlexColumnWidth(1),
                  4: FlexColumnWidth(1.5),
                },
                children: [
                  _tableHeader(context),
                  ...rows.map((row) {
                    return _tableRow(
                      context,
                      row.node,
                      row.g,
                      row.h,
                      row.f,
                      row.status,
                      row.statusColor,
                    );
                  }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  TableRow _tableHeader(BuildContext context) {
    return TableRow(
      decoration: BoxDecoration(
        color: AppC.panelBgSoft(context),
      ),
      children: const [
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Node',
            style: TextStyle(
              color: AppC.text,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'g(n)',
            style: TextStyle(
              color: AppC.text,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'h(n)',
            style: TextStyle(
              color: AppC.text,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'f(n)',
            style: TextStyle(
              color: AppC.text,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8),
          child: Text(
            'Status',
            style: TextStyle(
              color: AppC.text,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  TableRow _tableRow(
    BuildContext context,
    String node,
    double g,
    double h,
    double f,
    String status,
    Color statusColor,
  ) {
    return TableRow(
      children: [
        _cell(
          node,
          color: AppC.textColor(context),
          bold: true,
        ),
        _cell(
          g.toStringAsFixed(2),
          color: AppC.textColor(context),
        ),
        _cell(
          h.toStringAsFixed(2),
          color: AppC.textColor(context),
        ),
        _cell(
          f.toStringAsFixed(2),
          color: AppC.textColor(context),
        ),
        _cell(
          status,
          color: statusColor,
          bold: true,
        ),
      ],
    );
  }

  Widget _cell(
    String text, {
    required Color color,
    bool bold = false,
  }) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}
class _RecommendationPanel extends StatelessWidget {
  final RouteResult routeResult;
  final void Function(RouteResult routeResult) onSelesaiPengambilan;
  final List<SmartBinNode> bins;

  const _RecommendationPanel({
    required this.routeResult,
    required this.onSelesaiPengambilan,
    required this.bins,
  });

  @override
  Widget build(BuildContext context) {
    final fullBins = bins.where((e) => e.isFull).toList();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelBox(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Rekomendasi',
            style: TextStyle(
              color: AppC.textColor(context),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: const [
              Icon(Icons.check_circle, color: AppC.green),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Ikuti rute optimal (garis hijau) untuk efisiensi waktu dan jarak.',
                  style: TextStyle(color: AppC.sub),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: fullBins.isEmpty
                  ? null
                  : () async {
                      final confirm = await showDialog<bool>(
                        context: context,
                        builder: (_) => AlertDialog(
                          backgroundColor: const Color(0xFF0B1730),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          title: const Text(
                            'Konfirmasi Pengambilan',
                            style: TextStyle(color: Colors.white),
                          ),
                          content: Text(
                            'Selesaikan pengambilan untuk ${fullBins.length} bin penuh?',
                            style: const TextStyle(color: Colors.white70),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, false),
                              child: const Text('Batal'),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context, true),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppC.blue,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('OKE'),
                            ),
                          ],
                        ),
                      );

                      if (confirm == true) {
                        onSelesaiPengambilan(routeResult);
                      }
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppC.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                'Selesaikan Pengambilan',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomInfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _BottomInfoCard({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _panelBox(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppC.textColor(context),
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: 12),
          Expanded(child: child),
        ],
      ),
    );
  }
}

class RiwayatPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final List<RiwayatPengambilan> riwayat;
  final int unreadNotificationCount;

  const RiwayatPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.riwayat,
    required this.unreadNotificationCount,
  });

  void _showDetail(BuildContext context, RiwayatPengambilan item) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0B1730),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Detail Riwayat Pengambilan',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('Nama Bin', item.namaBin),
                const SizedBox(height: 10),
                _detailRow('Waktu', '${item.waktu.day.toString().padLeft(2, '0')}/${item.waktu.month.toString().padLeft(2, '0')}/${item.waktu.year} - ${item.waktu.hour.toString().padLeft(2, '0')}:${item.waktu.minute.toString().padLeft(2, '0')}'),
                const SizedBox(height: 10),
                _detailRow('Jarak', '${item.jarakKm.toStringAsFixed(2)} km'),
                const SizedBox(height: 10),
                _detailRow('Status', item.status),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppC.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 90,
          child: Text(
            '$label:',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppC.pageBg(context),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
            decoration: BoxDecoration(
              gradient: AppC.topHeaderBg(context),
            ),
child: TopBar(
  isDarkMode: isDarkMode,
  onThemeChanged: onThemeChanged,
  title: 'Riwayat',
  subtitle: 'Riwayat pengambilan sampah yang sudah diselesaikan',
  unreadNotificationCount: unreadNotificationCount,
),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppC.isDark(context)
                      ? const Color(0xFF081321)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppC.isDark(context)
                        ? Colors.white.withOpacity(0.05)
                        : const Color(0xFFD7E2F0),
                  ),
                  boxShadow: AppC.panelShadow(context),
                ),
                child: riwayat.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada riwayat pengambilan.',
                          style: TextStyle(
                            color: AppC.subColor(context),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(
                            AppC.isDark(context)
                                ? const Color(0xFF0B1730)
                                : const Color(0xFFF3F7FC),
                          ),
columns: [
  DataColumn(
    label: Text(
      'Nama Bin',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppC.textColor(context),
      ),
    ),
  ),
  DataColumn(
    label: Text(
      'Waktu Pengambilan',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppC.textColor(context),
      ),
    ),
  ),
  DataColumn(
    label: Text(
      'Keterangan',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppC.textColor(context),
      ),
    ),
  ),
  DataColumn(
    label: Text(
      'Jarak',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppC.textColor(context),
      ),
    ),
  ),
  DataColumn(
    label: Text(
      'Aksi',
      style: TextStyle(
        fontWeight: FontWeight.bold,
        color: AppC.textColor(context),
      ),
    ),
  ),
],
       rows: riwayat.map((item) {
                            return DataRow(
                              cells: [
                                DataCell(
                                  Text(
                                    item.namaBin,
                                    style: TextStyle(
                                      color: AppC.textColor(context),
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${item.waktu.day.toString().padLeft(2, '0')}/${item.waktu.month.toString().padLeft(2, '0')}/${item.waktu.year} - ${item.waktu.hour.toString().padLeft(2, '0')}:${item.waktu.minute.toString().padLeft(2, '0')}',
                                    style: TextStyle(
                                      color: AppC.textColor(context),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 6,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppC.green.withOpacity(0.14),
                                      borderRadius: BorderRadius.circular(999),
                                    ),
                                    child: const Text(
                                      'Selesai',
                                      style: TextStyle(
                                        color: AppC.green,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    '${item.jarakKm.toStringAsFixed(2)} km',
                                    style: TextStyle(
                                      color: AppC.textColor(context),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  ElevatedButton(
                                    onPressed: () => _showDetail(context, item),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppC.blue,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text('Lihat Detail'),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

  class NotifikasiPage extends StatelessWidget {
    final bool isDarkMode;
    final ValueChanged<bool> onThemeChanged;
    final List<NotifikasiItem> notifikasi;
    final int unreadNotificationCount;

  const NotifikasiPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.notifikasi,
    required this.unreadNotificationCount,
  });

  String _formatWaktu(DateTime waktu) {
    final day = waktu.day.toString().padLeft(2, '0');
    final month = waktu.month.toString().padLeft(2, '0');
    final year = waktu.year.toString();
    final hour = waktu.hour.toString().padLeft(2, '0');
    final minute = waktu.minute.toString().padLeft(2, '0');
    return '$day/$month/$year - $hour:$minute';
  }

  void _showDetail(BuildContext context, NotifikasiItem item) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0B1730),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          title: const Text(
            'Detail Notifikasi',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _detailRow('Nama Bin', item.namaBin),
                const SizedBox(height: 10),
                _detailRow(
                  'Persentase',
                  '${item.persentase.toStringAsFixed(0)}%',
                ),
                const SizedBox(height: 10),
                _detailRow('Waktu', _formatWaktu(item.waktu)),
                const SizedBox(height: 10),
                _detailRow('Pesan', item.pesan),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppC.blue,
                foregroundColor: Colors.white,
              ),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  Widget _detailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 95,
          child: Text(
            '$label:',
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: AppC.pageBg(context),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
            decoration: BoxDecoration(
              gradient: AppC.topHeaderBg(context),
            ),
child: TopBar(
  isDarkMode: isDarkMode,
  onThemeChanged: onThemeChanged,
  title: 'Notifikasi',
  subtitle: 'Pemberitahuan otomatis saat tempat sampah mencapai kondisi penuh',
  unreadNotificationCount: unreadNotificationCount,
),          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppC.isDark(context)
                      ? const Color(0xFF081321)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: AppC.isDark(context)
                        ? Colors.white.withOpacity(0.05)
                        : const Color(0xFFD7E2F0),
                  ),
                  boxShadow: AppC.panelShadow(context),
                ),
                child: notifikasi.isEmpty
                    ? Center(
                        child: Text(
                          'Belum ada notifikasi.',
                          style: TextStyle(
                            color: AppC.subColor(context),
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : ListView.separated(
                        itemCount: notifikasi.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final item = notifikasi[index];

                          return Container(
                            padding: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppC.isDark(context)
                                  ? const Color(0xFF0B1730)
                                  : const Color(0xFFF8FBFF),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(
                                color: AppC.red.withOpacity(0.22),
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 54,
                                  height: 54,
                                  decoration: BoxDecoration(
                                    color: AppC.red.withOpacity(0.14),
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  child: const Icon(
                                    Icons.notifications_active_outlined,
                                    color: AppC.red,
                                    size: 26,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.namaBin,
                                        style: TextStyle(
                                          color: AppC.textColor(context),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Mencapai ${item.persentase.toStringAsFixed(0)}% (Penuh)',
                                        style: const TextStyle(
                                          color: AppC.red,
                                          fontSize: 13.5,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        item.pesan,
                                        style: TextStyle(
                                          color: AppC.subColor(context),
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        _formatWaktu(item.waktu),
                                        style: TextStyle(
                                          color: AppC.subColor(context),
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () => _showDetail(context, item),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppC.blue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 18,
                                      vertical: 14,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(14),
                                    ),
                                  ),
                                  child: const Text('Lihat Detail'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class PengaturanSistemPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const PengaturanSistemPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          // ================= HEADER =================
          const Text(
            'Pengaturan Sistem',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),

          const SizedBox(height: 8),

          const Text(
            'Kelola preferensi aplikasi, notifikasi, keamanan, dan konfigurasi sistem IoT',
            style: TextStyle(color: Colors.white70),
          ),

          const SizedBox(height: 20),

          // ================= STATUS =================
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF0F1B2D),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.white10),
            ),
            child: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.green, size: 28),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Semua sistem berjalan normal (IoT, Server, Database)',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Normal',
                    style: TextStyle(color: Colors.green),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ================= GRID =================
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.5,
              children: [

                // 🔥 CARD 1 - TAMPILAN
                _card(
                  title: 'Preferensi Tampilan',
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Dark Mode',
                          style: TextStyle(color: Colors.white)),
                      Switch(
                        value: isDarkMode,
                        onChanged: onThemeChanged,
                      ),
                    ],
                  ),
                ),

                // 🔥 CARD 2 - NOTIFIKASI
                _card(
                  title: 'Pengaturan Notifikasi',
                  child: Column(
                    children: [
                      _switchRow('Bin Penuh (Real-time)', true),
                      _switchRow('Status Perangkat IoT', true),
                      _switchRow('Laporan Harian', false),
                    ],
                  ),
                ),

                // 🔥 CARD 3 - SISTEM
                _card(
                  title: 'Konfigurasi Sistem',
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Bahasa: Indonesia',
                          style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 6),
                      Text('Zona Waktu: WIB (UTC+7)',
                          style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 6),
                      Text('Versi Aplikasi: v1.0',
                          style: TextStyle(color: Colors.white70)),
                    ],
                  ),
                ),

                // 🔥 CARD 4 - KEAMANAN
                _card(
                  title: 'Keamanan & Akses',
                  child: Column(
                    children: [
                      _switchRow('Kunci Aplikasi', false),
                      const SizedBox(height: 6),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Auto Logout: 15 menit',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ),
                    ],
                  ),
                ),

                // 🔥 CARD 5 - ABOUT
                _card(
                  title: 'Tentang Sistem',
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Smart Bin Monitoring System',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Sistem monitoring berbasis IoT untuk pengelolaan sampah pintar dengan sensor ultrasonik & GPS.',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
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

  // ================= CARD STYLE =================
  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1B2D),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  // ================= SWITCH ROW =================
  Widget _switchRow(String text, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(text, style: const TextStyle(color: Colors.white)),
        Switch(value: value, onChanged: (_) {}),
      ],
    );
  }
}
class TempatSampahPage extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final List<SmartBinNode> bins;
  final void Function(int index, double value) onBinChanged;
  final int unreadNotificationCount;

  const TempatSampahPage({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.bins,
    required this.onBinChanged,
    required this.unreadNotificationCount,
  });

  @override
  Widget build(BuildContext context) {
    final fullCount = bins.where((b) => b.isFull).length;
    final almostCount = bins.where((b) => b.isAlmostFull).length;
    final safeCount = bins.where((b) => b.isNotFull).length;

    return Container(
      decoration: BoxDecoration(
        gradient: AppC.pageBg(context),
      ),
      child: Column(
        children: [
          // =========================
          // HEADER
          // =========================
          Container(
            padding: const EdgeInsets.fromLTRB(24, 22, 24, 18),
            decoration: BoxDecoration(
              gradient: AppC.topHeaderBg(context),
            ),
            child: TopBar(
              isDarkMode: isDarkMode,
              onThemeChanged: onThemeChanged,
              title: 'Tempat Sampah',
              subtitle: 'Kelola dan pantau semua tempat sampah',
              unreadNotificationCount: unreadNotificationCount,
            ),
          ),

          // =========================
          // CONTENT
          // =========================
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 18, 24, 22),
              child: Column(
                children: [
                  // =========================
                  // SUMMARY CARD
                  // =========================
                  SizedBox(
                    height: 110,
                    child: Row(
                      children: [
                        Expanded(
                          child: _TempatSampahSummaryCard(
                            icon: Icons.delete_rounded,
                            color: AppC.blue,
                            value: '${bins.length}',
                            label: 'Total Bin',
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _TempatSampahSummaryCard(
                            icon: Icons.check_circle_rounded,
                            color: AppC.green,
                            value: '$safeCount',
                            label: 'Aman',
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _TempatSampahSummaryCard(
                            icon: Icons.warning_rounded,
                            color: AppC.yellow,
                            value: '$almostCount',
                            label: 'Hampir Penuh',
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _TempatSampahSummaryCard(
                            icon: Icons.error_rounded,
                            color: AppC.red,
                            value: '$fullCount',
                            label: 'Penuh',
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // =========================
                  // TABLE CONTAINER
                  // =========================
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppC.panelBg(context),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: AppC.borderColor(context),
                        ),
                        boxShadow: AppC.panelShadow(context),
                      ),
                      child: Column(
                        children: [
                          // =========================
                          // TABLE HEADER
                          // =========================
                          Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: AppC.borderColor(context),
                                  width: 1.5,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                // BIN & LOKASI
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'BIN & LOKASI',
                                    style: TextStyle(
                                      color: AppC.subColor(context),
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),

                                // GARIS
                                Container(
                                  width: 1.5,
                                  height: 20,
                                  color: AppC.borderColor(context),
                                ),

                                const SizedBox(width: 20),

                                // KAPASITAS
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    'KAPASITAS',
                                    style: TextStyle(
                                      color: AppC.subColor(context),
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 20),

                                // GARIS
                                Container(
                                  width: 1.5,
                                  height: 20,
                                  color: AppC.borderColor(context),
                                ),

                                const SizedBox(width: 20),

                                // SIMULASI
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    'SIMULASI LEVEL SAMPAH',
                                    style: TextStyle(
                                      color: AppC.subColor(context),
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          // =========================
                          // LIST BIN
                          // =========================
                          Expanded(
                            child: ListView.builder(
                              itemCount: bins.length,
                              itemBuilder: (context, index) {
                                final bin = bins[index];

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: _TempatSampahListCard(
                                    bin: bin,
                                    onChanged: (value) {
                                      onBinChanged(index, value);
                                    },
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class _TempatSampahSummaryCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;

  const _TempatSampahSummaryCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppC.panelBg(context),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.25),
        ),
        boxShadow: AppC.panelShadow(context),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.16),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              icon,
              color: color,
              size: 25,
            ),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  color: AppC.textColor(context),
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  color: AppC.subColor(context),
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
class _TempatSampahListCard extends StatelessWidget {
  final SmartBinNode bin;
  final ValueChanged<double> onChanged;

  const _TempatSampahListCard({
    required this.bin,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final color = bin.color;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      decoration: BoxDecoration(
        color: AppC.panelBgSoft(context),
        borderRadius: BorderRadius.circular(16),
        border: Border(
          top: BorderSide(
            color: AppC.borderColor(context).withOpacity(0.4),
          ),
          bottom: BorderSide(
            color: AppC.borderColor(context).withOpacity(0.4),
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          // ================= BIN & LOKASI =================
          Expanded(
            flex: 3,
            child: Row(
              children: [

                // 🔥 GAMBAR (SUDAH BISA DIKLIK)
                GestureDetector(
                  onTap: () {
                    showBinImages(context, bin);
                  },
                  child: Container(
                    width: 85,
                    height: 85,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: color.withOpacity(0.5),
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(14),
                      child: Image.asset(
                        bin.imagePath,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 16),

                // INFO BIN
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Row(
                        children: [
                          Text(
                            bin.id,
                            style: TextStyle(
                              color: AppC.textColor(context),
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          const SizedBox(width: 10),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(999),
                            ),
                            child: Text(
                              bin.status,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // ICON MAP
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              color: Colors.purple, size: 16),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              bin.name,
                              style: TextStyle(
                                color: AppC.subColor(context),
                                fontWeight: FontWeight.w600,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      const SizedBox(height: 4),

                      Text(
                        'ID: ${bin.id.replaceAll("-", "00")}',
                        style: const TextStyle(
                          color: AppC.blue,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 🔥 GARIS 1
          Container(
            width: 1.5,
            height: 90,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: AppC.borderColor(context).withOpacity(0.6),
          ),

          // ================= KAPASITAS =================
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Kapasitas',
                  style: TextStyle(
                    color: AppC.subColor(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),

                Text(
                  '${bin.fillPercent.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: color,
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                const SizedBox(height: 8),

                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: LinearProgressIndicator(
                    value: bin.fillPercent / 100,
                    minHeight: 10,
                    color: color,
                    backgroundColor: Colors.white10,
                  ),
                ),
              ],
            ),
          ),

          // 🔥 GARIS 2
          Container(
            width: 1.5,
            height: 90,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            color: AppC.borderColor(context).withOpacity(0.6),
          ),

          // ================= SIMULASI =================
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  'Simulasi Level Sampah',
                  style: TextStyle(
                    color: AppC.subColor(context),
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  '${bin.fillPercent.toStringAsFixed(0)}%',
                  style: TextStyle(
                    color: AppC.textColor(context),
                    fontWeight: FontWeight.w800,
                  ),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.location_on_outlined, size: 16),
                      label: const Text('Lihat di Peta'),
                    ),
                    const SizedBox(width: 8),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class _RouteMiniMetric extends StatelessWidget {
  final String title;
  final String subtitle;

  const _RouteMiniMetric({
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AppC.textColor(context),
              fontWeight: FontWeight.w800,
              fontSize: 19,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: AppC.subColor(context),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteTimelineRow extends StatelessWidget {
  final String time;
  final Color lineColor;
  final Color dotColor;
  final String title;
  final String subtitle;
  final String trailingText;
  final Color trailingColor;
  final bool isFirst;
  final bool isLast;

  const _RouteTimelineRow({
    required this.time,
    required this.lineColor,
    required this.dotColor,
    required this.title,
    required this.subtitle,
    required this.trailingText,
    required this.trailingColor,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 84,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 42,
            child: Text(
              time,
              style: TextStyle(
                color: AppC.subColor(context),
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(
            width: 26,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    width: 2,
                    color: isFirst
                        ? Colors.transparent
                        : lineColor.withOpacity(0.9),
                  ),
                ),
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: dotColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: dotColor.withOpacity(0.35),
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : lineColor.withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: dotColor.withOpacity(0.14),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      title == 'DEPOT' ? Icons.local_shipping : Icons.delete,
                      color: dotColor,
                      size: 15,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: TextStyle(
                            color: AppC.textColor(context),
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            color: dotColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: trailingColor.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      trailingText,
                      style: TextStyle(
                        color: trailingColor,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BinListTile extends StatelessWidget {
  final SmartBinNode bin;

  const _BinListTile({
    required this.bin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Colors.white.withOpacity(0.04),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: bin.color.withOpacity(0.14),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.delete,
              color: bin.color,
              size: 15,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              bin.name,
              style: TextStyle(
                color: AppC.textColor(context),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${bin.fillPercent.toStringAsFixed(0)}%',
                style: TextStyle(
                  color: bin.color,
                  fontWeight: FontWeight.w800,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                bin.status,
                style: TextStyle(
                  color: bin.color,
                  fontWeight: FontWeight.w700,
                  fontSize: 11.5,
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
          Icon(
            Icons.chevron_right,
            color: AppC.subColor(context),
            size: 18,
          ),
        ],
      ),
    );
  }
}

class TopBar extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;
  final String title;
  final String subtitle;
  final int unreadNotificationCount;

  const TopBar({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
    required this.title,
    required this.subtitle,
    required this.unreadNotificationCount,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppC.isDark(context);
    final bool isHp = MediaQuery.of(context).size.width < 700;

if (isHp) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          softWrap: false,
          style: TextStyle(
            color: AppC.isDark(context)
                ? AppC.textColor(context)
                : Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          softWrap: true,
          style: TextStyle(
            color: AppC.isDark(context)
                ? AppC.subColor(context)
                : Colors.white.withOpacity(0.85),
            fontSize: 12,
            height: 1.35,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: isDark ? AppC.textColor(context) : Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  color: isDark
                      ? AppC.subColor(context)
                      : Colors.white.withOpacity(0.82),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 420,
          height: 56,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: _panelBox(context),
          child: Row(
            children: [
              Icon(Icons.search_rounded, color: AppC.subColor(context)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Cari lokasi, ID tempat sampah...',
                  style: TextStyle(
                    color: AppC.subColor(context),
                    fontSize: 14,
                  ),
                ),
              ),
              Text(
                '⌘ K',
                style: TextStyle(color: AppC.mutedColor(context)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        ThemeModeSwitcher(
          isDarkMode: isDarkMode,
          onChanged: onThemeChanged,
        ),
        const SizedBox(width: 16),
        Container(
          width: 54,
          height: 54,
          decoration: _panelBox(context),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Icon(
                Icons.notifications_none_rounded,
                color: AppC.textColor(context),
                size: 24,
              ),
              if (unreadNotificationCount > 0)
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                    decoration: const BoxDecoration(
                      color: AppC.red,
                      borderRadius: BorderRadius.all(Radius.circular(999)),
                    ),
                    child: Text(
                      unreadNotificationCount > 99
                          ? '99+'
                          : unreadNotificationCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        const LiveDateTimeCard(),
      ],
    );
  }
}

class LiveDateTimeCard extends StatefulWidget {
  const LiveDateTimeCard({super.key});

  @override
  State<LiveDateTimeCard> createState() => _LiveDateTimeCardState();
}

class _LiveDateTimeCardState extends State<LiveDateTimeCard> {
  late DateTime now;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          now = DateTime.now();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  String _bulan(int month) {
    const bulan = [
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
    return bulan[month - 1];
  }

  @override
  Widget build(BuildContext context) {
    final tanggal =
        '${now.day.toString().padLeft(2, '0')} ${_bulan(now.month)} ${now.year}';
    final jam =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: _panelBox(context),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tanggal,
                style: TextStyle(
                  color: AppC.textColor(context),
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                jam,
                style: TextStyle(
                  color: AppC.subColor(context),
                  fontSize: 13,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          const _MiniRefreshButton(),
        ],
      ),
    );
  }
}

class ThemeModeSwitcher extends StatelessWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onChanged;

  const ThemeModeSwitcher({
    super.key,
    required this.isDarkMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppC.panelBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppC.borderColor(context)),
        boxShadow: AppC.panelShadow(context),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _modeButton(
            context: context,
            label: 'Dark',
            icon: Icons.dark_mode_rounded,
            active: isDarkMode,
            onTap: () => onChanged(true),
          ),
          const SizedBox(width: 4),
          _modeButton(
            context: context,
            label: 'Light',
            icon: Icons.light_mode_rounded,
            active: !isDarkMode,
            onTap: () => onChanged(false),
          ),
        ],
      ),
    );
  }

  Widget _modeButton({
    required BuildContext context,
    required String label,
    required IconData icon,
    required bool active,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: active ? AppC.blue.withOpacity(0.14) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? AppC.blue.withOpacity(0.30) : Colors.transparent,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: active ? AppC.blue : AppC.subColor(context),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: active ? AppC.blue : AppC.textColor(context),
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class _MiniRefreshButton extends StatelessWidget {
  const _MiniRefreshButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppC.blue.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Row(
        children: [
          Icon(Icons.refresh_rounded, color: Color(0xFF70A2FF), size: 16),
          SizedBox(width: 6),
          Text(
            'Refresh',
            style: TextStyle(
              color: Color(0xFF70A2FF),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class StatsRow extends StatelessWidget {
  final List<SmartBinNode> bins;
  final void Function(int index, double value) onBinChanged;

  const StatsRow({
    super.key,
    required this.bins,
    required this.onBinChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 320,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 5,
            child: MonitoringSummaryCard(bins: bins),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 7,
            child: Row(
              children: List.generate(bins.length, (index) {
                final bin = bins[index];
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: index == bins.length - 1 ? 0 : 14,
                    ),
                    child: BinCardWithMiniSlider(
                      bin: bin,
                      onChanged: (value) => onBinChanged(index, value),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class BinCardWithMiniSlider extends StatelessWidget {
  final SmartBinNode bin;
  final ValueChanged<double> onChanged;

  const BinCardWithMiniSlider({
    super.key,
    required this.bin,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 12),
      decoration: BoxDecoration(
        color: AppC.isDark(context) ? AppC.panel : null,
        gradient: AppC.isDark(context)
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4B82DD),
                  Color(0xFF7FAAF2),
                ],
              ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppC.isDark(context)
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFD2E2FB),
          width: 1.2,
        ),
        boxShadow: AppC.isDark(context)
            ? [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.04),
                  blurRadius: 24,
                  spreadRadius: 1,
                ),
              ]
            : [
                BoxShadow(
                  color: const Color(0xFF3A84FF).withOpacity(0.28),
                  blurRadius: 36,
                  offset: const Offset(0, 14),
                  spreadRadius: 2,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.45),
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                  spreadRadius: -1,
                ),
              ],
      ),
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 18, 18, 8),
              child: AnimatedBinCard(
                title: bin.id,
                percentage: bin.fillPercent.round(),
                status: bin.status,
                liquidColor: bin.color,
                dotColor: bin.color,
                useOuterCard: false,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '0%',
                        style: TextStyle(
                          color: AppC.subColor(context),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      '${bin.fillPercent.round()}%',
                      style: TextStyle(
                        color: bin.color,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        '100%',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: AppC.subColor(context),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MonitoringSummaryCard extends StatelessWidget {
  final List<SmartBinNode> bins;

  const MonitoringSummaryCard({
    super.key,
    required this.bins,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppC.isDark(context);
    final fullCount = bins.where((e) => e.isFull).length;
final almostCount = bins.where((e) => e.isAlmostFull).length;
final notFullCount = bins.where((e) => e.isNotFull).length;
final avg = bins.isEmpty
    ? 0
    : bins.map((e) => e.fillPercent).reduce((a, b) => a + b) / bins.length;
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFD2E2FB),
          width: isDark ? 1 : 1.3,
        ),
        gradient: isDark
            ? const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF162A56),
                  Color(0xFF0D1827),
                ],
              )
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF4B82DD),
                  Color(0xFF7FAAF2),
                ],
              ),
        boxShadow: isDark
            ? [
                BoxShadow(
                  color: AppC.blue.withOpacity(0.10),
                  blurRadius: 28,
                  spreadRadius: 1,
                ),
              ]
            : [
                BoxShadow(
                  color: const Color(0xFF3A84FF).withOpacity(0.28),
                  blurRadius: 40,
                  offset: const Offset(0, 18),
                  spreadRadius: 3,
                ),
                BoxShadow(
                  color: const Color(0xFF3A84FF).withOpacity(0.18),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 1,
                ),
                BoxShadow(
                  color: Colors.white.withOpacity(0.6),
                  blurRadius: 10,
                  offset: const Offset(0, 1),
                  spreadRadius: -1,
                ),
              ],
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: isDark
                ? const SizedBox.shrink()
                : const _LightSummaryWaveDecoration(),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: isDark
                      ? AppC.blue.withOpacity(0.18)
                      : Colors.white.withOpacity(0.10),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(
                  Icons.show_chart_rounded,
                  color: isDark ? const Color(0xFF79A8FF) : Colors.white,
                  size: 26,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Ringkasan Monitoring',
                style: TextStyle(
                  color: isDark
                      ? AppC.sub
                      : Colors.white.withOpacity(0.92),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${bins.length} Tempat Sampah Dipantau',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  height: 1.15,
                ),
              ),
              const SizedBox(height: 6),
Text(
  '$fullCount penuh, $almostCount hampir penuh, $notFullCount belum penuh  •  Rata-rata kepenuhan ${avg.toStringAsFixed(0)}%',
  maxLines: 2,
  overflow: TextOverflow.ellipsis,
  style: TextStyle(
    color: isDark
        ? AppC.sub
        : Colors.white.withOpacity(0.92),
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    height: 1.2,
  ),
),              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: isDark
                      ? Colors.white.withOpacity(0.03)
                      : Colors.white.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDark
                        ? Colors.white.withOpacity(0.05)
                        : Colors.white.withOpacity(0.24),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _DarkSummaryMetric(
                        color: AppC.green,
                        icon: Icons.delete_outline_rounded,
                        value: '${bins.length}',
                        label: 'Total Aktif',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _DarkSummaryMetric(
                        color: AppC.red,
                        icon: Icons.warning_amber_rounded,
                        value: '$fullCount',
                        label: 'Bin Penuh',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _DarkSummaryMetric(
                        color: AppC.blue,
                        icon: Icons.percent_rounded,
                        value: '${avg.toStringAsFixed(0)}%',
                        label: 'Rata-rata',
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
}

class _LightSummaryWaveDecoration extends StatelessWidget {
  const _LightSummaryWaveDecoration();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: CustomPaint(
        painter: _LightSummaryWavePainter(),
      ),
    );
  }
}

class _LightSummaryWavePainter extends CustomPainter {
  const _LightSummaryWavePainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = Colors.white.withOpacity(0.14)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6;

    final paint2 = Paint()
      ..color = const Color(0xFF8CB3F2).withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    Path makeWave(double startY, double amp, double shift) {
      final path = Path()..moveTo(0, startY);
      for (double x = 0; x <= size.width; x += 1) {
        final y =
            startY + math.sin((x / size.width) * math.pi * 2.3 + shift) * amp;
        path.lineTo(x, y);
      }
      return path;
    }

    canvas.drawPath(makeWave(size.height * 0.22, 8, 0.0), paint1);
    canvas.drawPath(makeWave(size.height * 0.26, 6, 1.1), paint2);
    canvas.drawPath(makeWave(size.height * 0.30, 5, 2.1), paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _LightSummaryMetric extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String value;
  final String label;

  const _LightSummaryMetric({
    required this.color,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.16),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color.withOpacity(0.12),
            ),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF23395B),
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  height: 1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF476487),
                  fontSize: 10.8,
                  fontWeight: FontWeight.w500,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DarkSummaryMetric extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String value;
  final String label;

  const _DarkSummaryMetric({
    required this.color,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withOpacity(0.14),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppC.text,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
                  height: 1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppC.sub,
                  fontSize: 10.8,
                  fontWeight: FontWeight.w500,
                  height: 1.15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LightMetricDivider extends StatelessWidget {
  const _LightMetricDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      color: Colors.white.withOpacity(0.32),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String value;
  final String label;

  const _SummaryMetric({
    required this.color,
    required this.icon,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: color.withOpacity(0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: AppC.text,
                  fontWeight: FontWeight.w800,
                  fontSize: 22,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppC.sub,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BlueLinePatternPainter extends CustomPainter {
  const _BlueLinePatternPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint1 = Paint()
      ..color = AppC.blue.withOpacity(0.18)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final paint2 = Paint()
      ..color = AppC.blue.withOpacity(0.10)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;

    Path makeWave(double startY, double amp, double shift) {
      final path = Path()..moveTo(0, startY);
      for (double x = 0; x <= size.width; x += 1) {
        final y = startY + math.sin((x / size.width) * math.pi * 3 + shift) * amp;
        path.lineTo(x, y);
      }
      return path;
    }

    canvas.drawPath(makeWave(size.height * 0.23, 10, 0.0), paint1);
    canvas.drawPath(makeWave(size.height * 0.28, 7, 1.4), paint2);
    canvas.drawPath(makeWave(size.height * 0.20, 6, 2.5), paint2);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}


class AnimatedBinCard extends StatefulWidget {
  final String title;
  final int percentage;
  final String status;
  final Color liquidColor;
  final Color dotColor;
  final bool useOuterCard;

  const AnimatedBinCard({
    super.key,
    required this.title,
    required this.percentage,
    required this.status,
    required this.liquidColor,
    required this.dotColor,
    this.useOuterCard = true,
  });

  @override
  State<AnimatedBinCard> createState() => _AnimatedBinCardState();
}

class _AnimatedBinCardState extends State<AnimatedBinCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  final isDark = AppC.isDark(context);

  final content = Column(
    children: [
      const SizedBox(height: 2),
      Text(
        widget.title,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isDark ? AppC.textColor(context) : Colors.white,
          fontSize: 17,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.2,
          height: 1.1,
        ),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: isDark
              ? widget.dotColor.withOpacity(0.10)
              : Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: isDark
                ? widget.dotColor.withOpacity(0.18)
                : Colors.white.withOpacity(0.18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: widget.dotColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: widget.dotColor.withOpacity(0.35),
                    blurRadius: 8,
                    spreadRadius: 1,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 7),
            Text(
              widget.status,
              style: TextStyle(
                color: widget.dotColor,
                fontSize: 13,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.1,
                height: 1,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 12),
      Expanded(
        child: Center(
          child: SizedBox(
            width: 118,
            height: 196,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: BinLiquidPainter(
                    percentage: widget.percentage / 100,
                    color: widget.liquidColor,
                    waveValue: _controller.value,
                    context: context,
                  ),
                );
              },
            ),
          ),
        ),
      ),
      const SizedBox(height: 10),
      Text(
        '${widget.percentage}%',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: widget.liquidColor,
          fontSize: 18,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.3,
          height: 1.1,
        ),
      ),
      const SizedBox(height: 6),
      Text(
        'Kepenuhan',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isDark
              ? AppC.subColor(context)
              : Colors.white.withOpacity(0.88),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.2,
          height: 1.1,
        ),
      ),
    ],
  );

  if (!widget.useOuterCard) {
    return content;
  }

  return Container(
    padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
    decoration: BoxDecoration(
      color: isDark ? AppC.panel : null,
      gradient: isDark
          ? null
          : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF4B82DD),
                Color(0xFF7FAAF2),
              ],
            ),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.05)
            : const Color(0xFFD2E2FB),
        width: 1.2,
      ),
      boxShadow: isDark
          ? [
              BoxShadow(
                color: Colors.blue.withOpacity(0.04),
                blurRadius: 24,
                spreadRadius: 1,
              ),
            ]
          : [
              BoxShadow(
                color: const Color(0xFF3A84FF).withOpacity(0.28),
                blurRadius: 36,
                offset: const Offset(0, 14),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: Colors.white.withOpacity(0.45),
                blurRadius: 10,
                offset: const Offset(0, 1),
                spreadRadius: -1,
              ),
            ],
    ),
    child: content,
  );
}
}

class BinLiquidPainter extends CustomPainter {
  final double percentage;
  final Color color;
  final double waveValue;
  final BuildContext context;

  BinLiquidPainter({
    required this.percentage,
    required this.color,
    required this.waveValue,
    required this.context,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final outlineColor =
    Theme.of(context).brightness == Brightness.dark
        ? const Color(0xFF96A9D0)
        : Colors.white.withOpacity(0.95);

    final lidRect = Rect.fromLTWH(26, 20, size.width - 52, 14);
    final lidLipRect = Rect.fromLTWH(30, 32, size.width - 60, 5);
    final handleRect = Rect.fromLTWH(size.width / 2 - 12, 10, 24, 8);


final bodyTopY = 42.0;
final bodyBottomY = size.height - 14.0;

// bikin body LEBIH TINGGI & TEGAK
final topLeft = Offset(30, bodyTopY);
final topRight = Offset(size.width - 30, bodyTopY);

final bottomLeft = Offset(34, bodyBottomY);
final bottomRight = Offset(size.width - 34, bodyBottomY);

final bodyPath = Path()
  ..moveTo(topLeft.dx, topLeft.dy)

  // sisi kiri (sedikit miring, bukan cekung)
  ..lineTo(bottomLeft.dx, bottomLeft.dy)

  // bawah
  ..quadraticBezierTo(
    size.width / 2,
    bodyBottomY + 6,
    bottomRight.dx,
    bottomRight.dy,
  )

  // sisi kanan
  ..lineTo(topRight.dx, topRight.dy)

  // bagian atas sedikit lengkung
  ..quadraticBezierTo(
    size.width / 2,
    bodyTopY - 6,
    topLeft.dx,
    topLeft.dy,
  )

  ..close();
  
    final lidPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(lidRect, const Radius.circular(8)),
      );

    final lidLipPath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(lidLipRect, const Radius.circular(4)),
      );

    final handlePath = Path()
      ..addRRect(
        RRect.fromRectAndRadius(handleRect, const Radius.circular(5)),
      );

    final glowPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

    final outlinePaint = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2;

    canvas.drawPath(bodyPath, glowPaint);
    canvas.drawPath(lidPath, glowPaint);

    canvas.drawPath(bodyPath, outlinePaint);
    canvas.drawPath(lidPath, outlinePaint);
    canvas.drawPath(lidLipPath, outlinePaint);
    canvas.drawPath(handlePath, outlinePaint);

    canvas.save();
    canvas.clipPath(bodyPath);

    final bodyHeight = bodyBottomY - bodyTopY;
    final liquidTop = bodyBottomY - (bodyHeight * percentage);

    final liquidPath = Path()..moveTo(bottomLeft.dx - 10, bodyBottomY + 20);

    for (double x = bottomLeft.dx - 10; x <= bottomRight.dx + 10; x++) {
      final relative = (x - (bottomLeft.dx - 10)) /
          ((bottomRight.dx + 10) - (bottomLeft.dx - 10));
      final y = liquidTop +
          math.sin((relative * math.pi * 2.35) + (waveValue * math.pi * 2)) * 4.2;
      liquidPath.lineTo(x, y);
    }

    liquidPath
      ..lineTo(bottomRight.dx + 10, bodyBottomY + 20)
      ..lineTo(bottomLeft.dx - 10, bodyBottomY + 20)
      ..close();

    final liquidPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          color.withOpacity(0.97),
          color.withOpacity(0.82),
        ],
      ).createShader(
        Rect.fromLTRB(
          bottomLeft.dx,
          liquidTop,
          bottomRight.dx,
          bodyBottomY + 12,
        ),
      );

    canvas.drawPath(liquidPath, liquidPaint);

    final bubblePaint = Paint()..color = Colors.white.withOpacity(0.18);
    final rand = math.Random(7);

    for (int i = 0; i < 14; i++) {
      final bx = bottomLeft.dx + 8 + rand.nextDouble() * ((bottomRight.dx - bottomLeft.dx) - 16);
      final by = liquidTop + 8 + rand.nextDouble() * math.max(12, bodyBottomY - liquidTop - 12);
      canvas.drawCircle(
        Offset(bx, by),
        rand.nextDouble() * 2.1 + 1.1,
        bubblePaint,
      );
    }

    canvas.restore();

    final shinePaint = Paint()
      ..color = Colors.white.withOpacity(0.20)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(topLeft.dx + 7, bodyTopY + 18, 7, 20),
        const Radius.circular(3),
      ),
      shinePaint,
    );
  }

  @override
  bool shouldRepaint(covariant BinLiquidPainter oldDelegate) {
    return oldDelegate.waveValue != waveValue ||
        oldDelegate.percentage != percentage ||
        oldDelegate.color != color;
  }
}

class MainMapAndList extends StatelessWidget {
  final List<SmartBinNode> bins;

  const MainMapAndList({
    super.key,
    required this.bins,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: MapPanel(bins: bins),
        ),
        const SizedBox(width: 18),
        Expanded(
          flex: 4,
          child: BinListPanel(bins: bins),
        ),
      ],
    );
  }
}

class MapPanel extends StatefulWidget {
  final List<SmartBinNode> bins;

  const MapPanel({
    super.key,
    required this.bins,
  });

  @override
  State<MapPanel> createState() => _MapPanelState();
}

class _MapPanelState extends State<MapPanel> {
final BinMapData depot = BinMapData(
  name: 'Depot Petugas - Telkom University Purwokerto',
  fillLevel: '-',
  status: 'Titik Awal',
  color: AppC.blue,
  location: const latlng.LatLng(-7.4352631, 109.2490926),
  googleMapsPlaceUrl: 'https://maps.app.goo.gl/s7Lcdam6neQeYr6Q6',
);

  BinMapData? selectedBin;

List<BinMapData> get bins => widget.bins.map((bin) {
  return BinMapData(
    name: bin.name,
    fillLevel: '${bin.fillPercent.round()}%',
    status: bin.status,
    color: bin.color,
    location: bin.position,
    googleMapsPlaceUrl: bin.googleMapsPlaceUrl,
  );
}).toList();
  String _addressFromName(String name) {
    if (name.contains('KOST MAYA')) return 'Kost Reika, Purwokerto';
    if (name.contains('KOST AI')) return 'Kost pelangi indah, Purwokerto';
    if (name.contains('KOST ZIDAN')) return 'Kost eyang medan, Purwokerto';
    return 'Purwokerto';
  }

Future<void> _openGoogleMaps(BinMapData bin) async {
  final url = Uri.parse(bin.googleMapsPlaceUrl);

  if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
    throw Exception('Tidak bisa membuka Google Maps');
  }
}
  @override
  Widget build(BuildContext context) {
final fullBins = bins.where((e) {
  final percent = double.tryParse(
        e.fillLevel.replaceAll('%', '').trim(),
      ) ??
      0;
  return percent >= 92;
}).toList();

final fullNodes = widget.bins.where((bin) => bin.fillPercent >= 92).toList();

final routePoints = fullNodes.isEmpty
    ? <latlng.LatLng>[]
    : <latlng.LatLng>[
        depot.location,
        ...fullNodes.map((e) => e.position),
      ];
          final initialCenter = bins.isNotEmpty ? bins.first.location : depot.location;

    return Container(
      height: 500,
      decoration: _panelBox(context),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: FlutterMap(
              options: MapOptions(
                initialCenter: initialCenter,
                initialZoom: 16,
                onTap: (_, _) {
                  setState(() {
                    selectedBin = null;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.smartbin',
                ),
                if (routePoints.length >= 2)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points: routePoints,
                        strokeWidth: 4,
                        color: AppC.blue,
                      ),
                    ],
                  ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: depot.location,
                      width: 100,
                      height: 100,
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedBin = depot;
                          });
                        },
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'DEPOT',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppC.blue,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppC.blue.withOpacity(0.5),
                                    blurRadius: 18,
                                    spreadRadius: 4,
                                  ),
                                ],
                              ),
                              child: const Icon(
                                Icons.local_shipping,
                                color: Colors.white,
                                size: 26,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    ...bins.map((bin) {
                      return Marker(
                        point: bin.location,
                        width: 95,
                        height: 95,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedBin = bin;
                            });
                          },
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.8),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(
                                  bin.fillLevel,
                                  style: TextStyle(
                                    color: bin.color,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: bin.color,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: bin.color.withOpacity(0.45),
                                      blurRadius: 18,
                                      spreadRadius: 4,
                                    ),
                                  ],
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ],
            ),
          ),

          if (selectedBin != null && selectedBin != depot)
            Positioned(
              left: 26,
              bottom: 24,
              child: Container(
                width: 270,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF0B1625).withOpacity(0.96),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: Colors.white.withOpacity(0.06)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            selectedBin!.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedBin = null;
                            });
                          },
                          child: const Icon(Icons.close, color: Colors.white70, size: 20),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                      decoration: BoxDecoration(
                        color: selectedBin!.color.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        '${selectedBin!.fillLevel} • ${selectedBin!.status}',
                        style: TextStyle(
                          color: selectedBin!.color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => _openGoogleMaps(selectedBin!),
                        icon: const Icon(Icons.map_outlined),
                        label: const Text('Buka Lokasi di Maps'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppC.blue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class BinMapData {
  final String name;
  final String fillLevel;
  final String status;
  final Color color;
  final latlng.LatLng location;
  final String googleMapsPlaceUrl;

  const BinMapData({
    required this.name,
    required this.fillLevel,
    required this.status,
    required this.color,
    required this.location,
    required this.googleMapsPlaceUrl,
  });
}

class _MapTopChip extends StatelessWidget {
  final String label;
  final bool active;

  const _MapTopChip({
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: active ? AppC.blue : const Color(0xFF18263B),
        borderRadius: BorderRadius.circular(12),
        boxShadow: active
            ? [
                BoxShadow(
                  color: AppC.blue.withOpacity(0.28),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                )
              ]
            : null,
      ),
      child: Center(
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : const Color(0xFFC0CCE0),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _MapZoomControls extends StatelessWidget {
  const _MapZoomControls();

  @override
  Widget build(BuildContext context) {
    Widget btn(IconData icon) {
      return Container(
        width: 44,
        height: 44,
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1625).withOpacity(0.95),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Icon(icon, color: Colors.white, size: 22),
      );
    }

    return Column(
      children: [
        btn(Icons.add),
        btn(Icons.remove),
        btn(Icons.my_location_rounded),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  const _LegendDot(this.color);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(radius: 5, backgroundColor: color);
  }
}

class _LegendLine extends StatelessWidget {
  const _LegendLine();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 3,
      decoration: BoxDecoration(
        color: AppC.blue,
        borderRadius: BorderRadius.circular(99),
      ),
    );
  }
}

class BinListPanel extends StatelessWidget {
  final List<SmartBinNode> bins;

  const BinListPanel({
    super.key,
    required this.bins,
  });

  String _addressFromName(String name) {
    if (name.contains('KOST MAYA')) return 'Kost Reika';
    if (name.contains('KOST AI')) return 'Kost pelangi indah';
    if (name.contains('KOST ZIDAN')) return 'Kost eyang medan';
    return 'Lokasi tidak diketahui';
  }

  String _statusText(double percent) {
    if (percent >= 92) return 'Penuh';
    if (percent >= 50) return 'Hampir Penuh';
    return 'Belum Penuh';
  }

  String _recommendation(double percent) {
    if (percent >= 92) {
      return 'Kondisi bin sudah penuh. Prioritaskan pengambilan secepatnya.';
    }
    if (percent >= 50) {
      return 'Kondisi bin hampir penuh. Perlu dipantau dan dijadwalkan pengambilan.';
    }
    return 'Kondisi bin masih aman. Belum perlu pengambilan.';
  }

String _sensorDistance(double percent) {
  const double tinggiTempatSampah = 27.0;
  final value =
      (tinggiTempatSampah - ((percent / 100) * tinggiTempatSampah))
          .clamp(0.0, tinggiTempatSampah)
          .round();
  return '$value cm';
}

String _trashHeight(double percent) {
  const double tinggiTempatSampah = 27.0;
  final jarakSensor =
      (tinggiTempatSampah - ((percent / 100) * tinggiTempatSampah))
          .clamp(0.0, tinggiTempatSampah);

  final tinggiSampah =
      (tinggiTempatSampah - jarakSensor).clamp(0.0, tinggiTempatSampah).round();

  return '$tinggiSampah cm';
}
void _showBinDetail(
  BuildContext context, {
  required SmartBinNode bin,
}) {
  final percent = bin.fillPercent.round();
  final status = _statusText(bin.fillPercent);

  showDialog(
    context: context,
    barrierColor: Colors.black.withOpacity(0.65),
    builder: (_) => BinDetailDialog(
      color: bin.color,
      name: bin.name,
      address: _addressFromName(bin.name),
      percent: '$percent%',
      status: status,
      trashHeight: _trashHeight(bin.fillPercent),
      sensorDistance: _sensorDistance(bin.fillPercent),
      gpsStatus: 'Akurat ± 3 m',
      latitude: bin.position.latitude.toStringAsFixed(6),
      longitude: bin.position.longitude.toStringAsFixed(6),
      lastPickup: 'Realtime dari Firebase',
      recommendation: _recommendation(bin.fillPercent),
    ),
  );
}
  @override
  Widget build(BuildContext context) {
    final fullCount = bins.where((e) => e.fillPercent >= 92).length;
    final almostCount =
        bins.where((e) => e.fillPercent >= 50 && e.fillPercent < 92).length;
    final notFullCount = bins.where((e) => e.fillPercent < 50).length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppC.isDark(context)
            ? const Color(0xFF132238)
            : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: AppC.isDark(context)
              ? Colors.white.withOpacity(0.04)
              : const Color(0xFFD7E2F0),
          width: 1.1,
        ),
        boxShadow: AppC.isDark(context)
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFFB8C7DB).withOpacity(0.30),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Daftar Tempat Sampah',
                  style: TextStyle(
                    color: AppC.textColor(context),
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Container(
                height: 38,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppC.blue.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(
                      Icons.filter_alt_outlined,
                      color: Color(0xFF7AA8FF),
                      size: 16,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Filter',
                      style: TextStyle(
                        color: Color(0xFF7AA8FF),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
const SizedBox(height: 14),

...List.generate(bins.length, (index) {
  final bin = bins[index];
  return Padding(
    padding: EdgeInsets.only(bottom: index == bins.length - 1 ? 14 : 10),
    child: BinListTile(
      color: bin.color,
      name: bin.name,
      address: _addressFromName(bin.name),
      percent: '${bin.fillPercent.round()}%',
      status: _statusText(bin.fillPercent),
      onTap: () => _showBinDetail(context, bin: bin),
    ),
  );
}),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppC.isDark(context)
                  ? AppC.panel.withOpacity(0.45)
                  : const Color(0xFFF7FAFE),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: AppC.isDark(context)
                    ? Colors.white.withOpacity(0.04)
                    : const Color(0xFFD7E2F0),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ringkasan Status',
                  style: TextStyle(
                    color: AppC.textColor(context),
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Total ${bins.length} bin aktif',
                  style: TextStyle(
                    color: AppC.subColor(context),
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _SummaryItem(
                        color: AppC.red,
                        label: '$fullCount Penuh',
                        value: '>= 92%',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SummaryItem(
                        color: AppC.yellow,
                        label: '$almostCount Hampir Penuh',
                        value: '50% - 91%',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _SummaryItem(
                        color: AppC.green,
                        label: '$notFullCount Belum Penuh',
                        value: '0% - 49%',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _SummaryItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppC.isDark(context)
            ? AppC.panel.withOpacity(0.55)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppC.isDark(context)
              ? Colors.white.withOpacity(0.04)
              : const Color(0xFFD7E2F0),
          width: 1.0,
        ),
        boxShadow: AppC.isDark(context)
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFFB8C7DB).withOpacity(0.22),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(radius: 5, backgroundColor: color),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppC.textColor(context),
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: AppC.subColor(context),
              fontSize: 12.5,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              minHeight: 6,
              value: 0.333,
              backgroundColor: AppC.isDark(context)
                  ? Colors.white10
                  : const Color(0xFFE5EDF7),
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class BinListTile extends StatelessWidget {
  final Color color;
  final String name;
  final String address;
  final String percent;
  final String status;
  final VoidCallback? onTap;

  const BinListTile({
    super.key,
    required this.color,
    required this.name,
    required this.address,
    required this.percent,
    required this.status,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 68,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppC.isDark(context)
                ? const Color(0xFF132238)
                : Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: AppC.isDark(context)
                  ? Colors.white.withOpacity(0.04)
                  : const Color(0xFFD7E2F0),
              width: 1.1,
            ),
            boxShadow: AppC.isDark(context)
                ? null
                : [
                    BoxShadow(
                      color: const Color(0xFFB8C7DB).withOpacity(0.30),
                      blurRadius: 18,
                      offset: const Offset(0, 6),
                    ),
                  ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.delete_outline_rounded, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: AppC.textColor(context),
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      address,
                      style: TextStyle(
                        color: AppC.subColor(context),
                        fontSize: 13.5,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    percent,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    status,
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 10),
              Icon(
                Icons.chevron_right_rounded,
                color: AppC.isDark(context)
                    ? Colors.white.withOpacity(0.6)
                    : AppC.subColor(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class BinDetailDialog extends StatelessWidget {
  final Color color;
  final String name;
  final String address;
  final String percent;
  final String status;
  final String trashHeight;
  final String sensorDistance;
  final String gpsStatus;
  final String latitude;
  final String longitude;
  final String lastPickup;
  final String recommendation;

  const BinDetailDialog({
    super.key,
    required this.color,
    required this.name,
    required this.address,
    required this.percent,
    required this.status,
    required this.trashHeight,
    required this.sensorDistance,
    required this.gpsStatus,
    required this.latitude,
    required this.longitude,
    required this.lastPickup,
    required this.recommendation,
  });

  Widget _topBadge({
    required IconData icon,
    required String text,
    required Color badgeColor,
  }) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: badgeColor.withOpacity(0.14),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: badgeColor.withOpacity(0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 10,
            color: badgeColor,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: badgeColor,
              fontSize: 9.5,
              fontWeight: FontWeight.w900,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required String value,
    required String label,
  }) {
    final isDark = AppC.isDark(context);

    return Expanded(
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 7),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF101D2F) : const Color(0xFFF7FAFE),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark
                ? Colors.white.withOpacity(0.06)
                : const Color(0xFFD7E2F0),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 27,
              height: 27,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.14),
                borderRadius: BorderRadius.circular(9),
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 15,
              ),
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppC.textColor(context),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppC.subColor(context),
                      fontSize: 8.8,
                      fontWeight: FontWeight.w700,
                      height: 1,
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

  Widget _mapPanel(BuildContext context) {
    final isDark = AppC.isDark(context);
    final lat = double.tryParse(latitude) ?? 0;
    final lng = double.tryParse(longitude) ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101D2F) : const Color(0xFFF7FAFE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : const Color(0xFFD7E2F0),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: FlutterMap(
  options: MapOptions(
    initialCenter: latlng.LatLng(lat, lng),
    initialZoom: 16,
    interactionOptions: const InteractionOptions(
      flags: InteractiveFlag.drag |
          InteractiveFlag.pinchZoom |
          InteractiveFlag.doubleTapZoom,
    ),
  ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.example.smartbin',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: latlng.LatLng(lat, lng),
                      width: 38,
                      height: 38,
                      child: Container(
                        decoration: BoxDecoration(
                          color: color,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: color.withOpacity(0.35),
                              blurRadius: 10,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.location_on_rounded,
                          color: Colors.white,
                          size: 21,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Positioned(
            left: 7,
            top: 7,
            child: Container(
              height: 23,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.72),
                borderRadius: BorderRadius.circular(999),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.map_outlined,
                    color: Colors.white,
                    size: 11,
                  ),
                  SizedBox(width: 4),
                  Text(
                    'Informasi Lokasi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 9.5,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            left: 7,
            right: 7,
            bottom: 7,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.72),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Lat: $latitude  •  Long: $longitude',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9.3,
                  fontWeight: FontWeight.w700,
                  height: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _rightPanel(BuildContext context) {
    final isDark = AppC.isDark(context);

    return Container(
      padding: const EdgeInsets.all(9),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101D2F) : const Color(0xFFF7FAFE),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.06)
              : const Color(0xFFD7E2F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.route_rounded,
                color: AppC.blue,
                size: 13,
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  'Ringkasan & Rekomendasi',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppC.textColor(context),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w900,
                    height: 1,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 7),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: color.withOpacity(0.20),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.delete_rounded,
                  color: color,
                  size: 13,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    status,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: color,
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 7),

          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppC.green.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: AppC.green.withOpacity(0.18),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(
                    Icons.tips_and_updates_outlined,
                    color: AppC.green,
                    size: 13,
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      recommendation,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppC.green,
                        fontSize: 9.2,
                        fontWeight: FontWeight.w800,
                        height: 1.25,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 7),

          SizedBox(
            width: double.infinity,
            height: 31,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(
                Icons.check_circle_outline_rounded,
                size: 13,
              ),
              label: const Text(
                'Selesaikan Pengambilan',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 9.8,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppC.blue,
                foregroundColor: Colors.white,
                elevation: 0,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = AppC.isDark(context);
    final screen = MediaQuery.of(context).size;

    final dialogWidth = math.min(screen.width - 18, 430.0);
    final dialogHeight = math.min(screen.height * 0.48, 360.0);

    final dialogBg = isDark ? AppC.panel : Colors.white;
    final borderColor =
        isDark ? Colors.white.withOpacity(0.07) : const Color(0xFFC7D5E8);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 9, vertical: 18),
      child: SizedBox(
        width: dialogWidth,
        height: dialogHeight,
        child: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: dialogBg,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.34),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 41,
                    height: 41,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.14),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      Icons.delete_rounded,
                      color: color,
                      size: 23,
                    ),
                  ),

                  const SizedBox(width: 9),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppC.textColor(context),
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          address,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: AppC.subColor(context),
                            fontSize: 9.8,
                            fontWeight: FontWeight.w600,
                            height: 1,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Flexible(
                              child: _topBadge(
                                icon: Icons.circle,
                                text: status,
                                badgeColor: color,
                              ),
                            ),
                            const SizedBox(width: 5),
                            Flexible(
                              child: _topBadge(
                                icon: Icons.sensors_rounded,
                                text: 'Sensor Aktif',
                                badgeColor: AppC.green,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 5),

                  InkWell(
                    borderRadius: BorderRadius.circular(999),
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 29,
                      height: 29,
                      decoration: BoxDecoration(
                        color: isDark
                            ? Colors.white.withOpacity(0.06)
                            : const Color(0xFFF1F5FB),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close_rounded,
                        color: AppC.subColor(context),
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Row(
                children: [
                  _summaryCard(
                    context: context,
                    icon: Icons.delete_outline_rounded,
                    iconColor: color,
                    value: percent,
                    label: 'Kepenuhan',
                  ),
                  const SizedBox(width: 6),
                  _summaryCard(
                    context: context,
                    icon: Icons.height_rounded,
                    iconColor: AppC.yellow,
                    value: trashHeight,
                    label: 'Tinggi Sampah',
                  ),
                  const SizedBox(width: 6),
                  _summaryCard(
                    context: context,
                    icon: Icons.sensors_rounded,
                    iconColor: AppC.blue,
                    value: sensorDistance,
                    label: 'Jarak Sensor',
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Expanded(
                child: Row(
                  children: [
                    Expanded(
                      flex: 6,
                      child: _mapPanel(context),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 5,
                      child: _rightPanel(context),
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
}
class _DetailInfoCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  final String label;
  final String subtitle;

  const _DetailInfoCard({
    required this.icon,
    required this.color,
    required this.value,
    required this.label,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = AppC.isDark(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F2035) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark
              ? Colors.white.withOpacity(0.05)
              : const Color(0xFFC7D5E8),
          width: isDark ? 1 : 1.35,
        ),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: const Color(0xFFB8C7DB).withOpacity(0.10),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: color,
            size: 22,
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              color: isDark ? AppC.text : const Color(0xFF23395B),
              fontSize: 18,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: isDark ? AppC.text : const Color(0xFF425B7E),
              fontSize: 13.5,
              fontWeight: FontWeight.w700,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: TextStyle(
              color: isDark ? AppC.sub : const Color(0xFF6E7F99),
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomPanelsRow extends StatelessWidget {
  final List<SmartBinNode> bins;
  final List<RiwayatPengambilan> riwayat;
  final List<AktivitasBinItem> aktivitasBin;
  final DateTime trendStartDate;
  final FirebaseRouteData firebaseRouteData;

  const BottomPanelsRow({
    super.key,
    required this.bins,
    required this.riwayat,
    required this.aktivitasBin,
    required this.trendStartDate,
    required this.firebaseRouteData,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: AktivitasBinPanel(
            aktivitasBin: aktivitasBin,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RekomendasiRuteDashboardPanel(
            bins: bins,
            firebaseRouteData: firebaseRouteData,
          ),
        ),
      ],
    );
  }
}
class RekomendasiRuteDashboardPanel extends StatelessWidget {
  final List<SmartBinNode> bins;
  final FirebaseRouteData firebaseRouteData;

  const RekomendasiRuteDashboardPanel({
    super.key,
    required this.bins,
    required this.firebaseRouteData,
  });

  List<SmartBinNode> _sortedBins() {
    final data = [...bins];
    data.sort((a, b) => b.fillPercent.compareTo(a.fillPercent));
    return data;
  }

  SmartBinNode? _topPriorityBin() {
    final sorted = _sortedBins();
    if (sorted.isEmpty) return null;
    return sorted.first;
  }

  String _shortBinName(SmartBinNode bin) {
    final match = RegExp(r'BIN-\d+', caseSensitive: false).firstMatch(bin.id);
    if (match != null) {
      return match.group(0)!.toUpperCase();
    }
    return bin.id.toUpperCase();
  }

  Color _binColor(double percent) {
    if (percent >= 92) return AppC.red;
    if (percent >= 50) return AppC.yellow;
    return AppC.green;
  }

  String _routeNodeLabel(String nodeId) {
    final cleanId = nodeId.toLowerCase().replaceAll('-', '');

    if (cleanId == 'tps') {
      return 'DEPOT';
    }

    if (cleanId.startsWith('bin')) {
      final number = RegExp(r'\d+').firstMatch(cleanId)?.group(0);
      return number == null ? nodeId.toUpperCase() : 'BIN-$number';
    }

    final node = firebaseRouteData.nodes[nodeId];
    if (node != null) {
      final label = node.label.toUpperCase();

      if (label.contains('TPS') || label.contains('DEPOT')) {
        return 'DEPOT';
      }

      final binMatch =
          RegExp(r'BIN[- ]?\d+', caseSensitive: false).firstMatch(label);

      if (binMatch != null) {
        return binMatch.group(0)!.replaceAll(' ', '-').toUpperCase();
      }
    }

    return nodeId.toUpperCase();
  }

  List<String> _routeLabels() {
    if (firebaseRouteData.route.isNotEmpty) {
      return firebaseRouteData.route.map(_routeNodeLabel).toList();
    }

    final sorted = _sortedBins();

    return [
      'DEPOT',
      ...sorted.take(3).map(_shortBinName),
    ];
  }

  String _distanceText() {
    if (firebaseRouteData.distanceKm <= 0) {
      return '-';
    }

    return '${firebaseRouteData.distanceKm.toStringAsFixed(1)} km';
  }

  String _estimateTimeText() {
    final distanceKm = firebaseRouteData.distanceKm;

    if (distanceKm <= 0) {
      return '-';
    }

    final activeBinCount = bins.where((e) => e.fillPercent > 0).length;

    final minutes = ((distanceKm / 18) * 60).ceil() + (activeBinCount * 2);

    if (minutes < 60) {
      return '$minutes m';
    }

    final hour = minutes ~/ 60;
    final minute = minutes % 60;

    return '${hour}j ${minute}m';
  }

  Future<void> _openPriorityRoute() async {
    final targetBin = _topPriorityBin();

    if (targetBin == null) return;

    final uri = Uri.parse(targetBin.googleMapsPlaceUrl);

    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sortedBins = _sortedBins();
    final routeLabels = _routeLabels();

    return Container(
      height: 430,
      padding: const EdgeInsets.all(12),
      decoration: _panelBox(context),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool mini = constraints.maxWidth < 220;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'REKOMENDASI RUTE',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppC.textColor(context),
                  fontSize: mini ? 9 : 14,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Urutan rute berdasarkan data Firebase',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppC.subColor(context),
                  fontSize: mini ? 7 : 11,
                  fontWeight: FontWeight.w600,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                width: double.infinity,
                padding: EdgeInsets.all(mini ? 7 : 10),
                decoration: BoxDecoration(
                  color: AppC.panelBgSoft(context),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppC.borderColor(context),
                  ),
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < routeLabels.length; i++) ...[
                        _routeNode(
                          context: context,
                          color: i == 0 ? AppC.blue : AppC.green,
                          icon: i == 0
                              ? Icons.local_shipping_rounded
                              : Icons.delete_rounded,
                          label: routeLabels[i],
                          mini: mini,
                        ),
                        if (i < routeLabels.length - 1)
                          _routeArrow(context, mini),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 10),

              for (int i = 0; i < sortedBins.take(3).length; i++) ...[
                _priorityItem(
                  context: context,
                  number: '${i + 1}',
                  color: _binColor(sortedBins[i].fillPercent),
                  title: 'Prioritas ${i + 1}: ${_shortBinName(sortedBins[i])}',
                  percent: '${sortedBins[i].fillPercent.toStringAsFixed(0)}%',
                  mini: mini,
                ),
                if (i != sortedBins.take(3).length - 1)
                  const SizedBox(height: 7),
              ],

              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: _miniInfo(
                      context: context,
                      icon: Icons.route_rounded,
                      title: 'Jarak',
                      value: _distanceText(),
                      mini: mini,
                    ),
                  ),
                  const SizedBox(width: 7),
                  Expanded(
                    child: _miniInfo(
                      context: context,
                      icon: Icons.access_time_rounded,
                      title: 'Waktu',
                      value: _estimateTimeText(),
                      mini: mini,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                height: mini ? 30 : 38,
                child: ElevatedButton.icon(
                  onPressed: _openPriorityRoute,
                  icon: Icon(
                    Icons.navigation_rounded,
                    size: mini ? 12 : 16,
                  ),
                  label: Text(
                    'Mulai Rute',
                    style: TextStyle(
                      fontSize: mini ? 9 : 12,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppC.green,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(11),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 7),

              Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppC.subColor(context),
                    size: mini ? 10 : 13,
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      'Rute, jarak, dan prioritas mengikuti data terbaru.',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppC.subColor(context),
                        fontSize: mini ? 7 : 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _routeNode({
    required BuildContext context,
    required Color color,
    required IconData icon,
    required String label,
    required bool mini,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: mini ? 22 : 30,
          height: mini ? 22 : 30,
          decoration: BoxDecoration(
            color: color.withOpacity(0.16),
            shape: BoxShape.circle,
            border: Border.all(
              color: color.withOpacity(0.35),
            ),
          ),
          child: Icon(
            icon,
            color: color,
            size: mini ? 11 : 15,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontSize: mini ? 6.8 : 9,
            fontWeight: FontWeight.w900,
          ),
        ),
      ],
    );
  }

  Widget _routeArrow(BuildContext context, bool mini) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: mini ? 5 : 7),
      child: Icon(
        Icons.arrow_forward_rounded,
        color: AppC.subColor(context),
        size: mini ? 10 : 14,
      ),
    );
  }

  Widget _priorityItem({
    required BuildContext context,
    required String number,
    required Color color,
    required String title,
    required String percent,
    required bool mini,
  }) {
    return Container(
      height: mini ? 31 : 38,
      padding: EdgeInsets.symmetric(horizontal: mini ? 7 : 9),
      decoration: BoxDecoration(
        color: AppC.panelBgSoft(context),
        borderRadius: BorderRadius.circular(11),
        border: Border.all(
          color: AppC.borderColor(context),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: mini ? 17 : 21,
            height: mini ? 17 : 21,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: mini ? 8 : 10,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),

          SizedBox(width: mini ? 6 : 8),

          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: AppC.textColor(context),
                fontSize: mini ? 8.2 : 11,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          Container(
            padding: EdgeInsets.symmetric(
              horizontal: mini ? 5 : 7,
              vertical: mini ? 3 : 4,
            ),
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              percent,
              style: TextStyle(
                color: color,
                fontSize: mini ? 7.5 : 9,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _miniInfo({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String value,
    required bool mini,
  }) {
    return Container(
      height: mini ? 42 : 52,
      padding: EdgeInsets.symmetric(horizontal: mini ? 7 : 10),
      decoration: BoxDecoration(
        color: AppC.panelBgSoft(context),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppC.borderColor(context),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: AppC.subColor(context),
            size: mini ? 12 : 16,
          ),

          SizedBox(width: mini ? 5 : 8),

          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppC.subColor(context),
                    fontSize: mini ? 7 : 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppC.textColor(context),
                    fontSize: mini ? 8.5 : 12,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
class OverviewHariIniPanel extends StatelessWidget {
  final List<SmartBinNode> bins;

  const OverviewHariIniPanel({
    super.key,
    required this.bins,
  });

  @override
  Widget build(BuildContext context) {
    final totalBins = bins.length;
    final amanCount = bins.where((e) => e.fillPercent < 50).length;
    final pantauCount =
        bins.where((e) => e.fillPercent >= 50 && e.fillPercent < 92).length;
    final penuhCount = bins.where((e) => e.fillPercent >= 92).length;

    final amanPercent = totalBins == 0 ? 0.0 : (amanCount / totalBins) * 100;
    final pantauPercent =
        totalBins == 0 ? 0.0 : (pantauCount / totalBins) * 100;
    final penuhPercent = totalBins == 0 ? 0.0 : (penuhCount / totalBins) * 100;

    final overallLabel = penuhCount > 0
        ? 'Ada Bin Penuh'
        : pantauCount > 0
            ? 'Perlu Dipantau'
            : 'Semua Aman';

    final overallColor = penuhCount > 0
        ? AppC.red
        : pantauCount > 0
            ? AppC.yellow
            : AppC.green;

    return Container(
      height: 430,
      padding: const EdgeInsets.all(20),
      decoration: _panelBox(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.delete_outline_rounded,
                color: AppC.teal,
                size: 24,
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OVERVIEW HARI INI',
                      style: TextStyle(
                        color: AppC.text,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Pantau Smart Bin Secara Langsung',
                      style: TextStyle(
                        color: AppC.sub,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 220,
                        height: 220,
                        child: CircularOverviewWidget(
                          totalBins: totalBins,
                          amanCount: amanCount,
                          pantauCount: pantauCount,
                          penuhCount: penuhCount,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        overallLabel,
                        style: TextStyle(
                          color: overallColor,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      StatusBadgeCard(
                        color: AppC.green,
                        title: 'AMAN',
                        count: '$amanCount Bin',
                        percent: '${amanPercent.toStringAsFixed(1)}%',
                      ),
                      const SizedBox(height: 14),
                      StatusBadgeCard(
                        color: AppC.yellow,
                        title: 'PERLU DIPANTAU',
                        count: '$pantauCount Bin',
                        percent: '${pantauPercent.toStringAsFixed(1)}%',
                      ),
                      const SizedBox(height: 14),
                      StatusBadgeCard(
                        color: AppC.red,
                        title: 'PENUH',
                        count: '$penuhCount Bin',
                        percent: '${penuhPercent.toStringAsFixed(1)}%',
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
}

class CircularOverviewWidget extends StatelessWidget {
  final int totalBins;
  final int amanCount;
  final int pantauCount;
  final int penuhCount;

  const CircularOverviewWidget({
    super.key,
    required this.totalBins,
    required this.amanCount,
    required this.pantauCount,
    required this.penuhCount,
  });

  @override
  Widget build(BuildContext context) {
    final amanFraction = totalBins == 0 ? 0.0 : amanCount / totalBins;
    final pantauFraction = totalBins == 0 ? 0.0 : pantauCount / totalBins;
    final penuhFraction = totalBins == 0 ? 0.0 : penuhCount / totalBins;

    return CustomPaint(
      painter: CircularOverviewPainter(
        amanFraction: amanFraction,
        pantauFraction: pantauFraction,
        penuhFraction: penuhFraction,
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '$totalBins',
              style: const TextStyle(
                color: AppC.text,
                fontSize: 60,
                fontWeight: FontWeight.w800,
                height: 1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'TOTAL BIN',
              style: TextStyle(
                color: AppC.sub,
                fontSize: 16,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CircularOverviewPainter extends CustomPainter {
  final double amanFraction;
  final double pantauFraction;
  final double penuhFraction;

  const CircularOverviewPainter({
    required this.amanFraction,
    required this.pantauFraction,
    required this.penuhFraction,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    const strokeWidth = 22.0;
    final radius = (size.width / 2) - strokeWidth;

    final bgPaint = Paint()
      ..color = Colors.white.withOpacity(0.08)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, bgPaint);

    double startAngle = -math.pi / 2;

    void drawArc(double fraction, Color color) {
      if (fraction <= 0) return;

      final sweepAngle = (math.pi * 2 * fraction) - 0.08;
      if (sweepAngle <= 0) return;

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle + 0.08;
    }

    drawArc(amanFraction, AppC.green);
    drawArc(pantauFraction, AppC.yellow);
    drawArc(penuhFraction, AppC.red);
  }

  @override
  bool shouldRepaint(covariant CircularOverviewPainter oldDelegate) {
    return oldDelegate.amanFraction != amanFraction ||
        oldDelegate.pantauFraction != pantauFraction ||
        oldDelegate.penuhFraction != penuhFraction;
  }
}

class StatusBadgeCard extends StatelessWidget {
  final Color color;
  final String title;
  final String count;
  final String percent;

  const StatusBadgeCard({
    super.key,
    required this.color,
    required this.title,
    required this.count,
    required this.percent,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.30)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withOpacity(0.14),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.delete_outline_rounded, color: color),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w800,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  count,
                  style: const TextStyle(
                    color: AppC.text,
                    fontWeight: FontWeight.w700,
                    fontSize: 17,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              percent,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AktivitasBinPanel extends StatelessWidget {
  final List<AktivitasBinItem> aktivitasBin;

  const AktivitasBinPanel({
    super.key,
    required this.aktivitasBin,
  });

  String _formatJam(DateTime waktu) {
    return '${waktu.hour.toString().padLeft(2, '0')}:${waktu.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final aktivitasTerbaru = aktivitasBin.take(5).toList();

    return Container(
      height: 430,
      padding: const EdgeInsets.all(20),
      decoration: _panelBox(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'AKTIVITAS BIN TERAKHIR',
            style: TextStyle(
              color: AppC.text,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            '5 aktivitas terbaru berdasarkan perubahan terakhir',
            style: TextStyle(
              color: AppC.sub,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: aktivitasTerbaru.isEmpty
                ? const Center(
                    child: Text(
                      'Belum ada aktivitas.',
                      style: TextStyle(
                        color: AppC.sub,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: aktivitasTerbaru.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, index) {
                      final item = aktivitasTerbaru[index];

                      return Row(
                        children: [
                          SizedBox(
                            width: 48,
                            child: Text(
                              _formatJam(item.waktu),
                              style: const TextStyle(
                                color: AppC.sub,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          Container(
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: item.color.withOpacity(0.18),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              item.icon,
                              color: item.color,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item.title,
                                  style: const TextStyle(
                                    color: AppC.text,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item.subtitle,
                                  style: const TextStyle(
                                    color: AppC.sub,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class ActivityItem extends StatelessWidget {
  final Color color;
  final String time;
  final String title;
  final String subtitle;

  const ActivityItem({
    super.key,
    required this.color,
    required this.time,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withOpacity(0.16),
                child: Icon(Icons.place_rounded, color: color, size: 20),
              ),
              const SizedBox(height: 6),
              Expanded(
                child: Container(
                  width: 2,
                  color: color.withOpacity(0.35),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2, bottom: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    time,
                    style: const TextStyle(
                      color: AppC.sub,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppC.text,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppC.sub,
                      fontSize: 13,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TrendLevelBinPanel extends StatelessWidget {
  final List<SmartBinNode> bins;
  final DateTime trendStartDate;

  const TrendLevelBinPanel({
    super.key,
    required this.bins,
    required this.trendStartDate,
  });

List<double> _trend(double current) {
  final now = DateTime.now();

  final start = DateTime(
    trendStartDate.year,
    trendStartDate.month,
    trendStartDate.day,
  );

  final today = DateTime(now.year, now.month, now.day);

  int totalDays = today.difference(start).inDays + 1;

  if (totalDays < 1) totalDays = 1;
  if (totalDays > 7) totalDays = 7;

  return List.generate(totalDays, (index) {
    return current.clamp(0, 100).toDouble();
  });
}

  @override
  Widget build(BuildContext context) {
    final shownBins = bins.take(3).toList();

    return Container(
      height: 430,
      padding: const EdgeInsets.all(20),
      decoration: _panelBox(context).copyWith(
        border: Border.all(
          color: AppC.purple.withOpacity(0.75),
          width: 1.4,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TREND LEVEL BIN (7 HARI TERAKHIR)',
                      style: TextStyle(
                        color: AppC.text,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Rata-rata level isi bin per hari',
                      style: TextStyle(
                        color: AppC.sub,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppC.teal.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.show_chart_rounded,
                  color: AppC.teal,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Expanded(
            child: Container(
              padding: const EdgeInsets.fromLTRB(10, 12, 10, 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0B1625),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Colors.white.withOpacity(0.05),
                ),
              ),
              child: CustomPaint(
                painter: TrendLevelChartPainter(
                  bins: shownBins,
                  trends: shownBins.map((bin) => _trend(bin.fillPercent)).toList(),
                ),
                child: const SizedBox.expand(),
              ),
            ),
          ),

          const SizedBox(height: 14),

          Row(
            children: shownBins.map((bin) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.only(right: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101D2F),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: Colors.white.withOpacity(0.05),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        bin.id,
                        style: TextStyle(
                          color: bin.color,
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '${bin.fillPercent.toStringAsFixed(0)}%',
                        style: const TextStyle(
                          color: AppC.text,
                          fontSize: 20,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        bin.status,
                        style: TextStyle(
                          color: bin.color,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
            decoration: BoxDecoration(
              color: AppC.blue.withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: const Row(
              children: [
                Icon(
                  Icons.info_outline_rounded,
                  color: AppC.blue,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'Data level berasal dari sensor ultrasonik',
                  style: TextStyle(
                    color: AppC.sub,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class TrendLevelChartPainter extends CustomPainter {
  final List<SmartBinNode> bins;
  final List<List<double>> trends;

  TrendLevelChartPainter({
    required this.bins,
    required this.trends,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.white.withOpacity(0.07)
      ..strokeWidth = 1;

    final textPainter = TextPainter(
      textDirection: TextDirection.ltr,
    );

    final chartLeft = 34.0;
    final chartTop = 10.0;
    final chartRight = size.width - 12;
    final chartBottom = size.height - 28;
    final chartWidth = chartRight - chartLeft;
    final chartHeight = chartBottom - chartTop;

    for (int i = 0; i <= 4; i++) {
      final y = chartTop + (chartHeight / 4) * i;
      canvas.drawLine(
        Offset(chartLeft, y),
        Offset(chartRight, y),
        gridPaint,
      );

      final label = '${100 - (i * 25)}%';
      textPainter.text = TextSpan(
        text: label,
        style: TextStyle(
          color: Colors.white.withOpacity(0.45),
          fontSize: 10,
          fontWeight: FontWeight.w600,
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(0, y - 7));
    }

final now = DateTime.now();

String namaBulan(int month) {
  const bulan = [
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
  return bulan[month - 1];
}

final labels = List.generate(7, (index) {
  final date = now.add(Duration(days: index));
  return '${date.day} ${namaBulan(date.month)}';
});

for (int i = 0; i < labels.length; i++) {
  final x = chartLeft + (chartWidth / 6) * i;
    textPainter.text = TextSpan(
    text: labels[i],
    style: TextStyle(
      color: Colors.white.withOpacity(0.45),
      fontSize: 9,
      fontWeight: FontWeight.w600,
    ),
  );
  textPainter.layout();
  textPainter.paint(canvas, Offset(x - 14, chartBottom + 8));
}
    for (int i = 0; i < trends.length; i++) {
      final bin = bins[i];
      final values = trends[i];

      final paint = Paint()
        ..color = bin.color
        ..strokeWidth = 3
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      final dotPaint = Paint()
        ..color = bin.color
        ..style = PaintingStyle.fill;

      final path = Path();

      for (int j = 0; j < values.length; j++) {
        final x = chartLeft + (chartWidth / 6) * j;
        final y = chartBottom - ((values[j] / 100) * chartHeight);

        if (j == 0) {
          path.moveTo(x, y);
        } else {
          path.lineTo(x, y);
        }

        canvas.drawCircle(Offset(x, y), 4, dotPaint);
      }

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant TrendLevelChartPainter oldDelegate) => true;
}

class LegendMini extends StatelessWidget {
  final Color color;
  final String text;

  const LegendMini({
    super.key,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 8),
        Text(
          text,
          style: const TextStyle(
            color: AppC.sub,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class GlowBinDot extends StatelessWidget {
  final Color color;

  const GlowBinDot({
    super.key,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.55),
            blurRadius: 18,
            spreadRadius: 8,
          ),
        ],
      ),
      child: const Center(
        child: Icon(
          Icons.delete_outline_rounded,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }
}

class MapGlowPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = Colors.white.withOpacity(0.05)
      ..strokeWidth = 2;

    final path1 = Path()
      ..moveTo(0, size.height * 0.2)
      ..lineTo(size.width * 0.35, 0)
      ..lineTo(size.width * 0.7, size.height * 0.18)
      ..lineTo(size.width, 0);

    final path2 = Path()
      ..moveTo(size.width * 0.1, size.height)
      ..lineTo(size.width * 0.25, size.height * 0.6)
      ..lineTo(size.width * 0.6, size.height * 0.78)
      ..lineTo(size.width * 0.9, size.height * 0.5);

    final path3 = Path()
      ..moveTo(0, size.height * 0.5)
      ..lineTo(size.width * 0.3, size.height * 0.3)
      ..lineTo(size.width * 0.55, size.height * 0.45)
      ..lineTo(size.width * 0.84, size.height * 0.25);

    canvas.drawPath(path1, linePaint);
    canvas.drawPath(path2, linePaint);
    canvas.drawPath(path3, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class InsightMiniCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String value;
  final String subtitle;
  final String badge;

  const InsightMiniCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.badge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      padding: const EdgeInsets.all(18),
      decoration: _panelBox(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.14),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppC.sub,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              height: 1.25,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppC.text,
              fontSize: 22,
              fontWeight: FontWeight.w800,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              subtitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppC.sub,
                fontSize: 14,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class RecommendationPanel extends StatelessWidget {
  const RecommendationPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF08163A),
            Color(0xFF091B46),
          ],
        ),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: const Color(0xFF475BFF).withOpacity(0.35),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF223CFF).withOpacity(0.16),
            blurRadius: 28,
            spreadRadius: 2,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFF6D63FF).withOpacity(0.32),
                      const Color(0xFF3F56C9).withOpacity(0.24),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.08),
                  ),
                ),
                child: const Text(
                  'REKOMENDASI HARI INI',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 16,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFF234EA8),
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E63D8).withOpacity(0.24),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Text(
                  'Lihat Insight Lengkap',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: RecommendationCard(
                  color: AppC.red,
                  badge: 'PRIORITAS UTAMA',
                  title: 'Jadwalkan BIN-07 & BIN-04',
                  desc:
                      'Keduanya sudah di atas 90%. Ambil dalam 1–2 jam ke depan agar tidak meluap.',
                  action: 'Buat Jadwal',
                  icon: Icons.warning_amber_rounded,
                ),
              ),
              SizedBox(width: 18),
              Expanded(
                child: RecommendationCard(
                  color: AppC.blue,
                  badge: 'OPTIMASI RUTE',
                  title: 'Mulai dari Cluster Selatan',
                  desc:
                      '3 bin berdekatan bisa diambil dalam 1 rute agar perjalanan lebih singkat dan rapi.',
                  action: 'Simulasi Rute',
                  icon: Icons.alt_route_rounded,
                ),
              ),
              SizedBox(width: 18),
              Expanded(
                child: RecommendationCard(
                  color: AppC.green,
                  badge: 'INSIGHT MENARIK',
                  title: 'Pola Peningkatan Sore Hari',
                  desc:
                      'Level kepenuhan paling tinggi muncul pada pukul 16:00–18:00 berdasarkan pembacaan sensor.',
                  action: 'Lihat Pola',
                  icon: Icons.lightbulb_outline_rounded,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class RecommendationCard extends StatelessWidget {
  final Color color;
  final String badge;
  final String title;
  final String desc;
  final String action;
  final IconData icon;

  const RecommendationCard({
    super.key,
    required this.color,
    required this.badge,
    required this.title,
    required this.desc,
    required this.action,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 255,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color.withOpacity(0.16),
            color.withOpacity(0.07),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: color.withOpacity(0.38),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.18),
            blurRadius: 24,
            spreadRadius: 1,
            offset: const Offset(0, 10),
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color.withOpacity(0.16),
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.22),
                  blurRadius: 18,
                  spreadRadius: 2,
                ),
              ],
              border: Border.all(
                color: color.withOpacity(0.26),
              ),
            ),
            child: Icon(
              icon,
              color: color,
              size: 34,
            ),
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.16),
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: color.withOpacity(0.25),
              ),
            ),
            child: Text(
              badge,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: 0.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withOpacity(0.98),
              fontWeight: FontWeight.w800,
              fontSize: 18,
              height: 1.28,
              shadows: [
                Shadow(
                  color: Colors.black.withOpacity(0.30),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Text(
              desc,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.white.withOpacity(0.78),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                height: 1.45,
                shadows: [
                  Shadow(
                    color: Colors.black.withOpacity(0.20),
                    blurRadius: 8,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '$action  →',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: 15,
              shadows: [
                Shadow(
                  color: color.withOpacity(0.18),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _panelBox(BuildContext context) {
  return BoxDecoration(
    color: AppC.panelBg(context),
    borderRadius: BorderRadius.circular(22),
    border: Border.all(color: AppC.borderColor(context), width: 1.2),
    boxShadow: AppC.panelShadow(context),
  );
}

class DonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final rect = Rect.fromCircle(center: center, radius: size.width / 2 - 12);

    final bgPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 22
      ..color = Colors.white.withOpacity(0.07)
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(rect, 0, math.pi * 2, false, bgPaint);

    final segments = [
      (AppC.green, 0.26),
      (AppC.yellow, 0.40),
      (AppC.red, 0.34),
    ];

    double start = -math.pi / 2;
    for (final s in segments) {
      final paint = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 22
        ..color = s.$1
        ..strokeCap = StrokeCap.round;
      final sweep = math.pi * 2 * s.$2;
      canvas.drawArc(rect, start, sweep, false, paint);
      start += sweep + 0.02;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class LineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final left = 48.0;
    final bottom = size.height - 34;
    final top = 18.0;
    final right = size.width - 18;

    final grid = Paint()
      ..color = Colors.white.withOpacity(0.06)
      ..strokeWidth = 1;

    for (int i = 0; i < 5; i++) {
      final y = top + (bottom - top) * i / 4;
      canvas.drawLine(Offset(left, y), Offset(right, y), grid);
    }

    for (int i = 0; i < 7; i++) {
      final x = left + (right - left) * i / 6;
      canvas.drawLine(Offset(x, top), Offset(x, bottom), grid);
    }

    final axisStyle = TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 12);
    final tp100 = TextPainter(
      text: TextSpan(text: '100%', style: axisStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    tp100.paint(canvas, Offset(2, top - 8));

    final tp75 = TextPainter(
      text: TextSpan(text: '75%', style: axisStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    tp75.paint(canvas, Offset(10, top + (bottom - top) * 0.25 - 8));

    final tp50 = TextPainter(
      text: TextSpan(text: '50%', style: axisStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    tp50.paint(canvas, Offset(10, top + (bottom - top) * 0.5 - 8));

    final tp25 = TextPainter(
      text: TextSpan(text: '25%', style: axisStyle),
      textDirection: TextDirection.ltr,
    )..layout();
    tp25.paint(canvas, Offset(10, top + (bottom - top) * 0.75 - 8));

    final points = [0.28, 0.62, 0.44, 0.74, 0.41, 0.53, 0.68];
    final path = Path();
    final offsets = <Offset>[];

    for (int i = 0; i < points.length; i++) {
      final x = left + (right - left) * i / 6;
      final y = bottom - (bottom - top) * points[i];
      offsets.add(Offset(x, y));
    }

    path.moveTo(offsets.first.dx, offsets.first.dy);
    for (int i = 0; i < offsets.length - 1; i++) {
      final p1 = offsets[i];
      final p2 = offsets[i + 1];
      final cx = (p1.dx + p2.dx) / 2;
      path.cubicTo(cx, p1.dy, cx, p2.dy, p2.dx, p2.dy);
    }

    final fillPath = Path.from(path)
      ..lineTo(offsets.last.dx, bottom)
      ..lineTo(offsets.first.dx, bottom)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [AppC.blue.withOpacity(0.35), AppC.blue.withOpacity(0.02)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTRB(left, top, right, bottom));

    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = AppC.blue
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    canvas.drawPath(path, linePaint);

    for (int i = 0; i < offsets.length; i++) {
      final isLast = i == offsets.length - 1;
      canvas.drawCircle(
        offsets[i],
        isLast ? 7 : 4,
        Paint()..color = AppC.blue,
      );
      if (isLast) {
        canvas.drawCircle(
          offsets[i],
          12,
          Paint()..color = AppC.blue.withOpacity(0.18),
        );
      }
    }

    final badgeRect = RRect.fromRectAndRadius(
      Rect.fromCenter(center: offsets.last.translate(-2, -30), width: 44, height: 28),
      const Radius.circular(8),
    );
    canvas.drawRRect(badgeRect, Paint()..color = AppC.blue);
    final tpBadge = TextPainter(
      text: const TextSpan(
        text: '68%',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    tpBadge.paint(canvas, offsets.last.translate(-22, -39));

    const labels = ['14 Mei', '15 Mei', '16 Mei', '17 Mei', '18 Mei', '19 Mei', '20 Mei'];
    for (int i = 0; i < labels.length; i++) {
      final tp = TextPainter(
        text: TextSpan(text: labels[i], style: axisStyle),
        textDirection: TextDirection.ltr,
      )..layout();
      final x = left + (right - left) * i / 6 - tp.width / 2;
      tp.paint(canvas, Offset(x, bottom + 10));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class MapBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFF091421);
    canvas.drawRect(Offset.zero & size, bg);

    final roadPaint = Paint()
      ..color = const Color(0xFF1A2C45)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    for (double x = 0; x < size.width; x += 34) {
      canvas.drawLine(Offset(x, 0), Offset(x - 60, size.height), roadPaint);
    }

    for (double y = 18; y < size.height; y += 28) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 16), roadPaint);
    }

    final routeBlue = Paint()
      ..color = const Color(0xFF59A6FF)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;

    final dashed = Paint()
      ..color = Colors.white.withOpacity(0.55)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    Path p1 = Path()
      ..moveTo(170, 250)
      ..lineTo(320, 160)
      ..lineTo(450, 210)
      ..lineTo(590, 120)
      ..lineTo(770, 180)
      ..lineTo(910, 130);
    canvas.drawPath(p1, routeBlue);

    Path p2 = Path()
      ..moveTo(600, 340)
      ..lineTo(720, 410)
      ..lineTo(860, 380)
      ..lineTo(980, 300);
    canvas.drawPath(p2, routeBlue);

    _drawDashedPath(
      canvas,
      Path()
        ..moveTo(520, 260)
        ..lineTo(630, 300)
        ..lineTo(720, 280)
        ..lineTo(820, 360),
      dashed,
    );

    void marker(Offset pos, Color color, IconData icon) {
      canvas.drawCircle(pos, 24, Paint()..color = color.withOpacity(0.18));
      canvas.drawCircle(pos, 18, Paint()..color = color);
    }

    marker(const Offset(320, 160), AppC.green, Icons.delete);
    marker(const Offset(455, 210), AppC.green, Icons.delete);
    marker(const Offset(595, 120), AppC.green, Icons.delete);
    marker(const Offset(770, 180), AppC.red, Icons.delete);
    marker(const Offset(910, 130), Colors.white, Icons.flag);
    marker(const Offset(600, 340), AppC.yellow, Icons.delete);
    marker(const Offset(720, 410), AppC.red, Icons.delete);
    marker(const Offset(860, 380), AppC.green, Icons.delete);
    marker(const Offset(170, 250), AppC.blue, Icons.local_shipping);

    _paintMapLabels(canvas);
  }

  void _paintMapLabels(Canvas canvas) {
    final labels = [
      (const Offset(410, 190), 'Taman Kota'),
      (const Offset(470, 320), 'Kota'),
      (const Offset(610, 315), 'Taman Kota'),
      (const Offset(850, 420), 'Pasar Induk'),
      (const Offset(915, 360), 'Pasar Yani'),
    ];

    for (final item in labels) {
     final tp = TextPainter(
  text: TextSpan(
    text: item.$2,
    style: const TextStyle(
      color: Colors.green,
      fontSize: 12,
      fontWeight: FontWeight.w600,
    ),
  ),
  textDirection: TextDirection.ltr,
)..layout();
      tp.paint(canvas, item.$1);
    }
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      while (distance < metric.length) {
        const dash = 10.0;
        const gap = 6.0;
        final extract = metric.extractPath(distance, distance + dash);
        canvas.drawPath(extract, paint);
        distance += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}