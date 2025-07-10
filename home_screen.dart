import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/memory_provider.dart';
import '../models/memory_model.dart';
import '../widgets/memory_card.dart';
import '../core/theme/theme_config.dart';
import 'add_memory_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  late AnimationController _fabAnimationController;
  late Animation<double> _fabAnimation;
  bool _isGridView = true;
  bool _isAuthenticating = false;

  @override
  void initState() {
    super.initState();
    _fabAnimationController = AnimationController(
      duration: ThemeConfig.mediumAnimation,
      vsync: this,
    );
    _fabAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fabAnimationController, curve: Curves.easeInOut),
    );
    _fabAnimationController.forward();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkBiometricAuth();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabAnimationController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAuth() async {
    final provider = Provider.of<MemoryProvider>(context, listen: false);
    
    if (provider.isBiometricEnabled && !provider.isAuthenticated) {
      setState(() {
        _isAuthenticating = true;
      });

      try {
        final isAuthenticated = await provider.authenticateWithBiometric();
        if (!isAuthenticated) {
          // Show error and exit app or show retry option
          _showAuthenticationFailedDialog();
        }
      } catch (e) {
        _showAuthenticationFailedDialog();
      } finally {
        setState(() {
          _isAuthenticating = false;
        });
      }
    }
  }

  void _showAuthenticationFailedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('প্রমাণীকরণ ব্যর্থ'),
        content: const Text('স্মৃতির বাক্স খুলতে আপনার পরিচয় যাচাই করুন।'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _checkBiometricAuth();
            },
            child: const Text('পুনরায় চেষ্টা করুন'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isAuthenticating) {
      return Scaffold(
        body: Container(
          decoration: context.watch<MemoryProvider>().isDarkMode
              ? ThemeConfig.darkPaperBackground
              : ThemeConfig.paperBackground,
          child: const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 24),
                Text(
                  'স্মৃতির বাক্স খোলা হচ্ছে...',
                  style: TextStyle(fontSize: 18),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Consumer<MemoryProvider>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Container(
            decoration: provider.isDarkMode
                ? ThemeConfig.darkPaperBackground
                : ThemeConfig.paperBackground,
            child: CustomScrollView(
              slivers: [
                _buildAppBar(provider),
                _buildSearchAndFilters(provider),
                _buildMemoriesGrid(provider),
              ],
            ),
          ),
          floatingActionButton: ScaleTransition(
            scale: _fabAnimation,
            child: FloatingActionButton(
              onPressed: () => _navigateToAddMemory(),
              tooltip: 'নতুন স্মৃতি যোগ করুন',
              child: const Icon(Icons.add),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAppBar(MemoryProvider provider) {
    return SliverAppBar(
      expandedHeight: 120,
      floating: false,
      pinned: true,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      flexibleSpace: FlexibleSpaceBar(
        title: const Text(
          'স্মৃতির বাক্স',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        background: Container(
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
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(_isGridView ? Icons.view_list : Icons.grid_view),
          onPressed: () {
            setState(() {
              _isGridView = !_isGridView;
            });
          },
          tooltip: _isGridView ? 'তালিকা দেখুন' : 'গ্রিড দেখুন',
        ),
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () => _navigateToSettings(),
          tooltip: 'সেটিংস',
        ),
      ],
    );
  }

  Widget _buildSearchAndFilters(MemoryProvider provider) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
        child: Column(
          children: [
            // Search bar
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'স্মৃতি খুঁজুন...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: null,
              ),
              onChanged: (value) {
                provider.setSearchQuery(value);
              },
            ),
            const SizedBox(height: ThemeConfig.mediumSpacing),
            
            // Category filters
            SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  _buildCategoryChip('সব', provider),
                  ...MemoryCategories.allCategories.map(
                    (category) => _buildCategoryChip(category, provider),
                  ),
                ],
              ),
            ),
            
            // Statistics
            if (provider.totalMemories > 0) ...[
              const SizedBox(height: ThemeConfig.mediumSpacing),
              _buildStatistics(provider),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String category, MemoryProvider provider) {
    final isSelected = provider.selectedCategory == category;
    
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(category),
        selected: isSelected,
        onSelected: (selected) {
          provider.setCategory(category);
        },
        backgroundColor: Theme.of(context).cardColor,
        selectedColor: Theme.of(context).primaryColor.withOpacity(0.2),
        checkmarkColor: Theme.of(context).primaryColor,
        labelStyle: TextStyle(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Theme.of(context).textTheme.bodyMedium?.color,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildStatistics(MemoryProvider provider) {
    return Container(
      padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
      decoration: ThemeConfig.memoryCardDecoration(provider.isDarkMode),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'মোট স্মৃতি',
            provider.totalMemories.toString(),
            Icons.collections_bookmark,
          ),
          _buildStatItem(
            'ক্যাটেগরি',
            provider.memoriesByCategory.length.toString(),
            Icons.category,
          ),
          _buildStatItem(
            'এই মাসে',
            provider.memories
                .where((m) => m.date.month == DateTime.now().month)
                .length
                .toString(),
            Icons.calendar_today,
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).primaryColor),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }

  Widget _buildMemoriesGrid(MemoryProvider provider) {
    if (provider.isLoading) {
      return const SliverFillRemaining(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (provider.memories.isEmpty) {
      return SliverFillRemaining(
        child: _buildEmptyState(provider),
      );
    }

    return _isGridView
        ? _buildGridView(provider)
        : _buildListView(provider);
  }

  Widget _buildEmptyState(MemoryProvider provider) {
    final hasSearch = provider.searchQuery.isNotEmpty;
    final hasFilter = provider.selectedCategory != 'সব';
    
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(ThemeConfig.largeSpacing),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              hasSearch || hasFilter ? Icons.search_off : Icons.photo_library_outlined,
              size: 80,
              color: Theme.of(context).primaryColor.withOpacity(0.5),
            ),
            const SizedBox(height: ThemeConfig.mediumSpacing),
            Text(
              hasSearch || hasFilter
                  ? 'কোন স্মৃতি পাওয়া যায়নি'
                  : 'এখনো কোন স্মৃতি নেই',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: ThemeConfig.smallSpacing),
            Text(
              hasSearch || hasFilter
                  ? 'অন্য কিছু খুঁজে দেখুন বা ফিল্টার পরিবর্তন করুন'
                  : 'আপনার প্রথম স্মৃতি যোগ করুন',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (!hasSearch && !hasFilter) ...[
              const SizedBox(height: ThemeConfig.largeSpacing),
              ElevatedButton.icon(
                onPressed: _navigateToAddMemory,
                icon: const Icon(Icons.add),
                label: const Text('স্মৃতি যোগ করুন'),
              ),
            ],
            if (hasSearch || hasFilter) ...[
              const SizedBox(height: ThemeConfig.largeSpacing),
              ElevatedButton.icon(
                onPressed: () {
                  provider.clearFilters();
                  _searchController.clear();
                },
                icon: const Icon(Icons.clear),
                label: const Text('ফিল্টার সাফ করুন'),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildGridView(MemoryProvider provider) {
    return SliverPadding(
      padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: ThemeConfig.mediumSpacing,
          mainAxisSpacing: ThemeConfig.mediumSpacing,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final memory = provider.memories[index];
            return MemoryCard(
              memory: memory,
              isGridView: true,
            );
          },
          childCount: provider.memories.length,
        ),
      ),
    );
  }

  Widget _buildListView(MemoryProvider provider) {
    return SliverPadding(
      padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
      sliver: SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final memory = provider.memories[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: ThemeConfig.mediumSpacing),
              child: MemoryCard(
                memory: memory,
                isGridView: false,
              ),
            );
          },
          childCount: provider.memories.length,
        ),
      ),
    );
  }

  void _navigateToAddMemory() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const AddMemoryScreen(),
      ),
    );
  }

  void _navigateToSettings() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }
}

