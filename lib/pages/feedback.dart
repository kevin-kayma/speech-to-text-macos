import 'package:transcribe/config/config.dart';

class FeedbackView extends StatelessWidget {
  const FeedbackView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(Strings.strFeedback),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Center(
            child: InAppWebView(
              initialUrlRequest:
                  URLRequest(url: WebUri.uri(Uri.parse(strFeedbackURL))),
            ),
          ),
        ),
      ),
    );
  }
}
