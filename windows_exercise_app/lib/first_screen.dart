import 'package:fluent_ui/fluent_ui.dart';

class FirstScreen extends StatelessWidget {
  const FirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: ScaffoldPage(),
    );
  }
}
