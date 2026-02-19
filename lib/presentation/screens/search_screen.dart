// lib/presentation/screens/search_screen.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/responsive_helper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  List<String> _recentSearches = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentSearches();
  }

  Future<void> _loadRecentSearches() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedSearches = prefs.getStringList('recent_searches') ?? [];

      if (mounted) setState(() {
        _recentSearches = savedSearches;
        _isLoading = false;
      });
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      debugPrint('Error loading recent searches: $e');
    }
  }

  Future<void> _saveSearch(String city) async {
    if (city.trim().isEmpty) return;

    _recentSearches.remove(city);
    _recentSearches.insert(0, city);

    if (_recentSearches.length > 5) {
      _recentSearches = _recentSearches.sublist(0, 5);
    }

    setState(() {});

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('recent_searches', _recentSearches);
    } catch (e) {
      debugPrint('Error saving recent searches: $e');
    }
  }

  Future<void> _clearAllSearches() async {
    final responsive = ResponsiveHelper(context);
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear History', style: TextStyle(fontSize: responsive.sp(18))),
        content: Text('Are you sure you want to clear all recent searches?',
            style: TextStyle(fontSize: responsive.sp(14))),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel', style: TextStyle(fontSize: responsive.sp(14))),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('Clear', style: TextStyle(fontSize: responsive.sp(14))),
          ),
        ],
      ),
    );

    if (confirm == true) {
      setState(() => _recentSearches.clear());
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('recent_searches');
      } catch (e) {
        debugPrint('Error clearing recent searches: $e');
      }
    }
  }

  void _handleSubmit(String value) {
    if (value.isNotEmpty) {
      _saveSearch(value);
      Navigator.pop(context, value);
    }
  }

  void _handleClear() => _controller.clear();

  void _handleTapRecent(String city) {
    _saveSearch(city);
    Navigator.pop(context, city);
  }

  @override
  Widget build(BuildContext context) {
    final responsive = ResponsiveHelper(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text('Search City', style: TextStyle(fontSize: responsive.sp(18))),
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
        padding: EdgeInsets.all(responsive.sp(16)),
        child: Column(
          children: [
            // Search Input Field
            Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(responsive.r(24)),
                border: Border.all(
                  color: isDark ? Colors.grey.shade700 : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _controller,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Enter city name (e.g., London, Tokyo)',
                  hintStyle: TextStyle(
                    color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                    fontSize: responsive.sp(14),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    size: responsive.sp(20),
                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  ),
                  suffixIcon: _controller.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(
                      Icons.clear,
                      size: responsive.sp(18),
                      color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                    ),
                    onPressed: _handleClear,
                  )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: responsive.wp(4),
                    vertical: responsive.hp(1.2),
                  ),
                ),
                onChanged: (value) => setState(() {}),
                onSubmitted: _handleSubmit,
                textInputAction: TextInputAction.search,
                style: TextStyle(fontSize: responsive.sp(16)),
              ),
            ),

            SizedBox(height: responsive.hp(2.5)),

            // Recent Searches Header
            if (_recentSearches.isNotEmpty) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.history,
                        size: responsive.sp(18),
                        color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                      ),
                      SizedBox(width: responsive.wp(2)),
                      Text(
                        'Recent Searches',
                        style: TextStyle(
                          fontSize: responsive.sp(15),
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.grey.shade300 : Colors.grey.shade800,
                        ),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: _clearAllSearches,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                      padding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(2),
                        vertical: responsive.hp(0.5),
                      ),
                    ),
                    child: Text(
                      'Clear All',
                      style: TextStyle(fontSize: responsive.sp(13)),
                    ),
                  ),
                ],
              ),

              SizedBox(height: responsive.hp(1.2)),

              // Recent Searches List
              Expanded(
                child: ListView.separated(
                  itemCount: _recentSearches.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1,
                    indent: responsive.wp(14),
                  ),
                  itemBuilder: (context, index) {
                    final city = _recentSearches[index];
                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: responsive.wp(2),
                      ),
                      leading: Container(
                        padding: EdgeInsets.all(responsive.sp(6)),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.location_on,
                          size: responsive.sp(16),
                          color: AppColors.primary,
                        ),
                      ),
                      title: Text(
                        city,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: responsive.sp(15),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: responsive.sp(14),
                        color: isDark ? Colors.grey.shade500 : Colors.grey.shade400,
                      ),
                      onTap: () => _handleTapRecent(city),
                    );
                  },
                ),
              ),
            ] else ...[
              // Empty State
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: responsive.wp(30),
                        height: responsive.wp(30),
                        constraints: const BoxConstraints(
                          maxWidth: 120,
                          maxHeight: 120,
                          minWidth: 80,
                          minHeight: 80,
                        ),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withOpacity(0.1),
                        ),
                        child: Icon(
                          Icons.search_rounded,
                          size: responsive.sp(40),
                          color: AppColors.primary.withOpacity(0.5),
                        ),
                      ),
                      SizedBox(height: responsive.hp(2.5)),
                      Text(
                        'No Recent Searches',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: responsive.sp(18),
                        ),
                      ),
                      SizedBox(height: responsive.hp(1)),
                      Text(
                        'Search for a city to see weather information',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: isDark ? Colors.grey.shade500 : Colors.grey.shade600,
                          fontSize: responsive.sp(14),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}