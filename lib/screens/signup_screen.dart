// lib/screens/signup_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'success_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;
  
  bool _nameValid = false;
  bool _emailValid = false;
  bool _dobValid = false;
  bool _passwordValid = false;
  
  int _selectedAvatar = 0;
  
  int _passwordStrength = 0;

  // List of avatar icons
  final List<IconData> _avatars = [
    Icons.face,
    Icons.sentiment_satisfied_alt,
    Icons.emoji_emotions,
    Icons.mood,
    Icons.psychology,
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _dobController.dispose();
    super.dispose();
  }

  // Calculate progress percentage
  double get _progress {
    int completed = 0;
    if (_nameValid) completed++;
    if (_emailValid) completed++;
    if (_dobValid) completed++;
    if (_passwordValid) completed++;
    return completed / 4; // 4 fields total
  }

  // Get progress message based on percentage
  String get _progressMessage {
    double progress = _progress;
    if (progress == 0) return "Let's get started! 🚀";
    if (progress <= 0.25) return "Great start! 🌟";
    if (progress <= 0.50) return "Halfway there! 💪";
    if (progress <= 0.75) return "Almost done! 🎉";
    return "Ready for adventure! 🎊";
  }

  void _checkPasswordStrength(String password) {
    setState(() {
      if (password.isEmpty) {
        _passwordStrength = 0;
      } else if (password.length < 6) {
        _passwordStrength = 0; // Weak
      } else if (password.length < 10) {
        _passwordStrength = 1; // Medium
      } else {
        _passwordStrength = 2; // Strong
      }
    });
  }

  void _triggerHaptic() {
    HapticFeedback.lightImpact();
  }

  // Date picker
  Future<void> _selectDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _dobController.text = "${picked.day}/${picked.month}/${picked.year}";
        _dobValid = true;
      });
      _triggerHaptic(); // Haptic feedback on date selection
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      _triggerHaptic(); // Haptic feedback on submit
      
      // Calculate achievements
      List<String> achievements = [];
      
      // Check for strong password
      if (_passwordStrength == 2) {
        achievements.add("Strong Password Master");
      }
      
      // Check for early bird (before 12 PM)
      if (DateTime.now().hour < 12) {
        achievements.add("The Early Bird Special");
      }
      
      if (_nameValid && _emailValid && _dobValid && _passwordValid) {
        achievements.add("Profile Completer");
      }

      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SuccessScreen(
              userName: _nameController.text,
              avatarIcon: _avatars[_selectedAvatar],
              achievements: achievements,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Your Account 🎉'),
        backgroundColor: const Color.fromARGB(255, 0, 127, 104),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildProgressTracker(),
                const SizedBox(height: 20),
                
                _buildAvatarSelection(),
                const SizedBox(height: 20),

                // Name Field with validation animation
                _buildTextField(
                  controller: _nameController,
                  label: 'Adventure Name',
                  icon: Icons.person,
                  isValid: _nameValid,
                  onChanged: (value) {
                    setState(() {
                      _nameValid = value.isNotEmpty;
                    });
                    if (_nameValid) _triggerHaptic();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'What should we call you on this adventure?';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Email Field with validation animation
                _buildTextField(
                  controller: _emailController,
                  label: 'Email Address',
                  icon: Icons.email,
                  isValid: _emailValid,
                  onChanged: (value) {
                    setState(() {
                      _emailValid = value.contains('@') && value.contains('.');
                    });
                    if (_emailValid) _triggerHaptic();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'We need your email for adventure updates!';
                    }
                    if (!value.contains('@') || !value.contains('.')) {
                      return 'Oops! That doesn\'t look like a valid email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // DOB with Calendar
                TextFormField(
                  controller: _dobController,
                  readOnly: true,
                  onTap: _selectDate,
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: _dobValid ? Colors.green : Colors.deepPurple,
                    ),

                    suffixIcon: _dobValid
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : IconButton(
                            icon: const Icon(Icons.date_range),
                            onPressed: _selectDate,
                          ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: _dobValid ? Colors.green : Colors.grey,
                        width: 2,
                      ),
                    ),
                    filled: true,
                    fillColor: Colors.grey[50],
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'When did your adventure begin?';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Password Field with Strength Meter
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextFormField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      onChanged: (value) {
                        _checkPasswordStrength(value);
                        setState(() {
                          _passwordValid = value.length >= 6;
                        });
                        if (_passwordValid) _triggerHaptic();
                      },
                      decoration: InputDecoration(
                        labelText: 'Secret Password',
                        prefixIcon: Icon(
                          Icons.lock,
                          color: _passwordValid ? Colors.green : Colors.deepPurple,
                        ),

                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (_passwordValid)
                              const Icon(Icons.check_circle, color: Colors.green),
                            IconButton(
                              icon: Icon(
                                _isPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.deepPurple,
                              ),
                              onPressed: () {
                                setState(() {
                                  _isPasswordVisible = !_isPasswordVisible;
                                });
                              },
                            ),
                          ],
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        filled: true,
                        fillColor: Colors.grey[50],
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Every adventurer needs a secret password!';
                        }
                        if (value.length < 6) {
                          return 'Make it stronger! At least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    

                    _buildPasswordStrengthMeter(),
                  ],
                ),
                const SizedBox(height: 30),

                // Submit Button with Loading Animation
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: _isLoading ? 60 : double.infinity,
                  height: 60,
                  child: _isLoading
                      ? const Center(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(
                                Color.fromARGB(255, 183, 75, 58)),
                          ),
                        )
                      : ElevatedButton(
                          onPressed: _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 0, 127, 104),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            elevation: 5,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Start My Adventure',
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.rocket_launch, color: Colors.white),
                            ],
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildProgressTracker() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Adventure Progress',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '${(_progress * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                _progress == 1.0 ? Colors.green : const Color.fromARGB(255, 224, 35, 6),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _progressMessage,
            style: TextStyle(
              color: Colors.deepPurple[700],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSelection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.deepPurple.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Choose Your Avatar',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(_avatars.length, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedAvatar = index;
                  });
                  _triggerHaptic(); // Haptic feedback on selection
                },
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: _selectedAvatar == index
                        ? Colors.deepPurple
                        : Colors.grey[300],
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _selectedAvatar == index
                          ? Colors.deepPurple[700]!
                          : Colors.grey,
                      width: 3,
                    ),
                  ),
                  child: Icon(
                    _avatars[index],
                    color: _selectedAvatar == index
                        ? Colors.white
                        : Colors.grey[600],
                    size: 30,
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthMeter() {
    Color strengthColor;
    String strengthText;
    
    switch (_passwordStrength) {
      case 0:
        strengthColor = Colors.red;
        strengthText = 'Weak';
        break;
      case 1:
        strengthColor = Colors.orange;
        strengthText = 'Medium';
        break;
      case 2:
        strengthColor = Colors.green;
        strengthText = 'Strong';
        break;
      default:
        strengthColor = Colors.grey;
        strengthText = '';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('Password Strength: '),
            Text(
              strengthText,
              style: TextStyle(
                color: strengthColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: _passwordStrength >= 0 && _passwordController.text.isNotEmpty
                      ? strengthColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: _passwordStrength >= 1
                      ? strengthColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(width: 4),
            Expanded(
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  color: _passwordStrength >= 2
                      ? strengthColor
                      : Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Text field builder with validation animation
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required bool isValid,
    required Function(String) onChanged,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(
          icon,
          color: isValid ? Colors.green : Colors.deepPurple,
        ),

        suffixIcon: isValid
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isValid ? Colors.green : Colors.grey,
            width: 2,
          ),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
      validator: validator,
    );
  }
}