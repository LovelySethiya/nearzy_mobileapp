import 'package:flutter/material.dart';

import '../../core/app_export.dart';
import './widgets/login_form_widget.dart';
import './widgets/otp_login_widget.dart';
import './widgets/role_icon_widget.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedRole = 'Customer';
  bool _keyboardVisible = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);

    // Get role from route arguments if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args =
          ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null && args['role'] != null) {
        setState(() {
          _selectedRole = args['role'];
        });
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _handleLoginSuccess() {
    // Navigate to appropriate dashboard based on role
    String route;
    switch (_selectedRole.toLowerCase()) {
      case 'customer':
        route = '/customer-home-screen';
        break;
      case 'shopkeeper':
        route = '/product-management-screen';
        break;
      case 'admin':
        route = '/product-categories-screen'; // Admin dashboard placeholder
        break;
      default:
        route = '/customer-home-screen';
    }

    Navigator.pushReplacementNamed(context, route);
  }

  void _handleSignUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Sign Up',
          style: AppTheme.lightTheme.textTheme.titleLarge,
        ),
        content: Text(
          'Sign up functionality will be implemented in future updates. Please use the demo credentials to login.',
          style: AppTheme.lightTheme.textTheme.bodyMedium,
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

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;

    return Scaffold(
      backgroundColor: AppTheme.lightTheme.scaffoldBackgroundColor,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            // Dismiss keyboard when tapping outside
            FocusScope.of(context).unfocus();
          },
          child: Column(
            children: [
              // App Bar with Back Button
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: CustomIconWidget(
                        iconName: 'arrow_back',
                        color: AppTheme.lightTheme.colorScheme.onSurface,
                        size: 24,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        'Login',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: _keyboardVisible ? 16 : 32),

                      // Role Icon
                      Center(
                        child: RoleIconWidget(
                          role: _selectedRole,
                          size: _keyboardVisible ? 60 : 80,
                        ),
                      ),

                      SizedBox(height: 16),

                      // Role Title
                      Text(
                        'Login as $_selectedRole',
                        style: AppTheme.lightTheme.textTheme.headlineSmall
                            ?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppTheme.lightTheme.colorScheme.onSurface,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: 8),

                      Text(
                        'Welcome back! Please enter your credentials to continue.',
                        style:
                            AppTheme.lightTheme.textTheme.bodyMedium?.copyWith(
                          color:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                        ),
                        textAlign: TextAlign.center,
                      ),

                      SizedBox(height: _keyboardVisible ? 24 : 32),

                      // Tab Bar
                      Container(
                        decoration: BoxDecoration(
                          color: AppTheme.lightTheme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppTheme.lightTheme.colorScheme.outline
                                .withValues(alpha: 0.2),
                          ),
                        ),
                        child: TabBar(
                          controller: _tabController,
                          indicator: BoxDecoration(
                            color: AppTheme.lightTheme.colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          labelColor: AppTheme.lightTheme.colorScheme.onPrimary,
                          unselectedLabelColor:
                              AppTheme.lightTheme.colorScheme.onSurfaceVariant,
                          dividerColor: Colors.transparent,
                          tabs: [
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'email',
                                    size: 16,
                                    color: _tabController.index == 0
                                        ? AppTheme
                                            .lightTheme.colorScheme.onPrimary
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                  ),
                                  SizedBox(width: 8),
                                  Text('Email'),
                                ],
                              ),
                            ),
                            Tab(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CustomIconWidget(
                                    iconName: 'phone',
                                    size: 16,
                                    color: _tabController.index == 1
                                        ? AppTheme
                                            .lightTheme.colorScheme.onPrimary
                                        : AppTheme.lightTheme.colorScheme
                                            .onSurfaceVariant,
                                  ),
                                  SizedBox(width: 8),
                                  Text('OTP'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      SizedBox(height: 24),

                      // Tab Content
                      SizedBox(
                        height: _keyboardVisible ? null : 400,
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            // Email Login Tab
                            LoginFormWidget(
                              role: _selectedRole,
                              onLoginSuccess: _handleLoginSuccess,
                            ),

                            // OTP Login Tab
                            OtpLoginWidget(
                              role: _selectedRole,
                              onLoginSuccess: _handleLoginSuccess,
                            ),
                          ],
                        ),
                      ),

                      if (!_keyboardVisible) ...[
                        SizedBox(height: 32),

                        // Divider
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                'New to Nearzy?',
                                style: AppTheme.lightTheme.textTheme.bodySmall
                                    ?.copyWith(
                                  color: AppTheme
                                      .lightTheme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: AppTheme.lightTheme.colorScheme.outline
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 16),

                        // Sign Up Button
                        OutlinedButton(
                          onPressed: _handleSignUp,
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            side: BorderSide(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              width: 1.5,
                            ),
                          ),
                          child: Text(
                            'Create New Account',
                            style: AppTheme.lightTheme.textTheme.labelLarge
                                ?.copyWith(
                              color: AppTheme.lightTheme.colorScheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),

                        SizedBox(height: 24),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
