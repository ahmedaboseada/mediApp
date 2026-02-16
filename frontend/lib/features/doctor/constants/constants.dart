import 'package:multi_dropdown/multi_dropdown.dart';

class DoctorConstants {
  final List<DropdownItem<String>> spicilizations = [
    DropdownItem(value: 'Cardiology', label: 'Cardiology'),
    DropdownItem(value: 'Dermatology', label: 'Dermatology'),
    DropdownItem(value: 'Neurology', label: 'Neurology'),
    DropdownItem(value: 'Pediatrics', label: 'Pediatrics'),
    DropdownItem(value: 'Psychiatry', label: 'Psychiatry'),
    DropdownItem(value: 'Radiology', label: 'Radiology'),
    DropdownItem(value: 'Surgery', label: 'Surgery'),
    DropdownItem(value: 'Urology', label: 'Urology'),
  ];
  final List<DropdownItem<String>> workingHours = [
    DropdownItem(value: '9:00 AM - 10:00 AM', label: '9:00 AM - 10:00 AM'),
    DropdownItem(value: '10:00 AM - 11:00 AM', label: '10:00 AM - 11:00 AM'),
    DropdownItem(value: '11:00 AM - 12:00 PM', label: '11:00 AM - 12:00 PM'),
    DropdownItem(value: '12:00 PM - 1:00 PM', label: '12:00 PM - 1:00 PM'),
    DropdownItem(value: '1:00 PM - 2:00 PM', label: '1:00 PM - 2:00 PM'),
    DropdownItem(value: '2:00 PM - 3:00 PM', label: '2:00 PM - 3:00 PM'),
    DropdownItem(value: '3:00 PM - 4:00 PM', label: '3:00 PM - 4:00 PM'),
    DropdownItem(value: '4:00 PM - 5:00 PM', label: '4:00 PM - 5:00 PM'),
    DropdownItem(value: '5:00 PM - 6:00 PM', label: '5:00 PM - 6:00 PM'),
    DropdownItem(value: '6:00 PM - 7:00 PM', label: '6:00 PM - 7:00 PM'),
    DropdownItem(value: '7:00 PM - 8:00 PM', label: '7:00 PM - 8:00 PM'),
    DropdownItem(label: '8:00 PM - 9:00 PM', value: '8:00 PM - 9:00 PM'),
  ];
  final List<DropdownItem<String>> appointmentsTypes = [
    DropdownItem(value: 'Clinic Visit', label: 'Clinic Visit'),
    DropdownItem(value: 'Telemedicine', label: 'Telemedicine'),
  ];
}
