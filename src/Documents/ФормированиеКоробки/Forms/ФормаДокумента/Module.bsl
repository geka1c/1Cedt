
#область Штрихкоды

&НаКлиенте
Процедура 	ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если 	ИмяСобытия 	= "ScanData" 					и
			Источник 	= "ПодключаемоеОборудование" 	и
			ВводДоступен()									Тогда
			
			ШК = СтоСП_Клиент.ПолучитьШКизПараметров(Параметр);
			ОбработатьШКнаКлиенте(ШК);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура 	ОбработатьШКнаКлиенте(ШК)
	ДанныеШК    = СП_Штрихкоды.ПолучитьДанныеПоШК(ШК);
	Если 	Строка(ДанныеШК.Тип) = "Посылка (12)" 			или
			Строка(ДанныеШК.Тип) = "Покупка (11)" 			или 
			Строка(ДанныеШК.Тип) = "Заказ100маркета (33)"		Тогда
		ПунктВыдачиКорректен 	= не ПунктВыдачиНеКорректен(ДанныеШК.ПунктВыдачи);
		
		Если ПунктВыдачиКорректен и Строка(Объект.Статус )= "Подготовка" Тогда
			ПсылкаДобавлена = ДобавитьПокупку(ДанныеШК);
			Если ПсылкаДобавлена Тогда
				СтоСП_Клиент.СигналДинамика();
			КОнецЕсли;	
		КонецЕсли;
	Иначеесли Строка(ДанныеШК.Тип) = "Сотрудник (55)" 			Тогда	
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(этотОбъект,,ДанныеШК.Сотрудник) Тогда
			СформироватьСтикер("");
			Закрыть();
		КонецЕсли;		
	ИначеЕсли Строка(ДанныеШК.Тип) = "Габарит (62)" 			Тогда	
		Габарит			= ДанныеШК.Габарит;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Место хранения (63)" 		Тогда	
		МестоХранения	= ДанныеШК.МестоХранения;

	КонецЕсли;
	Модифицированность			= Истина;
	УстановитьВидимость();
КонецПроцедуры	

&НаКлиенте
Функция 	ДобавитьПокупку(параметрыЗаказа)
	
	строка = Новый Структура;
	Если параметрыЗаказа.Свойство("Участник") Тогда
		строка.Вставить("Участник",	параметрыЗаказа.Участник);
	КонецЕсли;	
	строка.Вставить("Покупка", 		параметрыЗаказа.Посылка);
	строка.Вставить("Подбор", 		Ложь);

	МассивСтрок	= Объект.Покупки.НайтиСтроки(строка);
	Если МассивСтрок.Количество() = 0 Тогда
		Если ПредупреждатьОНовыхЗаказах() Тогда
			Ответ = Вопрос("Не найдено на остатках. Добавить как новый Заказ?", РежимДиалогаВопрос.ДаНет, 0);
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Возврат ложь;
			КонецЕсли;
		КонецЕсли;
		
		Элементы.гпСтр.ТекущаяСтраница	= Элементы.гпНовыеЗаказы;
		ДобавитьНовуюПокупку(параметрыЗаказа);
	Иначе
		Элементы.гпСтр.ТекущаяСтраница	= Элементы.гпЗаказы;
		МассивСтрок[0].Подбор			= Истина;
	КонецЕсли;	
	УстановитьОбщееКоличество();
	Возврат истина;
КонецФункции	

Процедура 	ДобавитьНовуюПокупку(параметрыЗаказа)
	новаяСтр			=	Объект.НовыеПокупки.Добавить();
	новаяСтр.Покупка  	=	параметрыЗаказа.Заказ;
	Если параметрыЗаказа.Свойство("Участник") Тогда
		НоваяСтр.Участник 	=	параметрыЗаказа.Участник;
	Иначе
		НоваяСтр.Участник 	=	Справочники.Участники.нулевой;
	КонецЕсли;	
	новаяСтр.Точка		=	параметрыЗаказа.ПунктВыдачи;
	новаяСтр.ШК			=	параметрыЗаказа.ШК;
	новаяСтр.ОргСбор	=	ОргСбор;
КонецПроцедуры

&НаКлиенте
Процедура 	ДобавитьПоШК(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаВводаШК",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ВвестиШтрихКодВручную_Завершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура 	ВвестиШтрихКодВручную_Завершение(ШК, ДополнительныеПараметры) Экспорт
	ОбработатьШКнаКлиенте(ШК);
КонецПроцедуры	

#КОнецобласти

&НаСервереБезКонтекста
Функция ПредупреждатьОновыхЗаказах()

	возврат Константы.ФормированиеКоробкиПредупреждениеНовыйЗаказ.Получить();

КонецФункции // ПредупреждатьОновыхЗаказах()



&НаСервере
Процедура ПодсветкаСтрок()

    ЭтаФорма.УсловноеОформление.Элементы.Очистить();
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Покупки");
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Покупки.Подбор");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.БледноЗеленый);	
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Покупки");
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Покупки.Предупреждение");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Перечисления.ПредупрежденияПрихода.ЧерныйСписок;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоСерый);	
	
КонецПроцедуры



&НаСервереБезКонтекста
Функция ПолучитьСсылку(ВыражениеСтр)
	Возврат Вычислить(ВыражениеСтр);
КонецФункции	


	&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//// СтандартныеПодсистемы.Печать
	//УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект);
	//// Конец СтандартныеПодсистемы.Печать
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	
	Если не ЗначениеЗаполнено(объект.ВидОперации) тогда
		Объект.ВидОперации=Перечисления.ВидыОперацийФормированияКоробки.НаОднуТочку;
	КонецЕсли;	
	мОстанавливатьПриходПриОшибке=Константы.ОстанавливатьПриходПриОшибке.Получить();
	Объект.ТочкаОтправитель=Константы.СвояТочка.Получить();
	Если не ЗначениеЗаполнено(Объект.Ссылка) Тогда Объект.Статус=Перечисления.СтатусОтпавкиНаСайт.Подготовка КонецЕсли;
	Объект.Пользователь	= ПользователиКлиентСервер.ТекущийПользователь();
	Умолчания		= аСПНаСервере.ПолучитьЗначенияПоУмолчанию(Объект.ТочкаНазначения);
	Габарит			= Умолчания.Габарит;
	МестоХранения	= Умолчания.МестоХранения;
	ПодсветкаСтрок();
	УстановитьДоступность();
	
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Объект);
КонецПроцедуры
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Объект, Результат);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
    УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаСервере
Процедура СформироватьКоробкуНаСервере()
	// Вставить содержимое обработчика.
КонецПроцедуры


&НаКлиенте
Процедура СформироватьКоробку(Команда)
	СформироватьКоробкуНаСервере();
КонецПроцедуры




&НаСервере
Процедура ПоказатьСкрытьСверкуНаСервере(ТочкаНазначения)
	Если не элементы.гпСверка.Видимость Тогда Возврат; КонецЕсли;
	СхемаКомпоновкиДанных = Документы.ФормированиеКоробки.ПолучитьМакет("СверитьСодержимое");
	КомпоновщикНастроек=Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек["Основной"].Настройки);
	
	Для каждого СтрПарам Из КомпоновщикНастроек.Настройки.ПараметрыДанных.Элементы Цикл
		ЭлПарам = КомпоновщикНастроек.Настройки.ПараметрыДанных.ДоступныеПараметры.НайтиПараметр(СтрПарам.Параметр);
		Если ЭлПарам <> Неопределено Тогда
			Если ЭлПарам.Заголовок = "Точка" Тогда
				СтрПарам.Значение = ТочкаНазначения;
				СтрПарам.Использование = Истина;
			ИначеЕсли ЭлПарам.Заголовок = "На дату" Тогда
				СтрПарам.Значение = КонецДня(Объект.Дата);
				СтрПарам.Использование = Истина;
			КонецЕсли; 
		КонецЕсли;                                             
	КонецЦикла;	
	

	
	Настройки = КомпоновщикНастроек.Настройки;
	ДанныеРасшифровки = Новый ДанныеРасшифровкиКомпоновкиДанных;
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных,
	Настройки, ДанныеРасшифровки,,Тип("ГенераторМакетаКомпоновкиДанных"));
	ТЧДокумента=Объект.Покупки.Выгрузить(,"НомерСтроки,Покупка,Участник");
	
	ТЧДокумента.Колонки.Добавить("ВДокументе",новый ОписаниеТипов("Число"));
	ТЧДокумента.ЗаполнитьЗначения(1,"ВДокументе");
	ТЧДокумента.Колонки.Добавить("Остаток",новый ОписаниеТипов("Число"));
	ТЧДокумента.ЗаполнитьЗначения(0,"Остаток");
	
	ВнешниеНаборыДанных = Новый Структура;
	ВнешниеНаборыДанных.Вставить("ТЧДокумента", ТЧДокумента);

	ПроцессорКомпоновкиДанных = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиДанных.Инициализировать(МакетКомпоновки,ВнешниеНаборыДанных,ДанныеРасшифровки);
	
	
	Результат.Очистить(); 
	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(Результат);
	ПроцессорВывода.Вывести(ПроцессорКомпоновкиДанных);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСкрытьСверку(Команда)
	элементы.гпСверка.Видимость=не элементы.гпСверка.Видимость;
	ПоказатьСкрытьСверкуНаСервере(Объект.ТочкаНазначения);
КонецПроцедуры



&НаКлиенте
Процедура СформироватьСтикер(Команда)
	Если ЗначениеЗаполнено(Объект.Коробка) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Коробка уже сформирована.");
		Возврат;
	КонецЕсли;	
	Если Объект.Покупки.НайтиСтроки(новый структура("подбор",истина)).Количество()=0 и Объект.НовыеПокупки.Количество()=0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Выберите заказы наполняющие коробку.");
		Возврат;
	КонецЕсли;	
	Отказ=ложь;
	Записать();
	СформироватьХМЛНаСервере(отказ);
	ОтправитьНаСервере(отказ);
	Если  отказ Тогда Возврат; КонецЕсли;
	Попытка
		Если  ЗначениеЗаполнено(Объект.Коробка)  Тогда
			ком 				= ПолучитьКомандуПечати("Групповой стикер на принтер");
			Объект.Напечатано	= Истина;
			УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(ЭтаФорма.Команды[ком], ЭтотОбъект, Объект);
		КонецЕсли;
		записан	= СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(этотОбъект);
		Если Записан Тогда
			Закрыть();
		КонецЕсли
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры


Процедура УстановитьДоступность()
	Если Объект.Статус=Перечисления.СтатусОтпавкиНаСайт.Подготовка Тогда
		Элементы.Покупки.ТолькоПросмотр=Ложь;
		Элементы.НовыеПокупки.ТолькоПросмотр=Ложь;
		Элементы.гпНаСайт.ТолькоПросмотр=Ложь;

	ИначеЕсли Объект.Статус=Перечисления.СтатусОтпавкиНаСайт.Сформирован Тогда
		Элементы.Покупки.ТолькоПросмотр=Истина;
		//Элементы.НовыеПокупки.ТолькоПросмотр=Истина;
		Элементы.гпНаСайт.ТолькоПросмотр=Истина;

	ИначеЕсли Объект.Статус=Перечисления.СтатусОтпавкиНаСайт.Отправлен Тогда
		Элементы.Покупки.ТолькоПросмотр=Истина;  
		//Элементы.НовыеПокупки.ТолькоПросмотр=Истина;
		Элементы.гпНаСайт.ТолькоПросмотр=Истина;

	КонецЕсли;			

КонецПроцедуры // УстановитьДоступность()


Процедура УстановитьВидимость()
	Если Объект.ВидОперации=Перечисления.ВидыОперацийФормированияКоробки.КРазбору Тогда
		Элементы.ТочкаНазначения.Заголовок="Транзитная точка";
	Иначе	
		Элементы.ТочкаНазначения.Заголовок="Конечная точка";
	КонецЕсли;
	Элементы.ОргСбор.Видимость=Константы.ФлагОрганизаторОплачиваетРазборДоступность.Получить();
	Элементы.НовыеПокупкиОргСбор.Видимость= Элементы.ОргСбор.Видимость;
	//Элементы.Вес.Доступность=ЗначениеЗаполнено(Объект.Коробка);
	//Элементы.Объем.Доступность=ЗначениеЗаполнено(Объект.Коробка);
КонецПроцедуры	


&НаСервере
Процедура СформироватьХМЛНаСервере(Отказ)
	если не ПроверитьЗаполнение() Тогда
		отказ=истина;
		Возврат;
	КонецЕсли ;	
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ФормированиеКоробки"));
	об.СериолизоватьВХМЛ(отказ);
	ЗначениеВДанныеФормы(об,Объект);
	УстановитьДоступность();
	Записать();
КонецПроцедуры

&НаКлиенте
Процедура СформироватьХМЛ(Команда)
	Отказ=ложь;
	Записать();
	СформироватьХМЛНаСервере(Отказ);
КонецПроцедуры


&НаСервере
Процедура ОтправитьНаСервере(отказ)
	Если отказ тогда Возврат КонецЕсли;
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ФормированиеКоробки"));
	об.ОтправитьНаСайт(отказ);
	ЗначениеВДанныеФормы(об,Объект);
	Записать();
		
КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	ОтправитьНаСервере(ложь);
КонецПроцедуры

&НаКлиенте
Процедура Обработать(Команда)
	отказ=ложь;
	ОбработатьНаСервере(отказ);

КонецПроцедуры

Процедура ОбработатьНаСервере(отказ)
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ФормированиеКоробки"));
	об.ОбработатьПолученныеДанные(отказ);
	ЗначениеВДанныеФормы(об,Объект);
КонецПроцедуры	

&НаКлиенте
Процедура ЗаполнитьПоТочкеНазначения(Команда)
	Если Объект.Покупки.Количество()> 0 Тогда 
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос("Перед заполнением табличная часть будет очищена. Продолжить?", Режим, 0);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли; 
	КонецЕсли;		
	фрмВыбора=ПолучитьФорму("Справочник.ТочкиРаздачи.ФормаВыбора",,ЭтаФорма);
	фрмВыбора.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	ОбработкаВыбораНаСервере(ВыбранноеЗначение)	;
КонецПроцедуры

Процедура ОбработкаВыбораНаСервере(ВыбранноеЗначение)
	Объект.Покупки.Очистить();
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ФормированиеКоробки"));
	об.ЗаполнитьПоТочкеНазначения(ВыбранноеЗначение);
	ЗначениеВДанныеФормы(об,Объект);
	Умолчания=аСПНаСервере.ПолучитьЗначенияПоУмолчанию(Объект.ТочкаНазначения,ложь);
	Объект.Габарит		=Умолчания.Габарит;
	Объект.МестоХранения	=Умолчания.МестоХранения;

КонецПроцедуры




&НаКлиенте
Процедура ТочкаНазначенияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Объект.Покупки.Количество()> 0 Тогда 
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос("Перед заполнением табличная часть будет очищена. Продолжить?", Режим, 0);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли; 
	КонецЕсли;	
	СтандартнаяОбработка= ложь;
	фрмВыбора=ПолучитьФорму("Справочник.ТочкиРаздачи.ФормаВыбора",,ЭтаФорма);
	фрмВыбора.Открыть();

КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	УстановитьВидимость();
	
	//Сканер штрихкода
	СтоСП_Клиент.ПодключитьСканерШК(УникальныйИдентификатор);
	
	Если не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Если не ЗначениеЗаполнено(Объект.ТочкаНазначения) Тогда
			фрмВыбора=ПолучитьФорму("Справочник.ТочкиРаздачи.ФормаВыбора",,ЭтаФорма);
			фрмВыбора.Открыть();
		ИначеЕсли Объект.Покупки.Количество()=0 Тогда
			ОбработкаВыбораНаСервере(Объект.ТочкаНазначения);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПометитьВсе(Команда)
	Если Элементы.Покупки.ТолькоПросмотр Тогда Возврат; КонецЕсли;
	Для каждого стр из Объект.Покупки Цикл
		стр.Подбор=Истина;
	КонецЦикла	
КонецПроцедуры


&НаКлиенте
Процедура СнятьВыделениеВсе(Команда)
	Если Элементы.Покупки.ТолькоПросмотр Тогда Возврат; КонецЕсли;
	Для каждого стр из Объект.Покупки Цикл
		стр.Подбор=Ложь;
	КонецЦикла	
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если аСПСлужебные.ПроверятьОтветственного() и  не ЗначениеЗаполнено(Объект.Ответственный) Тогда
		Сообщить("Необходимо установить ответственного за выдачу!!!");
		отказ=Истина;
	КонецЕсли;	
	
	//ЗаполнитьОргов();
	

КонецПроцедуры


&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	//Если  ЗначениеЗаполнено(Объект.Коробка)  Тогда
	//	ком = ПолучитьКомандуПечати();
	//	Объект.Напечатано=Истина;
	//	УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(ЭтаФорма.Команды[ком], ЭтотОбъект, Объект);
	//	Записать();
	//КонецЕсли;
	ИзменитьТочкуНазначения();
		Если  ЗначениеЗаполнено(Объект.Коробка)  Тогда
			ком = ПолучитьКомандуПечати("Групповой стикер на принтер");
			Объект.Напечатано=Истина;
			УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(ЭтаФорма.Команды[ком], ЭтотОбъект, Объект);
		КонецЕсли;
КонецПроцедуры


Функция  ПолучитьКомандуПечати(ИмяКоманды)
	
	Для каждого ком из ЭтаФорма.Команды Цикл
		Если ком.Заголовок=ИмяКоманды Тогда
			Возврат ком.Имя;
		КонецЕсли;
	КонецЦикла;	
КонецФункции	

Процедура ИзменитьТочкуНазначения()
	Если Объект.Статус=Перечисления.СтатусОтпавкиНаСайт.Отправлен и ЗначениеЗаполнено(Объект.Коробка)  Тогда
		об=объект.Коробка.ПолучитьОбъект();
		об.ТочкаНазначения=объект.ТочкаНазначения;
		Попытка
			об.Записать();
		Исключение
			
		КонецПопытки;
		
	КонецЕсли
КонецПроцедуры	




&НаКлиенте
Процедура гпСтрПриСменеСтраницы(Элемент, ТекущаяСтраница)
	УстановитьОбщееКоличество();
	гпСтрПриСменеСтраницыНаСервере();
КонецПроцедуры


&НаСервере
Процедура гпСтрПриСменеСтраницыНаСервере()
	Если элементы.гпСтр.ТекущаяСтраница=элементы.гпСтр.ПодчиненныеЭлементы.гпВесОбъемПоОрганизаторам Тогда
		ЗаполнитьОргов();
	КонецЕсли;	
КонецПроцедуры

Процедура ЗаполнитьОргов()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.ФормированиеКоробки"));
	ДокОбъект.ЗаполнитьОргов();
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры	


&НаКлиенте
Процедура ВесПриИзменении(Элемент)
	ВесПриИзмененииНаСервере();
КонецПроцедуры

Процедура ВесПриИзмененииНаСервере()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.ФормированиеКоробки"));	
	ДокОбъект.УстановитьПроценты();
	массИтог= аСПНаСервере.РаспределитьПропорционально(ДокОбъект.Вес,ДокОбъект.Организаторы.ВыгрузитьКолонку("ВесПроцент"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"Вес");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОбъемПриИзменении(Элемент)
	ОбъемПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбъемПриИзмененииНаСервере()
	
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.ФормированиеКоробки"));
	ДокОбъект.УстановитьПроценты();
	массИтог= аСПНаСервере.РаспределитьПропорционально(ДокОбъект.Объем,ДокОбъект.Организаторы.ВыгрузитьКолонку("ОбъемПроцент"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"Объем");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизаторыВесПриИзменении(Элемент)
	ОрганизаторыВесПриИзмененииНаСервере();
КонецПроцедуры

Процедура ОрганизаторыВесПриИзмененииНаСервере()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.ФормированиеКоробки"));	
	ДокОбъект.Вес=Объект.Организаторы.Итог("Вес");
	массИтог= аСПНаСервере.РаспределитьПропорционально(100,ДокОбъект.Организаторы.ВыгрузитьКолонку("Вес"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"ВесПроцент");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизаторыОбъемПриИзменении(Элемент)
	ОрганизаторыОбъемПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизаторыОбъемПриИзмененииНаСервере()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.ФормированиеКоробки"));	
	ДокОбъект.Объем=Объект.Организаторы.Итог("Объем");
	массИтог= аСПНаСервере.РаспределитьПропорционально(100,ДокОбъект.Организаторы.ВыгрузитьКолонку("Объем"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"ОбъемПроцент");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры



&НаКлиенте
Процедура ОрганизаторыВесПроцентПриИзменении(Элемент)
	ОрганизаторыВесПроцентПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизаторыВесПроцентПриИзмененииНаСервере()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.ФормированиеКоробки"));	
	массИтог= аСПНаСервере.РаспределитьПропорционально(Объект.Вес,ДокОбъект.Организаторы.ВыгрузитьКолонку("ВесПроцент"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"Вес");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизаторыОбъемПроцентПриИзменении(Элемент)
	ОрганизаторыОбъемПроцентПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизаторыОбъемПроцентПриИзмененииНаСервере()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.ФормированиеКоробки"));	
	массИтог= аСПНаСервере.РаспределитьПропорционально(Объект.Объем,ДокОбъект.Организаторы.ВыгрузитьКолонку("ОбъемПроцент"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"Объем");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОбщееКоличество()
	МассивСтрок=Объект.Покупки.НайтиСтроки(новый Структура("Подбор",Истина));
	Объект.Количество=МассивСтрок.Количество()+Объект.НовыеПокупки.Количество();
КонецПроцедуры	

&НаКлиенте
Процедура ПокупкиПриИзменении(Элемент)
	УстановитьОбщееКоличество();
КонецПроцедуры

&НаКлиенте
Процедура НовыеПокупкиПриИзменении(Элемент)
	УстановитьОбщееКоличество();
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
КонецПроцедуры





&НаКлиенте
Функция ПунктВыдачиНеКорректен(ПунктВыдачи)
	Если 	ПунктВыдачи 				<> Объект.ТочкаНазначения и  
			Строка(Объект.ВидОперации) 	=  "НаОднуТочку" 				Тогда
		Ответ = Вопрос("Пункт выдачи заказа:"+ПунктВыдачи+" не совпадает с пунктом выдачи документа:"+Объект.ТочкаНазначения+". Все равно добавить?", РежимДиалогаВопрос.ДаНет, 0);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат Истина;
		КонецЕсли;
	КонецЕсли;
	Возврат Ложь;
КонецФункции	





