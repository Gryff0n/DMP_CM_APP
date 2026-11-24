class Article {
  final String nom;
  final double prix;

  const Article(this.nom, this.prix);
}

class Panier {
  final Map<Article, int> _lignes = {};

  int get nombreArticles => _lignes.values.fold(0, (somme, q) => somme + q);

  double get total =>
      _lignes.entries.fold(0.0, (somme, e) => somme + e.key.prix * e.value);

  void ajouter(Article article, {int quantite = 1}) {
    if (quantite <= 0) {
      throw ArgumentError.value(quantite, 'quantite', 'doit être > 0');
    }
    _lignes.update(article, (q) => q + quantite, ifAbsent: () => quantite);
  }

  void retirer(Article article) => _lignes.remove(article);

  void vider() => _lignes.clear();

  /// Applique une remise en pourcentage (entre 0 et 100).
  double totalAvecRemise(double pourcentage) {
    if (pourcentage < 0 || pourcentage > 100) {
      throw ArgumentError(
        "pourcentage n'appartient pas a l'intervalle [0,100]",
      );
    }
    assert(pourcentage >= 0 && pourcentage <= 100);
    return total * (1 - pourcentage / 100);
  }
}
