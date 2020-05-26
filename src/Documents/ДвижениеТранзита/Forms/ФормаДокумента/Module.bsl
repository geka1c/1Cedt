Процедура УстановитьВиДимость()
	наТранзит=(Объект.ВидОперации=Перечисления.ВидыОпераций_ДвижениеТранзита.ТранзитНаТранзит);
	наВозврат=(Объект.ВидОперации=Перечисления.ВидыОпераций_ДвижениеТранзита.ТранзитНаВозврат);
	наОстаток=(Объект.ВидОперации=Перечисления.ВидыОпераций_ДвижениеТранзита.ТранзитНаОстатки);
	Элементы.ПокупкиТранзитГруппаНазначение.Видимость = (наТранзит или наВозврат или наОстаток);
	Элементы.ПокупкиТранзитПунктВыдачиНазначение.Видимость   = (наТранзит);
	Элементы.ПокупкиТранзитОрганизатор.Видимость       = (наВозврат);
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	УстановитьВиДимость();
КонецПроцедуры
	

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВиДимость();
КонецПроцедуры


&НаКлиенте
Процедура ЗаполнитьПоОтбору(Команда)
	ЗаполнениеНазначения = Новый Структура;
	ЗаполнениеНазначения.Вставить("МестоХранения",  фМестоХранения);
	ЗаполнениеНазначения.Вставить("Габарит", 		фГабарит);
	ЗаполнениеНазначения.Вставить("Организатор", 	фОрганизатор);
	ЗаполнениеНазначения.Вставить("ПунктВыдачи", 	фПунктВыдачи);
	
	ОткрытьФорму("Документ.ДвижениеТранзита.Форма.ФормаОтбора",
						новый Структура("имяСхемы","СКДОтбор"),ЭтотОбъект,,,,Новый ОписаниеОповещения("ЗаполнитьПоОтбору_Завершение", ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);


КонецПроцедуры


&НаКлиенте
Процедура 	ЗаполнитьПоОтбору_Завершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	ЗаполнитьПоОтбору_Завершение_НаСервере(ВыбранноеЗначение);
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоОтбору_Завершение_НаСервере(ВыбранноеЗначение)
	КомпоновщикНастроек	= ВыбранноеЗначение.КомпоновщикНастроек;
	Схема				= ПолучитьИзВременногоХранилища(ВыбранноеЗначение.АдресСхемы);
	
	настройки						= КомпоновщикНастроек.Настройки;
	параметрПериод					= настройки.ПараметрыДанных.НайтиЗначениеПараметра(новый ПараметрКомпоновкиДанных("ДатаОтчета"));
	параметрПериод.Значение			= КонецДня(Объект.Дата);
	параметрПериод.Использование	= Истина;
	
	параметрПериод					= настройки.ПараметрыДанных.НайтиЗначениеПараметра(новый ПараметрКомпоновкиДанных("Габарит"));
	параметрПериод.Значение			= фГабарит;
	параметрПериод.Использование	= Истина;
	
	параметрПериод					= настройки.ПараметрыДанных.НайтиЗначениеПараметра(новый ПараметрКомпоновкиДанных("ПунктВыдачи"));
	параметрПериод.Значение			= фПунктВыдачи;
	параметрПериод.Использование	= Истина;
	
	параметрПериод					= настройки.ПараметрыДанных.НайтиЗначениеПараметра(новый ПараметрКомпоновкиДанных("ПунктВыдачиТранзита"));
	параметрПериод.Значение			= фПунктВыдачиТранзита;
	параметрПериод.Использование	= Истина;
	
	параметрПериод					= настройки.ПараметрыДанных.НайтиЗначениеПараметра(новый ПараметрКомпоновкиДанных("МестоХранения"));
	параметрПериод.Значение			= фМестоХранения;
	параметрПериод.Использование	= Истина;

	параметрПериод					= настройки.ПараметрыДанных.НайтиЗначениеПараметра(новый ПараметрКомпоновкиДанных("Организатор"));
	параметрПериод.Значение			= фОрганизатор;
	параметрПериод.Использование	= Истина;

	
	КомпановщикМакета			= Новый КомпоновщикМакетаКомпоновкиДанных;
	Макет						= КомпановщикМакета.Выполнить(Схема,КомпоновщикНастроек.Настройки,,,Тип("ГенераторМакетаКомпоновкиДанныхДляКоллекцииЗначений"));
	ПроцессорКомпоновки			= новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(Макет);
	
	ПроцессорВывода				= новый ПроцессорВыводаРезультатаКомпоновкиДанныхВКоллекциюЗначений;
	
	
	
	ТЗ							= новый ТаблицаЗначений;
	ПроцессорВывода.УстановитьОбъект(ТЗ);
	ПроцессорВывода.Вывести(ПроцессорКомпоновки,Истина);
	
	Объект.ПокупкиТранзит.Загрузить(ТЗ);
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если не ЗначениеЗаполнено(Объект.ВидОперации) Тогда
		Объект.ВидОперации = Перечисления.ВидыОпераций_ДвижениеТранзита.ТранзитНаВозврат;
	КонецЕсли;	
	Если Параметры.Свойство("ПараметрыЗаполнения") Тогда
 		ЗаполнитьИзПараметровЗапонения(Параметры.ПараметрыЗаполнения);
 	КонецЕсли;	
	
КонецПроцедуры

Процедура ЗаполнитьИзПараметровЗапонения(ПараметрыЗаполнения)
	
	ДокЗначение	= ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.ДвижениеТранзита"));
	ДокЗначение.ЗаполнитьПоОтбору(ПараметрыЗаполнения);
	ЗначениеВДанныеФормы(ДокЗначение, Объект);	
	
КонецПроцедуры




#Область ШтрихКоды

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// ПодключаемоеОборудование                
	Если 	ИмяСобытия 	= "ScanData" 					и
			Источник 	= "ПодключаемоеОборудование" 	и
			ВводДоступен()										Тогда
			
			ШК 			= СтоСП_Клиент.ПолучитьШКизПараметров(Параметр);
			ОбработатьШКнаКлиенте(ШК);
			
	КонецЕсли;
	// Конец ПодключаемоеОборудование
КонецПроцедуры


&НаКлиенте
Процедура ОбработатьШКнаКлиенте(ШК)
	ДанныеШК    = СП_Штрихкоды.ПолучитьДанныеПоШК(ШК);
	Если 		Строка(ДанныеШК.Тип) 	= "Посылка (12)" 			или
		 		Строка(ДанныеШК.Тип) 	= "Покупка (11)"			Или		
		 		Строка(ДанныеШК.Тип) 	= "Заказ100маркета (33)"	или
		 		Строка(ДанныеШК.Тип) 	= "Коробка (44)"					Тогда
			ЗаказДобавлен	= ДобавитьЗаказ(ДанныеШК);
			Если ЗаказДобавлен Тогда
				#Если не вебклиент Тогда
					Сигнал();
				#КонецЕсли
			КОнецЕсли;	
	ИначеЕсли 	Строка(ДанныеШК.Тип) 	= "Карта участника (22)" или
			Строка(ДанныеШК.Тип) 	= "Карта участника (23)" 		Тогда
	//	Объект.Участник = ДанныеШК.Участник;	
	ИначеЕсли Строка(ДанныеШК.Тип) = "Место хранения (63)" 		Тогда	
		фМестоХранения	= ДанныеШК.МестоХранения;
	Иначеесли Строка(ДанныеШК.Тип) 		= "Сотрудник (55)" 			Тогда	
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(этотОбъект,,ДанныеШК.Сотрудник) Тогда
			Закрыть();
		КонецЕсли;				
	КонецЕсли;		

КонецПроцедуры	

&НаКлиенте
Процедура СчитатьШКВручную(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаВводаШК",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ВвестиШтрихКодВручную_Завершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ВвестиШтрихКодВручную_Завершение(ШК, ДополнительныеПараметры) Экспорт
	Если ШК <> "" Тогда
		ОбработатьШКнаКлиенте(ШК);
	КонецЕсли;	
КонецПроцедуры	

Функция ДобавитьЗаказ(ДанныеШК)

	ТекстУсловия	= " ПокупкаСсылка = &Покупка ";
	
	указанУчастник = (ДанныеШК.Свойство("Участник") и ЗначениеЗаполнено(ДанныеШК.Участник));
	Если указанУчастник Тогда
		ТекстУсловия	= ТекстУсловия + " и Участник = &Участник ";
	КонецЕсли;
		
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ТранзитОстатки.ПокупкаСсылка как Покупка,
		|	ТранзитОстатки.МестоХранения,
		|	ТранзитОстатки.Габарит,
		|	ТранзитОстатки.Участник,
		|	ТранзитОстатки.Точка  как ПунктВыдачи,
		|	ТранзитОстатки.Партия,
		|	ТранзитОстатки.КоличествоОстаток как Количество,
		|ВЫБОР
		|	КОГДА &ГабаритНазначение = ЗНАЧЕНИЕ(Справочник.Габариты.ПустаяСсылка)
		|			или &ГабаритНазначение = неопределено
		|	ТОГДА ТранзитОстатки.Габарит
		|	ИНАЧЕ &ГабаритНазначение
		|КОНЕЦ как ГабаритНазначение,
		|
		|ВЫБОР
		|	КОГДА 		&МестоХраненияНазначение = ЗНАЧЕНИЕ(Справочник.МестаХранения.ПустаяСсылка)
		|			или &МестоХраненияНазначение = Неопределено
		|	ТОГДА ТранзитОстатки.МестоХранения
		|	ИНАЧЕ &МестоХраненияНазначение
		|КОНЕЦ как МестоХраненияНазначение,
		|ВЫБОР
		|	КОГДА &ПунктВыдачиНазначение = ЗНАЧЕНИЕ(Справочник.ТочкиРаздачи.ПустаяСсылка)
		|			или &ПунктВыдачиНазначение = неопределено
		|	ТОГДА ТранзитОстатки.Точка
		|	ИНАЧЕ &ПунктВыдачиНазначение
		|КОНЕЦ как ПунктВыдачиНазначение,
		|ВЫБОР
		|	КОГДА &Организатор = ЗНАЧЕНИЕ(Справочник.Организаторы.ПустаяСсылка)
		|			или &Организатор = неопределено
		|	ТОГДА ТранзитОстатки.ПокупкаСсылка.Организатор
		|	ИНАЧЕ &Организатор
		|КОНЕЦ как Организатор
		|
		|ИЗ
		|	РегистрНакопления.Транзит.Остатки(, "+ТекстУсловия+") КАК ТранзитОстатки";
	Если указанУчастник Тогда
		Запрос.УстановитьПараметр("Участник", 					ДанныеШК.Участник);
	КонецЕсли;
	Запрос.УстановитьПараметр("Покупка", 					ДанныеШК.Заказ);
	Запрос.УстановитьПараметр("ГабаритНазначение", 			фГабарит);
	Запрос.УстановитьПараметр("МестоХраненияНазначение", 	фМестоХранения);
	Запрос.УстановитьПараметр("ПунктВыдачиНазначение", 		фПунктВыдачи);
	Запрос.УстановитьПараметр("Организатор", 				фОрганизатор);	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		новаяСтрока = объект.ПокупкиТранзит.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ВыборкаДетальныеЗаписи);
	КонецЦикла;
 
	
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура ЗаполнитьНазначения(Команда)
	Для каждого элем из Объект.ПокупкиТранзит Цикл
		элем.МестоХраненияНазначение = фМестоХранения;
	КонецЦикла;	
КонецПроцедуры
	



#КонецОбласти