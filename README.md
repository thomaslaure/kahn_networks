# Projet Kahn
Projet du cours Systèmes d'exploitation année 2020-2021.

La compilation se fait en exécutant `make` dans le dossier principal, qui fait appel à `dune` ( penser à faire `eval $(opam env)` si il y a des erreurs liées à `opam` ) puis déplace l'exécutable `kahn` dans le dossier principal et le rend exécutable.

Un fichier `application.ml` contenant un module `Main(K : Sig.S)` qui possède lui-même un unit process main est attendu dans le dossier principal. L'exécutable exécutera le processus main avec le module choisi.

Par défaut, le fichier `application.ml` est celui du sujet qui permet d'afficher tous les entiers à partir de 2.

La commande `make clean` permet d'enlever tous les fichiers créés par la compilation.

Le programme s'utilise en faisant `./kahn` suivi des arguments suivants :
```
unix : implémentation par des processus unix
seq : implémentation séquentielle
th : implémentation par des threads fournie dans le sujet
network : implémentation à travers le réseau, non implémentée complètement, appellera th
```

L'argument décide du module qui sera utilisé pour l'implémentation des processus.
