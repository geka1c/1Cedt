



&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ТипЗнч(Параметры.ОбъектыПечати) = Тип("Массив") Тогда
		Организаторы.Загрузить(СтоСП_Печать.ПолучитьОрганизаторовВЧекеПоступления(Параметры.ОбъектыПечати));
	КонецЕсли	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	массивОрганизаторов = новый Массив;
	Для каждого элем из Организаторы Цикл
		Если не элем.Подбор тогда продолжить; КонецЕсли;
		массивОрганизаторов.Добавить(элем.Организатор);
	КонецЦикла;
	Закрыть(массивОрганизаторов);
КонецПроцедуры


