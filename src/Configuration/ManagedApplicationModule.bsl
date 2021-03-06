
// СтандартныеПодсистемы

// Хранилище глобальных переменных.
//
// ПараметрыПриложения - Соответствие - хранилище переменных, где:
//   * Ключ - Строка - имя переменной в формате "ИмяБиблиотеки.ИмяПеременной";
//   * Значение - Произвольный - значение переменной.
//
// Инициализация (на примере СообщенияДляЖурналаРегистрации):
//   ИмяПараметра = "СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации";
//   Если ПараметрыПриложения[ИмяПараметра] = Неопределено Тогда
//     ПараметрыПриложения.Вставить(ИмяПараметра, Новый СписокЗначений);
//   КонецЕсли;
//  
// Использование (на примере СообщенияДляЖурналаРегистрации):
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"].Добавить(...);
//   ПараметрыПриложения["СтандартныеПодсистемы.СообщенияДляЖурналаРегистрации"] = ...;
Перем ПараметрыПриложения Экспорт;

// Конец СтандартныеПодсистемы




//РаботаСВнешнимОборудованием
Перем глПодключаемоеОборудование Экспорт; // для кэширования на клиенте
Перем глПодключаемоеОборудованиеСобытиеОбработано Экспорт; // для предотвращения повторной обработки события
Перем глДоступныеТипыОборудования Экспорт;
//Конец РаботаСВнешнимОборудованием


Перем глКомпонентаОбменаСМобильнымиПриложениями Экспорт;
// СтандартныеПодсистемы

// СтандартныеПодсистемы.БазоваяФункциональность

// СписокЗначений для накапливания пакета сообщений в журнал регистрации, 
// формируемых в клиентской бизнес-логике.
Перем СообщенияДляЖурналаРегистрации Экспорт; 
// Признак того, что в данном сеансе не нужно повторно предлагать установку
Перем ПредлагатьУстановкуРасширенияРаботыСФайлами Экспорт;
// Признак того, что в данном сеансе не нужно запрашивать стандартное подтверждение при выходе
Перем ПропуститьПредупреждениеПередЗавершениемРаботыСистемы Экспорт;
// Структура параметров, используемая в процессе запуска и завершения программы.
Перем ПараметрыПриЗапускеИЗавершенииПрограммы Экспорт;
// Структура параметров подтверждения закрытия формы.
Перем ПараметрыПодтвержденияЗакрытияФормы Экспорт;
// Оповещение при подтверждении запроса внешних ресурсов.
Перем ОповещениеПриПримененииЗапросовНаИспользованиеВнешнихРесурсов Экспорт;

// Конец СтандартныеПодсистемы.БазоваяФункциональность

// СтандартныеПодсистемы.ЗавершениеРаботыПользователей
Перем ПараметрыЗавершенияРаботыПользователей Экспорт;
// Конец СтандартныеПодсистемы.ЗавершениеРаботыПользователей

// СтандартныеПодсистемы.ОбновлениеКонфигурации

// Информация о доступном обновлении конфигурации, обнаруженном в Интернете
// при запуске программы.
Перем ДоступноеОбновлениеКонфигурации Экспорт;
// Структура с параметрами помощника обновления конфигурации.
Перем НастройкиОбновленияКонфигурации Экспорт; 
// Признак необходимости обновления конфигурации информационной базы при завершении сеанса.
Перем ПредлагатьОбновлениеИнформационнойБазыПриЗавершенииСеанса Экспорт;
// Конец СтандартныеПодсистемы.ОбновлениеКонфигурации

// СтандартныеПодсистемы.РаботаСФайлами
Перем КомпонентаTwain Экспорт; // Twain компонента для работы со сканером
// Конец СтандартныеПодсистемы.РаботаСФайлами

// СтандартныеПодсистемы.ФайловыеФункции
// Признак того, что в данном сеансе не нужно повторно делать проверку доступа к каталогу на диске
Перем ПроверкаДоступаКРабочемуКаталогуВыполнена Экспорт;
// Конец СтандартныеПодсистемы.ФайловыеФункции

// СтандартныеПодсистемы.РезервноеКопированиеИБ

// Параметры для резервного копирования
Перем ПараметрыРезервногоКопированияИБ Экспорт;

// Конец СтандартныеПодсистемы.РезервноеКопированиеИБ

// СтандартныеПодсистемы.ОценкаПроизводительности
Перем ОценкаПроизводительностиЗамерВремени Экспорт;
// Конец СтандартныеПодсистемы.ОценкаПроизводительности

// СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса
//Перем ПредлагатьСинхронизироватьДанныеСПриложениемВИнтернетеПриЗавершенииСеанса Экспорт;
// Конец СтандартныеПодсистемы.РаботаВМоделиСервиса.ОбменДаннымиВМоделиСервиса

// Конец СтандартныеПодсистемы




Процедура ПередНачаломРаботыСистемы()
	
	// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПередНачаломРаботыСистемы();
	// Конец СтандартныеПодсистемы

	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПередНачаломРаботыСистемы();
	// Конец ПодключаемоеОборудование
	
	аспПроцедурыОбменаДанными.ЗаполнениеКонстант();

КонецПроцедуры

Процедура ПриНачалеРаботыСистемы()
		// СтандартныеПодсистемы
	СтандартныеПодсистемыКлиент.ПриНачалеРаботыСистемы();
	//аСПОбновлениеСервер.ВключитьРегламентныеЗаданияНаСервере();
		
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПриНачалеРаботыСистемы();
	// Конец ПодключаемоеОборудование

	ПодключитьОбработчикОповещения("глОбработкаОповещения");
	
    ПодключитьОбработчикОжидания("ПроверитьГруппыДоставки",60*60);
    
КонецПроцедуры





Процедура глОбработкаОповещения(Событие, Параметр, Источник) Экспорт
	Если 	Событие 						= "ScanData" 				 и
			Источник 						= "ПодключаемоеОборудование" и
			Параметр.Найти("Обработано") 	= Неопределено					Тогда
			
			ШК 			= СтоСП_Клиент.ПолучитьШКизПараметров(Параметр);
			Если ШК = "" Тогда
				Возврат
			КонецЕсли;
			ДанныеШК    = СП_Штрихкоды.ПолучитьДанныеПоШК(ШК);
			Если ДанныеШК = Неопределено Тогда Возврат; КонецЕсли;
			
			Если Строка(ДанныеШК.Тип) 		= "Сотрудник (55)"      		Тогда	
				//ОткрытьЗначение(ДанныеШК.Сотрудник);
			ИначеЕсли Строка(ДанныеШК.Тип) 	= "Номенклатура (61)"      		Тогда	
				док				= СП_РаботаСДокументами.СформироватьДокумент_Продажа(ДанныеШК.Номенклатура);
				ОткрытьЗначение(док);
			ИначеЕсли Строка(ДанныеШК.Тип) 	= "Габарит (62)"      			Тогда	
				ОткрытьЗначение(ДанныеШК.Габарит);
			ИначеЕсли Строка(ДанныеШК.Тип) 	= "Место хранения (63)"     	Тогда	
				ОткрытьЗначение(ДанныеШК.МестоХранения);
			ИначеЕсли Строка(ДанныеШК.Тип) 	= "Пункт выдачи (64)" и ДанныеШК.Действие = "Открыть Выдачу транзита"	    Тогда	
				форма		= ПолучитьФорму("Документ.ВыдачаТранзита.Форма.ФормаДокумента");
				ДанныеФормы = Форма.Объект;
				СП_РаботаСДокументами.ЗаполнитьФорму(ДанныеФормы, Новый Структура("ТочкаНазначения, 	 ТочкаТранзита",
																				   ДанныеШК.ПунктВыдачи, ДанныеШК.ПунктВыдачи));
				КопироватьДанныеФормы(ДанныеФормы, Форма.Объект);
				форма.Открыть();
			ИначеЕсли Строка(ДанныеШК.Тип) 	= "Пункт выдачи (64)"  и ДанныеШК.Действие = "Открыть Формирование коробки"     Тогда	
				форма		= ПолучитьФорму("Документ.ФормированиеКоробки.Форма.ФормаДокумента");
				ДанныеФормы = Форма.Объект;
				СП_РаботаСДокументами.ЗаполнитьФорму(ДанныеФормы, Новый Структура("ТочкаНазначения", ДанныеШК.ПунктВыдачи));
				КопироватьДанныеФормы(ДанныеФормы, Форма.Объект);
				форма.Открыть();
			ИначеЕсли Строка(ДанныеШК.Тип) 	= "Действие по ШК (66)"    	Тогда	
				Если ДанныеШК.Действие = "РазборКоробкиБезКоробки" Тогда	
					СП_РаботаСДокументами_Клиент.ОткрытьФорму_РазборКоробки(ДанныеШК);
				Иначе
					ОткрытьЗначение(ДанныеШК.Функция);
				КонецЕсли;	
			ИначеЕсли Строка(ДанныеШК.Тип) 	= "Супергруппа (67)"		 	Тогда	
				
				Если ДанныеШК.ОткрыватьРазборКоробки Тогда
					СП_РаботаСДокументами_Клиент.ОткрытьФорму_РазборКоробки(ДанныеШК);						
				Иначе	
					форма				= ПолучитьФорму("Документ.РегистрацияСупперГруппы.Форма.ФормаДокумента");
					ДанныеФормы 		= Форма.Объект;
					стр					= Форма.Объект.Группы.Добавить();
					стр.СупперГруппа	= ДанныеШК.Супергруппа;
					форма.Открыть();
				КонецЕсли;
			ИначеЕсли Строка(ДанныеШК.Тип) 	= "Расходная (68)"    	Тогда
				ПараметрыФормы =новый Структура;
				ПараметрыФормы.Вставить("Ключ", ДанныеШК.Ссылка);
				ПараметрыФормы.Вставить("ОткрытьДляОплаты", Истина);
				ОткрытьФорму("Документ.Расходная.Форма.ФормаДокумента",ПараметрыФормы, ПолучитьОкна()[1].Содержимое[0]);
			ИначеЕсли Строка(ДанныеШК.Тип) 	= "Карта участника (22)"		Тогда
				Если ДанныеШК.Владелец =Неопределено Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Карта: "+ДанныеШК.КартаУчастника+" не привязана к участнику!");					
					возврат
				ИначеЕсли Строка(ДанныеШК.Статус) <>	"Зарегистрированна" Тогда
					ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Карта: "+ДанныеШК.КартаУчастника+" не в статусе Зарегестрированна! Текущий статус карты: "+ДанныеШК.Статус);					
					возврат										
				КонецЕсли;	
				СП_РаботаСДокументами_Клиент.ОткрытьФорму_Расходная(ДанныеШК);
			ИначеЕсли Строка(ДанныеШК.Тип) 	= "Карта участника (23)"		Тогда	
				СП_РаботаСДокументами_Клиент.ОткрытьФорму_Расходная(ДанныеШК);
			ИначеЕсли Строка(ДанныеШК.Тип) 	= "Посылка (12)"		 		Тогда	
				СП_РаботаСДокументами_Клиент.ОткрытьФорму_Приходная(ДанныеШК);
			ИначеЕсли Строка(ДанныеШК.Тип) 	= "Покупка (11)"				Тогда	
				СП_РаботаСДокументами_Клиент.ОткрытьФорму_Приходная(ДанныеШК);
			ИначеЕсли Строка(ДанныеШК.Тип) 	= "Заказ100маркета (33)"		Тогда	
				СП_РаботаСДокументами_Клиент.ОткрытьФорму_Приходная(ДанныеШК);
			ИначеЕсли Строка(ДанныеШК.Тип) 	= "Коробка (44)"				Тогда	
				Если ДанныеШК.КРазбору Тогда
					СП_РаботаСДокументами_Клиент.ОткрытьФорму_РазборКоробки(ДанныеШК);					
				Иначе	
					СП_РаботаСДокументами_Клиент.ОткрытьФорму_Приходная(ДанныеШК);
				КонецЕсли;	
			КонецЕсли;	
	КонецЕсли;
	
КонецПроцедуры





Процедура ПередЗавершениемРаботыСистемы(Отказ)
	
	СтандартныеПодсистемыКлиент.ПередЗавершениемРаботыСистемы(Отказ);
	
	// ПодключаемоеОборудование
	МенеджерОборудованияКлиент.ПередЗавершениемРаботыСистемы();
	// Конец ПодключаемоеОборудование	
КонецПроцедуры

Процедура ОбработкаВнешнегоСобытия(Источник, Событие, Данные)
	
	глПодключаемоеОборудованиеСобытиеОбработано = Ложь;
	// ПодключаемоеОборудование
	// Подготовить данные
	
 	ОписаниеСобытия = Новый Структура();
	ОписаниеОшибки  = "";
	
	ОписаниеСобытия.Вставить("Источник", Источник);
	ОписаниеСобытия.Вставить("Событие",  Событие);
	ОписаниеСобытия.Вставить("Данные",   Данные);
	
	// Передать на обработку данные.
	Результат = МенеджерОборудованияКлиент.ОбработатьСобытиеОтУстройства(ОписаниеСобытия, ОписаниеОшибки);
	Если Не Результат Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='При обработке внешнего события от устройства произошла ошибка.'")
		                                                 + Символы.ПС + ОписаниеОшибки);
	КонецЕсли;
	// Конец ПодключаемоеОборудование
	
	
	
КонецПроцедуры



глПодключаемоеОборудованиеСобытиеОбработано = Ложь;























































































