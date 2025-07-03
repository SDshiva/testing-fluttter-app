import 'package:flutter/material.dart';
import '../services/details_service.dart';

class DetailsScreen extends StatefulWidget {
  final DetailsService detailsService;

  const DetailsScreen({
    super.key,
    required this.detailsService,
  });

  @override
  State<DetailsScreen> createState() => _DetailsScreenState();
}

class _DetailsScreenState extends State<DetailsScreen> {
  late TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController = TextEditingController(
      text: widget.detailsService.currentCount.toString(),
    );
  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  void _refreshUI() {
    setState(() {
      _inputController.text = widget.detailsService.currentCount.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final details = widget.detailsService;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.info_outline_rounded,
                        size: 48, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(height: 20),
                    Text(
                      'Current Count',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${details.currentCount}',
                      key: const Key('count_text'),
                      style: Theme.of(context)
                          .textTheme
                          .displaySmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      details.message,
                      key: const Key('message_text'),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      key: const Key('count_input_field'),
                      controller: _inputController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Enter new count',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton.icon(
                          key: const Key('recalculate_button'),
                          onPressed: () {
                            final newCount =
                                int.tryParse(_inputController.text);
                            if (newCount != null) {
                              details.updateCount(newCount);
                              _refreshUI();
                            }
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Recalculate'),
                        ),
                        ElevatedButton.icon(
                          key: const Key('reset_button'),
                          onPressed: () {
                            details.reset();
                            _refreshUI();
                          },
                          icon: const Icon(Icons.restart_alt),
                          label: const Text('Reset'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      key: const Key('back_button'),
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => Navigator.pop(context),
                      label: const Text('Go Back'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
