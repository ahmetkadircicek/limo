import 'package:limo/feature/home/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

class ProviderManager {
  static ProviderManager? _instance;
  static ProviderManager get instance {
    _instance ??= ProviderManager._init();
    return _instance!;
  }

  ProviderManager._init();

  List<SingleChildWidget> get providers => [
        ChangeNotifierProvider(create: (context) => HomeViewModel()),
      ];
}
