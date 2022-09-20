import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:system_info2/system_info2.dart';
import 'package:uwall/auth/signin_screen.dart';
import 'package:uwall/screens/about_app_screen.dart';
import 'package:uwall/screens/home_screen.dart';
import 'package:uwall/screens/privacy_policy_screen.dart';
import 'package:uwall/screens/profile_screen.dart';
import 'package:uwall/screens/submit_feedback_screen.dart';
import 'package:uwall/screens/terms_and_conditions_screen.dart';
import 'package:uwall/utils/colors.dart';
import 'package:uwall/utils/utils.dart';
import 'package:uwall/widgets/custom_rectangle.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String? fullName = "";
  String? email = "";
  String? photo = "";
  final cores = SysInfo.cores;
  final int megaByte = 1024 * 1024;
  bool isLoading = true;
  bool isUserLoggedIn = false;

  @override
  void initState() {
    super.initState();
    checkUserLoginState();
  }

  checkUserLoginState() {
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        isUserLoggedIn = true;
      });
      getData();
    }
    return isUserLoggedIn;
  }

  getData() async {
    setState(() {
      isLoading = true;
    });
    try {
      // user data
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then(
        (snapshot) async {
          if (snapshot.exists) {
            setState(() {
              fullName = snapshot.data()!['fullName'];
              email = snapshot.data()!['email'];
              photo = snapshot.data()!['photoUrl'];
            });
          }
        },
      );
    } catch (error) {
      showSnackBar(
        context,
        error.toString(),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                isUserLoggedIn
                    ? InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(
                              userId: FirebaseAuth.instance.currentUser!.uid,
                            ),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 100,
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 12.0, horizontal: 16),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(photo!),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 12.0),
                                        child: Text(
                                          fullName!,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      const Icon(
                                          Icons.arrow_forward_ios_rounded)
                                    ],
                                  ),
                                ),
                        ),
                      )
                    : CustomRectangle(
                        icon: Icons.account_circle_outlined,
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ontap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const SigninScreen(),
                          ),
                        ),
                      ),
                const SizedBox(
                  height: 10,
                ),
                CustomRectangle(
                  ontap: () {},
                  height: 250,
                  forward_icon: false,
                  icon: Icons.smartphone,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text(
                        'Device',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        """Kernel architecture: ${SysInfo.kernelArchitecture}
Kernel bitness: ${SysInfo.kernelBitness}
Kernel name: ${SysInfo.kernelName}
Kernel version: 
${SysInfo.kernelVersion}
Operating system name: ${SysInfo.operatingSystemName}
Operating system version: ${SysInfo.operatingSystemVersion}
User space bitness: ${SysInfo.userSpaceBitness}
Number of core: ${cores.length}
Total physical memory: ${SysInfo.getTotalPhysicalMemory() ~/ megaByte} MB
Free physical memory: ${SysInfo.getFreePhysicalMemory() ~/ megaByte}
Total virtual memory: ${SysInfo.getTotalVirtualMemory() ~/ megaByte}
Free virtual memory: ${SysInfo.getFreeVirtualMemory() ~/ megaByte}
Virtual memory size: ${SysInfo.getVirtualMemorySize() ~/ megaByte} MB """,
                        style: const TextStyle(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomRectangle(
                  icon: Icons.feedback_outlined,
                  child: const Text(
                    'Submit Feedback',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ontap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SubmitFeedbackScreen(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomRectangle(
                  icon: Icons.privacy_tip_outlined,
                  child: const Text(
                    'Privacy Policy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ontap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyScreen(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomRectangle(
                  icon: Icons.insert_drive_file_outlined,
                  child: const Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ontap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const TermsAndConditionsScreen(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomRectangle(
                  icon: Icons.perm_device_information_sharp,
                  child: const Text(
                    'About App',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  ontap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const AboutAppScreen(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                isUserLoggedIn
                    ? CustomRectangle(
                        icon: Icons.logout_rounded,
                        child: const Text(
                          'Logout',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ontap: () {
                          FirebaseAuth.instance.signOut();
                          showSnackBar(context, 'Logout successfully!');
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => const HomeScreen(),
                            ),
                          );
                        },
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
