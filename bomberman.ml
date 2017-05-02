open Graphics

let size_window = 600
let size_cell = (size_window/10)
let radius = (size_cell/2)
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

let ouvrir_fenetre n =
	let taille = Printf.sprintf " %dx%d" n n in
		open_graph taille;
		Graphics.auto_synchronize false

let dessiner_arene m = 
	for i = 0 to 9 do
		for j = 0 to 9 do
			begin
				match m.(i).(j) with
				| ' ' -> 
				(*set_color white;
				fill_circle (j*size_cell+radius) (size_window - (i*size_cell+radius)) radius;*)
				print_char ' ';
				| '=' -> 
				(*set_color black;
				fill_circle (j*size_cell+radius) (size_window - (i*size_cell+radius)) radius;*)
				print_char '=';
				| 'x' -> 
				(*set_color red;
				fill_circle (j*size_cell+radius) (size_window - (i*size_cell+radius)) radius;*)
				print_char 'x';
				| _ -> set_color yellow;
			end
		done;
		Printf.printf "\n";
	done;
	auto_synchronize(true)

let () =
	ouvrir_fenetre size_window;
	dessiner_arene grille;
	ignore (read_key ())