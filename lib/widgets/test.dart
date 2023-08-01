import 'package:flutter/material.dart';

class StatusAnimation extends StatefulWidget {
  final List<String>? list;
  const StatusAnimation({Key? key, this.list}) : super(key: key);

  @override
  State<StatusAnimation> createState() => _StatusAnimationState();
}

class _StatusAnimationState extends State<StatusAnimation>
    with TickerProviderStateMixin {
  List<AnimationController> listAnimationController = [];

  List<Animation<double>> listAnimations = [];

  static const duration = Duration(seconds: 3);

  PageController pageController = PageController();

  @override
  void initState() {
    if (widget.list != null && widget.list!.isNotEmpty) {
      for (var i in widget.list!) {
        listAnimationController
            .add(AnimationController(duration: duration, vsync: this));
      }

      for (var i in listAnimationController) {
        listAnimations.add(Tween(begin: 0.0, end: 100.0).animate(i));
      }

      listAnimationController.first.forward();

      for (int i = 0; i < listAnimationController.length; i++) {
        listAnimationController[i].addStatusListener((status) {
          if (listAnimationController[widget.list!.length - 1].status ==
              AnimationStatus.completed) {
          } else if (listAnimationController[i].status ==
              AnimationStatus.completed) {
            if (i < widget.list!.length - 1) {
              listAnimationController[i + 1].forward();
            }
          } else if (listAnimationController[i].status ==
              AnimationStatus.forward) {
            pageController.animateToPage(i,
                duration: const Duration(milliseconds: 500),
                curve: Curves.linear);
          }
        });
      }
    }

    super.initState();
  }

  @override
  void dispose() {
    for (var i in listAnimationController) {
      i.dispose();
    }
    super.dispose();
  }

  void onCallBack(int index) {
    setState(() {
      listAnimations[index] = Tween(begin: 100.0, end: 100.0)
          .animate(listAnimationController[index]);
    });

    if (index < widget.list!.length - 1) {
      listAnimationController[index + 1].forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: (widget.list == null || widget.list!.isEmpty)
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Stack(
              children: [
                PageView.builder(
                  itemCount: widget.list!.length,
                  controller: pageController,
                  itemBuilder: (context, index) => GestureDetector(
                    onTap: () {
                      if (index == widget.list!.length - 1) {
                        Navigator.of(context).pop();
                      } else {
                        onCallBack(index);
                        if (index + 1 < widget.list!.length) {
                          pageController.animateToPage(index + 1,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.linear);
                        }
                      }
                    },
                    child: Image.network(
                      widget.list!.elementAt(index),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5, top: 30),
                    child: Row(
                      children: List.generate(
                        widget.list!.length,
                        (index) => Expanded(
                          child: AnimatedStatus(
                            animationController:
                                listAnimationController.elementAt(index),
                            animation: listAnimations.elementAt(index),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class AnimatedStatus extends StatefulWidget {
  const AnimatedStatus({
    Key? key,
    required this.animationController,
    required this.animation,
  }) : super(key: key);

  final AnimationController animationController;
  final Animation<double> animation;

  @override
  State<AnimatedStatus> createState() => _AnimatedStatusState();
}

class _AnimatedStatusState extends State<AnimatedStatus> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 3,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(horizontal: 1),
        color: Colors.white.withOpacity(.50),
        child: AnimatedBuilder(
            animation: widget.animationController,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: widget.animation.value / 100,
                child: Container(
                  color: Colors.white,
                ),
              );
            }),
      ),
    );
  }
}
