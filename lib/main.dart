import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:plantix_app/app/core/helpers/network_controller.dart';
import 'package:plantix_app/app/core/theme/app_theme.dart';
import 'package:plantix_app/app/data/repositories/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/app_pages.dart';

final apiKey = dotenv.env['API_KEY'];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init(); //initialize storage
  Get.put<NetworkController>(NetworkController(),
      permanent: true); //Check internet connection
  await dotenv.load(); //load env
  await Supabase.initialize(
    url: 'https://ziuujbwicwlbfyagxpna.supabase.co',
    anonKey: apiKey!,
  ); //initialize supabase

  runApp(const MyApp());
}

final supabase = Supabase.instance.client;
final user = UserManager.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return GestureDetector(
      onTap: () {
        FocusScopeNode currentNode = FocusScope.of(Get.context!);
        if (currentNode.focusedChild != null && !currentNode.hasPrimaryFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: GetMaterialApp(
        popGesture: true,
        // showPerformanceOverlay: true,
        // showSemanticsDebugger: true,
        defaultTransition: Transition.cupertino,
        debugShowCheckedModeBanner: false,
        theme: myTheme,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
      ),
    );
  }
}
