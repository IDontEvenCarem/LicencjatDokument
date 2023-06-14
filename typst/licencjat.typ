#let title = "Przykłady zastosowania technik optymalizacji czasu wczytywania witryny internetowej"

#let footnote_counter = counter("footnote")
#let footnote_list = state("footnote_list", ())

#set document(
    title: title,
    author: "Kajetan Owczarek" 
)
#set page(
    numbering: "1", 
    number-align: center,
    footer: [
        #locate(loc => {
            let curr_footnotes = footnote_list.at(loc)
            if curr_footnotes.len() > 0 {
                line(length: 100%, stroke: 1pt + gray)
            }

            for el in curr_footnotes {
                [#el.idx - #el.body \ ]
            }

            footnote_list.update(v => ())
        })
    ]
)
#set text(
    font: "Lato", 
    lang: "pl", 
    hyphenate: true
)
#set heading(numbering: "1.1")

#let footnote(body) = {
    locate(loc => {
        let fid = footnote_counter.at(loc).first()
        super[[#fid]]
        footnote_list.update(v => v + ((idx: fid, body: body),))
        footnote_counter.step()
    })
}


#let measurements_showcase(data) = {
    let sum = 0
    for v in data {
        sum += v
    }

    table(
        columns: (1fr,)*(data.len()+1),
        ..data.map(v => [#v]), [#(sum / data.len())]
    )
}



// =================================================
//      START OF CONTENT
// =================================================

#align(center)[
    #block(text(weight: 700, size: 1.75em, title))
]

#align(center)[
    #pad(
        top: 0.5em, bottom: 0.5em, x: 2em,
        strong("Kajetan Owczarek")
    )
]

#outline(indent: true, title: "Spis treści")
#pagebreak()

= Wstęp
Pomimo nieustającego rozwoju technologii telekomunikacji oraz zwiększania prędkości łączy internetowych, problem wydajności usług internetowych nie zniknął, ani nie zapowiada się, aby tak się zadziało. Od potrzeb łączności poza terenami zabudowanymi, przez starzejący lub ograniczony sprzęt, po malejącą cierpliwość użytkowników, rozważanie, jak najszybciej dostarczyć treści z serwera do urządzenia użytkownika jest powszechne w pracy ze stronami internetowymi.

Celem tej pracy jest zaprezentowanie serii technik i optymalizacji, pozwalających na poprawienie czasów wczytywania stron internetowych na urządzeniach użytkownika, oraz porównanie ich przy pomocy obiektywnych i powszechnie stosowanych metryk. Główne wartości, których optymalizacją jestem zainteresowany, to czas to pojawienia się na stronie pierwszej treści, czas do interaktywności strony, oraz czas do pełnego wczytania treści niewczytywanej dynamicznie. 

Celem zilustrowania efektów takich optymalizacji, a w szczególności wpływ ich braku na używalność strony, zaprezentuję przykładową stronę zrobioną przy użyciu najprostszych, najpopularniejszych technik. Celem moim jest stworzenie strony, która zrobiona jest kompetentnie, acz z zerową uwagą przyłożoną do wydajności strony pod względem wczytywania i procesu uruchamiania strony. Następnie, poprzez stosowanie technik wpływających minimalnie na funkcjonalność strony, poprawiać wyniki pomiarów obiektywnych.




= Sposób pomiarów
Celem usunięcia jak najwięcej zewnętrznych zmiennych w danych pomiarowych, skorzystam z dwóch narzędzi używanych #footnote("Google") #footnote("Apple") #footnote[Microsoft]

== Lighthouse
Lighthouse to narzędzie stworzone przez Google, które analizuje strony internetowe pod wieloma względami, jak wydajność, dostępność, stosowanie rekomendowanych technik czy dostosowanie do silników wyszukiwania. W ramach tego projektu, tylko kategoria wydajności będzie nas interesowała.

Dane z Lighthouse'a powinny być traktowane raczej jako poglądowe, gdyż część pomiarów jest ustalane poprzez wykonanie normalnej pracy przeglądarki, a następnie przeskalowanie czasów trwiania o różnice wydajności maszyny prawdziwej a standardowej. Dokładniejsze pomiary dostarczy nam WebPageTest.

== WebPageTest
WebPageTest to strona umożliwiająca zarządanie zbadania wydajności strony za pomocą uruchomienia jej na pełnej emulacji docelowego urządzenia. Prócz tego dostarcza on bardzo praktyczny wgląd w detale tego, jak nasza strona była wczytywana.

Poniżej przykład pomiaru ogólnych statystyk:
#image("baseline-results.png")

Poniżej przykład widoku Waterfall procesu wczytania:
#image("baseline-waterfall.png")

= Bazowa witryna
Jako bazowa strona, do której zastosujemy techniki, stworzyłem prostą stronę udającą stronę z wiadomościami. 

= Zastosowane techniki
== Wycinanie funkcji z bibliotek
Podczas implementacji strony, oprócz używanych przez nas funkcji biliotek, załączyliśmy wiele, których nie potrzebujemy. Możemy więc pozbyć się ich, bez straty funkcjonalności.

=== Generator danych faker-js
Bardzo duża ilość kodu, który znajdował się w finalnym pliku strony była pokażna baza danych biblioteki faker-js, która jest używana do generowania losowych danych. Choć na prawdziwej stronie taki generator zapewnie nie byłby potrzebny, tak tego rodzaju problem jest bardzo powrzechny. Powrzechne jest chcieć posiadać możliwości obsługi wielu języków, co oznacza potencjalną duplikację danych dla każdego języka, który chcemy wspierać. (Jake Archibald mówił o tym, że strona google.io tak robiła)

Problem zbędnych funkcji będących umieszczanych na stronach jest załagodzany przez nowoczesne narzędzia. Większość systemów budowania kodu JavaScript w formę dostosowaną do użycia w przeglądarce dokonuje tree shakingu oraz dead branch elimination, które wspólnie usuwają elementy kodu, które nigdy nie mogą zostać wykorzystane. Niestety, w szczególności w przypadku baz językowych, ustalenie, co dokładnie będzie programowi potrzebne do wykonania się poprawnie bywa trudne lub wręcz niemożliwe. Gdybyśmy używali innych części tej biblioteki moglibyśmy na ten problem natrafić, acz w naszym przypadku problem wynikał z formy dystrybucji biblioteki faker-js. Biblioteka ta składa się z plików przystosowantch pod bycie wielce niezależnymi od tego, jakie są same dane przez nią używane, a żeby to osiągnąć używa metod, które burzą optymalizacje późniejszych narzędzi.

Niezmiennie, ręcznie wyciągająć tylko potrzebną nam funkcjonalność oraz bazy danych, z których są później składane nasze losowe dane, możemy znacznie poprawić rozmiar strony.

=== Biblioteka CSS Bootstrap
https://purifycss.online/


== Dzielenie kodu i asynchroniczne wczytywanie
Duża część kodu może zostać wczytana po tym, jak strona będzie już w używalnym stanie. O wiele lepiej dla użytkownika, kiedy na stronie działa cokolwiek. Możemy więc podzielic naszą stronę na części, które będę wczytywały wtedy, kiedy będą potrzebne.

=== Niezależne wczytywanie podstron
Kinda done

=== Opóźnienie wczytywania mniej ważnych elementów
Kinda done


== Korzystanie ze strumieniowania HTML
=== Struktura strony poza dynamiczną zawartością

== Optymalizacja zdjęć
=== Wybór rozmiaru
=== Formaty i kompresja
#lorem(100)

== Optymalizacja czcionek
=== Usuwanie niepotrzebnych znaków
=== Wczytywanie w tle
#lorem(100)

== Kompresja
=== Ustawianie serwera
#lorem(100)

= Podsumowanie
#lorem(100)
