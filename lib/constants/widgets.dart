import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String content;
  final GestureTapCallback onTap;
  const TaskCard(
      {Key? key,
      required this.title,
      required this.content,
      required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title.isNotEmpty)
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Theme.of(context).primaryColor,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (title.isNotEmpty && content.isNotEmpty)
                const SizedBox(
                  height: 10.0,
                ),
              if (content.isNotEmpty)
                Text(content,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 5,
                    style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).bottomAppBarColor,
                        height: 1.5))
            ],
          ),
        ),
      );
}

class TodoWidget extends StatefulWidget {
  final String todotitle;
  final bool isComplete;
  final GestureTapCallback onTap;
  final GestureTapCallback onTapDelete;
  final ValueChanged<String> onSave;
  const TodoWidget({
    Key? key,
    required this.todotitle,
    required this.isComplete,
    required this.onTap,
    required this.onTapDelete,
    required this.onSave,
  }) : super(key: key);

  @override
  State<TodoWidget> createState() => _TodoWidgetState();
}

class _TodoWidgetState extends State<TodoWidget> {
  late final TextEditingController _controller;
  late final FocusNode _titleFocus;
  late final ValueNotifier<bool> _showDelete;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _titleFocus = FocusNode();
    _showDelete = ValueNotifier<bool>(false);
    _titleFocus.addListener(() {
      if (_titleFocus.hasFocus) {
        if (!_showDelete.value) {
          _showDelete.value = true;
        }
      } else {
        widget.onSave(_controller.text);
        if (_showDelete.value) {
          _showDelete.value = false;
        }
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _titleFocus.dispose();
    _showDelete.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _controller.text = widget.todotitle;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: GestureDetector(
              onTap: widget.onTap,
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 12.0),
                    width: 20.0,
                    height: 20.0,
                    decoration: BoxDecoration(
                      color: widget.isComplete
                          ? Theme.of(context)
                              .floatingActionButtonTheme
                              .backgroundColor
                          : null,
                      borderRadius: BorderRadius.circular(6.0),
                      border: widget.isComplete
                          ? null
                          : Border.all(
                              color: Theme.of(context).backgroundColor,
                              width: 1.5,
                            ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 300),
                    opacity: widget.isComplete ? 1.0 : 0.0,
                    child: Align(
                      child: Icon(
                        Icons.done,
                        size: 19,
                        color: Theme.of(context).cardColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: _controller,
              focusNode: _titleFocus,
              maxLines: null,
              decoration: const InputDecoration(
                border: InputBorder.none,
              ),
              cursorColor:
                  Theme.of(context).floatingActionButtonTheme.backgroundColor,
              style: TextStyle(
                decoration: widget.isComplete
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                color: widget.isComplete
                    ? Theme.of(context).backgroundColor
                    : Theme.of(context).primaryColor,
                fontSize: 14.0,
                fontWeight:
                    widget.isComplete ? FontWeight.w200 : FontWeight.bold,
              ),
            ),
          ),
          ValueListenableBuilder(
            valueListenable: _showDelete,
            builder: (BuildContext context, bool value, Widget? child) {
              return Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Visibility(
                  visible: value,
                  child: InkWell(
                    onTap: widget.onTapDelete,
                    child: SizedBox(
                        width: 20.0,
                        height: 20.0,
                        child: Icon(Icons.close,
                            color: Theme.of(context).bottomAppBarColor)),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class RadioButton extends StatelessWidget {
  final String titleText;
  final bool isSelected;
  final Color selectedColor;
  final GestureTapCallback onTap;
  final Color textColor;
  const RadioButton({
    Key? key,
    required this.titleText,
    required this.isSelected,
    required this.selectedColor,
    required this.onTap,
    required this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: GestureDetector(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                titleText,
                style: TextStyle(fontSize: 16.0, color: textColor),
              ),
              Container(
                padding: const EdgeInsets.all(2.0),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  border: Border.all(color: selectedColor, width: 2.0),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: isSelected
                    ? Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: selectedColor,
                        ),
                      )
                    : null,
              ),
            ],
          ),
        ),
      );
}
