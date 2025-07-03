import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart'; // Adjust path as needed

class LoanApplicationScreen extends ConsumerStatefulWidget {
  const LoanApplicationScreen({super.key});

  @override
  ConsumerState<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends ConsumerState<LoanApplicationScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _loanType;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _purposeController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  void _submitApplication() {
    final isEnglish = ref.read(isEnglishProvider);
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      // TODO: Implement actual loan application submission logic
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isEnglish
                ? 'Loan Application Submitted for $_loanType: K${_amountController.text} for ${_purposeController.text}'
                : 'Pempho la Ngongole Latumizidwa kwa $_loanType: K${_amountController.text} chifukwa cha ${_purposeController.text}',
          ),
        ),
      );
      Navigator.pop(context); // Go back after submission
    }
  }

  @override
  Widget build(BuildContext context) {
    final customColors = ref.watch(customColorsProvider);
    final isEnglish = ref.watch(isEnglishProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isEnglish ? 'Loan Application' : 'Pempho la Ngongole',
          style: TextStyle(color: customColors['surface']),
        ),
        backgroundColor: customColors['primary'],
        iconTheme: IconThemeData(color: customColors['surface']),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text(
                isEnglish ? 'Fill in the details for your loan application.' : 'Lembani zambiri za pempho lanu la ngongole.',
                style: TextStyle(fontSize: 16, color: customColors['text']!.withOpacity(0.8)),
              ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: isEnglish ? 'Loan Type' : 'Mtundu wa Ngongole',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                value: _loanType,
                items: <String>[
                  isEnglish ? 'Crop Production Loan' : 'Ngongole Yolima',
                  isEnglish ? 'Farm Equipment Loan' : 'Ngongole Yogula Zida Za Famu',
                  isEnglish ? 'Livestock Development Loan' : 'Ngongole Yowonjezera Ziweto',
                  isEnglish ? 'Emergency Loan' : 'Ngongole Yadzidzidzi',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _loanType = newValue;
                  });
                },
                validator: (value) => value == null ? (isEnglish ? 'Please select a loan type' : 'Chonde sankhani mtundu wa ngongole') : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(
                  labelText: isEnglish ? 'Desired Amount (ZMW)' : 'Ndalama Zofunikira (ZMW)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isEnglish ? 'Please enter a desired amount' : 'Chonde lowetsani ndalama zofunikira';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return isEnglish ? 'Please enter a valid amount' : 'Chonde lowetsani ndalama zovomerezeka';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _purposeController,
                decoration: InputDecoration(
                  labelText: isEnglish ? 'Purpose of Loan' : 'Chifukwa cha Ngongole',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return isEnglish ? 'Please enter the purpose of the loan' : 'Chonde lowetsani chifukwa cha ngongole';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _submitApplication,
                style: ElevatedButton.styleFrom(
                  backgroundColor: customColors['primary'],
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  isEnglish ? 'Submit Application' : 'Tumizani Pempho',
                  style: TextStyle(fontSize: 18, color: customColors['surface']),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}