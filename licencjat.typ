#let title = "Przykłady zastosowania technik optymalizacji czasu wczytywania witryny internetowej"

#set document(
    title: title,
    author: "Kajetan Owczarek" 
)
#set page(
    numbering: "1", 
    number-align: center
)
#set text(
    font: "Lato", 
    lang: "pl", 
    hyphenate: true
)
#set heading(numbering: "1.1")


#let measurements_showcase(data) = {
    
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
#lorem(100)
= Sposób pomiarów
#lorem(100)
== Lighthouse
#lorem(100)
== WebPageTest
#lorem(100)

= Bazowa witryna
#lorem(100)

= Zastosowane techniki
#lorem(100)

== Dzielenie kodu i asynchroniczne wczytywanie
=== Niezależne wczytywanie podstron
=== Opóźnienie wczytywania mniej ważnych elementów
#lorem(100)

== Wycinanie funkcji z bibliotek
=== Generowanie danych - lorem ipsum
=== Odtwarzanie audio - Howler
#lorem(100)

== Korzystanie ze strumieniowania HTML
=== Struktura strony poza dynamiczną zawartością
=== Ustawianie zasobów z myślą o równoległym przetwarzaniu
#lorem(100)

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
