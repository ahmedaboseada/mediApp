import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:medi/core/core.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "title": "Simplify Your Medication",
      "subtitle": "Add your medications once. We'll remind \n you on time.",
      "image": AppAssets.medication,
    },
    {
      "title": "Connected with Your Doctor",
      "subtitle":
          "Chat or call your doctor, share updates, and get support anytime.",
      "image": AppAssets.doctors,
    },
    {
      "title": "Track Your Health Progress",
      "subtitle": "See your health history and track your progress.",
      "image": AppAssets.progress,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.68,

              decoration: BoxDecoration(
                color: Color(0xff2F7CF6),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(AppSizes.r200),
                ),
              ),
            ),

            Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.go(AppRouter.homeScreen),
                    child: Text(
                      'Skip',
                      style: AppStyles.splashSubtitleText60016,
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _pages.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _pages[index]['title']!,
                              textAlign: TextAlign.center,
                              style: AppStyles.onboardingTitle,
                            ),
                            SizedBox(height: AppSizes.h16),
                            Text(
                              _pages[index]['subtitle']!,
                              textAlign: TextAlign.center,
                              style: AppStyles.onboardingSubtitle,
                            ),
                            SizedBox(height: AppSizes.h40),

                            SvgPicture.asset(
                              _pages[index]['image']!,
                              height: AppSizes.h196,
                              width: AppSizes.w300,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: AppSizes.h70),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.center,
                //   children: List.generate(
                //     _pages.length,
                //     (index) => AnimatedContainer(
                //       margin: const EdgeInsets.symmetric(horizontal: 4),
                //       width: _currentPage == index ? 19 : 12,
                //       height:  12,
                //       curve: Curves.bounceIn,
                //       decoration: BoxDecoration(
                //         color: _currentPage == index ? Colors.blue : Colors.grey,
                //         shape: _currentPage == index ? BoxShape.rectangle : BoxShape.circle,
                //         borderRadius: _currentPage == index ? BorderRadius.circular(50) : null,

                //       ), duration: const Duration(milliseconds: 300),
                //     ),
                //   ),
                // ),
                SmoothPageIndicator(
                  controller: _controller,
                  count: _pages.length,
                  effect: ExpandingDotsEffect(
                    dotHeight: 12,
                    dotWidth: 12,
                    activeDotColor: AppColors.primary,
                    dotColor: Colors.grey.shade300,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSizes.w16,
                    vertical: AppSizes.h12,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: PrimaryButton(
                      onPressed: () {
                        if (_currentPage < _pages.length - 1) {
                          _controller.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          PrefHelper.markOnboardingAsCompleted();
                          context.replace(AppRouter.selectScreen);
                        }
                      },

                      text: _currentPage == _pages.length - 1
                          ? 'Get Started'
                          : 'Next',
                    ),
                  ),
                ),
                SizedBox(height: AppSizes.h20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
