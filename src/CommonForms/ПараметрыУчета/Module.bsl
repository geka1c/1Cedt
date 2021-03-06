


&НаКлиенте
Процедура ЗаполнитьКомпСФР(Команда)
	#Если не ВебКлиент Тогда
	НаборКонстант.КомпьютерСФР=ИмяКомпьютера();
	#КонецЕсли
КонецПроцедуры



&НаКлиенте
Процедура ВыборКаталогаСОбновлениями(Команда)
	Диалог=новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	если диалог.Выбрать() тогда
		НаборКонстант.КаталогСОбновлениями=диалог.Каталог;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВыборКаталогаОбмена(Команда)
	Диалог=новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
	если диалог.Выбрать() тогда
		НаборКонстант.КатологОбмена=диалог.Каталог;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтправкаЭлектронныхЧековПриИзменении(Элемент)
	ОтправкаЭлектронныхЧековПриИзмененииСервер();
	
	Если ОтправкаЭлектронныхЧеков = 1 Тогда
		РассылкаЭлектронныхЧековИспользование = Ложь;
		РегламентныеЗаданияИспользованиеПриИзменении("РассылкаЭлектронныхЧеков");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияИспользованиеПриИзменении(ПрефиксРеквизитов)
	ИмяРеквизитаИспользование = ПрефиксРеквизитов + "Использование";
	Идентификатор = ЭтотОбъект[ПрефиксРеквизитов + "Идентификатор"];
	Если ЭтотОбъект[ИмяРеквизитаИспользование] Тогда
		ЭлементПредставление = Элементы.Найти(ПрефиксРеквизитов + "ПредставлениеРасписания");
		Если ЭлементПредставление = Неопределено Или ЭлементПредставление.Видимость Тогда
			ПараметрыВыполнения = Новый Структура;
			ПараметрыВыполнения.Вставить("Идентификатор", Идентификатор);
			ПараметрыВыполнения.Вставить("ИмяРеквизитаРасписание", ПрефиксРеквизитов + "Расписание");
			ПараметрыВыполнения.Вставить("ИмяРеквизитаИспользование", ИмяРеквизитаИспользование);
			РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения);
			Возврат;
		КонецЕсли;
	КонецЕсли;
	Изменения = Новый Структура("Использование", ЭтотОбъект[ИмяРеквизитаИспользование]);
	РегламентныеЗаданияСохранить(Идентификатор, Изменения, ИмяРеквизитаИспользование);
КонецПроцедуры


&НаСервере
Процедура РегламентныеЗаданияСохранить(УникальныйИдентификатор, Изменения, РеквизитПутьКДанным)
	
	ИзменитьЗадание(УникальныйИдентификатор, Изменения);
	
	Если РеквизитПутьКДанным <> Неопределено Тогда
		УстановитьДоступность(РеквизитПутьКДанным);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьДоступность(РеквизитПутьКДанным = "")
	
	Если РассылкаЭлектронныхЧековИспользование Тогда
		РасписаниеПредставление = Строка(РассылкаЭлектронныхЧековРасписание);
		Представление = ВРег(Лев(РасписаниеПредставление, 1)) + Сред(РасписаниеПредставление, 2);
	Иначе
		Представление = НСтр("ru = '<Отключено>'");
	КонецЕсли;
	Элементы.РассылкаЭлектронныхЧековПредставлениеРасписания.Заголовок = Представление;
	
	Элементы.ГруппаРассылка.Доступность = НЕ Булево(ОтправкаЭлектронныхЧеков);
	
КонецПроцедуры


&НаСервере
// Изменяет задание с указанным идентификатором.
// В случае вызова в транзакции на задание устанавливается объектная блокировка.
// 
// Параметры: 
//  Идентификатор - СправочникСсылка.ОчередьЗаданий, СправочникСсылка.ОчередьЗаданийОбластейДанных - Идентификатор задания
//  ПараметрыЗадания - Структура - Параметры, которые следует установить заданию, 
//   возможные ключи:
//   Использование
//   Параметры
//   Ключ
//   ИнтервалПовтораПриАварийномЗавершении.
//   Расписание
//   КоличествоПовторовПриАварийномЗавершении.
//   
//   В случае если задание создано на основе шаблона или предопределенное, могут быть указаны
//   только следующие ключи: Использование.
// 
Процедура ИзменитьЗадание(Знач Идентификатор, Знач ПараметрыЗадания) Экспорт
	
	Если ТипЗнч(Идентификатор) = Тип("РегламентноеЗадание") Тогда
		Идентификатор = Идентификатор.УникальныйИдентификатор;
	КонецЕсли;
	
	Если ТипЗнч(Идентификатор) = Тип("Строка") Тогда
		Идентификатор = Новый УникальныйИдентификатор(Идентификатор);
	КонецЕсли;
	
	Задание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(Идентификатор);
	Если Задание <> Неопределено Тогда
		
		Если ПараметрыЗадания.Свойство("Наименование") Тогда
			Задание.Наименование = ПараметрыЗадания.Наименование;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("Использование") Тогда
			Задание.Использование = ПараметрыЗадания.Использование;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("Ключ") Тогда
			Задание.Ключ = ПараметрыЗадания.Ключ;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("ИмяПользователя") Тогда
			Задание.ИмяПользователя = ПараметрыЗадания.ИмяПользователя;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("ИнтервалПовтораПриАварийномЗавершении") Тогда
			Задание.ИнтервалПовтораПриАварийномЗавершении = ПараметрыЗадания.ИнтервалПовтораПриАварийномЗавершении;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("КоличествоПовторовПриАварийномЗавершении") Тогда
			Задание.КоличествоПовторовПриАварийномЗавершении = ПараметрыЗадания.КоличествоПовторовПриАварийномЗавершении;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("Параметры") Тогда
			Задание.Параметры = ПараметрыЗадания.Параметры;
		КонецЕсли;
		
		Если ПараметрыЗадания.Свойство("Расписание") Тогда
			Задание.Расписание = ПараметрыЗадания.Расписание;
		КонецЕсли;
		
		Задание.Записать();
	
	КонецЕсли;
	
КонецПроцедуры



&НаКлиенте
Процедура РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения)
	Обработчик = Новый ОписаниеОповещения("РегламентныеЗаданияПослеИзмененияРасписания", ЭтотОбъект, ПараметрыВыполнения);
	Диалог = Новый ДиалогРасписанияРегламентногоЗадания(ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаРасписание]);
	Диалог.Показать(Обработчик);
КонецПроцедуры

&НаСервере
Функция РегламентныеЗаданияНайтиПредопределенное(ИмяПредопределенного)
	Фильтр = Новый Структура("Метаданные", ИмяПредопределенного);
	Найденные =  РегламентныеЗадания.ПолучитьРегламентныеЗадания(Фильтр);
	Задание = ?(Найденные.Количество() = 0, Неопределено, Найденные[0]);
	Если ТипЗнч(Задание) = Тип("СтрокаТаблицыЗначений") Тогда
		Задание.Владелец().Колонки.Идентификатор.Имя = "УникальныйИдентификатор";
	КонецЕсли;
	Возврат Задание;
КонецФункции


&НаСервере
Процедура ОтправкаЭлектронныхЧековПриИзмененииСервер()
	
	ОтправкаЭлектронныхЧековПослеПробитияЧека = Булево(ОтправкаЭлектронныхЧеков);
	Константы.ОтправкаЭлектронныхЧековПослеПробитияЧека.Установить(ОтправкаЭлектронныхЧековПослеПробитияЧека);
	
	Элементы.ГруппаРассылка.Доступность = НЕ ОтправкаЭлектронныхЧековПослеПробитияЧека;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	МенеджерОборудованияВызовСервераПереопределяемый.ОбновитьПоставляемыеДрайвера();
	
	РегламентноеЗадание = РегламентныеЗаданияНайтиПредопределенное("РассылкаЭлектронныхЧеков");
	ВидимостьФлажка = (РегламентноеЗадание <> Неопределено);
	Если ВидимостьФлажка Тогда
		РассылкаЭлектронныхЧековИдентификатор = РегламентноеЗадание.УникальныйИдентификатор;
		РассылкаЭлектронныхЧековИспользование = РегламентноеЗадание.Использование;
		РассылкаЭлектронныхЧековРасписание    = РегламентноеЗадание.Расписание;
	КонецЕсли;
	Элементы.РассылкаЭлектронныхЧековИспользование.Видимость           = ВидимостьФлажка;
	Элементы.РассылкаЭлектронныхЧековНастроитьРасписание.Видимость     = ВидимостьФлажка;
	Элементы.РассылкаЭлектронныхЧековПредставлениеРасписания.Видимость = ВидимостьФлажка;
	
	ОтправкаЭлектронныхЧеков = Число(Константы.ОтправкаЭлектронныхЧековПослеПробитияЧека.Получить());
	
	// Обновление состояния элементов.
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура РассылкаЭлектронныхЧековНастроитьРасписание(Команда)
	РегламентныеЗаданияГиперссылкаНажатие("РассылкаЭлектронныхЧеков");
КонецПроцедуры

&НаКлиенте
Процедура РегламентныеЗаданияГиперссылкаНажатие(ПрефиксРеквизитов)
	ПараметрыВыполнения = Новый Структура;
	ПараметрыВыполнения.Вставить("Идентификатор", ЭтотОбъект[ПрефиксРеквизитов + "Идентификатор"]);
	ПараметрыВыполнения.Вставить("ИмяРеквизитаРасписание", ПрефиксРеквизитов + "Расписание");
	
	РегламентныеЗаданияИзменитьРасписание(ПараметрыВыполнения);
КонецПроцедуры


&НаКлиенте
Процедура ОткрытьОчередьЭлектронныхЧеков(Команда)
	ОткрытьФорму("Справочник.ОчередьЭлектронныхЧековКОтправке.ФормаСписка", , ЭтаФорма);
КонецПроцедуры


&НаКлиенте
Процедура РегламентныеЗаданияПослеИзмененияРасписания(Расписание, ПараметрыВыполнения) Экспорт
	Если Расписание = Неопределено Тогда
		Если ПараметрыВыполнения.Свойство("ИмяРеквизитаИспользование") Тогда
			ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаИспользование] = Ложь;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаРасписание] = Расписание;
	
	Изменения = Новый Структура("Расписание", Расписание);
	Если ПараметрыВыполнения.Свойство("ИмяРеквизитаИспользование") Тогда
		ЭтотОбъект[ПараметрыВыполнения.ИмяРеквизитаИспользование] = Истина;
		Изменения.Вставить("Использование", Истина);
	КонецЕсли;
	РегламентныеЗаданияСохранить(ПараметрыВыполнения.Идентификатор, Изменения, ПараметрыВыполнения.ИмяРеквизитаРасписание);
КонецПроцедуры

&НаКлиенте
Процедура РассылкаЭлектронныхЧековИспользованиеПриИзменении(Элемент)
	РегламентныеЗаданияИспользованиеПриИзменении("РассылкаЭлектронныхЧеков");
КонецПроцедуры


