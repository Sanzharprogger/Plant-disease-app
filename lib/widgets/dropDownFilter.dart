import 'package:flutter/material.dart';
import 'package:plant_disease_app/config/constants.dart';
import 'package:iconsax/iconsax.dart';
import 'package:plant_disease_app/widgets/checkMark.dart';

class DropDownFilter extends StatefulWidget {
  const DropDownFilter({Key? key, required this.options}) : super(key: key);
  final List<FilterItem> options;

  @override
  _DropDownFilterState createState() => _DropDownFilterState();
}

class _DropDownFilterState extends State<DropDownFilter>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    animationController = new AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    )..addListener(() {
        setState(() {});
      });
    animation = Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));
  }

  @override
  void dispose() {
    animationController.dispose();
    animationController.removeListener(() {
      setState(() {});
    });

    super.dispose();
  }

  late OverlayEntry _overlayEntry;
  int selectedIndex = 0;

  void _showOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    OverlayState overlayState = Overlay.of(context)!;

    _overlayEntry = OverlayEntry(
        builder: (context) => Stack(children: [
              Positioned.fill(
                  child: GestureDetector(
                      onTap: () async {
                        await animationController.reverse();
                        _overlayEntry.remove();
                      },
                      child: Container(
                        color: Colors.transparent,
                      ))),
              Positioned(
                  left: offset.dx - 200 + size.width,
                  top: offset.dy + size.height + 15,
                  child: Material(
                      type: MaterialType.transparency,
                      child: FadeTransition(
                        opacity: animation,
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.topCenter,
                          children: [
                            Container(
                              width: 200,
                              padding:
                                  EdgeInsets.only(bottom: kDefaultPadding / 2),
                              child: Column(
                                  children: widget.options
                                      .map((_filterItem) => FilterItem(
                                          text: _filterItem.text,
                                          active: selectedIndex ==
                                              widget.options
                                                  .indexOf(_filterItem),
                                          onPressed: () async {
                                            selectedIndex = widget.options
                                                .indexOf(_filterItem);
                                            await animationController.reverse();
                                            _overlayEntry.remove();
                                          }))
                                      .toList()),
                              decoration: BoxDecoration(
                                  color: Theme.of(context).backgroundColor,
                                  borderRadius: BorderRadius.circular(
                                      kDefaultBorderRaduis)),
                            ),
                            Positioned(
                                bottom: -18,
                                child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: kDefaultPadding * 0.3,
                                        horizontal: kDefaultPadding * 0.8),
                                    child: Center(
                                      child: Text(
                                        'Sort by:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary),
                                      ),
                                    ),
                                    decoration: BoxDecoration(
                                        color: Theme.of(context).accentColor,
                                        borderRadius: BorderRadius.circular(
                                            kDefaultBorderRaduis))))
                          ],
                        ),
                      )))
            ]));
    animationController.addListener(() {
      overlayState.setState(() {});
    });
    animationController.forward();
    overlayState.insert(_overlayEntry);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 54,
        width: 54,
        decoration: BoxDecoration(
            shape: BoxShape.circle, color: Theme.of(context).accentColor),
        child: Material(
            color: Colors.transparent,
            child: InkWell(
                splashColor: Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                onTap: () {
                  this._showOverlayEntry();
                },
                child: Icon(
                  Iconsax.sort,
                  color: Theme.of(context).colorScheme.onPrimary,
                ))));
  }
}

class FilterItem extends StatelessWidget {
  const FilterItem(
      {Key? key, required this.text, this.onPressed, this.active = false})
      : super(key: key);
  final String text;
  final bool active;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.circular(kDefaultBorderRaduis),
            onTap: () {
              this.onPressed!();
            },
            child: Container(
                padding: EdgeInsets.symmetric(
                    vertical: kDefaultPadding * 0.75,
                    horizontal: kDefaultPadding * 0.75),
                child: Row(children: [
                  this.active
                      ? CheckMark()
                      : SizedBox(
                          width: 20,
                        ),
                  SizedBox(width: 15),
                  Text(
                    this.text,
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  Spacer()
                ]))));
  }
}
