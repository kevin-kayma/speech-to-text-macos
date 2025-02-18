// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:transcribe/config/config.dart';

class ClickableCard extends StatelessWidget {
  final Widget child;

  final void Function() onTap;
  final Color? bgColor;
  const ClickableCard({
    Key? key,
    required this.child,
    required this.onTap,
    this.bgColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(intBorderRadius),
      ),
      color: bgColor ?? AppTheme.sidebarBackgroundColor,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        borderRadius: BorderRadius.circular(5),
        // splashColor: Theme.of(context).hoverColor,
        onTap: onTap,
        child: child,
      ),
    );
  }
}
