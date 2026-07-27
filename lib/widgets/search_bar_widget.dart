import 'package:flutter/material.dart';
import '../utils/validator.dart';
import 'search_textfield.dart';

/// Reusable Search Bar widget wrapping SearchTextField with validation logic.
class SearchBarWidget extends StatefulWidget {
  final ValueChanged<String> onSearch;
  final String? initialQuery;

  const SearchBarWidget({
    super.key,
    required this.onSearch,
    this.initialQuery,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  late final TextEditingController _controller;
  String? _inlineError;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitSearch() {
    final query = _controller.text;
    final validationError = CityValidator.validate(query);

    if (validationError != null) {
      setState(() {
        _inlineError = validationError;
      });
      return;
    }

    setState(() {
      _inlineError = null;
    });

    widget.onSearch(query.trim());
  }

  @override
  Widget build(BuildContext context) {
    return SearchTextField(
      controller: _controller,
      hintText: 'Search city name...',
      errorText: _inlineError,
      onSubmitted: (_) => _submitSearch(),
      onSearchPressed: _submitSearch,
      onClear: () {
        if (_inlineError != null) {
          setState(() {
            _inlineError = null;
          });
        }
      },
      onChanged: (text) {
        if (_inlineError != null) {
          setState(() {
            _inlineError = null;
          });
        }
      },
    );
  }
}
