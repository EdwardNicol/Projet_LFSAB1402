%Fur Elise
local
   Tiers = 1.0/3.0
   Dtiers = 2.0/3.0
   Qtiers = 4.0/3.0

   Start = [etirer(facteur:Tiers [e5 d#5])]
   Corps = [etirer(facteur:Tiers [e5 d#5 e5 b d5 c5]) etirer(facteur:Dtiers a) etirer(facteur:Tiers [silence c e a]) etirer(facteur:Dtiers b)]
   Ending11 = [etirer(facteur:Tiers [silence e g#4 b]) etirer(facteur:Dtiers c) etirer(facteur:Tiers [silence e e5 d#5])]
   Ending12 = [etirer(facteur:Tiers [silence e d5 b])]
   Ending21 = [etirer(facteur:Qtiers a)]
   Ending22 = [etirer(facteur:DTiers a)]
   Pont = [etirer(fact:Tiers [silence b c5 d5]) e etirer(fact:Tiers [g f5 e5]) d etirer(fact:Tiers [f e5 d5]) c etirer(fact:Tiers [e d5 c5]) etirer(fact:Dtiers b) etirer(fact:Tiers [e e e5 e e5 e5 e6 d#5])]
   Ending23 = [etirer(facteur:Dtiers a) etier(facteur:Tiers [b c5 d5])]
   Ending24 = [etirer(facteur:2.0 a)] % Ending maison

   Elise = [Start Corps Ending11 Corps Ending12 Ending21
		Start Corps Ending11 Corps Ending12 Ending22
		Pont Start Start Start
		Start Corps Ending11 Corps Ending12 Ending23
		Corps Ending11 Corps Ending12 Ending24]
in
   [partition([Elise])]
end