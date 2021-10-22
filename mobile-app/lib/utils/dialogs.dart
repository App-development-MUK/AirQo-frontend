import 'package:app/constants/app_constants.dart';
import 'package:app/screens/my_places.dart';
import 'package:flutter/material.dart';

RawMaterialButton customOkayButton(context) {
  return RawMaterialButton(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
        side: BorderSide(color: ColorConstants.appColor, width: 1)),
    fillColor: ColorConstants.appColor,
    elevation: 0,
    highlightElevation: 0,
    splashColor: Colors.black12,
    highlightColor: ColorConstants.appColor.withOpacity(0.4),
    onPressed: () async {
      Navigator.of(context).pop();
    },
    child: const Padding(
      padding: EdgeInsets.all(4),
      child: Text(
        'Close',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}

void infoDialog(context, String message) {
  showGeneralDialog(
    context: context,
    barrierDismissible: false,
    transitionDuration: const Duration(milliseconds: 250),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: ScaleTransition(
          scale: animation,
          child: child,
        ),
      );
    },
    pageBuilder: (context, animation, secondaryAnimation) {
      return AlertDialog(
        title: const Text('AirQopedia'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: Text(
              'OK',
              style: TextStyle(color: ColorConstants.appColor),
            ),
          ),
        ],
      );
    },
  );
}

void showInfoDialog(BuildContext context, String text) {
  showDialog<void>(
    context: context,
    builder: (context) {
      return AlertDialog(
        content: Text(text),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('CLOSE'),
          ),
        ],
      );
    },
  );
}

Future<void> showSnackBar(context, String message) async {
  var snackBar = SnackBar(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    content: Text(
      message,
      softWrap: true,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: ColorConstants.snackBarBgColor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> showSnackBar2(context, String message) async {
  var snackBar = SnackBar(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 0,
    content: Text(
      message,
      softWrap: true,
      textAlign: TextAlign.center,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: ColorConstants.snackBarBgColor,
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Future<void> showSnackBarGoToMyPlaces(context, String message) async {
  var snackBar = SnackBar(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    content: Text(
      message,
      softWrap: true,
      textAlign: TextAlign.start,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: ColorConstants.snackBarBgColor,
    action: SnackBarAction(
      textColor: Colors.white,
      label: 'View MyPlaces',
      onPressed: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
          return const MyPlaces();
        }));
      },
    ),
  );
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

class ShowErrorDialog extends StatelessWidget {
  final String message;

  ShowErrorDialog({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Icon(
                  Icons.info_outline_rounded,
                  color: ColorConstants.red,
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text(
                      message,
                      softWrap: true,
                      style: TextStyle(
                        color: ColorConstants.appColor,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            customOkayButton(context),
          ],
        ),
      ),
    );
  }
}