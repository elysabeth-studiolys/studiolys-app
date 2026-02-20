import '../../domain/entities/quote.dart';

class QuoteDataSource {
  static const List<Quote> _quotes = [
    Quote(text: "La vie est un mystère qu'il faut vivre, et non un problème à résoudre", author: "Gandhi"),
    Quote(text: "Deviens ce que tu es", author: "Nietzsche"),
    Quote(text: "Connais-toi toi-même", author: "Socrate"),
    Quote(text: "Le bonheur dépend de nous seuls", author: "Aristote"),
    Quote(text: "Ce qui ne me tue pas me rend plus fort", author: "Nietzsche"),
    Quote(text: "La simplicité est la sophistication suprême", author: "Léonard de Vinci"),
    Quote(text: "Vis comme si tu devais mourir demain. Apprends comme si tu devais vivre toujours", author: "Gandhi"),
    Quote(text: "Le véritable voyage de découverte ne consiste pas à chercher de nouveaux paysages, mais à avoir de nouveaux yeux", author: "Marcel Proust"),
    Quote(text: "Fais de ta vie un rêve, et d'un rêve, une réalité", author: "Antoine de Saint-Exupéry"),
    Quote(text: "Rien n'est permanent, sauf le changement", author: "Héraclite"),
    
    Quote(text: "La paix vient de l'intérieur. Ne la cherche pas à l'extérieur", author: "Bouddha"),
    Quote(text: "Le courage, c'est de comprendre sa propre vie", author: "Jean-Paul Sartre"),
    Quote(text: "Agis, et la voie apparaîtra", author: "Rumi"),
    Quote(text: "La liberté commence où l'ignorance finit", author: "Victor Hugo"),
    Quote(text: "On ne voit bien qu'avec le cœur", author: "Antoine de Saint-Exupéry"),
    Quote(text: "Tout ce que nous sommes est le résultat de ce que nous avons pensé", author: "Bouddha"),
    Quote(text: "La plus grande richesse est de vivre content de peu", author: "Platon"),
    Quote(text: "Ce n'est pas la mort que l'homme doit craindre, mais de ne jamais commencer à vivre", author: "Marc Aurèle"),
    Quote(text: "La vie est maintenant", author: "Eckhart Tolle"),
    Quote(text: "Choisis d'être heureux", author: "Épictète"),
    
    Quote(text: "Fais de ton mieux, et laisse le reste aller", author: "Proverbe zen"),
    Quote(text: "La joie est en tout, il faut savoir l'extraire", author: "Confucius"),
    Quote(text: "L'homme se découvre quand il se mesure à l'obstacle", author: "Antoine de Saint-Exupéry"),
    Quote(text: "Chaque instant est un commencement", author: "T.S. Eliot"),
    Quote(text: "Le silence est parfois la meilleure réponse", author: "Dalaï-Lama"),
    Quote(text: "Apprends à lâcher ce que tu ne peux contrôler", author: "Sénèque"),
    Quote(text: "La patience est une force", author: "Jean-Jacques Rousseau"),
    Quote(text: "La vie est courte, mais large", author: "Victor Hugo"),
    Quote(text: "Ce que tu cherches te cherche aussi", author: "Rumi"),
    Quote(text: "Sois le changement que tu veux voir dans le monde", author: "Gandhi"),
    
    Quote(text: "Il n'y a pas de chemin vers le bonheur, le bonheur est le chemin", author: "Bouddha"),
    Quote(text: "Rien de grand ne s'est accompli sans passion", author: "Hegel"),
    Quote(text: "L'essentiel est invisible pour les yeux", author: "Antoine de Saint-Exupéry"),
    Quote(text: "Tout passe", author: "Proverbe perse"),
    Quote(text: "Le bonheur n'est pas une destination, mais une manière de voyager", author: "Margaret Lee Runbeck"),
    Quote(text: "Vivre, c'est changer", author: "Henri Bergson"),
    Quote(text: "Ce qui compte, c'est le sens", author: "Viktor Frankl"),
    Quote(text: "La sagesse commence dans l'émerveillement", author: "Socrate"),
    Quote(text: "Apprends à te suffire", author: "Épicure"),
    Quote(text: "La plus grande victoire est sur soi-même", author: "Platon"),
    
    Quote(text: "Respire, tu es vivant", author: "Thich Nhat Hanh"),
    Quote(text: "La vérité est en marche", author: "Émile Zola"),
    Quote(text: "L'espoir est une bonne chose", author: "Stephen King"),
    Quote(text: "Le doute est le commencement de la sagesse", author: "Aristote"),
    Quote(text: "La vie est un équilibre entre lâcher prise et tenir bon", author: "Rumi"),
    Quote(text: "Sois doux avec toi-même", author: "Bouddha"),
    Quote(text: "La force vient du calme", author: "Proverbe chinois"),
    Quote(text: "Tout commence par un pas", author: "Lao Tseu"),
    Quote(text: "Le présent est le seul temps qui nous appartient", author: "Pascal"),
    Quote(text: "La conscience précède le changement", author: "Carl Rogers"),
    
    Quote(text: "Ce que tu fais aujourd'hui compte", author: "Bouddha"),
    Quote(text: "La joie naît de l'acceptation", author: "Marc Aurèle"),
    Quote(text: "Vis simplement", author: "Henry David Thoreau"),
    Quote(text: "La clarté apporte la paix", author: "Jiddu Krishnamurti"),
    Quote(text: "Chaque jour est une seconde chance", author: "Inconnu"),
    Quote(text: "L'amour est l'acte suprême de courage", author: "Paulo Coelho"),
    Quote(text: "La sérénité est un choix", author: "Sénèque"),
    Quote(text: "Le calme est une superpuissance", author: "Naval Ravikant"),
    Quote(text: "Ce qui est juste est souvent simple", author: "Albert Einstein"),
    Quote(text: "Sois présent", author: "Thich Nhat Hanh"),
    
    Quote(text: "La plus belle des ruses du diable est de vous persuader qu'il n'existe pas", author: "Baudelaire"),
    Quote(text: "L'imagination est plus importante que le savoir", author: "Albert Einstein"),
    Quote(text: "Aime et fais ce que tu veux", author: "Saint Augustin"),
    Quote(text: "Le bonheur est la seule chose qui se double si on le partage", author: "Albert Schweitzer"),
    Quote(text: "Tout obstacle renforce la détermination", author: "Léonard de Vinci"),
    Quote(text: "La vraie générosité envers l'avenir consiste à tout donner au présent", author: "Albert Camus"),
    Quote(text: "Celui qui déplace la montagne, c'est celui qui commence à enlever les petites pierres", author: "Confucius"),
    Quote(text: "Le succès, c'est d'aller d'échec en échec sans perdre son enthousiasme", author: "Winston Churchill"),
    Quote(text: "La meilleure façon de prédire l'avenir, c'est de le créer", author: "Peter Drucker"),
    Quote(text: "Sois toi-même, tous les autres sont déjà pris", author: "Oscar Wilde"),
    
    Quote(text: "La perfection est atteinte non pas lorsqu'il n'y a plus rien à ajouter, mais lorsqu'il n'y a plus rien à retirer", author: "Antoine de Saint-Exupéry"),
    Quote(text: "Il n'est jamais trop tard pour être ce que vous auriez pu être", author: "George Eliot"),
    Quote(text: "Le seul moyen de faire du bon travail est d'aimer ce que vous faites", author: "Steve Jobs"),
    Quote(text: "Crois en tes rêves et ils se réaliseront peut-être. Crois en toi et ils se réaliseront sûrement", author: "Martin Luther King"),
    Quote(text: "La différence entre l'impossible et le possible réside dans la détermination", author: "Tommy Lasorda"),
    Quote(text: "Le pessimiste se plaint du vent, l'optimiste espère qu'il va changer, le réaliste ajuste ses voiles", author: "William Arthur Ward"),
    Quote(text: "Ne laisse personne te dire que tu ne peux pas faire quelque chose", author: "Will Smith"),
    Quote(text: "Les gagnants trouvent des moyens, les perdants des excuses", author: "F.D. Roosevelt"),
    Quote(text: "Ce n'est pas parce que les choses sont difficiles que nous n'osons pas, c'est parce que nous n'osons pas qu'elles sont difficiles", author: "Sénèque"),
    Quote(text: "Un voyage de mille lieues commence toujours par un premier pas", author: "Lao Tseu"),
    
    Quote(text: "Le courage n'est pas l'absence de peur, mais la capacité de la vaincre", author: "Nelson Mandela"),
    Quote(text: "L'échec est simplement l'opportunité de recommencer de manière plus intelligente", author: "Henry Ford"),
    Quote(text: "La vie, c'est comme une bicyclette, il faut avancer pour ne pas perdre l'équilibre", author: "Albert Einstein"),
    Quote(text: "Ose être toi-même, tous les autres sont déjà pris", author: "André Gide"),
    Quote(text: "Le secret du changement consiste à concentrer son énergie pour créer du nouveau, et non pas pour se battre contre l'ancien", author: "Socrate"),
    Quote(text: "N'attendez pas que les choses soient parfaites pour commencer", author: "Tim Ferriss"),
    Quote(text: "La seule limite à notre épanouissement de demain sera nos doutes d'aujourd'hui", author: "F.D. Roosevelt"),
    Quote(text: "Les difficultés sont faites pour être surmontées", author: "Ernest Shackleton"),
    Quote(text: "Fais de ta vie une œuvre d'art", author: "Michel-Ange"),
    Quote(text: "Le bonheur est une direction, pas une destination", author: "Sydney J. Harris"),
    
    Quote(text: "Apprends comme si tu devais vivre toujours", author: "Gandhi"),
    Quote(text: "La vie devient plus facile quand tu apprends à accepter les excuses que tu n'as jamais reçues", author: "Robert Brault"),
    Quote(text: "On ne peut pas retourner en arrière et changer un nouveau début mais on peut démarrer maintenant et changer la fin", author: "C.S. Lewis"),
    Quote(text: "La qualité n'est jamais un accident", author: "John Ruskin"),
    Quote(text: "Ne remets jamais à demain ce que tu peux faire aujourd'hui", author: "Benjamin Franklin"),
    Quote(text: "La vraie sagesse est de savoir que l'on ne sait rien", author: "Socrate"),
    Quote(text: "Vis ta vie de l'intérieur vers l'extérieur", author: "Paulo Coelho"),
    Quote(text: "Le temps est ta ressource la plus précieuse", author: "Brian Tracy"),
    Quote(text: "Chaque matin, nous renaissons. Ce que nous faisons aujourd'hui est ce qui importe le plus", author: "Bouddha"),
    Quote(text: "La vie est trop courte pour être petite", author: "Benjamin Disraeli"),
  ];

  /// Retourne la citation du jour basée sur la date
  Quote getQuoteOfTheDay(DateTime date) {
    // Calculer le jour de l'année (1-365/366)
    final dayOfYear = date.difference(DateTime(date.year, 1, 1)).inDays;
    
    // Utiliser le modulo pour avoir un index entre 0 et 99
    final index = dayOfYear % _quotes.length;
    
    return _quotes[index];
  }

  /// Retourne une citation aléatoire
  Quote getRandomQuote() {
    final index = DateTime.now().millisecondsSinceEpoch % _quotes.length;
    return _quotes[index];
  }
}