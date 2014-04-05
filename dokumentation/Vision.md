# Vision
## Introduktion
Jag ska göra en Webapplikation där man kan skissa på idéer och planera
vad man ska göra i projekt.

Jag gillar att skissa när jag tänker och planerar för att lättare hålla
ordning och få en fast inriktining. Att använda penna och papper är ofta
besvärligt, speciellt om man vill spara eller dela anteckningarna. Och
att rita på en dator är inte heller speciellt smidigt och man tappar mycket
av känslan när man ritar med en mus.
Därför vill jag rikta in mig på ett touch-gränsnitt i första hand så att
man kan använda en surfplatta och rita med antingen fingrar eller en penna.
Men själklart ska det även fungera bra på en dator med mus och tangentbord.

Jag vill även att det ska gå att presentera sina skisser på en bra sätt
för att kunna planera projekt och rita upp saker som databasmodeller och
klassdiagram.

## Användargrupper
Användare som vill planera och utveckla idéer genom skisser och beskrivningar,
och som ser nyttan i att använda en surfplatta istället för penna och papper
genom att enkelt kunna dela och presentera sitt arbete.

## Liknade system
### Sketch Notes
Sketch Notes tillåter en att rita på en Android surfplatta på flera blad.
Den har dock ingen funktionalitet för att skriva text och symboler.

### Powerpoint
Powerpoint har ett liknade upplägg som jag tänker mig, men är inte inriktad
på att skissa och planera utan riktar endast in sig på presentation. Det
har inte ett smidigt gränsnitt och är inte touchanpassat.

## Baskrav
### BK 1
Ett användavänligt gränsnitt som är bra anpassat för touch.

### BK 2
Möjlighet att skriva text, rita för frihand, skapa listor och lägga in symboler
(exempelvis objekt i databasmodeller).

### BK 3
Möjlighet till att byta till en nytt blad samt navigera mellan olika blad

### BK 4
Möjlighet att arbeta med bladen på en större arbetsyta och strukurera dessa.

## Teknik
Jag ska använda mig programmeringspråket [Dart](https://www.dartlang.org/), tillsammans med framework:et
[AngularDart](https://angulardart.org/). Jag ska även använda mig av ett microframework som jag själv har
skrivit för att enkelt skapa REST-liknade APIer.

Jag tycker att Dart är ett riktigt trevligt språk och vill gärna fördjupa mina
kunskaper i det. Jag har även valt att använda AngularDart därför att det hjälper
till att få en bra struktur samt gör att man slipper en en hel del kod för att
hålla gränsnittet uppdaterat.

Som utvecklingsmiljö ska jag använda mig Dart Editor tillsammans med WebStorm.
Dart Editor är utvecklad av Dartteamet och är bra på Dart men är inte speciellt
bra på versionshantering, HTML, CSS eller SASS så jag väljer därför att använda
WebStorm som komplement.
