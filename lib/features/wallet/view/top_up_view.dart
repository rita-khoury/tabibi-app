import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tabibi/core/constance/app_colors.dart';
import 'package:tabibi/features/wallet/controller/wallet_controller.dart';

class TopUpView extends StatefulWidget {
  const TopUpView({super.key});

  @override
  State<TopUpView> createState() => _TopUpViewState();
}

class _TopUpViewState extends State<TopUpView> {
  final WalletController controller = Get.find<WalletController>();
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _cvvController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_refreshPreview);
    _cardNumberController.addListener(_refreshPreview);
    _cvvController.addListener(_refreshPreview);
  }

  @override
  void dispose() {
    _amountController
      ..removeListener(_refreshPreview)
      ..dispose();
    _cardNumberController
      ..removeListener(_refreshPreview)
      ..dispose();
    _cvvController
      ..removeListener(_refreshPreview)
      ..dispose();
    super.dispose();
  }

  void _refreshPreview() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _submitTopUp() async {
    if (!(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    final amount = int.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      return;
    }

    final isSuccess = await controller.topUpWallet(
      cardNumber: _cardNumberController.text.replaceAll(' ', ''),
      cvv: _cvvController.text.trim(),
      amount: amount,
    );

    if (isSuccess && mounted) {
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FC),
      appBar: AppBar(
        backgroundColor: AppColors.white,
        surfaceTintColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: AppColors.primaryBlue),
        title: const Text(
          'Top Up Wallet',
          style: TextStyle(
            color: Color(0xFF1F2937),
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      body: SafeArea(
        top: false,
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 32),
            children: [
              const Text(
                'Add funds securely to your wallet',
                style: TextStyle(
                  color: AppColors.gray,
                  fontSize: 14,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),
              _CreditCardPreview(
                cardNumber: _cardNumberController.text,
                cvv: _cvvController.text,
                amount: _amountController.text,
              ),
              const SizedBox(height: 28),
              const Text(
                'Payment details',
                style: TextStyle(
                  color: Color(0xFF1F2937),
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 14),
              _FormFieldLabel(label: 'Amount to Add'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration(
                  prefix: const Text(
                    r'$ ',
                    style: TextStyle(
                      color: AppColors.primaryBlue,
                      fontSize: 17,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  hintText: 'Enter amount',
                  icon: Icons.account_balance_wallet_outlined,
                ),
                validator: (value) {
                  final amount = int.tryParse(value?.trim() ?? '');
                  if (amount == null || amount <= 0) {
                    return 'Enter an amount greater than zero';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _FormFieldLabel(label: 'Card Number'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cardNumberController,
                keyboardType: TextInputType.number,
                inputFormatters: const [_CardNumberFormatter()],
                decoration: _inputDecoration(
                  hintText: '1234 5678 9012 3456',
                  icon: Icons.credit_card_outlined,
                ),
                validator: (value) {
                  if (value?.replaceAll(' ', '').length != 16) {
                    return 'Enter a valid 16-digit card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _FormFieldLabel(label: 'CVV / Security Code'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _cvvController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: _inputDecoration(
                  hintText: '123',
                  icon: Icons.lock_outline,
                ).copyWith(counterText: ''),
                validator: (value) {
                  final digits = value?.trim() ?? '';
                  if (digits.length < 3 || digits.length > 4) {
                    return 'Enter a valid 3 or 4-digit CVV';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              Obx(
                () => SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: controller.isTopUpLoading.value
                        ? null
                        : _submitTopUp,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      disabledBackgroundColor: AppColors.primaryBlue.withValues(
                        alpha: 0.65,
                      ),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: controller.isTopUpLoading.value
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.5,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'Confirm Top Up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({
    required String hintText,
    required IconData icon,
    Widget? prefix,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Color(0xFF94A3B8)),
      prefixIcon: prefix == null
          ? Icon(icon, color: AppColors.primaryBlue)
          : Padding(
              padding: const EdgeInsets.only(left: 16, right: 8),
              child: prefix,
            ),
      prefixIconConstraints: const BoxConstraints(minWidth: 54),
      filled: true,
      fillColor: AppColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 17),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: AppColors.primaryBlue, width: 1.6),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDC2626)),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: Color(0xFFDC2626), width: 1.4),
      ),
    );
  }
}

class _FormFieldLabel extends StatelessWidget {
  const _FormFieldLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: const TextStyle(
        color: Color(0xFF334155),
        fontSize: 13,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

class _CreditCardPreview extends StatelessWidget {
  const _CreditCardPreview({
    required this.cardNumber,
    required this.cvv,
    required this.amount,
  });

  final String cardNumber;
  final String cvv;
  final String amount;

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.62,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.primaryBlue, AppColors.lightBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x401E88E5),
              blurRadius: 18,
              offset: Offset(0, 9),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 31,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFD66B),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Icon(
                    Icons.memory_rounded,
                    color: Color(0xFFB88A1B),
                    size: 22,
                  ),
                ),
                const Spacer(),
                const Text(
                  'Credit Card',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(Icons.credit_card, color: Colors.white, size: 22),
              ],
            ),
            const Spacer(),
            Text(
              _displayCardNumber(cardNumber),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _PreviewDetail(
                    label: 'AMOUNT',
                    value: amount.trim().isEmpty ? r'$ 0' : r'$ ' + amount,
                  ),
                ),
                _PreviewDetail(
                  label: 'CVV',
                  value: cvv.isEmpty ? '•••' : '•' * cvv.length,
                  alignEnd: true,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static String _displayCardNumber(String value) {
    final digits = value.replaceAll(' ', '');
    if (digits.isEmpty) {
      return '1234  ••••  ••••  9000';
    }
    final groups = <String>[];
    for (var index = 0; index < 16; index += 4) {
      final end = index + 4 > digits.length ? digits.length : index + 4;
      final part = index < digits.length ? digits.substring(index, end) : '';
      if (index == 0) {
        groups.add(part.padRight(4, '•'));
      } else if (index == 12 && part.isNotEmpty) {
        groups.add(part.padRight(4, '•'));
      } else {
        groups.add(
          part.isEmpty ? '••••' : ('•' * part.length).padRight(4, '•'),
        );
      }
    }
    return groups.join('  ');
  }
}

class _PreviewDetail extends StatelessWidget {
  const _PreviewDetail({
    required this.label,
    required this.value,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    final alignment = alignEnd
        ? CrossAxisAlignment.end
        : CrossAxisAlignment.start;
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: Color(0xD9FFFFFF),
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CardNumberFormatter extends TextInputFormatter {
  const _CardNumberFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final limited = digits.length > 16 ? digits.substring(0, 16) : digits;
    final groups = <String>[];
    for (var index = 0; index < limited.length; index += 4) {
      final end = index + 4 > limited.length ? limited.length : index + 4;
      groups.add(limited.substring(index, end));
    }
    final formatted = groups.join(' ');
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}
