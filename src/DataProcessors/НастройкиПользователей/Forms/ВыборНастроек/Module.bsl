
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПользовательСсылка             = Параметры.Пользователь;
	ДействиеСНастройками           = Параметры.ДействиеСНастройками;
	ПользовательИнформационнойБазы = Обработки.НастройкиПользователей.ИмяПользователяИБ(ПользовательСсылка);
	ТекущийПользовательСсылка      = Пользователи.ТекущийПользователь();
	ТекущийПользователь            = Обработки.НастройкиПользователей.ИмяПользователяИБ(ТекущийПользовательСсылка);
	
	ВыбраннаяСтраницаНастроек = Элементы.ВидыНастроек.ТекущаяСтраница.Имя;
	
	ИмяФормыПерсональныхНастроек = 
		ОбщегоНазначения.ОбщиеПараметрыБазовойФункциональности().ИмяФормыПерсональныхНастроек;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если ДанныеВХранилищеНастроекСохранены
	   И ТипЗнч(ВладелецФормы) = Тип("УправляемаяФорма") Тогда
		
		Свойства = Новый Структура("ОчиститьИсториюВыбораНастроек", Ложь);
		ЗаполнитьЗначенияСвойств(ВладелецФормы, Свойства);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСохраненииДанныхВНастройкахНаСервере(Настройки)
	
	Настройки.Вставить("ПоискСписокВыбора", Элементы.Поиск.СписокВыбора.ВыгрузитьЗначения());
	
	Настройки.Удалить("ВнешнийВид");
	Настройки.Удалить("НастройкиОтчетов");
	Настройки.Удалить("ПрочиеНастройки");
	
	ВнешнийВидДерево       = РеквизитФормыВЗначение("ВнешнийВид");
	НастройкиОтчетовДерево = РеквизитФормыВЗначение("НастройкиОтчетов");
	ПрочиеНастройкиДерево  = РеквизитФормыВЗначение("ПрочиеНастройки");
	
	ПомеченныеНастройкиВнешнегоВида = ПомеченныеНастройки(ВнешнийВидДерево);
	ПомеченныеНастройкиОтчетов      = ПомеченныеНастройки(НастройкиОтчетовДерево);
	ПомеченныеПрочиеНастройки       = ПомеченныеНастройки(ПрочиеНастройкиДерево);
	
	Настройки.Вставить("ПомеченныеНастройкиВнешнегоВида", ПомеченныеНастройкиВнешнегоВида);
	Настройки.Вставить("ПомеченныеНастройкиОтчетов",      ПомеченныеНастройкиОтчетов);
	Настройки.Вставить("ПомеченныеПрочиеНастройки",       ПомеченныеПрочиеНастройки);
	
	ДанныеВХранилищеНастроекСохранены = Истина;
	
КонецПроцедуры

&НаСервере
Процедура ПриЗагрузкеДанныхИзНастроекНаСервере(Настройки)
	
	ВсеВыбранныеНастройки = Новый Структура;
	ВсеВыбранныеНастройки.Вставить("ПомеченныеНастройкиВнешнегоВида");
	ВсеВыбранныеНастройки.Вставить("ПомеченныеНастройкиОтчетов");
	ВсеВыбранныеНастройки.Вставить("ПомеченныеПрочиеНастройки");
	
	Если Параметры.ОчиститьИсториюВыбораНастроек Тогда
		Настройки.Очистить();
		Возврат;
	КонецЕсли;
	
	ПоискСписокВыбора = Настройки.Получить("ПоискСписокВыбора");
	Если ТипЗнч(ПоискСписокВыбора) = Тип("Массив") Тогда
		Элементы.Поиск.СписокВыбора.ЗагрузитьЗначения(ПоискСписокВыбора);
	КонецЕсли;
	Поиск = "";
	
	ПомеченныеНастройкиВнешнегоВида = Настройки.Получить("ПомеченныеНастройкиВнешнегоВида");
	ПомеченныеНастройкиОтчетов      = Настройки.Получить("ПомеченныеНастройкиОтчетов");
	ПомеченныеПрочиеНастройки       = Настройки.Получить("ПомеченныеПрочиеНастройки");
	
	ВсеВыбранныеНастройки.ПомеченныеНастройкиВнешнегоВида = ПомеченныеНастройкиВнешнегоВида;
	ВсеВыбранныеНастройки.ПомеченныеНастройкиОтчетов = ПомеченныеНастройкиОтчетов;
	ВсеВыбранныеНастройки.ПомеченныеПрочиеНастройки = ПомеченныеПрочиеНастройки;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьСписокНастроек();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ПриСменеСтраницы(Элемент, ТекущаяСтраница)
	
	ВыбраннаяСтраницаНастроек = ТекущаяСтраница.Имя;
	
КонецПроцедуры

&НаКлиенте
Процедура ПоискПриИзменении(Элемент)
	
	Если ЗначениеЗаполнено(Поиск) Тогда
		СписокВыбора = Элементы.Поиск.СписокВыбора;
		ЭлементСписка = СписокВыбора.НайтиПоЗначению(Поиск);
		Если ЭлементСписка = Неопределено Тогда
			СписокВыбора.Вставить(0, Поиск);
			Если СписокВыбора.Количество() > 10 Тогда
				СписокВыбора.Удалить(10);
			КонецЕсли;
		Иначе
			Индекс = СписокВыбора.Индекс(ЭлементСписка);
			Если Индекс <> 0 Тогда
				СписокВыбора.Сдвинуть(Индекс, -Индекс);
			КонецЕсли;
		КонецЕсли;
		ТекущийЭлемент = Элементы.Поиск;
	КонецЕсли;
	
	ПоискНастроек = Истина;
	ОбновитьСписокНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ДеревоНастроекВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ПользователиСлужебныйКлиент.ОткрытьОтчетИлиФорму(
		ТекущийЭлемент, ПользовательИнформационнойБазы, ТекущийПользователь, ИмяФормыПерсональныхНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометкаПриИзменении(Элемент)
	
	ИзменитьПометку(Элемент);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Обновить(Команда)
	
	ПоискНастроек = Ложь;
	ОбновитьСписокНастроек();
	
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьНастройку(Команда)
	
	ПользователиСлужебныйКлиент.ОткрытьОтчетИлиФорму(
		ТекущийЭлемент, ПользовательИнформационнойБазы, ТекущийПользователь, ИмяФормыПерсональныхНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьВсе(Команда)
	
	Если ВыбраннаяСтраницаНастроек = "НастройкиОтчетовСтраница" Тогда
		ДеревоНастроек = НастройкиОтчетов.ПолучитьЭлементы();
		ПометитьЭлементыДерева(ДеревоНастроек, Истина);
	ИначеЕсли ВыбраннаяСтраницаНастроек = "ВнешнийВидСтраница" Тогда
		ДеревоНастроек = ВнешнийВид.ПолучитьЭлементы();
		ПометитьЭлементыДерева(ДеревоНастроек, Истина);
	Иначе
		ДеревоНастроек = ПрочиеНастройки.ПолучитьЭлементы();
		ПометитьЭлементыДерева(ДеревоНастроек, Истина);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометкуСоВсех(Команда)
	
	Если ВыбраннаяСтраницаНастроек = "НастройкиОтчетовСтраница" Тогда
		ДеревоНастроек = НастройкиОтчетов.ПолучитьЭлементы();
		ПометитьЭлементыДерева(ДеревоНастроек, Ложь);
	ИначеЕсли ВыбраннаяСтраницаНастроек = "ВнешнийВидСтраница" Тогда
		ДеревоНастроек = ВнешнийВид.ПолучитьЭлементы();
		ПометитьЭлементыДерева(ДеревоНастроек, Ложь);
	Иначе
		ДеревоНастроек = ПрочиеНастройки.ПолучитьЭлементы();
		ПометитьЭлементыДерева(ДеревоНастроек, Ложь);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	
	Результат = Новый Структура;
	
	ВыбранныеНастройкиВнешнегоВида    = ВыбранныеНастройки(ВнешнийВид);
	ВыбранныеНастройкиОтчетов         = ВыбранныеНастройки(НастройкиОтчетов);
	ВыбранныеПрочиеНастройкиСтруктура = ВыбранныеНастройки(ПрочиеНастройки);
	
	КоличествоНастроек = ВыбранныеНастройкиВнешнегоВида.КоличествоНастроек
	                   + ВыбранныеНастройкиОтчетов.КоличествоНастроек
	                   + ВыбранныеПрочиеНастройкиСтруктура.КоличествоНастроек;
	
	Если ВыбранныеНастройкиОтчетов.КоличествоНастроек = 1 Тогда
		ПредставленияНастроек = ВыбранныеНастройкиОтчетов.ПредставленияНастроек;
	ИначеЕсли ВыбранныеНастройкиВнешнегоВида.КоличествоНастроек = 1 Тогда
		ПредставленияНастроек = ВыбранныеНастройкиВнешнегоВида.ПредставленияНастроек;
	ИначеЕсли ВыбранныеПрочиеНастройкиСтруктура.КоличествоНастроек = 1 Тогда
		ПредставленияНастроек = ВыбранныеПрочиеНастройкиСтруктура.ПредставленияНастроек;
	КонецЕсли;
	
	Результат.Вставить("ВнешнийВид",       ВыбранныеНастройкиВнешнегоВида.МассивНастроек);
	Результат.Вставить("НастройкиОтчетов", ВыбранныеНастройкиОтчетов.МассивНастроек);
	Результат.Вставить("ПрочиеНастройки",  ВыбранныеПрочиеНастройкиСтруктура.МассивНастроек);
	
	Результат.Вставить("ПредставленияНастроек", ПредставленияНастроек);
	Результат.Вставить("КоличествоНастроек",    КоличествоНастроек);
	
	Результат.Вставить("ТаблицаВариантовОтчетов",  ТаблицаПользовательскихВариантовОтчетов);
	Результат.Вставить("ВыбранныеВариантыОтчетов", ВыбранныеНастройкиОтчетов.ВариантыОтчетов);
	
	Результат.Вставить("ПерсональныеНастройки",           ВыбранныеПрочиеНастройкиСтруктура.МассивПерсональныхНастроек);
	Результат.Вставить("ПрочиеПользовательскиеНастройки", ВыбранныеПрочиеНастройкиСтруктура.ПрочиеПользовательскиеНастройки);
	
	Закрыть(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

////////////////////////////////////////////////////////////////////////////////
// Процедуры и функции, отвечающие за вывод настроек пользователю.

&НаКлиенте
Процедура ОбновитьСписокНастроек()
	
	Элементы.БыстрыйПоиск.Доступность = Ложь;
	Элементы.КоманднаяПанель.Доступность = Ложь;
	Элементы.СтраницыДлительнаяОперация.ТекущаяСтраница = Элементы.СтраницаДлительнаяОперация;
	Результат = ОбновлениеСпискаНастроек();
	
	ПараметрыОжидания = ДлительныеОперацииКлиент.ПараметрыОжидания(ЭтотОбъект);
	ПараметрыОжидания.ВыводитьОкноОжидания = Ложь;
	ОповещениеОЗавершении = Новый ОписаниеОповещения("ОбновитьСписокНастроекЗавершение", ЭтотОбъект);
	
	ДлительныеОперацииКлиент.ОжидатьЗавершение(Результат, ОповещениеОЗавершении, ПараметрыОжидания);
	
КонецПроцедуры

&НаСервере
Функция ОбновлениеСпискаНастроек()
	
	Если РезультатВыполнения <> Неопределено
		И РезультатВыполнения.ИдентификаторЗадания <> Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000") Тогда
		ДлительныеОперации.ОтменитьВыполнениеЗадания(РезультатВыполнения.ИдентификаторЗадания);
	КонецЕсли;
	
	Если ПоискНастроек Тогда
		ПомеченныеЭлементыДерева();
	КонецЕсли;
	
	ПараметрыДлительнойОперации = ПараметрыДлительнойОперации();
	
	ПараметрыВыполнения = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	ПараметрыВыполнения.ОжидатьЗавершение = 0; // запускать сразу
	ПараметрыВыполнения.НаименованиеФоновогоЗадания = НСтр("ru = 'Обновление настроек пользователей'");
	
	РезультатВыполнения = ДлительныеОперации.ВыполнитьВФоне("ПользователиСлужебный.ЗаполнитьСпискиНастроек",
		ПараметрыДлительнойОперации, ПараметрыВыполнения);
	
	Возврат РезультатВыполнения;
	
КонецФункции

&НаКлиенте
Процедура ОбновитьСписокНастроекЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Результат = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	Если Результат.Статус = "Выполнено" Тогда
		ЗаполнитьНастройки();
		РазвернутьДеревоЗначений();
		Элементы.СтраницыДлительнаяОперация.ТекущаяСтраница = Элементы.СтраницаНастройки;
		Элементы.БыстрыйПоиск.Доступность = Истина;
		Элементы.КоманднаяПанель.Доступность = Истина;
	ИначеЕсли Результат.Статус = "Ошибка" Тогда
		Элементы.СтраницыДлительнаяОперация.ТекущаяСтраница = Элементы.СтраницаНастройки;
		ВызватьИсключение Результат.КраткоеПредставлениеОшибки;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьНастройки()
	Результат = ПолучитьИзВременногоХранилища(РезультатВыполнения.АдресРезультата);
	
	ЗначениеВРеквизитФормы(Результат.НастройкиОтчетовДерево, "НастройкиОтчетов");
	ЗначениеВРеквизитФормы(Результат.ПользовательскиеВариантыОтчетов, "ТаблицаПользовательскихВариантовОтчетов");
	ЗначениеВРеквизитФормы(Результат.НастройкиВнешнегоВида, "ВнешнийВид");
	ЗначениеВРеквизитФормы(Результат.ПрочиеНастройкиДерево, "ПрочиеНастройки");
	
	Если ПоискНастроек
		Или Не НачальныеНастройкиЗагружены 
		И ВсеВыбранныеНастройки <> Неопределено Тогда
		ЗагрузитьЗначенияПометок(НастройкиОтчетов, ВсеВыбранныеНастройки.ПомеченныеНастройкиОтчетов, "НастройкиОтчетов");
		ЗагрузитьЗначенияПометок(ВнешнийВид, ВсеВыбранныеНастройки.ПомеченныеНастройкиВнешнегоВида, "ВнешнийВид");
		ЗагрузитьЗначенияПометок(ПрочиеНастройки, ВсеВыбранныеНастройки.ПомеченныеПрочиеНастройки, "ПрочиеНастройки");
		НачальныеНастройкиЗагружены = Истина;
	КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Вспомогательные процедуры и функции.

&НаКлиенте
Процедура ИзменитьПометку(Элемент)
	
	ПомеченныйЭлемент = Элемент.Родитель.Родитель.ТекущиеДанные;
	ЗначениеПометки = ПомеченныйЭлемент.Пометка;
	
	Если ЗначениеПометки = 2 Тогда
		ЗначениеПометки = 0;
		ПомеченныйЭлемент.Пометка = ЗначениеПометки;
	КонецЕсли;
	
	РодительЭлемента = ПомеченныйЭлемент.ПолучитьРодителя();
	ДочерниеЭлементы = ПомеченныйЭлемент.ПолучитьЭлементы();
	КоличествоНастроек = 0;
	
	Если РодительЭлемента = Неопределено Тогда
		
		Для Каждого ДочернийЭлемент Из ДочерниеЭлементы Цикл
			
			Если ДочернийЭлемент.Пометка <> ЗначениеПометки Тогда
				КоличествоНастроек = КоличествоНастроек + 1
			КонецЕсли;
			
			ДочернийЭлемент.Пометка = ЗначениеПометки;
		КонецЦикла;
		
		Если ДочерниеЭлементы.Количество() = 0 Тогда
			КоличествоНастроек = КоличествоНастроек + 1;
		КонецЕсли;
		
	Иначе
		ПроверитьПометкиДочернихЭлементовИОтметитьРодителя(РодительЭлемента, ЗначениеПометки);
		КоличествоНастроек = КоличествоНастроек + 1;
	КонецЕсли;
	
	КоличествоНастроек = ?(ЗначениеПометки, КоличествоНастроек, -КоличествоНастроек);
	// Обновление заголовка страницы настроек.
	ОбновитьЗаголовокСтраницы(КоличествоНастроек);
	
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаголовокСтраницы(КоличествоНастроек)
	
	Если ВыбраннаяСтраницаНастроек = "НастройкиОтчетовСтраница" Тогда
		
		КоличествоНастроекОтчетов = КоличествоНастроекОтчетов + КоличествоНастроек;
		
		Если КоличествоНастроекОтчетов = 0 Тогда
			ТекстЗаголовка = НСтр("ru='Настройки отчетов'");
		Иначе
			ТекстЗаголовка = НСтр("ru='Настройки отчетов (%1)'");
			ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, КоличествоНастроекОтчетов);
		КонецЕсли;
		
		Элементы.НастройкиОтчетовСтраница.Заголовок = ТекстЗаголовка;
		
	ИначеЕсли ВыбраннаяСтраницаНастроек = "ВнешнийВидСтраница" Тогда
		
		КоличествоНастроекВнешнегоВида = КоличествоНастроекВнешнегоВида + КоличествоНастроек;
		Если КоличествоНастроекВнешнегоВида = 0 Тогда
			ТекстЗаголовка = НСтр("ru='Внешний вид'");
		Иначе
			ТекстЗаголовка = НСтр("ru='Внешний вид (%1)'");
			ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, КоличествоНастроекВнешнегоВида);
		КонецЕсли;
		
		Элементы.ВнешнийВидСтраница.Заголовок = ТекстЗаголовка;
		
	ИначеЕсли ВыбраннаяСтраницаНастроек = "ПрочиеНастройкиСтраница" Тогда
		
		КоличествоПрочихНастроек = КоличествоПрочихНастроек + КоличествоНастроек;
		Если КоличествоПрочихНастроек = 0 Тогда
			ТекстЗаголовка = НСтр("ru='Прочие настройки'");
		Иначе
			ТекстЗаголовка = НСтр("ru='Прочие настройки (%1)'");
			ТекстЗаголовка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ТекстЗаголовка, КоличествоПрочихНастроек);
		КонецЕсли;
		
		Элементы.ПрочиеНастройкиСтраница.Заголовок = ТекстЗаголовка;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьПометкиДочернихЭлементовИОтметитьРодителя(ЭлементДерева, ЗначениеПометки)
	
	ЕстьНеПомеченные = Ложь;
	ЕстьПомеченные = Ложь;
	
	ДочерниеЭлементы = ЭлементДерева.ПолучитьЭлементы();
	Если ДочерниеЭлементы = Неопределено Тогда
		ЭлементДерева.Пометка = ЗначениеПометки;
	Иначе
		
		Для Каждого ДочернийЭлемент Из ДочерниеЭлементы Цикл
			
			Если ДочернийЭлемент.Пометка = 0 Тогда
				ЕстьНеПомеченные = Истина;
			ИначеЕсли ДочернийЭлемент.Пометка = 1 Тогда
				ЕстьПомеченные = Истина;
			КонецЕсли;
			
		КонецЦикла;
		
		Если ЕстьНеПомеченные 
			И ЕстьПомеченные Тогда
			ЭлементДерева.Пометка = 2;
		ИначеЕсли ЕстьПомеченные Тогда
			ЭлементДерева.Пометка = 1;
		Иначе
			ЭлементДерева.Пометка = 0;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьЭлементыДерева(ДеревоНастроек, ЗначениеПометки)
	
	КоличествоНастроек = 0;
	Для Каждого ЭлементДерева Из ДеревоНастроек Цикл
		ДочерниеЭлементы = ЭлементДерева.ПолучитьЭлементы();
		
		Для Каждого ДочернийЭлемент Из ДочерниеЭлементы Цикл
			
			ДочернийЭлемент.Пометка = ЗначениеПометки;
			КоличествоНастроек = КоличествоНастроек + 1;
			
		КонецЦикла;
		
		Если ДочерниеЭлементы.Количество() = 0 Тогда
			КоличествоНастроек = КоличествоНастроек + 1;
		КонецЕсли;
		
		ЭлементДерева.Пометка = ЗначениеПометки;
	КонецЦикла;
	
	КоличествоНастроек = ?(ЗначениеПометки, КоличествоНастроек, 0);
	
	Если ВыбраннаяСтраницаНастроек = "НастройкиОтчетовСтраница" Тогда
		КоличествоНастроекОтчетов = КоличествоНастроек;
	ИначеЕсли ВыбраннаяСтраницаНастроек = "ВнешнийВидСтраница" Тогда
		КоличествоНастроекВнешнегоВида = КоличествоНастроек;
	ИначеЕсли ВыбраннаяСтраницаНастроек = "ПрочиеНастройкиСтраница" Тогда
		КоличествоПрочихНастроек = КоличествоНастроек;
	КонецЕсли;
	
	ОбновитьЗаголовокСтраницы(0);
	
КонецПроцедуры

&НаКлиенте
Функция ВыбранныеНастройки(ДеревоНастроек)
	
	МассивНастроек = Новый Массив;
	МассивПерсональныхНастроек = Новый Массив;
	ПредставленияНастроек = Новый Массив;
	МассивВариантовОтчетов = Новый Массив;
	ПрочиеПользовательскиеНастройки = Новый Массив;
	КоличествоНастроек = 0;
	
	Для Каждого Настройка Из ДеревоНастроек.ПолучитьЭлементы() Цикл
		
		Если Настройка.Пометка = 1 Тогда
			
			Если Настройка.Тип = "ПерсональныеНастройки" Тогда
				МассивПерсональныхНастроек.Добавить(Настройка.Ключи);
			ИначеЕсли Настройка.Тип = "ПрочаяПользовательскаяНастройка" Тогда
				ПользовательскиеНастройки = Новый Структура;
				ПользовательскиеНастройки.Вставить("ИдентификаторНастройки", Настройка.ТипСтроки);
				ПользовательскиеНастройки.Вставить("ЗначениеНастройки", Настройка.Ключи);
				ПрочиеПользовательскиеНастройки.Добавить(ПользовательскиеНастройки);
			Иначе
				МассивНастроек.Добавить(Настройка.Ключи);
				
				Если Настройка.Тип = "ВариантЛичный" Тогда
					МассивВариантовОтчетов.Добавить(Настройка.Ключи);
				КонецЕсли;
				
			КонецЕсли;
			КоличествоДочерних = Настройка.ПолучитьЭлементы().Количество();
			КоличествоНастроек = КоличествоНастроек + ?(КоличествоДочерних=0,1,КоличествоДочерних);
			
			Если КоличествоДочерних = 1 Тогда
				
				ДочерняяНастройка = Настройка.ПолучитьЭлементы()[0];
				ПредставленияНастроек.Добавить(Настройка.Настройка + " - " + ДочерняяНастройка.Настройка);
				
			ИначеЕсли КоличествоДочерних = 0 Тогда
				ПредставленияНастроек.Добавить(Настройка.Настройка);
			КонецЕсли;
			
		Иначе
			ДочерниеНастройки = Настройка.ПолучитьЭлементы();
			
			Для Каждого ДочерняяНастройка Из ДочерниеНастройки Цикл
				
				Если ДочерняяНастройка.Пометка = 1 Тогда
					МассивНастроек.Добавить(ДочерняяНастройка.Ключи);
					ПредставленияНастроек.Добавить(Настройка.Настройка + " - " + ДочерняяНастройка.Настройка);
					КоличествоНастроек = КоличествоНастроек + 1;
				КонецЕсли;
				
			КонецЦикла;
			
		КонецЕсли;
		
	КонецЦикла;
	
	СтруктураНастроек = Новый Структура;
	
	СтруктураНастроек.Вставить("МассивНастроек", МассивНастроек);
	СтруктураНастроек.Вставить("МассивПерсональныхНастроек", МассивПерсональныхНастроек);
	СтруктураНастроек.Вставить("ПрочиеПользовательскиеНастройки", ПрочиеПользовательскиеНастройки);
	СтруктураНастроек.Вставить("ВариантыОтчетов", МассивВариантовОтчетов);
	СтруктураНастроек.Вставить("ПредставленияНастроек", ПредставленияНастроек);
	СтруктураНастроек.Вставить("КоличествоНастроек", КоличествоНастроек);
	
	Возврат СтруктураНастроек;
	
КонецФункции

&НаКлиенте
Процедура РазвернутьДеревоЗначений()
	
	Строки = НастройкиОтчетов.ПолучитьЭлементы();
	Для Каждого Строка Из Строки Цикл 
		Элементы.НастройкиОтчетовДерево.Развернуть(Строка.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
	Строки = ВнешнийВид.ПолучитьЭлементы();
	Для Каждого Строка Из Строки Цикл 
		Элементы.ВнешнийВид.Развернуть(Строка.ПолучитьИдентификатор(), Истина);
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Функция ПомеченныеЭлементыДерева()
	
	НастройкиОтчетовДерево = РеквизитФормыВЗначение("НастройкиОтчетов");
	ВнешнийВидДерево = РеквизитФормыВЗначение("ВнешнийВид");
	ПрочиеНастройкиДерево = РеквизитФормыВЗначение("ПрочиеНастройки");
	
	ПомеченныеНастройкиОтчетов = ПомеченныеНастройки(НастройкиОтчетовДерево);
	ПомеченныеНастройкиВнешнегоВида = ПомеченныеНастройки(ВнешнийВидДерево);
	ПомеченныеПрочиеНастройки = ПомеченныеНастройки(ПрочиеНастройкиДерево);
	
	Если ВсеВыбранныеНастройки = Неопределено Тогда
		
		ВсеВыбранныеНастройки = Новый Структура;
		ВсеВыбранныеНастройки.Вставить("ПомеченныеНастройкиОтчетов", ПомеченныеНастройкиОтчетов);
		ВсеВыбранныеНастройки.Вставить("ПомеченныеНастройкиВнешнегоВида", ПомеченныеНастройкиВнешнегоВида);
		ВсеВыбранныеНастройки.Вставить("ПомеченныеПрочиеНастройки", ПомеченныеПрочиеНастройки);
		
	Иначе
		
		ВсеВыбранныеНастройки.ПомеченныеНастройкиОтчетов = 
			ПомеченныеПослеСравненияНастройки(ПомеченныеНастройкиОтчетов, НастройкиОтчетовДерево, "НастройкиОтчетов");
		ВсеВыбранныеНастройки.ПомеченныеНастройкиВнешнегоВида = 
			ПомеченныеПослеСравненияНастройки(ПомеченныеНастройкиВнешнегоВида, ВнешнийВидДерево, "ВнешнийВид");
		ВсеВыбранныеНастройки.ПомеченныеПрочиеНастройки = 
			ПомеченныеПослеСравненияНастройки(ПомеченныеПрочиеНастройки, ПрочиеНастройкиДерево, "ПрочиеНастройки");
		
	КонецЕсли;
	
КонецФункции

&НаСервере
Функция ПараметрыДлительнойОперации()
	
	ПараметрыДлительнойОперации = Новый Структура;
	ПараметрыДлительнойОперации.Вставить("ИмяФормы");
	ПараметрыДлительнойОперации.Вставить("Поиск");
	ПараметрыДлительнойОперации.Вставить("ДействиеСНастройками");
	ПараметрыДлительнойОперации.Вставить("ПользовательИнформационнойБазы");
	ПараметрыДлительнойОперации.Вставить("ПользовательСсылка");
	
	ЗаполнитьЗначенияСвойств(ПараметрыДлительнойОперации, ЭтотОбъект);
	
	ПараметрыДлительнойОперации.Вставить("НастройкиОтчетовДерево",          РеквизитФормыВЗначение("НастройкиОтчетов"));
	ПараметрыДлительнойОперации.Вставить("НастройкиВнешнегоВида",           РеквизитФормыВЗначение("ВнешнийВид"));
	ПараметрыДлительнойОперации.Вставить("ПрочиеНастройкиДерево",           РеквизитФормыВЗначение("ПрочиеНастройки"));
	ПараметрыДлительнойОперации.Вставить("ПользовательскиеВариантыОтчетов", РеквизитФормыВЗначение("ТаблицаПользовательскихВариантовОтчетов"));
	
	Возврат ПараметрыДлительнойОперации;
	
КонецФункции

&НаСервере
Функция ПомеченныеНастройки(ДеревоНастроек)
	
	СписокПомеченных = Новый СписокЗначений;
	ОтборПомеченных = Новый Структура("Пометка", 1);
	ОтборНеопределенных = Новый Структура("Пометка", 2);
	
	МассивПомеченных = ДеревоНастроек.Строки.НайтиСтроки(ОтборПомеченных, Истина);
	Для Каждого СтрокаМассива Из МассивПомеченных Цикл
		СписокПомеченных.Добавить(СтрокаМассива.ТипСтроки, , Истина);
	КонецЦикла;
	
	МассивНеопределенных = ДеревоНастроек.Строки.НайтиСтроки(ОтборНеопределенных, Истина);
	Для Каждого СтрокаМассива Из МассивНеопределенных Цикл
		СписокПомеченных.Добавить(СтрокаМассива.ТипСтроки);
	КонецЦикла;
	
	Возврат СписокПомеченных;
	
КонецФункции

&НаСервере
Функция ПомеченныеПослеСравненияНастройки(ПомеченныеНастройки, ДеревоНастроек, ТипНастроек)
	
	Если ТипНастроек = "НастройкиОтчетов" Тогда
		ИсходныйСписокПомеченных = ВсеВыбранныеНастройки.ПомеченныеНастройкиОтчетов;
	ИначеЕсли ТипНастроек = "ВнешнийВид" Тогда
		ИсходныйСписокПомеченных = ВсеВыбранныеНастройки.ПомеченныеНастройкиВнешнегоВида;
	ИначеЕсли ТипНастроек = "ПрочиеНастройки" Тогда
		ИсходныйСписокПомеченных = ВсеВыбранныеНастройки.ПомеченныеПрочиеНастройки;
	КонецЕсли;
	
	Если ИсходныйСписокПомеченных = Неопределено Тогда
		Возврат Новый СписокЗначений;
	КонецЕсли;
	
	Для Каждого Элемент Из ИсходныйСписокПомеченных Цикл
		
		НайденнаяНастройка = ПомеченныеНастройки.НайтиПоЗначению(Элемент.Значение);
		Если НайденнаяНастройка = Неопределено Тогда
			
			ПараметрыОтбора = Новый Структура("ТипСтроки", Элемент.Значение);
			НайденнаяНастройкаВДереве = ДеревоНастроек.Строки.НайтиСтроки(ПараметрыОтбора, Истина);
			Если НайденнаяНастройкаВДереве.Количество() = 0 Тогда
				ПомеченныеНастройки.Добавить(Элемент.Значение, , Элемент.Пометка);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат ПомеченныеНастройки;
КонецФункции

&НаСервере
Процедура ЗагрузитьЗначенияПометок(ДеревоЗначений, ПомеченныеНастройки, ВидНастроек)
	
	Если ПомеченныеНастройки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	КоличествоПомеченных = 0;
	
	Для Каждого СтрокаПомеченныеНастройки Из ПомеченныеНастройки Цикл
		
		ПомеченнаяНастройка = СтрокаПомеченныеНастройки.Значение;
		
		Для Каждого СтрокаДерева Из ДеревоЗначений.ПолучитьЭлементы() Цикл
			
			ДочерниеЭлементы = СтрокаДерева.ПолучитьЭлементы();
			
			Если СтрокаДерева.ТипСтроки = ПомеченнаяНастройка Тогда
				
				Если СтрокаПомеченныеНастройки.Пометка Тогда
					СтрокаДерева.Пометка = 1;
					
					Если ДочерниеЭлементы.Количество() = 0 Тогда
						КоличествоПомеченных = КоличествоПомеченных + 1;
					КонецЕсли;
					
				Иначе
					СтрокаДерева.Пометка = 2;
				КонецЕсли;
				
			Иначе
				
				Для Каждого ДочернийЭлемент Из ДочерниеЭлементы Цикл
					
					Если ДочернийЭлемент.ТипСтроки = ПомеченнаяНастройка Тогда
						ДочернийЭлемент.Пометка = 1;
						КоличествоПомеченных = КоличествоПомеченных + 1;
					КонецЕсли;
					
				КонецЦикла;
				
			КонецЕсли;
			
		КонецЦикла;
		
	КонецЦикла;
	
	Если КоличествоПомеченных > 0 Тогда
		
		Если ВидНастроек = "НастройкиОтчетов" Тогда
			КоличествоНастроекОтчетов = КоличествоПомеченных;
			Элементы.НастройкиОтчетовСтраница.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Настройки отчетов (%1)'"), КоличествоПомеченных);
		ИначеЕсли ВидНастроек = "ВнешнийВид" Тогда
			КоличествоНастроекВнешнегоВида = КоличествоПомеченных;
			Элементы.ВнешнийВидСтраница.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Внешний вид (%1)'"), КоличествоПомеченных);
		ИначеЕсли ВидНастроек = "ПрочиеНастройки" Тогда
			КоличествоПрочихНастроек = КоличествоПомеченных;
			Элементы.ПрочиеНастройкиСтраница.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтр("ru='Прочие настройки (%1)'"), КоличествоПомеченных);
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
