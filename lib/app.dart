import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:sotong/screens/auth/plan/AutoRegisterSelect.dart';
//import 'package:sotong/screens/auth/plan/AutoRegisterSummary.dart';
import 'package:sotong/screens/auth/plan/VariableExpense.dart';
import 'package:sotong/screens/auth/plan/VariableExpenseSummary.dart';
import 'package:sotong/screens/auth/plan/planGuide.dart';
import 'models/VariableExpense_info.dart';

import 'models/refData.dart';
import 'models/plan_info.dart';
import 'models/sign_up_info.dart';
import 'models/dateEntry.dart';
import 'models/Entry.dart';
import 'screens/auth/welcome_auth_screen.dart';
import 'screens/auth/login/login_email.dart';
import 'screens/home/newHome.dart';
import 'screens/home/profile.dart';
import 'screens/auth/signUp/getEmail.dart';
import 'screens/auth/signUp/getPassword.dart';
import 'screens/auth/signUp/getUserInfo.dart';
import 'screens/auth/signUp/sign_up_success.dart';
import 'screens/auth/plan/getPlanName.dart';
import 'screens/auth/plan/getFixedIncome.dart';
import 'screens/auth/plan/getFixedConsumption.dart';
import 'screens/auth/plan/selectAlarm.dart';
import 'screens/auth/plan/consultOrNot.dart';
import 'screens/auth/plan/consultRatio.dart';
import 'screens/auth/plan/consultPeriod.dart';

import 'package:sotong/screens/additional/additional_choice.dart';
import 'package:sotong/screens/additional/deposit/deposit.dart';
import 'package:sotong/screens/additional/deposit/amount_change_choice.dart';
import 'package:sotong/screens/additional/deposit/period_application_complete.dart';
import 'package:sotong/screens/additional/deposit/limit_application_complete.dart';
import 'package:sotong/screens/additional/spending/spending.dart';
import 'package:sotong/screens/additional/spending/spending_amount_change_choice.dart';
import 'package:sotong/screens/additional/spending/spending_limit_application_complete.dart';
import 'package:sotong/screens/additional/spending/spending_period_application_complete.dart';

import 'package:sotong/screens/home/input_spend.dart';
import 'package:sotong/screens/home/spend_list.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sotong',
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/selectAlarm':
            final args = settings.arguments;
            if (args is Map<String, dynamic>) {
              final planInfo = args['planInfo'] as PlanInfo;
              final refData = args['refData'] as RefData;
              return MaterialPageRoute(
                builder: (context) => SelectAlarmPage(
                  planInfo: planInfo,
                  refData: refData,
                ),
              );
            }
            return _errorRoute();

          case '/summary':
            final args = settings.arguments;
            if (args is Map<String, dynamic>) {
              final planInfo = args['planInfo'] as PlanInfo;
              final refData = args['refData'] as RefData;
              return MaterialPageRoute(
                builder: (context) => SummaryPage(
                  planInfo: planInfo,
                  refData: refData,
                ),
              );
            }
            return _errorRoute();

          case '/variableExpense':
            final args = settings.arguments;
            if (args is Map<String, dynamic>) {
              final planInfo = args['planInfo'] as PlanInfo;
              final refData = args['refData'] as RefData;
              return MaterialPageRoute(
                builder: (context) => VariableExpensePage(
                  planInfo: planInfo,
                  refData: refData,
                ),
              );
            }
            return _errorRoute();

          case '/planGuide':
            final args = settings.arguments;
            if (args is Map<String, dynamic>) {
              final planInfo = args['planInfo'] as PlanInfo;
              final refData = args['refData'] as RefData;
              return MaterialPageRoute(
                builder: (context) => PlanGuidePage(
                  planInfo: planInfo,
                  refData: refData,
                ),
              );
            }
            return _errorRoute();

          case '/consultPeriod':
            final args = settings.arguments;
            if (args is Map<String, dynamic>) {
              final planInfo = args['planInfo'] as PlanInfo;
              final refData = args['refData'] as RefData;
              return MaterialPageRoute(
                builder: (context) => ConsultPeriodPage(
                  planInfo: planInfo,
                  refData: refData,
                ),
              );
            }
            return _errorRoute();

          case '/consultRatio':
            final args = settings.arguments;
            if (args is Map<String, dynamic>) {
              final planInfo = args['planInfo'] as PlanInfo;
              final refData = args['refData'] as RefData;
              return MaterialPageRoute(
                builder: (context) => ConsultRatioPage(
                  planInfo: planInfo,
                  refData: refData,
                ),
              );
            }
            return _errorRoute();

          case '/consultOrNot':
            final args = settings.arguments;
            if (args is Map<String, dynamic>) {
              final planInfo = args['planInfo'] as PlanInfo;
              final refData = args['refData'] as RefData;
              return MaterialPageRoute(
                builder: (context) => ConsultOrNotPage(
                  planInfo: planInfo,
                  refData: refData,
                ),
              );
            }
            return _errorRoute();

          case '/FixedConsumption':
            final args = settings.arguments;
            if (args is Map<String, dynamic>) {
              final planInfo = args['planInfo'] as PlanInfo;
              final refData = args['refData'] as RefData;
              return MaterialPageRoute(
                builder: (context) => FixedConsumptionPage(
                  planInfo: planInfo,
                  refData: refData,
                ),
              );
            }
            return _errorRoute();

          case '/FixedIncome':
            final args = settings.arguments;
            if (args is Map<String, dynamic>) {
              final planInfo = args['planInfo'] as PlanInfo;
              return MaterialPageRoute(
                builder: (context) => FixedIncomePage(
                  planInfo: planInfo,
                ),
              );
            }
            return _errorRoute();

          case '/getPlanName':
            return MaterialPageRoute(builder: (context) => const GetPlanNamePage());
          case '/signUpSuccess':
            return MaterialPageRoute(builder: (context) => const SignUpSuccessPage());
          case '/getUserInfo':
            final args = settings.arguments;
            if (args is SignUpInfo) {
              return MaterialPageRoute(
                builder: (context) => GetUserInfoPage(signUpInfo: args),
              );
            }
            return _errorRoute();
          case '/getPassword':
            final args = settings.arguments as SignUpInfo;
            if (args is SignUpInfo) {
              return MaterialPageRoute(
                builder: (context) => GetPasswordPage(signUpInfo: args),
              );
            }
            return _errorRoute();
          case '/getEmail':
            return MaterialPageRoute(builder: (context) => const GetEmailPage());
          case '/splash':
            return MaterialPageRoute(builder: (context) => const SplashScreen());
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case '/email_login':
            return MaterialPageRoute(builder: (context) => const EmailLoginPage());
          case '/':
            return MaterialPageRoute(builder: (context) => const HomePage());
          case '/myPage':
            return MaterialPageRoute(builder: (context) => const MyPage());

        //////////////////////////
          case '/deposit_period_application_complete':
            final args = settings.arguments;
            if (args is DateEntry) {
              return MaterialPageRoute(
                builder: (context) => DepositPeriodApplicationComplete(dateEntry: args),
              );
            }
            return _errorRoute();

          case '/deposit_limit_application_complete':
            final args = settings.arguments;
            if (args is DateEntry) {
              return MaterialPageRoute(
                builder: (context) => DepositLimitApplicationComplete(dateEntry: args),
              );
            }
            return _errorRoute();

          case '/deposit_amount_change_choice':
            final args = settings.arguments;
            if (args is DateEntry) {
              return MaterialPageRoute(
                builder: (context) => AmountChangeChoice(dateEntry: args),
              );
            }
            return _errorRoute();

          case '/deposit':
            final args = settings.arguments;
            if (args is DateEntry) {
              return MaterialPageRoute(
                builder: (context) => Deposit(dateEntry: args),
              );
            }
            return _errorRoute();

          case '/spending_period_application_complete':
            final args = settings.arguments;
            if (args is DateEntry) {
              return MaterialPageRoute(
                builder: (context) => SpendingPeriodApplicationComplete(dateEntry: args),
              );
            }
            return _errorRoute();

          case '/spending_limit_application_complete':
            final args = settings.arguments;
            if (args is DateEntry) {
              return MaterialPageRoute(
                builder: (context) => SpendingLimitApplicationComplete(dateEntry: args),
              );
            }
            return _errorRoute();

          case '/spending_amount_change_choice':
            final args = settings.arguments;
            if (args is DateEntry) {
              return MaterialPageRoute(
                builder: (context) => SpendingAmountChangeChoice(dateEntry: args),
              );
            }
            return _errorRoute();

          case '/spending':
            final args = settings.arguments;
            if (args is DateEntry) {
              return MaterialPageRoute(
                builder: (context) => Spending(dateEntry: args),
              );
            }
            return _errorRoute();

          case '/additional_choice':
            final args = settings.arguments;
            if (args is DateEntry) {
              return MaterialPageRoute(
                builder: (context) => AdditionalChoice(dateEntry: args),
              );
            }
            return _errorRoute();

          case '/input_spend':
            final args = settings.arguments;
            if (args is DateEntry) {
              return MaterialPageRoute(
                builder: (context) => InputSpendScreen(dateEntry: args),
              );
            }
            return _errorRoute();

          case '/spend_list':
            final args = settings.arguments;
            if (args is DateEntry) {
              return MaterialPageRoute(
                builder: (context) => SpendListScreen(dateEntry: args),
              );
            }
            return _errorRoute();

          default:
            return null;
        }
      },

      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
        ),
      ),

    );
  }
}

Route _errorRoute() {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      appBar: AppBar(title: Text('오류')),
      body: Center(
        child: Text('잘못된 접근입니다.'),
      ),
    ),
  );
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // 3초 뒤 로그인 페이지로 전환
    WidgetsBinding.instance.addPostFrameCallback((_) { // Flutter의 위젯 트리가 빌드된 후에 특정 작업을 수행하도록 예약하는 기능
      Timer(const Duration(seconds: 3), () {
        Navigator.of(context).pushReplacement(_createRoute());
      });
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SvgPicture.asset(
            'sotong_svg/sotong logo.svg',
            width: 200,
            height: 200,
          ),
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      const begin = Offset(1.0, 0.0);
      const end = Offset.zero;
      const curve = Curves.ease;

      final tween =
      Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      final offsetAnimation = animation.drive(tween);

      return SlideTransition(
        position: offsetAnimation,
        child: child,
      );
    },
  );
}