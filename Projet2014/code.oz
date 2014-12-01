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
	    
	 in
	    local
	       fun {SuperInterprete Partition Bourdon Facteur Transposer}
		  if Bourdon == nil then
		     case Partition
		     of nil then nil% cas d'une liste de partitions vide
		     [] H|T then % cas d'une liste de partitions
			case {ToNote H}
			of note(nom:Nom octave:Octave alteration:Alt) then
			   case Alt
			   of none then
			      case Nom
			      of 'a' then echantillon(hauteur:440 div (2*(4-Octave)) duree:1.0*Facteur instrument:none)|{SuperInterprete Partition.2 Bourdon Facteur}
			      [] 'b' then echantillon(hauteur:494 div (2*(4-Octave)) duree:1.0*Facteur instrument:none)|
			      [] 'c' then echantillon(hauteur:262 div (2*(4-Octave)) duree:1.0*Facteur instrument:none)|
			      [] 'd' then echantillon(hauteur:294 div (2*(4-Octave)) duree:1.0*Facteur instrument:none)|
			      [] 'e' then echantillon(hauteur:330 div (2*(4-Octave)) duree:1.0*Facteur instrument:none)|
			      [] 'f' then echantillon(hauteur:349 div (2*(4-Octave)) duree:1.0*Facteur instrument:none)|
			      [] 'g' then echantillon(hauteur:392 div (2*(4-Octave)) duree:1.0*Facteur instrument:none)|
			      [] 'silence' then echantillon(hauteur:0 duree:1.0*Facteur instrument:none)|
			      end
			      
			   [] '#' then
			      case Nom
			      of 'a' then echantillon(hauteur:466 div (2*(4-Octave)) duree:1.0*Facteur instrument:none)|
			      [] 'b' then echantillon(hauteur:523 div (2*(4-Octave)) duree:1.0*Facteur instrument:none)|% B# = C !!
			      [] 'c' then echantillon(hauteur:277 div (2*(4-Octave)) duree:1.0*Facteur instrument:none)|
			      [] 'd' then echantillon(hauteur:311 div (2*(4-Octave)) duree:1.0*Facteur instrument:none)|
			      [] 'e' then echantillon(hauteur:349 div (2*(4-Octave)) duree:1.0*Facteur instrument:none)|% E# = F !!
			      [] 'f' then echantillon(hauteur:370 div (2*(4-Octave)) duree:1.0*Facteur instrument:none)|
			      [] 'g' then echantillon(hauteur:415 div (2*(4-Octave)) duree:1.0*Facteur instrument:none)|
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
