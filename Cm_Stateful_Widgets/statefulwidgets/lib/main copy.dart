import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Démo Navigation',

      // DÉCO 1 : thème violet (AppBar + boutons)
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.purple),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.purple,
          foregroundColor: Colors.white,
          centerTitle: true,
        ),
      ),

      home: FirstScreen(),
    );
  }
}

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _FirstScreenState createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  String returnedMessage = "Aucun message retourné";

  var firstScreenMessage = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Premier écran')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // DÉCO 2 : marges autour du champ
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                controller: firstScreenMessage,
                decoration: InputDecoration(
                  labelText: 'Message pour écran 2 ?',
                  hintText: 'Écris ton message ici',
                  prefixIcon: const Icon(Icons.message_outlined),
                  filled: true,
                  fillColor: Colors.purple.shade50,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.purple.shade200),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide:
                        const BorderSide(color: Colors.purple, width: 2),
                  ),
                ),
              ),
            ),

            // DÉCO 3 : espace + texte un peu plus gros
            SizedBox(height: 20),
            Text(
              'Message retourné : $returnedMessage',
              style: TextStyle(fontSize: 18, color: Colors.purple),
            ),

            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                // Passer un message au second écran et attendre un résultat en retour
                final result = await Navigator.push<String>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SecondScreen(
                      message: firstScreenMessage.text,
                    ),
                  ),
                );
                // Mettre à jour l'état avec le message retourné
                if (result != null) {
                  setState(() {
                    returnedMessage = result;
                  });
                }
              },
              // DÉCO 4 : icône dans le bouton
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Aller à l\'écran suivant'),
                  SizedBox(width: 8),
                  Icon(Icons.arrow_forward),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatefulWidget {
  final String message;

  const SecondScreen({super.key, required this.message});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String messageToSend = 'Yes';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Second écran')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // DÉCO 3 (idem écran 1) : texte un peu plus gros
            Text(
              'Message reçu : ${widget.message}',
              style: TextStyle(fontSize: 18, color: Colors.purple),
            ),

            SizedBox(height: 20),

            RadioGroup<String>(
              groupValue: messageToSend,
              onChanged: (value) {
                setState(() {
                  messageToSend = value!;
                });
              },
              child: Column(
                children: const [
                  RadioListTile<String>(
                    title: Text('Yes'),
                    value: 'Yes',
                  ),
                  RadioListTile<String>(
                    title: Text('No'),
                    value: 'No',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Retourner l'option choisie au premier écran
                Navigator.pop(context, messageToSend);
              },
              child: const Text('Retourner au premier écran'),
            ),
          ],
        ),
      ),
    );
  }
}