import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:transcribe/components/components.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/extension/context_extension.dart';
import 'package:transcribe/extension/padding_extension.dart';

class SummaryScreen extends ConsumerStatefulWidget {
  const SummaryScreen({required this.summaryText, this.isFirstTime = false, super.key});

  final bool isFirstTime;
  final String summaryText;

  @override
  ConsumerState<SummaryScreen> createState() => _SummaryScreenState();
}

class _SummaryScreenState extends ConsumerState<SummaryScreen> {
  String summaryText = '';
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) {
      setState(() {
        summaryText = widget.summaryText;
      });
      if (widget.isFirstTime) {
        Utils.reviewDialog(context);
      }
    });
  }

  void _editSummary() {
    TextEditingController controller = TextEditingController(text: summaryText);
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        insetPadding: EdgeInsets.zero,
        child: Container(
          width: context.width * 0.6,
          height: context.height * 0.8,
          padding: const EdgeInsets.all(20.0),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(20.0),
            border: Border.all(
              color: Colors.white.withAlpha(40),
            ),
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Summary',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(height: 15),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    maxLines: 100,
                    style: const TextStyle(color: AppTheme.lightFontColor),
                    onTapOutside: (event) {
                      FocusScope.of(context).unfocus();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty || value.length < 3) {
                        return 'Enter the valid value';
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      hintText: 'Edit your summary here...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppTheme.cardBackgroundColor,
                      contentPadding: const EdgeInsets.all(15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text('Cancel', style: TextStyle(color: Colors.black)),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: () {
                        Utils.sendAnalyticsEvent(AnalyticsEvents.editSummary);
                        if (formKey.currentState?.validate() ?? false) {
                          setState(() {
                            summaryText = controller.text;
                          });
                          Navigator.pop(context);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        backgroundColor: AppTheme.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      child: const Text(
                        'Save',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _copySummary() {
    Utils.sendAnalyticsEvent(AnalyticsEvents.copySummary);
    Clipboard.setData(ClipboardData(text: summaryText));
    showToast('Summary copied to clipboard!', AppTheme.darkFontColor);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        foregroundColor: AppTheme.lightFontColor,
        title: const Text('Summary'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Summary of Transcription',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppTheme.lightFontColor,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: AppTheme.cardBackgroundColor,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: AppTheme.primaryColor.withAlpha(40),
                    width: 0.5,
                  ),
                ),
                child: SingleChildScrollView(
                  child: SelectableAutoLinkText(
                    summaryText,
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Row(
                    children: [
                      const Icon(HugeIcons.strokeRoundedEdit02, color: AppTheme.lightFontColor),
                      const SizedBox(width: 8),
                      Text(
                        'Edit',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppTheme.lightFontColor),
                      ),
                    ],
                  ),
                  onPressed: _editSummary,
                ),
                IconButton(
                  icon: Row(
                    children: [
                      const Icon(HugeIcons.strokeRoundedCopy01, color: AppTheme.lightFontColor),
                      const SizedBox(width: 8),
                      Text(
                        'Copy',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppTheme.lightFontColor),
                      ),
                    ],
                  ),
                  onPressed: _copySummary,
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  icon: Row(
                    children: [
                      const Icon(HugeIcons.strokeRoundedShare01, color: AppTheme.lightFontColor),
                      const SizedBox(width: 8),
                      Text(
                        'Share',
                        style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w500, color: AppTheme.lightFontColor),
                      ),
                    ],
                  ),
                  onPressed: () {
                    Utils.sendAnalyticsEvent(AnalyticsEvents.shareSummary);
                    Share.share(
                      summaryText,
                    );
                  },
                ),
              ],
            ).paddingSymmetric(horizontal: 20),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
