import 'package:billsplit_flutter/presentation/base/bloc/base_state.dart';
import 'package:billsplit_flutter/presentation/common/base_bloc_builder.dart';
import 'package:billsplit_flutter/presentation/common/base_bloc_widget.dart';
import 'package:billsplit_flutter/presentation/features/onboarding/bloc/onboarding_bloc.dart';
import 'package:billsplit_flutter/presentation/features/onboarding/bloc/onboarding_state.dart';
import 'package:billsplit_flutter/presentation/features/onboarding/screens/onboarding_step_change_display_name.dart';
import 'package:billsplit_flutter/presentation/features/onboarding/screens/onboarding_step_default_currency.dart';
import 'package:billsplit_flutter/presentation/features/onboarding/screens/onboarding_step_upload_pfp_screen.dart';
import 'package:billsplit_flutter/presentation/features/onboarding/screens/onboarding_step_welcome.dart';
import 'package:billsplit_flutter/presentation/utils/routing_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();

  static Route getRoute() => slideUpRoute(const OnboardingPage());
}

class _OnboardingPageState extends State<OnboardingPage> {
  final controller = PageController();

  @override
  Widget build(BuildContext context) {
    return BaseBlocWidget<OnboardingBloc>(
      create: (context) => OnboardingBloc(),
      listener: (context, cubit, event) {
        if (event is NextStepEvent) {
          _onNextStepEvent();
        } else if (event is PreviousStepEvent) {
          _onPrevStepEvent(context);
        } else if (event is ImReadyEvent) {
          _onImReadyEvent(context);
        }else if(event is SubmitUserSuccessEvent){
          _onSubmitSuccess(context);
        }
      },
      child: BaseBlocBuilder<OnboardingBloc>(
        builder: (cubit, state) {
          return Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () {
                  cubit.onPreviousClicked();
                },
              ),
              actions: [
                CloseButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ],
            ),
            body: Builder(
              builder: (context) {
                if(state is Loading){
                  return const Center(child: CircularProgressIndicator());
                }
                return PageView(
                  controller: controller,
                  children: const [
                    OnboardingStepWelcomeView(),
                    OnboardingStepChangeDisplayName(),
                    OnboardingStepUploadProfilePicture(),
                    OnboardingStepDefaultCurrency()
                  ],
                );
              }
            ),
          );
        },
      ),
    );
  }

  void _onNextStepEvent() {
    final nextPage = (controller.page ?? 0).round() + 1;
    controller.animateToPage(nextPage,
        duration: 500.ms, curve: Curves.fastEaseInToSlowEaseOut);
  }

  void _onPrevStepEvent(BuildContext context) {
    if ((controller.page?.round() ?? 0) == 0) {
      Navigator.of(context).pop();
    } else {
      final prevPage = (controller.page ?? 0).round() - 1;
      controller.animateToPage(prevPage,
          duration: 500.ms, curve: Curves.fastEaseInToSlowEaseOut);
    }
  }

  void _onImReadyEvent(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onSubmitSuccess(BuildContext context) {
    Navigator.of(context).pop();
  }
}
