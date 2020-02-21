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
КонецПроцедуры


#Область ШтрихКоды


&НаКлиенте
Функция ОбработатьШКнаКлиенте(ШК)
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
		Объект.Участник = ДанныеШК.Участник;	
	ИначеЕсли Строка(ДанныеШК.Тип) = "Место хранения (63)" 		Тогда	
		МестоХранения	= ДанныеШК.МестоХранения;
	Иначеесли Строка(ДанныеШК.Тип) 		= "Сотрудник (55)" 			Тогда	
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(этотОбъект,,ДанныеШК.Сотрудник) Тогда
			Закрыть();
		КонецЕсли;				
	КонецЕсли;		

КонецФункции	

&НаКлиенте
Процедура СчитатьШКВручную(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаВводаШК",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ВвестиШтрихКодВручную_Завершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ВвестиШтрихКодВручную_Завершение(ШК, ДополнительныеПараметры) Экспорт
	ОбработатьШКнаКлиенте(ШК);
КонецПроцедуры	

Функция ДобавитьЗаказ(ДанныеШК)

	ТекстУсловия	= " ПокупкаСсылка = &Покупка ";
	
	Если ЗначениеЗаполнено(ДанныеШК.Участник) Тогда
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
		|	&ГабаритНазначение как ГабаритНазначение,
		|	&МестоХраненияНазначение как МестоХраненияНазначение,
		|	&ПунктВыдачиНазначение как ПунктВыдачиНазначение,	
		|	&Организатор как Организатор
		|
		|ИЗ
		|	РегистрНакопления.Транзит.Остатки(, "+ТекстУсловия+") КАК ТранзитОстатки";
	
	Запрос.УстановитьПараметр("Участник", 					ДанныеШК.Участник);
	Запрос.УстановитьПараметр("Покупка", 					ДанныеШК.Покупка);
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



#КонецОбласти