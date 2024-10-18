import 'package:flutter/material.dart';
import 'package:pariwisata/bloc/pemandu_bloc.dart';
import 'package:pariwisata/model/pemandu.dart';
import 'package:pariwisata/ui/pemandu_form.dart';
import 'package:pariwisata/ui/pemandu_page.dart';
import 'package:pariwisata/widget/warning_dialog.dart';

// ignore: must_be_immutable
class PemanduDetail extends StatefulWidget {
  Pemandu? pemandu;
  PemanduDetail({Key? key, this.pemandu}) : super(key: key);
  @override
  _PemanduDetailState createState() => _PemanduDetailState();
}

class _PemanduDetailState extends State<PemanduDetail> {
  // Definisi warna kustom
  final primaryGreen = const Color(0xFF2E7D32);
  final secondaryYellow = const Color(0xFFFFEB3B);
  final lightYellow = const Color(0xFFFFFDE7);
  final errorRed = const Color(0xFFD32F2F);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: lightYellow,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Detail Pemandu',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryGreen,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [lightYellow, Colors.white],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Avatar Section
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: secondaryYellow.withOpacity(0.2),
                    border: Border.all(
                      color: primaryGreen,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: primaryGreen,
                  ),
                ),
                const SizedBox(height: 24),
                
                // Detail Card
                Container(
                  width: double.infinity,
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: primaryGreen.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    border: Border.all(
                      color: secondaryYellow.withOpacity(0.5),
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailItem(
                          icon: Icons.person,
                          label: "Guide",
                          value: widget.pemandu!.guide!,
                        ),
                        const SizedBox(height: 20),
                        _buildDetailItem(
                          icon: Icons.language,
                          label: "Languages",
                          value: widget.pemandu!.languages!,
                        ),
                        const SizedBox(height: 20),
                        _buildDetailItem(
                          icon: Icons.star,
                          label: "Rating",
                          value: widget.pemandu!.rating.toString(),
                          isRating: true,
                        ),
                        const SizedBox(height: 32),
                        _tombolHapusEdit(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailItem({
    required IconData icon,
    required String label,
    required String value,
    bool isRating = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: primaryGreen,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: secondaryYellow.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: secondaryYellow.withOpacity(0.5),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: primaryGreen,
                size: 24,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: primaryGreen,
                  ),
                ),
              ),
              if (isRating)
                Row(
                  children: List.generate(
                    5,
                    (index) => Icon(
                      Icons.star,
                      size: 20,
                      color: index < double.parse(value)
                          ? secondaryYellow
                          : secondaryYellow.withOpacity(0.3),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _tombolHapusEdit() {
    return Row(
      children: [
        // Tombol Edit
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryGreen,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.edit),
            label: const Text(
              "EDIT",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PemanduForm(
                    pemandu: widget.pemandu!,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 12),
        // Tombol Hapus
        Expanded(
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: errorRed,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            icon: const Icon(Icons.delete),
            label: const Text(
              "DELETE",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () => confirmHapus(),
          ),
        ),
      ],
    );
  }

  void confirmHapus() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: errorRed, size: 28),
            const SizedBox(width: 8),
            const Text("Konfirmasi Hapus"),
          ],
        ),
        content: const Text(
          "Yakin ingin menghapus data ini?",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          TextButton(
            child: const Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: errorRed,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text("Hapus"),
            onPressed: () {
              PemanduBloc.deletePemandu(id: widget.pemandu!.id!).then(
                (value) => {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const PemanduPage(),
                    ),
                  )
                },
                onError: (error) {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => const WarningDialog(
                      description: "Hapus gagal, silahkan coba lagi",
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}