let modul = ref "th" 

let set_mod s = 
  modul := s 


let spec_list = []

let () =
    Arg.parse spec_list set_mod "";
    match !modul with 
        | "th" -> Th.res()
        | "unix" -> Unix_implem.res()
      
        | "network" -> Network_implem.res()
        | "seq" -> Seq_implem.res()
        | _ -> failwith "enter an implemented Kahn module"