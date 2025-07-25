import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import 'components/doctor_selection_app_bar.dart';
import 'components/search_bar.dart' as custom;
import 'components/doctor_list.dart';
import 'models/doctor_model.dart';
import 'data/doctors_data.dart';

class DoctorSelectionScreen extends StatefulWidget {
  const DoctorSelectionScreen({Key? key}) : super(key: key);

  @override
  State<DoctorSelectionScreen> createState() => _DoctorSelectionScreenState();
}

class _DoctorSelectionScreenState extends State<DoctorSelectionScreen>
    with TickerProviderStateMixin {
  List<Doctor> _allDoctors = [];
  List<Doctor> _filteredDoctors = [];
  bool _isLoading = true;
  
  late AnimationController _backgroundAnimationController;
  late Animation<Color?> _backgroundColorAnimation;

  @override
  void initState() {
    super.initState();
    
    // Background animation controller
    _backgroundAnimationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    _backgroundColorAnimation = ColorTween(
      begin: const Color(0xFFF7F9FC),
      end: const Color(0xFFE3F2FD),
    ).animate(CurvedAnimation(
      parent: _backgroundAnimationController,
      curve: Curves.easeInOut,
    ));

    _loadDoctors();
    _startBackgroundAnimation();
  }

  void _startBackgroundAnimation() {
    _backgroundAnimationController.repeat(reverse: true);
  }

  Future<void> _loadDoctors() async {
    try {
      setState(() {
        _isLoading = true;
      });

      // Simulate loading for better UX
      await Future.delayed(const Duration(milliseconds: 800));
      
      final doctors = await DoctorsData.getDoctors();
      
      if (mounted) {
        setState(() {
          _allDoctors = doctors;
          _filteredDoctors = doctors;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load doctors: $e'),
            backgroundColor: Colors.red[600],
          ),
        );
      }
    }
  }

  void _onSearchChanged(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredDoctors = _allDoctors;
      } else {
        _filteredDoctors = _allDoctors
            .where((doctor) => doctor.matchesSearch(query))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _backgroundAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _backgroundAnimationController,
      builder: (context, child) {
        return Scaffold(
          backgroundColor: _backgroundColorAnimation.value ?? const Color(0xFFF7F9FC),
          appBar: const DoctorSelectionAppBar(),
          body: Column(
            children: [
              // Search Bar
              custom.SearchBar(
                onSearchChanged: _onSearchChanged,
                hintText: 'Search doctors or specialties...',
              ),
              
              // Statistics Row (Optional Enhancement)
              if (!_isLoading && _allDoctors.isNotEmpty)
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 18), // Reduced from 20
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14), // Reduced padding
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: const Color(0xFF00B4D8).withOpacity(0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildStatItem(
                        'Total Doctors',
                        '${_allDoctors.length}',
                        Icons.medical_services,
                      ),
                      Container(
                        width: 1,
                        height: 28, // Reduced from 30
                        color: Colors.grey[300],
                      ),
                      _buildStatItem(
                        'Available Now',
                        '${_allDoctors.where((d) => d.isAvailable).length}',
                        Icons.online_prediction,
                      ),
                      Container(
                        width: 1,
                        height: 30,
                        color: Colors.grey[300],
                      ),
                      _buildStatItem(
                        'Specialties',
                        '${_allDoctors.map((d) => d.specialty).toSet().length}',
                        Icons.category,
                      ),
                    ],
                  ),
                ),
              
              const SizedBox(height: 12), // Reduced from 16
              
              // Doctors List
              Expanded(
                child: DoctorList(
                  doctors: _filteredDoctors,
                  isLoading: _isLoading,
                ),
              ),
            ],
          ),
          
          // Floating Action Button for Quick Actions
          floatingActionButton: _isLoading ? null : FloatingActionButton.extended(
            onPressed: () {
              // Quick help or emergency contact
              _showQuickHelpDialog();
            },
            backgroundColor: const Color(0xFF00B4D8),
            icon: const Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
            label: const Text(
              'Need Help?',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFF00B4D8),
          size: 18, // Reduced from 20
        ),
        const SizedBox(height: 3), // Reduced from 4
        Text(
          value,
          style: const TextStyle(
            fontSize: 14, // Reduced from 16
            fontWeight: FontWeight.bold,
            color: kPrimaryColor,
            fontFamily: 'Montserrat',
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 9, // Reduced from 10
            color: Colors.grey[600],
            fontFamily: 'Montserrat',
          ),
        ),
      ],
    );
  }

  void _showQuickHelpDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Row(
            children: [
              Icon(
                Icons.help_outline,
                color: Color(0xFF00B4D8),
              ),
              SizedBox(width: 8),
              Text(
                'Quick Help',
                style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• Select a doctor based on your symptoms',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              SizedBox(height: 8),
              Text(
                '• Use search to find specific specialties',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              SizedBox(height: 8),
              Text(
                '• Green dot indicates doctor is available',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
              SizedBox(height: 8),
              Text(
                '• Tap "Start Chat" to begin consultation',
                style: TextStyle(fontFamily: 'Montserrat'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Got it!',
                style: TextStyle(
                  color: Color(0xFF00B4D8),
                  fontFamily: 'Montserrat',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
