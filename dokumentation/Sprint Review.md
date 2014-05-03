# Sprint 1
Denna sprint gick bra. Jag hade överskattat en del uppgifter så veckan slutade lite fortare än förväntat,
men eftersom jag hade glömt att räkna med påsken så gick det bra ändå. Jag stötte på en bugg i AngularDart
som jag blev tvungen att hitta enn minimalt exemplel på och sen rapportera den.

# Sprint 2
Den här sprinten blev kortare i tid då jag hade en del att göra när jag kom hem efter påsken. Jag överskred
den estimerade tiden en del, främst på grund utav uppdateringen av Angular som hade en hel del breaking changes.
En av dessa var dessutom odokumenterad och tog lång tid innan jag sen förstod att det fanns ett mycket
enklare sätt att lösa problemet på där jag inte behövde använda den borttagna klassen. Eftersom jag kom
runt problemet orkade jag inte lämna in någon buggrapoirt på den odokumenterade borttagningen.

# Sprint 3
Efter att ha fokuserat på testning känns det som jag har ett bättre grepp på den och har en bra grund att
bugga vidare på. Testresultaten går att se efter vare push på drone.io. Veckans build är
[#37](https://drone.io/github.com/re222dv/Cogito/37)

Tidsmässigt är det väl inte så mycket att säga, vissa saker gick snababre än trott medans
en (rita pilar) tog längre tid vilket gjorde att det jämnade ut sig. Jag blev tvungen att rapportera ännu
en [bugg till AngularDart](https://github.com/angular/angular.dart/issues/987).

Att publicera på OpenShift gick helt åt skogen då ingen av de två cartridgen
jag hittade fungerade (den ena var för gammal och den andra fungerade inte pub, darts pakethanterare i).
Jag tog en nödlösning och publicerade klientdelen på [github pages](http://re222dv.github.io/Cogito/) men
där fungerar inte serverdelen så jag blir tvungen att leta efter en ny lösning.
