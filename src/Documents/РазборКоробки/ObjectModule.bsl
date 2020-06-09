
#Область СобытияОбъекта
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	мОстанавливатьПриходПриОшибке=Константы.ОстанавливатьПриходПриОшибке.Получить();
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если Константы.ПроверятьОтветственногоПриРасходе.Получить() Тогда
		ПроверяемыеРеквизиты.Добавить("Ответственный");	
	КонецЕсли;	
	//Если не Транзит Тогда
	//    НеПроверять="ТочкаНазначения";
	//КонецЕсли;
	//инд=ПроверяемыеРеквизиты.Найти(НеПроверять);
	//Если инд<>Неопределено Тогда ПроверяемыеРеквизиты.Удалить(инд); КонецЕсли;
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	
	Если Коробки.Количество()>0 Тогда
		Организатор	=	Коробки[0].Коробка.Организатор;
	КонецЕсли;
	
	массПосылки 		= Посылки.НайтиСтроки(новый Структура("Посылка",Справочники.Посылки.ПустаяСсылка()));
	Для каждого пос из массПосылки Цикл
		Посылки.Удалить(пос);
	КонецЦикла;	
	
	масс_ПустыеСтроки	=	Покупки.НайтиСтроки(новый Структура("Коробка",Справочники.Коробки.ПустаяСсылка()));
	Для каждого стр из масс_ПустыеСтроки Цикл
		Покупки.Удалить(стр);
	КонецЦикла;	
	Если ЗначениеЗаполнено(Супергруппа) Тогда
		обСупергруппа = Супергруппа.ПолучитьОбъект();
		массПосылокСупергруппы 	= Посылки.НайтиСтроки(новый структура("Коробка", Справочники.Коробки.БезКоробки));
		массПокупокСупергруппы 	= Покупки.НайтиСтроки(новый структура("Коробка", Справочники.Коробки.БезКоробки));
		массбезкоробки 			= Коробки.НайтиСтроки(новый структура("Коробка", Справочники.Коробки.БезКоробки));
		обСупергруппа.Количество = массПосылокСупергруппы.Количество()+ массПокупокСупергруппы.Количество() + (Коробки.Количество() - массбезкоробки.количество());
		Попытка
			обСупергруппа.Записать();
		Исключение
		
		КонецПопытки;
	КонецЕсли;	
	ЗаполнитьШК();
КонецПроцедуры
#КонецОбласти

#Область Корректировки

Функция 	СоздатьПоШК(РазобралиШК) Экспорт
	Если РазобралиШК.ТипШК="12" Тогда
		стр_коробки			= Коробки.Добавить();		
		стр_коробки.Коробка	= Справочники.Коробки.БезКоробки;
		стр_коробки.ШК		= Справочники.Мегаордера.нулевой;
		
		//стр_посылки=Посылки.Добавить();
		//стр_посылки.Посылка=РазобралиШК.Посылка;
		//стр_посылки.ПунктВыдачи
    Конецесли;
КонецФункции

Процедура 	ЗаполнитьШК() Экспорт
	масс_ПустыеСтроки=Покупки.НайтиСтроки(новый Структура("Коробка",Справочники.Коробки.ПустаяСсылка()));
	Для каждого стр из масс_ПустыеСтроки Цикл
		Покупки.Удалить(стр);
	КонецЦикла;
	
	масс_БезШК=Покупки.НайтиСтроки(новый Структура("ШК",Справочники.Мегаордера.ПустаяСсылка()));
	Для каждого стр из масс_БезШК Цикл
		стр.ШК=СП_Штрихкоды.ПолучитьМегаордер(стр.Покупка,стр.Участник,стр.ТочкаНазначения);
	КонецЦикла;
	
	масс_БезШК_Посылки=Посылки.НайтиСтроки(новый Структура("ШК",Справочники.Мегаордера.ПустаяСсылка()));
	Для каждого стр из масс_БезШК_Посылки Цикл
		стр.ШК=СП_Штрихкоды.ПолучитьМегаордер(стр.Посылка,Справочники.Участники.ПустаяСсылка(),стр.ПунктВЫдачи);
	КонецЦикла;	
	
	масс_КоробкиБезШК=Коробки.НайтиСтроки(новый Структура("ШК",Справочники.Мегаордера.ПустаяСсылка()));
	Для каждого стр из масс_КоробкиБезШК Цикл
		Если стр.коробка=Справочники.Коробки.БезКоробки Тогда
			стр.ШК=	Справочники.Мегаордера.нулевой;
		Иначе	
			стр.ШК=СП_Штрихкоды.ПолучитьМегаордер(стр.коробка,Неопределено);
		КонецЕсли;	
	КонецЦикла;
КонецПроцедуры	

#КонецОбласти


#Область Проведение

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	#Область ПравильноеПроведение
	
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.РазборКоробки.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.Вставить("ЭтоНовый",ЭтоНовый());
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СтоСПОбмен_Общий.ОтразитьСтоСПОбмен_РН(ДополнительныеСвойства, Движения, Отказ);
	СтоСПОбмен_Общий.ОтразитьСтоСПОбмен_РН_Ошибки(ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьНеВыгруженноНаСайт(ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьТранзит(ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьОстаткиТоваров(ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьЗаказыВПосылках(ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьПриход(ДополнительныеСвойства, Движения, Отказ);
//	СП_ДвиженияСервер.ОтразитьКПолучению(ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("Обмен100СПрн",ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("ШтрафныеЗаказы",ДополнительныеСвойства, Движения, Отказ);
	#КонецОбласти
	
	//масс_Отправленных = Посылки.НайтиСтроки(новый Структура("Отправлено",Истина));
	//Для каждого пос из масс_Отправленных Цикл
	//	СП_РаботаСоСправочниками.ЗаполнитьМегаордерПо_Посылке(пос);
	//КонецЦикла;
	
	ДвигаемОчередьРазбора(Отказ, РежимПроведения);
	//ДвигаемПоступлениеТранзита();

	//
	ДвигаемПокупкиОтдельнымМестом(Отказ, РежимПроведения);
	
	ДвигаемНегабаритЗначения();
КонецПроцедуры

Процедура ДвигаемНегабаритЗначения()
	Движения.НегабаритЗначения.Записывать = Истина;
	Для Каждого ТекСтрокаПокупки Из Покупки Цикл
		Если ТекСтрокаПокупки.Габарит.НеГабарит Тогда
			Движение = Движения.НегабаритЗначения.Добавить();
			Движение.Покупка = ТекСтрокаПокупки.Покупка;
			Движение.Участник = ТекСтрокаПокупки.Участник;
			Движение.Габарит = ТекСтрокаПокупки.Габарит;
			Движение.Вес = ТекСтрокаПокупки.Вес;
			Движение.объем = ТекСтрокаПокупки.объем;
			Движение.Партия=Ссылка;
		КонецЕсли;
	КонецЦикла;
	Для Каждого ТекСтрокаПокупки Из Посылки Цикл
		Если ТекСтрокаПокупки.Габарит.НеГабарит Тогда
			Движение = Движения.НегабаритЗначения.Добавить();
			Движение.Покупка = ТекСтрокаПокупки.Посылка;
			Движение.Участник = ТекСтрокаПокупки.Посылка.Участник;
			Движение.Габарит = ТекСтрокаПокупки.Габарит;
			Движение.Вес = ТекСтрокаПокупки.Вес;
			Движение.объем = ТекСтрокаПокупки.объем;
			Движение.Партия=Ссылка;
		КонецЕсли;
	КонецЦикла;	
КонецПроцедуры

Процедура ДвигаемОчередьРазбора(Отказ, Режим)

	Движения.ОчередьРазбора.Записывать = Истина;
	Для Каждого ТекСтрокаКоробки Из Коробки Цикл
		Если ТекСтрокаКоробки.Коробка<>справочники.Коробки.БезКоробки Тогда 
			Движение = Движения.ОчередьРазбора.Добавить();
			Движение.Период = Дата;
			Движение.Статус=Перечисления.СтатусыКоробки.Разобрана;
			Движение.Коробка = ТекСтрокаКоробки.Коробка;
		КонецЕсли;
	КонецЦикла;

	
КонецПроцедуры

Процедура ДвигаемПокупкиОтдельнымМестом(Отказ, Режим)
	Движения.ПокупкиОтдельнымМестом.Записывать = Истина;
		Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПриходнаяПокупки.Ссылка.Дата КАК Период,
		|	ПриходнаяПокупки.Покупка,
		|	ПриходнаяПокупки.Участник,
		|	МАКСИМУМ(ПриходнаяПокупки.ОтдельнымМестом) КАК ОтдельнымМестом
		|ИЗ
		|	Документ.РазборКоробки.Покупки КАК ПриходнаяПокупки
		|ГДЕ
		|	ПриходнаяПокупки.Ссылка = &Ссылка
		|
		|СГРУППИРОВАТЬ ПО
		|	ПриходнаяПокупки.Участник,
		|	ПриходнаяПокупки.Покупка,
		|	ПриходнаяПокупки.Ссылка.Дата";
	Запрос.Параметры.Вставить("Ссылка",Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Движения.ПокупкиОтдельнымМестом.Загрузить(РезультатЗапроса.Выгрузить());
	//
	//Для Каждого ТекСтрокаПокупки Из Покупки Цикл
	//	Движение = Движения.ПокупкиОтдельнымМестом.Добавить();
	//	Движение.Покупка = ТекСтрокаПокупки.Покупка;
	//	Движение.ОтдельнымМестом = ТекСтрокаПокупки.ОтдельнымМестом;
	//КонецЦикла;
КонецПроцедуры

#КонецОбласти

#Область Обмен

Функция   	ВыгрузитьНаСайт() Экспорт
	//12000006516484000949
	СтоСПОбмен_Посылки_income.ВыгрузитьПоступления_income(ЭтотОбъект);
КонецФункции

#КонецОбласти


	


#Область НеИспользуется

Функция	  ПолучитьДокументВыдачи(тзПокупкиУчастники)
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц=Новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПУ.Покупка,
		|	ПУ.Участник
		|ПОМЕСТИТЬ ПУ
		|ИЗ
		|	&ПУ КАК ПУ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	КПолучениюОстатки.ДокументВыдачи,
		|	СУММА(ЕСТЬNULL(КПолучениюОстатки.КоличествоОстаток, 0)) КАК КоличествоОстаток,
		|	ПУ.Покупка,
		|	ПУ.Участник
		|ПОМЕСТИТЬ Пред
		|ИЗ
		|	ПУ КАК ПУ
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.КПолучению.Остатки(&НаДату, ) КАК КПолучениюОстатки
		|		ПО (КПолучениюОстатки.Покупка = ПУ.Покупка)
		|			И (КПолучениюОстатки.Участник = ПУ.Участник)
		|ГДЕ
		|	КПолучениюОстатки.КоличествоОстаток > 0
		|
		|СГРУППИРОВАТЬ ПО
		|	КПолучениюОстатки.ДокументВыдачи,
		|	ПУ.Покупка,
		|	ПУ.Участник
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Пред.ДокументВыдачи,
		|	Пред.КоличествоОстаток,
		|	Пред.Покупка,
		|	Пред.Участник
		|ИЗ
		|	Пред КАК Пред";

	Запрос.УстановитьПараметр("ПУ", тзПокупкиУчастники);
	Запрос.УстановитьПараметр("НаДату", Дата-1);


	Результат = Запрос.Выполнить();
	Возврат Результат.Выгрузить();//.ВыгрузитьКолонку("ТочкаОтправитель"); 
КонецФункции 

Процедура ДвигаемПоступлениеТранзита()
	Движения.КПолучению.Записывать = Истина;
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	РазборКоробкиПокупки.Участник,
		|	РазборКоробкиПокупки.Покупка
		|ИЗ
		|	Документ.РазборКоробки.Покупки КАК РазборКоробкиПокупки
		|ГДЕ
		|	РазборКоробкиПокупки.Ссылка = &Ссылка
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Справочник.Участники.Нулевой),
		|	РазборКоробкиКоробки.Коробка
		|ИЗ
		|	Документ.РазборКоробки.Коробки КАК РазборКоробкиКоробки
		|ГДЕ
		|	РазборКоробкиКоробки.Ссылка = &Ссылка";
	Запрос.Параметры.Вставить("Ссылка",Ссылка);
	РезультатЗапроса = Запрос.Выполнить();
	

	тзПокупкиУчастники=РезультатЗапроса.Выгрузить();//Покупки.Выгрузить(,"Покупка,Участник");
	
	тзДВ=ПолучитьДокументВыдачи(тзПокупкиУчастники);
	Для Каждого ТекСтрокаПокупки Из тзПокупкиУчастники Цикл
		масСтроки=тзДВ.НайтиСтроки(новый Структура("Покупка,Участник",ТекСтрокаПокупки.Покупка,ТекСтрокаПокупки.Участник));
		Если масСтроки.Количество()=0 или масСтроки[0].КоличествоОстаток<1 тогда продолжить; КонецЕсли;
		
		Движение = Движения.КПолучению.Добавить();
		Движение.Период = Дата;
		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
		Движение.Покупка = ТекСтрокаПокупки.Покупка;

		Движение.Участник	=ТекСтрокаПокупки.Участник;
		Движение.ДокументВыдачи = масСтроки[0].ДокументВыдачи;
		Движение.Количество = 1;
		масСтроки[0].КоличествоОстаток=масСтроки[0].КоличествоОстаток-1;
	КонецЦикла;
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ПриходнаяПокупки.Покупка КАК Коробка
		|ИЗ
		|	Документ.Приходная.Покупки КАК ПриходнаяПокупки
		|ГДЕ
		|	ПриходнаяПокупки.Ссылка = &Ссылка
		|	И ТИПЗНАЧЕНИЯ(ПриходнаяПокупки.Покупка) = ТИП(Справочник.Коробки)
		|
		|СГРУППИРОВАТЬ ПО
		|	ПриходнаяПокупки.Покупка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	Движения.ОчередьРазбора.Записывать = Истина;

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Движение = Движения.ОчередьРазбора.Добавить();
		Движение.Период=Ссылка.Дата;
		Движение.Коробка = ВыборкаДетальныеЗаписи.Коробка;
		Движение.Статус	 = Перечисления.СтатусыКоробки.Разобрана;
	КонецЦикла;
КонецПроцедуры	

#КонецОбласти