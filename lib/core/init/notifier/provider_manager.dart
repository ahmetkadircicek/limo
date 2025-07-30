import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:soforvarcom/feature/authentication/splash/viewmodel/splash_viewmodel.dart';

class ProviderManager {
  static ProviderManager? _instance;
  static ProviderManager get instance {
    _instance ??= ProviderManager._init();
    return _instance!;
  }

  ProviderManager._init();

  List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(create: (context) => SplashViewModel(context)),
      ];
}
