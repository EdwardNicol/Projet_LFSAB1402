% Vous ne pouvez pas utiliser le mot-clé 'declare'.
local Mix Interprete Projet CWD in
   % CWD contient le chemin complet vers le dossier contenant le fichier 'code.oz'
   % modifiez sa valeur pour correspondre à votre système.
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
      fun {Mix Interprete Music}
         Audio
      end

      fun {Interprete Partition}
	 local

	    fun{ToNote Note}%Transforme tous les formats que peu prendre <note> en un format standard
	       case Note
	       of Nom#Octave then note(nom:Nom octave:Octave alteration:'#')
	       [] Atom then
		  case {AtomToString Atom}
		  of [N] then note(nom:Atom octave:4 alteration:none)
		  [] [N O] then note(nom:{StringToAtom [N]} octave:{StringToInt [O]} alteration:none)
		  end
	       else Note %Ne modifie pas la partition 'Note' s'il n'est pas une note
	       end
	    end

	    fun{CountNotes Partition Acc} % Compte le nombre de notes dans une partition
	       case {Flatten Partition}
	       of nil then Acc % Fin de partition
	       [] H|T then % Cas ou la partition est une liste de partitions
		  case {ToNote H}
		  of note(nom:Nom octave:Octave alteration:Alt) then {CountNotes T Acc+1.0}
		  [] muet(P) then {CounNotes T Acc+{CountNotes P}}
		  [] bourdon(note:N P) then {CounNotes T Acc+{CountNotes P}}
		  [] etirer (facteur:F P) then {CounNotes T Acc+{CountNotes P}}
		  [] transpose(demitons:D P) then {CounNotes T Acc+{CountNotes P}}
		  [] duree(secondes:F P) then {CounNotes T Acc+{CountNotes P}}
		  end
	       [] Mono then % Cas ou la partition ne comporte qu'un seul élément
		  case {ToNote Mono}
		  of note(nom:Nom octave:Octave alteration:Alt) then Acc+1.0
		  [] muet(P) then Acc+{CountNotes P}
		  [] bourdon(note:N P) then Acc+{CountNotes P}
		  [] etirer (facteur:F P) then Acc+{CountNotes P}
		  [] transpose(demitons:D P) then Acc+{CountNotes P}
		  [] duree(secondes:F P) then Acc+{CountNotes P}
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
			case {ToNote H}
			of note(nom:Nom octave:Octave alteration:Alt) then
			   case Alt
			   of none then
			      case Nom
			      of 'a' then echantillon(hauteur:0-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)|{SuperInterprete T Bourdon Facteur Transposer}
			      [] 'b' then echantillon(hauteur:2-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)|{SuperInterprete T Bourdon Facteur Transposer}
			      [] 'c' then echantillon(hauteur:~9-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)|{SuperInterprete T Bourdon Facteur Transposer}
			      [] 'd' then echantillon(hauteur:~7-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)|{SuperInterprete T Bourdon Facteur Transposer}
			      [] 'e' then echantillon(hauteur:~5-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)|{SuperInterprete T Bourdon Facteur Transposer}
			      [] 'f' then echantillon(hauteur:~4-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)|{SuperInterprete T Bourdon Facteur Transposer}
			      [] 'g' then echantillon(hauteur:~2-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)|{SuperInterprete T Bourdon Facteur Transposer}
			      [] 'silence' then silence(duree:1.0*Facteur)|{SuperInterprete T Bourdon Facteur Transposer}
			      end
			      
			   [] '#' then
			      case Nom
			      of 'a' then echantillon(hauteur:1-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)|{SuperInterprete T Bourdon Facteur Transposer}
			      [] 'b' then echantillon(hauteur:3-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)|{SuperInterprete T Bourdon Facteur Transposer}% B# = C5 !!
			      [] 'c' then echantillon(hauteur:~8-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)|{SuperInterprete T Bourdon Facteur Transposer}
			      [] 'd' then echantillon(hauteur:~6-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)|{SuperInterprete T Bourdon Facteur Transposer}
			      [] 'e' then echantillon(hauteur:~4-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)|{SuperInterprete T Bourdon Facteur Transposer}% E# = F !!
			      [] 'f' then echantillon(hauteur:~3-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)|{SuperInterprete T Bourdon Facteur Transposer}
			      [] 'g' then echantillon(hauteur:~1-(12*(4-Octave))+Transposer duree:1.0*Facteur instrument:none)|{SuperInterprete T Bourdon Facteur Transposer}
			      end
			   end

			[] muet(P) then {SuperInterprete P silence Facteur Transposer}|{SuperInterprete T Bourdon Facteur Transposer}
			[] bourdon(note:N P) then {SuperInterprete P N Facteur Transposer}|{SuperInterprete T Bourdon Facteur Transposer}
			[] etirer(facteur:F P) then {SuperInterprete P Bourdon F Transposer}|{SuperInterprete T Bourdon Facteur Transposer}
			[] transpose(demitons:D P) then {SuperInterprete P Bourdon Facteur D}|{SuperInterprete T Bourdon Facteur Transposer}
			[] duree(secondes:S P) then
			   local Temps in
			      Temps=seconds/{CountNotes P 0.0}
			      {SuperInterprete P Bourdon Temps Transposer}|{SuperInterprete T Bourdon Facteur Transposer}
			   end
			end
		     end
		     

	       
	 end
      end
   end

   local 
      Music = {Projet.load CWD#'joie.dj.oz'}
   in
      % Votre code DOIT appeler Projet.run UNE SEULE fois.  Lors de cet appel,
      % vous devez mixer une musique qui démontre les fonctionalités de votre
      % programme.
      %
      % Si votre code devait ne pas passer nos tests, cet exemple serait le
      % seul qui ateste de la validité de votre implémentation.
      {Browse {Projet.run Mix Interprete Music CWD#'out.wav'}}
   end
end
