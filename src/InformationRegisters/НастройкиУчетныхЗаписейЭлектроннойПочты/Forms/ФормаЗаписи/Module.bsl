#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	ПользовательУчетнойЗаписи = ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Запись.УчетнаяЗаписьЭлектроннойПочты, "ВладелецУчетнойЗаписи");
	ЭтоПерсональнаяУчетнаяЗапись = ЗначениеЗаполнено(ПользовательУчетнойЗаписи);
	Если Не ЭтоПерсональнаяУчетнаяЗапись Тогда
		ПользовательУчетнойЗаписи = Запись.ОтветственныйЗаВедениеПапок;
	КонецЕсли;
	
	Если НЕ Запись.НеИспользоватьВоВстроенномПочтовомКлиенте Тогда
		ИспользоватьВоВстроенномПочтовомКлиенте = 1;
	КонецЕсли;
		
	ОбновитьСостояниеЭлементовФормы(ЭтотОбъект);
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.ФорматПодписиДляНовыхСообщений = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
		
		ТекущийОбъект.ПодписьДляНовыхСообщенийПростойТекст =
			НовоеСообщениеФорматированныйДокумент.ПолучитьТекст();
		
		ТекущийОбъект.ПодписьДляНовыхСообщенийФорматированныйДокумент =
			Новый ХранилищеЗначения(НовоеСообщениеФорматированныйДокумент);
		
	Иначе
		
		ТекущийОбъект.ПодписьДляНовыхСообщенийФорматированныйДокумент = Неопределено;
		
	КонецЕсли;
	
	Если ТекущийОбъект.ФорматПодписиПриОтветеПересылке = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
		
		ТекущийОбъект.ПодписьПриОтветеПересылкеПростойТекст = ПриОтветеПересылкеФорматированныйДокумент.ПолучитьТекст();
		ТекущийОбъект.ПодписьПриОтветеПересылкеФорматированныйДокумент = 
			Новый ХранилищеЗначения(ПриОтветеПересылкеФорматированныйДокумент);
		
	Иначе
		
		ТекущийОбъект.ПодписьПриОтветеПересылкеФорматированныйДокумент = Неопределено;
		
	КонецЕсли;
	
	Если ЭтоПерсональнаяУчетнаяЗапись Тогда
		ТекущийОбъект.ОтветственныйЗаОбработкуПисем = Справочники.Пользователи.ПустаяСсылка();
		ТекущийОбъект.ОтветственныйЗаВедениеПапок   = Справочники.Пользователи.ПустаяСсылка();
		ТекущийОбъект.УдалятьПисьмаПослеОтправки    = Ложь;
	КонецЕсли;
	
	ТекущийОбъект.ОбработкаПисемВыполняетсяВДругомПочтовомКлиенте = ?(ОбработкаПисемВыполняетсяВДругомПочтовомКлиенте = 1, Истина, Ложь);
	
	ПриСозданииЧтенииНаСервере();
	
КонецПроцедуры 

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	Если ТекущийОбъект.ВключатьПодписьДляНовыхСообщений 
		И ТекущийОбъект.ФорматПодписиДляНовыхСообщений = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
		
		НовоеСообщениеФорматированныйДокумент = ТекущийОбъект.ПодписьДляНовыхСообщенийФорматированныйДокумент.Получить();
		
	КонецЕсли;
	
	Если ТекущийОбъект.ВключатьПодписьПриОтветеПересылке 
		И ТекущийОбъект.ФорматПодписиПриОтветеПересылке = Перечисления.СпособыРедактированияЭлектронныхПисем.HTML Тогда
		
		ПриОтветеПересылкеФорматированныйДокумент = 
			ТекущийОбъект.ПодписьПриОтветеПересылкеФорматированныйДокумент.Получить();
		
	КонецЕсли;
		
	Если Запись.ОбработкаПисемВыполняетсяВДругомПочтовомКлиенте Тогда
		ОбработкаПисемВыполняетсяВДругомПочтовомКлиенте = 1;
	КонецЕсли;
	
	УстановитьКартинкиСтраниц();
	
КонецПроцедуры

&НаСервере
Процедура ОбработкаПроверкиЗаполненияНаСервере(Отказ, ПроверяемыеРеквизиты)
	Если ЭтоПерсональнаяУчетнаяЗапись Или Запись.НеИспользоватьВоВстроенномПочтовомКлиенте Тогда
		ПроверяемыеРеквизиты.Очистить();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "Запись_УчетнаяЗаписьЭлектроннойПочты" 
		И Источник = Запись.УчетнаяЗаписьЭлектроннойПочты Тогда
		
		Элементы.ГруппаГдеИдетОбработкаПисем.Видимость = НастройкаОбработкиПисемВДругомКлиентеДоступна();
	ИначеЕсли ИмяСобытия = "ПриИзмененииВидаУчетнойЗаписиЭлектроннойПочты" И Источник = ВладелецФормы Тогда
		ЭтоПерсональнаяУчетнаяЗапись = Параметр;
		ПриИзмененииВидаУчетнойЗаписиЭлектроннойПочты();
	КонецЕсли;
КонецПроцедуры 

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	УстановитьКартинкиСтраниц();
	
КонецПроцедуры

&НаСервере
Процедура УстановитьКартинкиСтраниц()

	Элементы.СтраницаПодписьПриОтвете.Картинка = ВзаимодействияКлиентСервер.ПолучитьКартинкуСтраницыПодписи(Запись.ВключатьПодписьПриОтветеПересылке);
	Элементы.СтраницаПодписьДляНового.Картинка = ВзаимодействияКлиентСервер.ПолучитьКартинкуСтраницыПодписи(Запись.ВключатьПодписьДляНовыхСообщений);

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ТипЗнч(ВладелецФормы) = Тип("УправляемаяФорма") И ВладелецФормы.ИмяФормы = "Справочник.УчетныеЗаписиЭлектроннойПочты.Форма.ФормаЭлемента" Тогда
		ЭтоПерсональнаяУчетнаяЗапись = ВладелецФормы.ВидУчетнойЗаписи = "Персональная";
	КонецЕсли;
	ОбновитьСостояниеЭлементовФормы(ЭтотОбъект);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВключатьПодписьДляНовыйСообщенийПриИзменении(Элемент)
	
	ОбновитьСостояниеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ВключатьПодписьПриОтветеПересылкеПриИзменении(Элемент)
	
	ОбновитьСостояниеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматПодписиДляНовыхСообщенийПриИзменении(Элемент)
	
	Если Запись.ФорматПодписиДляНовыхСообщений = ПредопределенноеЗначение(
		"Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") 
		И Элементы.СтраницыПодписьДляНовыхСообщений.ТекущаяСтраница = Элементы.СтраницаНовоеСообщениеФорматированныйТекст Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Запись.ФорматПодписиДляНовыхСообщений = ПредопределенноеЗначение(
		"Перечисление.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст") 
		И Элементы.СтраницыПодписьДляНовыхСообщений.ТекущаяСтраница = Элементы.СтраницаНовоеСообщениеПростойТекст Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Запись.ФорматПодписиДляНовыхСообщений = ПредопределенноеЗначение(
		"Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") Тогда
		
		Если Не ПустаяСтрока(Запись.ПодписьДляНовыхСообщенийПростойТекст) Тогда
			НовоеСообщениеФорматированныйДокумент.Удалить();
			НовоеСообщениеФорматированныйДокумент.Добавить(Запись.ПодписьДляНовыхСообщенийПростойТекст);
		КонецЕсли;
		
		ОбновитьСостояниеЭлементовФормы(ЭтотОбъект);
		
	Иначе
		
		ДополнительныеПараметры = Новый Структура("КонтекстВызова", "ДляНовыхСообщений");
		ВзаимодействияКлиент.ВопросПриИзмененииФорматаСообщенияНаОбычныйТекст(ЭтотОбъект, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ФорматПодписиПриОтветеПересылкеПриИзменении(Элемент)
	
	Если Запись.ФорматПодписиПриОтветеПересылке = ПредопределенноеЗначение(
			"Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") 
			И Элементы.СтраницыПодписьПриОтветеПересылке.ТекущаяСтраница = Элементы.СтраницаПриОтветеПересылкеФорматированныйДокумент Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Запись.ФорматПодписиПриОтветеПересылке = ПредопределенноеЗначение(
			"Перечисление.СпособыРедактированияЭлектронныхПисем.ОбычныйТекст") 
			И Элементы.СтраницыПодписьПриОтветеПересылке.ТекущаяСтраница = Элементы.СтраницаПриОтветеПересылкеПростойТекст Тогда
		
		Возврат;
		
	КонецЕсли;
	
	Если Запись.ФорматПодписиПриОтветеПересылке = ПредопределенноеЗначение(
			"Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") Тогда
		
		Если Не ПустаяСтрока(Запись.ПодписьПриОтветеПересылкеПростойТекст) Тогда
			ПриОтветеПересылкеФорматированныйДокумент.Удалить();
			ПриОтветеПересылкеФорматированныйДокумент.Добавить(Запись.ПодписьПриОтветеПересылкеПростойТекст);
		КонецЕсли;
		
		ОбновитьСостояниеЭлементовФормы(ЭтотОбъект);
		
	Иначе
		
		ДополнительныеПараметры = Новый Структура("КонтекстВызова", "ПриОтветеПересылке");
		ВзаимодействияКлиент.ВопросПриИзмененииФорматаСообщенияНаОбычныйТекст(ЭтотОбъект, ДополнительныеПараметры);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ИспользоватьВоВстроенномПочтовомКлиентеПриИзменении(Элемент)
	
	Запись.НеИспользоватьВоВстроенномПочтовомКлиенте = ?(ИспользоватьВоВстроенномПочтовомКлиенте = 1, Ложь, Истина);
	ОбновитьСостояниеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОбновитьСостояниеЭлементовФормы(Форма)
	
	ВзаимодействияКлиентСервер.УстановитьСвойствоЭлементовГруппы(Форма.Элементы.ГруппаОсновныеНастройки, "Доступность", НЕ Форма.Запись.НеИспользоватьВоВстроенномПочтовомКлиенте);
	Форма.Элементы.СтраницаПодписьДляНового.Доступность = НЕ Форма.Запись.НеИспользоватьВоВстроенномПочтовомКлиенте;
	Форма.Элементы.СтраницаПодписьПриОтвете.Доступность = НЕ Форма.Запись.НеИспользоватьВоВстроенномПочтовомКлиенте;

	Если Форма.Запись.ФорматПодписиДляНовыхСообщений = ПредопределенноеЗначение(
		"Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") Тогда
		
		Форма.Элементы.СтраницыПодписьДляНовыхСообщений.ТекущаяСтраница =
			Форма.Элементы.СтраницаНовоеСообщениеФорматированныйТекст;
		Форма.Элементы.НовоеСообщениеФорматированныйДокумент.Доступность =
			Форма.Запись.ВключатьПодписьДляНовыхСообщений;
		
	Иначе
		
		Форма.Элементы.СтраницыПодписьДляНовыхСообщений.ТекущаяСтраница =
			Форма.Элементы.СтраницаНовоеСообщениеПростойТекст;
		Форма.Элементы.ПодписьДляНовыхСообщенийПростойТекст.Доступность =
			Форма.Запись.ВключатьПодписьДляНовыхСообщений;
		
	КонецЕсли;
	
	Если Форма.Запись.ФорматПодписиПриОтветеПересылке = ПредопределенноеЗначение(
			"Перечисление.СпособыРедактированияЭлектронныхПисем.HTML") Тогда
		
		Форма.Элементы.СтраницыПодписьПриОтветеПересылке.ТекущаяСтраница = 
			Форма.Элементы.СтраницаПриОтветеПересылкеФорматированныйДокумент;
		Форма.Элементы.ПриОтветеПересылкеФорматированныйДокумент.Доступность = 
			Форма.Запись.ВключатьПодписьПриОтветеПересылке;
		
	Иначе
		
		Форма.Элементы.СтраницыПодписьПриОтветеПересылке.ТекущаяСтраница = 
			Форма.Элементы.СтраницаПриОтветеПересылкеПростойТекст;
		Форма.Элементы.ПодписьПриОтветеПересылкеПростойТекст.Доступность = 
			Форма.Запись.ВключатьПодписьПриОтветеПересылке;
		
	КонецЕсли;
	
	Форма.Элементы.ГруппаОтветственные.Видимость = Не Форма.ЭтоПерсональнаяУчетнаяЗапись;
	
	Форма.Элементы.ФорматПодписиДляНовыхСообщений.Доступность  = Форма.Запись.ВключатьПодписьДляНовыхСообщений;
	Форма.Элементы.ФорматПодписиПриОтветеПересылке.Доступность = Форма.Запись.ВключатьПодписьПриОтветеПересылке;

КонецПроцедуры

&НаКлиенте
Процедура ВопросПриИзмененииФорматаПриЗакрытии(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса <> КодВозвратаДиалога.Да Тогда
		Если ДополнительныеПараметры.КонтекстВызова = "ДляНовыхСообщений" Тогда
			Запись.ФорматПодписиДляНовыхСообщений  = ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML");
		ИначеЕсли ДополнительныеПараметры.КонтекстВызова = "ПриОтветеПересылке" Тогда
			Запись.ФорматПодписиПриОтветеПересылке = ПредопределенноеЗначение("Перечисление.СпособыРедактированияЭлектронныхПисем.HTML");
		КонецЕсли;
		Возврат;
	КонецЕсли;
	
	Если ДополнительныеПараметры.КонтекстВызова = "ДляНовыхСообщений" Тогда
		
		Запись.ПодписьДляНовыхСообщенийПростойТекст = НовоеСообщениеФорматированныйДокумент.ПолучитьТекст();
		НовоеСообщениеФорматированныйДокумент.Удалить();
		
	ИначеЕсли ДополнительныеПараметры.КонтекстВызова = "ПриОтветеПересылке" Тогда
		
		Запись.ПодписьПриОтветеПересылкеПростойТекст = ПриОтветеПересылкеФорматированныйДокумент.ПолучитьТекст();
		ПриОтветеПересылкеФорматированныйДокумент.Удалить();
		
	КонецЕсли;
	
	ОбновитьСостояниеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

&НаСервере
Функция НастройкаОбработкиПисемВДругомКлиентеДоступна()
	
	ИспользоватьПризнакРассмотрено = ПолучитьФункциональнуюОпцию("ИспользоватьПризнакРассмотрено");
	РеквизитыУЗ = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(
	                 Запись.УчетнаяЗаписьЭлектроннойПочты,
	                 "ИспользоватьДляПолучения, ПротоколВходящейПочты");
	
	Возврат ИспользоватьПризнакРассмотрено
	        И РеквизитыУЗ.ИспользоватьДляПолучения
	        И РеквизитыУЗ.ПротоколВходящейПочты = "IMAP";
	
КонецФункции

&НаСервере
Процедура ПриСозданииЧтенииНаСервере()

	Элементы.ГруппаГдеИдетОбработкаПисем.Видимость = НастройкаОбработкиПисемВДругомКлиентеДоступна();

КонецПроцедуры

&НаКлиенте
Процедура ПриИзмененииВидаУчетнойЗаписиЭлектроннойПочты()
	
	Если ЭтоПерсональнаяУчетнаяЗапись Тогда
		ПользовательУчетнойЗаписи = ВладелецФормы.Объект.ВладелецУчетнойЗаписи;
		Запись.ОтветственныйЗаВедениеПапок = ПользовательУчетнойЗаписи;
		Запись.ОтветственныйЗаОбработкуПисем = ПользовательУчетнойЗаписи;
		Модифицированность = Истина;
	КонецЕсли;
	
	ОбновитьСостояниеЭлементовФормы(ЭтотОбъект);
	
КонецПроцедуры

#КонецОбласти
