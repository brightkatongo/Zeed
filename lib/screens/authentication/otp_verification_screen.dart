import 'package:flutter/material.dart';
import '../../providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String? emailOrPhone; // To display where OTP was sent

  const OtpVerificationScreen({super.key, this.emailOrPhone});

  @override
  ConsumerState<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

  @override
  void dispose() {
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() {
    final customColors = ref.read(customColorsProvider);
    final isEnglish = ref.read(isEnglishProvider);
    String otp = _otpControllers.map((c) => c.text).join();
    if (otp.length == 6) {
      // TODO: Implement OTP verification logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEnglish ? 'Verifying OTP: $otp (simulated)' : 'Kuwonetsetsa OTP: $otp (zoyerekezera)',
            style: TextStyle(color: customColors['surface']),
          ),
          backgroundColor: customColors['primary'],
        ),
      );
      // On successful verification, navigate to next screen (e.g., reset password or home)
      Navigator.pop(context); // For now, just go back
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEnglish ? 'Please enter a 6-digit OTP.' : 'Chonde lowetsani OTP ya manambala 6.',
            style: TextStyle(color: customColors['surface']),
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish ? 'OTP Verification' : 'Kuwonetsetsa OTP',
          style: TextStyle(color: customColors['surface']),
        ),
        backgroundColor: customColors['primary'],
        iconTheme: IconThemeData(color: customColors['surface']),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isEnglish ? 'Enter Verification Code' : 'Lowetsani Khodi Yowonetsetsa',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: customColors['text'],
                ),
              ),
              const SizedBox(height: 16),
              Text(
                isEnglish
                    ? 'A 6-digit code has been sent to ${widget.emailOrPhone ?? 'your email/phone'}.'
                    : 'Khodi ya manambala 6 yatulutsidwa ku ${widget.emailOrPhone ?? 'imelo/foni yanu'}.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: customColors['subText'],
                ),
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 45,
                    child: TextField(
                      controller: _otpControllers[index],
                      focusNode: _focusNodes[index],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      maxLength: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        counterText: "", // Hide the counter text
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
                        } else if (value.isEmpty && index > 0) {
                          FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
                        }
                        if (index == 5 && value.isNotEmpty) {
                          // Last digit entered, trigger verification
                          FocusScope.of(context).unfocus();
                        }
                      },
                    ),
                  );
                }),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _verifyOtp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: customColors['primary'],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isEnglish ? 'Verify' : 'Wonetsetsani',
                  style: TextStyle(fontSize: 18, color: customColors['surface']),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  // TODO: Implement resend OTP logic
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(isEnglish ? 'OTP Resent (simulated)!' : 'OTP Yatumizidwanso (zoyerekezera)!')),
                  );
                },
                child: Text(
                  isEnglish ? 'Resend Code' : 'Tumizani Khodi Kachiwiri',
                  style: TextStyle(color: customColors['secondary']),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}