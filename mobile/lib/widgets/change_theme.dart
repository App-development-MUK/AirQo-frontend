import 'package:app/providers/theme_provider.dart';
import 'package:flutter/material.dart';

class ChangeThemeDialog extends StatefulWidget {
  final Themes initialValue;

  final void Function(Themes) onValueChange;

  const ChangeThemeDialog(
      {Key? key, required this.onValueChange, required this.initialValue})
      : super(key: key);

  @override
  State createState() => ChangeThemeDialogState();
}

class ChangeThemeDialogState extends State<ChangeThemeDialog> {
  Themes? _theme = Themes.lightTheme;

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: const Text('Change Theme'),
      children: <Widget>[
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<Themes>(
              title: const Text('Light Mode'),
              value: Themes.lightTheme,
              groupValue: _theme,
              onChanged: (Themes? value) {
                setState(() {
                  _theme = value;
                });

                if (value != null) {
                  ThemeController.of(context).setTheme('light');
                  widget.onValueChange(value);
                }
              },
            ),
            RadioListTile<Themes>(
              title: const Text('Dark Mode'),
              value: Themes.darkTheme,
              groupValue: _theme,
              onChanged: (Themes? value) {
                setState(() {
                  _theme = value;
                });

                if (value != null) {
                  ThemeController.of(context).setTheme('dark');

                  widget.onValueChange(value);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    _theme = widget.initialValue;
  }
}

enum Themes { lightTheme, darkTheme }
