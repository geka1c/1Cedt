
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Изменение", Метаданные.Справочники.ГруппыДоступа)
	     
	 ИЛИ ПараметрыДоступа("Изменение", Метаданные.Справочники.ГруппыДоступа,
	         "Ссылка").ОграничениеУсловием Тогда
		
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	Если ОбщегоНазначения.ЭтоАвтономноеРабочееМесто() Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ТекущийОбъект.Ссылка = Справочники.ГруппыДоступа.РодительПерсональныхГруппДоступа(Истина) Тогда
		ТолькоПросмотр = Истина;
	КонецЕсли;
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	НаименованиеПерсональныхГруппДоступа = Неопределено;
	
	РодительПерсональныхГруппДоступа = Справочники.ГруппыДоступа.РодительПерсональныхГруппДоступа(
		Истина, НаименованиеПерсональныхГруппДоступа);
	
	Если Объект.Ссылка <> РодительПерсональныхГруппДоступа
	   И Объект.Наименование = НаименованиеПерсональныхГруппДоступа Тогда
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			НСтр("ru = 'Это наименование зарезервировано.'"),
			,
			"Объект.Наименование",
			,
			Отказ);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
