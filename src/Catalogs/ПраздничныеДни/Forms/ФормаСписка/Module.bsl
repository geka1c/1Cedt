
&НаКлиенте
Процедура Заполнить(Команда)
	ДобавитьВыходныеДни(Год, Месяц, ДеньНедели);
	ОбновитьИнтерфейс();
КонецПроцедуры



&НаСервере
Процедура ДобавитьВыходныеДни(Год, Месяц, ДеньНедели)
	СпрПраздничныеДни=Справочники.ПраздничныеДни;
	ИндексДата=КонецМесяца(Дата(Год,Месяц,1));

	Пока  Месяц=Месяц(ИндексДата) Цикл
		
		ВыходнойДень=СпрПраздничныеДни.СоздатьЭлемент();
		ВыходнойДень.Наименование="Выходной день";
		ВыходнойДень.Дата=НачалоНедели(ИндексДата)+86400*(ДеньНедели-1);
		
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПраздничныеДни.Дата
			|ИЗ
			|	Справочник.ПраздничныеДни КАК ПраздничныеДни
			|ГДЕ
			|	ПраздничныеДни.Дата = &ДатаТек";

		Запрос.УстановитьПараметр("ДатаТек", ВыходнойДень.Дата);

		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();
        запись=истина;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Сообщить("Элемент на дату "+ВыходнойДень.Дата+"Уже добавлен");
			запись=ложь;
		КонецЦикла;
		Если  Месяц(НачалоНедели(ИндексДата)+86400*ДеньНедели)<>Месяц Тогда
			запись=ложь;
		КонецЕсли;	
		Если запись Тогда
			ВыходнойДень.Записать();	
		КонецЕсли;
		ИндексДата=НачалоНедели(ИндексДата)-1;
	КонецЦикла;

КонецПроцедуры // ДобавитьВыходныеДни()


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Год=Год(ТекущаяДата());
	Месяц=Месяц(ТекущаяДата());
	ДеньНедели=7;
КонецПроцедуры
 
