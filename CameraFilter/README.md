#  Camera Filter

Cette application accède aux photos de la galerie, permet d'en sélectionner une et d'y appliquer un filtre.

On utilise RxSwift pour choisir une image et la renvoyer vers la vue principale. On met un observable sur les cellules contenant les images et on s'y abonne depuis la vue principale.

En faisant ça on peut directement récupérer l'image selectionné. On pourrait aussi utiliser les délégués pour faire ça, RxSwift n'est pas LA solution mais une possibilité.

De même on utilise RxSwift pour l'application du filtre. On met un observable sur la fonction traitant l'image , une fois que l'image est générée avec le filtre elle est affichée automatiqueemntdans la vue principale.



