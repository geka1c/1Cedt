

&НаКлиенте
Процедура ПометитьВсе(Команда)
	Если Элементы.ЗаказыНаСкладе.ТолькоПросмотр Тогда Возврат; КонецЕсли;
	Для каждого стр из Объект.ЗаказыНаСкладе Цикл
		стр.Подбор=Истина;
	КонецЦикла;	
	//УстановитьКоличествоПомеченныхСтрок();
КонецПроцедуры


&НаКлиенте
Процедура СнятьВыделениеВсе(Команда)
	Если Элементы.ЗаказыНаСкладе.ТолькоПросмотр Тогда Возврат; КонецЕсли;
	Для каждого стр из Объект.ЗаказыНаСкладе Цикл
		стр.Подбор=Ложь;
	КонецЦикла;
	//УстановитьКоличествоПомеченныхСтрок();
КонецПроцедуры

&НаКлиенте
Процедура ИнвертироватьВыделение(Команда)
	Если Элементы.ЗаказыНаСкладе.ТолькоПросмотр Тогда Возврат; КонецЕсли;
	Для каждого стр из Объект.ЗаказыНаСкладе Цикл
		стр.Подбор=не стр.Подбор;
	КонецЦикла;
	//УстановитьКоличествоПомеченныхСтрок();
КонецПроцедуры

&НаКлиенте
Процедура ВернутьОжиданиеСборки(Команда)
	ВернутьОжиданиеСборкиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВернутьОжиданиеСборкиНаСервере()
	Объект.СтатусДоставки = Перечисления.СтатусыДоставки.ОжидаетСборки;
КонецПроцедуры


Функция  ПолучитьКомандуПечати(ИмяКоманды)
	
	Для каждого ком из ЭтаФорма.Команды Цикл
		Если ком.Заголовок=ИмяКоманды Тогда
			Возврат ком.Имя;
		КонецЕсли;
	КонецЦикла;	
КонецФункции


&НаКлиенте
Процедура ОбновитьЗаказыНаСкладе(Команда)
	ОбновитьЗаказыНаСкладеНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	СП_РаботаСДокументами.ПриСозданииНаСервере(ЭтотОбъект);
	ПодсветкаСтрок();
		
	Если Объект.ЗаказыНаСкладе.Количество() = 0 и 
			  (			Объект.СтатусДоставки = Перечисления.СтатусыДоставки.Собран
					или Объект.СтатусДоставки = Перечисления.СтатусыДоставки.ОжидаетСборки ) Тогда
		ОбновитьЗаказыНаСкладеНаСервере();
	КонецЕсли;	
	
	Если не ЗначениеЗаполнено(Объект.МестоХранения) Тогда
		Объект.МестоХранения= Справочники.ТочкиРаздачи.НайтиПоКоду("0100").МестоХранения;
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СделатьОтправленным(Команда)
	СделатьОтправленнымНаСервере();
КонецПроцедуры
Процедура СделатьОтправленнымНаСервере()
	Объект.СтатусДоставки = Перечисления.СтатусыДоставки.Отправлен;
КонецПроцедуры

&НаКлиенте
Процедура Отменить(Команда)
	ОтменитьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ЗаказыНаСкладеПриИзменении(Элемент)
	пересчитатьИтоги();
КонецПроцедуры


&НаСервере
Процедура ОтменитьНаСервере()
	Объект.СтатусДоставки = Перечисления.СтатусыДоставки.Отменен;
КонецПроцедуры


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	//Сканер штрихкода
	СтоСП_Клиент.ПодключитьСканерШК(УникальныйИдентификатор);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	СП_РаботаСДокументами_Клиент.ПроверитьОтветственного(ЭтотОбъект,Отказ);
КонецПроцедуры




&НаСервере
Процедура ОбновитьЗаказыНаСкладеНаСервере()
	док	= ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.КурьерскаяДоставка"));
	док.ЗаполнитьОстатками();
	ЗначениеВДанныеФормы(док, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ПолучитьАдресДоставки(Команда)
	ПолучитьАдресДоставкиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьАдресДоставкиНаСервере()
	док	= ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.КурьерскаяДоставка"));
	док.ПолучитьАдресДоставки_Api();
	ЗначениеВДанныеФормы(док, Объект);
КонецПроцедуры


Процедура РасчитатьСтоимостьИтого()
	Объект.СтоимостьИтого = Объект.СтоимостьХранения+Объект.СтоимостьДоставки;
КонецПроцедуры

&НаКлиенте
Процедура СтоимостьХраненияПриИзменении(Элемент)
	пересчитатьИтоги()
КонецПроцедуры

&НаКлиенте
Процедура СтоимостьДоставкиПриИзменении(Элемент)
	пересчитатьИтоги()
КонецПроцедуры





&НаСервере
Процедура ГруппаСтраницыПриСменеСтраницыНаСервере()
	Если Элементы.Страницы.ТекущаяСтраница	= Элементы.Страницы.ПодчиненныеЭлементы.ГруппаПротокол Тогда
		парамДок				= Протокол.Параметры.Элементы.Найти("Документ");
		парамДок.Значение		= Объект.Ссылка;
		парамДок.Использование	= Истина;
	Конецесли;	
КонецПроцедуры


&НаКлиенте
Процедура СтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ГруппаСтраницыПриСменеСтраницыНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура ОтправитьСчет(Команда)
	ОтправитьСчетНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОтправитьСчетНаСервере()
	док	= ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.КурьерскаяДоставка"));
	док.ВыставитьСчет_Api();
	ЗначениеВДанныеФормы(док, Объект);
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
КонецПроцедуры


Процедура пересчитатьИтоги()
	Объект.СтоимостьОплачиваетОрганизатор 	= 0;
	Объект.СтоимостьХранения				= 0;
	Объект.СтоимостьИтого					= 0;
	помеченныеСтроки = Объект.ЗаказыНаСкладе.Выгрузить(новый Структура("Подбор", Истина));
	Для каждого элем из помеченныеСтроки Цикл
		Объект.СтоимостьОплачиваетОрганизатор 	= Объект.СтоимостьОплачиваетОрганизатор + элем.ОплачиваетОрганизатор;
		Объект.СтоимостьХранения 				= Объект.СтоимостьХранения + элем.СтоимостьИтого;
	КонецЦикла;	
	Объект.СтоимостьИтого					= Объект.СтоимостьХранения + Объект.СтоимостьДоставки;
КонецПроцедуры	


&НаСервере
Процедура ПодсветкаСтрок()
    ЭтаФорма.УсловноеОформление.Элементы.Очистить();
	ЭлементУсловногоОформления 		= УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле 				= ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле 			= Новый ПолеКомпоновкиДанных("ЗаказыНаСкладе");
	ЭлементОтбора 					= ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Объект.ЗаказыНаСкладе.Подбор");
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение 	= истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.БледноЗеленый);	
	
//	ЭлементУсловногоОформления 		= УсловноеОформление.Элементы.Добавить();
//	ОформляемоеПоле 				= ЭлементУсловногоОформления.Поля.Элементы.Добавить();
//	ОформляемоеПоле.Поле 			= Новый ПолеКомпоновкиДанных("Покупки");
//	ЭлементОтбора 					= ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
//	ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Объект.Покупки.Предупреждение");
//	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
//	ЭлементОтбора.ПравоеЗначение 	= Перечисления.ПредупрежденияПрихода.ЧерныйСписок;
//	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоСерый);	
	
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

&НаКлиенте
Процедура ОбновитьССайта(Команда)
	ОбновитьССайтаНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбновитьССайтаНаСервере()
	док	= ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.КурьерскаяДоставка"));
	док.ОбновитьГруппуДоставки();
	ЗначениеВДанныеФормы(док, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
		Если не Объект.Напечатано Тогда
			командаПечати		= ПолучитьКомандуПечати("Чек");
			УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(ЭтаФорма.Команды[командаПечати], ЭтотОбъект, Объект);
			Объект.Напечатано	= Истина;
			СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтотОбъект);
		КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если 	ИмяСобытия 	= "ScanData"					и
			Источник 	= "ПодключаемоеОборудование" 	и
	   		ВводДоступен()   Тогда
			
			ШК = СтоСП_Клиент.ПолучитьШКизПараметров(Параметр);
			ОбработатьШКнаКлиенте(ШК);
	КонецЕсли;
КонецПроцедуры



&НаКлиенте
Процедура 	ОбработатьШКНаКлиенте(ШК)
	ДанныеШК    = СП_Штрихкоды.ПолучитьДанныеПоШК(ШК);
	Если ДанныеШК = неопределено Тогда Возврат; КонецЕсли;
	Если Строка(ДанныеШК.Тип) = "Сотрудник (55)" 		Тогда	
		ЗакрыватьДокумент = (сред(шк,8,2) = "01");
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(этотОбъект,,ДанныеШК.Сотрудник) и ЗакрыватьДокумент Тогда
			Закрыть();
		КонецЕсли;			
	КонецЕсли;
КонецПроцедуры // ОбработатьШКНаКлиенте()




// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

