module type S = sig
  type 'a process
  type 'a in_port
  type 'a out_port
  (*val new_channel: unit -> 'a in_port * 'a out_port
  val put: 'a -> 'a out_port -> unit process
  val get: 'a in_port -> 'a process
  val doco: unit process list -> unit process*)
  val return: 'a -> 'a process
  val bind: 'a process -> ('a -> 'b process) -> 'b process
  val run: 'a process -> 'a
end


module Seq : S = 
 struct
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
  end


  module Lib  = struct
    let ( >>= ) x f = Seq.bind x f
    let delay f x =
    (Seq.return ()) >>= (fun () -> Seq.return (f x))
    end

open Lib

let test x =
  Seq.return (Printf.printf "je suis un gentil processus qui vaut %d\n%!" x)

let test1 () = 
  42

let p1 = delay test1 () 

let p = p1 >>= (test);;

Seq.run p