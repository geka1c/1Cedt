#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	РеквизитыСправочника = Метаданные.Справочники.РассылкиОтчетов.Реквизиты;
	Элементы.СерверИКаталог.Подсказка      = РеквизитыСправочника.FTPКаталог.Подсказка;
	Элементы.Порт.Подсказка                = РеквизитыСправочника.FTPПорт.Подсказка;
	Элементы.Логин.Подсказка               = РеквизитыСправочника.FTPЛогин.Подсказка;
	Элементы.ПассивноеСоединение.Подсказка = РеквизитыСправочника.FTPПассивноеСоединение.Подсказка;
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Параметры, "Сервер, Каталог, Порт, Логин, Пароль, ПассивноеСоединение");
	Если ЭтотОбъект.Сервер = "" Тогда
		ЭтотОбъект.Сервер = "сервер";
	КонецЕсли;
	Если ЭтотОбъект.Каталог = "" Тогда
		ЭтотОбъект.Каталог = "/каталог/";
	КонецЕсли;
	ВидимостьДоступность(ЭтотОбъект);
	
	Если ОбщегоНазначенияКлиентСервер.ЭтоМобильныйКлиент() Тогда // Временное решение для работы в мобильном клиенте, будет удалено в следующих версиях
		
		ОбщегоНазначенияКлиентСервер.УстановитьСвойствоЭлементаФормы(Элементы, "ФормаОК", "Картинка", БиблиотекаКартинок.ЗаписатьИЗакрыть);
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СерверИКаталогПриИзменении(Элемент)
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, РассылкаОтчетовКлиентСервер.РазобратьFTPАдрес(СерверИКаталог), "Сервер, Каталог");
	ВидимостьДоступность(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Заполнить(Команда)
	Если Сервер = "" Тогда
		ПолныйАдрес = НСтр("ru = 'ftp://логин:пароль@сервер:порт/каталог/'");
	Иначе
		Если Логин = "" Тогда
			ПолныйАдрес = "ftp://"+ Сервер +":"+ Формат(Порт, "ЧН=21; ЧГ=0") + Каталог;
		Иначе
			ПолныйАдрес = "ftp://"+ Логин +":"+ ?(ЗначениеЗаполнено(Пароль), ПарольСкрыт(), "") +"@"+ Сервер +":"+ Формат(Порт, "ЧН=0; ЧГ=0") + Каталог;
		КонецЕсли;
	КонецЕсли;
	
	Обработчик = Новый ОписаниеОповещения("ЗаполнитьЗавершение", ЭтотОбъект);
	ПоказатьВводСтроки(Обработчик, ПолныйАдрес, НСтр("ru = 'Введите полный ftp адрес'"))
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	ЗначениеВыбора = Новый Структура("Сервер, Каталог, Порт, Логин, Пароль, ПассивноеСоединение");
	ЗаполнитьЗначенияСвойств(ЗначениеВыбора, ЭтотОбъект);
	ОповеститьОВыборе(ЗначениеВыбора);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ВидимостьДоступность(Форма, Изменения = "")
	Если Не СтрЗаканчиваетсяНа(Форма.Каталог, "/") Тогда
		Форма.Каталог = Форма.Каталог + "/";
	КонецЕсли;
	Форма.СерверИКаталог = "ftp://"+ Форма.Сервер + Форма.Каталог;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьЗавершение(РезультатВвода, ДополнительныеПараметры) Экспорт
	Если РезультатВвода <> Неопределено Тогда
		ПарольДоВвода = Пароль;
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, РассылкаОтчетовКлиентСервер.РазобратьFTPАдрес(РезультатВвода));
		Если Пароль = ПарольСкрыт() Тогда
			Пароль = ПарольДоВвода;
		КонецЕсли;
		ВидимостьДоступность(ЭтотОбъект);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ПарольСкрыт()
	Возврат "********";
КонецФункции

#КонецОбласти
