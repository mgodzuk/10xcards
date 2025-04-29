# Dokument wymagań produktu (PRD) - AI Fiszki

## 1. Przegląd produktu

AI Fiszki to aplikacja webowa skierowana do studentów, umożliwiająca szybkie tworzenie i zarządzanie fiszkami edukacyjnymi. Główne funkcje obejmują generowanie fiszek z wprowadzonego tekstu za pomocą AI, manualne tworzenie oraz podstawowe operacje CRUD. Uwierzytelnianie użytkowników odbywa się przez OAuth, a przechowywane fiszki można przeglądać, edytować i usuwać. Gotowe fiszki można wykorzystać w procesie powtórek opartym na istniejącym algorytmie spaced repetition.

## 2. Problem użytkownika

Studentom brakuje czasu na ręczne tworzenie fiszek edukacyjnych, mimo że spaced repetition jest uznaną metodą ułatwiającą zapamiętywanie. Proces ręcznego przygotowywania fiszek jest czasochłonny i żmudny, co zniechęca do korzystania z metody powtórek.

## 3. Wymagania funkcjonalne

1. Generowanie fiszek przez AI
   - wejście: tekst o długości do 255 znaków
   - generowanie zestawu pytań i odpowiedzi w formacie fiszek
   - jednorazowe zatwierdzenie lub edycja przez użytkownika
   - obsługa błędów AI: komunikat o błędzie, opcja ponowienia, automatyczne przełączenie do trybu manualnego
2. Manualne tworzenie fiszek
   - formularz do definiowania pytania i odpowiedzi
3. Przeglądanie i zarządzanie fiszkami
   - lista fiszek z możliwością filtrowania i wyszukiwania (tekstowe)
   - edycja treści pojedynczej fiszki
   - usuwanie pojedynczej fiszki z potwierdzeniem
4. System kont użytkowników
   - logowanie i rejestracja przez OAuth (Google, Facebook, itp.)
   - ochrona zasobów: dostęp do fiszek własnego konta
5. Integracja z algorytmem powtórek
   - wyzwalanie sesji powtórkowej dla istniejących fiszek
   - zapis historii powtórek (data, wynik)

## 4. Granice produktu

- brak własnego, zaawansowanego algorytmu powtórek (korzystamy z zewnętrznego rozwiązania)
- brak importu plików w formatach PDF, DOCX i innych
- brak dzielenia się zestawami fiszek między użytkownikami
- brak integracji z platformami edukacyjnymi
- brak aplikacji mobilnych, tylko wersja webowa

## 5. Historyjki użytkowników

US-001
Tytuł: Logowanie przez OAuth
Opis: Student loguje się do aplikacji używając swojego konta Google lub Facebook.
Kryteria akceptacji:
- student może wybrać dostawcę OAuth
- po udanej autoryzacji widzi swój pulpit z listą fiszek
- przy błędzie logowania wyświetlany jest komunikat i opcja ponowienia

US-002
Tytuł: Generowanie fiszek przez AI
Opis: Student wkleja tekst do 255 znaków i inicjuje generowanie fiszek przez AI.
Kryteria akceptacji:
- wejście dłuższe niż 255 znaków blokowane z komunikatem
- po wysłaniu tekstu AI generuje zestaw fiszek w ciągu maksymalnie 2 sekund
- student może zatwierdzić lub edytować wygenerowane fiszki

US-003
Tytuł: Obsługa błędów generowania AI
Opis: Jeśli generowanie fiszek przez AI zakończy się niepowodzeniem, student otrzymuje informację i może spróbować ponownie lub przełączyć się na tryb manualny.
Kryteria akceptacji:
- w przypadku błędu AI wyświetlany jest przyjazny komunikat
- dostępne są przyciski: ponów generowanie, przejdź do tworzenia manualnego

US-004
Tytuł: Manualne tworzenie fiszki
Opis: Student definiuje pytanie i odpowiedź dla nowej fiszki.
Kryteria akceptacji:
- formularz zawiera pola pytanie i odpowiedź
- oba pola są obowiązkowe, w przeciwnym razie formularz nie może zostać wysłany
- po zatwierdzeniu fiszka zostaje zapisana i pojawia się w liście

US-005
Tytuł: Przeglądanie listy fiszek
Opis: Student przegląda wszystkie swoje fiszki w formie listy.
Kryteria akceptacji:
- lista wyświetla tytuł pytania i datę utworzenia
- możliwość wyszukiwania fiszek po treści pytania
- brak fiszek wyświetla komunikat zachęcający do tworzenia nowych

US-006
Tytuł: Edycja fiszki
Opis: Student edytuje treść pytania lub odpowiedzi istniejącej fiszki.
Kryteria akceptacji:
- formularz edycyjny prewypełniony istniejącymi danymi
- po zapisaniu zmiany są widoczne na liście
- walidacja pól jak w tworzeniu manualnym

US-007
Tytuł: Usuwanie fiszki
Opis: Student usuwa wybraną fiszkę.
Kryteria akceptacji:
- przed usunięciem wyświetla się okno potwierdzenia
- po zatwierdzeniu fiszka zostaje trwale usunięta
- widok listy aktualizuje się automatycznie

US-008
Tytuł: Rozpoczęcie sesji powtórkowej
Opis: Student inicjuje sesję powtórkową dla swoich fiszek.
Kryteria akceptacji:
- student wybiera zestaw fiszek lub wszystkie
- sesja uruchamia się przy użyciu istniejącego algorytmu
- na koniec sesji wyświetlane są statystyki wyników

US-009
Tytuł: Bezpieczny dostęp do zasobów
Opis: Niezalogowany użytkownik nie może uzyskać dostępu do panelu fiszek.
Kryteria akceptacji:
- przy próbie wejścia na chronioną stronę następuje przekierowanie do logowania
- po wylogowaniu dostęp ponownie wymaga autoryzacji

US-010
Tytuł: Wylogowanie
Opis: Student wylogowuje się z aplikacji.
Kryteria akceptacji:
- po kliknięciu "Wyloguj" token uwierzytelniający jest unieważniany
- użytkownik zostaje przekierowany na stronę logowania

## 6. Metryki sukcesu

- 75% fiszek generowanych przez AI zostaje zaakceptowane przez użytkowników
- 75% wszystkich utworzonych fiszek powstaje z wykorzystaniem AI
- średni czas generowania fiszek ≤ 2 sekund
- dostępność usługi ≥ 99%
- odsetek błędów generowania AI ≤ 5%
- wskaźnik porzuconych sesji generowania fiszek < 10%
- retencja użytkowników na poziomie ≥ 60% po 30 dniach 