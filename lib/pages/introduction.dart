import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:transcribe/config/config.dart';
import 'package:transcribe/controllers/onboarding_controller.dart';
import 'package:transcribe/extension/context_extension.dart';
import 'package:transcribe/extension/padding_extension.dart';
import 'package:transcribe/pages/tabbar.dart';

class Introduction extends ConsumerStatefulWidget {
  const Introduction({Key? key}) : super(key: key);

  @override
  ConsumerState<Introduction> createState() => OnBoardingPageState();
}

class OnBoardingPageState extends ConsumerState<Introduction> {
  Future<void> _onIntroEnd(context) async {
    Utils.sendAnalyticsEvent(AnalyticsEvents.obDone);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const Tabbar(),
      ),
    );
  }

  final PageController pageController = PageController();

  @override
  void initState() {
    currentSource = Source.ob;
    Utils.sendAnalyticsEvent(AnalyticsEvents.obView);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final onboardingWatch = ref.watch(onboardingController);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFF1A1A1A),
              Color(0xFF121212),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: pageController,
                  itemCount: onboardingWatch.onboardingList.length,
                  itemBuilder: (context, index) {
                    final item = onboardingWatch.onboardingList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        color: Colors.transparent,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 40),
                              Expanded(
                                child: Image.asset(
                                  item.icon,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                item.title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 21.sp,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ).paddingSymmetric(horizontal: context.width * 0.25),
                              const SizedBox(height: 12),
                              Text(
                                item.subtitle,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  color: Colors.white70,
                                ),
                              ).paddingSymmetric(horizontal: context.width * 0.15),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 20),
              SmoothPageIndicator(
                controller: pageController,
                count: onboardingWatch.onboardingList.length,
                effect: const ExpandingDotsEffect(
                  activeDotColor: AppTheme.primaryColor,
                  dotColor: Colors.white30,
                  dotHeight: 10,
                  dotWidth: 10,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          if (pageController.page == onboardingWatch.onboardingList.length - 1) {
                            _onIntroEnd(context);
                          } else {
                            pageController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.primaryColor,
                          foregroundColor: AppTheme.staticBlackColor,
                          padding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 40,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text(
                          pageController.hasClients && pageController.page == onboardingWatch.onboardingList.length - 1
                              ? "Get Started"
                              : "Next",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
