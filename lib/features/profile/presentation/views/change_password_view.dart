import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../auth/providers/auth_provider.dart';

class ChangePasswordView extends ConsumerStatefulWidget {
  const ChangePasswordView({super.key});

  @override
  ConsumerState<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends ConsumerState<ChangePasswordView> {
  final _oldPass = TextEditingController();
  final _newPass = TextEditingController();
  final _confirmPass = TextEditingController();

  bool _showChangeForm = false;

  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;

  // ================= VALIDATION =================

  bool get has8Chars => _newPass.text.length >= 8;

  bool get hasUpper => _newPass.text.contains(RegExp(r'[A-Z]'));

  bool get hasLower => _newPass.text.contains(RegExp(r'[a-z]'));

  bool get hasNumber => _newPass.text.contains(RegExp(r'[0-9]'));

  bool get isMatch =>
      _confirmPass.text == _newPass.text && _confirmPass.text.isNotEmpty;

  bool get isFormValid {
    if (!_showChangeForm) {
      return _oldPass.text.isNotEmpty;
    }

    return _oldPass.text.isNotEmpty &&
        has8Chars &&
        hasUpper &&
        hasLower &&
        hasNumber &&
        isMatch;
  }

  Future<void> _submit() async {
    await ref
        .read(changePasswordViewModelProvider.notifier)
        .changePassword(
          currentPassword: _oldPass.text,
          newPassword: _newPass.text,
          confirmPassword: _confirmPass.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(changePasswordViewModelProvider);

    ref.listen(changePasswordViewModelProvider, (prev, next) {
      next.whenOrNull(
        data: (_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Password berhasil diubah")),
          );
          Navigator.pop(context);
        },
        error: (e, _) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        },
      );
    });

    return Scaffold(
      backgroundColor: AppColors.greyBg,
      body: SingleChildScrollView(
        child: Column(children: [_buildHeader(), _buildForm()]),
      ),
      bottomNavigationBar: _buildButton(state),
    );
  }

  // ================= BUTTON =================

  Widget _buildButton(AsyncValue state) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.white,
      child: SizedBox(
        height: 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isFormValid
                ? const Color(0xFFD9541E)
                : Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: isFormValid && !state.isLoading
              ? () async {
                  if (!_showChangeForm) {
                    setState(() => _showChangeForm = true);
                  } else {
                    await _submit();
                  }
                }
              : null,
          child: state.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  _showChangeForm ? "Simpan" : "Selanjutnya",
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
        ),
      ),
    );
  }

  // ================= HEADER =================

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
        const Positioned(
          top: 54,
          left: 16,
          child: Row(
            children: [
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

  // ================= FORM =================

  Widget _buildForm() {
    return Transform.translate(
      offset: const Offset(0, -30),
      child: Container(
        padding: const EdgeInsets.all(16),
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
            const SizedBox(height: 4),
            const Text(
              "Lengkapi data akun terlebih dahulu",
              style: AppTypography.smallNormalBlack,
            ),
            const SizedBox(height: 16),
            const Text("Kata sandi lama"),
            const SizedBox(height: 6),
            _passwordField(
              _oldPass,
              _obscureOld,
              () => setState(() => _obscureOld = !_obscureOld),
            ),
            if (_showChangeForm) ...[
              const SizedBox(height: 20),
              const Text(
                "Kata sandi baru",
                style: AppTypography.smallBoldBlack,
              ),
              const SizedBox(height: 8),
              _passwordCard(),
            ],
          ],
        ),
      ),
    );
  }

  // ================= PASSWORD CARD =================

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
          _passwordField(
            _newPass,
            _obscureNew,
            () => setState(() => _obscureNew = !_obscureNew),
          ),
          const SizedBox(height: 12),
          _criteria(has8Chars, "8+ karakter"),
          _criteria(hasUpper, "Huruf besar"),
          _criteria(hasLower, "Huruf kecil"),
          _criteria(hasNumber, "1 angka"),
          const SizedBox(height: 20),
          _passwordField(
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

  Widget _passwordField(
    TextEditingController controller,
    bool obscure,
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
        obscureText: obscure,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          hintText: "••••••••",
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 14,
            horizontal: 16,
          ),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
        ),
      ),
    );
  }

  Widget _criteria(bool valid, String text) {
    return Row(
      children: [
        Icon(
          Icons.check_circle,
          size: 18,
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
