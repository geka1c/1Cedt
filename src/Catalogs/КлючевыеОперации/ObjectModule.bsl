#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	ПроверитьПриоритет(Отказ);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ХешMD5 = Новый ХешированиеДанных(ХешФункция.MD5);
	ХешMD5.Добавить(Имя);
	ИмяХешТемп = ХешMD5.ХешСумма;
	ИмяХеш = СтрЗаменить(Строка(ИмяХешТемп), " ", "");
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьПриоритет(Отказ)
	
	Если ДополнительныеСвойства.Свойство(ОценкаПроизводительностиКлиентСервер.НеПроверятьПриоритет()) Или Приоритет = 0 Тогда
		Возврат;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Приоритет", Приоритет);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	КлючевыеОперации.Ссылка КАК Ссылка,
	|	КлючевыеОперации.Наименование КАК Наименование
	|ИЗ
	|	Справочник.КлючевыеОперации КАК КлючевыеОперации
	|ГДЕ
	|	КлючевыеОперации.Приоритет = &Приоритет
	|	И КлючевыеОперации.Ссылка <> &Ссылка";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		ТекстСообщения = НСтр("ru = 'Ключевая операция с приоритетом ""%1"" уже существует (%2).'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%1", Строка(Приоритет));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%2", Выборка.Наименование);
		ОценкаПроизводительностиКлиентСервер.ЗаписатьВЖурналРегистрации(
			"Справочник.КлючевыеОперации.МодульОбъекта.ПередЗаписью",
			УровеньЖурналаРегистрации.Ошибка,
			ТекстСообщения);
		ОценкаПроизводительностиКлиентСервер.СообщитьПользователю(ТекстСообщения);
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли