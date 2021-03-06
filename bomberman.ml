open Graphics
open Gtypes
open Ig
open Unix

(** declaration de la grille de jeu **)
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
(** liste de joueur **)
let bombers = [ ("bleu", 1, 1, "sud"); ("vert", 7, 1, "sud");("rouge", 7, 4, "sud"); ("violet", 3, 7, "sud")]

let ouvrir_fenetre () =
  init 92 72 10 10

let case_to_coord i j =
  46+(j*92), 36+(i*72)

let coord_x_to_case x =
  x/92
let coord_y_to_case y =
  y/72

(** convertit string en couleur **)
let couleur_of_string s = 
  match s with
  | "bleu" -> Bleu
  | "rouge" -> Rouge
  | "vert" -> Vert
  | "violet" -> Violet
  | _ -> assert false

(** convertit couleur en string **)
let couleur_to_string c = 
  match c with
  | Bleu -> "bleu"
  | Rouge -> "rouge"
  | Vert -> "vert"
  | Violet -> "violet"

(** convertit string en direction **)
let dir_of_string s = 
  match s with
  | "sud" -> Sud
  | "nord" -> Nord
  | "est" -> Est
  | "ouest" -> Ouest
  | _ -> assert false

(** prochaine case: i j depuis: direction et coordonnées fenetre **)
let prochaine_case x y dir =
  match dir with
  | Nord -> 9-coord_y_to_case (y+36), coord_x_to_case x;
  | Sud -> 9-coord_y_to_case (y-36), coord_x_to_case x;
  | Est -> 9-coord_y_to_case y, coord_x_to_case (x+50);
  | Ouest -> 9-coord_y_to_case y, coord_x_to_case (x-50)

(** prochaine case: i j depuis: i j **)
let prochaine_case_ij i j dir =
  match dir with
  | Nord -> i, (j+1);
  | Sud -> i, (j-1);
  | Est -> (i+1), j;
  | Ouest -> (i-1), j

(** construction d'un bomberman depuis (string*int*int*string) **)
let build_bomber (c, i, j, d) = 
  Bomberman {
    x = fst(case_to_coord i j);
    y = snd(case_to_coord i j);
    couleur = couleur_of_string c;
    dir = dir_of_string d;
    etat = Vivant;
    pas = Some 0} 

(** construction d'un bomberman depuis (couleur*int*int*dir) **)
let build_bomber2 (c, i , j, d, p) = 
  Bomberman {
    x = i;
    y = j;
    couleur = c;
    dir = d;
    etat = Vivant;
    pas = Some p}

(** construction d'une bombe **)
let build_bombe i j d =
  Bombe {
    b_i = i;
    b_j = j;
    b_duree = d;
  }

(** affichage arene sur console **)
let affiche_arene m l =
  List.iter (function (c,i,j,d) -> Printf.printf "%s %d %d %s\n%!" c i j d) l;
  for i = 0 to 9 do
    for j = 0 to 9 do
      begin
        match m.(i).(j) with
        | ' ' -> Printf.printf " %!";
        | '=' -> Printf.printf "=%!";
        | 'x' -> Printf.printf "x%!";
        | _ -> ();
      end
    done;
    Printf.printf "\n";
  done;
  Printf.printf "\n"

(** mise en place de l'arene au départ du jeu **)
let dessiner_arene m l = 
  List.iter (function (c,i,j,d) -> Printf.printf "%s %d %d %s\n%!" c i j d) l;
  for i = 0 to 9 do
    for j = 0 to 9 do
      begin
        match m.(i).(j) with
        | ' ' -> let sprite_sol = Sol (j , 9-i) in 
          affiche_sprite sprite_sol;
          Printf.printf " %!";
        | '=' -> let sprite_bloc = Bloc {blk_i = j; blk_j = 9-i;  blk_forme = Incassable } in
          affiche_sprite sprite_bloc;
          affiche();
          Printf.printf "=%!";
        | 'x' -> let sprite_bloc = Bloc {blk_i = j; blk_j = 9-i; blk_forme = Cassable(Intact) } in
          affiche_sprite sprite_bloc;
          affiche();
          Printf.printf "x%!";
        | _ -> ();
      end
    done;
    Printf.printf "\n";
  done;
  Printf.printf "\n";
  let l = List.map build_bomber bombers in
  List.iter affiche_sprite l;
  affiche()

(** affiche les bombes **)
let affiche_bombe l =
  List.iter (fun x -> affiche_sprite x) l

(** efface les bombes **)
let efface_bombe l =
  List.iter (fun x -> efface_sprite x) l

let maj_pos_joueur x y coul =
  let couleur = couleur_to_string coul in
  List.map (fun (a,b,c,d) -> if a = couleur then (a,(coord_y_to_case y), (coord_x_to_case x), "sud") 
             else (a,b,c,d)) bombers

(** mise à jour grille **)
let maj_grille m i j =
  m.(i).(j) <- ' ';
  let s = Sol (j, (9-i)) in
  affiche_sprite s;
  m

(** ajoute la flamme à la liste **) 
let rec flamme_dir m i j dir liste_flamme =
  let (pcx, pcy) = prochaine_case_ij i j dir in
  if m.(9-(pcy)).(pcx) = 'x' then 
    begin
      maj_grille m (9-(pcy)) pcx;
      liste_flamme
    end
  else 
  if m.(9-(pcy)).(pcx) <> ' ' then liste_flamme
  else
    let (pcx2, pcy2) = prochaine_case_ij pcx pcy dir in
    if m.(9-(pcy2)).(pcx2) = ' ' then 
      begin
        let f = match dir with
          | Nord | Sud -> FVert
          | Est | Ouest-> FHoriz
        in
        let f = Flamme {f_i=pcx;f_j=pcy;f_forme=f}in
        flamme_dir m pcx pcy dir (f::liste_flamme)
      end
    else
      begin
        let f = match dir with
          | Nord -> FHaut
          | Sud -> FBas
          | Est -> FDroite
          | Ouest -> FGauche
        in
        let f = Flamme {f_i=pcx;f_j=pcy;f_forme=f} in
        flamme_dir m pcx pcy dir (f::liste_flamme)
      end

(** liste de bombe sans le bombe en parametre **)
let bombe_set0 b l =
  List.fold_left (fun l2 s -> match s with
      | Bombe x -> 
        if x=b then
          Bombe ( { x with b_duree = 0 } ) :: l2
        else
          l2
      | _ -> s :: l2 ) [] l

(** affichage des flammes **)
let rec affiche_flamme m i j liste_bombe liste_flamme =
  let l = [Flamme {f_i=i;f_j=j;f_forme=FCroix}] in
  let l2 = flamme_dir m i j Nord l in
  let l3 = flamme_dir m i j Sud l2 in
  let l4 = flamme_dir m i j Est l3 in
  let l5 = flamme_dir m i j Ouest l4 in
  (* List.iter 
     (fun x -> match x with
       | Flamme f -> List.iter 
                       (fun s -> match s with
                          | Bombe b -> if f.f_i <> i && f.f_i=b.b_i && f.f_j=b.b_j
                            then 
                              begin
                                let liste_bombe = bombe_set0 s liste_bombe in 
                                affiche_flamme m b.b_i b.b_j liste_bombe l5
                              end
                          | _ -> () ) liste_bombe
       | _ -> () ) l5; *)
  List.iter (fun x -> affiche_sprite x;) l5;
  affiche();
  sleepf(1./.10.);
  List.iter (fun x -> efface_sprite x;) l5;
  affiche()

(** mise a jour des bombes **)
let maj_bombe m l =
  List.fold_left 
    (fun l' s -> 
       match s with
       | Bombe r  -> 
         if r.b_duree > 0 then 
           Bombe ( { r with b_duree = r.b_duree - 1 } ) :: l'
         else 
           begin
             efface_sprite s;
             affiche_flamme m r.b_i r.b_j l [];
             l'
           end
       | _ -> s :: l' ) [] l

(** affiche tous les joueurs d'une liste excpeté celui en paramètre **)
let affiche_all_joueur j l =
  let filtre = List.filter (fun x -> x <> j) l in 
  List.iter (fun x -> affiche_sprite x) filtre

(** affiche toutes les bombes d'une liste **)
let affiche_all_bombe j l =
  List.iter (fun x -> affiche_sprite x) l

let rec mouvement x y m joueur coul dir decr list_bombe p =
  let v = match dir with
    | Nord -> (!y+5)
    | Sud -> (!y-5)
    | Est -> (!x+5)
    | Ouest -> (!x-5)
  in
  let proch_case = prochaine_case !x !y dir in
  if (m.(fst(proch_case)).(snd(proch_case)) == ' ' && !decr > 0) then 
    begin
      efface_sprite joueur;
      p := !p mod 3;
      let joueur2 = match dir with
        | Nord | Sud -> build_bomber2 (coul, !x, v, dir, !p) 
        | Est | Ouest -> build_bomber2 (coul, v, !y, dir, !p) in
      affiche_sprite joueur2;
      affiche_bombe list_bombe;
      affiche();
      efface_bombe list_bombe;
      efface_sprite joueur;
      sleepf(1./.25.);
      (match dir with
       | Nord ->  y := !y + 5
       | Sud ->  y := !y - 5
       | Est -> x := !x + 5
       | Ouest -> x := !x - 5);
      decr := !decr -1;
      p := !p + 1;
      mouvement x y m joueur2 coul dir decr list_bombe p;
    end

(** controle d'un bomberman **)
let rec controle coul m bombers bombas =
  let sprite_bomba : (sprite list) ref = ref bombas in
  let sprite_bomber = List.map build_bomber bombers in
  let joueur = List.find (fun s ->  match s with  
      | Bomberman(r) -> r.couleur = coul
      | _ -> false) sprite_bomber in
  let Bomberman(r) = joueur in
  let x = ref r.x in
  let y = ref r.y in
  if (not(touche_pressee())) then
    begin
      sleepf(1./.05.);
      affiche_bombe !sprite_bomba;
      efface_bombe !sprite_bomba;
      affiche_sprite joueur;
      if bombas = [] then
        begin
          affiche_all_joueur joueur sprite_bomber;
        end
      else
        affiche_bombe bombas;
      affiche();
      let bombas2 = maj_bombe m !sprite_bomba in
      let bombers2 = maj_pos_joueur !x !y coul in
      controle coul m bombers2 bombas2
    end
  else
    begin
      let p = ref 0 in
      (match lecture_touche() with
       | 'z' -> let decr = ref 15 in
         mouvement x y m joueur coul Nord decr !sprite_bomba p;
         efface_sprite joueur;
       | 'd' -> let decr = ref 20 in
         mouvement x y m joueur coul Est decr !sprite_bomba p;
         efface_sprite joueur;
       | 'q' -> let decr = ref 20 in
         mouvement x y m joueur coul Ouest decr !sprite_bomba p;
         efface_sprite joueur;
       | 's' -> let decr = ref 15 in
         mouvement x y m joueur coul Sud decr !sprite_bomba p;
         efface_sprite joueur;
       | 'b' -> let bomba = build_bombe (coord_x_to_case !x) (coord_y_to_case !y) 15 in
         sprite_bomba :=  bomba :: !sprite_bomba;
       | 'o' -> close_graph(Printf.printf "Fin du jeu!\n")
       |  _  -> ()
      );
      affiche_bombe !sprite_bomba;
      let bombas2 = maj_bombe m !sprite_bomba in
      let bombers2 = maj_pos_joueur !x !y coul in
      affiche_arene m bombers2;
      controle coul m bombers2 bombas2
    end

let () =
  auto_synchronize false;
  ouvrir_fenetre();
  dessiner_arene grille bombers;
  controle Rouge grille bombers []
