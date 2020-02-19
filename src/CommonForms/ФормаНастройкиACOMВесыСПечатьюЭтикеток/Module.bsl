
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Параметры.Свойство("Идентификатор", Идентификатор);
	Заголовок = НСтр("ru='Оборудование:'") + Символы.НПП  + Строка(Идентификатор);
	
	времБазаТоваров = Неопределено;
	
	Параметры.ПараметрыОборудования.Свойство("БазаТоваров", времБазаТоваров);
	
	БазаТоваров = ?(времБазаТоваров  = Неопределено, "", времБазаТоваров);
	
	Драйвер = НСтр("ru='Не требуется'");
	Версия  = НСтр("ru='Не определена'");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура БазаТоваровНачалоВыбораЗавершение(ВыбранныеФайлы, ДополнительныеПараметры) Экспорт
	
	Если ТипЗнч(ВыбранныеФайлы) = Тип("Массив") И ВыбранныеФайлы.Количество() > 0 Тогда
		БазаТоваров = ВыбранныеФайлы[0];
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БазаТоваровНачалоВыбораДоступностьРасширенияЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат Тогда
		Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
		Диалог.МножественныйВыбор = Ложь;
		Диалог.ПолноеИмяФайла = БазаТоваров;
		Оповещение = Новый ОписаниеОповещения("БазаТоваровНачалоВыбораЗавершение", ЭтотОбъект);
		Диалог.Показать(Оповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура БазаТоваровНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Оповещение = Новый ОписаниеОповещения("БазаТоваровНачалоВыбораДоступностьРасширенияЗавершение", ЭтотОбъект);
	МенеджерОборудованияКлиент.ПроверитьДоступностьРасширенияРаботыСФайлами(Оповещение);
	СтандартнаяОбработка = Ложь;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	
	ТекстОшибки = "";
	Результат = Истина;
	
	Если ПустаяСтрока(БазаТоваров) Тогда
		Результат = Ложь;
		ТекстОшибки = НСтр("ru='Файл базы товаров не указан.'");
	КонецЕсли;
	
	Если Результат Тогда
		
		НовыеЗначениеПараметров = Новый Структура;
		НовыеЗначениеПараметров.Вставить("БазаТоваров", БазаТоваров);
		
		Результат = Новый Структура;
		Результат.Вставить("Идентификатор", Идентификатор);
		Результат.Вставить("ПараметрыОборудования", НовыеЗначениеПараметров);
		
		Закрыть(Результат);
		
	Иначе
		ОчиститьСообщения();
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru= 'При проверке были обнаружены следующие ошибки:'") + ТекстОшибки);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ТестУстройства(Команда)
	
	ОчиститьСообщения();
	
	РезультатТеста = Неопределено;

	ВходныеПараметры  = Неопределено;
	ВыходныеПараметры = Неопределено;

	времПараметрыУстройства = Новый Структура();
	времПараметрыУстройства.Вставить("БазаТоваров", БазаТоваров);

	Результат = МенеджерОборудованияКлиент.ВыполнитьДополнительнуюКоманду("ТестУстройства",
	                                                                      ВходныеПараметры,
	                                                                      ВыходныеПараметры,
	                                                                      Идентификатор,
	                                                                      времПараметрыУстройства);

	ДополнительноеОписание = ?(ТипЗнч(ВыходныеПараметры) = Тип("Массив")
	                           И ВыходныеПараметры.Количество() >= 2,
	                           НСтр("ru = 'Дополнительное описание:'") + " " + ВыходныеПараметры[1],
	                           "");
	Если Результат Тогда
		ТекстСообщения = НСтр("ru = 'Тест успешно выполнен.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = НСтр("ru = 'Тест не пройден.%ПереводСтроки%%ДополнительноеОписание%'");
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ПереводСтроки%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                  "",
		                                                                  Символы.ПС));
		ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ДополнительноеОписание%", ?(ПустаяСтрока(ДополнительноеОписание),
		                                                                           "",
		                                                                           ДополнительноеОписание));
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти