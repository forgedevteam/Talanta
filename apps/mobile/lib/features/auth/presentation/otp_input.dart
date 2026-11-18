import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talanta/core/theme/talanta_theme.dart';
import 'package:talanta_tokens/talanta_tokens.dart';

/// Six boxes over one invisible text field, so the keyboard, paste and
/// Android's SMS auto-fill all work the way they do for a normal field.
class OtpInput extends StatefulWidget {
  const OtpInput({
    required this.controller,
    required this.onCompleted,
    super.key,
    this.length = 6,
    this.enabled = true,
    this.hasError = false,
  });

  final TextEditingController controller;
  final ValueChanged<String> onCompleted;
  final int length;
  final bool enabled;
  final bool hasError;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput> {
  final _focus = FocusNode();

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onChanged);
    _focus.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _focus.dispose();
    super.dispose();
  }

  void _onChanged() {
    setState(() {});
    if (widget.controller.text.length == widget.length) {
      widget.onCompleted(widget.controller.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final digits = widget.controller.text;
    return GestureDetector(
      onTap: _focus.requestFocus,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (var i = 0; i < widget.length; i++)
                _Box(
                  digit: i < digits.length ? digits[i] : null,
                  active:
                      _focus.hasFocus &&
                      i == digits.length.clamp(0, widget.length - 1),
                  hasError: widget.hasError,
                  palette: palette,
                ),
            ],
          ),
          // The real field. Zero height so it never shows, but still focusable.
          Opacity(
            opacity: 0,
            child: SizedBox(
              height: 1,
              child: TextField(
                key: const ValueKey('otp-field'),
                controller: widget.controller,
                focusNode: _focus,
                enabled: widget.enabled,
                autofocus: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.oneTimeCode],
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(widget.length),
                ],
                showCursor: false,
                enableInteractiveSelection: false,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  filled: false,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Box extends StatelessWidget {
  const _Box({
    required this.digit,
    required this.active,
    required this.hasError,
    required this.palette,
  });

  final String? digit;
  final bool active;
  final bool hasError;
  final TalantaColors palette;

  @override
  Widget build(BuildContext context) {
    final border = hasError
        ? palette.danger
        : active
        ? TalantaBrand.primary
        : palette.outline;
    return AnimatedContainer(
      duration: TalantaDurations.fast,
      width: 48,
      height: 56,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: palette.surface,
        borderRadius: BorderRadius.circular(TalantaRadii.sm),
        border: Border.all(color: border, width: active || hasError ? 1.5 : 1),
      ),
      child: Text(
        digit ?? '',
        style: context.text.headlineSmall?.copyWith(fontFamily: 'Inter'),
      ),
    );
  }
}
