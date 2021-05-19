module Uni : Sig.S = struct
  type 'a process = unit -> 'a

  type 'a in_port = in_channel 
  type 'a out_port = out_channel 

  let run e = 
    e ()
  

  let return v ()=
    v
   
  let bind e e' ()=
    let x = e () in 
      e' x ()


  let new_channel () = 
    let f_in,f_out = Unix.pipe () in  
      Unix.in_channel_of_descr f_in,Unix.out_channel_of_descr f_out

  let put v c ()=
    Marshal.to_channel c v [];;


  let rec get c ()= 
    try
      let v = Marshal.from_channel c in 
      v 
    with End_of_file -> get c () ;;


  let doco l () =
      let rec expl l n () =
         match l with
         | [] -> for i=0 to (n-1) do 
                ignore (Unix.wait()); (*le père attend que tous ses fils meurent*)
                done
        | e :: q -> begin match Unix.fork() with 
                      | 0 -> 
                              e ();
                              exit 0 (*crée successivement tous les processus associés aux fils*)
  
                      | _ -> expl q (n+1) ()
                   end
      in
      expl l 0 ()
  

  end 


module M = Application.Main(Uni)

let res () = 
  Uni.run M.main