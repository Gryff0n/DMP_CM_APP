import 'package:flutter_test/flutter_test.dart';
import 'package:app_test/models/panier.dart';

void main() {
  late Panier panier;
  const stylo = Article('Stylo', 1.50);
  const cahier = Article('Cahier', 3.20);

  setUp(() {
    panier = Panier();
  });

  group('Panier', () {
    test('est vide à sa création', () {
      expect(panier.nombreArticles, 0);
      expect(panier.total, 0.0);
    });

    test("vider() ne casse pas sur un panier vide", () {
      expect(() => panier.vider(), returnsNormally);
      expect(panier.nombreArticles, 0);
    });

    test("vider() vide bien le panier", () {
      panier.ajouter(stylo);
      panier.ajouter(stylo, quantite: 2);

      panier.vider();

      expect(panier.total, 0.0);
      expect(panier.nombreArticles, 0);
    });

    test('ajouter cumule les quantités d\'un même article', () {
      // Arrange : fait dans setUp
      // Act
      panier.ajouter(stylo);
      panier.ajouter(stylo, quantite: 2);
      // Assert
      expect(panier.nombreArticles, 3);
    });

    test('total additionne prix × quantité', () {
      panier.ajouter(stylo, quantite: 2);
      panier.ajouter(cahier);

      expect(panier.total, closeTo(6.20, 0.001));
    });

    test('retirer supprime la ligne de l\'article', () {
      panier.ajouter(stylo);
      panier.ajouter(cahier);

      panier.retirer(stylo);

      expect(panier.nombreArticles, 1);
      expect(panier.total, closeTo(3.20, 0.001));
    });

    test('totalAvecRemise applique le pourcentage', () {
      panier.ajouter(cahier, quantite: 5); // 16.00 €

      expect(panier.totalAvecRemise(25), closeTo(12.0, 0.001));
    });

    test("totalAvecRemise throw ArgumentError si le pourcentage n'est pas dans [0,100]", () {
      panier.ajouter(cahier, quantite: 5); // 16.00 €

      expect(() => panier.totalAvecRemise(-1), throwsArgumentError);
      expect(panier.totalAvecRemise(0), 16.00);
      expect(panier.totalAvecRemise(100), 0);
      expect(() => panier.totalAvecRemise(101), throwsArgumentError);
    });

    test('lève ArgumentError si la quantité est nulle ou négative', () {
      expect(() => panier.ajouter(stylo, quantite: 0), throwsArgumentError);
      expect(
        () => panier.ajouter(stylo, quantite: -1),
        throwsA(isA<ArgumentError>()),
      );
    });
  });
}
