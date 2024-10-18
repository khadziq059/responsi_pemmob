import 'package:flutter/material.dart';
import 'package:pariwisata/bloc/pemandu_bloc.dart';
import 'package:pariwisata/model/pemandu.dart';
import 'package:pariwisata/ui/pemandu_page.dart';
import 'package:pariwisata/widget/warning_dialog.dart';

// ignore: must_be_immutable
class PemanduForm extends StatefulWidget {
  Pemandu? pemandu;
  PemanduForm({Key? key, this.pemandu}) : super(key: key);

  @override
  _PemanduFormState createState() => _PemanduFormState();
}

class _PemanduFormState extends State<PemanduForm> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String judul = "TAMBAH PEMANDU";
  String tombolSubmit = "SIMPAN";
  final _guideTextboxController = TextEditingController();
  final _languagesTextboxController = TextEditingController();
  final _ratingTextboxController = TextEditingController();

  // Custom Color Scheme
  final ColorScheme colorScheme = const ColorScheme(
    primary: Color(0xFF2E7D32),        // Dark Green
    secondary: Color(0xFFFFEB3B),       // Yellow
    surface: Color(0xFFF9FBE7),         // Light Yellow-Green
    background: Color(0xFFF1F8E9),      // Very Light Green
    error: Color(0xFFD32F2F),           // Error Red
    onPrimary: Colors.white,
    onSecondary: Colors.black87,
    onSurface: Color(0xFF1B5E20),       // Dark Green Text
    onBackground: Colors.black87,
    onError: Colors.white,
    brightness: Brightness.light,
  );

  // Custom Text Styles
  final textTheme = const TextTheme(
    titleLarge: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      letterSpacing: 1.2,
    ),
    labelLarge: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      letterSpacing: 0.5,
    ),
  );

  @override
  void initState() {
    super.initState();
    isUpdate();
  }

  isUpdate() {
    if (widget.pemandu != null) {
      setState(() {
        judul = "UBAH PEMANDU";
        tombolSubmit = "UBAH";
        _guideTextboxController.text = widget.pemandu!.guide!;
        _languagesTextboxController.text = widget.pemandu!.languages!;
        _ratingTextboxController.text = widget.pemandu!.rating.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colorScheme.primary,
        title: Text(
          judul,
          style: textTheme.titleLarge?.copyWith(
            color: colorScheme.onPrimary,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              color: colorScheme.surface,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildInputField(
                        controller: _guideTextboxController,
                        label: "Guide",
                        icon: Icons.person,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _languagesTextboxController,
                        label: "Language",
                        icon: Icons.language,
                      ),
                      const SizedBox(height: 20),
                      _buildInputField(
                        controller: _ratingTextboxController,
                        label: "Rating",
                        icon: Icons.star,
                        keyboardType: TextInputType.number,
                      ),
                      const SizedBox(height: 32),
                      _buildSubmitButton(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: colorScheme.primary),
        prefixIcon: Icon(icon, color: colorScheme.primary),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colorScheme.error),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return "$label harus diisi";
        }
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 4,
      ),
      onPressed: _isLoading ? null : _handleSubmit,
      child: _isLoading
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                strokeWidth: 2,
              ),
            )
          : Text(
              tombolSubmit,
              style: textTheme.labelLarge?.copyWith(
                color: colorScheme.onPrimary,
              ),
            ),
    );
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      widget.pemandu != null ? ubah() : simpan();
    }
  }

  void simpan() {
    setState(() => _isLoading = true);
    
    final createPemandu = Pemandu(
      id: null,
      guide: _guideTextboxController.text,
      languages: _languagesTextboxController.text,
      rating: int.parse(_ratingTextboxController.text),
    );

    PemanduBloc.addPemandu(pemandu: createPemandu).then(
      (value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PemanduPage()),
        );
      },
      onError: (error) {
        showDialog(
          context: context,
          builder: (_) => const WarningDialog(
            description: "Simpan gagal, silahkan coba lagi",
          ),
        );
      },
    ).whenComplete(() => setState(() => _isLoading = false));
  }

  void ubah() {
    setState(() => _isLoading = true);
    
    final updatePemandu = Pemandu(
      id: widget.pemandu!.id,
      guide: _guideTextboxController.text,
      languages: _languagesTextboxController.text,
      rating: int.parse(_ratingTextboxController.text),
    );

    PemanduBloc.updatePemandu(pemandu: updatePemandu).then(
      (value) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const PemanduPage()),
        );
      },
      onError: (error) {
        showDialog(
          context: context,
          builder: (_) => const WarningDialog(
            description: "Permintaan ubah data gagal, silahkan coba lagi",
          ),
        );
      },
    ).whenComplete(() => setState(() => _isLoading = false));
  }
}