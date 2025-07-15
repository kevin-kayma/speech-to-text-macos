import 'package:transcribe/components/components.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/models/models.dart';
import 'package:transcribe/pages/pages.dart';

Widget audioCard(BuildContext context, AudioModel audioModel) {
  return ClickableCard(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AudioDetail(audioModel: audioModel),
        ),
      );
    },
    child: ListTile(
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Text(
          audioModel.filename,
          maxLines: 2,
          style:
              TextStyle(overflow: TextOverflow.ellipsis, fontWeight: FontWeight.w400, color: AppTheme.lightFontColor),
        ),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 8,
        children: [
          Text(
            audioModel.responseModel?.paragraphs.transcript ?? Strings.strNoResultFound,
            style:
                TextStyle(overflow: TextOverflow.ellipsis, color: AppTheme.greyFontColor, fontWeight: FontWeight.w300),
            maxLines: 3,
          ),
          Text(
            audioModel.date,
            style: TextStyle(
                overflow: TextOverflow.ellipsis,
                fontSize: Sizes.extraSmallFont,
                color: AppTheme.greyFontColor,
                fontWeight: FontWeight.w200),
            maxLines: 1,
          ),
        ],
      ),
      trailing: rotateBackArrow(),
    ),
  );
}
