﻿ИЗБОРИ ЗА НАРОДНИ ПРЕДСТАВИТЕЛИ 2021

1. Относно данните
Централната избирателна комисия със съдействието на Информационно обслужване АД
 в качеството на избран изпълнител на компютърната обработка на резултатите от
изборите за Народни представители, в съответствие с Директива 2003/98/ЕО на Европейския парламент и на
 Съвета от 17 ноември 2003 г. относно повторната употреба на информация в 
обществения сектор, изменена с Директива 2013/37/ЕС на Европейския парламент и
на Съвета от 26 юни 2013 г. (обн. в официален вестник на Европейския съюз L175,
стр.1 от 27.06.2013), транспонирана в българското законодателство в Закона за
достъп до обществената информация, предоставят на интернет страницата си
www.cik.bg пълните данни от актуализираната база данни, приета с решение на ЦИК
.......................... г. в машинночетим формат заедно с метаданните им във формат,
гарантиращ оперативна съвместимост – структури са в comma-separated values (CSV) 
формат.

2. Описание на файловете
readme.txt            Настоящият файл
cik_parties.txt       Партии, коалиции от партии и независими кандидати
local_candidates.txt    Кандидатски листи на местно ниво
sections.txt          Списък със секциите и населените места
protocols.txt         Данни от основната част на секционните протоколи
votes.txt             Данни от разпределението на гласовете по партии/коалиции/ИК от секционните протоколи
preferences.txt       Данни разпределението на преференции по партии/коалиции от секционните протоколи
votes_mv.txt          Данни от записващите технически устройства за разпределение на гласовете
preferences_mv.txt    Данни от записващите технически устройства за разпределение на предпочитанията (преференциите)

3. Структура на файловете

Структура на текстовия файл cik_parties.txt
Всеки ред от файла представя една партия/коалиция, регистрирана в ЦИК, като разделителят между полетата е ;
Полета:
  1) Номер
  2) Име

Структура на текстовия файл local_parties.txt
Всеки ред от файла представя една партия/коалиция/инициативен комитет, регистрирана в РИК, като разделителят между полетата е ;
Полета:
  1) Код на РИК
  2) Наименование на Община/Кметство/Район
  3) Номер
  4) Име

Структура на текстовия файл local_candidates.txt
Всеки ред от файла представя един кандидат на партия/коалиция/инициативен комитет, регистриран в РИК, като разделителят между полетата е ;
Полета:
  1) Код на РИК
  2) Наименование на Община/Кметство/Район
  3) Номер на партия/коалиция/инициативен комитет
  4) Име на партия/коалиция/инициативен комитет
  5) Номер на кандидат в листата
  6) Име на кандидат

Структура на текстовия файл sections.txt
Всеки ред от файла представя една избирателна секция, като разделителят между полетата е ;
Полета:
  1) Пълен код на секция(код на район(2), община(2), адм. район(2), секция(3))
  2) Идентификатор на административна единица, за която се гласува в секцията
  3) Име на административна единица, за която се гласува в секцията
  4) ЕКАТТЕ на населеното място
  5) Име на Населено място, където е регистрирана секцията (за секциите извън страната - Държава, Населено място)
  6) Флаг мобилна секция
  7) Флаг корабна секция
  8) Флаг машинно гласуване

Структура на текстовия файл protocols.txt

Всеки ред от файла представя един секционен протокол, като разделителят между полетата е ;

Всяка точка от протокола е представена със стойност, съответстваща на позицията на точката от формуляра. Точките са разделени с ;

За всяка секция подредбата на точките се определя от формуляра, който се използва за конкретния вид избор
Формуляр № 1
  1) № формуляр
  2) Пълен код на секция(код на район(2), община(2), адм. район(2), секция(3));
  3) Идентификатор на административна единица, за която се отнася протокола(община, кметство, район)
  4) Серийни номера на страниците на протокола, разделени с |
  5)  А.Брой на получените бюлетините по реда на чл. 215 ИК
  6)  1.Брой на избирателите в избирателния списък при предаването му на СИК, включително и вписаните в допълнителната страница (под чертата) на избирателния списък в изборния ден
  7)  2.Брой на гласувалите избиратели според положените подписи в избирателния списък, включително и подписите в допълнителната страница (под чертата)
  8)  3.Общ брой на недействителните бюлетини по чл. 227, 228 и чл. 265, ал. 5, сгрешените бюлетини и унищожените от СИК бюлетини по други поводи (за създаване на образци за таблата пред изборното помещение и увредени механично при откъсване от кочана)
 11)  4.Брой на намерените в избирателната кутия бюлетини
 12)  5.Брой на намерените в избирателната кутия недействителни гласове (бюлетини)
 15)  6.Общ брой на намерените в избирателната кутия действителни гласове (бюлетини)
 18)6.1.Брой на действителните гласове, подадени за кандидатските листи на партии, коалиции и инициативни комитети
 21)6.2.Брой на действителните гласове с отбелязан вот в квадратчето „Не подкрепям никого“
 22) 7.1Общ брой на действителните гласове, подадени за кандидатските листи на партии, коалиции и инициативни комитети


Формуляр № 7
  1) № формуляр
  2) Пълен код на секция(код на район(2), община(2), адм. район(2), секция(3));
  3) Идентификатор на административна единица, за която се отнася протокола(община, кметство, район)
  4) Серийни номера на страниците на протокола, разделени с |
  5)  А.Брой на получените бюлетините по реда на чл. 215 ИК
  6)  1.Брой на избирателите в списъка за гласуване извън страната при предаването му на СИК, включително и вписаните в допълнителната страница (под чертата) на списъка в изборния ден
  7)  2.Брой на гласувалите избиратели според положените подписи в списъка за гласуване извън страната, включително и подписите в допълнителната страница (под чертата)
  8)  3.Общ брой на недействителните бюлетини по чл. 227, 228 и чл. 265, ал. 5, сгрешените бюлетини и унищожените от СИК бюлетини по други поводи (за създаване на образци за таблата пред изборното помещение и увредени механично при откъсване от кочана)
 11)  4.Брой на намерените в избирателната кутия бюлетини
 12)  5.Брой на намерените в избирателната кутия недействителни гласове (бюлетини)
 15)  6.Общ брой на намерените в избирателната кутия действителни гласове (бюлетини)
 18)6.1.Брой на действителните гласове, подадени за кандидатските листи на партии и коалиции
 21)6.2.Брой на действителните гласове с отбелязан вот в квадратчето „Не подкрепям никого“
 22) 7.1Общ брой на действителните гласове, подадени за кандидатските листи на партии и коалиции


Формуляр № 8
  1) № формуляр
  2) Пълен код на секция(код на район(2), община(2), адм. район(2), секция(3));
  3) Идентификатор на административна единица, за която се отнася протокола(община, кметство, район)
  4) Серийни номера на страниците на протокола, разделени с |
  5)  А.Брой на получените бюлетините по реда на чл. 215 ИК
  6)  1.Брой на избирателите в избирателния списък при предаването му на СИК, включително и вписаните в допълнителната страница (под чертата) на избирателния списък в изборния ден
  7)  2.Брой на гласувалите избиратели според положените подписи в избирателния списък, включително и подписите в допълнителната страница (под чертата)
  8)  3.Общ брой на недействителните бюлетини по чл. 227, 228 и чл. 265, ал. 5, сгрешените бюлетини и унищожените от СИК бюлетини по други поводи (за създаване на образци за таблата пред изборното помещение и увредени механично при откъсване от кочана)
  9) 4а.Брой на намерените в избирателната кутия бюлетини
 10) 4б.Брой на участвалите в машинното гласуване
 11)  4.Общ брой на намерените в избирателната кутия бюлетини и на участвалите в машинното гласуване
 12)  5.Брой на намерените в избирателната кутия недействителни гласове (бюлетини)
 13) 6а.Общ брой на намерените в избирателната кутия действителни гласове (бюлетини)
 14) 6б.Общ брой на действителните гласове от машинното гласуване
 15)  6.Общ брой на всички действителни гласове
 16)6.1аБрой на намерените в избирателната кутия действителни гласове, подадени за кандидатските листи на партии, коалиции и инициативни комитети
 17)6.1бБрой на действителните гласове за кандидатските листи от машинното гласуване
 18)6.1.Общ брой на действителните гласове, подадени за кандидатските листи на партии, коалиции и инициативни комитети
 19)6.2аБрой на намерените в избирателната кутия действителни гласове с отбелязан вот в квадратчето „Не подкрепям никого“
 20)6.2бБрой гласували за „Не подкрепям никого“ от машинното гласуване
 21)6.2.Общ брой на действителните гласове с отбелязан вот „Не подкрепям никого“
 22) 7.1Общ брой на действителните гласове, подадени за кандидатските листи на партии, коалиции и инициативни комитети


Формуляр № 14
  1) № формуляр
  2) Пълен код на секция(код на район(2), община(2), адм. район(2), секция(3));
  3) Идентификатор на административна единица, за която се отнася протокола(община, кметство, район)
 10)  -.Участвали в машинно гласуване
 20)  -.Гласували  за „не подкрепям никого“
 22)  -.Действителни гласове по кандидатски листи - общо

Структура на текстовия файл votes.txt и votes_mv.txt

Всеки ред от файла представя действителните гласове от един секционен протокол, като разделителят между полетата е ;

Полета:
  1) Пълен код на секция(код на район(2), община(2), адм. район(2), секция(3));
  2) Идентификатор на административна единица, за която се отнася протокола(община, кметство, район)
Следват гласовете за всяка партия, коалиция, инициативен комитет, според съответната номенклатура (в ЦИК или РИК), като данните са в последователност № П/К/ИК;действителни гласове;действителни гласове от бюлетини;действителни гласове от машинно гласуване.

Структура на текстовия файл preferences.txt и preferences_mv.txt
Всеки ред от файла представя броя предпочитания за един кандидат в един секционен протокол, като разделителят между полетата е ;
Полета:
  1) Пълен код на секция(код на район(2), община(2), адм. район(2), секция(3))
  2) Номер на партия
  3) Номер на кандидат в кандидатска листа
  4) Брой гласове
  5) Брой гласове от бюлетини
  6) Брой гласове от машинно гласуване

Структура на текстовия файл preferencesList.txt и preferencesList_mv.txt
Всеки ред от файла представя броя предпочитания за всички кандидати в един секционен протокол, като разделителят между полетата е ;
Полета:
  1) Пълен код на секция(код на район(2), община(2), адм. район(2), секция(3))
Следват предпочитанията, подадени за кандидати на партия/коалиция (П/К), според съответната номенклатура (в ЦИК или РИК), като данните са в последователност № П/К;поле Без предпочитания за П/К;стойност на поле Без предпочитания;пореден номер на кандидат от листата на П/К, до изчерпване на листата от кандидати за съответната партия;предпочитания за съответния кандидат от бюлетини;предпочитания за съответния кандидат от машинно гласуване;общ брой предпочитания за съответния кандидат;поле Общо;стойност на поле Общ брой предпочитания за П/К



