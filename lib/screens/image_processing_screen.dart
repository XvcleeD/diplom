// image_processing_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/io_client.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ImageProcessingScreen extends StatefulWidget {
  const ImageProcessingScreen({super.key});

  @override
  State<ImageProcessingScreen> createState() => _ImageProcessingScreenState();
}

class _ImageProcessingScreenState extends State<ImageProcessingScreen> {
  File? _selectedImage;
  List<drive.File> _driveImages = [];
  bool _showDriveGallery = false;
  bool _loadingDrive = false;
  bool _uploading = false;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _showDriveGallery = false;
        _driveImages = [];
      });
    }
  }

  Future<void> _signInAndLoadDriveImages() async {
    setState(() {
      _loadingDrive = true;
      _driveImages = [];
      _showDriveGallery = false;
      _selectedImage = null;
    });

    final googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveReadonlyScope]);
    final account = await googleSignIn.signIn();
    if (account == null) {
      setState(() {
        _loadingDrive = false;
      });
      return;
    }

    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    final fileList = await driveApi.files.list(
      q: "mimeType contains 'image/' and trashed = false",
      spaces: 'drive',
      $fields: "files(id, name, thumbnailLink, mimeType)",
    );

    setState(() {
      _loadingDrive = false;
      _driveImages = fileList.files ?? [];
      _showDriveGallery = true;
    });

    if (_driveImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Google Drive-д зураг алга байна')),
      );
    }
  }

  Future<void> _downloadAndSelectDriveImage(drive.File file) async {
    final googleSignIn = GoogleSignIn(scopes: [drive.DriveApi.driveReadonlyScope]);
    final account = await googleSignIn.signIn();
    if (account == null) return;

    final authHeaders = await account.authHeaders;
    final authenticateClient = GoogleAuthClient(authHeaders);
    final driveApi = drive.DriveApi(authenticateClient);

    final mediaStream = await driveApi.files.get(
      file.id!,
      downloadOptions: drive.DownloadOptions.fullMedia,
    ) as drive.Media;

    final List<int> bytes = [];
    await for (var chunk in mediaStream.stream) {
      bytes.addAll(chunk);
    }

    final tempDir = await getTemporaryDirectory();
    final fileOnDisk = File('${tempDir.path}/${file.name}');
    await fileOnDisk.writeAsBytes(bytes);

    setState(() {
      _selectedImage = fileOnDisk;
      _showDriveGallery = false;
      _driveImages = [];
    });
  }

  void _clearSelectedImage() {
    setState(() {
      _selectedImage = null;
      _showDriveGallery = false;
      _driveImages = [];
    });
  }

  Future<void> _uploadImageToFirebase() async {
    if (_selectedImage == null) return;

    setState(() {
      _uploading = true;
    });

    try {
      String fileName = 'images/${DateTime.now().millisecondsSinceEpoch}.jpg';

      final storageRef = FirebaseStorage.instance.ref().child(fileName);
      final uploadTask = storageRef.putFile(_selectedImage!);

      final snapshot = await uploadTask.whenComplete(() {});

      final downloadUrl = await snapshot.ref.getDownloadURL();

      await FirebaseFirestore.instance.collection('uploaded_images').add({
        'url': downloadUrl,
        'uploaded_at': FieldValue.serverTimestamp(),
      });

      setState(() {
        _uploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Зураг амжилттай хадгалагдлаа')),
      );

      _clearSelectedImage();
    } catch (e) {
      setState(() {
        _uploading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Алдаа гарлаа: $e')),
      );
    }
  }

  Widget _buildDriveGallery() {
    if (_loadingDrive) return const Center(child: CircularProgressIndicator());

    if (_driveImages.isEmpty) {
      return const Center(child: Text('Google Drive-с зураг олдсонгүй'));
    }

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _driveImages.length,
      itemBuilder: (context, index) {
        final file = _driveImages[index];
        final thumbnailUrl = file.thumbnailLink?.replaceFirst('=s220', '=s200');
        return GestureDetector(
          onTap: () => _downloadAndSelectDriveImage(file),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.purple.shade50,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: thumbnailUrl != null
                  ? Image.network(thumbnailUrl, fit: BoxFit.cover)
                  : Center(
                      child: Text(
                        file.name ?? '',
                        style: const TextStyle(fontSize: 12),
                        textAlign: TextAlign.center,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Зураг сонгох'),
        backgroundColor: Colors.purple.shade300,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Center(
                    child: _selectedImage == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.image, size: 100, color: Colors.purple.shade100),
                              const SizedBox(height: 12),
                              Text(
                                'Зураг байхгүй байна',
                                style: TextStyle(fontSize: 18, color: Colors.purple.shade200),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.contain,
                              width: double.infinity,
                            ),
                          ),
                  ),
                  if (_selectedImage != null)
                    Positioned(
                      top: 10,
                      right: 10,
                      child: CircleAvatar(
                        backgroundColor: Colors.black.withOpacity(0.6),
                        child: IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: _clearSelectedImage,
                        ),
                      ),
                    ),
                ],
              ),
            ),

            if (_showDriveGallery) Expanded(child: _buildDriveGallery()),

            const SizedBox(height: 20),

            if (_uploading)
              const CircularProgressIndicator(),

            if (!_uploading && _selectedImage != null)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _uploadImageToFirebase,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple.shade300,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.send),
                  label: const Text('Илгээх', style: TextStyle(fontSize: 16)),
                ),
              ),

            if (_selectedImage == null && !_showDriveGallery)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.photo_library),
                      label: const Text('Gallery-с авах'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade100,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _pickImageFromGallery,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      icon: const Icon(Icons.cloud_download),
                      label: const Text('Drive-с авах'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade100,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: _signInAndLoadDriveImages,
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = IOClient();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }
}
