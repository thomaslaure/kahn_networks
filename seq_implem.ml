module Seq : Sig.S = 
 struct

  exception Reschedule of (unit -> unit) 

  type 'a process = ('a -> unit ) -> unit 

  type 'a channel = 'a Queue.t 

  type 'a in_port = 'a channel
  type 'a out_port = 'a channel

  let run e = 
    let res = ref None in 
      e (fun v -> res := Some v );
    
    match !res with 
      | None -> failwith "cas impossible"
      | Some v -> v

  let return v f = 
      f v 


  let bind e e' f = (*e : ('a -> unit ) -> unit , e' : 'a -> ((b'-> unit)-> unit)
                  f : b'-> unit, res : unit *)
    e (fun x -> e' x f )

  
  let new_channel () =
    let q = Queue.create () in q,q

  let put v c f = (*dépose la valeur v dans c puis s'arrête en transmettant sa continuation pour la suite et permettre d'exécuter 
        d'autres processus dans la liste*)
    Queue.push v c; 
    raise (Reschedule f) 

  let rec get c f = (*lit la valeur et continue son calcul, sauf si la channel est vide, auquel cas s'arrête et se transmet elle-même
          comme continuation*)
    try f (Queue.pop c)
    with Queue.Empty -> raise (Reschedule (fun () -> get c f))

  let rec docaux l = (*exécute tous les processus qu'elle peut et renvoie la liste de ceux qui sont arrêtés pour rescheduling*)
    match l with 
    | [] -> []
    | e :: q -> try e (fun () -> ());
                    docaux q 
                    
                with Reschedule f -> (fun g -> f () ; g () ) :: (docaux q)  

  let rec doco l f = (*répète l'exécution des processus de l grâce à docaux, puis une fois qu'ils sont tous terminés lance f*)
    match docaux l with 
    | [] -> f ()
    | e :: q -> doco (docaux l) f;;


  end
    

  module M = Application.Main(Seq)

  let res () = 
    Seq.run M.main