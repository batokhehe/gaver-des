import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gaver_des/features/home/presentation/views/home_page.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth_provider.dart';
import 'forgot_password_view.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _obscure = true;

  void _doLogin() {
    final email = _email.text.trim();
    final pass = _pass.text.trim();

    // ========== VALIDASI ==========
    if (email.isEmpty) {
      _showError("Email tidak boleh kosong");
      return;
    }
    if (!email.contains('@')) {
      _showError("Format email tidak valid");
      return;
    }
    if (pass.isEmpty) {
      _showError("Password tidak boleh kosong");
      return;
    }

    ref.read(loginViewModelProvider.notifier).login(email, pass);
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    ref.listen(loginViewModelProvider, (prev, next) {
      next.whenOrNull(
        data: (success) {
          if (success == true) {
            context.go('/home');
          } else {
            _showError("Email atau password salah");
          }
        },
        error: (err, _) {
          _showError("Gagal login: $err");
        },
      );
    });

    final loginState = ref.watch(loginViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          _buildMainUI(size),

          // ========== LOADING ==========
          if (loginState.isLoading)
            Container(
              color: Colors.black38,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }

  Widget _buildMainUI(Size size) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // ================= HEADER IMAGE =================
          SizedBox(
            height: size.height * 0.42,
            width: double.infinity,
            child: Image.asset(
              "assets/images/bg_base.png",
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),

          Transform.translate(
            offset: const Offset(0, -30),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
              decoration: _boxDecoration(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Selamat Datang Kembali!",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "Masukkan kredensial Anda untuk masuk ke sistem pengiriman.",
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),

                  const SizedBox(height: 22),

                  // EMAIL FIELD
                  _label("Email Akun"),
                  _boxField(
                    controller: _email,
                    hint: "username@email.com",
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 16),

                  // PASSWORD FIELD
                  _label("Kata sandi"),
                  _boxField(
                    controller: _pass,
                    hint: "Tulis kata sandi akun",
                    icon: Icons.lock_outline,
                    obscure: _obscure,
                    suffix: IconButton(
                      icon: Icon(
                        _obscure ? Icons.visibility_off : Icons.visibility,
                      ),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),

                  const SizedBox(height: 22),

                  // BUTTON LOGIN
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFFD9541E),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: _doLogin,
                      child: const Text(
                        "Masuk Sekarang",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ForgotPasswordView(),
                          ),
                        );
                      },
                      child: const Text(
                        "Lupa Sandi",
                        style: TextStyle(
                          color: Color(0xFFD9541E),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 28),

                  Center(
                    child: Text(
                      "GaVer 1.0.0",
                      style: TextStyle(color: Colors.grey),
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

  // ================= REUSABLE WIDGETS =================

  Widget _label(String text) {
    return Column(
      children: [
        Text(text, style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 6),
      ],
    );
  }

  Widget _boxField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          prefixIcon: Icon(icon),
          suffixIcon: suffix,
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(28),
        topRight: Radius.circular(28),
      ),
      boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 12, offset: Offset(0, -2)),
      ],
    );
  }
}
