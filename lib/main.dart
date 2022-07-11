import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:reel_ro/app/routes/app_page.dart';
import 'package:reel_ro/utils/colors.dart';
import 'firebase_options.dart';

late PackageInfo kPackageInfo;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
   await GetStorage.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  kPackageInfo = await PackageInfo.fromPlatform();
  runApp(const MyApp());
}

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  TextTheme buildTheme(TextTheme base) {
    return base
        .copyWith(
            displayMedium: const TextStyle(
              fontWeight: FontWeight.w500,
            ),
            headlineSmall: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
            titleLarge: const TextStyle(fontWeight: FontWeight.w700),
            titleMedium: const TextStyle(
              fontWeight: FontWeight.w400,
              color: Color(0xff2B2C43),
            ),
            titleSmall: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Color(0xff393F45),
            ))
        .apply(
          fontFamily: 'Poppins',
        );
  }

  @override
  Widget build(BuildContext context) {
    final base = ThemeData.light();
    return GetMaterialApp(
      title: 'Reel Ro',
      scaffoldMessengerKey: snackbarKey,
      theme: ThemeData(
        primarySwatch: Colors.amber,
        colorScheme: base.colorScheme.copyWith(
          primary: AppColors.primary,
          onPrimary: Colors.white,
          secondary: AppColors.secondary,
          primaryContainer: AppColors.primaryContainer,
          error: Colors.red,
        ),
        fontFamily: 'Poppins',
        textTheme: buildTheme(base.textTheme),
        primaryTextTheme: buildTheme(base.textTheme),
        buttonTheme: const ButtonThemeData(
          textTheme: ButtonTextTheme.primary,
        ),
        iconTheme: const IconThemeData(
          color: Colors.black,
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          hintStyle: base.textTheme.bodyLarge?.copyWith(
            fontFamily: 'Poppins',
            color: AppColors.subtitle1Color.withOpacity(.6),
          ),
          contentPadding: EdgeInsets.symmetric(
            horizontal: Get.width * 0.04,
            vertical: Get.height * 0.025,
          ),
          fillColor: AppColors.textFieldColor,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: Colors.transparent),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const RoundedRectangleBorder(
               borderRadius: BorderRadius.all(Radius.circular(12))
            )),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            foregroundColor:
                MaterialStateProperty.all(AppColors.buttonTextColor),
            shape: MaterialStateProperty.all(
              const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
            ),
            minimumSize: MaterialStateProperty.all(
              const Size.fromHeight(60),
            ),
            shadowColor: MaterialStateProperty.all(Colors.transparent),
            backgroundColor: MaterialStateProperty.all(Colors.transparent),
          ),
        ),
      ),
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      initialRoute: AppPages.initial,
    );
  }
}

/* class Root extends StatelessWidget {
  const Root({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home page"),
      ),
    );
  }
} */
