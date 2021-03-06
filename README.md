Cogito [![Build Status](https://travis-ci.org/re222dv/Cogito.svg?branch=master)](https://travis-ci.org/re222dv/Cogito)
======

A web based tool for planning and design

## För att köra
### Inloggningsuppgifter
Skapa antingen ett eget konto (ingen fungerande mail behövs) eller logga in med

    Epost: a@a
    Lösenord: aaaaa

### Publicerad version
En publicerad version finns på [heroku](http://re222dv-cogito.herokuapp.com/). Eftersom Heroku
stänger ner min VM efter en timmes inaktivitet (gratis version) så kan det ta lång tid att ladda
den första sidan så VM startar upp, efter det ska det dock gå snabbt.

### Lokal version
Det finns två sätt att köra applikationen lokalt, antingen som Javascript eller som Dart i Dartium.
Servern måste alltid körs i Dart VM.

Installera först [Dart SDK](https://www.dartlang.org/tools/download.html) kör sedan `pub get` i
applikationsroten för att installera beroenden (beroendena är specificerade i filen pubspec.yaml).

Applikationen är redan förberedd för att köras som Dart men för att köra applikationen som Javascript
måste den kompileras. Detta görs genom att köra `pub build` i applikationsrooten. Efter det måste
STATIC_PATH i bin/server.dart ändras till `../build/web`.

Starta servern genom att gå till `bin/` och köra `dart server.dart`. Nu kan du surfa till
[localhost:9000](http://localhost:9000). 

### Webbläsarstöd
Körs applikationen som Dart måste den köras i Dartium som följer med Dart SDK.
Körs applikationen som Javascript måste den köras i Chrome då applikationen använder sig av Shadow Dom.
Möjligtvis kan även Opera fungera ([caniuse rapporterar tidigt stöd för Shadow Dom i Opera](http://caniuse.com/shadowdom)) men den är
otestad. Firefox's stöd är ännu i ett tidigt stade och dras med stora buggar som gör den oanvändbar.

Jag förväntar mig att denna punkten löser sig själv i framtiden då flera webbläsare får stöd. Möjligtvis
kommer detta även att lösas i Angular Dart med en bättre polyfill innan det släpps i en stabil version,
men det återstår att se. När man använder väldigt nya tekniker får man förvänta sig sämre stöd.

Den publicerade versionen är kompilerad och ska därför köras i Chrome.

### Tester
Testerna är uppdelade i två delar. En del ska köras direkt i Dart VM och den andra ska köras i Dartium,
Detta för att det inte går att nå hela Darts standardbibliotek (endast serversidan kan nå dart:io och
endast klientsidan kan nå dart:html).

VM testerna körs genom att gå till `test/` och köra `dart vm_tests.dart`. Webbläsartesterna körs genom
att öppna test/browser_tests.dart i Dartium.

## Continuous Integration
Vid varje push kommer Travis att köra alla tester under både den stabila samt utvecklingsversionen
av Dart, efter testerna kommer den även att kompilera koden för att se att allt fungerar som det ska.
Historiken går att se på https://travis-ci.org/re222dv/Cogito/builds
Tidigare (fram till och med Sprint #4) användes Drone som CI och det går att se dessa körningar på
https://drone.io/github.com/re222dv/Cogito
Drone körde dock endast testerna (d.v.s. ingen kompilering) samt endast på den stabila versionen av Dart.

## Demonstrationsfilm
[Finns på Youtube](http://youtu.be/XKqTwt-qIM0)

## Dokumentation
Dokumentation finns i `/dokumentation`.
`Google Docs.md` innehåller länkar till de dokument som är skrivna där, men det finns också en PDF-version
av varje dokument direkt i `/dokumentation`.

#### Product Backlog
##### Prioritet
Baserat på en skala från 1 till 5 där 5 är högsta prioritet. Den är baserad på en uppskattad avvägning
mellan nytta för applikationen och estimerad tid.

##### Beroenden
Betyder att den eller de listade kraven måste eller är starkt rekommenderade att implementeras först.

##### Status
Klart betyder att kravet är både implementerat och testat med automatiska tester.
Implementerat betyder att kravet är implementerat i applikationen men att det inte ännu är testat.
