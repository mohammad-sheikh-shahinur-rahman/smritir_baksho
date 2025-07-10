import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:intl/intl.dart';
import 'package:flutter_sound/flutter_sound.dart';

import '../models/memory_model.dart';
import '../providers/memory_provider.dart';
import '../core/theme/theme_config.dart';
import 'add_memory_screen.dart';

class MemoryDetailsScreen extends StatefulWidget {
  final MemoryModel memory;

  const MemoryDetailsScreen({super.key, required this.memory});

  @override
  State<MemoryDetailsScreen> createState() => _MemoryDetailsScreenState();
}

class _MemoryDetailsScreenState extends State<MemoryDetailsScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  FlutterSoundPlayer? _audioPlayer;
  bool _isPlaying = false;
  bool _isPlayerInitialized = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: ThemeConfig.mediumAnimation,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
    
    _initializeAudioPlayer();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _disposeAudioPlayer();
    super.dispose();
  }

  Future<void> _initializeAudioPlayer() async {
    if (widget.memory.audioPath != null) {
      _audioPlayer = FlutterSoundPlayer();
      try {
        await _audioPlayer!.openPlayer();
        setState(() {
          _isPlayerInitialized = true;
        });
      } catch (e) {
        debugPrint('Error initializing audio player: $e');
      }
    }
  }

  Future<void> _disposeAudioPlayer() async {
    if (_audioPlayer != null) {
      try {
        await _audioPlayer!.closePlayer();
      } catch (e) {
        debugPrint('Error disposing audio player: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: context.watch<MemoryProvider>().isDarkMode
            ? ThemeConfig.darkPaperBackground
            : ThemeConfig.paperBackground,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: CustomScrollView(
            slivers: [
              _buildAppBar(),
              _buildContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: widget.memory.imagePath != null ? 300 : 120,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          widget.memory.title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                offset: Offset(1, 1),
                blurRadius: 3,
                color: Colors.black54,
              ),
            ],
          ),
        ),
        background: widget.memory.imagePath != null
            ? _buildHeaderImage()
            : _buildHeaderGradient(),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.edit),
          onPressed: _editMemory,
          tooltip: 'সম্পাদনা করুন',
        ),
        IconButton(
          icon: const Icon(Icons.share),
          onPressed: _shareMemory,
          tooltip: 'শেয়ার করুন',
        ),
        PopupMenuButton<String>(
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text('মুছে ফেলুন'),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHeaderImage() {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          File(widget.memory.imagePath!),
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildHeaderGradient();
          },
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.transparent,
                Colors.black.withOpacity(0.7),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeaderGradient() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColor.withOpacity(0.8),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMetadataCard(),
            const SizedBox(height: ThemeConfig.mediumSpacing),
            _buildDescriptionCard(),
            if (widget.memory.audioPath != null) ...[
              const SizedBox(height: ThemeConfig.mediumSpacing),
              _buildAudioCard(),
            ],
            const SizedBox(height: ThemeConfig.largeSpacing),
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info_outline),
                const SizedBox(width: ThemeConfig.smallSpacing),
                Text(
                  'বিবরণ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: ThemeConfig.mediumSpacing),
            _buildMetadataRow(
              'ক্যাটেগরি',
              widget.memory.category,
              Icons.category,
            ),
            const SizedBox(height: ThemeConfig.smallSpacing),
            _buildMetadataRow(
              'তারিখ',
              DateFormat('dd MMMM yyyy', 'bn_BD').format(widget.memory.date),
              Icons.calendar_today,
            ),
            const SizedBox(height: ThemeConfig.smallSpacing),
            _buildMetadataRow(
              'তৈরি হয়েছে',
              DateFormat('dd MMM yyyy, hh:mm a', 'bn_BD')
                  .format(widget.memory.createdAt),
              Icons.access_time,
            ),
            if (widget.memory.updatedAt != widget.memory.createdAt) ...[
              const SizedBox(height: ThemeConfig.smallSpacing),
              _buildMetadataRow(
                'সর্বশেষ আপডেট',
                DateFormat('dd MMM yyyy, hh:mm a', 'bn_BD')
                    .format(widget.memory.updatedAt),
                Icons.update,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetadataRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Theme.of(context).primaryColor,
        ),
        const SizedBox(width: ThemeConfig.smallSpacing),
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildDescriptionCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.description),
                const SizedBox(width: ThemeConfig.smallSpacing),
                Text(
                  'স্মৃতির বিবরণ',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: ThemeConfig.mediumSpacing),
            Text(
              widget.memory.description,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    height: 1.6,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAudioCard() {
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
            if (_isPlayerInitialized)
              Row(
                children: [
                  IconButton(
                    onPressed: _toggleAudioPlayback,
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle : Icons.play_circle,
                      size: 48,
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(width: ThemeConfig.mediumSpacing),
                  Expanded(
                    child: Text(
                      _isPlaying ? 'চলছে...' : 'ভয়েস মেমো শুনুন',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              )
            else
              const Row(
                children: [
                  CircularProgressIndicator(),
                  SizedBox(width: ThemeConfig.mediumSpacing),
                  Text('অডিও লোড হচ্ছে...'),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleAudioPlayback() async {
    if (_audioPlayer == null || !_isPlayerInitialized) return;

    try {
      if (_isPlaying) {
        await _audioPlayer!.stopPlayer();
        setState(() {
          _isPlaying = false;
        });
      } else {
        await _audioPlayer!.startPlayer(
          fromURI: widget.memory.audioPath!,
          whenFinished: () {
            setState(() {
              _isPlaying = false;
            });
          },
        );
        setState(() {
          _isPlaying = true;
        });
      }
    } catch (e) {
      debugPrint('Error playing audio: $e');
      _showErrorSnackBar('অডিও চালাতে সমস্যা হয়েছে');
    }
  }

  void _editMemory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => AddMemoryScreen(memoryToEdit: widget.memory),
      ),
    ).then((result) {
      // Refresh the screen if memory was updated
      if (result == true) {
        setState(() {});
      }
    });
  }

  void _shareMemory() {
    final String shareText = '''
${widget.memory.title}

${widget.memory.description}

ক্যাটেগরি: ${widget.memory.category}
তারিখ: ${DateFormat('dd MMMM yyyy', 'bn_BD').format(widget.memory.date)}

স্মৃতির বাক্স অ্যাপ থেকে শেয়ার করা হয়েছে
''';

    if (widget.memory.imagePath != null) {
      Share.shareXFiles(
        [XFile(widget.memory.imagePath!)],
        text: shareText,
      );
    } else {
      Share.share(shareText);
    }
  }

  void _handleMenuAction(String action) {
    switch (action) {
      case 'delete':
        _showDeleteConfirmation();
        break;
    }
  }

  void _showDeleteConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('স্মৃতি মুছে ফেলুন'),
        content: const Text(
          'আপনি কি নিশ্চিত যে এই স্মৃতিটি মুছে ফেলতে চান? এটি পুনরুদ্ধার করা যাবে না।',
        ),
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

    try {
      final provider = Provider.of<MemoryProvider>(context, listen: false);
      await provider.deleteMemory(widget.memory.id);
      
      _showSuccessSnackBar('স্মৃতি সফলভাবে মুছে ফেলা হয়েছে');
      Navigator.of(context).pop(); // Go back to previous screen
    } catch (e) {
      _showErrorSnackBar('স্মৃতি মুছতে সমস্যা হয়েছে: $e');
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

