import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../constants.dart';


const List<String> mongolianAlphabets = [
  'А', 'Б', 'В', 'Г', 'Д', 'Е', 'Ё', 'Ж', 'З', 'И', 'Й', 'К', 'Л',
  'М', 'Н', 'О', 'Ө', 'П', 'Р', 'С', 'Т', 'У', 'Ү', 'Ф', 'Х', 'Ц',
  'Ч', 'Ш', 'Щ', 'Ъ', 'Ы', 'Ь', 'Э', 'Ю', 'Я'
];

const List<String> mongolianProvinces = [
  'Архангай', 'Баян-Өлгий', 'Баянхонгор', 'Булган', 'Говь-Алтай', 
  'Говьсүмбэр', 'Дархан-Уул', 'Дорноговь', 'Дорнод', 'Дундговь', 
  'Завхан', 'Орхон', 'Өвөрхангай', 'Өмнөговь', 'Сүхбаатар', 
  'Сэлэнгэ', 'Төв', 'Увс', 'Ховд', 'Хөвсгөл', 'Хэнтий', 'Улаанбаатар'
];
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fnameController = TextEditingController();
  final _lnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _regnumNumberController = TextEditingController();

  String? _province;
  String _nation = "Монгол";
  String? _regnumFirstChar;
  String? _regnumSecondChar;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _isMongolianAlphabet(String input) {
    final reg = RegExp(r'^[А-ЯӨҮЁЁа-яөүёё]+$');
    return reg.hasMatch(input);
  }

  @override
  void dispose() {
    _fnameController.dispose();
    _lnameController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _regnumNumberController.dispose();
    super.dispose();
  }

  void _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (_regnumFirstChar == null || _regnumSecondChar == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select regnum initials')),
      );
      return;
    }

    final regnum = '$_regnumFirstChar$_regnumSecondChar${_regnumNumberController.text}';

    try {
      await FirebaseFirestore.instance.collection('users').add({
        'fname': _fnameController.text,
        'lname': _lnameController.text,
        'username': _usernameController.text,
        'password': _passwordController.text,
        'nation': _nation,
        'province': _province,
        'regnum': regnum,
        'createddate': DateTime.now().toIso8601String(),
      });

      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeColor = const Color(0xFF7E5A9B); // Lavender Purple
    final lightLavender = const Color(0xFFF2ECF9);

    return Scaffold(
      backgroundColor: lightLavender,
      appBar: AppBar(
        backgroundColor: themeColor,
        title: const Text('Create Account'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    'Welcome!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: themeColor),
                  ),
                  const SizedBox(height: 4),
                  const Text('Fill out the form below to create an account'),
                  const SizedBox(height: 20),

                  _buildTextField('First Name', _fnameController, validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    if (!_isMongolianAlphabet(val)) return 'Use Mongolian characters only';
                    return null;
                  }),

                  _buildTextField('Last Name', _lnameController, validator: (val) {
                    if (val == null || val.isEmpty) return 'Required';
                    if (!_isMongolianAlphabet(val)) return 'Use Mongolian characters only';
                    return null;
                  }),

                  _buildTextField('Username', _usernameController),

                  _buildPasswordField('Password', _passwordController, _obscurePassword, () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  }),

                  _buildPasswordField('Confirm Password', _confirmPasswordController, _obscureConfirmPassword, () {
                    setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                  }),

                  _buildTextField('Nation', TextEditingController(text: _nation), enabled: false),

                  _buildDropdownField(
                    'Province',
                    value: _province,
                    items: mongolianProvinces,
                    onChanged: (val) => setState(() => _province = val),
                  ),

                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDropdownField(
                          'Regnum 1',
                          value: _regnumFirstChar,
                          items: mongolianAlphabets,
                          onChanged: (val) => setState(() => _regnumFirstChar = val),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildDropdownField(
                          'Regnum 2',
                          value: _regnumSecondChar,
                          items: mongolianAlphabets,
                          onChanged: (val) => setState(() => _regnumSecondChar = val),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: _buildTextField(
                          'Regnum Digits',
                          _regnumNumberController,
                          keyboardType: TextInputType.number,
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Required';
                            if (!RegExp(r'^\d+$').hasMatch(val)) return 'Digits only';
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: themeColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _signUp,
                      child: const Text('Sign Up', style: TextStyle(fontSize: 16)),
                    ),
                  ),

                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () => Navigator.pushNamed(context, AppRoutes.signIn),
                        child: Text('Sign In', style: TextStyle(color: themeColor)),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool enabled = true, TextInputType keyboardType = TextInputType.text, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF8F4FC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        keyboardType: keyboardType,
        validator: validator ?? (val) => val == null || val.isEmpty ? 'Required' : null,
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller, bool obscure, VoidCallback toggle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscure,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF8F4FC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: IconButton(
            icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
            onPressed: toggle,
          ),
        ),
        validator: (val) {
          if (val == null || val.isEmpty) return 'Required';
          if (val.length < 6) return 'At least 6 characters';
          return null;
        },
      ),
    );
  }

  Widget _buildDropdownField(String label,
      {required String? value,
      required List<String> items,
      required void Function(String?) onChanged}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF8F4FC),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
        onChanged: onChanged,
        validator: (val) => val == null || val.isEmpty ? 'Required' : null,
      ),
    );
  }
}
