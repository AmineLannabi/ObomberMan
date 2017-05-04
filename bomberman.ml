open Graphics
open Gtypes
open Ig

(** declaration de la grille de jeur **)
let grille = 
  [|
    [|'='; '='; '='; '='; '='; '='; '='; '='; '='; '='|];
    [|'='; ' '; ' '; ' '; ' '; '='; ' '; ' '; ' '; '='|];
    [|'='; ' '; '='; ' '; ' '; 'x'; ' '; ' '; ' '; '='|];
    [|'='; ' '; ' '; '='; ' '; '='; 'x'; '='; ' '; '='|];
    [|'='; ' '; 'x'; ' '; ' '; '='; ' '; ' '; ' '; '='|];
    [|'='; ' '; '='; ' '; ' '; '='; ' '; ' '; ' '; '='|];
    [|'='; ' '; 'x'; ' '; ' '; '='; ' '; ' '; ' '; '='|];
    [|'='; ' '; '='; ' '; ' '; 'x'; ' '; '='; ' '; '='|];
    [|'='; ' '; ' '; '='; ' '; ' '; '='; ' '; ' '; '='|];
    [|'='; '='; '='; '='; '='; '='; '='; '='; '='; '='|];
  |]

let ouvrir_fenetre () =
  init 92 72 10 10

let case_to_coord i j =
  (92/2)+(j*92), (72/2)+(i*72)

let coord_to_case x y =
  x/92, y/72

let dessiner_arene m  nbJoueur = 
  (** écriture du(des) joueur(s) à l'origine **)
  (match nbJoueur with
   | 1 -> Printf.printf "Bleu 7 3 Sud\n";
   | 2 -> Printf.printf "Bleu 7 3 Sud\n";
     Printf.printf "Rouge 5 7 Sud\n";
   | 3 -> Printf.printf "Bleu 7 3 Sud\n";
     Printf.printf "Rouge 5 7 Sud\n";
     Printf.printf "Vert 1 7 Sud\n";
   | 4 -> Printf.printf "Bleu 7 3 Sud\n";
     Printf.printf "Rouge 5 7 Sud\n";
     Printf.printf "Vert 1 7 Sud\n";
     Printf.printf "Violet 1 2 Sud\n";
   | _ -> Printf.printf "mauvais nombre de joueur\n");

  (** affichage des cases **)
  for i = 0 to 9 do
    for j = 0 to 9 do
      begin
        match m.(i).(j) with
        | ' ' -> let sprite_sol = Sol (j , 9-i) in 
          affiche_sprite sprite_sol;
          print_char ' ';
        | '=' -> let sprite_bloc = Bloc {blk_i = j; blk_j = 9-i;  blk_forme = Incassable } in
          affiche_sprite sprite_bloc;
          affiche();
          print_char '=';
        | 'x' -> let sprite_bloc = Bloc {blk_i = j; blk_j = 9-i; blk_forme = Cassable(Intact) } in
          affiche_sprite sprite_bloc;
          affiche();
          print_char 'x';
        | _ -> ();
      end
    done;
    Printf.printf "\n";
  done;

  (** affichage des bombermens **)
  (match nbJoueur with
   | 1 -> let joueur1 = Bomberman {x = fst(case_to_coord 7 3);y = snd(case_to_coord 7 3);couleur = Bleu;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur1;
   | 2 -> let joueur1 = Bomberman {x = fst(case_to_coord 7 3);y = snd(case_to_coord 7 3);couleur = Bleu;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur1;
     let joueur2 = Bomberman {x = fst(case_to_coord 5 7);y = snd(case_to_coord 5 7);couleur = Rouge;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur2; 
   | 3 -> let joueur1 = Bomberman {x = fst(case_to_coord 7 3);y = snd(case_to_coord 7 3);couleur = Bleu;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur1;
     let joueur2 = Bomberman {x = fst(case_to_coord 5 7);y = snd(case_to_coord 5 7);couleur = Rouge;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur2;
     let joueur3 = Bomberman {x = fst(case_to_coord 1 7);y = snd(case_to_coord 1 7);couleur = Vert;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur3; 
   | 4 -> let joueur1 = Bomberman {x = fst(case_to_coord 7 3);y = snd(case_to_coord 7 3);couleur = Bleu;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur1;
     let joueur2 = Bomberman {x = fst(case_to_coord 5 7);y = snd(case_to_coord 5 7);couleur = Rouge;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur2;
     let joueur3 = Bomberman {x = fst(case_to_coord 1 7);y = snd(case_to_coord 1 7);couleur = Vert;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur3; 
     let joueur4 = Bomberman {x = fst(case_to_coord 1 2);y = snd(case_to_coord 1 2);couleur = Violet;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur4; 
   | _ -> ());
  affiche();
  synchronize ()

(** coordonées i j de la prochaine case en fonction de la direction et des coordonnées fenetre **)
let prochaine_case x y dir =
  match dir with
  | Nord -> fst(coord_to_case x y)+1, snd(coord_to_case x y);
  | Sud -> fst(coord_to_case x y)-1, snd(coord_to_case x y);
  | Est -> fst(coord_to_case x y), snd(coord_to_case x y)+1;
  | Ouest -> fst(coord_to_case x y), snd(coord_to_case x y)-1

let deplacement joueur m =
  let x = ref joueur.x in
  let y = ref joueur.y in
  let old_sprite = Bomberman {
      x = joueur.x;
      y = joueur.y;
      couleur = joueur.couleur;
      dir = joueur.dir;
      etat = joueur.etat;
      pas = None
    } in 
  if touche_pressee() then
    (match lecture_touche() with
     |  'z' -> let proch_case = prochaine_case !x !y Nord in
       while (m.(fst(proch_case)).(snd(proch_case)) == ' ')
       do
         efface_sprite old_sprite;
         let new_sprite = Bomberman {
             x = !x;
             y = !y;
             couleur = joueur.couleur;
             dir = Nord;
             etat = joueur.etat;
             pas = None} in 
         affiche_sprite new_sprite;
         x := !x+1;
       done;
     |  'd' -> let proch_case = prochaine_case !x !y Est in
       while (m.(fst(proch_case)).(snd(proch_case)) == ' ')
       do
         efface_sprite old_sprite;
         let new_sprite = Bomberman {
             x = !x;
             y = !y;
             couleur = joueur.couleur;
             dir = Est;
             etat = joueur.etat;
             pas = None
           } in 
         affiche_sprite new_sprite;
         y := !y+1;
       done;
     |  'q' -> let proch_case = prochaine_case !x !y Ouest in
       while (m.(fst(proch_case)).(snd(proch_case)) == ' ')
       do
         efface_sprite old_sprite;
         let new_sprite = Bomberman {
             x = !x;
             y = !y;
             couleur = joueur.couleur;
             dir = Ouest;
             etat = joueur.etat;
             pas = None
           } in 
         affiche_sprite new_sprite;
         x := !x-1;
       done;
     |  's' -> let proch_case = prochaine_case !x !y Sud in
       while (m.(fst(proch_case)).(snd(proch_case)) == ' ')
       do
         efface_sprite old_sprite;
         let new_sprite = Bomberman {
             x = !x;
             y = !y;
             couleur = joueur.couleur;
             dir = Sud;
             etat = joueur.etat;
             pas = None
           } in 
         affiche_sprite new_sprite;
         x := !x-1;
       done;
     |  _  -> ());
  affiche()

let () =
  auto_synchronize false;
  ouvrir_fenetre();
  dessiner_arene grille 1;
  let joueur = {x = fst(case_to_coord 7 3);y = snd(case_to_coord 7 3);couleur = Bleu;dir = Sud;etat = Vivant;pas = None} in
  deplacement joueur grille;
  ignore (read_key ())

