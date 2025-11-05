import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance =
      NotificationService._();

  /// Optional global navigator key to allow showing overlays/snackbars without a BuildContext
  /// If your app sets this key on MaterialApp.navigatorKey, NotificationService can use it.
  GlobalKey<NavigatorState>? navigatorKey;

  static const _prefsKeyEnabled =
      'notifications_enabled';
  bool enabled = true;

  Future<void> loadConfig() async {
    try {
      final prefs =
          await SharedPreferences.getInstance();
      enabled =
          prefs.getBool(_prefsKeyEnabled) ?? true;
    } catch (_) {
      enabled = true;
    }
  }

  Future<void> saveConfig(bool value) async {
    try {
      final prefs =
          await SharedPreferences.getInstance();
      await prefs.setBool(_prefsKeyEnabled, value);
      enabled = value;
    } catch (_) {}
  }

  void showSnackBar(
      BuildContext context, String message,
      {Duration? duration}) {
    if (!enabled) return;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration:
            duration ?? const Duration(seconds: 2),
      ),
    );
  }

  /// Show a snackbar without passing a BuildContext. Requires [navigatorKey] to be set.
  void showSnackBarWithoutContext(String message,
      {Duration? duration}) {
    if (!enabled) return;
    final key = navigatorKey;
    if (key == null || key.currentState == null)
      return;
    final context = key.currentState!.overlay!.context;
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        duration:
            duration ?? const Duration(seconds: 2),
      ),
    );
  }

  /// A very small overlay toast (non-blocking) that sits above content.
  void showToast(BuildContext context, String message,
      {Duration? duration}) {
    if (!enabled) return;
    final overlay = Overlay.of(context);
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (ctx) => ToastOverlay(
        message: message,
        duration:
            duration ?? const Duration(seconds: 2),
        onFinish: () {
          entry.remove();
        },
        themeContext: context,
      ),
    );
    overlay.insert(entry);
  }

  /// Show a toast without a BuildContext. Requires [navigatorKey] to be set.
  void showToastWithoutContext(String message,
      {Duration? duration}) {
    if (!enabled) return;
    final key = navigatorKey;
    if (key == null || key.currentState == null)
      return;
    final context = key.currentState!.overlay!.context;
    showToast(context, message, duration: duration);
  }
}

class ToastOverlay extends StatefulWidget {
  final String message;
  final Duration duration;
  final VoidCallback onFinish;
  final BuildContext themeContext;

  const ToastOverlay({
    Key? key,
    required this.message,
    required this.duration,
    required this.onFinish,
    required this.themeContext,
  }) : super(key: key);

  @override
  State<ToastOverlay> createState() =>
      _ToastOverlayState();
}

class _ToastOverlayState extends State<ToastOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _offsetAnim;
  late final Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _offsetAnim = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: _ctrl, curve: Curves.easeOutCubic));
    _fadeAnim = CurvedAnimation(
        parent: _ctrl, curve: Curves.easeIn);
    _ctrl.forward();
    Future.delayed(widget.duration, () async {
      if (!mounted) return;
      await _ctrl.reverse();
      widget.onFinish();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(widget.themeContext);
    final bg = theme.colorScheme.surface
        .withAlpha((0.95 * 255).round());
    final fg = theme.colorScheme.onSurface;
    return Positioned(
      bottom: 50,
      left: 24,
      right: 24,
      child: SlideTransition(
        position: _offsetAnim,
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Material(
            color: Colors.transparent,
            child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Text(
                widget.message,
                style: TextStyle(color: fg),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
