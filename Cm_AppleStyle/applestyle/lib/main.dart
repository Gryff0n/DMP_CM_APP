import 'package:flutter/cupertino.dart';

void main() => runApp(const MonAppIOS());

class MonAppIOS extends StatelessWidget {
  const MonAppIOS({super.key});

  @override
  Widget build(BuildContext context) {
    return const CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: PageAccueil(),
    );
  }
}

class PageAccueil extends StatelessWidget {
  const PageAccueil({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(middle: Text('Mon App iOS')),
      child: Center(
        child: CupertinoButton.filled(
          child: const Text('Appuyer'),
          onPressed: () {
            showCupertinoDialog(
              context: context,
              builder: (context) => CupertinoAlertDialog(
                title: const Text('Salut 👋'),
                content: const Text('Ceci est une alerte iPhone.'),
                actions: [
                  CupertinoDialogAction(
                    child: const Text('OK'),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
