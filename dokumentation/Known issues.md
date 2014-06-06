# Handtagen för att ändra storlek placeras fel
Handtagen för att ändra storlek på noder placeras inte alltid korrekt och vissa verktyg
har väldigt stora fel.

Idag används storleken som DOM:en anger för att beräkna positionen, uppenbarligen
fungerar det dåligt. Istället bör storleken beräknas manuellt.

Denna bugg löses bäst i samma veva som varje typ av nod får sin egen komponent. Just nu
blockeras dock det av [angular/angular.dart#987](https://github.com/angular/angular.dart/issues/987)

# När man navigerar ifrån sidan så kan hela sidan försvinna och endast en blå sida visas
Om man navigerar iväg från sidan på ett sätt som triggar Angulars RouteHandler
så försvinner hela sidan och endast en blå sida visas. Detta inträffar framförallt
när man från `/page` använder backknappen för att gå till `/`.

Detta beror på en bug i routingbiblioteket i Angular och den går att följa på
[angular/route.dart#28](https://github.com/angular/route.dart/issues/28)
(Buggen är nu fixad där, men eftersom det var så sent i projektet och att det
sen tar några dagar för den att komma in i Angular så har jag valt att inte
uppdatera eftersom Angular utvecklas så snabbt nu och det kan va så att de har
ändrat på saker som jag använder.)

# Tooltipen för dropdown fastnar när man väljer ett alternativ i dropdownen
När jag väljer ett alternativ i dropdownmenyn kommer tooltipen upp och jag måste
dra musen över dropdown knappen för att släcka den. Eftersom jag använder CSS
selectorn `:hover` för att visa den kan jag bara gissa på att det beror på en
sak, Shadow Dom, och att webbläsaren missar att jag inte längre hovrar eftersom
muspekaren nu är placerad utanför Shadow Dom:en. Om det ska vara så och jag på
något sätt måste notifiera att jag inte hovrar på något sätt eller om det är en
bugg i Chrome vet jag inte.
