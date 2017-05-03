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

let ouvrir_fenetre =
	init 92 72 10 10

let dessiner_arene m = 
	for i = 0 to 9 do
		for j = 0 to 9 do
			begin
				match m.(i).(j) with
				| ' ' -> (*let sprite_sol = in 
				affiche_sprite sprite_sol;*)
				print_char ' ';
				| '=' -> let sprite_bloc = Bloc {blk_i = i; blk_j = j;  blk_forme = Incassable } in
					affiche_sprite sprite_bloc;
					affiche();
				print_char '=';
				| 'x' -> let sprite_bloc = Bloc {blk_i = i; blk_j = j; blk_forme = Cassable(Intact) } in
					affiche_sprite sprite_bloc;
					affiche();
				print_char 'x';
				| _ -> ();
			end
		done;
		Printf.printf "\n";
	done;
	synchronize ()

let () =
	auto_synchronize false;
	ouvrir_fenetre;
	dessiner_arene grille;
	ignore (read_key ())
