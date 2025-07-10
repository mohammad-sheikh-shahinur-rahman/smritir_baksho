import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

import '../providers/memory_provider.dart';
import '../models/memory_model.dart';
import '../widgets/voice_recorder_widget.dart';
import '../core/theme/theme_config.dart';

class AddMemoryScreen extends StatefulWidget {
  final MemoryModel? memoryToEdit;

  const AddMemoryScreen({super.key, this.memoryToEdit});

  @override
  State<AddMemoryScreen> createState() => _AddMemoryScreenState();
}

class _AddMemoryScreenState extends State<AddMemoryScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  
  String _selectedCategory = MemoryCategories.other;
  DateTime _selectedDate = DateTime.now();
  File? _selectedImage;
  String? _audioPath;
  bool _isLoading = false;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    if (widget.memoryToEdit != null) {
      _initializeForEditing();
    }
  }

  void _initializeForEditing() {
    final memory = widget.memoryToEdit!;
    _titleController.text = memory.title;
    _descriptionController.text = memory.description;
    _selectedCategory = memory.category;
    _selectedDate = memory.date;
    _audioPath = memory.audioPath;
    
    if (memory.imagePath != null) {
      _selectedImage = File(memory.imagePath!);
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.memoryToEdit != null ? 'স্মৃতি সম্পাদনা' : 'নতুন স্মৃতি'),
        actions: [
          if (widget.memoryToEdit != null)
            IconButton(
              icon: const Icon(Icons.delete),
              onPressed: _showDeleteConfirmation,
              tooltip: 'মুছে ফেলুন',
            ),
        ],
      ),
      body: Container(
        decoration: context.watch<MemoryProvider>().isDarkMode
            ? ThemeConfig.darkPaperBackground
            : ThemeConfig.paperBackground,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildForm(),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildTitleField(),
            const SizedBox(height: ThemeConfig.mediumSpacing),
            _buildDescriptionField(),
            const SizedBox(height: ThemeConfig.mediumSpacing),
            _buildCategoryDropdown(),
            const SizedBox(height: ThemeConfig.mediumSpacing),
            _buildDatePicker(),
            const SizedBox(height: ThemeConfig.largeSpacing),
            _buildImageSection(),
            const SizedBox(height: ThemeConfig.largeSpacing),
            _buildVoiceSection(),
            const SizedBox(height: ThemeConfig.extraLargeSpacing),
            _buildSaveButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleField() {
    return TextFormField(
      controller: _titleController,
      decoration: const InputDecoration(
        labelText: 'শিরোনাম *',
        hintText: 'আপনার স্মৃতির একটি সুন্দর নাম দিন',
        prefixIcon: Icon(Icons.title),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'শিরোনাম আবশ্যক';
        }
        if (value.trim().length < 2) {
          return 'শিরোনাম কমপক্ষে ২ অক্ষরের হতে হবে';
        }
        return null;
      },
      textInputAction: TextInputAction.next,
      maxLength: 100,
    );
  }

  Widget _buildDescriptionField() {
    return TextFormField(
      controller: _descriptionController,
      decoration: const InputDecoration(
        labelText: 'বিবরণ *',
        hintText: 'আপনার স্মৃতির বিস্তারিত লিখুন',
        prefixIcon: Icon(Icons.description),
        alignLabelWithHint: true,
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'বিবরণ আবশ্যক';
        }
        if (value.trim().length < 10) {
          return 'বিবরণ কমপক্ষে ১০ অক্ষরের হতে হবে';
        }
        return null;
      },
      maxLines: 5,
      maxLength: 1000,
      textInputAction: TextInputAction.newline,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: const InputDecoration(
        labelText: 'ক্যাটেগরি',
        prefixIcon: Icon(Icons.category),
      ),
      items: MemoryCategories.allCategories.map((category) {
        return DropdownMenuItem(
          value: category,
          child: Text(category),
        );
      }).toList(),
      onChanged: (value) {
        if (value != null) {
          setState(() {
            _selectedCategory = value;
          });
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'ক্যাটেগরি নির্বাচন করুন';
        }
        return null;
      },
    );
  }

  Widget _buildDatePicker() {
    return InkWell(
      onTap: _selectDate,
      child: InputDecorator(
        decoration: const InputDecoration(
          labelText: 'তারিখ',
          prefixIcon: Icon(Icons.calendar_today),
        ),
        child: Text(
          DateFormat('dd MMMM yyyy', 'bn_BD').format(_selectedDate),
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.image),
                const SizedBox(width: ThemeConfig.smallSpacing),
                Text(
                  'ছবি',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const Spacer(),
                if (_selectedImage != null)
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                    tooltip: 'ছবি মুছুন',
                  ),
              ],
            ),
            const SizedBox(height: ThemeConfig.mediumSpacing),
            if (_selectedImage != null) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(ThemeConfig.smallRadius),
                child: Image.file(
                  _selectedImage!,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: ThemeConfig.mediumSpacing),
            ],
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('গ্যালারি থেকে'),
                  ),
                ),
                const SizedBox(width: ThemeConfig.smallSpacing),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _pickImage(ImageSource.camera),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('ক্যামেরা'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVoiceSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.mic),
                const SizedBox(width: ThemeConfig.smallSpacing),
                Text(
                  'ভয়েস মেমো',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: ThemeConfig.mediumSpacing),
            VoiceRecorderWidget(
              initialAudioPath: _audioPath,
              onAudioRecorded: (audioPath) {
                setState(() {
                  _audioPath = audioPath;
                });
              },
              onAudioDeleted: () {
                setState(() {
                  _audioPath = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton() {
    return ElevatedButton.icon(
      onPressed: _saveMemory,
      icon: const Icon(Icons.save),
      label: Text(widget.memoryToEdit != null ? 'আপডেট করুন' : 'সংরক্ষণ করুন'),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: ThemeConfig.mediumSpacing),
      ),
    );
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      locale: const Locale('bn', 'BD'),
      helpText: 'তারিখ নির্বাচন করুন',
      cancelText: 'বাতিল',
      confirmText: 'ঠিক আছে',
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      _showErrorSnackBar('ছবি নির্বাচনে সমস্যা হয়েছে: $e');
    }
  }

  Future<void> _saveMemory() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<MemoryProvider>(context, listen: false);

      if (widget.memoryToEdit != null) {
        // Update existing memory
        final updatedMemory = widget.memoryToEdit!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
          date: _selectedDate,
          imagePath: _selectedImage?.path,
          audioPath: _audioPath,
        );
        await provider.updateMemory(updatedMemory);
        _showSuccessSnackBar('স্মৃতি সফলভাবে আপডেট হয়েছে');
      } else {
        // Create new memory
        final newMemory = MemoryModel.create(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
          date: _selectedDate,
          imagePath: _selectedImage?.path,
          audioPath: _audioPath,
        );
        await provider.addMemory(newMemory);
        _showSuccessSnackBar('স্মৃতি সফলভাবে সংরক্ষিত হয়েছে');
      }

      Navigator.of(context).pop();
    } catch (e) {
      _showErrorSnackBar('স্মৃতি সংরক্ষণে সমস্যা হয়েছে: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('স্মৃতি মুছে ফেলুন'),
        content: const Text('আপনি কি নিশ্চিত যে এই স্মৃতিটি মুছে ফেলতে চান? এটি পুনরুদ্ধার করা যাবে না।'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('বাতিল'),
          ),
          TextButton(
            onPressed: _deleteMemory,
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('মুছে ফেলুন'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteMemory() async {
    Navigator.of(context).pop(); // Close dialog

    setState(() {
      _isLoading = true;
    });

    try {
      final provider = Provider.of<MemoryProvider>(context, listen: false);
      await provider.deleteMemory(widget.memoryToEdit!.id);
      _showSuccessSnackBar('স্মৃতি সফলভাবে মুছে ফেলা হয়েছে');
      Navigator.of(context).pop();
    } catch (e) {
      _showErrorSnackBar('স্মৃতি মুছতে সমস্যা হয়েছে: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

