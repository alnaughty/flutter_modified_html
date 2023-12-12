import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/html_parser.dart';
import 'package:flutter_html/src/navigation_delegate.dart';
import 'package:flutter_html/src/replaced_element.dart';
import 'package:flutter_html/style.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview;
import 'package:html/dom.dart' as dom;

/// [IframeContentElement is a [ReplacedElement] with web content.
class IframeContentElement extends ReplacedElement {
  final String? src;
  final double? width;
  final double? height;
  final String? baseUrl;
  final NavigationDelegate? navigationDelegate;
  final UniqueKey key = UniqueKey();

  IframeContentElement({
    required String name,
    required this.src,
    required this.width,
    this.baseUrl,
    required this.height,
    required dom.Element node,
    required this.navigationDelegate,
  }) : super(name: name, style: Style(), node: node, elementId: node.id);
  late final webview.WebViewController _controller =
      new webview.WebViewController()
        ..setNavigationDelegate(
          webview.NavigationDelegate(
            onNavigationRequest: (request) async {
              if (request.url.startsWith("https://www.pornhub.com") ||
                  request.url.startsWith("https://www.xvideos.com") ||
                  request.url.startsWith("https://xhamster.com") ||
                  request.url.startsWith("https://www.spankbang.com") ||
                  request.url.startsWith("https://www.youporn.com")) {
                return webview.NavigationDecision.prevent;
              } else {
                return webview.NavigationDecision.navigate;
              }
            },
          ),
        )
        ..loadHtmlString(src!, baseUrl: baseUrl);
  @override
  Widget toWidget(RenderContext context) {
    final sandboxMode = attributes["sandbox"];

    return Container(
      width: width ?? (height ?? 150) * 2,
      height: height ?? (width ?? 300) / 2,
      child: ContainerSpan(
        style: context.style,
        newContext: context,
        child: webview.WebViewWidget(
          key: key,
          controller: _controller
            ..setJavaScriptMode(
                sandboxMode == null || sandboxMode == "allow-scripts"
                    ? webview.JavaScriptMode.unrestricted
                    : webview.JavaScriptMode.disabled),
          gestureRecognizers: {
            Factory<VerticalDragGestureRecognizer>(
                () => VerticalDragGestureRecognizer())
          },
        ),
      ),
    );
  }
}
