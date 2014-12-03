fun{Mix Interprete Music}
   case {Flatten Music}
   of nil then nil
   [] H|T then 
      case H
      of voix then
          case voix of A|B then
	     case A of silence(duree:s) then
                local VecteurSilence C in
		  C=silence.duree*44100.0
		  fun{VecteurSilence Acc1 Acc2}
		     if Acc2==0 then Acc1
		     else {VecteurSilence 0.0|Acc1 Acc2-1.0}
		  end
		 {Append {VecteurSilence nil C} {Mix Interprete B}}
	        end
		
          []echantillon(hauteur:h duree:s instrument:none)     
               local VecteurAudio C D in
	           C=A.duree*44100.0
	      	   D=B.hauteur
	             fun{VecteurAudio Acc1 Acc2}
	             if Acc2==0 then Acc1
	             else {VecteurAudio 0.5*{Float.sin 2.0*3.1415*440.0*Acc2*{Float.pow 2.0 D/12}/C}|Acc1 Acc2-1}
	             end
	          {Append {VecteurAudio nil C} {Mix Interprete B}}
	       end
       [] transformation then % WTF?
            {Mix Interprete {Interprete transformation}}|{Mix Interprete T}
       [] partition(P) then
	    {Mix Interprete {Interprete P}}|{Mix Interprete T}     
       [] note(nom:Nom octave:Octave alteration:Alt) then
            {Mix Interprete {Interprete note}}|{Mix Interprete T}
       [] wave(Nom) then
            {Projet.readFile Nom}|{Mix Interprete T}
       [] repetition(nombre:N Music) then
             local Repete E in
	     E=repetition.nombre
	      fun{Repete Acc1 Acc2}
	        if Acc2==0.0 then Acc1
		else {Repete {Mix Interprete Music}|Acc1 Acc2-1.0}
		end
		{Repete nil E}|{Mix Interprete T}
		end 
       [] repetition(duree:S Music) E then
             local Repete in
	     fun{Repete Acc1 Acc2}
	         if Acc2<=0.0 then Acc1
		 else {Repete {Mix Interprete Music}|Acc1 Acc2-{IntToFloat{Length {Mix Interprete Music}}}/44100.0}
		 end
		 {Repete nil repetition.duree}
	     end
       [] clip(bas:B haut:H Music) then
       	     local Mcm L in
	         L={Mix Interprete Music}
	        fun{Mcm L Acc}
	        if L==nil then Acc
		elseif L.1>=B andthen L.1=<H then {Mcm L.2 Acc|L.1}
		elseif L.1<B then {Mcm L.2 Acc|B}
		else {Mcm L.2 Acc|H}
		end
	     end
	end
		
	     
       [] renverser(Music) then
             {Reverse {Mix Interprete Music}}
       [] echo(delai:Del Music) then
             {Mix Interprete merge([0.5#M 0.5[voix([silence(duree:Del)]) M]])}|{Mix Interprete T}
       [] echo(delai:Del decadence:Dec Music) then
		local X Y in
		   X = 1.0/(1.0+Dec)
		   Y = X*Dec
		   {Mix Interprete merge(X#M Y#[voix([silence(duree:Del)]) M])}|{Mix Interprete T}
		end
       [] echo(delai:Del decadence:Dec repetition:Rep Music) then
             
       [] fondu(ouverture:S1 fermeture:S2 Music) then
             nil
       [] fondu_enchaine(duree:S Music1 Music2) then
             nil
       [] couper(debut:S1 fin:S2 Music) then
             local Cut A B L in
	     A=S1*44100.0
	     B=S2*44100.0
	     L={Mix Interprete Music}
	     fun{Cut L A B Acc}
	       if B==0 then {Reverse Acc}
	       elseif A=<0 andthen L==nil then {Cut L A-1 B-1 0|Acc} 
	       elseif A=<0 {Cut L.2 A-1 B-1 L.1|Acc}
	       elseif A>0 then {Cut L.2 A-1 B-1 Acc}
	       end
	end
	       end
	       
	      
       
	     
       [] merge(musiquesavecintensites) then
             local Sum Mul in
	         fun{Sum L1 L2 Acc}
   	     	    if L1==nil then {Reverse {Flatten L2|Acc}}
  	      	    elseif L2==nil then {Reverse {Flatten L1|Acc}}  
  	       	    else {Sum L1.2 L2.2 (L1.1+L2.1)|Acc}
  	         end
		 fun{Mul L N Acc}
   		    if L==nil then {Reverse Acc}
   		    else {Mul L.2 N N*L.1|Acc}
  		 end		 
end
end
end