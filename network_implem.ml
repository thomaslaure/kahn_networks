module Network = Th.Th


module Network1 = struct 
  type 'a process = 'a -> unit 

  type 'a in_port = in_channel 

  type 'a out_port = out_channel

  let run e = 
    e ()
  

  let return v ()=
    v
   
  let bind e e' ()=
    let x = e () in 
      e' x ()

  (*implémentation par des sockets, manque de temps*)
end



module M = Application.Main(Network)

let res () = 
  Network.run M.main