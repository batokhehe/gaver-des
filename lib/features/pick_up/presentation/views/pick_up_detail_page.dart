import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class PickUpDetailPage extends StatefulWidget {
  const PickUpDetailPage({super.key});

  @override
  State<PickUpDetailPage> createState() => _PickUpDetailPageState();
}

class _PickUpDetailPageState extends State<PickUpDetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildContent()),
        ],
      ),
      bottomNavigationBar: _buildBottomButton(),
    );
  }

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

        Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(16, 54, 16, 0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () {},
                child: Icon(Icons.arrow_back, color: Colors.white),
              ),
              SizedBox(width: 12),
              Text(
                "Detail Pekerjaan",
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

  Widget _buildContent() {
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),

              // INFORMASI PENGIRIMAN
              _sectionTitle("Informasi Pengiriman"),
              const SizedBox(height: 8),
              _buildPickUpInfo(),

              const SizedBox(height: 16),

              // DAFTAR BARANG
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _sectionTitle("Daftar Barang"),
                  Text(
                    "+ Tambah Barang",
                    style: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              _buildItemList(),

              const SizedBox(height: 20),

              // FORM SERAH TERIMA
              _sectionTitle("Form Serah Terima (Opsional)"),
              const SizedBox(height: 12),
              _buildSerahTerimaForm(),

              const SizedBox(height: 20),

              // BUKTI PENGIRIMAN
              _sectionTitle("Bukti Pengiriman"),
              const SizedBox(height: 12),
              _buildBuktiPengiriman(),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  // ----------------------------
  // SECTION TITLE
  // ----------------------------
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
    );
  }

  // ----------------------------
  // INFORMASI PENGIRIMAN CARD
  // ----------------------------
  Widget _buildPickUpInfo() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "PKO.2025.11.0002",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text("Hub Jakarta Selatan"),
          SizedBox(height: 8),
          Divider(),
          Text(
            "Toko Andalan Sejahtera",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            "Jl. Gatot Subroto Blok B3 No. 12, Jakarta Selatan, DKI Jakarta",
          ),
        ],
      ),
    );
  }

  // ----------------------------
  // LIST BARANG
  // ----------------------------
  Widget _buildItemList() {
    return Column(
      children: [
        _itemCard("Minyak Goreng Kemasan 2L (Box 6 pcs)", "12", "144"),
        _itemCard("Tepung Terigu Premium 25kg", "8", "200"),
        _itemCard("Air Mineral Galon 19L", "10", "190"),
      ],
    );
  }

  Widget _itemCard(String title, String koli, String kg) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _qtyBox("Koli", koli),
              const SizedBox(width: 10),
              _qtyBox("Kg", kg),
              const Spacer(),
              const Icon(Icons.delete_outline, color: Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _qtyBox(String label, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 10)),
            Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  // ----------------------------
  // FORM SERAH TERIMA
  // ----------------------------
  Widget _buildSerahTerimaForm() {
    return Column(
      children: [
        _formTtdField("Diserahkan Oleh", "Toko Andalan Sejahtera"),
        const SizedBox(height: 12),
        _formTtdField("Diterima Oleh", "Garuda Verdana"),
        const SizedBox(height: 16),
        _orangeButton("Preview Serah Terima", () {}),
      ],
    );
  }

  Widget _formTtdField(String title, String name) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              Expanded(child: Text(name)),
              const Icon(Icons.edit, color: Colors.orange),
              const SizedBox(width: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  "TTD",
                  style: TextStyle(color: Colors.orange),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ----------------------------
  // BUKTI PENGIRIMAN
  // ----------------------------
  Widget _buildBuktiPengiriman() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          const Icon(Icons.image, size: 40, color: Colors.grey),
          const SizedBox(height: 6),
          const Text("Belum Ada Bukti Pengiriman"),
          const SizedBox(height: 10),
          _orangeButton("Unggah Bukti", () {}),
        ],
      ),
    );
  }

  // ----------------------------
  // BOTTOM BUTTON
  // ----------------------------
  Widget _buildBottomButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.white,
      child: _orangeButton("Selesaikan Tugas", () {}),
    );
  }

  // BUTTON STYLE
  Widget _orangeButton(String text, VoidCallback onTap) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.orange,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
