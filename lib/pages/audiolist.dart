import 'package:transcribe/components/components.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/providers/providers.dart';

class AllAudioListScreen extends ConsumerStatefulWidget {
  const AllAudioListScreen({super.key});

  @override
  ConsumerState<AllAudioListScreen> createState() => _AllAudioListScreenState();
}

class _AllAudioListScreenState extends ConsumerState<AllAudioListScreen> {
  @override
  Widget build(BuildContext context) {
    final allAudioList = ref.watch(audioListProvider).reversed.toList();

    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
          title: const Text('Audio List'),
          backgroundColor: AppTheme.scaffoldBackgroundColor,
          foregroundColor: AppTheme.lightFontColor,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Visibility(
                visible: allAudioList.isNotEmpty,
                child: IconButton(
                    onPressed: () {
                      Utils.showWarning(
                          strTitle: Strings.strChatAlertTitle,
                          strSubTitle: Strings.strChatAlertSubTitle,
                          onNo: () {
                            Navigator.pop(context);
                          },
                          onYes: () async {
                            ref
                                .read(audioListProvider.notifier)
                                .clearAudioHistory();

                            Navigator.pop(context);
                          },
                          context: context);
                    },
                    icon: HugeIcon(
                        icon: HugeIcons.strokeRoundedDelete03,
                        color: AppTheme.lightFontColor)),
              ),
            )
          ]),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: allAudioList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: audioCard(context, allAudioList[index]),
          );
        },
      ),
    );
  }
}
