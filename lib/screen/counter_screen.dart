import 'package:flutter/material.dart';
import 'package:testing/controller/details_service.dart';
import 'package:testing/screen/details_screen.dart';
import '../../controller/counter_service.dart';

class CounterScreen extends StatefulWidget {
  final CounterService counterService;

  const CounterScreen({
    super.key,
    required this.counterService,
  });

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Flutter Testing Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // const Text(
            //   'You have pushed the button this many times:',
            // ),
            Text(
              '${widget.counterService.counter}',
              key: const Key('counter_text'),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              'Status: ${widget.counterService.getCounterStatus()}',
              key: const Key('status_text'),
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              widget.counterService.isEven() ? 'Even number' : 'Odd number',
              key: const Key('parity_text'),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FloatingActionButton(
                  key: const Key('decrement_button'),
                  onPressed: () {
                    setState(() {
                      widget.counterService.decrement();
                    });
                  },
                  heroTag: 'decrement',
                  child: const Icon(Icons.remove),
                ),
                FloatingActionButton(
                  key: const Key('reset_button'),
                  onPressed: () {
                    setState(() {
                      widget.counterService.reset();
                    });
                  },
                  heroTag: 'reset',
                  child: const Icon(Icons.refresh),
                ),
                FloatingActionButton(
                  key: const Key('increment_button'),
                  onPressed: () {
                    setState(() {
                      widget.counterService.increment();
                    });
                  },
                  heroTag: 'increment',
                  child: const Icon(Icons.add),
                ),
              ],
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              key: const Key('details_button'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailsScreen(
                      detailsService: DetailsService(
                        count: widget.counterService.counter,
                      ),
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.info_outline),
              label: const Text('Details'),
            ),
          ],
        ),
      ),
    );
  }
}
