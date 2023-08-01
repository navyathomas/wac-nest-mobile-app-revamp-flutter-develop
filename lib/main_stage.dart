import 'main.dart';
import 'services/flavour_config.dart';

Future<void> main() async {
  FlavourConstants.setEnvironment(Environment.stage);
  await initializeApp();
}
