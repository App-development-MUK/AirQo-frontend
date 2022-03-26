import 'package:app/constants/config.dart';
import 'package:app/widgets/custom_widgets.dart';
import 'package:flutter/material.dart';

import '../themes/light_theme.dart';
import 'analytics_view.dart';
import 'kya/know_your_air_view.dart';

class ForYouPage extends StatefulWidget {
  const ForYouPage({Key? key}) : super(key: key);

  @override
  _ForYouPageState createState() => _ForYouPageState();
}

class _ForYouPageState extends State<ForYouPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool analytics = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appTopBar(context, 'For You'),
      body: Container(
        padding: const EdgeInsets.only(right: 16, left: 16),
        color: Config.appBodyColor,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 10),
              child: Material(
                color: Colors.white,
                borderRadius: const BorderRadius.all(Radius.circular(7.0)),
                child: TabBar(
                    controller: _tabController,
                    indicatorColor: Colors.transparent,
                    labelColor: Colors.transparent,
                    unselectedLabelColor: Colors.transparent,
                    labelPadding: const EdgeInsets.all(3.0),
                    physics: const NeverScrollableScrollPhysics(),
                    onTap: (value) {
                      if (value == 0) {
                        setState(() {
                          analytics = true;
                        });
                      } else {
                        setState(() {
                          analytics = false;
                        });
                      }
                    },
                    tabs: <Widget>[
                      tabButton(text: 'Analytics'),
                      tabButton(text: 'Know your Air'),
                    ]),
              ),
            ),
            Expanded(
                child: TabBarView(
              controller: _tabController,
              physics: const NeverScrollableScrollPhysics(),
              children: const <Widget>[
                AnalyticsView(),
                KnowYourAirView(),
              ],
            )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  Widget tabButton({required String text}) {
    return Container(
      constraints:
          const BoxConstraints(minWidth: double.infinity, maxHeight: 32),
      decoration: BoxDecoration(
          color: text.toLowerCase() == 'analytics'
              ? analytics
                  ? Config.appColorBlue
                  : Colors.white
              : analytics
                  ? Colors.white
                  : Config.appColorBlue,
          borderRadius: const BorderRadius.all(Radius.circular(4.0))),
      child: Tab(
          child: Text(text,
              style: CustomTextStyle.button1(context)?.copyWith(
                color: text.toLowerCase() == 'analytics'
                    ? analytics
                        ? Colors.white
                        : Config.appColorBlue
                    : analytics
                        ? Config.appColorBlue
                        : Colors.white,
              ))),
    );
  }

  Widget topTabBar(text) {
    return Container(
      constraints:
          const BoxConstraints(minWidth: double.infinity, maxHeight: 32),
      decoration: BoxDecoration(
          color: analytics ? Config.appColorBlue : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(5.0))),
      child: Tab(
          child: Text(
        text,
        style: TextStyle(
          color: analytics ? Colors.white : Colors.black,
        ),
      )),
    );
  }
}
