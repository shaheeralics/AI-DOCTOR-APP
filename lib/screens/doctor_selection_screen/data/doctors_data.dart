import '../models/doctor_model.dart';

class DoctorsData {
  // Backend-ready: This will be replaced with API calls later
  static Future<List<Doctor>> getDoctors() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      const Doctor(
        id: 'ent_001',
        name: 'Dr. Hearwell',
        specialty: 'ENT Specialist',
        description: 'Expert in ear, nose & throat care with 15+ years experience',
        iconPath: 'assets/icons/ent_doctor.png', // Future: real profile images
        isAvailable: true,
        tags: ['ENT', 'Hearing', 'Throat', 'Nose'],
        availabilityText: 'Available Now',
      ),
      const Doctor(
        id: 'cardio_001',
        name: 'Dr. Heartbeat',
        specialty: 'Cardiologist',
        description: 'Specialist in heart & blood vessels with advanced cardiac care',
        iconPath: 'assets/icons/cardio_doctor.png',
        isAvailable: true,
        tags: ['Cardiology', 'Heart', 'Blood Pressure', 'Cardiac'],
        availabilityText: 'Available Now',
      ),
      const Doctor(
        id: 'neuro_001',
        name: 'Dr. NeuroNet',
        specialty: 'Neurologist',
        description: 'Brain & nervous system expert specializing in neural disorders',
        iconPath: 'assets/icons/neuro_doctor.png',
        isAvailable: true,
        tags: ['Neurology', 'Brain', 'Nervous System', 'Memory'],
        availabilityText: 'Available Now',
      ),
      const Doctor(
        id: 'derma_001',
        name: 'Dr. SkinCare',
        specialty: 'Dermatologist',
        description: 'Skin, hair & nail specialist with cosmetic expertise',
        iconPath: 'assets/icons/derma_doctor.png',
        isAvailable: false,
        tags: ['Dermatology', 'Skin', 'Hair', 'Cosmetic'],
        availabilityText: 'Available at 3:00 PM',
      ),
      const Doctor(
        id: 'ortho_001',
        name: 'Dr. BoneStrong',
        specialty: 'Orthopedic Surgeon',
        description: 'Bone, joint & muscle specialist with surgical expertise',
        iconPath: 'assets/icons/ortho_doctor.png',
        isAvailable: true,
        tags: ['Orthopedic', 'Bones', 'Joints', 'Surgery'],
        availabilityText: 'Available Now',
      ),
    ];
  }

  // Backend-ready: Filter methods for API integration
  static Future<List<Doctor>> searchDoctors(String query) async {
    final allDoctors = await getDoctors();
    if (query.isEmpty) return allDoctors;
    
    return allDoctors.where((doctor) => doctor.matchesSearch(query)).toList();
  }

  static Future<List<Doctor>> getDoctorsBySpecialty(String specialty) async {
    final allDoctors = await getDoctors();
    return allDoctors.where((doctor) => 
      doctor.specialty.toLowerCase() == specialty.toLowerCase()).toList();
  }

  static Future<Doctor?> getDoctorById(String id) async {
    final allDoctors = await getDoctors();
    try {
      return allDoctors.firstWhere((doctor) => doctor.id == id);
    } catch (e) {
      return null;
    }
  }
}
