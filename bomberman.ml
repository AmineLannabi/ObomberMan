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
		| _ -> Printf.printf "mauvais nombre joueur\n");
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
	match nbJoueur with
		| 1 -> let joueur1 = Bomberman {x = 94;y = 70;couleur = Bleu;dir = Sud;etat = Vivant;pas = None} in 
				affiche_sprite joueur1;
				affiche();
		| 2 -> let joueur1 = Bomberman {x = 94+(92/2);y = 70+(62/2);couleur = Bleu;dir = Sud;etat = Vivant;pas = None} in 
				affiche_sprite joueur1;
				let joueur2 = Bomberman {x = 204+(92/2);y = 160+(62/2);couleur = Rouge;dir = Sud;etat = Vivant;pas = None} in 
				affiche_sprite joueur2; 
				affiche();
		| 3 -> let joueur1 = Bomberman {x = 94;y = 70;couleur = Bleu;dir = Sud;etat = Vivant;pas = None} in 
				affiche_sprite joueur1;
				let joueur2 = Bomberman {x = 204+(92/2);y = 160+(62/2);couleur = Rouge;dir = Sud;etat = Vivant;pas = None} in 
				affiche_sprite joueur2;
				let joueur3 = Bomberman {x = 264+(92/2);y = 320+(62/2);couleur = Vert;dir = Sud;etat = Vivant;pas = None} in 
				affiche_sprite joueur3; 
				affiche();
		| 4 -> let joueur1 = Bomberman {x = 94;y = 70;couleur = Bleu;dir = Sud;etat = Vivant;pas = None} in 
				affiche_sprite joueur1;
				let joueur2 = Bomberman {x = 204+(92/2);y = 160+(62/2);couleur = Rouge;dir = Sud;etat = Vivant;pas = None} in 
				affiche_sprite joueur2;
				let joueur3 = Bomberman {x = 264+(92/2);y = 320+(62/2);couleur = Vert;dir = Sud;etat = Vivant;pas = None} in 
				affiche_sprite joueur3; 
				let joueur4 = Bomberman {x = 164+(92/2);y = 520+(62/2);couleur = Violet;dir = Sud;etat = Vivant;pas = None} in 
				affiche_sprite joueur4; 
				affiche();
		| _ -> ();
	synchronize ()

let () =
	auto_synchronize false;
	ouvrir_fenetre();
	dessiner_arene grille 4;
	ignore (read_key ())
