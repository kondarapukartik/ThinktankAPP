import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const Color neonBlue = Color(0xFF00F1FF);
const Color darkBackground = Color(0xFF121212);

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  File? profileImage;

  final nameController = TextEditingController();
  final bioController = TextEditingController();

  bool isEditing = false;
  bool isLoading = true;

  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    loadProfile();
  }

  Future loadProfile() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get();

    if (doc.exists) {
      var data = doc.data() as Map<String, dynamic>;

      nameController.text = data["name"] ?? "";
      bioController.text = data["bio"] ?? "";
    }

    setState(() {
      isLoading = false;
    });
  }

  Future saveProfile() async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .update({"name": nameController.text, "bio": bioController.text});

    setState(() {
      isEditing = false;
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text("Profile Updated")));
  }

  Future pickImage() async {
    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        profileImage = File(pickedFile.path);
      });
    }
  }

  Future logout() async {
    await FirebaseAuth.instance.signOut();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: darkBackground,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: darkBackground,
      appBar: AppBar(
        backgroundColor: darkBackground,
        title: const Text("Profile"),
        actions: [
          IconButton(
            icon: Icon(isEditing ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                isEditing = !isEditing;
              });
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            const SizedBox(height: 30),

            Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: neonBlue.withOpacity(0.7),
                        blurRadius: 25,
                        spreadRadius: 3,
                      )
                    ],
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: profileImage != null
                        ? FileImage(profileImage!)
                        : const AssetImage("images/avatar.png")
                            as ImageProvider,
                  ),
                ),
                if (isEditing)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FloatingActionButton(
                      mini: true,
                      backgroundColor: neonBlue,
                      onPressed: pickImage,
                      child: const Icon(Icons.camera_alt, color: Colors.black),
                    ),
                  )
              ],
            ),

            const SizedBox(height: 20),

            Text(
              user!.email ?? "",
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 35),

            // NAME
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isEditing
                  ? TextField(
                      controller: nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: const Color(0xFF1F1F1F),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  : Text(
                      nameController.text.isEmpty
                          ? "Add your name"
                          : nameController.text,
                      key: const ValueKey("nameDisplay"),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),

            const SizedBox(height: 15),

            // BIO
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isEditing
                  ? TextField(
                      controller: bioController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Bio",
                        labelStyle: const TextStyle(color: Colors.white),
                        filled: true,
                        fillColor: const Color(0xFF1F1F1F),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    )
                  : Text(
                      bioController.text.isEmpty
                          ? "Add your bio"
                          : bioController.text,
                      key: const ValueKey("bioDisplay"),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
            ),

            const SizedBox(height: 35),

            if (isEditing)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: saveProfile,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: neonBlue,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                  ),
                  child: const Text(
                    "Save Profile",
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text("Logout"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
