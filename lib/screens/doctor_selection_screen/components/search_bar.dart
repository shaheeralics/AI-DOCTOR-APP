import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import '../../../utils/constants.dart';

class SearchBar extends StatefulWidget {
  final Function(String) onSearchChanged;
  final String hintText;

  const SearchBar({
    Key? key,
    required this.onSearchChanged,
    this.hintText = 'Search doctors or specialties...',
  }) : super(key: key);

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  final TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Start animation after a delay
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        _animationController.forward();
      }
    });

    _searchController.addListener(() {
      widget.onSearchChanged(_searchController.text);
      setState(() {
        _isSearchActive = _searchController.text.isNotEmpty;
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    widget.onSearchChanged('');
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Opacity(
            opacity: _opacityAnimation.value,
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: widget.hintText,
                  hintStyle: TextStyle(
                    color: Colors.grey[500],
                    fontFamily: 'Montserrat',
                    fontSize: 14,
                  ),
                  prefixIcon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isSearchActive
                        ? Icon(
                            Ionicons.search,
                            color: kSecondaryColor,
                            key: const ValueKey('search_active'),
                          )
                        : Icon(
                            Ionicons.search_outline,
                            color: Colors.grey[500],
                            key: const ValueKey('search_inactive'),
                          ),
                  ),
                  suffixIcon: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    child: _isSearchActive
                        ? IconButton(
                            icon: const Icon(
                              Ionicons.close_circle,
                              color: Colors.grey,
                            ),
                            onPressed: _clearSearch,
                            key: const ValueKey('clear_button'),
                          )
                        : const SizedBox.shrink(
                            key: ValueKey('empty'),
                          ),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                style: const TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
