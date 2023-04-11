import 'package:flutter/material.dart';

class DefaultStreamBuilder<T> extends StatelessWidget {
  final Stream<Iterable<T>> stream;
  final Widget Function(Iterable<T>) body;

  const DefaultStreamBuilder(
      {Key? key,
      required this.stream,
      required this.body})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: StreamBuilder(
          stream: stream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text("${snapshot.error}"));
            }
            if (!snapshot.hasData) {
              return const Center(child: Text("No data"));
            }
            final data = snapshot.data!;
            return body(data);
          }),
    );
  }
}
