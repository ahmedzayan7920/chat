import 'package:flutter/material.dart';
import 'package:pinput/pinput.dart';

class CustomPinput extends StatefulWidget {
  final bool isEnabled;
  final Function(String) onChanged;
  final Function(String) onCompleted;
  final int length;

  const CustomPinput({
    super.key,
    required this.isEnabled,
    required this.onChanged,
    required this.onCompleted,
    this.length = 6,
  });

  @override
  State<CustomPinput> createState() => _CustomPinputState();
}

class _CustomPinputState extends State<CustomPinput> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.isEnabled) {
        _focusNode.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Pinput(
      focusNode: _focusNode,
      enabled: widget.isEnabled,
      onChanged: widget.onChanged,
      onCompleted: widget.onCompleted,
      length: widget.length,
      defaultPinTheme: PinTheme(
        width: 56,
        height: 80,
        textStyle: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: Theme.of(context).colorScheme.onSecondary),
        decoration: BoxDecoration(
          border: Border.all(
            color: Theme.of(context).colorScheme.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
      ),
    );
  }
}
