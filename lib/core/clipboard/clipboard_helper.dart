// Cross-platform clipboard write.
//
// Mobile/desktop use Flutter's Clipboard.setData. The web implementation uses
// a synchronous textarea + execCommand('copy') inside the click gesture, which
// avoids the async Clipboard API's "Document is not focused" failures seen in
// some web environments.
import 'clipboard_default.dart'
    if (dart.library.html) 'clipboard_web.dart' as impl;

Future<void> copyTextToClipboard(String text) => impl.copyTextToClipboard(text);
