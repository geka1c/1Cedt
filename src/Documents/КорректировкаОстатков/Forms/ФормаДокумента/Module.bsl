
&НаКлиенте
Процедура Заполнить(Команда)

	 ПолучитьОтрицательныеОстатки();
	
КонецПроцедуры


&НаСервере
Процедура  ПолучитьОтрицательныеОстатки()

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОстаткиТоваровОстатки.Габарит,
		|	ОстаткиТоваровОстатки.Участник,
		|	ОстаткиТоваровОстатки.МестоХранения,
		|	ОстаткиТоваровОстатки.Покупка,
		|	ОстаткиТоваровОстатки.Партия,
		|	ОстаткиТоваровОстатки.Оплачен,
		|	ОстаткиТоваровОстатки.Потерян,
		|	ОстаткиТоваровОстатки.КоличествоОстаток,
		|	Покупки.Наименование КАК ПокупкаСпр
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров.Остатки(&наДату, ) КАК ОстаткиТоваровОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Покупки КАК Покупки
		|		ПО ОстаткиТоваровОстатки.Покупка = Покупки.Код
		|ГДЕ
		|	ОстаткиТоваровОстатки.КоличествоОстаток < 0";
	Запрос.Параметры.Вставить("наДату",КонецДня(Объект.Дата));
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрПокупки= Объект.Покупки.Добавить();
		СтрПокупки.Участник =  ВыборкаДетальныеЗаписи.Участник;
		СтрПокупки.Покупка =  ВыборкаДетальныеЗаписи.Покупка;
		СтрПокупки.Оплачен =  ВыборкаДетальныеЗаписи.Оплачен;
		СтрПокупки.МестоХранения =  ВыборкаДетальныеЗаписи.МестоХранения;
		СтрПокупки.Габарит =  ВыборкаДетальныеЗаписи.Габарит;
		СтрПокупки.ПокупкаСпр =  ВыборкаДетальныеЗаписи.ПокупкаСпр;
		СтрПокупки.Партия =  ВыборкаДетальныеЗаписи.Партия;
		СтрПокупки.Потерян =  ВыборкаДетальныеЗаписи.Потерян;
		СтрПокупки.Количество =  ВыборкаДетальныеЗаписи.КоличествоОстаток;
		
	КонецЦикла;


	
	
КонецПроцедуры



&НаСервере
Процедура  ПолучитьКоректировкуПокупок()
	

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОстаткиТоваровОстатки.Габарит,
		|	ОстаткиТоваровОстатки.Участник,
		|	ОстаткиТоваровОстатки.МестоХранения,
		|	ОстаткиТоваровОстатки.Покупка,
		|	ОстаткиТоваровОстатки.Партия,
		|	ОстаткиТоваровОстатки.Оплачен,
		|	ОстаткиТоваровОстатки.Потерян,
		|	ОстаткиТоваровОстатки.КоличествоОстаток как Количество,
		|	Покупки.Наименование КАК ПокупкаСпр,
		|	Покупки.Ссылка КАК ПокупкаСсылка
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров.Остатки(&наДату, ТИПЗНАЧЕНИЯ(Покупка) = ТИП(ЧИСЛО)) КАК ОстаткиТоваровОстатки
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Покупки КАК Покупки
		|		ПО ОстаткиТоваровОстатки.Покупка = Покупки.Код";
	Запрос.Параметры.Вставить("наДату",КонецДня(Объект.Дата));
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		СтрПокупки= Объект.Покупки.Добавить();
		ЗаполнитьЗначенияСвойств(СтрПокупки,ВыборкаДетальныеЗаписи);
		
		
		СтрПокупки= Объект.Покупки.Добавить();
		ЗаполнитьЗначенияСвойств(СтрПокупки,ВыборкаДетальныеЗаписи);
		СтрПокупки.Покупка=ВыборкаДетальныеЗаписи.ПокупкаСсылка;
		СтрПокупки.Количество=ВыборкаДетальныеЗаписи.Количество*-1;
	КонецЦикла;
КонецПроцедуры


&НаКлиенте
Процедура КоректировкаПокупок(Команда)
	ПолучитьКоректировкуПокупок()

КонецПроцедуры


&НаСервере
Процедура ЗаполнитьТранзитыНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТранзитОстатки.Габарит,
		|	ТранзитОстатки.Участник,
		|	ТранзитОстатки.МестоХранения,
		|	ТранзитОстатки.Партия,
		|	ТранзитОстатки.ПокупкаСсылка,
		|	ТранзитОстатки.Точка,
		|	ТранзитОстатки.КоличествоОстаток КАК Количество
		|ИЗ
		|	РегистрНакопления.Транзит.Остатки(&наДату, ) КАК ТранзитОстатки
		|ГДЕ
		|	ТранзитОстатки.КоличествоОстаток < 0";
	Запрос.Параметры.Вставить("наДату",КонецДня(Объект.Дата));
	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		стрТР=Объект.Транзиты.Добавить();
		ЗаполнитьЗначенияСвойств(стрТР,ВыборкаДетальныеЗаписи);		
	КонецЦикла;
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьТранзиты(Команда)
	ЗаполнитьТранзитыНаСервере();
КонецПроцедуры
	