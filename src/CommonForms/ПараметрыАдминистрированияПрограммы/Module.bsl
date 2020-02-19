
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() И Параметры.ЗапрашиватьПараметрыАдминистрированияКластера Тогда
		ВызватьИсключение НСтр("ru = 'Настройка параметров кластера серверов доступна только в клиент-серверном режиме работы.'");
	КонецЕсли;
	
	Если Параметры.ЗапрашиватьПараметрыАдминистрированияКластера
		И ОбщегоНазначенияКлиентСервер.ЭтоOSXКлиент() Тогда
		Возврат; // Отказ устанавливается в ПриОткрытии.
	КонецЕсли;
	
	ДоступноИспользованиеРазделенныхДанных = ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных();
	
	Если Параметры.ПараметрыАдминистрирования = Неопределено Тогда
		ПараметрыАдминистрирования = СтандартныеПодсистемыСервер.ПараметрыАдминистрирования();
	Иначе
		ПараметрыАдминистрирования = Параметры.ПараметрыАдминистрирования;
	КонецЕсли;
	
	ПроверитьНеобходимостьВводаПараметровАдминистрирования();
	
	Если ДоступноИспользованиеРазделенныхДанных Тогда
		
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоИмени(
		ПараметрыАдминистрирования.ИмяАдминистратораИнформационнойБазы);
		Если ПользовательИБ <> Неопределено Тогда
			ИдентификаторАдминистратораИБ = ПользовательИБ.УникальныйИдентификатор;
		КонецЕсли;
		Пользователи.НайтиНеоднозначныхПользователейИБ(Неопределено, ИдентификаторАдминистратораИБ);
		АдминистраторИБ = Справочники.Пользователи.НайтиПоРеквизиту("ИдентификаторПользователяИБ", ИдентификаторАдминистратораИБ);
		
	КонецЕсли;
	
	Если Не ПустаяСтрока(Параметры.Заголовок) Тогда
		Заголовок = Параметры.Заголовок;
	КонецЕсли;
	
	Если ПустаяСтрока(Параметры.ПоясняющаяНадпись) Тогда
		Элементы.ПоясняющаяНадпись.Видимость = Ложь;
	Иначе
		Элементы.ПоясняющаяНадпись.Заголовок = Параметры.ПоясняющаяНадпись;
	КонецЕсли;
	
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, ПараметрыАдминистрирования);
	
	Элементы.РежимРаботы.ТекущаяСтраница = ?(ДоступноИспользованиеРазделенныхДанных, Элементы.РазделенныйРежим, Элементы.НеразделенныйРежим);
	Элементы.ГруппаАдминистрированиеИБ.Видимость = Параметры.ЗапрашиватьПараметрыАдминистрированияИБ;
	Элементы.ГруппаАдминистрированиеКластера.Видимость = Параметры.ЗапрашиватьПараметрыАдминистрированияКластера;
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоLinuxКлиент() Тогда
		
		ТипПодключения = "RAS";
		Элементы.ТипПодключения.Видимость = Ложь;
		Элементы.ГруппаПараметрыУправления.ОтображатьЗаголовок = Истина;
		Элементы.ГруппаПараметрыУправления.Отображение = ОтображениеОбычнойГруппы.СлабоеВыделение;
		
	КонецЕсли;
	
	Элементы.ГруппаТипПодключения.ТекущаяСтраница = ?(ТипПодключения = "COM", Элементы.ГруппаCOM, Элементы.ГруппаRAS);
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда
		
		ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиФормы.Авто;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Параметры.ЗапрашиватьПараметрыАдминистрированияКластера
		И ОбщегоНазначенияКлиентСервер.ЭтоOSXКлиент() Тогда
		Отказ = Истина;
		ТекстСообщения = НСтр("ru = 'Подключение к кластеру серверов недоступно в клиенте под управлением ОС X.'");
		ПоказатьПредупреждение(,ТекстСообщения);
		Возврат;
	КонецЕсли;
	
	Если Не ТребуетсяВводПараметровАдминистрирования Тогда
		Попытка
			ПроверитьПараметрыАдминистрирования(ПараметрыАдминистрирования);
		Исключение
			Возврат; // Обработка не требуется. Форма будет открыта в штатном режиме.
		КонецПопытки;
		Отказ = Истина;
		ВыполнитьОбработкуОповещения(ЭтотОбъект.ОписаниеОповещенияОЗакрытии, ПараметрыАдминистрирования);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	
	Если Не Параметры.ЗапрашиватьПараметрыАдминистрированияИБ Тогда
		Возврат;
	КонецЕсли;
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Если Не ЗначениеЗаполнено(АдминистраторИБ) Тогда
			Возврат;
		КонецЕсли;
		
		ИмяПоля = "АдминистраторИБ";
		
		ПользовательИБ = Неопределено;
		ПолучитьАдминистратораИБ(ПользовательИБ);
		Если ПользовательИБ = Неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'Указанный пользователь не имеет доступа к информационной базе.'"),,
				ИмяПоля,,Отказ);
			Возврат;
		КонецЕсли;
		
		Если Не Пользователи.ЭтоПолноправныйПользователь(ПользовательИБ, Истина) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru = 'У пользователя нет административных прав.'"),,
				ИмяПоля,,Отказ);
			Возврат;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ТипПодключенияПриИзменении(Элемент)
	
	Элементы.ГруппаТипПодключения.ТекущаяСтраница = ?(ТипПодключения = "COM", Элементы.ГруппаCOM, Элементы.ГруппаRAS);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Записать(Команда)
	
	ОчиститьСообщения();
	
	Если Не ПроверитьЗаполнениеНаСервере() Тогда
		Возврат;
	КонецЕсли;
	
	// Заполняем структуру настроек.
	ЗаполнитьЗначенияСвойств(ПараметрыАдминистрирования, ЭтотОбъект);
	
	ПроверитьПараметрыАдминистрирования(ПараметрыАдминистрирования);
	
	СохранитьПараметрыПодключения();
	
	// Восстанавливаем значения паролей.
	ЗаполнитьЗначенияСвойств(ПараметрыАдминистрирования, ЭтотОбъект);
	
	Закрыть(ПараметрыАдминистрирования);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	Закрыть();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Функция ПроверитьЗаполнениеНаСервере()
	
	Возврат ПроверитьЗаполнение();
	
КонецФункции

&НаСервере
Процедура СохранитьПараметрыПодключения()
	
	// Сохраняем параметры в константу, пароли очищаем.
	СтандартныеПодсистемыСервер.УстановитьПараметрыАдминистрирования(ПараметрыАдминистрирования);
	
КонецПроцедуры

&НаСервере
Процедура ПолучитьАдминистратораИБ(ПользовательИБ = Неопределено)
	
	Если ОбщегоНазначения.ДоступноИспользованиеРазделенныхДанных() Тогда
		
		Если ЗначениеЗаполнено(АдминистраторИБ) Тогда
			
			ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
				АдминистраторИБ.ИдентификаторПользователяИБ);
			
		Иначе
			
			ПользовательИБ = Неопределено;
			
		КонецЕсли;
		
		ИмяАдминистратораИнформационнойБазы = ?(ПользовательИБ = Неопределено, "", ПользовательИБ.Имя);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПараметрыАдминистрирования(ПараметрыАдминистрирования)
	
	Если ТипПодключения = "COM" Тогда
		ОбщегоНазначенияКлиент.ЗарегистрироватьCOMСоединитель(Ложь);
	КонецЕсли;
	
	Если ОбщегоНазначенияКлиент.ИнформационнаяБазаФайловая() Тогда
		
		ПроверитьПараметрыАдминистрированияФайловойБазы();
		
	Иначе
		
		Если ОбщегоНазначенияКлиент.КлиентПодключенЧерезВебСервер() Тогда
			
			ПроверитьПараметрыАдминистрированияНаСервере();
			
		Иначе
			АдминистрированиеКластераКлиентСервер.ПроверитьПараметрыАдминистрирования(ПараметрыАдминистрирования,,
				Параметры.ЗапрашиватьПараметрыАдминистрированияКластера, Параметры.ЗапрашиватьПараметрыАдминистрированияИБ);
		КонецЕсли;
			
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьПараметрыАдминистрированияНаСервере()
	
	АдминистрированиеКластераКлиентСервер.ПроверитьПараметрыАдминистрирования(ПараметрыАдминистрирования,,
		Параметры.ЗапрашиватьПараметрыАдминистрированияКластера, Параметры.ЗапрашиватьПараметрыАдминистрированияИБ);
	
КонецПроцедуры

&НаСервере
Процедура ПроверитьНеобходимостьВводаПараметровАдминистрирования()
	
	ТребуетсяВводПараметровАдминистрирования = Истина;
	
	Если Параметры.ЗапрашиватьПараметрыАдминистрированияИБ И Не Параметры.ЗапрашиватьПараметрыАдминистрированияКластера Тогда
		
		КоличествоПользователей = ПользователиИнформационнойБазы.ПолучитьПользователей().Количество();
		
		Если КоличествоПользователей > 0 Тогда
			
			// Вычисляем актуальное имя пользователя, даже если оно было ранее изменено в текущем сеансе;
			// Например, для подключения к текущей ИБ через внешнее соединение из этого сеанса;
			// Во всех остальных случаях достаточно получить ПользователиИнформационнойБазы.ТекущийПользователь().
			ТекущийПользователь = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(
				ПользователиИнформационнойБазы.ТекущийПользователь().УникальныйИдентификатор);
			
			Если ТекущийПользователь = Неопределено Тогда
				ТекущийПользователь = ПользователиИнформационнойБазы.ТекущийПользователь();
			КонецЕсли;
			
			Если ТекущийПользователь.АутентификацияСтандартная И Не ТекущийПользователь.ПарольУстановлен 
				И Пользователи.ЭтоПолноправныйПользователь(ТекущийПользователь, Истина) Тогда
				
				ПараметрыАдминистрирования.ИмяАдминистратораИнформационнойБазы = ТекущийПользователь.Имя;
				ПараметрыАдминистрирования.ПарольАдминистратораИнформационнойБазы = "";
				
				ТребуетсяВводПараметровАдминистрирования = Ложь;
				
			КонецЕсли;
			
		ИначеЕсли КоличествоПользователей = 0 Тогда
			
			ПараметрыАдминистрирования.ИмяАдминистратораИнформационнойБазы = "";
			ПараметрыАдминистрирования.ПарольАдминистратораИнформационнойБазы = "";
			
			ТребуетсяВводПараметровАдминистрирования = Ложь;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПараметрыАдминистрированияФайловойБазы()
	
	Если Параметры.ЗапрашиватьПараметрыАдминистрированияИБ Тогда
		
		// В базовых версиях проверку подключения не осуществляем.
		ПараметрыРаботыКлиента = СтандартныеПодсистемыКлиент.ПараметрыРаботыКлиента();
		
		Если ПараметрыРаботыКлиента.ЭтоБазоваяВерсияКонфигурации
			Или ПараметрыРаботыКлиента.ЭтоУчебнаяПлатформа Тогда
			Возврат;
		КонецЕсли;
		
		ПараметрыПодключения = ОбщегоНазначенияКлиентСервер.СтруктураПараметровДляУстановкиВнешнегоСоединения();
		ПараметрыПодключения.КаталогИнформационнойБазы = СтрРазделить(СтрокаСоединенияИнформационнойБазы(), """")[1];
		ПараметрыПодключения.ИмяПользователя = ИмяАдминистратораИнформационнойБазы;
		ПараметрыПодключения.ПарольПользователя = ПарольАдминистратораИнформационнойБазы;
		
		Результат = ОбщегоНазначенияКлиентСервер.УстановитьВнешнееСоединениеСБазой(ПараметрыПодключения);
		
		Если Результат.Соединение = Неопределено Тогда
			
			ВызватьИсключение Результат.КраткоеОписаниеОшибки;
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти