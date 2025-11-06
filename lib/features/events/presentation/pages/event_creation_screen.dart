import 'package:attend_event/features/auth/teacher_auth/domain/entities/teacher.dart';
import 'package:attend_event/features/events/domain/entities/event.dart';
import 'package:attend_event/features/events/domain/repositories/event_repositories.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class CreateEventScreen extends StatefulWidget {
  final String studentId;
  
  const CreateEventScreen({super.key, required this.studentId});
  
  @override
  State<CreateEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<CreateEventScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _eventRepository = EventRepository(Supabase.instance.client);
  final Uuid uuid = Uuid();
  
  String _selectedCategory = 'NCC';
  String? _selectedTeacherId;
  DateTime _selectedDate = DateTime.now();
  List<Teacher> _teachers = [];
  
  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }
  
  Future<void> _loadTeachers() async {
    try {
      final teachers = await _eventRepository.getTeachers();
      setState(() => _teachers = teachers);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load teachers: $e')),
      );
    }
  }
  
  Future<void> _createEvent() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedTeacherId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a teacher')),
      );
      return;
    }
    
    try {
      final event = Event(
        id: uuid.v4(),
        title: _titleController.text,
        description: _descriptionController.text,
        category: _selectedCategory,
        createdBy: widget.studentId,
        supervisingTeacherId: _selectedTeacherId,
        status: 'pending',
        createdAt: DateTime.now(),
        scheduledFor: _selectedDate,
      );
      
      await _eventRepository.createEventWithTeacherRequest(event);
      
      Navigator.pop(context, true);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Event request sent to teacher successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to create event: $e')),
      );
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create Event')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Event Title',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Description Field
              TextFormField(
                controller: _descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event description';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Category Dropdown
              DropdownButtonFormField<String>(
                value: _selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: ['NCC', 'NSS', 'Sports']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value!);
                },
              ),
              SizedBox(height: 16),
              
              // Teacher Dropdown
              DropdownButtonFormField<String>(
                value: _selectedTeacherId,
                decoration: InputDecoration(
                  labelText: 'Select Teacher',
                  border: OutlineInputBorder(),
                ),
                items: _teachers
                    .map((teacher) => DropdownMenuItem(
                          value: teacher.id, // Using UUID from teachers table
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(teacher.name),
                              if (teacher.department != null)
                                Text(
                                  teacher.department!,
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() => _selectedTeacherId = value!);
                },
                validator: (value) {
                  if (value == null) return 'Please select a teacher';
                  return null;
                },
              ),
              SizedBox(height: 16),
              
              // Date Picker
              ListTile(
                title: Text('Event Date & Time'),
                subtitle: Text(
                  DateFormat('MMM dd, yyyy - HH:mm').format(_selectedDate),
                ),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(Duration(days: 365)),
                  );
                  if (date != null) {
                    final time = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.fromDateTime(_selectedDate),
                    );
                    if (time != null) {
                      setState(() {
                        _selectedDate = DateTime(
                          date.year,
                          date.month,
                          date.day,
                          time.hour,
                          time.minute,
                        );
                      });
                    }
                  }
                },
              ),
              SizedBox(height: 24),
              
              // Submit Button
              ElevatedButton(
                onPressed: _createEvent,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text('Send Request to Teacher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}