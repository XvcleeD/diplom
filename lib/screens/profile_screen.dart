import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileScreen extends StatefulWidget {
  final String username;

  const ProfileScreen({super.key, required this.username});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _loading = true;
  final _formKey = GlobalKey<FormState>();

  final _controllers = {
    'fname': TextEditingController(),
    'lname': TextEditingController(),
    'Province': TextEditingController(),
    'nation': TextEditingController(),
    'regnum': TextEditingController(),
    'password': TextEditingController(),
  };

  final _editing = {
    'fname': false,
    'lname': false,
    'Province': false,
    'nation': false,
    'regnum': false,
    'password': false,
  };

  final Color backgroundColor = const Color(0xFFF4F1F8);
  final Color cardColor = const Color(0xFFE0D4F4);
  final Color accentColor = const Color(0xFFA084DC);
  final Color mainTextColor = const Color(0xFF3C3A4E);
  final Color subTextColor = const Color(0xFF7B6F9A);

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      var userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.username)
          .get();

      if (userDoc.exists) {
        var data = userDoc.data()!;
        _controllers['fname']!.text = data['fname'] ?? '';
        _controllers['lname']!.text = data['lname'] ?? '';
        _controllers['Province']!.text = data['Province'] ?? '';
        _controllers['nation']!.text = data['nation'] ?? '';
        _controllers['regnum']!.text = data['regnum'] ?? '';
        _controllers['password']!.text = data['password'] ?? '';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load data')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _saveField(String key) async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('users')
            .doc(widget.username)
            .update({key: _controllers[key]!.text});
        setState(() => _editing[key] = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Мэдээлэл амжилттай хадгалагдлаа')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Хадгалахад алдаа гарлаа')),
        );
      }
    }
  }

  Widget _buildRow(String key, String label) {
    final isEditing = _editing[key]!;
    final controller = _controllers[key]!;
    final isReadOnly = key == 'regnum' || key == 'nation';

    return Card(
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              flex: 2,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: mainTextColor,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 3,
              child: isReadOnly
                  ? Text(
                      controller.text,
                      style: TextStyle(color: subTextColor),
                    )
                  : isEditing
                      ? TextFormField(
                          controller: controller,
                          obscureText: key == 'password',
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          style: TextStyle(color: mainTextColor),
                          validator: (val) {
                            if (val == null || val.isEmpty) {
                              return 'Заавал бөглөнө үү';
                            }
                            if (key == 'password' && val.length < 6) {
                              return 'Нууц үг хамгийн багадаа 6 тэмдэгт байх ёстой';
                            }
                            return null;
                          },
                        )
                      : Text(
                          controller.text,
                          style: TextStyle(color: subTextColor),
                        ),
            ),
            isReadOnly
                ? const SizedBox.shrink()
                : IconButton(
                    icon: Icon(
                      isEditing ? Icons.check_circle : Icons.edit,
                      color: accentColor,
                    ),
                    onPressed: () {
                      if (isEditing) {
                        _saveField(key);
                      } else {
                        setState(() => _editing[key] = true);
                      }
                    },
                  ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text('Профайл'),
        backgroundColor: accentColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildRow('fname', 'Нэр'),
                    _buildRow('lname', 'Овог'),
                    _buildRow('Province', 'Аймаг'),
                    _buildRow('nation', 'Үндэс'),
                    _buildRow('regnum', 'Регистрийн дугаар'),
                    _buildRow('password', 'Нууц үг'),
                  ],
                ),
              ),
            ),
    );
  }
}
