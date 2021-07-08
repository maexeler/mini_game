import 'package:flutter/material.dart';

// Code stolen from
// https://stackoverflow.com/questions/49307677/how-to-get-height-of-a-widget

/// Use it as following:
///
/// ```dart
/// SizeProviderWidget(
///   child:MyWidget(), //the widget we want the size of,
///   onChildSize:(size) {
///     // the size of the rendered MyWidget() is available here
///   }
/// )
/// ```
class SizeProviderWidget extends StatefulWidget {
  final Widget child;
  final Function(Size?) onChildSize;

  const SizeProviderWidget(
      {Key? key, required this.onChildSize, required this.child})
      : super(key: key);
  @override
  _SizeProviderWidgetState createState() => _SizeProviderWidgetState();
}

class _SizeProviderWidgetState extends State<SizeProviderWidget> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      widget.onChildSize(context.size);
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
