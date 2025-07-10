import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../providers/memory_provider.dart';
import '../core/theme/theme_config.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('সেটিংস'),
      ),
      body: Container(
        decoration: context.watch<MemoryProvider>().isDarkMode
            ? ThemeConfig.darkPaperBackground
            : ThemeConfig.paperBackground,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _buildSettingsList(),
      ),
    );
  }

  Widget _buildSettingsList() {
    return Consumer<MemoryProvider>(
      builder: (context, provider, child) {
        return ListView(
          padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
          children: [
            _buildSecuritySection(provider),
            const SizedBox(height: ThemeConfig.largeSpacing),
            _buildThemeSection(provider),
            const SizedBox(height: ThemeConfig.largeSpacing),
            _buildDataSection(provider),
            const SizedBox(height: ThemeConfig.largeSpacing),
            _buildAboutSection(),
          ],
        );
      },
    );
  }

  Widget _buildSecuritySection(MemoryProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.security),
                const SizedBox(width: ThemeConfig.smallSpacing),
                Text(
                  'নিরাপত্তা',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: ThemeConfig.mediumSpacing),
            FutureBuilder<bool>(
              future: provider.checkBiometricSupport(),
              builder: (context, snapshot) {
                final isSupported = snapshot.data ?? false;
                
                return SwitchListTile(
                  title: const Text('বায়োমেট্রিক লক'),
                  subtitle: Text(
                    isSupported
                        ? 'ফিঙ্গারপ্রিন্ট বা ফেস আনলক দিয়ে অ্যাপ সুরক্ষিত করুন'
                        : 'এই ডিভাইসে বায়োমেট্রিক সমর্থিত নয়',
                  ),
                  value: provider.isBiometricEnabled,
                  onChanged: isSupported
                      ? (value) => _toggleBiometric(provider)
                      : null,
                  secondary: const Icon(Icons.fingerprint),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeSection(MemoryProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.palette),
                const SizedBox(width: ThemeConfig.smallSpacing),
                Text(
                  'থিম ও চেহারা',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: ThemeConfig.mediumSpacing),
            SwitchListTile(
              title: const Text('ডার্ক মোড'),
              subtitle: const Text('অন্ধকার থিম ব্যবহার করুন'),
              value: provider.isDarkMode,
              onChanged: (value) => provider.toggleDarkMode(),
              secondary: Icon(
                provider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
              ),
            ),
            const Divider(),
            ListTile(
              title: const Text('প্রাথমিক রঙ'),
              subtitle: const Text('অ্যাপের মূল রঙ পরিবর্তন করুন'),
              leading: CircleAvatar(
                backgroundColor: provider.primaryColor,
                radius: 12,
              ),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showColorPicker(provider),
            ),
            const Divider(),
            ListTile(
              title: const Text('ফন্ট'),
              subtitle: Text('বর্তমান: ${provider.selectedFont}'),
              leading: const Icon(Icons.font_download),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showFontPicker(provider),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection(MemoryProvider provider) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.storage),
                const SizedBox(width: ThemeConfig.smallSpacing),
                Text(
                  'ডেটা ব্যবস্থাপনা',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: ThemeConfig.mediumSpacing),
            ListTile(
              title: const Text('ব্যাকআপ তৈরি করুন'),
              subtitle: const Text('সব স্মৃতি এক্সপোর্ট করুন'),
              leading: const Icon(Icons.backup),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _exportData(provider),
            ),
            const Divider(),
            ListTile(
              title: const Text('ব্যাকআপ পুনরুদ্ধার করুন'),
              subtitle: const Text('পূর্বের ব্যাকআপ ইমপোর্ট করুন'),
              leading: const Icon(Icons.restore),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _importData(provider),
            ),
            const Divider(),
            _buildStatistics(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildStatistics(MemoryProvider provider) {
    return ExpansionTile(
      title: const Text('পরিসংখ্যান'),
      leading: const Icon(Icons.analytics),
      children: [
        Padding(
          padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
          child: Column(
            children: [
              _buildStatRow('মোট স্মৃতি', provider.totalMemories.toString()),
              _buildStatRow(
                'ক্যাটেগরি',
                provider.memoriesByCategory.length.toString(),
              ),
              const SizedBox(height: ThemeConfig.mediumSpacing),
              const Text(
                'ক্যাটেগরি অনুযায়ী বিভাজন:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: ThemeConfig.smallSpacing),
              ...provider.memoriesByCategory.entries.map(
                (entry) => _buildStatRow(entry.key, entry.value.toString()),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.info),
                const SizedBox(width: ThemeConfig.smallSpacing),
                Text(
                  'অ্যাপ সম্পর্কে',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: ThemeConfig.mediumSpacing),
            ListTile(
              title: const Text('স্মৃতির বাক্স'),
              subtitle: const Text('সংস্করণ ১.০.০'),
              leading: const Icon(Icons.apps),
            ),
            const Divider(),
            const ListTile(
              title: Text('বিকাশকারী'),
              subtitle: Text('Flutter Developer'),
              leading: Icon(Icons.person),
            ),
            const Divider(),
            const ListTile(
              title: Text('বিবরণ'),
              subtitle: Text(
                'আপনার প্রিয় স্মৃতিগুলো সংরক্ষণ করুন ছবি, ভয়েস মেমো এবং বিস্তারিত বিবরণ সহ। '
                'সম্পূর্ণ অফলাইন এবং নিরাপদ।',
              ),
              leading: Icon(Icons.description),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _toggleBiometric(MemoryProvider provider) async {
    try {
      await provider.toggleBiometric();
      _showSuccessSnackBar(
        provider.isBiometricEnabled
            ? 'বায়োমেট্রিক লক চালু করা হয়েছে'
            : 'বায়োমেট্রিক লক বন্ধ করা হয়েছে',
      );
    } catch (e) {
      _showErrorSnackBar('বায়োমেট্রিক সেটিংস পরিবর্তনে সমস্যা: $e');
    }
  }

  void _showColorPicker(MemoryProvider provider) {
    final colors = [
      Colors.brown,
      Colors.blue,
      Colors.green,
      Colors.purple,
      Colors.red,
      Colors.orange,
      Colors.teal,
      Colors.indigo,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('রঙ নির্বাচন করুন'),
        content: Wrap(
          spacing: 16,
          runSpacing: 16,
          children: colors.map((color) {
            return GestureDetector(
              onTap: () {
                provider.setPrimaryColor(color);
                Navigator.of(context).pop();
              },
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  border: provider.primaryColor == color
                      ? Border.all(color: Colors.white, width: 3)
                      : null,
                ),
                child: provider.primaryColor == color
                    ? const Icon(Icons.check, color: Colors.white)
                    : null,
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('বাতিল'),
          ),
        ],
      ),
    );
  }

  void _showFontPicker(MemoryProvider provider) {
    final fonts = ['SolaimanLipi', 'Nikosh'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ফন্ট নির্বাচন করুন'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: fonts.map((font) {
            return RadioListTile<String>(
              title: Text(
                'নমুনা টেক্সট',
                style: TextStyle(fontFamily: font),
              ),
              subtitle: Text(font),
              value: font,
              groupValue: provider.selectedFont,
              onChanged: (value) {
                if (value != null) {
                  provider.setSelectedFont(value);
                  Navigator.of(context).pop();
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('বাতিল'),
          ),
        ],
      ),
    );
  }

  Future<void> _exportData(MemoryProvider provider) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await provider.exportData();
      final jsonString = const JsonEncoder.withIndent('  ').convert(data);
      
      final directory = await getApplicationDocumentsDirectory();
      final fileName = 'smritir_baksho_backup_${DateTime.now().millisecondsSinceEpoch}.json';
      final file = File('${directory.path}/$fileName');
      
      await file.writeAsString(jsonString);
      
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'স্মৃতির বাক্স ব্যাকআপ ফাইল',
      );
      
      _showSuccessSnackBar('ব্যাকআপ সফলভাবে তৈরি হয়েছে');
    } catch (e) {
      _showErrorSnackBar('ব্যাকআপ তৈরিতে সমস্যা: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _importData(MemoryProvider provider) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );

      if (result != null && result.files.single.path != null) {
        setState(() {
          _isLoading = true;
        });

        final file = File(result.files.single.path!);
        final jsonString = await file.readAsString();
        final data = jsonDecode(jsonString) as Map<String, dynamic>;

        await provider.importData(data);
        
        _showSuccessSnackBar('ব্যাকআপ সফলভাবে পুনরুদ্ধার হয়েছে');
      }
    } catch (e) {
      _showErrorSnackBar('ব্যাকআপ পুনরুদ্ধারে সমস্যা: $e');
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

