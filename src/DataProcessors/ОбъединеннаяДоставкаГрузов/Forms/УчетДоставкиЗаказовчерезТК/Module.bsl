
&НаКлиенте
Процедура ОбновитьССайта(Команда)
	//Загрузка
	СтоСПОбмен_ГруппыДоставки.ЗагрузитьСоставПосылокКурьерскойДоставки();
	массГрупп	= СтоСПОбмен_ГруппыДоставки.Получить_ПоДате();
	СтоСП_ГруппыДоставки.РасчитатьОстаткиПоГруппамДоставки();	
	Для каждого элем из массГрупп Цикл
		ОповеститьОбИзменении(элем);
	КонецЦикла;
	//Выгрузка
	СписокГрупп = СтоСПОбмен_ГруппыДоставки.ВыгрузитьИзмененияНаСайт();
	Если СписокГрупп= Неопределено Тогда
		Для каждого элем из СписокГрупп Цикл
			ОповеститьОбИзменении(элем.Значение);
		КонецЦикла;		
	КонецЕсли;
	
КонецПроцедуры



#Область СобытияФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	// СтандартныеПодсистемы.Печать
	СписокОбъектов=Новый Массив;
	СписокОбъектов.Добавить(Метаданные.Документы.ОтправлениеТранзита);
	УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект,Элементы.ГруппаПечать,СписокОбъектов);
	// Конец СтандартныеПодсистемы.Печать
	
   // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПараметрыРазмещения = новый Структура;
	ПараметрыРазмещения.Вставить("Источники",Новый ОписаниеТипов("СправочникСсылка.Коробки"));
	ПараметрыРазмещения.Вставить("КоманднаяПанель","ПодключаемыеКоманды");
	ПараметрыРазмещения.Вставить("ПрефиксГрупп","СписокГД");
//    Структура - Параметры размещения подключаемых команд.
//       * Источники - ОписаниеТипов, Массив - Источники команд.
//           Используется для второстепенных списков, а также в формах объектов, не являющихся поставщиками
//           команд (обработки, общие формы). В массиве ожидаются элементы типа "ОбъектМетаданных".
//       * КоманднаяПанель - ГруппаФормы - Командная панель или группа команд, в которой выводятся подменю.
//           Используется как родитель для создания подменю в случае их отсутствия.
//           Если не указан то в первую очередь ищется группа "ПодключаемыеКоманды".
//       * ПрефиксГрупп - Строка - Добавка к именам подменю и имени командной панели.
//           Используется при необходимости префиксации групп с командами (в частности, когда в форме несколько таблиц).
//           В качестве префикса рекомендуется использовать имя таблицы формы, для которой выводятся команды.
//           Например, если ПрефиксГрупп = "СкладскиеДокументы" (имя второстепенной таблицы формы),
//           то используются подменю с именами "СкладскиеДокументыПодменюПечать", "СкладскиеДокументыПодменюОтчеты" и т.д.

    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект,ПараметрыРазмещения);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	//аспПроцедурыОбменаДанными.РасчитатьОстаткиПоГруппамДоставки();
	СписокГД.Параметры.УстановитьЗначениеПараметра("ТекущаяДата",ТекущаяДата());
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаОдиночныеЗаказы Тогда
		ПроверитьЗаказыВнеГрупп(истина);
	ИначеЕсли Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппыДоставки Тогда	
		Элементы.СписокГД.Обновить();
	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="ПровелиОтправлениеТранзита" и  
		 Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаОдиночныеЗаказы Тогда  
		Элементы.ОдиночныеЗаказы.Обновить();
	ИначеЕсли ИмяСобытия="ПровелиВыдачуТранзита" и  
		 Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаОдиночныеЗаказы Тогда 
 		Элементы.ОдиночныеЗаказы_КОтгрузке.Обновить();
	ИначеЕсли ИмяСобытия="ПроведенВозврат" Тогда  		
		СписокГрупп = СтоСПОбмен_ГруппыДоставки.ВыгрузитьИзмененияНаСайт();
		Для каждого группа из СписокГрупп Цикл
			ОповеститьОбИзменении(группа.Значение);
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры



#КонецОбласти



#Область Печать 

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
    УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Элементы.ОтправленныеЗаказы);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать

&НаКлиенте
Процедура ОписьДляПочтыРоссии(Команда)
	МассивДокументов=Элементы.ОтправленныеЗаказы.ВыделенныеСтроки;
	СсылкаНаФорму=ПолучитьСсылкуНаФорму(МассивДокументов);
	ЗапуститьПриложение(СсылкаНаФорму);
КонецПроцедуры

Функция ПолучитьСсылкуНаФорму(МассивДокументов)
	об=Обработки.ОбменСПочтойРоссии.Создать();
     возврат об.ОбменССайтомКвитанцияФ103(МассивДокументов)
КонецФункции

#КонецОбласти

#Область ДействияСЗаказами 

#Область Расшифровка
&НаКлиенте
Процедура СписокГДВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	результат=ПолучитьФормуРасшифровки(ВыбраннаяСтрока,Поле.Имя);
	Если ЗначениеЗаполнено(результат.Значение) Тогда
		ОткрытьЗначение(результат.Значение);
	Иначе
		ОткрытьФорму(результат.НазваниеФормы, результат.Парам,ЭтаФорма);
	КонецЕсли;	
КонецПроцедуры

Функция ПолучитьФормуРасшифровки(ВыбраннаяСтрока,ИмяПоля)
	Если ТипЗнч(ВыбраннаяСтрока)=Тип("СправочникСсылка.Коробки") Тогда
		//Если (ВыбраннаяСтрока.СтатусГруппыДоставки=Перечисления.СтатусыГруппыДоставки.waitForOrders или
		//	  ВыбраннаяСтрока.СтатусГруппыДоставки=Перечисления.СтатусыГруппыДоставки.waitForPayment или 
		//	  ВыбраннаяСтрока.СтатусГруппыДоставки=Перечисления.СтатусыГруппыДоставки.waitForDelay или 
		//	  ВыбраннаяСтрока.СтатусГруппыДоставки=Перечисления.СтатусыГруппыДоставки.shipment) и
		Если 	ИмяПоля<>"СписокГДСсылка"  Тогда
			Парам=новый Структура("ГруппаДоставки",ВыбраннаяСтрока);
			НазваниеФормы="Документ.ОтправлениеТранзита.Форма.ФормаДокумента";
			Значение=ВыбраннаяСтрока.ОтправлениеТранзита;
		Иначе
			Парам  = Новый Структура("Ключ", ВыбраннаяСтрока);
			НазваниеФормы="Справочник.Коробки.Форма.ФормаГруппыДоставки";
			Значение=Неопределено;
		КонецЕсли;
	КонецЕсли;
	результат=Новый Структура("НазваниеФормы,Парам,Значение",НазваниеФормы,Парам,Значение);
	Возврат результат;
КонецФункции	
#КонецОбласти

#Область ОбъединитьГД
&НаКлиенте
Процедура ОбъединитьГруппыДоставки(Команда)
	МассДляОтправления=Элементы.СписокГД.ВыделенныеСтроки;
	
	Фрм=ПолучитьФорму("Документ.ОбъединениеГруппДоставки.Форма.ФормаДокумента",,ЭтаФорма);
	обОбъединениеГруппДоставкиСформы=фрм.Объект;	
	СформироватьОбъединениеГруппДоставкиНаСервере(обОбъединениеГруппДоставкиСформы,МассДляОтправления);
	КопироватьДанныеФормы(обОбъединениеГруппДоставкиСформы,фрм.объект);
	фрм.Открыть();
КонецПроцедуры

&НаКлиенте
Процедура СоздатьГруппуДоставки(Команда)
	МассДляОтправления=Элементы.СписокГД.ВыделенныеСтроки[0];
	
	Фрм=ПолучитьФорму("Документ.СоздатьГруппуДоставки.Форма.ФормаДокумента",,ЭтаФорма);
	докОбъект=фрм.Объект;	
	СоздатьГруппуДоставкиНаСервере(докОбъект,МассДляОтправления);
	КопироватьДанныеФормы(докОбъект,фрм.объект);
	фрм.Открыть();
КонецПроцедуры

&НаСервере
Процедура СоздатьГруппуДоставкиНаСервере(обОбъединениеГруппДоставкиСформы,МассДляОтправления)
	УчастникГД = Справочники.Участники.ПустаяСсылка();
	Попытка
		УчастникГД = МассДляОтправления.УчастникГД;
		обОбъединениеГруппДоставки=ДанныеФормыВЗначение(обОбъединениеГруппДоставкиСформы,Тип("ДокументОбъект.СоздатьГруппуДоставки"));
		обОбъединениеГруппДоставки.Дата=ТекущаяДата();
		обОбъединениеГруппДоставки.участник = УчастникГД;
		обОбъединениеГруппДоставки.ЗаполнитьОстаткамиНаСкладе(УчастникГД);
		ЗначениеВДанныеФормы(обОбъединениеГруппДоставки,обОбъединениеГруппДоставкиСформы);
	Исключение
		
	КонецПопытки;

КонецПроцедуры


&НаСервере
Процедура СформироватьОбъединениеГруппДоставкиНаСервере(обОбъединениеГруппДоставкиСформы,МассДляОтправления)
	    УчастникГД=Справочники.Участники.ПустаяСсылка();
		Для каждого стр Из МассДляОтправления Цикл
			Если УчастникГД=Справочники.Участники.ПустаяСсылка() Тогда
				УчастникГД=стр.УчастникГД;
			Иначе
				Если УчастникГД<>стр.УчастникГД Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Объединять можно ,только, группы для одного участника!!!");
					Возврат;
				КонецЕсли;	
			КонецЕсли	
		КонецЦикла;
	    обОбъединениеГруппДоставки=ДанныеФормыВЗначение(обОбъединениеГруппДоставкиСформы,Тип("ДокументОбъект.ОбъединениеГруппДоставки"));
		обОбъединениеГруппДоставки.Дата=ТекущаяДата();
		обОбъединениеГруппДоставки.ЗаполнитьПоМассивуКоробок(МассДляОтправления);
		ЗначениеВДанныеФормы(обОбъединениеГруппДоставки,обОбъединениеГруппДоставкиСформы);
	

КонецПроцедуры

#КонецОбласти

#Область ВыдачаТранзита

&НаКлиенте
Процедура СформироватьВыдачуТранзита(Команда)
	МассДляОтправления=Элементы.СписокГД.ВыделенныеСтроки;
	
	Фрм=ПолучитьФорму("Документ.ВыдачаТранзита.Форма.ФормаДокумента",,ЭтаФорма);
	обВыдачаТранзитаСформы=фрм.Объект;	
	СформироватьВыдачуТранзитаНаСервере(обВыдачаТранзитаСформы,МассДляОтправления);
	КопироватьДанныеФормы(обВыдачаТранзитаСформы,фрм.объект);
	фрм.Открыть();
КонецПроцедуры

&НаСервере
Процедура СформироватьВыдачуТранзитаНаСервере(обВыдачаТранзитаСформы,МассДляОтправления)
	тз=Новый ТаблицаЗначений;
	тз.Колонки.Добавить("ГД",новый ОписаниеТипов("СправочникСсылка.Коробки"));
	тз.Колонки.Добавить("ТочкаНазначения",новый ОписаниеТипов("СправочникСсылка.ТочкиРаздачи"));
	
	Для каждого элем из МассДляОтправления Цикл
		стрТЗ=тз.Добавить();
		Если ТипЗнч(элем)=Тип("ДокументСсылка.ОтправлениеТранзита") Тогда
			Заказ=элем.Коробка;
		Иначе
			Заказ=элем;
		КонецЕсли;	
		стрТЗ.ГД=Заказ;
		стрТЗ.ТочкаНазначения=Заказ.ТочкаНазначения;
	КонецЦикла;
	тзТочки=тз.Скопировать(,"ТочкаНазначения");
	тзТочки.Свернуть("ТочкаНазначения");
	

	
	Для каждого стр из тзТочки Цикл
		массСтрок=тз.НайтиСтроки(новый Структура("ТочкаНазначения",стр.ТочкаНазначения));
		СписокЗаказов=Новый СписокЗначений;
		Для каждого стр из массСтрок Цикл
			СписокЗаказов.Добавить(стр.ГД);
		КонецЦикла;	
		СписокЗаказов.ЗагрузитьЗначения(массСтрок);
		обВыдачаТранзита=ДанныеФормыВЗначение(обВыдачаТранзитаСформы,Тип("ДокументОбъект.ВыдачаТранзита"));
		обВыдачаТранзита.Дата=ТекущаяДата();
		обВыдачаТранзита.ЗаполнитьПоСпискуКоробок(СписокЗаказов);
		обВыдачаТранзита.ВидОперации=Перечисления.ВидыОперацийВыдачаТранзита.НаОднуТочку;
		обВыдачаТранзита.ТочкаТранзита=?(ЗначениеЗаполнено(стр.ТочкаНазначения.ОсновнаяТочка),стр.ТочкаНазначения.ОсновнаяТочка, стр.ТочкаНазначения);
		обВыдачаТранзита.ТочкаНазначения=стр.ТочкаНазначения;
		ЗначениеВДанныеФормы(обВыдачаТранзита,обВыдачаТранзитаСформы);
	КонецЦикла
КонецПроцедуры
#КонецОбласти

#Область ОтчетОДоставке
&НаСервере
Процедура СформироватьОтчетОДоставкеНаСервере(обОтчетОДоставкеСформы,МассДляОтправления)
	тз=Новый ТаблицаЗначений;
	тз.Колонки.Добавить("ГД",новый ОписаниеТипов("СправочникСсылка.Коробки"));
	тз.Колонки.Добавить("ТочкаНазначения",новый ОписаниеТипов("СправочникСсылка.ТочкиРаздачи"));

	Для каждого элем из МассДляОтправления Цикл
		стрТЗ=тз.Добавить();
		стрТЗ.ГД=элем;
		стрТЗ.ТочкаНазначения=элем.ТочкаНазначения;
	КонецЦикла;
	тзТочки=тз.Скопировать(,"ТочкаНазначения");
	тзТочки.Свернуть("ТочкаНазначения");
	Для каждого стр из тзТочки Цикл
		массСтрок=тз.НайтиСтроки(новый Структура("ТочкаНазначения",стр.ТочкаНазначения));
		СписокЗаказов=Новый СписокЗначений;
		Для каждого стр из массСтрок Цикл
			СписокЗаказов.Добавить(стр.ГД);
		КонецЦикла;	
		СписокЗаказов.ЗагрузитьЗначения(массСтрок);
		обОтчетОДоставке=ДанныеФормыВЗначение(обОтчетОДоставкеСформы,Тип("ДокументОбъект.ОтчетОДоставке"));
		обОтчетОДоставке.Дата=ТекущаяДата();
		обОтчетОДоставке.ГруппыДоставки=Истина;
		обОтчетОДоставке.ЗаполнитьПоСпискуКоробок(СписокЗаказов);
		обОтчетОДоставке.ВидОперации=Перечисления.ВидыОперацийОтчетОДоставке.Доставлен;
		обОтчетОДоставке.ДатаДоставки=ТекущаяДата();
		ЗначениеВДанныеФормы(обОтчетОДоставке,обОтчетОДоставкеСформы);
	КонецЦикла
КонецПроцедуры

&НаКлиенте
Процедура СформироватьОтчетОДоставке(Команда)
	МассДляОтправления=Элементы.СписокГД.ВыделенныеСтроки;
	
	Фрм=ПолучитьФорму("Документ.ОтчетОДоставке.Форма.ФормаДокумента",,ЭтаФорма);
	обОтчетОДоставкеСформы=фрм.Объект;	
	СформироватьОтчетОДоставкеНаСервере(обОтчетОДоставкеСформы,МассДляОтправления);
	КопироватьДанныеФормы(обОтчетОДоставкеСформы,фрм.объект);
	фрм.Открыть();
КонецПроцедуры


&НаСервере
Функция СформироватьВозвратНаСервере(ДанныеФормы,ГруппаДоставки)
	объектВозврата = Обработки.ОбъединеннаяДоставкаГрузов.ОформитьВозвратГруппыВстатусеЗапросОплаты(ГруппаДоставки);
	Если объектВозврата = Неопределено Тогда
		возврат ложь;
	КонецЕсли;	
	ЗначениеВДанныеФормы(объектВозврата,ДанныеФормы);
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура СформироватьВозврат(Команда)
	Фрм=ПолучитьФорму("Документ.ВозвратПокупокОрганизатору.Форма.ФормаДокумента",,ЭтаФорма);
	ДанныеФормы=фрм.Объект;	
	Группа = Элементы.СписокГД.ВыделенныеСтроки[0];
	Если СформироватьВозвратНаСервере(ДанныеФормы,Группа) Тогда
		КопироватьДанныеФормы(ДанныеФормы,фрм.объект);
		фрм.Открыть();
	Конецесли;
КонецПроцедуры
#КонецОбласти


#Область УстановитьМетодОплатыНаложенныйПлатеж
&НаКлиенте
Процедура УстановитьМетодОплатыНаложенныйПлатеж(Команда)
	МассДляОтправления=Элементы.СписокГД.ВыделенныеСтроки;
	Если МассДляОтправления.Количество()>1 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Устанавливать ""Наложенный платеж"" возможно только по одной ""Группе доставки""!");
		Возврат;
	КонецЕсли; 	
	Если МассДляОтправления.Количество()=1 Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос("Продолжить выполнение операции?", Режим, 0);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли; 
		группа = МассДляОтправления[0];
		СтоСПОбмен_ГруппыДоставки.УстановитьНаложенныйПлатеж(группа);
 		ОповеститьОбИзменении(группа);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ЗаменаАдрессаГруппыДоставки
&НаКлиенте
Процедура ИзменитьАдресУГруппыДоставки(Команда)
	МассДляОтправления=Элементы.СписокГД.ВыделенныеСтроки;
	Если МассДляОтправления.Количество()>1 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Менять адрес возможно только по одной ""Группе доставки""!");
		Возврат;
	КонецЕсли; 	
	Если МассДляОтправления.Количество()=1 Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос("У участника появится возможност поменять параметры доставки в личном кабинете.Продолжить выполнение операции?", Режим, 0);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли; 
		группа = МассДляОтправления[0];
		СтоСПОбмен_ГруппыДоставки.ИзменитьАдресГруппыДоставки(группа);
 		ОповеститьОбИзменении(группа);
	КонецЕсли;

КонецПроцедуры


#КонецОбласти

#КонецОбласти







#Область ОдиночныеЗаказы

Процедура Обновить_ТЗ_ОдиночныеЗаказы()
	Элементы.ОдиночныеЗаказы.Обновить();
	Элементы.ОдиночныеЗаказы_КОтгрузке.Обновить();
КонецПроцедуры


&НаКлиенте
Процедура ОбновитьОдиночныеЗаказы(Команда)
	Обновить_ТЗ_ОдиночныеЗаказы();
КонецПроцедуры


&НаКлиенте
Процедура Оформить_ОдиночныеЗаказы(Команда)
	ОдиночныеЗаказы_Выбор.Очистить();
	
	Если Элементы.ОдиночныеЗаказы.ВыделенныеСтроки.Количество()=0 Тогда Возврат КонецЕсли;
	ПерваяСтрока		= Элементы.ОдиночныеЗаказы.ВыделенныеСтроки[0];
	ОсновнойУчастник	= Элементы.ОдиночныеЗаказы.ДанныеСтроки(ПерваяСтрока).Участник;
	ОсновнаяТочка		= Элементы.ОдиночныеЗаказы.ДанныеСтроки(ПерваяСтрока).Точка;
	Для каждого Стр Из Элементы.ОдиночныеЗаказы.ВыделенныеСтроки Цикл
		текущаяСтрока=Элементы.ОдиночныеЗаказы.ДанныеСтроки(Стр);
		Если текущаяСтрока.Участник<>ОсновнойУчастник Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Необходимо выделить заказы только одного участника!");
			Возврат;
		КонецЕсли;	
		стр_заказ=ОдиночныеЗаказы_Выбор.Добавить();
		ЗаполнитьЗначенияСвойств(стр_заказ,текущаяСтрока);
		стр_заказ.Подбор=Истина;
	КонецЦикла;	
	Если ПроверитьЗаказыНаВхождениеВГруппы() и ОдиночныеЗаказы_Выбор.Количество()>0 Тогда
		фрмОтправлениеТранзита=ПолучитьФорму("Документ.ОтправлениеТранзита.Форма.ФормаДокумента",новый Структура("Участник,ТочкаНазначения,Заказы",ОсновнойУчастник,ОсновнаяТочка,ОдиночныеЗаказы_Выбор),ЭтаФорма);
		фрмОтправлениеТранзита.Открыть();
	КонецЕсли;
КонецПроцедуры

Функция ПроверитьЗаказыНаВхождениеВГруппы()
	ТЗ = ДанныеФормыВЗначение(ОдиночныеЗаказы_Выбор, Тип("ТаблицаЗначений"));
	тз_Заказы=ТЗ.Скопировать(,"Покупка,Участник,МестоХранения,Габарит");
	Результат_Проверки=СтоСПОбмен_ГруппыДоставки.ЗаказыДругихТочек_ПроверитьЗаказы(тз_Заказы);
	Если не Результат_Проверки.Авторизация Тогда
		Возврат ложь;
	КонецЕсли;
	Для каждого стр из ОдиночныеЗаказы_Выбор Цикл
		отбор_Проверка=новый структура("Участник,Покупка",стр.Участник,стр.Покупка);
		масс_Строк=Результат_Проверки.ЗаказыБезГрупп.НайтиСтроки(отбор_Проверка);
		масс_Строк_СвоиГруппы=Результат_Проверки.ЗаказыВСвоихГруппах.НайтиСтроки(отбор_Проверка);
		Если  масс_Строк.Количество()= 0 и масс_Строк_СвоиГруппы.Количество()= 0  Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заказ покупка-"+стр.Покупка+", участник-"+стр.Участник+" Включен в группу доставки другой точки и был удален из отправления." );
			масс_Удалить=ОдиночныеЗаказы_Выбор.НайтиСтроки(отбор_Проверка);
			Для каждого стрУдалить из масс_Удалить Цикл
				ОдиночныеЗаказы_Выбор.Удалить(стрУдалить);
			КонецЦикла;
		КонецЕсли;	
	КонецЦикла;
	Возврат Истина;
КонецФункции


&НаКлиенте
Процедура Отгрузить_ОдиночныеЗаказы(Команда)
	МассДляОтправления=Элементы.ОдиночныеЗаказы_КОтгрузке.ВыделенныеСтроки;
	
	Фрм=ПолучитьФорму("Документ.ВыдачаТранзита.Форма.ФормаДокумента",,ЭтаФорма);
	обВыдачаТранзитаСформы=фрм.Объект;	
	СформироватьВыдачуТранзитаНаСервере(обВыдачаТранзитаСформы,МассДляОтправления);
	КопироватьДанныеФормы(обВыдачаТранзитаСформы,фрм.объект);
	фрм.Открыть();

	
КонецПроцедуры


&НаСервере
Процедура ЗаполнитьЗаказыВнеГрупп(ДанныеФормы)
	обДТ=ДанныеФормыВЗначение(ДанныеФормы,Тип("ДокументОбъект.ДвижениеТранзита"));
	обДТ.ЗаполнитьЗаказамиДруихТочек();
	ЗначениеВДанныеФормы(обДТ,ДанныеФормы);
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьЗаказыВнеГрупп(Команда)
	форма=ПолучитьФорму("Документ.ДвижениеТранзита.Форма.ФормаДокумента");
	ДанныеФормы = Форма.Объект;
	ЗаполнитьЗаказыВнеГрупп(ДанныеФормы);
	Если ДанныеФормы.ПокупкиТранзит.Количество()>0 Тогда
		КопироватьДанныеФормы(ДанныеФормы, Форма.Объект);
		форма.Открыть();
	КонецЕсли;
	Обновить_ТЗ_ОдиночныеЗаказы();
КонецПроцедуры

&НаСервере
Функция ВернутьСтатусЗапросОплатыНаСервере(группа)
	НачатьТранзакцию();
	об_отпр=группа.ОтправлениеТранзита.ПолучитьОбъект();
	об_отпр.Дата=об_отпр.Дата+1;
	об_отпр.Записать(РежимЗаписиДокумента.Проведение);
	
	СписокГрупп = СтоСПОбмен_ГруппыДоставки.ВернутьГруппеСтатусЗапросОплаты(Группа);
	ЗафиксироватьТранзакцию();
	Возврат СписокГрупп;
КонецФункции

&НаКлиенте
Процедура ВернутьСтатусЗапросОплаты(Команда)
	МассДляОтправления=Элементы.СписокГД.ВыделенныеСтроки;
	Если МассДляОтправления.Количество()>1 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Вернуть статус в  ""Запрос оплаты"" возможно только по одной ""Группе доставки""!");
		Возврат;
	КонецЕсли; 	
	Если МассДляОтправления.Количество()=1 Тогда
		Режим = РежимДиалогаВопрос.ДаНет;
		Ответ = Вопрос("Продолжить выполнение операции?", Режим, 0);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Возврат;
		КонецЕсли; 
		СписокГрупп = ВернутьСтатусЗапросОплатыНаСервере(МассДляОтправления[0]);
		Если СписокГрупп <> Неопределено Тогда 
			Для каждого элем из СписокГрупп Цикл
				ОповеститьОбИзменении(элем.Значение);
			КонецЦикла;
		КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ДтКТ_ОдиночныеЗаказы(Команда)
	фрм=ПолучитьФорму("РегистрНакопления.Транзит.ФормаСписка",новый Структура("ДляОтбора",Элементы.ОдиночныеЗаказы.ТекущиеДанные),ЭтаФорма);
	фрм.Открыть();
КонецПроцедуры



#КонецОбласти


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.СписокГД);
КонецПроцедуры
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.СписокГД, Результат);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.СписокГД);
КонецПроцедуры


// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
