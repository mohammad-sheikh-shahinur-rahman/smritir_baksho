import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../models/memory_model.dart';
import '../providers/memory_provider.dart';
import '../screens/memory_details_screen.dart';
import '../core/theme/theme_config.dart';

class MemoryCard extends StatefulWidget {
  final MemoryModel memory;
  final bool isGridView;

  const MemoryCard({
    super.key,
    required this.memory,
    this.isGridView = true,
  });

  @override
  State<MemoryCard> createState() => _MemoryCardState();
}

class _MemoryCardState extends State<MemoryCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: ThemeConfig.shortAnimation,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MemoryProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTapDown: (_) => _animationController.forward(),
          onTapUp: (_) => _animationController.reverse(),
          onTapCancel: () => _animationController.reverse(),
          onTap: () => _navigateToDetails(),
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              decoration: ThemeConfig.memoryCardDecoration(provider.isDarkMode),
              child: widget.isGridView
                  ? _buildGridCard(provider)
                  : _buildListCard(provider),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridCard(MemoryProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: _buildImageSection(),
        ),
        Expanded(
          flex: 2,
          child: Padding(
            padding: const EdgeInsets.all(ThemeConfig.smallSpacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                const SizedBox(height: 4),
                _buildCategory(),
                const Spacer(),
                _buildDateAndIcons(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildListCard(MemoryProvider provider) {
    return Padding(
      padding: const EdgeInsets.all(ThemeConfig.mediumSpacing),
      child: Row(
        children: [
          _buildListImage(),
          const SizedBox(width: ThemeConfig.mediumSpacing),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                const SizedBox(height: 4),
                _buildDescription(),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _buildCategory(),
                    const Spacer(),
                    _buildDateAndIcons(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageSection() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(ThemeConfig.mediumRadius),
        topRight: Radius.circular(ThemeConfig.mediumRadius),
      ),
      child: Container(
        width: double.infinity,
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        child: widget.memory.imagePath != null
            ? Image.file(
                File(widget.memory.imagePath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildListImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(ThemeConfig.smallRadius),
      child: Container(
        width: 80,
        height: 80,
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        child: widget.memory.imagePath != null
            ? Image.file(
                File(widget.memory.imagePath!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return _buildPlaceholderImage();
                },
              )
            : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Theme.of(context).primaryColor.withOpacity(0.2),
            Theme.of(context).primaryColor.withOpacity(0.1),
          ],
        ),
      ),
      child: Icon(
        Icons.photo_library_outlined,
        size: widget.isGridView ? 40 : 30,
        color: Theme.of(context).primaryColor.withOpacity(0.6),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.memory.title,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
      maxLines: widget.isGridView ? 2 : 1,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildDescription() {
    return Text(
      widget.memory.description,
      style: Theme.of(context).textTheme.bodySmall,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCategory() {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).primaryColor.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        widget.memory.category,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  Widget _buildDateAndIcons() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.memory.audioPath != null) ...[
          Icon(
            Icons.mic,
            size: 16,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 4),
        ],
        if (widget.memory.imagePath != null) ...[
          Icon(
            Icons.image,
            size: 16,
            color: Theme.of(context).primaryColor,
          ),
          const SizedBox(width: 4),
        ],
        if (!widget.isGridView) const SizedBox(width: 8),
        Text(
          _formatDate(widget.memory.date),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'আজ';
    } else if (difference.inDays == 1) {
      return 'গতকাল';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} দিন আগে';
    } else if (difference.inDays < 30) {
      final weeks = (difference.inDays / 7).floor();
      return '$weeks সপ্তাহ আগে';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months মাস আগে';
    } else {
      return DateFormat('dd MMM yyyy', 'bn_BD').format(date);
    }
  }

  void _navigateToDetails() {
    Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            MemoryDetailsScreen(memory: widget.memory),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          var tween = Tween(begin: begin, end: end).chain(
            CurveTween(curve: curve),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
        transitionDuration: ThemeConfig.mediumAnimation,
      ),
    );
  }
}

