import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/app_export.dart';

class OtpLoginWidget extends StatefulWidget {
  final String role;
  final VoidCallback onLoginSuccess;

  const OtpLoginWidget({
    Key? key,
    required this.role,
    required this.onLoginSuccess,
  }) : super(key: key);

  @override
  State<OtpLoginWidget> createState() => _OtpLoginWidgetState();
}

class _OtpLoginWidgetState extends State<OtpLoginWidget> {
  final _phoneController = TextEditingController();
  final List<TextEditingController> _otpControllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes =
      List.generate(6, (index) => FocusNode());

  String _selectedCountryCode = '+1';
  bool _isPhoneValid = false;
  bool _isOtpSent = false;
  bool _isLoading = false;
  bool _isVerifying = false;
  int _resendTimer = 0;

  final List<Map<String, String>> _countryCodes = [
    {'code': '+1', 'country': 'US'},
    {'code': '+91', 'country': 'IN'},
    {'code': '+44', 'country': 'UK'},
    {'code': '+86', 'country': 'CN'},
    {'code': '+81', 'country': 'JP'},
  ];

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_validatePhone);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _validatePhone() {
    final isValid = _phoneController.text.length >= 10;
    if (isValid != _isPhoneValid) {
      setState(() {
        _isPhoneValid = isValid;
      });
    }
  }

  Future<void> _sendOtp() async {
    if (!_isPhoneValid) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate OTP sending
    await Future.delayed(Duration(milliseconds: 1000));

    setState(() {
      _isLoading = false;
      _isOtpSent = true;
      _resendTimer = 30;
    });

    _startResendTimer();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('OTP sent to $_selectedCountryCode ${_phoneController.text}'),
        backgroundColor: AppTheme.lightTheme.colorScheme.tertiary,
      ),
    );
  }

  void _startResendTimer() {
    Future.delayed(Duration(seconds: 1), () {
      if (_resendTimer > 0 && mounted) {
        setState(() {
          _resendTimer--;
        });
        _startResendTimer();
      }
    });
  }

  Future<void> _verifyOtp() async {
    final otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length != 6) return;

    setState(() {
      _isVerifying = true;
    });

    // Simulate OTP verification
    await Future.delayed(Duration(milliseconds: 1500));

    // Mock OTP is always "123456" for demo
    final isValidOtp = otp == '123456';

    setState(() {
      _isVerifying = false;
    });

    if (isValidOtp) {
      HapticFeedback.lightImpact();
      widget.onLoginSuccess();
    } else {
      _showOtpErrorDialog();
    }
  }

  void _showOtpErrorDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Invalid OTP',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'The OTP you entered is incorrect. Please try again.',
              style: AppTheme.lightTheme.textTheme.bodyMedium,
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppTheme.lightTheme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Demo OTP: 123456',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  fontFamily: 'monospace',
                  color: AppTheme.lightTheme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _onOtpChanged(String value, int index) {
    if (value.isNotEmpty && index < 5) {
      _otpFocusNodes[index + 1].requestFocus();
    } else if (value.isEmpty && index > 0) {
      _otpFocusNodes[index - 1].requestFocus();
    }

    // Auto-verify when all digits are entered
    final otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length == 6) {
      _verifyOtp();
    }
  }

  Widget _buildCountryCodePicker() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.lightTheme.colorScheme.outline),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedCountryCode,
          items: _countryCodes.map((country) {
            return DropdownMenuItem<String>(
              value: country['code'],
              child: Text(
                '${country['country']} ${country['code']}',
                style: AppTheme.lightTheme.textTheme.bodyMedium,
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              setState(() {
                _selectedCountryCode = value;
              });
            }
          },
        ),
      ),
    );
  }

  Widget _buildPhoneInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Enter your phone number',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 16),
        Row(
          children: [
            _buildCountryCodePicker(),
            SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  hintText: '1234567890',
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(12),
                    child: CustomIconWidget(
                      iconName: 'phone',
                      color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(15),
                ],
                onFieldSubmitted: (_) => _sendOtp(),
              ),
            ),
          ],
        ),
        SizedBox(height: 24),
        ElevatedButton(
          onPressed: _isPhoneValid && !_isLoading ? _sendOtp : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: _isLoading
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                )
              : Text('Send OTP'),
        ),
      ],
    );
  }

  Widget _buildOtpInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Enter verification code',
          style: AppTheme.lightTheme.textTheme.titleMedium,
        ),
        SizedBox(height: 8),
        Text(
          'We sent a 6-digit code to $_selectedCountryCode ${_phoneController.text}',
          style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
            color: AppTheme.lightTheme.colorScheme.onSurfaceVariant,
          ),
        ),
        SizedBox(height: 24),

        // OTP Input Fields
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(6, (index) {
            return SizedBox(
              width: 45,
              child: TextFormField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                decoration: InputDecoration(
                  counterText: '',
                  contentPadding: EdgeInsets.symmetric(vertical: 16),
                ),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => _onOtpChanged(value, index),
              ),
            );
          }),
        ),

        SizedBox(height: 24),

        // Verify Button
        ElevatedButton(
          onPressed: !_isVerifying ? _verifyOtp : null,
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: _isVerifying
              ? SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppTheme.lightTheme.colorScheme.onPrimary,
                    ),
                  ),
                )
              : Text('Verify OTP'),
        ),

        SizedBox(height: 16),

        // Resend OTP
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Didn't receive code? ",
              style: AppTheme.lightTheme.textTheme.bodySmall,
            ),
            TextButton(
              onPressed: _resendTimer == 0 ? _sendOtp : null,
              child: Text(
                _resendTimer > 0 ? 'Resend in ${_resendTimer}s' : 'Resend',
                style: AppTheme.lightTheme.textTheme.bodySmall?.copyWith(
                  color: _resendTimer == 0
                      ? AppTheme.lightTheme.colorScheme.primary
                      : AppTheme.lightTheme.colorScheme.onSurface
                          .withValues(alpha: 0.38),
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 16),

        // Back to Phone Input
        TextButton(
          onPressed: () {
            setState(() {
              _isOtpSent = false;
              for (var controller in _otpControllers) {
                controller.clear();
              }
            });
          },
          child: Text('Change phone number'),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 300),
      child: _isOtpSent ? _buildOtpInput() : _buildPhoneInput(),
    );
  }
}
