import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kalkulator BMI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const BMIScreen(),
    );
  }
}

class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});

  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  final _weightController = TextEditingController();
  final _heightController = TextEditingController();

  String _gender = 'Laki-laki';
  double? _bmi;
  String _result = '';

  bool get isFemale => _gender == 'Perempuan';

  Color get primary =>
      isFemale ? const Color(0xFFE96B98) : const Color(0xFF3978D4);

  Color get background =>
      isFemale ? const Color(0xFFFFF5F8) : const Color(0xFFF4F7FC);

  Color get softColor =>
      isFemale ? const Color(0xFFFFE4ED) : const Color(0xFFE2ECFC);

  void calculateBMI() {
    final weight = double.tryParse(
      _weightController.text.replaceAll(',', '.'),
    );
    final height = double.tryParse(
      _heightController.text.replaceAll(',', '.'),
    );

    if (weight == null ||
        height == null ||
        weight <= 0 ||
        height <= 0 ||
        weight > 500 ||
        height > 300) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Masukkan berat dan tinggi badan yang valid.'),
        ),
      );
      return;
    }

    final heightMeter = height / 100;
    final bmi = weight / (heightMeter * heightMeter);

    String result;

    if (bmi < 18.5) {
      result = 'Berat badan kurang';
    } else if (bmi < 25) {
      result = 'Berat badan ideal';
    } else if (bmi < 30) {
      result = 'Berat badan berlebih';
    } else {
      result = 'Obesitas';
    }

    setState(() {
      _bmi = bmi;
      _result = result;
    });
  }

  void resetBMI() {
    setState(() {
      _weightController.clear();
      _heightController.clear();
      _gender = 'Laki-laki';
      _bmi = null;
      _result = '';
    });
  }

  @override
  void dispose() {
    _weightController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        title: const Text(
          'Kalkulator BMI',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Yuk, cek BMI kamu!',
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: primary,
                ),
              ),
              
              const SizedBox(height: 25),

              // Jenis kelamin
              const Text(
                'Jenis Kelamin',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: genderOption(
                      'Laki-laki',
                      Icons.male,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: genderOption(
                      'Perempuan',
                      Icons.female,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Berat badan
              inputField(
                title: 'Berat Badan',
                unit: 'kg',
                hint: 'Masukkan berat badan',
                icon: Icons.monitor_weight_outlined,
                controller: _weightController,
              ),

              const SizedBox(height: 16),

              // Tinggi badan
              inputField(
                title: 'Tinggi Badan',
                unit: 'cm',
                hint: 'Masukkan tinggi badan',
                icon: Icons.height,
                controller: _heightController,
              ),

              const SizedBox(height: 24),

              // Tombol hitung
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: calculateBMI,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text(
                    'Hitung BMI',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Tombol reset
              SizedBox(
                width: double.infinity,
                height: 46,
                child: OutlinedButton(
                  onPressed: resetBMI,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: primary,
                    side: BorderSide(color: primary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                  child: const Text('Reset'),
                ),
              ),

              const SizedBox(height: 28),

              // Hasil
              const Text(
                'Hasil Perhitungan',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: softColor),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.monitor_heart_outlined,
                      size: 34,
                      color: primary,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'BMI ${_gender}',
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      _bmi?.toStringAsFixed(1) ?? '--',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    if (_bmi != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: softColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _result,
                          style: TextStyle(
                            color: primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    else
                      const Text(
                        'Hasil BMI akan muncul di sini',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black45,
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Panduan sederhana
              const Text(
                'Panduan BMI Dewasa',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),

              categoryRow('Di bawah 18,5', 'Berat badan kurang'),
              categoryRow('18,5 – 24,9', 'Normal'),
              categoryRow('25 – 29,9', 'Berat badan berlebih'),
              categoryRow('30 ke atas', 'Obesitas'),

              const SizedBox(height: 16),
              const Center(
                child: Text(
                  'Jaga kesehatanmu setiap hari.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black45,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget genderOption(String gender, IconData icon) {
    final selected = _gender == gender;

    return GestureDetector(
      onTap: () {
        setState(() {
          _gender = gender;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 17),
        decoration: BoxDecoration(
          color: selected ? softColor : Colors.white,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: selected ? primary : Colors.black12,
            width: selected ? 1.8 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(icon, size: 32, color: primary),
            const SizedBox(height: 7),
            Text(
              gender,
              style: TextStyle(
                color: selected ? primary : Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget inputField({
    required String title,
    required String unit,
    required String hint,
    required IconData icon,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 9),
        TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: primary),
            suffixText: unit,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: softColor),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(13),
              borderSide: BorderSide(color: primary, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  Widget categoryRow(String range, String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Text(
              range,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              color: Colors.black54,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
