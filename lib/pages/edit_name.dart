import 'package:transcribe/config/config.dart';
import 'package:transcribe/extension/padding_extension.dart';
import 'package:transcribe/models/audiomodel.dart';
import 'package:transcribe/models/paragraphs.dart';
import 'package:transcribe/models/responsemodel.dart';
import 'package:transcribe/providers/audio_provider.dart';

class EditScreen extends ConsumerStatefulWidget {
  final AudioModel model;
  final bool isChangeName;

  const EditScreen({
    super.key,
    required this.model,
    this.isChangeName = false,
  });

  @override
  ConsumerState<EditScreen> createState() => _EditScreenState();
}

class _EditScreenState extends ConsumerState<EditScreen> {
  late TextEditingController _controller;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
        text: widget.isChangeName ? widget.model.filename : widget.model.responseModel?.paragraphs.transcript);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppTheme.scaffoldBackgroundColor,
        foregroundColor: AppTheme.lightFontColor,
        title: Text(widget.isChangeName ? 'Edit Name' : 'Edit Transcript'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              AudioModel newModel;
              if (formKey.currentState?.validate() ?? false) {
                if (widget.isChangeName) {
                  newModel = AudioModel(
                    id: DateTime.now().millisecondsSinceEpoch,
                    filename: _controller.text,
                    filePath: widget.model.filePath,
                    date: widget.model.date,
                    responseModel: Responsemodel(
                      paragraphs: Paragraphs(
                        transcript: widget.model.responseModel?.paragraphs.transcript ?? '',
                        paragraphs: widget.model.responseModel?.paragraphs.paragraphs ?? [],
                      ),
                    ),
                  );
                  ref.read(audioListProvider.notifier).deleteAudio(widget.model.id);
                  ref.read(audioListProvider.notifier).addAudio(newModel);
                } else {
                  newModel = AudioModel(
                    id: DateTime.now().millisecondsSinceEpoch,
                    filename: widget.model.filename,
                    filePath: widget.model.filePath,
                    date: widget.model.date,
                    responseModel: Responsemodel(
                      paragraphs: Paragraphs(
                        transcript: _controller.text,
                        paragraphs: widget.model.responseModel?.paragraphs.paragraphs ?? [],
                      ),
                    ),
                  );
                  ref.read(audioListProvider.notifier).deleteAudio(widget.model.id);
                  ref.read(audioListProvider.notifier).addAudio(newModel);
                }
                Navigator.pop(context, newModel);
              }
            },
            child: const Text(
              'Save',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _controller,
                  style: TextStyle(color: AppTheme.lightFontColor),
                  decoration: InputDecoration(
                    focusColor: AppTheme.primaryColor,
                    label: Text(
                      'Edit Text',
                      style: TextStyle(color: Colors.grey, fontSize: 18.sp),
                    ).paddingSymmetric(horizontal: 4),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                    ),
                    disabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppTheme.primaryColor, width: 2),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: AppTheme.lightFontColor.withAlpha(150), width: 2),
                    ),
                  ),
                  onTapOutside: (val) {
                    FocusScope.of(context).unfocus();
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Enter Valid ${widget.isChangeName ? 'Name' : 'Transcript'}';
                    } else {
                      return null;
                    }
                  },
                  maxLines: widget.isChangeName ? 1 : 100,
                  minLines: widget.isChangeName ? 1 : 10,
                  keyboardType: widget.isChangeName ? TextInputType.name : TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
