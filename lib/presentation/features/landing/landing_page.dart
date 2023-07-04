import 'package:billsplit_flutter/presentation/common/page_view_title.dart';
import 'package:billsplit_flutter/presentation/features/landing/widgets/sign_in_view.dart';
import 'package:billsplit_flutter/presentation/features/landing/widgets/sign_up_view.dart';
import 'package:flutter/material.dart';


class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final PageController pageController = PageController();

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Splitsby",
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
      ),
      body: Column(
        children: [
          PageViewTitle(
              pageController: pageController,
              titleOne: "Sign Up",
              titleTwo: "Sign in"),
          Expanded(
            child: PageView(
              controller: pageController,
              children: const [
                SignUpView(),
                SignInView(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
