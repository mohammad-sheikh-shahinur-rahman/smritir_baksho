import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import '../core/theme/theme_config.dart';

class VoiceRecorderWidget extends StatefulWidget {
  final String? initialAudioPath;
  final Function(String audioPath) onAudioRecorded;
  final VoidCallback onAudioDeleted;

  const VoiceRecorderWidget({
    super.key,
    this.initialAudioPath,
    required this.onAudioRecorded,
    required this.onAudioDeleted,
  });

  @override
  State<VoiceRecorderWidget> createState() => _VoiceRecorderWidgetState();
}

class _VoiceRecorderWidgetState extends State<VoiceRecorderWidget>
    with TickerProviderStateMixin {
  FlutterSoundRecorder? _recorder;
  FlutterSoundPlayer? _player;
  
  bool _isRecorderInitialized = false;
  bool _isPlayerInitialized = false;
  bool _isRecording = false;
  bool _isPlaying = false;
  bool _hasPermission = false;
  
  String? _currentAudioPath;
  Duration _recordingDuration = Duration.zero;
  Duration _playbackPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  late AnimationController _waveController;
  late Animation<double> _waveAnimation;

  @override
  void initState() {
    super.initState();
    _currentAudioPath = widget.initialAudioPath;
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _waveController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _waveAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _waveController, curve: Curves.easeInOut),
    );

    _initializeRecorder();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _waveController.dispose();
    _disposeRecorder();
    _disposePlayer();
    super.dispose();
  }

  Future<void> _initializeRecorder() async {
    await _requestPermissions();
    
    if (_hasPermission) {
      _recorder = FlutterSoundRecorder();
      _player = FlutterSoundPlayer();
      
      try {
        await _recorder!.openRecorder();
        await _player!.openPlayer();
        
        setState(() {
          _isRecorderInitialized = true;
          _isPlayerInitialized = true;
        });
      } catch (e) {
        debugPrint('Error initializing recorder/player: $e');
      }
    }
  }

  Future<void> _requestPermissions() async {
    final status = await Permission.microphone.request();
    setState(() {
      _hasPermission = status == PermissionStatus.granted;
    });
  }

  Future<void> _disposeRecorder() async {
    if (_recorder != null) {
      try {
        await _recorder!.closeRecorder();
      } catch (e) {
        debugPrint('Error disposing recorder: $e');
      }
    }
  }

  Future<void> _disposePlayer() async {
    if (_player != null) {
      try {
        await _player!.closePlayer();
      } catch (e) {
        debugPrint('Error disposing player: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_hasPermission) {
      return _buildPermissionRequest();
    }

    if (!_isRecorderInitialized || !_isPlayerInitialized) {
      return _buildLoadingState();
    }

    return Column(
      children: [
        if (_currentAudioPath != null) ...[
          _buildAudioPlayer(),
          const SizedBox(height: ThemeConfig.mediumSpacing),
        ],
        _buildRecorderControls(),
        if (_isRecording) ...[
          const SizedBox(height: ThemeConfig.mediumSpacing),
          _buildRecordingIndicator(),
        ],
      ],
    );
  }

  Widget _buildPermissionRequest() {
    return Container(
      padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.errorContainer,
        borderRadius: BorderRadius.circular(ThemeConfig.smallRadius),
      ),
      child: Column(
        children: [
          const Icon(Icons.mic_off, size: 48),
          const SizedBox(height: ThemeConfig.smallSpacing),
          const Text(
            'মাইক্রোফোন অনুমতি প্রয়োজন',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: ThemeConfig.smallSpacing),
          const Text(
            'ভয়েস মেমো রেকর্ড করতে মাইক্রোফোন অনুমতি দিন',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: ThemeConfig.mediumSpacing),
          ElevatedButton(
            onPressed: _requestPermissions,
            child: const Text('অনুমতি দিন'),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Column(
        children: [
          CircularProgressIndicator(),
          SizedBox(height: ThemeConfig.smallSpacing),
          Text('রেকর্ডার প্রস্তুত হচ্ছে...'),
        ],
      ),
    );
  }

  Widget _buildAudioPlayer() {
    return Container(
      padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(ThemeConfig.smallRadius),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: _togglePlayback,
                icon: Icon(
                  _isPlaying ? Icons.pause_circle : Icons.play_circle,
                  size: 40,
                ),
                color: Theme.of(context).primaryColor,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _isPlaying ? 'চলছে...' : 'ভয়েস মেমো',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    LinearProgressIndicator(
                      value: _totalDuration.inMilliseconds > 0
                          ? _playbackPosition.inMilliseconds /
                              _totalDuration.inMilliseconds
                          : 0.0,
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${_formatDuration(_playbackPosition)} / ${_formatDuration(_totalDuration)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: _deleteAudio,
                icon: const Icon(Icons.delete),
                color: Theme.of(context).colorScheme.error,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRecorderControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (_currentAudioPath != null && !_isRecording)
          ElevatedButton.icon(
            onPressed: _startNewRecording,
            icon: const Icon(Icons.mic),
            label: const Text('নতুন রেকর্ডিং'),
          )
        else
          AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _isRecording ? _pulseAnimation.value : 1.0,
                child: FloatingActionButton(
                  onPressed: _isRecording ? _stopRecording : _startRecording,
                  backgroundColor: _isRecording
                      ? Theme.of(context).colorScheme.error
                      : Theme.of(context).primaryColor,
                  child: Icon(
                    _isRecording ? Icons.stop : Icons.mic,
                    color: Colors.white,
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildRecordingIndicator() {
    return Column(
      children: [
        AnimatedBuilder(
          animation: _waveAnimation,
          builder: (context, child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 20 + (10 * _waveAnimation.value * (index % 2 == 0 ? 1 : -1)),
                  width: 4,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error,
                    borderRadius: BorderRadius.circular(2),
                  ),
                );
              }),
            );
          },
        ),
        const SizedBox(height: ThemeConfig.smallSpacing),
        Text(
          'রেকর্ডিং... ${_formatDuration(_recordingDuration)}',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.error,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }

  Future<void> _startRecording() async {
    if (!_isRecorderInitialized || _isRecording) return;

    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'voice_memo_${DateTime.now().millisecondsSinceEpoch}.aac';
      final filePath = '${directory.path}/$fileName';

      await _recorder!.startRecorder(
        toFile: filePath,
        codec: Codec.aacADTS,
      );

      setState(() {
        _isRecording = true;
        _recordingDuration = Duration.zero;
      });

      _pulseController.repeat(reverse: true);
      _waveController.repeat(reverse: true);
      _startRecordingTimer();
    } catch (e) {
      debugPrint('Error starting recording: $e');
      _showErrorSnackBar('রেকর্ডিং শুরু করতে সমস্যা হয়েছে');
    }
  }

  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      final path = await _recorder!.stopRecorder();
      
      setState(() {
        _isRecording = false;
        _currentAudioPath = path;
      });

      _pulseController.stop();
      _waveController.stop();

      if (path != null) {
        widget.onAudioRecorded(path);
        _showSuccessSnackBar('ভয়েস মেমো সফলভাবে রেকর্ড হয়েছে');
      }
    } catch (e) {
      debugPrint('Error stopping recording: $e');
      _showErrorSnackBar('রেকর্ডিং বন্ধ করতে সমস্যা হয়েছে');
    }
  }

  void _startNewRecording() {
    setState(() {
      _currentAudioPath = null;
    });
    widget.onAudioDeleted();
  }

  Future<void> _togglePlayback() async {
    if (!_isPlayerInitialized || _currentAudioPath == null) return;

    try {
      if (_isPlaying) {
        await _player!.stopPlayer();
        setState(() {
          _isPlaying = false;
        });
      } else {
        await _player!.startPlayer(
          fromURI: _currentAudioPath!,
          whenFinished: () {
            setState(() {
              _isPlaying = false;
              _playbackPosition = Duration.zero;
            });
          },
        );
        setState(() {
          _isPlaying = true;
        });
        _startPlaybackTimer();
      }
    } catch (e) {
      debugPrint('Error toggling playback: $e');
      _showErrorSnackBar('অডিও চালাতে সমস্যা হয়েছে');
    }
  }

  void _deleteAudio() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ভয়েস মেমো মুছুন'),
        content: const Text('আপনি কি নিশ্চিত যে এই ভয়েস মেমোটি মুছে ফেলতে চান?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('বাতিল'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _currentAudioPath = null;
                _isPlaying = false;
              });
              widget.onAudioDeleted();
            },
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('মুছে ফেলুন'),
          ),
        ],
      ),
    );
  }

  void _startRecordingTimer() {
    Future.delayed(const Duration(seconds: 1), () {
      if (_isRecording) {
        setState(() {
          _recordingDuration = _recordingDuration + const Duration(seconds: 1);
        });
        _startRecordingTimer();
      }
    });
  }

  void _startPlaybackTimer() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_isPlaying && _player != null) {
        _player!.getProgress().then((progress) {
          if (mounted) {
            setState(() {
              _playbackPosition = progress.position;
              _totalDuration = progress.duration;
            });
          }
        });
        _startPlaybackTimer();
      }
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
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

