local Mix Interprete Projet CWD in
   CWD = {Property.condGet 'testcwd' '/Users/Ed/GitHub/Projet_LFSAB1402/Projet2014/'}

   % Projet fournit quatre fonctions :
   % {Projet.run Interprete Mix Music 'out.wav'} = ok OR error(...) 
   % {Projet.readFile FileName} = AudioVector OR error(...)
   % {Projet.writeFile FileName AudioVector} = ok OR error(...)
   % {Projet.load 'music_file.dj.oz'} = La valeur oz contenue dans le fichier chargé (normalement une <musique>).
   %
   % et une constante :
   % Projet.hz = 44100, la fréquence d'échantilonnage (nombre de données par seconde)
   [Projet] = {Link [CWD#'Projet2014_mozart2.ozf']}

   local
      Audio = {Projet.readFile CWD#'wave/animaux/cow.wav'}
   in
      % Mix prends une musique et doit retourner un vecteur audio.
       % Mix prends une musique et doit retourner un vecteur audio.
      fun {Mix Interprete Music}
	 case {Flatten Music}
	 of nil then nil %On fait en sorte de n'avoir qu'une seule liste et pas des listes de listes pour faciliter l'écriture du programme
	 [] H|T then %On analyse la liste morceau par morceau en commencant toujours pas H, un appel récursif sera fait à chaque fois sur T
	    case H
	    of voix(V) then %Deux cas sont distingués si on a une voix, si c'est un silence ou un échantillon
	       case V
	       of A|B then
		  case A
		  of silence(duree:s) then
		     local VecteurSilence C in %On définit la fonction VecteurSilence qui crée un vecteur remplis de 0
			C=silence.duree*44100.0

			fun{VecteurSilence Acc1 Acc2}
			   if Acc2==0 then Acc1
			   else {VecteurSilence 0.0|Acc1 Acc2-1.0} %Création d'un vecteur remplis de 0
			   end
			end
		   
			{Append {VecteurSilence nil C} {Mix Interprete B}}
		   
		     end
		
		  []echantillon(hauteur:H duree:S instrument:none) then 
		     local VecteurAudio C D in %On définit la fonction VecteurAudio qui crée un vecteur audio
			C=S*44100.0
			D={IntToFloat H}
			fun{VecteurAudio Acc1 Acc2}
			   if Acc2==0 then Acc1
			   else {VecteurAudio 0.5*{Float.sin 2.0*3.1415*440.0*Acc2*{Float.pow 2.0 D/12}/C}|Acc1 Acc2-1}
			   end
			end  
			{Append {VecteurAudio nil C} {Mix Interprete B}}
		     end
		  end
	       end


	    [] partition(P) then %Idem pour partition
	       {Mix Interprete {Interprete P}}|{Mix Interprete T}     


	    [] wave(Nom) then %Une fonction spécifique a été donnée pour gérer ce genre de fichier wave, il suffit de l'ulitilser sans l'implèmenter
	       {Projet.readFile Nom}|{Mix Interprete T}


	    [] repetition(nombre:N Music) then %Il est demandé de répeter un nombre précis de fois la musique Music
	       local Repete in
		  fun{Repete Acc1 Acc2} %les vecteurs audio {Mix Interprete Music} sont assemblés dans Acc1 quand Acc2 qui contient à la base le nombre de répétition
		     if Acc2==0.0 then Acc1 %demandés est égal à zéro on renvoit le vecteur Acc1
		     else {Repete {Mix Interprete Music}|Acc1 Acc2-1.0}
		     end
		  end
		  {Repete nil N}|{Mix Interprete T}
	       end 

	    [] repetition(duree:S Music) then %Il est demandé de répeter une musique pendant une certaine durée.
	       local Repete in
		  fun{Repete Acc1 Acc2} %Le premier accumulateur contient les vecteurs audio répétés, l'accumulateur deux joue un rôle de compte à rebour!
		     if Acc2=<0.0 then Acc1
		     else {Repete {Mix Interprete Music}|Acc1 Acc2-{IntToFloat{Length {Mix Interprete Music}}}/44100.0}
		     end
		  end
		  {Repete nil repetition.duree}
	       end


	    [] clip(bas:B haut:H Music) then %Il est demandé de réduire les valeures du vecteur audio entre B et H
	       local Mcm L in
		  L={Mix Interprete Music}
		  fun{Mcm L Acc}
		     if L==nil then Acc
		     elseif L.1>=B andthen L.1=<H then {Mcm L.2 Acc|L.1} %Effectué si la valeure du vecteur est comprise entre B et H, la valeure ne change pas
		     elseif L.1<B then {Mcm L.2 Acc|B} %Effectué si la valeure est inférieure à B, alors la valeure est remplacée par B
		     else {Mcm L.2 Acc|H}%Effectué en dernier si la valeure est supérieure à H, alors la valeure est remplacée par H
		     end
		  end
		  {Mcm L nil}
	       end
	 

	    [] renverser(Music) then %Création d'une musique satanique! Pour faire cela, il suffit d'appliquer la fonction reverse déjà implémentée à notre vecteur audio
	       {Reverse {Mix Interprete Music}}


	    [] echo(delai:Del M) then 
	       {Mix Interprete [merge([0.5#M 0.5#[voix([silence(duree:Del)]) M]])]}|{Mix Interprete T}

	    [] echo(delai:Del decadence:Dec M) then
	       local X Y in
		  X = 1.0/(1.0+Dec)
		  Y = X*Dec
		  {Mix Interprete [merge([X#M Y#[voix([silence(duree:Del)]) M]])]}|{Mix Interprete T}
	       end

	    [] echo(delai:Del decadence:Dec repetition:Rep M) then
	       local
		  fun {SubEcho Delai Decadence Intensite Nombre Iteration M Acc}
		     if Iteration > Nombre then {Reverse Acc}
		     elseif Iteration == 0 then
			{SubEcho Delai Decadence Intensite*Decadence Nombre-1 Iteration+1 M Intensite#M|Acc}
		     else
			{SubEcho Delai Decadence Intensite*Decadence Nombre-1 Iteration+1 M Intensite#[voix([silence(duree:Delai*Iteration)]) M]|Acc}
		     end
		  end

		  fun {CalcIntensite Dec N Acc}
		     if N==0 then Acc
		     else
			{CalcIntensite Dec N-1 Acc*Dec+1.0}
		     end
		  end
	       in
		  local X in
		     X = {CalcIntensite Dec Rep 1.0}
		     {Mix Interprete [merge({SubEcho Del Dec X Rep 0 M nil})]}|{Mix Interprete T}
		  end
	       end
	     

	    [] fondu(ouverture:S1 fermeture:S2 Music) then %Retourne un vecteur audio avec une partie "adoucie" entre S1 et S2
	       local L Fondu Dur1 Dur2 in
		  L={Mix Interprete Music}
		  Dur1=S1*44100.0
		  Dur2=S2*44100.0
		  fun{Fondu L AccOuv AccFer Return}
		     if L==nil then {Reverse Return} %L est le vecteur audio de base, quand tout le vecteur a été "fondu" on retourne le nouveau vecteur!
		     elseif AccOuv>0.0 then {Fondu L.2 AccOuv-1 AccFer ((Dur1-AccOuv)/Dur1)|Return} %Addouci le début de la musique
		     elseif AccOuv =<0.0 andthen {Length L}>AccFer then {Fondu L.2 AccOuv AccFer Return}%Rien n'est effectué, on avance dans le vecteur
		     else {Fondu L.2 AccOuv AccFer {Length L}/Dur2|Return}%Addouci la fin du vecteur
		     end
		  end
		  {Fondu L S1*44100.0 S2*44100.0 nil}
	       end	

	    [] fondu_enchaine(duree:Sec Musique1 Musique2) then
	       local Inter Fondu FusionAt in
		  fun {Inter M O Acc}
		     if Acc>{Length M} then nil
		     elseif {IntToFloat Acc}>=(O*44100.0) then 1.0*{Nth M Acc}|{Inter M O (Acc+1)}
		     else
			(1.0/(44100.0*O)*{IntToFloat Acc})*{Nth M Acc}|{Inter M O (Acc+1)}
		     end
		  end
	      
		  fun {Fondu Musique Ouverture Fermeture}
		     if {And {Or Ouverture*44100.0>{IntToFloat {Length Musique}} Ouverture==0.0} {Or Fermeture*44100.0>{IntToFloat {Length Musique}} Fermeture==0.0}}
		     then Musique
		     else
			{Inter {Reverse {Inter {Reverse Musique} Fermeture 1}} Ouverture 1}
		     end
		  end
	      
		  fun {FusionAt L1 L2 I}
		     local FInt in
			fun {FInt L1 L2 Length1 Length2 I Acc}
			   if Acc>(I+Length2)
			   then nil
			   elseif Acc>Length1
			   then L2.1|{FInt L1 L2.2 Length1 Length2 I Acc+1}
			   elseif Acc>I
			   then {Nth L1 Acc}+L2.1|{FInt L1 L2.2 Length1 Length2 I Acc+1}
			   else
			      {Nth L1 Acc}|{FInt L1 L2 Length1 Length2 I Acc+1}
			   end
			end
			{FInt L1 L2 {Length L1} {Length L2} ({Length L1}-{FloatToInt I}) 1}
		     end
		  end
		  {Flatten {FusionAt {Fondu {Mix Interprete Musique1} 0.0 Sec} {Fondu {Mix Interprete Musique2} Sec 0.0} Sec*44100.0-1.0}|{Mix Interprete T}}
	       end


	    [] couper(debut:S1 fin:S2 Music) then
	       local Cut A B L in
		  A=S1*44100.0
		  B=S2*44100.0
		  L={Mix Interprete Music}
		  fun{Cut L A B Acc}
		     if B==0 then {Reverse Acc}
		     elseif A=<0 andthen L==nil then {Cut L A-1 B-1 0|Acc} 
		     elseif A=<0 then {Cut L.2 A-1 B-1 L.1|Acc}
		     elseif A>0 then {Cut L.2 A-1 B-1 Acc}
		     end
		  end
		  {Cut L A B nil}
	       end	     


	    [] merge(LMusic) then %fonction qui a pour but d'additioner deux vecteurs audio tout en les multipliant par une intensité pour former une un nouveau vecteur 
	       local Sum Merge in %audio
		  fun{Sum L1 L2 Acc}
		     if L1==nil then {Reverse {Flatten L2|Acc}}
		     elseif L2==nil then {Reverse {Flatten L1|Acc}}  
		     else {Sum L1.2 L2.2 (L1.1+L2.1)|Acc}
		     end
		  end

		  fun{Merge LMusic}
		     case {Flatten LMusic}
		     of nil then nil
		     [](Intensite#Music)|T then
			local X Y in
			   X = {Map {Mix Interprete Music} fun{$ N} Intensite*N end}
			   Y = {Merge T}
			   {Sum X Y nil}
			end
		     end
		  end
		  {Merge LMusic}
	       end
	    end  	    
	 end
      end




      fun {Interprete Partition}
	 local

	    fun{ToNote Note}%Transforme tous les formats que peu prendre <note> en un format standard
	       case Note
	       of Nom#Octave then note(nom:Nom octave:Octave alteration:'#')
	       [] silence then note(nom:silence octave:4 alteration:none)
	       [] Atom then
		  case {AtomToString Atom}
		  of [N] then note(nom:Atom octave:4 alteration:none)
		  [] [N O] then note(nom:{StringToAtom [N]} octave:{StringToInt [O]} alteration:none)
		  end
	       end
	    end

	    fun{CountNotes Partition}% Compte le nombre de notes dans une partition
	       local
		  fun {SubCountNotes Partition Acc}
		     case {Flatten Partition}
		     of nil then Acc % Fin de partition
		     [] H|T then % Cas ou la partition est une liste de partitions
			case H
			of muet(P) then {SubCountNotes T Acc+{SubCountNotes P 0.0}}
			[] bourdon(note:N P) then {SubCountNotes T Acc+{SubCountNotes P 0.0}}
			[] etirer(facteur:F P) then {SubCountNotes T Acc+{SubCountNotes P 0.0}}
			[] transpose(demitons:D P) then {SubCountNotes T Acc+{SubCountNotes P 0.0}}
			[] duree(secondes:F P) then {SubCountNotes T Acc+{SubCountNotes P 0.0}}
			else
			   {SubCountNotes T Acc+1.0}
			end
		     [] Mono then % Cas ou la partition ne comporte qu'un seul élément
			case Mono
			of muet(P) then Acc+{SubCountNotes P 0.0}
			[] bourdon(note:N P) then Acc+{SubCountNotes P 0.0}
			[] etirer(facteur:F P) then Acc+{SubCountNotes P 0.0}
			[] transpose(demitons:D P) then Acc+{SubCountNotes P 0.0}
			[] duree(secondes:F P) then Acc+{SubCountNotes P 0.0}
			else
			   Acc+1.0
			end
		     end
		  end
	       in
		  {SubCountNotes Partition 0.0}
	       end
	    end

	    fun{GetEchantillon Note Facteur Transposer}
	       case {ToNote Note} of note(nom:Nom octave:Octave alteration:Alt) then
		  case Alt
		  of none then
		     case Nom
		     of 'a' then echantillon(hauteur:0-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)
		     [] 'b' then echantillon(hauteur:2-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)
		     [] 'c' then echantillon(hauteur:~9-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)
		     [] 'd' then echantillon(hauteur:~7-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)
		     [] 'e' then echantillon(hauteur:~5-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)
		     [] 'f' then echantillon(hauteur:~4-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)
		     [] 'g' then echantillon(hauteur:~2-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)
		     [] 'silence' then silence(duree:1.0*Facteur)
		     end
		     
		  [] '#' then
		     case Nom
		     of 'a' then echantillon(hauteur:1-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)
		     [] 'b' then echantillon(hauteur:3-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)% B# = C5 !!
		     [] 'c' then echantillon(hauteur:~8-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)
		     [] 'd' then echantillon(hauteur:~6-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)
		     [] 'e' then echantillon(hauteur:~4-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)% E# = F !!
		     [] 'f' then echantillon(hauteur:~3-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)
		     [] 'g' then echantillon(hauteur:~1-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)
		     end
		  end
	       end
	    end	     
	    
	 in


	    local
	       fun {SuperInterprete Partition Bourdon Facteur Transposer}

		  if Bourdon == nil then

		     case {Flatten Partition}
		     of nil then nil% cas d'une liste de partitions vide
		     [] H|T then % cas d'une liste de partitions
			{SuperInterprete H Bourdon Facteur Transposer}|{SuperInterprete T Bourdon Facteur Transposer}


		     [] Mono then % Cas ou la partition n'est pas une liste de partitions (note ou transformation unique)
			case Mono
			of muet(P) then {SuperInterprete P silence Facteur Transposer}
			[] bourdon(note:N P) then {SuperInterprete P N Facteur Transposer}
			[] etirer(facteur:F P) then {SuperInterprete P Bourdon F Transposer}
			[] transpose(demitons:D P) then {SuperInterprete P Bourdon Facteur D}
			[] duree(secondes:S P) then
			   local Temps in
			      Temps=S/{CountNotes P}
			      {SuperInterprete P Bourdon Temps Transposer}
			   end

			else % Mono est donc une note
			   {GetEchantillon Mono Facteur Transposer}
			end	   
		     end


		  else % on doit donc creer un bourdon
		     case{Flatten Partition}
		     of nil then nil
		     [] H|T then
			{SuperInterprete H Bourdon Facteur Transposer}|{SuperInterprete T Bourdon Facteur Transposer}

		     [] Mono then % Cas ou la partition n'est pas une liste de partitions
			case Mono
			of muet(P) then {SuperInterprete P silence Facteur Transposer}
			[] bourdon(note:N P) then {SuperInterprete P N Facteur Transposer}
			[] etirer(facteur:F P) then {SuperInterprete P Bourdon F Transposer}
			[] transpose(demitons:D P) then {SuperInterprete P Bourdon Facteur D}
			[] duree(secondes:S P) then
			   local Temps in
			      Temps=S/{CountNotes P}
			      {SuperInterprete P Bourdon Temps Transposer}
			   end

			else % Mono est donc une note (a remplacer par bourdon)
			   {GetEchantillon Bourdon Facteur Transposer}
			end	   
		     end
		  end
	       end
	    in
	       {Flatten {SuperInterprete Partition nil 1.0 0}}
	    end
	 end
      end
   end

   local 
      Music = {Projet.load CWD#'example.dj.oz'}
   in
      % Votre code DOIT appeler Projet.run UNE SEULE fois.  Lors de cet appel,
      % vous devez mixer une musique qui démontre les fonctionalités de votre
      % programme.
      %
      % Si votre code devait ne pas passer nos tests, cet exemple serait le
      % seul qui ateste de la validité de votre implémentation.
      {Browse {Interprete Music.1.1}}
      {Browse {Projet.run Mix Interprete Music CWD#'out.wav'}}
   end
end
