import 'package:flutter/material.dart';
import 'package:food_hunt/core/assets/app_assets.dart';
import 'package:lottie/lottie.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PayStackScreen extends StatefulWidget {
  final String checkoutUrl;

  PayStackScreen({
    Key? key,
    required this.checkoutUrl,
  }) : super(key: key);

  @override
  State<PayStackScreen> createState() => _PayStackScreenState();
}

class _PayStackScreenState extends State<PayStackScreen> {
  WebViewController controller = WebViewController();
  WebViewCookieManager cookieManager = WebViewCookieManager();
  Widget? loadingReplacement;
  bool isLoading = true;

  @override
  initState() {
    super.initState();

    cookieManager.clearCookies();

    final webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white70)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) async {},
          onUrlChange: (urlChange) async {
            if (urlChange.url!.startsWith("https://khervie00.vercel.app")) {
              setState(() {
                isLoading = true;
              });
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => CashBackTierPostPayStackScreen(
              //         cashbackTier: widget.cashbackTier),
              //   ),
              // );
            } else {
              setState(() {
                isLoading = false;
              });
            }
          },
          onPageFinished: (String url) async {},
        ),
      )
      ..loadRequest(Uri.parse(widget.checkoutUrl));

    controller = webViewController;

    cookieManager.clearCookies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: Lottie.asset(
              AppAssets.circularProgressJson,
              width: 80,
              height: 80,
              fit: BoxFit.fill,
            ))
          : Stack(
              children: <Widget>[
                WebViewWidget(
                  controller: controller,
                ),
                Visibility(
                  visible: loadingReplacement != null && (isLoading),
                  child: Center(
                      child: Lottie.asset(
                    AppAssets.circularProgressJson,
                    width: 80,
                    height: 80,
                    fit: BoxFit.fill,
                  )),
                ),
              ],
            ),
    );
  }
}
