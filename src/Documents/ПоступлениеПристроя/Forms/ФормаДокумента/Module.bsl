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

КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШКнаКлиенте(ШК)
	ДанныеШК    = СП_Штрихкоды.ПолучитьДанныеПоШК(ШК);
	Если 		Строка(ДанныеШК.Тип) = "Посылка (12)" 				Тогда
		СтрокаЗаказа	=	Элементы.Заказы.ТекущиеДанные;
		Если СтрокаЗаказа = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Установите курсор на строку с пристроем, для привязки стикера");
			Возврат;
		КонецЕсли;	
		
		СтрокаЗаказа.МестоХранения	= МестоХранения;
		СтрокаЗаказа.Габарит		= Габарит;
		СтрокаЗаказа.ШК				= ДанныеШК.ШК;
		
			#Если не ВебКлиент Тогда
			Сигнал();
			#КонецЕсли
	ИначеЕсли 	Строка(ДанныеШК.Тип) 	= "Карта участника (22)"	или
		 Строка(ДанныеШК.Тип) 	= "Карта участника (23)"			Тогда
			Объект.Участник	= ДанныеШК.Участник;
			ОбновитьСписокПристроя();
	ИначеЕсли Строка(ДанныеШК.Тип) = "Габарит (62)" 				Тогда	
		Габарит			= ДанныеШК.Габарит;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Место хранения (63)" 		Тогда	
		МестоХранения	= ДанныеШК.МестоХранения;
	ИначеЕсли 	Строка(ДанныеШК.Тип) 		= "Сотрудник (55)" 			Тогда	
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(этотОбъект,,ДанныеШК.Сотрудник) Тогда
			Закрыть();
		КонецЕсли;				
	КонецЕсли;		
КонецПроцедуры


#КонецОбласти



#Область ОбменДанными

&НаСервере
Функция  ПросмотрXMLНаСервере()
	
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ПоступлениеПристроя"));
	Возврат об.СкомпоноватьДляВыгрузки();
КонецФункции

&НаКлиенте
Процедура ПросмотрXML(Команда)
	Если Модифицированность Тогда
		Записать(новый Структура("РежимЗаписи",РежимЗаписиДокумента.Запись));
	КонецЕсли;
	хмл_incomes=ПросмотрXMLНаСервере();
	СтоСП_Клиент.Показать_XML(хмл_incomes);
КонецПроцедуры

&НаКлиенте
Процедура ПросмотрПолученногоXML(Команда)
	хмл_incomes = Элементы.Протокол.ТекущиеДанные.ПолученныеДанные;
	СтоСП_Клиент.Показать_XML(хмл_incomes);
КонецПроцедуры



&НаКлиенте
Процедура Отправить(Команда)
	Если Модифицированность Тогда
		Записать(новый Структура("РежимЗаписи",РежимЗаписиДокумента.Запись));
	КонецЕсли;	
	ОтправитьНаСервере();
	Для каждого стр из Объект.Заказы Цикл
		Если стр.Отправлено Тогда
			ОповеститьОбИзменении(стр.Пристрой);
		Конецесли;
	КонецЦикла	
КонецПроцедуры

&НаСервере
Процедура ОтправитьНаСервере()
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ПоступлениеПристроя"));
	об.ВыгрузитьНаСайт();
	ЗначениеВДанныеФормы(об,Объект);
КонецПроцедуры



&НаКлиенте
Процедура ОбновитьССайта(Команда)
	ОбновитьСписокПристроя()
КонецПроцедуры

Процедура ОбновитьСписокПристроя()
	Попытка
		СтоСПОбмен_Пристрой.Загрузить_ПристройПоУчастнику(Объект.Участник);
	Исключение
	КонецПопытки;
	
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ПоступлениеПристроя"));
	об.ЗаполнитьНеПринятыми();
	ЗначениеВДанныеФормы(об,Объект);
КонецПроцедуры



&НаКлиенте
Процедура 		ПросмотрПристроя(Команда)
	путьПристроя=ПолучитьПутьПристроя(Элементы.Заказы.ТекущиеДанные.Пристрой);
	ЗапуститьПриложение(путьПристроя);
 КонецПроцедуры

Функция 		ПолучитьПутьПристроя(Пристрой)
	путьПристроя="http://www.100sp.ru/bulletins/"+Формат(Пристрой.bulletinId,"ЧГ=0");
	Возврат путьПристроя;
КонецФункции	


Процедура 		ОтвязатьПристройНаСервере(Пристрой)
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ПоступлениеПристроя"));
	об.ОтвязатьПристройОтПосылки(Пристрой);
	ЗначениеВДанныеФормы(об,Объект);	
КонецПроцедуры

&НаКлиенте
Процедура 		ОтвязатьПристрой(Команда)
	Если Вопрос("Вы дествительно хотите отвязать данный пристройот стикера?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Да Тогда
		ОтвязатьПристройНаСервере(Элементы.Заказы.ТекущиеДанные.Пристрой);
	КонецЕсли;	
КонецПроцедуры


#КонецОбласти

#Область СобытияФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды		
	Если не ЗначениеЗаполнено(Объект.СвояТочка) Тогда
		Объект.СвояТочка=константы.СвояТочка.Получить();
	КонецЕсли;	
	Умолчания=аСПНаСервере.ПолучитьЗначенияПоУмолчанию();
	Габарит			=Умолчания.Габарит;
	МестоХранения	=Умолчания.МестоХранения;
	
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
	Если Объект.Заказы.НайтиСтроки(новый Структура("Отправлено",Ложь)).Количество()>0 Тогда
		ОтправитьНаСервере();
	КонецЕсли;
	Если Объект.Заказы.НайтиСтроки(новый Структура("Отправлено",Ложь)).Количество()>0 Тогда
		Если Вопрос("Не все позиции пристроя отправлены на сайт. Продолжить запись?", РежимДиалогаВопрос.ДаНет) = КодВозвратаДиалога.Нет Тогда
			Отказ=Истина;
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Константы.ВыгружатьПриходПриЗаписи.Получить()  
		или Константы.ВыгружатьТранзитПриЗаписи.Получить()  Тогда
		ФоновыеЗадания.Выполнить("СтоСПФоновые.Запустить_Выгрузку_100СП",,1,"Запустить_Выгрузку_100СП");
	КонецЕсли;

КонецПроцедуры

////////////////////////////////////////

&НаСервере
Процедура ГруппаСтраницыПриСменеСтраницыНаСервере()
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаПротокол Тогда
		парамДок=Протокол.Параметры.Элементы.Найти("Документ");
		парамДок.Значение=Объект.Ссылка;
		парамДок.Использование=Истина;
	Конецесли;	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ГруппаСтраницыПриСменеСтраницыНаСервере();
КонецПроцедуры


#КонецОбласти


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
Процедура ВвестиШтрихКодВручную(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаВводаШК",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ВвестиШтрихКодВручную_Завершение", ЭтотОбъект));
КонецПроцедуры

&НаКлиенте
Процедура ВвестиШтрихКодВручную_Завершение(ШК, ДополнительныеПараметры) Экспорт
	ОбработатьШКнаКлиенте(ШК);
КонецПроцедуры	


// Конец СтандартныеПодсистемы.ПодключаемыеКоманды



