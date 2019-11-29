;
; http://mircboard.net/index.php
;
;Author SexisBadToTheBone, with help from IRC  channels : Gummibaer, Flobe, Liath, Alex  ( Central.irc.de )  , Jay2k1, Vliedel  ( Quakenet) and jagged ( Freenode ) thank u help out when i was stucked
;
;date Juli the 3rd 2013
;Verison : 0.9
;
;die hashtabelle folgt folgender logic
;0 0 1500 0 0 1500 0 0 1500 0 0 0
;1gibt gewonne duel spiele an, 2 verlorene duel spiele, 3 gib den elo wert fur duel an
;4gibt gewonne ffa spiele an, 5 verlorene ffa spiele, 6 den elo wert fur ffa
;7gibt gewonne team spiele an, 8 verlorene team spiele, 9 den elo wert fur teamspiele
;10, 11 und 12 fur evtl zukunfige verwendung
;--------------------------------------------------------------------------------------------------
;the script stores won and lost games. also it calculate a elo rating for the gametype duel, ffa and teamer
;commandos: ......
; !register : put nickname in the hashtable
; !won : Syntax : !won gametype nickname(s), on 2v2teamer the inputer and the 2nd nick is stored to winner section the 3rd and 4th nickname is loser and stored so all parameter just delimeted by a space character. on 3v3 teamer inputer 2nd and 3rd nick counted to winner teamer 4th 5th and 6th nick stored to loser how it will work for 4v4?
; !confirm : here just the loser confirm his loss, its enough one of the losers confirm e.g in ffa or teamer
; !top10 : syntax : !top10 gametype..... !top10 duel, !top10 ffa, !top10 teamer - shows top 10 of gametype
; !rank : syntax: !rank gametype nickname - shows rank of a certain nickname rated by elo
; !report stores waht ever was said in logfile with date day time
;u might need create for logfile the textfile logforscores.txt manually
 
on *:START:{
  hmake -s jiggle 10
  echo -s table created
  hload -s jiggle jiggle.txt
  echo-s table loaded
}
 
on *:EXIT:{
  hsave -os jiggle jiggle.txt
}
 
;here we have all elo equations for different gametypes begin
 
alias BerechneEloDuel  {
 
  var %RBWindDuelNickElo-Old = $gettok($hget(jiggle,%winduelnick),3,32)
  var %RALostDuelNickElo-Old = $gettok($hget(jiggle,%lostduelnick),3,32)
  ;zählen der gespielten Spiele zur berechnung des k-faktors unter 30
  var %gameamountb = $calc($gettok($hget(jiggle,%winduelnick),1,32) + ($gettok($hget(jiggle,%winduelnick),2,32)))
 
  if ( %gameamountb <= 30 ) {
  var %kfactorb = 30 }
  elseif ( %RBWindDuelNickElo-Old >= 2400 ) {
  var %kfactorb = 10 }
  else { var %kfactorb = 15 }
  ;zählen der gespielten Spiele zur berechnung des k-faktors unter 30
  var %gameamounta = $calc($gettok($hget(jiggle,%lostduelnick),1,32) + ($gettok($hget(jiggle,%lostduelnick),2,32)))
 
  if ( %gameamounta <= 30 ) {
  var %kfactora = 30 }
  elseif ( %RALostDuelNickElo-Old >= 2400 ) {
  var %kfactora = 10 }
  else { var %kfactora = 15 }
 
  var %EaOddsa = $calc(1/(1 + 10^$calc((%RBWindDuelNickElo-Old - %RALostDuelNickElo-Old) / 400)))
  var %EaOddsb = $calc(1/(1 + 10^$calc((%RALostDuelNickElo-Old - %RBWindDuelNickElo-Old) / 400)))
  var %RBWindDuelNickElo-New = $calc(%RBWindDuelNickElo-Old + (%kfactorb *(1-  %EaOddsb)))
  var %RALostDuelNickElo-New = $calc(%RALostDuelNickElo-Old + (%kfactora * (0 - %EaOddsa)))
  return $round(%RBWindDuelNickElo-New,0) $round(%RALostDuelNickElo-New,0)
}
 
alias BerechneEloFFA-2  {
  var %RBWinffaNickElo-Old = $gettok($hget(jiggle,%winffanick),6,32)
  var %RALostffaNickElo-Old1 = $gettok($hget(jiggle,%lostffanick1),6,32)
  var %RALostffaNickElo-Old2 = $gettok($hget(jiggle,%lostffanick2),6,32)
  var %RALostffaNickElo-Old3 = $gettok($hget(jiggle,%lostffanick3),6,32)
  var %RALostffaNickElo-Old4 = $gettok($hget(jiggle,%lostffanick4),6,32)
  var %RALostffaNickElo-Old5 = $gettok($hget(jiggle,%lostffanick5),6,32)
  var %RALostffaNickElo-Old6 = $gettok($hget(jiggle,%lostffanick6),6,32)
 
  ;zählen der gespielten Spiele zur berechnung des k-faktorsb unter 30
  var %gameamountb = $calc(($gettok($hget(jiggle,%lostffanick1),4,32) + ($gettok($hget(jiggle,%lostffanick1),5,32)) + ($gettok($hget(jiggle,%lostffanick2),4,32)) + ($gettok($hget(jiggle,%lostffanick2),5,32)) + ($gettok($hget(jiggle,%lostffanick3),4,32)) + ($gettok($hget(jiggle,%lostffanick3),5,32)) + ($gettok($hget(jiggle,%lostffanick4),4,32)) + ($gettok($hget(jiggle,%lostffanick4),5,32)) + ($gettok($hget(jiggle,%lostffanick5),4,32)) + ($gettok($hget(jiggle,%lostffanick5),5,32)) + ($gettok($hget(jiggle,%lostffanick6),4,32)) + ($gettok($hget(jiggle,%lostffanick6),5,32)))  / %playeramount)
 
  if ( %gameamountb <= 30 ) {
  var %kfactorb = 30 }
  elseif ( %RBWinffaNickElo-Old >= 2400 ) {
  var %kfactorb = 10 }
  else { var %kfactorb = 15 }
 
  ;zählen der gespielten Spiele zur berechnung des k-faktorsa unter spileranzahl/playeramount
  var %gameamounta = $calc($gettok($hget(jiggle,%winffanick),4,32) + ($gettok($hget(jiggle,%winffanick),5,32)))
 
  if ( %gameamounta <= 30 ) {
  var %kfactora = 30 }
  elseif ( %RALostffaNickElo-Old1 >= 2400 ) {
  var %kfactora = 10 }
  else { var %kfactora = 15 }
 
  var %EaOddsA = $calc(1/(1 + 10^$calc((%RBWinffaNickElo-Old - ((%RALostffaNickElo-Old1 + %RALostffaNickElo-Old2 + %RALostffaNickElo-Old3 + %RALostffaNickElo-Old4 + %RALostffaNickElo-Old5 + %RALostffaNickElo-Old6) /%playeramount)) / 400)))
  var %EaOddsB = $calc(1/(1 + 10^$calc((((%RALostffaNickElo-Old1 + %RALostffaNickElo-Old2 + %RALostffaNickElo-Old3 + %RALostffaNickElo-Old4 + %RALostffaNickElo-Old5 + %RALostffaNickElo-Old6)/%playeramount) - %RBWinffaNickElo-Old ) / 400)))
 
  var %RBWinffaNickElo-New = $calc(%RBWinffaNickElo-Old + (%kfactorb * ( 1- %EaOddsB)))
  var %RALostffaNickElo-New1 = $calc(%RALostffaNickElo-Old1 + (%kfactora * (0 - %EaOddsA)))
  var %RALostffaNickElo-New2 = $calc(%RALostffaNickElo-Old2 + (%kfactora * (0 - %EaOddsA)))
  var %RALostffaNickElo-New3 = $calc(%RALostffaNickElo-Old3 + (%kfactora * (0 - %EaOddsA)))
  var %RALostffaNickElo-New4 = $calc(%RALostffaNickElo-Old4 + (%kfactora * (0 - %EaOddsA)))
  var %RALostffaNickElo-New5 = $calc(%RALostffaNickElo-Old5 + (%kfactora * (0 - %EaOddsA)))
  var %RALostffaNickElo-New6 = $calc(%RALostffaNickElo-Old6 + (%kfactora * (0 - %EaOddsA)))
  return $round(%RBWinffaNickElo-New,0) $round(%RALostffaNickElo-New1,0) $round(%RALostffaNickElo-New2,0) $round(%RALostffaNickElo-New3,0) $round(%RALostffaNickElo-New4,0) $round(%RALostffaNickElo-New5,0) $round(%RALostffaNickElo-New6,0)
}
 
alias BerechneElo22team  {
 
  var %RBWinTeamNickElo-Old1 = $gettok($hget(jiggle,%winteamnick1),9,32)
  var %RBWinTeamNickElo-Old2 = $gettok($hget(jiggle,%winteamnick2),9,32)
  var %RALostTeamNickElo-Old1 = $gettok($hget(jiggle,%lostteamnick1),9,32)
  var %RALostTeamNickElo-Old2 = $gettok($hget(jiggle,%lostteamnick2),9,32)
  ;zählen der gespielten Spiele zur berechnung des k-faktors unter 60, 60 weil zwei spiler antreten und nicht nur einer. haben beide spieler 30 spiele absolviert sinds insgesamt 60
  var %gameamountb = $calc($gettok($hget(jiggle,%winteamnick1),7,32) + ($gettok($hget(jiggle,%winteamnick1),8,32)) + ($gettok($hget(jiggle,%winteamnick2),7,32)) + ($gettok($hget(jiggle,%winteamnick2),8,32)))
  ;zählen der gespielten Spiele zur berechnung des k-faktors unter 60, 60 weil zwei spiler antreten und nicht nur einer. haben beide spieler 30 spiele absolviert sinds insgesamt 60
 
  if ( %gameamountb <= 60 ) {
  var %kfactorb = 30 }
  elseif ( $calc(%RBWinTeamNickElo-Old1 + %RBWinTeamNickElo-Old2)  >= 4800 ) {
  var %kfactorb = 10 }
  else { var %kfactorb = 15 }
 
  ;zählen der gespielten Spiele zur berechnung des k-faktors unter 60, 60 weil zwei spiler antreten und nicht nur einer. haben beide spieler 30 spiele absolviert sinds insgesamt 60
  var %gameamounta = $calc($gettok($hget(jiggle,%lostteamnick1),7,32) + ($gettok($hget(jiggle,%lostteamnick1),8,32)) + ($gettok($hget(jiggle,%lostteamnick2),7,32)) + ($gettok($hget(jiggle,%lostteamnick2),8,32)))
 
  if ( %gameamounta <= 60 ) {
  var %kfactora = 30 }
  elseif ( $calc(%RALostTeamNickElo-Old1 + %RALostTeamNickElo-Old2)  >= 4800 ) {
  var %kfactora = 10 }
  else { var %kfactora = 15 }
 
  var %EaOddsa = $calc(1/(1 + 10^$calc(((%RBWinTeamNickElo-Old1 + %RBWinTeamNickElo-Old2) - (%RALostTeamNickElo-Old1 + %RALostTeamNickElo-Old2)) / 400)))
  var %EaOddsb = $calc(1/(1 + 10^$calc(((%RALostTeamNickElo-Old1 + %RALostTeamNickElo-Old2) - (%RBWinTeamNickElo-Old1 + %RBWinTeamNickElo-Old2)) / 400)))
  var %RBWindTeamNickElo-New1 = $calc(%RBWinTeamNickElo-Old1 + (%kfactorb * (1 - %EaOddsb)))
  var %RBWindTeamNickElo-New2 = $calc(%RBWinTeamNickElo-Old2 + (%kfactorb * (1 - %EaOddsb)))
  var %RALostTeamNickElo-New1 = $calc(%RALostTeamNickElo-Old1 + (%kfactora * (0 - %EaOddsa)))
  var %RALostTeamNickElo-New2 = $calc(%RALostTeamNickElo-Old2 + (%kfactora * (0 - %EaOddsa)))
  return $round(%RBWindTeamNickElo-New1,0) $round(%RBWindTeamNickElo-New2,0) $round(%RALostTeamNickElo-New1,0) $round(%RALostTeamNickElo-New2,0)
}
 
alias BerechneElo33team  {
 
  var %RBWinTeamNickElo-Old1 = $gettok($hget(jiggle,%winteamnick1),9,32)
  var %RBWinTeamNickElo-Old2 = $gettok($hget(jiggle,%winteamnick2),9,32)
  var %RBWinTeamNickElo-Old3 = $gettok($hget(jiggle,%winteamnick3),9,32)
  var %RALostTeamNickElo-Old1 = $gettok($hget(jiggle,%lostteamnick1),9,32)
  var %RALostTeamNickElo-Old2 = $gettok($hget(jiggle,%lostteamnick2),9,32)
  var %RALostTeamNickElo-Old3 = $gettok($hget(jiggle,%lostteamnick3),9,32)
  ;zählen der gespielten Spiele zur berechnung des k-faktors unter 90, 90 weil drei spiler antreten und nicht nur einer. haben drei spieler 30 spiele absolviert sinds insgesamt 90
  var %gameamountb = $calc($gettok($hget(jiggle,%winteamnick1),7,32) + ($gettok($hget(jiggle,%winteamnick1),8,32)) + ($gettok($hget(jiggle,%winteamnick2),7,32)) + ($gettok($hget(jiggle,%winteamnick2),8,32)) + ($gettok($hget(jiggle,%winteamnick3),7,32)) + ($gettok($hget(jiggle,%winteamnick3),8,32)))
 
  if ( %gameamountb <= 90 ) {
  var %kfactorb = 30 }
  elseif ( $calc(%RBWinTeamNickElo-Old1 + %RBWinTeamNickElo-Old2 + %RBWinTeamNickElo-Old3)  >= 7200 ) {
  var %kfactorb = 10 }
  else { var %kfactorb = 15 }
 
  ;zählen der gespielten Spiele zur berechnung des k-faktors unter 90, 90 weil drei spiler antreten und nicht nur einer. haben drei spieler 30 spiele absolviert sinds insgesamt 90
  var %gameamounta = $calc($gettok($hget(jiggle,%winteamnick1),7,32) + ($gettok($hget(jiggle,%winteamnick1),8,32)) + ($gettok($hget(jiggle,%winteamnick2),7,32)) + ($gettok($hget(jiggle,%winteamnick2),8,32)) + ($gettok($hget(jiggle,%winteamnick3),7,32)) + ($gettok($hget(jiggle,%winteamnick3),8,32)))
 
  if ( %gameamounta <= 90 ) {
  var %kfactora = 30 }
  elseif ( $calc(%RALostTeamNickElo-Old1 + %RALostTeamNickElo-Old2 + %RALostTeamNickElo-Old3)  >= 7200 ) {
  var %kfactora = 10 }
  else { var %kfactora = 15 }
 
  var %EaOddsa = $calc(1/(1 + 10^$calc(((%RBWinTeamNickElo-Old1 + %RBWinTeamNickElo-Old2 + %RBWinTeamNickElo-Old3) - (%RALostTeamNickElo-Old1 + %RALostTeamNickElo-Old2 + %RALostTeamNickElo-Old3)) / 400)))
  var %EaOddsb = $calc(1/(1 + 10^$calc(((%RALostTeamNickElo-Old1 + %RALostTeamNickElo-Old2 + %RALostTeamNickElo-Old3) - (%RBWinTeamNickElo-Old1 + %RBWinTeamNickElo-Old2 + %RBWinTeamNickElo-Old3)) / 400)))
  var %RBWindTeamNickElo-New1 = $calc(%RBWinTeamNickElo-Old1 + (%kfactorb * (1 - %EaOddsb)))
  var %RBWindTeamNickElo-New2 = $calc(%RBWinTeamNickElo-Old2 + (%kfactorb * (1 - %EaOddsb)))
  var %RBWindTeamNickElo-New3 = $calc(%RBWinTeamNickElo-Old3 + (%kfactorb * (1 - %EaOddsb)))
  var %RALostTeamNickElo-New1 = $calc(%RALostTeamNickElo-Old1 + (%kfactora * (0 - %EaOddsa)))
  var %RALostTeamNickElo-New2 = $calc(%RALostTeamNickElo-Old2 + (%kfactora * (0 - %EaOddsa)))
  var %RALostTeamNickElo-New3 = $calc(%RALostTeamNickElo-Old3 + (%kfactora * (0 - %EaOddsa)))
  return $round(%RBWindTeamNickElo-New1,0) $round(%RBWindTeamNickElo-New2,0) $round(%RBWindTeamNickElo-New3,0) $round(%RALostTeamNickElo-New1,0) $round(%RALostTeamNickElo-New2,0) $round(%RALostTeamNickElo-New3,0)
}
 
alias BerechneElo44team  {
 
  var %RBWinTeamNickElo-Old1 = $gettok($hget(jiggle,%winteamnick1),9,32)
  var %RBWinTeamNickElo-Old2 = $gettok($hget(jiggle,%winteamnick2),9,32)
  var %RBWinTeamNickElo-Old3 = $gettok($hget(jiggle,%winteamnick3),9,32)
  var %RBWinTeamNickElo-Old4 = $gettok($hget(jiggle,%winteamnick4),9,32)
  var %RALostTeamNickElo-Old1 = $gettok($hget(jiggle,%lostteamnick1),9,32)
  var %RALostTeamNickElo-Old2 = $gettok($hget(jiggle,%lostteamnick2),9,32)
  var %RALostTeamNickElo-Old3 = $gettok($hget(jiggle,%lostteamnick3),9,32)
  var %RALostTeamNickElo-Old4 = $gettok($hget(jiggle,%lostteamnick4),9,32)
  ;zählen der gespielten Spiele zur berechnung des k-faktors unter 120, 120 weil vier spiler antreten und nicht nur einer. haben vieri spieler 30 spiele absolviert sinds insgesamt 120
  var %gameamountb = $calc($gettok($hget(jiggle,%winteamnick1),7,32) + ($gettok($hget(jiggle,%winteamnick1),8,32)) + ($gettok($hget(jiggle,%winteamnick2),7,32)) + ($gettok($hget(jiggle,%winteamnick2),8,32)) + ($gettok($hget(jiggle,%winteamnick3),7,32)) + ($gettok($hget(jiggle,%winteamnick3),8,32)) + ($gettok($hget(jiggle,%winteamnick4),7,32)) + ($gettok($hget(jiggle,%winteamnick4),8,32)))
 
  if ( %gameamountb <= 120 ) {
  var %kfactorb = 30 }
  elseif ( $calc(%RBWinTeamNickElo-Old1 + %RBWinTeamNickElo-Old2 + %RBWinTeamNickElo-Old3 + %RBWinTeamNickElo-Old4)  >= 9600 ) {
  var %kfactorb = 10 }
  else { var %kfactorb = 15 }
 
  ;zählen der gespielten Spiele zur berechnung des k-faktors unter 120, 120 weil vier spiler antreten und nicht nur einer. haben vieri spieler 30 spiele absolviert sinds insgesamt 120
  var %gameamounta = $calc($gettok($hget(jiggle,%winteamnick1),7,32) + ($gettok($hget(jiggle,%winteamnick1),8,32)) + ($gettok($hget(jiggle,%winteamnick2),7,32)) + ($gettok($hget(jiggle,%winteamnick2),8,32)) + ($gettok($hget(jiggle,%winteamnick3),7,32)) + ($gettok($hget(jiggle,%winteamnick3),8,32)) + ($gettok($hget(jiggle,%winteamnick4),7,32)) + ($gettok($hget(jiggle,%winteamnick4),8,32)))
 
  if ( %gameamounta <= 120 ) {
  var %kfactora = 30 }
  elseif ( $calc(%RALostTeamNickElo-Old1 + %RALostTeamNickElo-Old2 + %RALostTeamNickElo-Old3 + %RALostTeamNickElo-Old4)  >= 9600 ) {
  var %kfactora = 10 }
  else { var %kfactora = 15 }
 
  var %EaOddsa = $calc(1/(1 + 10^$calc(((%RBWinTeamNickElo-Old1 + %RBWinTeamNickElo-Old2 + %RBWinTeamNickElo-Old3 + %RBWinTeamNickElo-Old4) - (%RALostTeamNickElo-Old1 + %RALostTeamNickElo-Old2 + %RALostTeamNickElo-Old3 + %RALostTeamNickElo-Old4)) / 400)))
  var %EaOddsb = $calc(1/(1 + 10^$calc(((%RALostTeamNickElo-Old1 + %RALostTeamNickElo-Old2 + %RALostTeamNickElo-Old3 + %RALostTeamNickElo-Old4) - (%RBWinTeamNickElo-Old1 + %RBWinTeamNickElo-Old2 + %RBWinTeamNickElo-Old3 + %RBWinTeamNickElo-Old4)) / 400)))
 
  var %RBWindTeamNickElo-New1 = $calc(%RBWinTeamNickElo-Old1 + (%kfactorb * (1 - %EaOddsb)))
  var %RBWindTeamNickElo-New2 = $calc(%RBWinTeamNickElo-Old2 + (%kfactorb * (1 - %EaOddsb)))
  var %RBWindTeamNickElo-New3 = $calc(%RBWinTeamNickElo-Old3 + (%kfactorb * (1 - %EaOddsb)))
  var %RBWindTeamNickElo-New4 = $calc(%RBWinTeamNickElo-Old4 + (%kfactorb * (1 - %EaOddsb)))
  var %RALostTeamNickElo-New1 = $calc(%RALostTeamNickElo-Old1 + (%kfactora * (0 - %EaOddsa)))
  var %RALostTeamNickElo-New2 = $calc(%RALostTeamNickElo-Old2 + (%kfactora * (0 - %EaOddsa)))
  var %RALostTeamNickElo-New3 = $calc(%RALostTeamNickElo-Old3 + (%kfactora * (0 - %EaOddsa)))
  var %RALostTeamNickElo-New4 = $calc(%RALostTeamNickElo-Old4 + (%kfactora * (0 - %EaOddsa)))
  return $round(%RBWindTeamNickElo-New1,0) $round(%RBWindTeamNickElo-New2,0) $round(%RBWindTeamNickElo-New3,0) $round(%RBWindTeamNickElo-New4,0) $round(%RALostTeamNickElo-New1,0) $round(%RALostTeamNickElo-New2,0) $round(%RALostTeamNickElo-New3,0) $round(%RALostTeamNickElo-New4,0)
}
;here we have all elo equations for different gametypes end
 
on *:TEXT:!register:#:{
  if (!$hget(jiggle,$remove($nick,-tk))) {
    hadd -s jiggle $remove($nick,-tk) 0 0 1500 0 0 1500 0 0 1500 0 0 0
    msg $chan Thanks for registering, $remove($nick,-tk)
    write -a logforscores.txt $fulldate :: Register :: $remove($nick,-tk)
  }
  else {
    msg $chan You are already registered, $remove($nick,-tk)
    echo -ag hashtable entry for $remove($nick,-tk) $+ : $hget(jiggle,$remove($nick,-tk))
  }
  hsave -os jiggle jiggle.txt
}
 
;§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
 
on *:TEXT:!won*:#:{  
  if ($timer(1).reps > 0) {      
  msg $chan Please wait 20 sec. Procedure in progress... }
  else {
    ;FFA Section Won Begin--------------------------------------------------------%
    if ($2 == ffa) && ($hget(jiggle,$remove($nick,-tk))) && ($hget(jiggle,$3)) && (($hget(jiggle,$4)) || ($4 == $null)) && (($hget(jiggle,$5)) || ($5 == $null)) && (($hget(jiggle,$6)) || ($6 == $null)) && (($hget(jiggle,$7)) || ($7 == $null)) && (($hget(jiggle,$8)) || ($8 == $null)) && ($3 != $remove($nick,-tk)) && ($4 != $remove($nick,-tk)) && ($5 != $remove($nick,-tk)) && ($6 != $remove($nick,-tk)) && ($7 != $remove($nick,-tk)) && ($8 != $remove($nick,-tk)) {
      set -u20 %winffanick $remove($nick,-tk)
      set -u20 %lostffanick1 $3
      set -u20 %playeramount $calc($0 - 2)
      if ($4 != $null) { set -u20 %lostffanick2 $4 }
      else { var %slot2 = 2 }
      if ($5 != $null) { set -u20 %lostffanick3 $5 }
      else { var %slot3 = 3 }
      if ($6 != $null) { set -u20 %lostffanick4 $6 }
      else { var %slot4 = 4 }
      if ($7 != $null) { set -u20 %lostffanick5 $7 }
      else { var %slot5 = 5 }
      if ($8 != $null) { set -u20 %lostffanick6 $8 }
      else { var %slot6 = 6 }
      set -u20 %gametypeffa $2
      msg $chan Did %winffanick won vs u $2 %lostffanick1 %lostffanick2 %lostffanick3 %lostffanick4 %lostffanick5 %lostffanick6 ? - Confirm within 20 seconds by typing " !confirm "
    timer1 20 1 echo -s timer running }
    ;FFA Section Won End---------------------------------------------------------%
    ;Duell Section Won Begin-----------------------------------------------------%
    elseif ($2 == duel) && ($3 != $remove($nick,-tk)) && ($hget(jiggle,$3)) && ($hget(jiggle,$remove($nick,-tk))) {
      set -u20 %winduelnick $remove($nick,-tk)
      set -u20 %lostduelnick $3
      set -u20 %gametypeduel $2
      msg $chan Did %winduelnick won vs u in $2 %lostduelnick ? Confirm within 20 seconds by typing " !confirm "
    timer1 20 1 echo -s timer running }
    ;Duell Section Won End-------------------------------------------------------%
    ;Teamer 2v2  Section Won Begin----------------------------------------------------------------------------%
    elseif ($2 == 22team) && ($hget(jiggle,$remove($nick,-tk))) && ($3 != $remove($nick,-tk)) && ($4 != $remove($nick,-tk)) && ($5 != $remove($nick,-tk)) && ($hget(jiggle,$3)) && ($hget(jiggle,$4)) && ($hget(jiggle,$5)) {
      set -u20 %winteamnick1 $remove($nick,-tk)
      set -u20 %winteamnick2 $3
      set -u20 %lostteamnick1 $4
      set -u20 %lostteamnick2 $5
      set -u20 %gametype22team $2
      msg $chan Did Team %winteamnick1 + %winteamnick2 won vs u %lostteamnick1 + %lostteamnick2 ? One of u have to type !confirm
    timer1 20 1 echo -s timer running }
    ;Teamer 2v2  Section Won End------------------------------------------------------------------------------%
    ;Teamer 3v3  Section Won Begin----------------------------------------------------------------------------%
    elseif ($2 == 33team) && ($3 != $remove($nick,-tk)) && ($4 != $remove($nick,-tk)) && ($5 != $remove($nick,-tk)) && ($6 != $remove($nick,-tk)) && ($7 != $remove($nick,-tk)) && ($3 != $4) && ($3 != $5) && ($3 != $6) && ($3 != $7) && ($4 != $5) && ($4 != $6) && ($4 != $7) && ($5 != $6) && ($5 != $7) && ($6 != $7) && ($hget(jiggle,$remove($nick,-tk))) && ($hget(jiggle,$3)) && ($hget(jiggle,$4)) && ($hget(jiggle,$5)) && ($hget(jiggle,$6)) && ($hget(jiggle,$7)) {
      set -u20 %winteamnick1 $remove($nick,-tk)
      set -u20 %winteamnick2 $3
      set -u20 %winteamnick3 $4
      set -u20 %lostteamnick1 $5
      set -u20 %lostteamnick2 $6
      set -u20 %lostteamnick3 $7
      set -u20 %gametype33team $2
      msg $chan Did Team %winteamnick1 + %winteamnick2 + %winteamnick3 won vs u %lostteamnick1 + %lostteamnick2 + %lostteamnick3  ? One of u have to type !confirm
    timer1 20 1 echo -s timer running }
    ;Teamer 3v3  Section Won End------------------------------------------------------------------------------%
    ;Teamer 4v4  Section Won Begin----------------------------------------------------------------------------%
    elseif ($2 == 44team) && ($3 != $remove($nick,-tk)) && ($4 != $remove($nick,-tk)) && ($5 != $remove($nick,-tk)) && ($6 != $remove($nick,-tk)) && ($7 != $remove($nick,-tk)) && ($8 != $remove($nick,-tk)) && ($9 != $remove($nick,-tk)) && ($3 != $4) && ($3 != $5) && ($3 != $6) && ($3 != $7) && ($3 != $8) && ($3 != $9) && ($4 != $5) && ($4 != $6) && ($4 != $7) && ($4 != $8) && ($4 != $9) && ($5 != $6) && ($5 != $7) && ($5 != $8) && ($5 != $9) && ($6 != $7) && ($6 != $8) && ($6 != $9) && ($7 != $8) && ($7 != $9) && ($8 != $9) && ($hget(jiggle,$remove($nick,-tk))) && ($hget(jiggle,$3)) && ($hget(jiggle,$4)) && ($hget(jiggle,$5)) && ($hget(jiggle,$6)) &&  ($hget(jiggle,$7)) && ($hget(jiggle,$8)) && ($hget(jiggle,$9)) {
      set -u20 %winteamnick1 $remove($nick,-tk)
      set -u20 %winteamnick2 $3
      set -u20 %winteamnick3 $4
      set -u20 %winteamnick4 $5
      set -u20 %lostteamnick1 $6
      set -u20 %lostteamnick2 $7
      set -u20 %lostteamnick3 $8
      set -u20 %lostteamnick4 $9
      set -u20 %gametype44team $2
      msg $chan  Did Team %winteamnick1 + %winteamnick2 + %winteamnick3 + %winteamnick4 won vs u %lostteamnick1 + %lostteamnick2 + %lostteamnick3 + %lostteamnick4 ? One of u have to type !confirm
    timer1 20 1 echo -s timer running }
    ;Teamer 5v5  Section Won Begin----------------------------------------------------------------------------%
    elseif ($2 == 55team) {
    msg $chan teamer 5v5 is under construction }
    ;Teamer Section End-----------------------------------------------------------%
    else {
    msg $chan no GameType - $2 - Check spelling - Unregistered Player? }
  }
}
 
;§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
;§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
 
on *:TEXT:!confirm:#:{
  ;Duel Section Confirm Begin-----------------------------------------------------%
  ;Bedingung prüfen auf berechtigten Zugriff gleichzeitig ausschliessen das selber "confirmed" wird und gametype
  if (%lostduelnick == $remove($nick,-tk)) && ((duel == %gametypeduel) && (%winduelnick != $remove($nick,-tk))) {
    if ($timer(2).reps > 0) {      
    msg $chan Please wait 20 sec. Procedure in progress... }
    else {
      ;zugreifen auf Alias und Werte von $BerechneEloDuel in variable %retelo zuweisen
      var %retelo = $BerechneEloDuel(%winduelnick,%lostduelnick)
 
      ;abspeichern des alias BerechneEloDuel in Haschtable fur gewinner und verlierer mittles $gettok(%retelo,x,y)
      hadd jiggle %winduelnick $puttok($hget(jiggle,%winduelnick),$gettok(%retelo,1,32),3,32)
      hadd jiggle %lostduelnick $puttok($hget(jiggle,%lostduelnick),$gettok(%retelo,2,32),3,32)
 
      ;hinzufugen der zahler fur gewinner
      ;add to winner beginn-----------------------------------%
      var %counter = $calc($gettok($hget(jiggle,%winduelnick),1,32) + 1)
      hadd jiggle %winduelnick $puttok($hget(jiggle,%winduelnick),%counter,1,32)
      var %msgaddwinner =  %winduelnick  u won already %counter duel games :: Elo: $gettok(%retelo,1,32)
      ;add to winner end--------------------------------------%
 
      ;hinzufugen des zahlers fur verlierer
      ;add to loser begin-------------------------------------%
      var %counter1 = $calc($gettok($hget(jiggle,%lostduelnick),2,32) + 1)
      hadd jiggle %lostduelnick $puttok($hget(jiggle,%lostduelnick),%counter1,2,32)
      var %msgaddloser =  %lostduelnick its ur %counter duel game u lost :: Elo : $gettok(%retelo,2,32)
      ;abspeichern in hashtable
      hsave -os jiggle jiggle.txt
      ;add to loser end---------------------------------------%
      msg $chan %msgaddwinner
      msg $chan %msgaddloser
      write -a logforscores.txt $fulldate :: Confirmed :: %msgaddwinner :: %msgaddloser
  timer2 20 1 echo -s timer running  } }
  ;Duel Section Confirm End-------------------------------------------------------%
 
  ;FFA Section Confirm Begin------------------------------------------------------%
  elseif ((%gametypeffa == ffa) && ((%lostffanick1 == $remove($nick,-tk)) || ((%lostffanick2 == $remove($nick,-tk)) || (%lostffanick2 == $null)) || ((%lostffanick3 == $remove($nick,-tk)) || (%lostffanick3 == $null)) || ((%lostffanick4 == $remove($nick,-tk)) || (%lostffanick4 == $null)) || ((%lostffanick5 == $remove($nick,-tk)) || (%lostffanick5 == $null)) || ((%lostffanick6 == $remove($nick,-tk)) || (%lostffanick6 == $null)))) {
    if ($timer(2).reps > 0) {      
    msg $chan Please wait 20 sec. Procedure in progress... }
    else {
      ;zugreifen auf Alias und Werte von $BerechneEloFFA-2 in variable %retelo zuweisen
      var %retelo = $BerechneEloFFA-2(%winffanick,%lostffanick1,%lostffanick2,%lostffanick3,%lostffanick4,%lostffanick5,%lostffanick6)
 
      ;abspeichern des alias BerechneEloDuel in Haschtable fur gewinner und verlierer mittles $gettok(%retelo,x,y)
      hadd jiggle %winffanick $puttok($hget(jiggle,%winffanick),$gettok(%retelo,1,32),6,32)
 
      ;add to winner beginn----Punkte-------------------------------%
      var %counter = $calc($gettok($hget(jiggle,%winffanick),4,32) + 1)
      hadd jiggle %winffanick $puttok($hget(jiggle,%winffanick),%counter,4,32)
      hsave -os jiggle jiggle.txt
      var %msgaddwinner =  %winffanick u won already %counter ffa games :: Elo: $gettok(%retelo,1,32)
      ;add to winner end-------Punkte-------------------------------%
 
      ;add to loser1 begin-----Punkte-------------------------------%
      var %counter1 = $calc($gettok($hget(jiggle,%lostffanick1),5,32) + 1)
      hadd jiggle %lostffanick1 $puttok($hget(jiggle,%lostffanick1),%counter1,5,32)
      hadd jiggle %lostffanick1 $puttok($hget(jiggle,%lostffanick1),$gettok(%retelo,2,32),6,32)
      hsave -os jiggle jiggle.txt
      var %msgaddloser1 = %lostffanick1 its ur %counter1 lost ffa game :: Elo : $gettok(%retelo,2,32)
      ;add to loser1 end--------Punkte------------------------------%
 
      ;add to loser2 begin------------------------------------%
      if (%lostffanick2 != $null) {
        var %counter2 = $calc($gettok($hget(jiggle,%lostffanick2),5,32) + 1)
        hadd jiggle %lostffanick2 $puttok($hget(jiggle,%lostffanick2),%counter2,5,32)
        hadd jiggle %lostffanick2 $puttok($hget(jiggle,%lostffanick2),$gettok(%retelo,3,32),6,32)
        hsave -os jiggle jiggle.txt
        var %msgaddloser2 = %lostffanick2 its ur %counter2 lost ffa game :: Elo: $gettok(%retelo,3,32)
      }
      else { var %noentry = noentry }
      ;add to loser2 end--------------------------------------%
 
      ;add to loser3 begin------------------------------------%
      if (%lostffanick3 != $null) {
        var %counter3 = $calc($gettok($hget(jiggle,%lostffanick3),5,32) + 1)
        hadd jiggle %lostffanick3 $puttok($hget(jiggle,%lostffanick3),%counter3,5,32)
        hadd jiggle %lostffanick3 $puttok($hget(jiggle,%lostffanick3),$gettok(%retelo,4,32),6,32)
        hsave -os jiggle jiggle.txt
        var %msgaddloser3 = %lostffanick3 its ur %counter3 lost ffa game :: Elo: $gettok(%retelo,4,32)
      }
      else { var %noentry = noentry }
      ;add to loser3 end--------------------------------------%
 
      ;add to loser4 begin------------------------------------%
      if (%lostffanick4 != $null) {
        var %counter4 = $calc($gettok($hget(jiggle,%lostffanick4),5,32) + 1)
        hadd jiggle %lostffanick4 $puttok($hget(jiggle,%lostffanick4),%counter4,5,32)
        hadd jiggle %lostffanick4 $puttok($hget(jiggle,%lostffanick4),$gettok(%retelo,5,32),6,32)
        hsave -os jiggle jiggle.txt
        var %msgaddloser4 = %lostffanick4 its ur %counter4 lost ffa game ::Elo: $gettok(%retelo,5,32)
      }
      else { var %noentry = noentry }
      ;add to loser5 end--------------------------------------%
 
      ;add to loser5 begin------------------------------------%
      if (%lostffanick5 != $null) {
        var %counter5 = $calc($gettok($hget(jiggle,%lostffanick5),5,32) + 1)
        hadd jiggle %lostffanick5 $puttok($hget(jiggle,%lostffanick5),%counter5,5,32)
        hadd jiggle %lostffanick5 $puttok($hget(jiggle,%lostffanick5),$gettok(%retelo,6,32),6,32)
        hsave -os jiggle jiggle.txt
        var %msgaddloser5 = %lostffanick5 its ur %counter5 lost ffa game :: Elo: $gettok(%retelo,6,32)
      }
      else { var %noentry = noentry }
      ;add to loser5 end--------------------------------------%
 
      ;add to loser6 begin------------------------------------%
      if (%lostffanick6 != $null) {
        var %counter6 = $calc($gettok($hget(jiggle,%lostffanick6),5,32) + 1)
        hadd jiggle %lostffanick6 $puttok($hget(jiggle,%lostffanick6),%counter6,5,32)
        hadd jiggle %lostffanick6 $puttok($hget(jiggle,%lostffanick6),$gettok(%retelo,7,32),6,32)
        hsave -os jiggle jiggle.txt
        var %msgaddloser6 = %lostffanick5 its ur %counter6 lost ffa game :: Elo: $gettok(%retelo,7,32)
      }
      else { var %noentry = noentry }
      ;add to loser6 end--------------------------------------%
      msg $chan %msgaddwinner
      msg $chan %msgaddloser1 %msgaddloser2 %msgaddloser3 %msgaddloser4 %msgaddloser5 %msgaddloser6
    write -a logforscores.txt $fulldate :: Confirmed :: %msgaddwinner :: %msgaddloser1 :: %msgaddloser2 :: %msgaddloser3 :: %msgaddloser4 :: %msgaddloser5 :: %msgaddloser6  }
  timer2 20 1 echo -s timer running  }
  ;FFA Section Confirm End--------------------------------------------------------%
 
  ;22team Section Confirm Begin---------------------------------------------------%
  elseif (((%lostteamnick1 == $remove($nick,-tk)) || (%lostteamnick2 == $remove($nick,-tk)))  && (22team == %gametype22team)) {
    if ($timer(2).reps > 0) {      
    msg $chan Please wait 20 sec. Procedure in progress... }
    else {
      ;zugreifen auf Alias und Werte von $BerechneElo22team in variable %retelo zuweisen
      var %retelo = $BerechneElo22team(%winteamnick1,%winteamnick2,%lostteamnick1,%lostteamnick2)
 
      ;abspeichern des alias $BerechneElo22team in Haschtable fur gewinner und verlierer mittles $gettok(%retelo,x,y)
      hadd jiggle %winteamnick1 $puttok($hget(jiggle,%winteamnick1),$gettok(%retelo,1,32),9,32)
      hadd jiggle %winteamnick2 $puttok($hget(jiggle,%winteamnick2),$gettok(%retelo,2,32),9,32)
      hadd jiggle %lostteamnick1 $puttok($hget(jiggle,%lostteamnick1),$gettok(%retelo,3,32),9,32)
      hadd jiggle %lostteamnick2 $puttok($hget(jiggle,%lostteamnick2),$gettok(%retelo,4,32),9,32)
 
      ;add to winner1 beginn-----------------------------------%
      var %counter1 = $calc($gettok($hget(jiggle,%winteamnick1),7,32) + 1)
      hadd jiggle %winteamnick1 $puttok($hget(jiggle,%winteamnick1),%counter1,7,32)
      var %msgaddwinner1 = %winteamnick1 won already %counter1 Teamers :: Elo : $gettok(%retelo,1,32)
      ;add to winner1 end--------------------------------------%
      ;add to winner2 beginn-----------------------------------%
      var %counter2 = $calc($gettok($hget(jiggle,%winteamnick2),7,32) + 1)
      hadd jiggle %winteamnick2 $puttok($hget(jiggle,%winteamnick2),%counter2,7,32)
      var %msgaddwinner2 = %winteamnick2 won already %counter2 Teamers :: Elo : $gettok(%retelo,2,32)
      ;add to winner2 end--------------------------------------%
      ;add to loser1 begin------------------------------------%
      var %counter3 = $calc($gettok($hget(jiggle,%lostteamnick1),8,32) + 1)
      hadd jiggle %lostteamnick1 $puttok($hget(jiggle,%lostteamnick1),%counter3,8,32)
      var %msgaddloser1 = %lostteamnick1 lost %counter3 teamers Elo : $gettok(%retelo,3,32)
      ;add to loser1 end--------------------------------------%
      ;add to loser2 begin------------------------------------%
      var %counter4 = $calc($gettok($hget(jiggle,%lostteamnick2),8,32) + 1)
      hadd jiggle %lostteamnick2 $puttok($hget(jiggle,%lostteamnick2),%counter4,8,32)
      var %msgaddloser2 = %lostteamnick2 lost %counter4 teamers ::Elo : $gettok(%retelo,4,32)
      hsave -os jiggle jiggle.txt
      ;add to loser2 end--------------------------------------%
      msg $chan %msgaddwinner1 %msgaddwinner2
      msg $chan %msgaddloser1 %msgaddloser2
      write -a logforscores.txt $fulldate :: Confirmed :: %msgaddwinner1 ::  %msgaddwinner2  :: %msgaddloser1 :: %msgaddloser2
      ;22team Section Confirm End-----------------------------------------------------%
    timer2 20 1 echo -s timer running  }
  }
  ;33team Section Confirm Begin-----------------------------------------------------%
  elseif (33team == %gametype33team) && ((%lostteamnick1 == $remove($nick,-tk)) || (%lostteamnick2 == $remove($nick,-tk)) || (%lostteamnick3 == $remove($nick,-tk))) {
    if ($timer(2).reps > 0) {      
    msg $chan Please wait 20 sec. Procedure in progress... }
    else {
      ;zugreifen auf Alias und Werte von $BerechneElo33team in variable %retelo zuweisen
      var %retelo = $BerechneElo33team(%winteamnick1,%winteamnick2,%winteamnick3,%lostteamnick1,%lostteamnick2,%lostteamnick3)
 
      ;abspeichern des alias $BerechneElo33team in Haschtable fur gewinner und verlierer mittles $gettok(%retelo,x,y)
      hadd jiggle %winteamnick1 $puttok($hget(jiggle,%winteamnick1),$gettok(%retelo,1,32),9,32)
      hadd jiggle %winteamnick2 $puttok($hget(jiggle,%winteamnick2),$gettok(%retelo,2,32),9,32)
      hadd jiggle %winteamnick3 $puttok($hget(jiggle,%winteamnick3),$gettok(%retelo,3,32),9,32)
      hadd jiggle %lostteamnick1 $puttok($hget(jiggle,%lostteamnick1),$gettok(%retelo,4,32),9,32)
      hadd jiggle %lostteamnick2 $puttok($hget(jiggle,%lostteamnick2),$gettok(%retelo,5,32),9,32)
      hadd jiggle %lostteamnick3 $puttok($hget(jiggle,%lostteamnick3),$gettok(%retelo,6,32),9,32)
 
      ;add to winner1 beginn-----------------------------------%
      var %counter1 = $calc($gettok($hget(jiggle,%winteamnick1),7,32) + 1)
      hadd jiggle %winteamnick1 $puttok($hget(jiggle,%winteamnick1),%counter1,7,32)
      var %msgaddwinner1 = %winteamnick1 u won already %counter1 teamers :: Elo : $gettok(%retelo,1,32)
      ;add to winner1 end--------------------------------------%
      ;add to winner2 beginn-----------------------------------%
      var %counter2 = $calc($gettok($hget(jiggle,%winteamnick2),7,32) + 1)
      hadd jiggle %winteamnick2 $puttok($hget(jiggle,%winteamnick2),%counter2,7,32)
      var %msgaddwinner2 = %winteamnick2 u won already %counter2 teamers :: Elo : $gettok(%retelo,2,32)
      ;add to winner2 end--------------------------------------%
      ;add to winner3 beginn-----------------------------------%
      var %counter3 = $calc($gettok($hget(jiggle,%winteamnick3),7,32) + 1)
      hadd jiggle %winteamnick3 $puttok($hget(jiggle,%winteamnick3),%counter3,7,32)
      var %msgaddwinner3 = %winteamnick3 u won already %counter3 teamers :: Elo : $gettok(%retelo,3,32)
      ;add to winner3 end--------------------------------------%
      ;add to loser1 begin------------------------------------%
      var %counter4 = $calc($gettok($hget(jiggle,%lostteamnick1),8,32) + 1)
      hadd jiggle %lostteamnick1 $puttok($hget(jiggle,%lostteamnick1),%counter4,8,32)
      var %msgaddloser1 = %lostteamnick1 u lost %counter4 teamers :: Elo : $gettok(%retelo,4,32)
      ;add to loser1 end--------------------------------------%
      ;add to loser2 begin------------------------------------%
      var %counter5 = $calc($gettok($hget(jiggle,%lostteamnick2),8,32) + 1)
      hadd jiggle %lostteamnick2 $puttok($hget(jiggle,%lostteamnick2),%counter5,8,32)
      var %msgaddloser2 = %lostteamnick2 u lost %counter5 teamers :: Elo : $gettok(%retelo,5,32)
      ;add to loser2 end--------------------------------------%
      ;add to loser3 begin------------------------------------%
      var %counter6 = $calc($gettok($hget(jiggle,%lostteamnick3),8,32) + 1)
      hadd jiggle %lostteamnick3 $puttok($hget(jiggle,%lostteamnick3),%counter6,8,32)
      var %msgaddloser3 = %lostteamnick3 u lost %counter6 teamers :: Elo : $gettok(%retelo,6,32)
      hsave -os jiggle jiggle.txt
      ;add to loser3 end--------------------------------------%
      msg $chan %msgaddwinner1 %msgaddwinner2 %msgaddwinner3
      msg $chan %msgaddloser1 %msgaddloser2 %msgaddloser3
      write -a logforscores.txt $fulldate :: Confirmed :: %msgaddwinner1 :: %msgaddwinner2 :: %msgaddwinner3 :: %msgaddloser1 :: %msgaddloser2 :: %msgaddloser3
      ;33team Section Confirm End-----------------------------------------------------%
    timer2 20 1 echo -s timer running  }
  }
  ;44team Section Confirm Begin---------------------------------------------------%
  elseif (44team == %gametype44team) && ((%lostteamnick1 == $remove($nick,-tk)) || (%lostteamnick2 == $remove($nick,-tk)) || (%lostteamnick3 == $remove($nick,-tk)) || (%lostteamnick4 == $remove($nick,-tk))) {
    if ($timer(2).reps > 0) {      
    msg $chan Please wait 20 sec. Procedure in progress... }
    else {
      ;zugreifen auf Alias und Werte von $BerechneElo22team in variable %retelo zuweisen
      var %retelo = $BerechneElo44team(%winteamnick1,%winteamnick2,%winteamnick3,%winteamnick4,%lostteamnick1,%lostteamnick2,%lostteamnick3,%lostteamnick4)
 
      ;abspeichern des alias $BerechneElo22team in Haschtable fur gewinner und verlierer mittles $gettok(%retelo,x,y)
      hadd jiggle %winteamnick1 $puttok($hget(jiggle,%winteamnick1),$gettok(%retelo,1,32),9,32)
      hadd jiggle %winteamnick2 $puttok($hget(jiggle,%winteamnick2),$gettok(%retelo,2,32),9,32)
      hadd jiggle %winteamnick3 $puttok($hget(jiggle,%winteamnick3),$gettok(%retelo,3,32),9,32)
      hadd jiggle %winteamnick4 $puttok($hget(jiggle,%winteamnick4),$gettok(%retelo,4,32),9,32)
      hadd jiggle %lostteamnick1 $puttok($hget(jiggle,%lostteamnick1),$gettok(%retelo,5,32),9,32)
      hadd jiggle %lostteamnick2 $puttok($hget(jiggle,%lostteamnick2),$gettok(%retelo,6,32),9,32)
      hadd jiggle %lostteamnick3 $puttok($hget(jiggle,%lostteamnick3),$gettok(%retelo,7,32),9,32)
      hadd jiggle %lostteamnick4 $puttok($hget(jiggle,%lostteamnick4),$gettok(%retelo,8,32),9,32)
 
      ;add to winner1 beginn-----------------------------------%
      var %counter1 = $calc($gettok($hget(jiggle,%winteamnick1),7,32) + 1)
      hadd jiggle %winteamnick1 $puttok($hget(jiggle,%winteamnick1),%counter1,7,32)
      var %msgaddwinner1 = %winteamnick1 u won already %counter1 teamers :: Elo : $gettok(%retelo,1,32)
      ;add to winner1 end--------------------------------------%
      ;add to winner2 beginn-----------------------------------%
      var %counter2 = $calc($gettok($hget(jiggle,%winteamnick2),7,32) + 1)
      hadd jiggle %winteamnick2 $puttok($hget(jiggle,%winteamnick2),%counter2,7,32)
      var %msgaddwinner2 = %winteamnick2 u won already %counter2 teamers :: Elo : $gettok(%retelo,2,32)
      ;add to winner2 end--------------------------------------%
      ;add to winner3 beginn-----------------------------------%
      var %counter3 = $calc($gettok($hget(jiggle,%winteamnick3),7,32) + 1)
      hadd jiggle %winteamnick3 $puttok($hget(jiggle,%winteamnick3),%counter3,7,32)
      var %msgaddwinner3 = %winteamnick3 u won already %counter3 teamers :: Elo : $gettok(%retelo,3,32)
      ;add to winner3 end--------------------------------------%
      ;add to winner4 beginn-----------------------------------%
      var %counter4 = $calc($gettok($hget(jiggle,%winteamnick4),7,32) + 1)
      hadd jiggle %winteamnick4 $puttok($hget(jiggle,%winteamnick4),%counter4,7,32)
      var %msgaddwinner4 = %winteamnick4 u won already %counter4 teamers :: Elo : $gettok(%retelo,4,32)
      ;add to winner4 end--------------------------------------%
      ;add to loser1 begin------------------------------------%
      var %counter5 = $calc($gettok($hget(jiggle,%lostteamnick1),8,32) + 1)
      hadd jiggle %lostteamnick1 $puttok($hget(jiggle,%lostteamnick1),%counter5,8,32)
      var %msgaddloser1 = %lostteamnick1 u lost %counter5 teamers :: Elo : $gettok(%retelo,5,32)
      ;add to loser1 end--------------------------------------%
      ;add to loser2 begin------------------------------------%
      var %counter6 = $calc($gettok($hget(jiggle,%lostteamnick2),8,32) + 1)
      hadd jiggle %lostteamnick2 $puttok($hget(jiggle,%lostteamnick2),%counter6,8,32)
      var %msgaddloser2 = %lostteamnick2 u lost %counter5 teamers ::  Elo : $gettok(%retelo,6,32)
      ;add to loser2 end--------------------------------------%
      ;add to loser3 begin------------------------------------%
      var %counter7 = $calc($gettok($hget(jiggle,%lostteamnick3),8,32) + 1)
      hadd jiggle %lostteamnick3 $puttok($hget(jiggle,%lostteamnick3),%counter7,8,32)
      var %msgaddloser3 = %lostteamnick3 u lost %counter7 teamers :: Elo : $gettok(%retelo,7,32)
      ;add to loser4 begin------------------------------------%
      var %counter8 = $calc($gettok($hget(jiggle,%lostteamnick4),8,32) + 1)
      hadd jiggle %lostteamnick4 $puttok($hget(jiggle,%lostteamnick4),%counter8,8,32)
      var %msgaddloser4 = %lostteamnick4 u lost %counter8 teamers :: Elo : $gettok(%retelo,8,32)
      hsave -os jiggle jiggle.txt
      ;add to loser4 end--------------------------------------%
      msg $chan %msgaddwinner1 %msgaddwinner2 %msgaddwinner3 %msgaddwinner4
      msg $chan %msgaddloser1 %msgaddloser2 %msgaddloser3 %msgaddloser4
      write -a logforscores.txt $fulldate :: Confirmed :: %msgaddwinner1 :: %msgaddwinner2 :: %msgaddwinner3 ::  %msgaddwinner4 :: %msgaddloser1 :: %msgaddloser2 :: %msgaddloser3 :: %msgaddloser4
      ;44team Section Confirm End-----------------------------------------------------%
    timer2 20 1 echo -s timer running  }
  }
  else { msg $chan No permission $remove($nick,-tk) or nothing to confirm }
}
 
;§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§§
 
; if type !top10 + gametype it shows the top 10 players rated by Elo
on *:TEXT:!top10*:#:{
  if ( $2 == duel ) {
    var %entries = $hget(jiggle, 0).item
    var %i = 1
    window -sh @bohne
    while ( %i <= %entries ) {  var %alldata = $hget(jiggle,%i).data
      var %partialdata = $base($gettok(%alldata,3,32),10,10,4) $gettok(%alldata,1,32) $gettok(%alldata,2,32) $round($calc(($gettok(%alldata,1,32)) / ($calc(($gettok(%alldata,1,32)) + ($gettok(%alldata,2,32)))) * 100 ),0) $hget(jiggle,%i).item
      aline @bohne %partialdata
      inc %i
    }
    var %total = $line(@bohne,0)
    var %t = %total
    var %k = 0
    while ( %k <= 9 ) {
      var %scores $line(@bohne,%t) | dec %t | inc %k
    msg $chan %k = $gettok(%scores,5,32) : Elo= $gettok(%scores,1,32) :  Wins = $gettok(%scores,2,32) : Loss = $gettok(%scores,3,32) : % = $gettok(%scores,4,32) }
    msg $chan EntireEntries $line(@bohne,0)
    window -c @bohne
  }
  elseif ( $2 == ffa ) {
    var %entries = $hget(jiggle, 0).item
    var %i = 1
    window -s @bohne
    while ( %i <= %entries ) {  var %alldata = $hget(jiggle,%i).data
      var %partialdata = $base($gettok(%alldata,6,32),10,10,4) $gettok(%alldata,4,32) $gettok(%alldata,5,32) $round($calc(($gettok(%alldata,4,32)) / ($calc(($gettok(%alldata,4,32)) + ($gettok(%alldata,5,32)))) * 100 ),0) $hget(jiggle,%i).item
      aline @bohne %partialdata
      inc %i
    }
    var %total = $line(@bohne,0)
    var %t = %total
    var %k = 0
    while ( %k <= 9 ) {
      var %scores $line(@bohne,%t) | dec %t | inc %k
    msg $chan %k = $gettok(%scores,5,32) : Elo= $gettok(%scores,1,32) :  Wins = $gettok(%scores,2,32) : Loss = $gettok(%scores,3,32) : % = $gettok(%scores,4,32) }
    msg $chan EntireEntries $line(@bohne,0)
    window -c @bohne
  }
  elseif ( $2 == teamer ) {
    var %entries = $hget(jiggle, 0).item
    var %i = 1
    window -s @bohne
    while ( %i <= %entries ) {  var %alldata = $hget(jiggle,%i).data
      var %partialdata = $base($gettok(%alldata,9,32),10,10,4) $gettok(%alldata,7,32) $gettok(%alldata,8,32) $round($calc(($gettok(%alldata,7,32)) / ($calc(($gettok(%alldata,7,32)) + ($gettok(%alldata,8,32)))) * 100 ),0) $hget(jiggle,%i).item
      aline @bohne %partialdata
      inc %i
    }
    var %total = $line(@bohne,0)
    var %t = %total
    var %k = 0
    while ( %k <= 9 ) {
      var %scores $line(@bohne,%t) | dec %t | inc %k
    msg $chan %k = $gettok(%scores,5,32) : Elo= $gettok(%scores,1,32) :  Wins = $gettok(%scores,2,32) : Loss = $gettok(%scores,3,32) : % = $gettok(%scores,4,32) }
    msg $chan EntireEntries $line(@bohne,0)
    window -c @bohne
  }
  else { msg $chan To see the Top 10 of duel ffa or teamer type : " !top10 duel " !top10 ffa " !top10 teamer " }
}
 
; syntax !rank gametype nickname
on *:TEXT:!rank*:#:{
  if ( $2 == duel ) {
    var %entries = $hget(jiggle, 0).item
    var %i = 1
    window -sh @bohne
    while ( %i <= %entries ) {  var %alldata = $hget(jiggle,%i).data
      var %partialdata = $base($gettok(%alldata,3,32),10,10,4) $gettok(%alldata,1,32) $gettok(%alldata,2,32) $round($calc(($gettok(%alldata,1,32)) / ($calc(($gettok(%alldata,1,32)) + ($gettok(%alldata,2,32)))) * 100 ),0) $hget(jiggle,%i).item
      aline @bohne %partialdata
    inc %i  }
    window -h @kraut
    var %total = $line(@bohne,0)
    var %t = %total
    var %k = 0
    while ( %k < %total ) {
      var %scores = $line(@bohne,%t) | dec %t | inc %k
    aline @kraut %k = $gettok(%scores,5,32) : Elo= $gettok(%scores,1,32) :  Wins = $gettok(%scores,2,32) : Loss = $gettok(%scores,3,32) : % = $gettok(%scores,4,32) }
    msg $chan EntireEntries $line(@bohne,0)
    msg $chan $fline(@kraut,* $3 *,1).text
    window -c @bohne
  window -c @kraut }
  elseif ( $2 == ffa ) {
    var %entries = $hget(jiggle, 0).item
    var %i = 1
    window -sh @bohne
    while ( %i <= %entries ) {  var %alldata = $hget(jiggle,%i).data
      var %partialdata = $base($gettok(%alldata,6,32),10,10,4) $gettok(%alldata,4,32) $gettok(%alldata,5,32) $round($calc(($gettok(%alldata,4,32)) / ($calc(($gettok(%alldata,4,32)) + ($gettok(%alldata,5,32)))) * 100 ),0) $hget(jiggle,%i).item
      aline @bohne %partialdata
    inc %i }
    window -h @kraut
    var %total = $line(@bohne,0)
    var %t = %total
    var %k = 0
    while ( %k < %total ) {
      var %scores = $line(@bohne,%t) | dec %t | inc %k
    aline @kraut %k = $gettok(%scores,5,32) : Elo= $gettok(%scores,1,32) :  Wins = $gettok(%scores,2,32) : Loss = $gettok(%scores,3,32) : % = $gettok(%scores,4,32) }
    msg $chan EntireEntries $line(@bohne,0)
    msg $chan $fline(@kraut,* $3 *,1).text
    window -c @bohne
  window -c @kraut }
  elseif ( $2 == teamer ) {
    var %entries = $hget(jiggle, 0).item
    var %i = 1
    window -sh @bohne
    while ( %i <= %entries ) {  var %alldata = $hget(jiggle,%i).data
      var %partialdata = $base($gettok(%alldata,9,32),10,10,4) $gettok(%alldata,7,32) $gettok(%alldata,8,32) $round($calc(($gettok(%alldata,7,32)) / ($calc(($gettok(%alldata,7,32)) + ($gettok(%alldata,8,32)))) * 100 ),0) $hget(jiggle,%i).item
      aline @bohne %partialdata
    inc %i  }
    window -h @kraut
    var %total = $line(@bohne,0)
    var %t = %total
    var %k = 0
    while ( %k < %total ) {
      var %scores = $line(@bohne,%t) | dec %t | inc %k
    aline @kraut %k = $gettok(%scores,5,32) : Elo= $gettok(%scores,1,32) :  Wins = $gettok(%scores,2,32) : Loss = $gettok(%scores,3,32) : % = $gettok(%scores,4,32) }
    msg $chan EntireEntries $line(@bohne,0)
    msg $chan $fline(@kraut,* $3 *,1).text
    window -c @bohne
  window -c @kraut }
  else { msg $chan To see a rank of a certain player type !rank duel or ffa or teamer and last parameter the nickname }
}
 
on *:TEXT:!report*:#:{
  write -a logforscores.txt $fulldate $2-
  msg $chan $2- :: Is Noticed
}

on *:TEXT:!help*:#:{
 if (!$2) { msg $chan $nick $+ : the bot works this way: first u need register to the bot so that it recognise u with command !register. then when u have won a match u type for duel: !won duel then followed by opponent. opponent need write !confirm. same way it works for teamer. u type !won 22team then ur teammate, followed by 2 opponents.one of the opponent need "!confirm". other game modi are ffa team33 and team44. one of the opponent need "!confirm" Available commands are 1) !register, 2) !won, 3) !confirm, 4) !top10, 5) !rank, 6) !report, 7) !help, 9) !gametype. Type !help <command> for more info. }
 if $2 == !register { msg $chan $nick $+ : put your nickname in the hashtable and makes u able use bot }
 if $2 == !won { msg $chan $nick $+ : !won gametype nickname(s), on 2v2teamer the inputer and the 2nd nick is stored to winner section the 3rd and 4th nickname is loser and stored so all parameter just delimeted by a space character. on 3v3 teamer inputer 2nd and 3rd nick counted to winner teamer 4th 5th and 6th nick stored to loser how it will work for 4v4? }
 if $2 == !confirm { msg $chan $nick $+ : here just the loser confirm his loss, its enough one of the losers confirm e.g in ffa or teamer }
 if $2 == !top10 { msg $chan $nick $+ : syntax : !top10 gametype..... !top10 duel, !top10 ffa, !top10 teamer - shows top 10 of gametype }
 if $2 == !rank { msg $chan $nick $+ : syntax: !rank gametype nickname - shows rank of a certain nickname rated by elo }
 if $2 == !report { msg $chan $nick $+ : stores waht ever was said in logfile with date day time for admin to notice }
 if $2 == !gametype { msg $chan $nick $+ : currentlysupported gametypes are: ffa, duel, 22team, 33team, 44team. }
}
