
Процедура ПередЗаписью(Отказ)
	
	Взвешено=ЗначениеЗаполнено(ОтправлениеТранзита) и (
				ОтправлениеТранзита.СтоимостьДоставки>0 или
				ОтправлениеТранзита.СтоимостьДоставкиПредоплата>0 );
				
	Если ВидСтикера = Перечисления.ВидыСтикеров.ГруппаДоставки Тогда
		исключенныеЗаказы 		= Состав.НайтиСтроки(новый Структура("Исключить",истина));
		удаленныеЗаказы 		= Состав.НайтиСтроки(новый Структура("Удалить",истина));
		Количество 			= Состав.Количество() - исключенныеЗаказы.Количество() - удаленныеЗаказы.Количество();
		НеобходимоИсключить	= (исключенныеЗаказы.Количество()>0);	
		НеобходимоУдалить	= (удаленныеЗаказы.Количество()>0);			
	КонецЕсли;
	
#Область ЗаполнитьИтоговоеКоличествоПоОрганизаторам	
	таблицаОрганизаторов=новый ТаблицаЗначений;
	таблицаОрганизаторов.Колонки.Добавить("Организатор",новый ОписаниеТипов("СправочникСсылка.Участники"));
	таблицаОрганизаторов.Колонки.Добавить("Количество", новый ОписаниеТипов("Число"));
	Для каждого стр из Состав Цикл
		строка_итогов = таблицаОрганизаторов.Добавить();
		Если ТипЗнч(стр.Покупка)<>Тип("СправочникСсылка.Пристрой") Тогда
			строка_итогов.Организатор 	= стр.Покупка.Организатор;
		КонецЕсли;
		строка_итогов.количество 	= 1;
	КонецЦикла;
	таблицаОрганизаторов.Свернуть("Организатор","Количество");
	
	Для каждого стр из таблицаОрганизаторов Цикл
		МассивОргов	= Организаторы.НайтиСтроки(новый структура("Организатор", стр.Организатор));
		Если МассивОргов.Количество()=0 Тогда
			новаяСтрока				= Организаторы.Добавить();	
			новаяСтрока.Организатор	= стр.Организатор;
			новаяСтрока.Количество	= стр.Количество;
		Иначе	
			МассивОргов[0].Организатор 	= стр.Организатор;
			МассивОргов[0].Количество	= стр.Количество;
		КонецЕсли;	
	КонецЦикла;
#КонецОбласти
КонецПроцедуры


Процедура ПриЗаписи(Отказ)
	Если ПометкаУдаления и 
		 ВидСтикера=Перечисления.ВидыСтикеров.ГруппаДоставки и 
		 ЗначениеЗаполнено(ОтправлениеТранзита) Тогда
		 
		 об_ОТ=ОтправлениеТранзита.ПолучитьОбъект();
		 об_ОТ.УстановитьПометкуУдаления(Истина);
		
	КонецЕсли;
	// Вставить содержимое обработчика.
КонецПроцедуры
