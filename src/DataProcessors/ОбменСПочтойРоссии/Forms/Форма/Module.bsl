
&НаСервере
Функция ПолучитьКвитанцию(Документ)
	обр=ДанныеФормыВЗначение(Объект,Тип("ОбработкаОбъект.ОбменСПочтойРоссии"));
	Возврат обр.ОбменССайтомКвитанция(Документ) ;
КонецФункции

&НаКлиенте
Процедура Команда1(Команда)
	СсылкаНаКвитанцию=ПолучитьКвитанцию(Документ);
	Если СсылкаНаКвитанцию<>Неопределено Тогда
		ЗапуститьПриложение(СсылкаНаКвитанцию);
	КонецЕсли;
КонецПроцедуры


