import 'package:flutter/material.dart';
import '../services/search_service.dart';

class SearchInput extends StatefulWidget {
  final TextEditingController controller;
  final List<String> availableAnswers;
  final Function(String) onSubmitted;

  const SearchInput({
    super.key,
    required this.controller,
    required this.availableAnswers,
    required this.onSubmitted,
  });

  @override
  State<SearchInput> createState() => _SearchInputState();
}

class _SearchInputState extends State<SearchInput> {
  final SearchService _searchService = SearchService();
  List<String> _suggestions = [];
  bool _showSuggestions = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() async {
    final query = widget.controller.text;
    if (query.length >= 2) {
      final suggestions = await _searchService.getSuggestions(query, widget.availableAnswers);
      setState(() {
        _suggestions = suggestions;
        _showSuggestions = _suggestions.isNotEmpty;
      });
    } else {
      setState(() {
        _suggestions.clear();
        _showSuggestions = false;
      });
    }
  }

  void _onSuggestionTapped(String suggestion) {
    widget.controller.text = suggestion;
    setState(() {
      _showSuggestions = false;
    });
    widget.onSubmitted(suggestion);
  }

  void _onSubmitted(String value) {
    if (value.trim().isNotEmpty) {
      setState(() {
        _showSuggestions = false;
      });
      widget.onSubmitted(value.trim());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: TextField(
            controller: widget.controller,
            onSubmitted: _onSubmitted,
            decoration: InputDecoration(
              hintText: 'Tapez le nom d\'un joueur...',
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: const Icon(Icons.search, color: Colors.grey),
              suffixIcon: widget.controller.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear, color: Colors.grey),
                      onPressed: () {
                        widget.controller.clear();
                        setState(() {
                          _suggestions.clear();
                          _showSuggestions = false;
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
            ),
            style: const TextStyle(fontSize: 16),
          ),
        ),
        if (_showSuggestions) ...[
          const SizedBox(height: 8),
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: _suggestions.length,
              separatorBuilder: (context, index) => Divider(
                height: 1,
                color: Colors.grey.shade200,
              ),
              itemBuilder: (context, index) {
                final suggestion = _suggestions[index];
                return ListTile(
                  title: Text(
                    suggestion,
                    style: const TextStyle(fontSize: 16),
                  ),
                  leading: const Icon(
                    Icons.person,
                    color: Colors.grey,
                    size: 20,
                  ),
                  onTap: () => _onSuggestionTapped(suggestion),
                  dense: true,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}