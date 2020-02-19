#Область ШтрихКоды

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	    
	Если 	ИмяСобытия 	= "ScanData" и
			Источник 	= "ПодключаемоеОборудование" и
			ВводДоступен()									Тогда
			
			ШК = СтоСП_Клиент.ПолучитьШКизПараметров(Параметр);
			ОбработатьШКнаКлиенте(ШК);
	КонецЕсли;

КонецПроцедуры


&НаКлиенте
Процедура ОбработатьШКнаКлиенте(ШК)
	ДанныеШК    = СП_Штрихкоды.ПолучитьДанныеПоШК(ШК);
	Если Строка(ДанныеШК.Тип) = "Посылка (12)" 					Тогда
		Если Элементы.ГруппаТабЧасти.ТекущаяСтраница=Элементы.ГруппаТабЧасти.ПодчиненныеЭлементы.тчСклад Тогда
			ВыборкаОстатков(,ДанныеШК.заказ);
		КонецЕсли;		
	ИначеЕсли Строка(ДанныеШК.Тип) = "Покупка (11)" или 
			  Строка(ДанныеШК.Тип) = "Заказ100маркета (33)"      Тогда   //11043940487532000904	
		Если Элементы.ГруппаТабЧасти.ТекущаяСтраница=Элементы.ГруппаТабЧасти.ПодчиненныеЭлементы.тчСклад Тогда
			ВыборкаОстатков(ДанныеШК.Участник,ДанныеШК.заказ);
		КонецЕсли;		
	Иначеесли Строка(ДанныеШК.Тип) = "Сотрудник (55)" 			Тогда	
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(этотОбъект,,ДанныеШК.Сотрудник) Тогда
			Закрыть();
		КонецЕсли;	
	КонецЕсли;
	Модифицированность			= Истина;
	УстановитьВидимость();
КонецПроцедуры	


&НаКлиенте
Процедура ВвестиШтрихКодВручную(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаВводаШК",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ВвестиШтрихКодВручную_Завершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ВвестиШтрихКодВручную_Завершение(ШК, ДополнительныеПараметры) Экспорт
	ОбработатьШКнаКлиенте(ШК);
КонецПроцедуры	


#КонецОбласти


#Область Команды

&НаКлиенте
Процедура ЗаполнитьПоОтбору(Команда)
	фрм=ПолучитьФорму("Документ.Движение.Форма.ФормаОтбора",новый Структура("имяСхемы","СКДОтборТовары"),ЭтаФорма);
	фрм.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТранзитПоОтбору(Команда)
	фрм=ПолучитьФорму("Документ.Движение.Форма.ФормаОтбора",новый Структура("имяСхемы","СКДОтборТранзиты"),ЭтаФорма);
	фрм.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура Добавить(Команда)
		Если Строка(фМестоХранения)= "" тогда
#Если не ВебКлиент Тогда			
		Сигнал();
#КонецЕсли		
		
		Сообщить("Зачем добавлять пустую строку?");
		Возврат;
	конецЕсли;	
	Если ПроверкаСписка(фМестоХранения) Тогда
#Если не ВебКлиент Тогда		
		Сигнал();
#КонецЕсли
		
		Сообщить("Этот элемент уже присутствует в списке!!!");
		Возврат;
	
	КонецЕсли;
	фМестаХранения.Добавить(фМестоХранения);
	// Вставить содержимое обработчика.

	// Вставить содержимое обработчика.
КонецПроцедуры

#КонецОбласти

#Область СтарыйОтбор
&НаКлиенте
Процедура Заполнить(Команда)
	Объект.Покупки.Очистить();
	ВыборкаОстатков();	
КонецПроцедуры

&НаКлиенте
Функция ПроверкаСписка(МестоХранения)
    Для н=0 По фМестаХранения.Количество()-1 Цикл
		Если фМестаХранения.Получить(н).Значение=МестоХранения Тогда
			Возврат Истина
		КонецЕсли
	КонецЦикла;
	Возврат Ложь

КонецФункции // ПроверкаСписка()

&НаСервере
Процедура ВыборкаОстатков(Участник = Неопределено, Заказ = неопределено)
	
	ПервоеУсловие	= Истина;
	ТекстУсловия	= "";
	
	Если ЗначениеЗаполнено(фОрганизатор) Тогда
		ТекстУсловия	= ТекстУсловия + " и (Партия.Организатор = &Организатор) ";
	КонецЕсли;
	Если ЗначениеЗаполнено(фМестаХранения) Тогда
		ТекстУсловия	= ТекстУсловия + " и (МестоХранения В (&МестаХранения)) ";
	КонецЕсли;
	Если ЗначениеЗаполнено(Участник) или ЗначениеЗаполнено(фУчастник) Тогда
		ТекстУсловия	= ТекстУсловия + " и (Участник = &Участник) ";
	КонецЕсли;
	Если ЗначениеЗаполнено(Заказ) или ЗначениеЗаполнено(фПокупка) Тогда
		ТекстУсловия	= ТекстУсловия + " и (Покупка = &Покупка) ";
	КонецЕсли;
	Если ЗначениеЗаполнено(фПотерян) Тогда
		ТекстУсловия	= ТекстУсловия + " и (Потерян = &Потерян) ";
	КонецЕсли;
	Если ЗначениеЗаполнено(фПартия) Тогда
		ТекстУсловия	= ТекстУсловия + " и (Партия = &Партия) ";
	КонецЕсли;
	
	Если СтрНачинаетсяС(ТекстУсловия, " и ") Тогда
		ТекстУсловия = Сред(ТекстУсловия,3,СтрДлина(ТекстУсловия)-2);
	КонецЕсли;
	
    ДатаЕ=КонецДня(Объект.Дата);
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОстаткиТоваровОстатки.Габарит,
		|	ПРЕДСТАВЛЕНИЕ(ОстаткиТоваровОстатки.Габарит),
		|	ОстаткиТоваровОстатки.Участник КАК Участник,
		|	ПРЕДСТАВЛЕНИЕ(ОстаткиТоваровОстатки.Участник),
		|	ОстаткиТоваровОстатки.МестоХранения КАК МестоХранения,
		|	ПРЕДСТАВЛЕНИЕ(ОстаткиТоваровОстатки.МестоХранения),
		|	ОстаткиТоваровОстатки.Покупка КАК Покупка,
		|	ОстаткиТоваровОстатки.Партия,
		|	ПРЕДСТАВЛЕНИЕ(ОстаткиТоваровОстатки.Партия),
		|	ОстаткиТоваровОстатки.Оплачен,
		|	ОстаткиТоваровОстатки.Потерян КАК Потерян,
		|	ОстаткиТоваровОстатки.КоличествоОстаток КАК количество,
		|	ОстаткиТоваровОстатки.Партия.Организатор КАК Организатор
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров.Остатки(
		|			,
		| "+ТекстУсловия+" ) КАК ОстаткиТоваровОстатки
		|
		|УПОРЯДОЧИТЬ ПО
		|	Потерян,
		|	МестоХранения,
		|	Участник,
		|	Покупка";
  //  Запрос.УстановитьПараметр("ДатаЕ", ДатаЕ);
	Запрос.УстановитьПараметр("МестаХранения", 	фМестаХранения);  
	Запрос.УстановитьПараметр("Организатор",	фОрганизатор) ;
	Запрос.УстановитьПараметр("Партия", 		фПартия);
	Запрос.УстановитьПараметр("Покупка", 		?(ЗначениеЗаполнено(Заказ), 	Заказ, 		фПокупка));
	Запрос.УстановитьПараметр("Потерян", 		фПотерян);
	Запрос.УстановитьПараметр("Участник", 		?(ЗначениеЗаполнено(Участник), 	Участник, 	фУчастник));

	Результат = Запрос.Выполнить();

	Выборка = Результат.Выбрать();

	Пока Выборка.Следующий() Цикл
			строкТЧ					= Объект.Покупки.Добавить();
			строкТЧ.Потерян			= Выборка.Потерян;
		    строкТЧ.Покупка			= Выборка.Покупка;
			Если ТипЗнч(строкТЧ.Покупка)= Тип("СправочникСсылка.Покупки") Тогда
				Объект.Организатор = СП_РаботаСоСправочниками.ПолучитьОрганизатораПо_Коду(строкТЧ.Покупка.Владелец.Код);
			ИначеЕсли ТипЗнч(строкТЧ.Покупка) = Тип("СправочникСсылка.Заказы") Тогда
				Объект.Организатор = строкТЧ.Покупка.Организатор;
			Иначе
				Объект.Организатор = Справочники.Организаторы.ПустаяСсылка();
			КонецЕсли;

			
			строкТЧ.Оплачен			= Выборка.Оплачен;
			строкТЧ.МестоХранения	= Выборка.МестоХранения;
			строкТЧ.Габарит			= Выборка.Габарит;
			строкТЧ.Количество      = Выборка.Количество;
			строкТЧ.Партия  		= Выборка.Партия;
			строкТЧ.Участник  		= Выборка.Участник;
		
	КонецЦикла;


	
	
	
КонецПроцедуры // Печать()


Процедура ЗаполнитьПросроченнымиНаСервере()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОстаткиТоваровОстатки.Партия.Дата,
		|	ОстаткиТоваровОстатки.Участник,
		|	ОстаткиТоваровОстатки.МестоХранения КАК МестоХранения,
		|	ОстаткиТоваровОстатки.Оплачен КАК Оплачен,
		|	ОстаткиТоваровОстатки.Потерян КАК Потерян,
		|	ОстаткиТоваровОстатки.Габарит КАК Габарит,
		|	&ДатаОтчета КАК ДатаОтчета,
		|	1 КАК Количество,
		|	РАЗНОСТЬДАТ(ОстаткиТоваровОстатки.Партия.Дата, &ДатаОтчета, ДЕНЬ) КАК ДниПросрочки,
		|	ОстаткиТоваровОстатки.Покупка.Наименование КАК ПокупкаНаименование,
		|	ВЫБОР
		|		КОГДА РАЗНОСТЬДАТ(ОстаткиТоваровОстатки.Партия.Дата, &ДатаОтчета, ДЕНЬ) - ОстаткиТоваровОстатки.Габарит.ДниХранения > 0
		|			ТОГДА ОстаткиТоваровОстатки.Габарит.СтоимостьХранения + (РАЗНОСТЬДАТ(ОстаткиТоваровОстатки.Партия.Дата, &ДатаОтчета, ДЕНЬ) - ОстаткиТоваровОстатки.Габарит.ДниХранения) * ОстаткиТоваровОстатки.Габарит.ДобавочнаяСтоимость
		|		ИНАЧЕ ОстаткиТоваровОстатки.Габарит.СтоимостьХранения
		|	КОНЕЦ КАК СтоимостьХранения,
		|	ОстаткиТоваровОстатки.Партия КАК партия,
		|	ОстаткиТоваровОстатки.Покупка.Ссылка КАК Покупка
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров.Остатки(, "+?(фИспользоватьМХ," МестоХранения = &МестоХранения "," ")+") КАК ОстаткиТоваровОстатки
		|ГДЕ
		|	РАЗНОСТЬДАТ(ОстаткиТоваровОстатки.Партия.Дата, &ДатаОтчета, ДЕНЬ) > &ДнейПросрочки
		|
		|УПОРЯДОЧИТЬ ПО
		|	МестоХранения";

	Запрос.УстановитьПараметр("ДатаОтчета", Объект.Дата);
	Запрос.УстановитьПараметр("ДнейПросрочки", ДнейПросрочки);
	Запрос.УстановитьПараметр("МестоХранения", фМестоХранения);


	Результат = Запрос.Выполнить();


	Объект.Покупки.Загрузить(Результат.Выгрузить());
КонецПроцедуры	

&НаКлиенте
Процедура ЗаполнитьПросроченными(Команда)
	ЗаполнитьПросроченнымиНаСервере();
	ОбновитьОтображениеДанных();
КонецПроцедуры

&НаКлиенте
Процедура фИспользоватьМХПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

#КонецОбласти

#Область СобытияФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
 // СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
 ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтотОбъект);
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Сканер штрихкода
   СтоСП_Клиент.ПодключитьСканерШК(УникальныйИдентификатор);
	
	УстановитьВидимость();
КонецПроцедуры

/////////////////////

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ОбработкаВыбораНаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаСервере
Процедура ОбработкаВыбораНаСервере(ВыбранноеЗначение)
	КомпоновщикНастроек=ВыбранноеЗначение.КомпоновщикНастроек;
	Схема=ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресСхемы);
	
	настройки=КомпоновщикНастроек.Настройки;
	параметрПериод=настройки.ПараметрыДанных.НайтиЗначениеПараметра(новый ПараметрКомпоновкиДанных("ДатаОтчета"));
	параметрПериод.Значение=КонецДня(Объект.Дата);
	параметрПериод.Использование=Истина;
	
	КомпановщикМакета=Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет=КомпановщикМакета.Выполнить(Схема,КомпоновщикНастроек.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки= новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет);
	ПроцессорВывода=новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	ТЗ=новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ТЗ);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки,Истина);
	Если   Объект.ТипДвижения  =Перечисления.ТипыДвиженияПокупок.СписаниеТранзита Тогда
		Объект.ПокупкиТранзит.Загрузить(ТЗ);
	Иначе
		Объект.Покупки.Загрузить(ТЗ);
	КонецЕсли	
КонецПроцедуры


&НаКлиенте
Процедура ТипДвиженияПриИзменении(Элемент)
	УстановитьВидимость();		
КонецПроцедуры

#КонецОбласти


Процедура УстановитьВидимость()
	Элементы.ГруппаНазначение.Видимость=Истина;
	Если Объект.ТипДвижения  =Перечисления.ТипыДвиженияПокупок.Перемещение или
		 Объект.ТипДвижения  =Перечисления.ТипыДвиженияПокупок.Найденные Тогда
    	Элементы.ТочкаНазначения.Видимость=Ложь;
		Элементы.Организатор.Видимость=Ложь;
		Элементы.МестоХранения.Видимость=Истина;
		Элементы.Габарит.Видимость=Истина;
	ИначеЕсли Объект.ТипДвижения  =Перечисления.ТипыДвиженияПокупок.Возврат Тогда
		Элементы.ТочкаНазначения.Видимость=Ложь;
		Элементы.Организатор.Видимость=Ложь;
		Элементы.МестоХранения.Видимость=Ложь;
		Элементы.Габарит.Видимость=Ложь;
	ИначеЕсли   Объект.ТипДвижения  =Перечисления.ТипыДвиженияПокупок.ПередачаНаТранзит Тогда
		Элементы.ТочкаНазначения.Видимость=Истина;
		Элементы.Организатор.Видимость=Ложь;
		Элементы.МестоХранения.Видимость=Истина;
		Элементы.Габарит.Видимость=Истина;
	ИначеЕсли   Объект.ТипДвижения  =Перечисления.ТипыДвиженияПокупок.СписаниеТранзита Тогда
		Элементы.ГруппаНазначение.Видимость=Ложь
	Иначе	
		Элементы.ТочкаНазначения.Видимость=Ложь;
		Элементы.Организатор.Видимость=Истина;
		Элементы.МестоХранения.Видимость=Ложь;
		Элементы.Габарит.Видимость=Ложь;
		
	КонецЕсли;
	Элементы.фМестоХранения1.Видимость= фИспользоватьМХ;
	
	Если   Объект.ТипДвижения  =Перечисления.ТипыДвиженияПокупок.СписаниеТранзита или
		   Объект.ТипДвижения  =Перечисления.ТипыДвиженияПокупок.СТранзитаНаВозврат или
		   Объект.ТипДвижения  =Перечисления.ТипыДвиженияПокупок.СТранзитаНаОстатки Тогда
		   
		Элементы.ГруппаТабЧасти.ТекущаяСтраница=Элементы.ГруппаТабЧасти.ПодчиненныеЭлементы.тчТранзит;
	Иначе
		Элементы.ГруппаТабЧасти.ТекущаяСтраница=Элементы.ГруппаТабЧасти.ПодчиненныеЭлементы.тчСклад;
	КонецЕсли;	
	
КонецПроцедуры	




// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
    Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтотОбъект, Команда.Имя) Тогда
        РезультатВыполнения = Неопределено;
        ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
        ДополнительныеОтчетыИОбработкиКлиент.ПоказатьРезультатВыполненияКоманды(ЭтотОбъект, РезультатВыполнения);
    КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки



// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
    ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтотОбъект, ИмяЭлемента, РезультатВыполнения);
КонецПроцедуры

