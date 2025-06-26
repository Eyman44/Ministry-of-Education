import 'package:flutter/material.dart';
import 'package:flutter_application_eyman/constant/color.dart';
import 'package:flutter_application_eyman/constant/image.dart';
import 'package:flutter_application_eyman/secreens/search_page.dart';
//import 'package:flutter_application_eyman/secreens/mark_page.dart';
import 'package:flutter_application_eyman/secreens/student_profile.dart';

class DataEntryPage extends StatelessWidget {
  const DataEntryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      body: Stack(
        children: [
          SizedBox.expand(
            child: Opacity(
              opacity: 0.4,
              child: Image.asset(
                AppImageAsset.s,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  child: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: AssetImage(AppImageAsset.logo),
                        radius: 24,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Ministry of Education',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColor.purple,
                        ),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.school, color: AppColor.purple, size: 20),
                    ],
                  ),
                ),
                const Spacer(),
                Center(
                  child: Card(
                    color: AppColor.backgroundcolor,
                    margin: const EdgeInsets.symmetric(horizontal: 24),
                    elevation: 8,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            'Data Entry Dashboard',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: AppColor.title,
                            ),
                          ),
                          const SizedBox(height: 20),
                          _buildNavButton(
                            context,
                            icon: Icons.search,
                            label: "Search Student",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const SearchPage()),
                              );
                            },
                          ),
                          const SizedBox(height: 12),
                          _buildNavButton(
                            context,
                            icon: Icons.person_add,
                            label: "Add Student",
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) => const StudentProfilePage()),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(BuildContext context,
      {required IconData icon,
      required String label,
      required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: AppColor.backgroundcolor),
        label: Text(
          label,
          style: const TextStyle(color: AppColor.backgroundcolor),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColor.purple,
          textStyle: const TextStyle(fontSize: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
