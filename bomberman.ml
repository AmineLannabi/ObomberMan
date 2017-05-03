open Graphics
open Gtypes
open Ig

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

let dessiner_arene m  nbJoueur = 
  (match nbJoueur with
   | 1 -> Printf.printf "Bleu 1 1 Sud\n";
   | 2 -> Printf.printf "Bleu 1 1 Sud\n";
     Printf.printf "Rouge 3 4 Sud\n";
   | 3 -> Printf.printf "Bleu 1 1 Sud\n";
     Printf.printf "Rouge 3 4 Sud\n";
     Printf.printf "Vert 5 7 Sud\n";
   | 4 -> Printf.printf "Bleu 1 1 Sud\n";
     Printf.printf "Rouge 3 4 Sud\n";
     Printf.printf "Vert 5 7 Sud\n";
     Printf.printf "Violet 6 2 Sud\n";
   | _ -> Printf.printf "mauvais nombre de joueur\n");
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
  (match nbJoueur with
   | 1 -> let joueur1 = Bomberman {x = fst(case_to_coord 2 3);y = snd(case_to_coord 2 3);couleur = Bleu;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur1;
   | 2 -> let joueur1 = Bomberman {x = fst(case_to_coord 2 3);y = snd(case_to_coord 2 3);couleur = Bleu;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur1;
     let joueur2 = Bomberman {x = fst(case_to_coord 4 5);y = snd(case_to_coord 4 5);couleur = Rouge;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur2; 
   | 3 -> let joueur1 = Bomberman {x = fst(case_to_coord 2 3);y = snd(case_to_coord 2 3);couleur = Bleu;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur1;
     let joueur2 = Bomberman {x = fst(case_to_coord 4 5);y = snd(case_to_coord 4 5);couleur = Rouge;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur2;
     let joueur3 = Bomberman {x = fst(case_to_coord 6 3);y = snd(case_to_coord 6 3);couleur = Vert;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur3; 
   | 4 -> let joueur1 = Bomberman {x = fst(case_to_coord 2 3);y = snd(case_to_coord 2 3);couleur = Bleu;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur1;
     let joueur2 = Bomberman {x = fst(case_to_coord 4 5);y = snd(case_to_coord 4 5);couleur = Rouge;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur2;
     let joueur3 = Bomberman {x = fst(case_to_coord 6 3);y = snd(case_to_coord 6 3);couleur = Vert;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur3; 
     let joueur4 = Bomberman {x = fst(case_to_coord 1 2);y = snd(case_to_coord 1 2);couleur = Violet;dir = Sud;etat = Vivant;pas = None} in 
     affiche_sprite joueur4; 
   | _ -> ());
  affiche();
  synchronize ()

let () =
  auto_synchronize false;
  ouvrir_fenetre();
  dessiner_arene grille 4;
  ignore (read_key ())
