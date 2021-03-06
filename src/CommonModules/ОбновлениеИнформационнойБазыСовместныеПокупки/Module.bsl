////////////////////////////////////////////////////////////////////////////////
// Обновление информационной базы библиотеки СтандартныеПодсистемы (БСП).
//
////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

////////////////////////////////////////////////////////////////////////////////
// Сведения о библиотеке (или конфигурации).

// Заполняет основные сведения о библиотеке или основной конфигурации.
// Библиотека, имя которой имя совпадает с именем конфигурации в метаданных, определяется как основная конфигурация.
// 
// Параметры:
//  Описание - Структура - сведения о библиотеке:
//
//   * Имя                 - Строка - имя библиотеки, например, "СтандартныеПодсистемы".
//   * Версия              - Строка - версия в формате из 4-х цифр, например, "2.1.3.1".
//
//   * ТребуемыеПодсистемы - Массив - имена других библиотек (Строка), от которых зависит данная библиотека.
//                                    Обработчики обновления таких библиотек должны быть вызваны ранее
//                                    обработчиков обновления данной библиотеки.
//                                    При циклических зависимостях или, напротив, отсутствии каких-либо зависимостей,
//                                    порядок вызова обработчиков обновления определяется порядком добавления модулей
//                                    в процедуре ПриДобавленииПодсистем общего модуля
//                                    ПодсистемыКонфигурацииПереопределяемый.
//
Процедура ПриДобавленииПодсистемы(Описание) Экспорт
	
	Описание.Имя    = "СовместныеПокупки";
	Описание.Версия = "3.6.1.1";
	
	// Требуется библиотека стандартных подсистем.
//	Описание.ТребуемыеПодсистемы.Добавить("СтандартныеПодсистемы");
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Обработчики обновления информационно4й базы.

// Добавляет в список процедуры-обработчики обновления данных ИБ
// для всех поддерживаемых версий библиотеки или конфигурации.
// Вызывается перед началом обновления данных ИБ для построения плана обновления.
//
//  Обработчики - ТаблицаЗначений - описание полей, см. в процедуре.
//                ОбновлениеИнформационнойБазы.НоваяТаблицаОбработчиковОбновления.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.Версия              = "1.1.0.0";
//  Обработчик.Процедура           = "ОбновлениеИБ.ПерейтиНаВерсию_1_1_0_0";
//  Обработчик.РежимВыполнения     = "Монопольно";
//
Процедура ПриДобавленииОбработчиковОбновления(Обработчики) Экспорт
	
	// Обработчики этого события для подсистем БСП добавляются через подписку на служебное событие:
	// "СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПриДобавленииОбработчиковОбновления".
	//
	// Процедуры обработки этого события всех подсистем БСП имеют то же имя, что и эта процедура,
	// но размещены в своих подсистемах.
	// Чтобы найти процедуры можно выполнить глобальный поиск по имени процедуры.
	// Чтобы найти модули в которых размещены процедуры, можно выполнить поиск по имени события.
	
	
	#Область НачальноеЗаполнение

	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "";
	Обработчик.НачальноеЗаполнение = Истина;
	Обработчик.РежимВыполнения = "Монопольно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыСовместныеПокупки.ПервыйЗапуск";
	Обработчик.Комментарий = НСтр("ru = 'Иницализация настроек программы при первом запуске.'");
	
	#КонецОбласти
	
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.3.7.3";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыСовместныеПокупки.ОбновитьПредопределенныеТарифыТК";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет тарифы ТК'");
	Обработчик.ВыполнятьВГруппеОбязательных = Истина;
	Обработчик.Приоритет = 99;
	
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.3.7.3";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыСовместныеПокупки.ОбновитьКодыТочекРаздачи";
	Обработчик.Комментарий = НСтр("ru = 'Обновляет коды точек раздачи до 4 разрядов'");
	Обработчик.ВыполнятьВГруппеОбязательных = Истина;
	Обработчик.Приоритет = 99;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.3.7.3";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыСовместныеПокупки.ОбновитьГородаСДЭК";
	Обработчик.Комментарий = НСтр("ru = 'Добовляет основные города СДЭК'");
	Обработчик.ВыполнятьВГруппеОбязательных = Истина;
	Обработчик.Приоритет = 99;
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "3.3.7.10";
	Обработчик.РежимВыполнения = "Отложенно";
	Обработчик.Процедура = "ОбновлениеИнформационнойБазыСовместныеПокупки.ОбновлениеНаВерсию_3_3_7_10";
	Обработчик.Комментарий = НСтр("ru = 'Заполняем тип мегоордера'");
	
	//Обработчик = Обработчики.Добавить();
	//Обработчик.Версия = "3.4.1.1";
	//Обработчик.РежимВыполнения = "Отложенно";
	//Обработчик.Процедура = "ОбновлениеИнформационнойБазыСовместныеПокупки.ОбновлениеНаВерсию_3_4_1_1";
	//Обработчик.Комментарий = НСтр("ru = 'Увеличиваем разрядность групповых стикеров до 10'");
	//
	
	
	ВариантыОтчетов.ДобавитьОбработчикиПолногоОбновления(Обработчики, "0.0.0.8");
	
КонецПроцедуры

// Вызывается перед процедурами-обработчиками обновления данных ИБ.
//
Процедура ПередОбновлениемИнформационнойБазы() Экспорт
	
	//// Обработчики этого события для подсистем БСП добавляются через подписку на служебное событие:
	//// "СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПередОбновлениемИнформационнойБазы".
	////
	//// Процедуры обработки этого события всех подсистем БСП имеют то же имя, что и эта процедура,
	//// но размещены в своих подсистемах.
	//// Чтобы найти процедуры можно выполнить глобальный поиск по имени процедуры.
	//// Чтобы найти модули в которых размещены процедуры, можно выполнить поиск по имени события.
	//
	//ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
	//	"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПередОбновлениемИнформационнойБазы");
	//
	//Для каждого Обработчик Из ОбработчикиСобытия Цикл
	//	Если Обработчик.Подсистема <> "СтандартныеПодсистемы" Тогда
	//		Продолжить;
	//	КонецЕсли;
	//	Обработчик.Модуль.ПередОбновлениемИнформационнойБазы();
	//КонецЦикла;
	
КонецПроцедуры

// Вызывается после завершения обновления данных ИБ.
// 
// Параметры:
//   ПредыдущаяВерсия       - Строка - версия до обновления. "0.0.0.0" для "пустой" ИБ.
//   ТекущаяВерсия          - Строка - версия после обновления.
//   ВыполненныеОбработчики - ДеревоЗначений - список выполненных процедур-обработчиков обновления,
//                                             сгруппированных по номеру версии.
//   ВыводитьОписаниеОбновлений - Булево - если установить Истина, то будет выведена форма
//                                с описанием обновлений. По умолчанию, Истина.
//                                Возвращаемое значение.
//   МонопольныйРежим           - Булево - Истина, если обновление выполнялось в монопольном режиме.
//
// Пример обхода выполненных обработчиков обновления:
//
//	Для Каждого Версия Из ВыполненныеОбработчики.Строки Цикл
//		
//		Если Версия.Версия = "*" Тогда
//			// Обработчик, который может выполнятся при каждой смене версии.
//		Иначе
//			// Обработчик, который выполняется для определенной версии.
//		КонецЕсли;
//		
//		Для Каждого Обработчик Из Версия.Строки Цикл
//			...
//		КонецЦикла;
//		
//	КонецЦикла;
//
Процедура ПослеОбновленияИнформационнойБазы(Знач ПредыдущаяВерсия, Знач ТекущаяВерсия,
		Знач ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим) Экспорт
	
	//// Вызываем процедуры-обработчики служебного события "ПослеОбновленияИнформационнойБазы".
	//// (Для быстрого перехода к процедурам-обработчикам выполнить глобальный поиск по имени события.).
	//ОбработчикиСобытия = ОбщегоНазначения.ОбработчикиСлужебногоСобытия(
	//	"СтандартныеПодсистемы.ОбновлениеВерсииИБ\ПослеОбновленияИнформационнойБазы");
	//
	//Для каждого Обработчик Из ОбработчикиСобытия Цикл
	//	Если Обработчик.Подсистема <> "СтандартныеПодсистемы" Тогда
	//		Продолжить;
	//	КонецЕсли;
	//	Обработчик.Модуль.ПослеОбновленияИнформационнойБазы(ПредыдущаяВерсия, ТекущаяВерсия,
	//		ВыполненныеОбработчики, ВыводитьОписаниеОбновлений, МонопольныйРежим);
	//КонецЦикла;
	
КонецПроцедуры

// Вызывается при подготовке табличного документа с описанием изменений в программе.
//
// Параметры:
//   Макет - ТабличныйДокумент - описание обновления всех библиотек и конфигурации.
//           Макет можно дополнить или заменить.
//           См. также общий макет ОписаниеИзмененийСистемы.
//
Процедура ПриПодготовкеМакетаОписанияОбновлений(Знач Макет) Экспорт
	
КонецПроцедуры




// Добавляет в список процедуры-обработчики перехода с другой программы (с другим именем конфигурации).
// Например, для перехода между разными, но родственными конфигурациями: базовая -> проф -> корп.
// Вызывается перед началом обновления данных ИБ.
//
// Параметры:
//  Обработчики - ТаблицаЗначений - с колонками:
//    * ПредыдущееИмяКонфигурации - Строка - имя конфигурации, с которой выполняется переход;
//                                           или "*", если нужно выполнять при переходе с любой конфигурации.
//    * Процедура                 - Строка - полное имя процедуры-обработчика перехода с программы
//                                           ПредыдущееИмяКонфигурации.
//                                  Например, "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику"
//                                  Обязательно должна быть экспортной.
//
// Пример добавления процедуры-обработчика в список:
//  Обработчик = Обработчики.Добавить();
//  Обработчик.ПредыдущееИмяКонфигурации  = "УправлениеТорговлей";
//  Обработчик.Процедура                  = "ОбновлениеИнформационнойБазыУПП.ЗаполнитьУчетнуюПолитику";
//
Процедура ПриДобавленииОбработчиковПереходаСДругойПрограммы(Обработчики) Экспорт
	
	//Обработчик = Обработчики.Добавить();
	//Обработчик.ПредыдущееИмяКонфигурации = "БиблиотекаСтандартныхПодсистемДемоБазовая";
	//Обработчик.Процедура = "_ДемоОбновлениеИнформационнойБазыБСП.ПерейтиСБазовойВерсииНаПРОФ";
	
КонецПроцедуры
// Позволяет переопределить режим обновления данных информационной базы.
// Для использования в редких (нештатных) случаях перехода, не предусмотренных в
// стандартной процедуре определения режима обновления.
//
// Параметры:
//   РежимОбновленияДанных - Строка - в обработчике можно присвоить одно из значений:
//              "НачальноеЗаполнение"     - если это первый запуск пустой базы (области данных);
//              "ОбновлениеВерсии"        - если выполняется первый запуск после обновление конфигурации базы данных;
//              "ПереходСДругойПрограммы" - если выполняется первый запуск после обновление конфигурации базы данных, 
//                                          в которой изменилось имя основной конфигурации.
//
//   СтандартнаяОбработка  - Булево - если присвоить Ложь, то стандартная процедура
//                                    определения режима обновления не выполняется, 
//                                    а используется значение РежимОбновленияДанных.
//
Процедура ПриОпределенииРежимаОбновленияДанных(РежимОбновленияДанных, СтандартнаяОбработка) Экспорт
	
КонецПроцедуры
// Вызывается после выполнения всех процедур-обработчиков перехода с другой программы (с другим именем конфигурации),
// и до начала выполнения обновления данных ИБ.
//
// Параметры:
//  ПредыдущееИмяКонфигурации    - Строка - имя конфигурации до перехода.
//  ПредыдущаяВерсияКонфигурации - Строка - имя предыдущей конфигурации (до перехода).
//  Параметры                    - Структура - 
//    * ВыполнитьОбновлениеСВерсии   - Булево - по умолчанию Истина. Если установить Ложь, 
//        то будут выполнена только обязательные обработчики обновления (с версией "*").
//    * ВерсияКонфигурации           - Строка - номер версии после перехода. 
//        По умолчанию, равен значению версии конфигурации в свойствах метаданных.
//        Для того чтобы выполнить, например, все обработчики обновления с версии ПредыдущаяВерсияКонфигурации, 
//        следует установить значение параметра в ПредыдущаяВерсияКонфигурации.
//        Для того чтобы выполнить вообще все обработчики обновления, установить значение "0.0.0.1".
//    * ОчиститьСведенияОПредыдущейКонфигурации - Булево - по умолчанию Истина. 
//        Для случаев когда предыдущая конфигурация совпадает по имени с подсистемой текущей конфигурации, следует
//        указать Ложь.
//
Процедура ПриЗавершенииПереходаСДругойПрограммы(Знач ПредыдущееИмяКонфигурации, 
	Знач ПредыдущаяВерсияКонфигурации, Параметры) Экспорт
	//
	//Если ПредыдущееИмяКонфигурации = "ПредыдущееИмяКонфигурацииБазовая" Тогда
	//	Параметры.ВерсияКонфигурации = ПредыдущаяВерсияКонфигурации;
	//КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ПроцедурыОбработчиков

Процедура ПервыйЗапуск(раз="") Экспорт
	//МенеджерОборудованияВызовСервераПереопределяемый.ОбновлениеБиблиотеки();
КонецПроцедуры

Процедура ОбновитьИспользованиеНаборовСвойствКонтрагентов() Экспорт
	
	ПараметрыНабора = УправлениеСвойствами.СтруктураПараметровНабораСвойств();
	ПараметрыНабора.Используется = Истина;
	УправлениеСвойствами.УстановитьПараметрыНабораСвойств("Справочник_Контрагенты", ПараметрыНабора);
	
КонецПроцедуры

Процедура ОбновитьПредопределенныеТарифыТК(раз="") Экспорт
	Тариф136=Справочники.ТарифыТК.Тариф136.ПолучитьОбъект();	
	Тариф136.Наименование="Посылка склад-склад";
	Тариф136.КодТарифа="136";
	Тариф136.Примечание="Услуга экономичной доставки товаров по России для компаний, осуществляющих дистанционную торговлю.";
	тариф136.Ограничения="до 30 кг.";
	тариф136.Записать();
	
	Тариф302=Справочники.ТарифыТК.Тариф302.ПолучитьОбъект();
	Тариф302.Наименование="До постомата InPost склад-склад";
	Тариф302.КодТарифа="302";
	Тариф302.Примечание="Услуга доставки товаров по России с использованием постоматов. Для компаний, осуществляющих дистанционную торговлю.
							|Характеристики услуги:
							|- по услуге принимаются только одноместные заказы
							|- выбранный при оформлении заказа постомат изменить на другой нельзя
							|- при невозможности использования постоматов осуществляется доставка до ПВЗ СДЭК или «до двери» клиента с изменением тарификации на услугу «Посылка»
							|- срок хранения заказа в ячейке: 5 дней с момента закладки в постомат
							|- возможность приема наложенного платежа";
	Тариф302.Ограничения="3 вида ячеек:
							|А (8*38*64 см)— до 5 кг
							|В (19*38*64 см) — до 7 кг
							|С (41*38*64 см)— до 20 кг";
	Тариф302.Записать();
	
	
	Тариф137=Справочники.ТарифыТК.Тариф137.ПолучитьОбъект();
	Тариф137.Наименование="Посылка склад-дверь";
	Тариф137.КодТарифа="137";
	Тариф137.Примечание="Услуга экономичной доставки товаров по России для компаний, осуществляющих дистанционную торговлю. ";
	Тариф137.Ограничения="до 30 кг.";
	Тариф137.Записать();


КонецПроцедуры

Процедура ОбновитьКодыТочекРаздачи(раз="") Экспорт	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ТочкиРаздачи.Ссылка
		|ИЗ
		|	Справочник.ТочкиРаздачи КАК ТочкиРаздачи";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Если СтрДлина(ВыборкаДетальныеЗаписи.ссылка.код)=2 Тогда
			Попытка
				
				об=ВыборкаДетальныеЗаписи.ссылка.ПолучитьОбъект();
				об.код=Формат(Число(об.Код),"ЧЦ=4; ЧВН=; ЧГ=0");
				об.записать();
			Исключение
			
			КонецПопытки;
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры	

Процедура ОбновитьГородаСДЭК(раз="") Экспорт
	Если не ЗначениеЗаполнено(Справочники.ГородаСДЭК.НайтиПоКоду("288")) Тогда
		элем=Справочники.ГородаСДЭК.СоздатьЭлемент();
		элем.Код="288";
		Элем.Наименование="Владивосток";
		элем.Записать();
	КонецЕсли;	
	
	Если не ЗначениеЗаполнено(Справочники.ГородаСДЭК.НайтиПоКоду("44")) Тогда
		элем=Справочники.ГородаСДЭК.СоздатьЭлемент();
		элем.Код="44";
		Элем.Наименование="Москва";
		элем.Записать();
	КонецЕсли;	
	
	Если не ЗначениеЗаполнено(Справочники.ГородаСДЭК.НайтиПоКоду("435")) Тогда
		элем=Справочники.ГородаСДЭК.СоздатьЭлемент();
		элем.Код="435";
		Элем.Наименование="Краснодар";
		элем.Записать();
	КонецЕсли;	
	
КонецПроцедуры

Процедура ОбновлениеНаВерсию_3_3_7_10(Параметры) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Мегаордера.Ссылка КАК Ссылка,
		|	ПОДСТРОКА(Мегаордера.Код, 1, 2) КАК типМО
		|ИЗ
		|	Справочник.Мегаордера КАК Мегаордера
		|ГДЕ
		|	Мегаордера.типМегаордера = ЗНАЧЕНИЕ(Перечисление.типМегаордера.ПустаяСсылка)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Выборка = РезультатЗапроса.Выбрать();
	
	параметры.ПрогрессВыполнения.ВсегоОбъектов 		= Выборка.Количество();
	параметры.ПрогрессВыполнения.обработаноОбъектов	= 0;
	Пока Выборка.Следующий() Цикл
		мегаордерОбъект = Выборка.Ссылка.ПолучитьОбъект();
		
		Если Выборка.ТипМО = "11" Тогда
			мегаордерОбъект.типМегаордера = Перечисления.типМегаордера.Покупка;
		ИначеЕсли Выборка.ТипМО = "12" Тогда	
			мегаордерОбъект.типМегаордера = Перечисления.типМегаордера.Посылка;
			мегаордерОбъект.Посылка = мегаордерОбъект.Покупка;
		ИначеЕсли Выборка.ТипМО = "44" Тогда	
			мегаордерОбъект.типМегаордера = Перечисления.типМегаордера.Коробка;
			мегаордерОбъект.Коробка = мегаордерОбъект.Покупка;
		КонецЕсли;	
		ОбновлениеИнформационнойБазы.ЗаписатьОбъект(мегаордерОбъект);
		параметры.ПрогрессВыполнения.обработаноОбъектов = параметры.ПрогрессВыполнения.обработаноОбъектов + 1;
	КонецЦикла;
КонецПроцедуры	


Процедура ОбновлениеНаВерсию_3_4_1_1(Параметры) Экспорт
	
	//Запрос = Новый Запрос;
	//Запрос.Текст = 
	//	"ВЫБРАТЬ
	//	|	Коробки.Ссылка КАК Ссылка
	//	|ИЗ
	//	|	Справочник.Коробки КАК Коробки
	//	|ГДЕ
	//	|	Коробки.ВидСтикера = &ВидСтикера
	//	|
	//	|УПОРЯДОЧИТЬ ПО
	//	|	Коробки.Код УБЫВ";
	//
	//Запрос.УстановитьПараметр("ВидСтикера", Перечисления.ВидыСтикеров.ГС);
	//
	//РезультатЗапроса = Запрос.Выполнить();
	//
	//Выборка = РезультатЗапроса.Выбрать();
	//кол = 1;
	//Пока Выборка.Следующий() Цикл
	//	Если СтрДлина(Выборка.Ссылка.Код) = 10 Тогда Продолжить; КонецЕсли;
	//	объект_Коробка 		= Выборка.Ссылка.ПолучитьОбъект();
	//	объект_Коробка.код	= Формат(Число(объект_Коробка.код),"ЧЦ=10; ЧВН=; ЧГ=0");
	//	Попытка
	//		объект_Коробка.Записать()
	//	Исключение
	//	КонецПопытки;
	//	кол = кол + 1;
	//КонецЦикла;

КонецПроцедуры	

#КонецОбласти       



//Процедура ОбновитьПоставляемыеДрайвера() Экспорт
//	//МенеджерОборудованияВызовСервераПереопределяемый.ОбновлениеБиблиотеки();
//КонецПроцедуры

