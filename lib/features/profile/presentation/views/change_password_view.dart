import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  final _email = TextEditingController();
  final _oldPass = TextEditingController();
  final _newPass = TextEditingController();
  final _confirmPass = TextEditingController();

  bool _showChangeForm = false;

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  bool get has8Chars => _newPass.text.length >= 8;

  bool get hasUpper => _newPass.text.contains(RegExp(r'[A-Z]'));

  bool get hasLower => _newPass.text.contains(RegExp(r'[a-z]'));

  bool get hasNumber => _newPass.text.contains(RegExp(r'[0-9]'));

  bool get isMatch =>
      _confirmPass.text == _newPass.text && _confirmPass.text.isNotEmpty;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: SingleChildScrollView(
        child: Column(children: [_buildHeader(), _buildEmailForm()]),
      ),

      // ========== BUTTON ==============
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        color: Colors.white,
        child: SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFD9541E),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              setState(() => _showChangeForm = true);
            },
            child: const Text(
              "Selanjutnya",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // =================== HEADER ======================
  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: 150,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg_header.png"),
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
            ),
          ),
        ),
        Positioned(
          top: 54,
          left: 16,
          child: Row(
            children: const [
              Icon(Icons.arrow_back, color: Colors.white),
              SizedBox(width: 12),
              Text(
                "Ganti Sandi",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // =================== EMAIL FORM ======================
  Widget _buildEmailForm() {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        decoration: const BoxDecoration(
          color: AppColors.greyBg,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Masukan Detail Akun",
              style: AppTypography.smallBoldBlack,
            ),
            const Text(
              "Untuk mengganti sandi, Anda diminta untuk melengkapi data akun terlebih dahulu",
              style: AppTypography.smallNormalBlack,
            ),
            const SizedBox(height: 16),
            const Text("Email Akun", style: AppTypography.smallBoldBlack),
            const SizedBox(height: 8),
            _inputBox(
              controller: _email,
              hint: "contoh@email.com",
              icon: Icons.email_outlined,
            ),
            if (_showChangeForm) ...[
              const SizedBox(height: 16),
              const Text("Ganti Sandi", style: AppTypography.smallBoldBlack),
              const SizedBox(height: 8),
              _passwordCard(),
            ],
          ],
        ),
      ),
    );
  }

  // =================== PASSWORD CARD ======================
  Widget _passwordCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // === OLD PASSWORD ===
          const Text(
            "Kata sandi lama",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          _passwordTextField(
            _oldPass,
            _obscureOld,
            () => setState(() => _obscureOld = !_obscureOld),
          ),

          const SizedBox(height: 18),

          // === NEW PASSWORD ===
          const Text(
            "Kata Sandi Baru",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          _passwordTextField(
            _newPass,
            _obscureNew,
            () => setState(() => _obscureNew = !_obscureNew),
          ),

          const SizedBox(height: 12),
          _criteria(has8Chars, "8+ Karakter"),
          _criteria(hasUpper, "Huruf besar"),
          _criteria(hasLower, "Huruf kecil"),
          _criteria(hasNumber, "1 angka"),

          const SizedBox(height: 20),

          // === CONFIRM NEW PASSWORD ===
          const Text(
            "Konfirmasi Kata Sandi Baru",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          _passwordTextField(
            _confirmPass,
            _obscureConfirm,
            () => setState(() => _obscureConfirm = !_obscureConfirm),
          ),

          const SizedBox(height: 12),
          _criteria(isMatch, "Sandi baru sesuai"),
        ],
      ),
    );
  }

  Widget _inputBox({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: hint,
          border: InputBorder.none,
          prefixIcon: Icon(icon),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
        ),
      ),
    );
  }

  Widget _passwordTextField(
    TextEditingController controller,
    bool obs,
    VoidCallback toggle,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: TextField(
        controller: controller,
        obscureText: obs,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: "••••••••",
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          suffixIcon: IconButton(
            icon: Icon(obs ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }

  Widget _criteria(bool valid, String text) {
    return Row(
      children: [
        Image.asset(
          "assets/icons/ic_tick_square.png",
          width: 18,
          height: 18,
          color: valid ? Colors.green : Colors.grey,
        ),
        const SizedBox(width: 6),
        Text(
          text,
          style: TextStyle(
            color: valid ? Colors.green : Colors.black54,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}
