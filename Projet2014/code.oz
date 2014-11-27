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
	 case Partition.1
	 of H|T then %suite de partition
	 [] nil then %fin de suite de partition / partition
	    
	 [] N then% note
	    case N
	    of 'a0' then
	    [] 'b0' then
	    [] 'c0' then
	    [] 'd0' then
	    [] 'e0' then
	    [] 'f0' then
	    [] 'g0' then
	       
	    [] 'a1' then
	    [] 'b1' then
	    [] 'c1' then
	    [] 'd1' then
	    [] 'e1' then
	    [] 'f1' then
	    [] 'g1' then

	    [] 'a2' then
	    [] 'b2' then
	    [] 'c2' then
	    [] 'd2' then
	    [] 'e2' then
	    [] 'f2' then
	    [] 'g2' then

	    [] 'a3' then
	    [] 'b3' then
	    [] 'c3' then
	    [] 'd3' then
	    [] 'e3' then
	    [] 'f3' then
	    [] 'g3' then

	    [] 'a4' then
	    [] 'b4' then
	    [] 'c4' then
	    [] 'd4' then
	    [] 'e4' then
	    [] 'f4' then
	    [] 'g4' then
	       
	 [] N#O then% note alteree

	 [] muet(P) then P % transformation: muet
	 [] duree(secondes:F P) then F % transformation: duree
	 [] etirer(facteur:F P) then F % transformation: etirer
	 [] bourdon(note:N P) then N % transformation: bourdon
	 [] transposer(demitons:E P) then E % transformation: transposer
	 else nil
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
