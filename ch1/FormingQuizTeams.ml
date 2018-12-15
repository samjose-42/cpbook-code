open Scanf
open Printf

let n = ref 0
let numStudents = ref 0
let target = ref 0
let caseNo = ref 1
let dist = Array.make_matrix 20 20 0.
let memo = Array.make (1 lsl 16) 0.


let hypot (ax, ay) (bx, by) = 
  Float.hypot (ax -. bx) (ay -. by)
;;

let rec matching bitmask =
  if memo.(bitmask) > -0.5 then memo.(bitmask)
  else if bitmask = !target then 0.
  else
    let ans = ref 1e9 in
    let p1 = ref 0 in
    while (bitmask land (1 lsl !p1) > 0) do 
      p1 := !p1 + 1
    done;
    for p2 = !p1 + 1 to !numStudents - 1 do 
      if bitmask land (1 lsl p2) = 0 then
        ans := min !ans (dist.(!p1).(p2) +. matching (bitmask lor (1 lsl !p1) lor (1 lsl p2)))
    done;
    !ans

let () =
  let rec solve () =
    scanf "%d\n" (fun x -> n := x);
    if !n = 0
    then
      ()
    else
      numStudents := 2 * !n;
      let positions = Array.make !numStudents (0., 0.) in
      for i = 0 to !numStudents - 1 do 
        scanf "%s %f %f\n" (fun _ x y -> positions.(i) <- (x,y))
      done;
      for i = 0 to !numStudents - 1 do
        for j = i+1 to !numStudents - 1 do 
          dist.(i).(j) <- hypot positions.(i) positions.(j)
        done
      done;
      for i = 0 to (1 lsl 16) - 1 do
        memo.(i) <- -1.
      done;
      target := (1 lsl !numStudents) - 1;
      printf "Case %d: %.2f\n" !caseNo (matching 0);
      caseNo := !caseNo + 1;
      solve ()
  in
  solve ()
