&НаКлиенте
перем РежимЗаписи;

#Область ШтрихКоды

&НаКлиенте
Процедура 	ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	// ПодключаемоеОборудование 
	Если ИмяСобытия = "ScanData" Тогда
		Если Источник = "ПодключаемоеОборудование"   и ВводДоступен() Тогда
			ШК = СтоСП_Клиент.ПолучитьШКизПараметров(Параметр);
			ОбработатьШКнаКлиенте(ШК);
		КонецЕсли;
	КонецЕсли;
	// Конец ПодключаемоеОборудование
КонецПроцедуры

&НаКлиенте
Процедура 	ОбработатьШКнаКлиенте(ШК)
	ДанныеШК    	= СП_Штрихкоды.ПолучитьДанныеПоШК(ШК);
	Если ДанныеШК 	= Неопределено Тогда Возврат КонецЕсли;
	Если Строка(ДанныеШК.Тип) = "Посылка (12)" Тогда
		Если Элементы.Коробки.ТекущиеДанные	=	неопределено 	Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбрана коробка!!! Установите курсор на текущую коробку.",,"Коробки");
			Возврат;
		КонецЕсли;	

		ТекущаяКоробка			= Элементы.Коробки.ТекущиеДанные.Коробка;
		
		ПсылкаДобавлена 		= ДобавитьПосылку(ДанныеШК, ТекущаяКоробка);
		Если ПсылкаДобавлена Тогда
			СтоСП_Клиент.СигналДинамика();
			Элементы.ГруппаСтраницы.ТекущаяСтраница	=	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПосылки;
		КонецЕсли;	
	ИначеЕсли Строка(ДанныеШК.Тип) = "Покупка (11)" или 
			  Строка(ДанныеШК.Тип) = "Заказ100маркета (33)"		Тогда
		Если Элементы.Коробки.ТекущиеДанные	=	неопределено Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбрана коробка!!! Установите курсор на текущую коробку.",,"Коробки");
			Возврат;
		КонецЕсли;	

		ТекущаяКоробка			= Элементы.Коробки.ТекущиеДанные.Коробка;
		
		ЗаказДобавлен	 		= ДобавитьСтарыйЗаказ(ДанныеШК, ТекущаяКоробка);
		Если ЗаказДобавлен Тогда
			СтоСП_Клиент.СигналДинамика();
			Элементы.ГруппаСтраницы.ТекущаяСтраница	=	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПокупки;
		КонецЕсли;	
	ИначеЕсли Строка(ДанныеШК.Тип) = "Коробка (44)" 			Тогда
		СверитьПоследнююКоробку();
		Если ДанныеШК.КРазбору Тогда
			ДобавитьВыбратьКоробку(ДанныеШК.Коробка);
			ОтдельнымМестом = Ложь;
		Иначе
			Если Элементы.ГруппаГруппыНаТранзит.Видимость Тогда
				группаДобавлена = ДобавитьГруппуНаТранзит(ДанныеШК);
				Если группаДобавлена Тогда
					СтоСП_Клиент.СигналДинамика();
					Элементы.ГруппаСтраницы.ТекущаяСтраница	=	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаГруппыНаТранзит;
				КОнецЕсли;	
			Иначе	
				ПоказатьВопрос(	Новый ОписаниеОповещения("ДобавитьКоробкуБезРазбора_Завершение",ЭтотОбъект,ДанныеШК),
							"Коробка не для разбора. Все равно разобрать?",
							РежимДиалогаВопрос.ДаНет);
			КонецЕсли;
		КонецЕсли;	
		
	Иначеесли Строка(ДанныеШК.Тип) = "Сотрудник (55)" 			Тогда	
		ЗакрыватьДокумент = (сред(шк,8,2) = "01");
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(этотОбъект,,ДанныеШК.Сотрудник) и ЗакрыватьДокумент Тогда
			Закрыть();
		КонецЕсли;		
	ИначеЕсли Строка(ДанныеШК.Тип) = "Габарит (62)" 			Тогда	
		Габарит			= ДанныеШК.Габарит;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Место хранения (63)" 		Тогда	
		МестоХранения	= ДанныеШК.МестоХранения;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Действие по ШК (66)"  и ДанныеШК.Действие = "СнятьУстановитьОтдельнымМестом"  Тогда		
		ОтдельнымМестом	=	не ОтдельнымМестом;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Действие по ШК (66)"  и ДанныеШК.Действие = "РазборКоробкиБезКоробки" Тогда		
		ДобавитьВыбратьКоробку(ДанныеШК.Коробка);
		ОтдельнымМестом = Ложь;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Супергруппа (67)"    Тогда	
		Если	ЗначениеЗаполнено(Объект.Супергруппа) и 
				Объект.Супергруппа <> ДанныеШК.Супергруппа Тогда
			ПоказатьВопрос(	Новый ОписаниеОповещения("ПеревыбратьСупергруппу_Завершение",ЭтотОбъект,ДанныеШК),
							"В документе уже выбранна супергруппа: " + Объект.Супергруппа + ". Установить другую " + ДанныеШК.Супергруппа +" ?",
							РежимДиалогаВопрос.ДаНет);
		Иначе
			Объект.Супергруппа	= ДанныеШК.Супергруппа;
		КонецЕсли	
	иначе	
	КонецЕсли;
	УстановитьВидимость();
	Модифицированность=Истина;
КонецПроцедуры	

&НаКлиенте
Процедура ПеревыбратьСупергруппу_Завершение(РезультатЗапроса, ДополнительныеПараметры) Экспорт
	Если РезультатЗапроса = КодВозвратаДиалога.Да Тогда
		Объект.Супергруппа	= ДополнительныеПараметры.Супергруппа	
	КонецЕсли;
КонецПроцедуры	

&НаКлиенте
Процедура 	ВвестиШтрихКодВручную(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаВводаШК",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ВвестиШтрихКодВручную_Завершение", ЭтотОбъект));
	//44563042000101845164000941
	//12000006516484000949
КонецПроцедуры

&НаКлиенте
Процедура 	ВвестиШтрихКодВручную_Завершение(ШК, ДополнительныеПараметры) Экспорт
	ОбработатьШКнаКлиенте(ШК);
КонецПроцедуры	


#КонецОбласти 


#Область ДобавлениеЗаказа

Функция ПередДобавлениемЗаказа(ПараметрыЗаказа)
	ПроверкаПройдена=Истина;
	Если  НЕ ЗначениеЗаполнено(МестоХранения) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Необходимо выбрать место хранения",,"МестоХранения",);
		ПроверкаПройдена	= Ложь;
	Иначе
		Если 	  Константы.ИспользоватьБуффернуюЗону.Получить() 
				и не МестоХранения.БуфенаяЗона
				и ПараметрыЗаказа.ПунктВыдачи.ПроизводитсяОтгрузка Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Производится отгрузка на пункт выдачи " + ПараметрыЗаказа.ПунктВыдачи);
			ПроверкаПройдена	= Ложь;
		КонецЕсли;
	КонецЕсли;
	Если  НЕ ЗначениеЗаполнено(Габарит) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Необходимо выбрать Габарит",,"Габарит");
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	
	
	мТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Если КонтралироватьТочкиПользователя и
		мТекущийПользователь.ТочкиПриема.Количество()>0 и
		мТекущийПользователь.ТочкиПриема.НайтиСтроки(новый структура("ТочкаРаздачи",ПараметрыЗаказа.ПунктВыдачи)).Количество()=0
		Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Текущий пользователь не может принимать покупки на точку "+ПараметрыЗаказа.ПунктВыдачи);
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	
	Возврат ПроверкаПройдена;
	
КонецФункции


Функция 	ДобавитьПосылку(параметрыПосылки, ТекущаяКоробка)
	ПроверкаПройдена	= ПередДобавлениемЗаказа(параметрыПосылки);
	
	масс_строк=Объект.Посылки.НайтиСтроки(новый Структура("Посылка",параметрыПосылки.Посылка));
	Если масс_строк.Количество()>0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Посылка "+параметрыПосылки.Посылка+" уже добавлена для коробки: """+масс_строк[0].Коробка+"""",,"Габарит");
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	
	
	Если не ПроверкаПройдена Тогда Возврат Ложь; КонецЕсли;
	
	
	
	новая_строка					= Объект.Посылки.Добавить();
	новая_строка.Посылка	 		= параметрыПосылки.Посылка;
	новая_строка.ПунктВыдачи		= параметрыПосылки.ПунктВыдачи;
	новая_строка.ОтдельнымМестом	= ОтдельнымМестом;

	новая_строка.Вес			= Вес;
	новая_строка.объем			= объем;
	новая_строка.ДатаПриема		= ТекущаяДата();
	новая_строка.Коробка		= ТекущаяКоробка;
	новая_строка.ШК				= параметрыПосылки.Посылка.ШК;
	
	
	Умолчания					= аСПНаСервере.ПолучитьЗначенияПоУмолчанию(параметрыПосылки.ПунктВыдачи,Ложь);
	Если ВыбиратьГабаритПоТочкеНазначения и 
		параметрыПосылки.ПунктВыдачи <> Объект.СвояТочка  и
		ТекущаяКоробка.КРазбору Тогда
		новая_строка.Габарит		= ?(ЗначениеЗаполнено(Умолчания.Габарит),		Умолчания.Габарит,Габарит);
		новая_строка.МестоХранения	= ?(ЗначениеЗаполнено(Умолчания.МестоХранения),	Умолчания.МестоХранения,МестоХранения);
	Иначе	
		новая_строка.Габарит		= Габарит;
		новая_строка.МестоХранения	= МестоХранения;
	КонецЕсли;	
	
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница <> Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПосылки Тогда	
		Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПосылки;
	КонецЕсли;	
	Возврат Истина;
КонецФункции

Функция 	ДобавитьСтарыйЗаказ(параметрыПосылки, ТекущаяКоробка)
	ПроверкаПройдена		= ПередДобавлениемЗаказа(параметрыПосылки);
	
	Если  параметрыПосылки.Участник.ЧерныйСписок Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Участник:"+параметрыПосылки.Участник+"находится в черном списке",,"Габарит");
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	
	
	Если  параметрыПосылки.НеПринимать Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Участник:"+параметрыПосылки.Участник+"находится в группе ""Не принимать""",,"Габарит");
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	
	
	масс_строк	=	Объект.Покупки.НайтиСтроки(новый Структура("Покупка, Участник, Коробка",параметрыПосылки.Покупка, параметрыПосылки.Участник, ТекущаяКоробка));
	Если масс_строк.Количество()>0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заказ "+параметрыПосылки.Участник+символы.ПС+
															  ", "+параметрыПосылки.Покупка+символы.ПС+ 
															  " уже добавлен для коробки: """+масс_строк[0].Коробка+"""",,"Габарит");
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	
	
	Если не ПроверкаПройдена Тогда Возврат Ложь; КонецЕсли;

	
	новая_строка					= Объект.Покупки.Добавить();
	
	новая_строка.Коробка			= ТекущаяКоробка;
	новая_строка.Участник			= параметрыПосылки.Участник;
	новая_строка.Покупка			= параметрыПосылки.Покупка;
	новая_строка.ПунктВыдачи		= параметрыПосылки.ПунктВыдачи;
	новая_строка.Организатор		= параметрыПосылки.Организатор;
	новая_строка.ОтдельнымМестом	= ОтдельнымМестом;
	новая_строка.Оплачен			= Оплачен;
	новая_строка.вес				= Вес;
	новая_строка.объем				= объем;
	новая_строка.количество			= 1;
	новая_строка.ДатаПриема			= ТекущаяДата();
	новая_строка.ШК					= параметрыПосылки.ШК;
	
	Умолчания						= аСПНаСервере.ПолучитьЗначенияПоУмолчанию(параметрыПосылки.ПунктВыдачи,Ложь);
	Если ВыбиратьГабаритПоТОчкеНазначения и 
		параметрыПосылки.ПунктВыдачи <> Объект.СвояТочка  и
		ТекущаяКоробка.КРазбору Тогда
		новая_строка.Габарит		= ?(ЗначениеЗаполнено(Умолчания.Габарит),Умолчания.Габарит,Габарит);
		новая_строка.МестоХранения	= ?(ЗначениеЗаполнено(Умолчания.МестоХранения),Умолчания.МестоХранения,МестоХранения);
	Иначе	
		новая_строка.Габарит		= Габарит;
		новая_строка.МестоХранения	= МестоХранения;
	КонецЕсли;		
	
	Возврат Истина;
КонецФункции	

Функция ДобавитьГруппуНаТранзит(параметрыГруппы)
	ПроверкаПройдена	= ПередДобавлениемЗаказа(параметрыГруппы);
	
	масс_строк=Объект.ГруппыНаТранзит.НайтиСтроки(новый Структура("Коробка",параметрыГруппы.Коробка));
	Если масс_строк.Количество()>0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Группа "+параметрыГруппы.Коробка+" уже добавлена на транзит ",,"Габарит");
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	
	
	Если не ПроверкаПройдена Тогда Возврат Ложь; КонецЕсли;
	
	новая_строка					= Объект.ГруппыНаТранзит.Добавить();
	новая_строка.Коробка	 		= параметрыГруппы.Коробка;
	новая_строка.ПунктВыдачи		= параметрыГруппы.ПунктВыдачи;
	новая_строка.ОтдельнымМестом	= ОтдельнымМестом;
	новая_строка.Количество			= новая_строка.Коробка.Количество;

	новая_строка.Вес			= Вес;
	новая_строка.объем			= объем;
	новая_строка.ДатаПриема		= ТекущаяДата();
	новая_строка.ШК				= параметрыГруппы.Коробка.ШК;
	
	
	Умолчания					= аСПНаСервере.ПолучитьЗначенияПоУмолчанию(параметрыГруппы.ПунктВыдачи,Ложь);
	Если ВыбиратьГабаритПоТОчкеНазначения  Тогда
		новая_строка.Габарит		= ?(ЗначениеЗаполнено(Умолчания.Габарит),Умолчания.Габарит,Габарит);
		новая_строка.МестоХранения	= ?(ЗначениеЗаполнено(Умолчания.МестоХранения),Умолчания.МестоХранения,МестоХранения);
	Иначе	
		новая_строка.Габарит		= Габарит;
		новая_строка.МестоХранения	= МестоХранения;
	КонецЕсли;		
	Возврат Истина;
	
	
КонецФункции




Процедура 	ДобавитьВыбратьКоробку(КоробкаПараметр	= неопределено)
	Если КоробкаПараметр	=	неопределено Тогда
		Коробка	= Справочники.Коробки.БезКоробки;
		ШК		= Справочники.Мегаордера.нулевой;
	Иначе 
		Коробка	= КоробкаПараметр;
		ШК		= КоробкаПараметр.ШК;
	КонецЕсли;

	ужеДобавлено	= Объект.Коробки.НайтиСтроки(новый Структура("Коробка",Коробка));
	Если ужеДобавлено.Количество()=0 Тогда
		НоваяКоробка					= Объект.Коробки.Добавить();
		НоваяКоробка.Коробка			= Коробка;
		НоваяКоробка.ШК					= ШК;
		Элементы.Коробки.ТекущаяСтрока	= НоваяКоробка.НомерСтроки-1;
		
	Иначе
		Элементы.Коробки.ТекущаяСтрока	= ужеДобавлено[0].НомерСтроки-1;
	КонецЕсли;
	Элементы.Покупки.ОтборСтрок		= новый ФиксированнаяСтруктура("Коробка",Коробка);
КонецПроцедуры



&НаКлиенте
Процедура ДобавитьКоробкуБезРазбора_Завершение(РезультатЗапроса, ДополнительныеПараметры) Экспорт 
	Если РезультатЗапроса = КодВозвратаДиалога.Да Тогда
		ДобавитьВыбратьКоробку(ДополнительныеПараметры.Коробка);
	КонецЕсли;	
КонецПроцедуры	

#КонецОбласти 

#Область Команды

&НаКлиенте
Процедура 	ОбновитьКоробкуССайта(Команда)
	Если Элементы.Коробки.ТекущиеДанные=Неопределено Тогда Возврат; КонецЕсли;
	ТекущаяКоробка	= Элементы.Коробки.ТекущиеДанные.Коробка;
	СтоСПОбмен_Коробки.Загрузить_КоробкиПоКодам(ТекущаяКоробка);
	ОповеститьОбИзменении(ТекущаяКоробка);
	//ПоказатьСверку(ТекущаяКоробка);
КонецПроцедуры

&НаКлиенте
Процедура 	БезКоробки(Команда)
	СверитьПоследнююКоробку();
	ДобавитьВыбратьКоробку();
	УстановитьВидимость();
	ОтдельнымМестом = Истина;
КонецПроцедуры

&НаКлиенте
Процедура 	Добавить(Команда)
	ШК_Строка	=	СП_Штрихкоды.ПолучитьШтрихКод(Покупка,Участник,Объект.СвояТочка);
	ОбработатьШКнаКлиенте(ШК_Строка);

КонецПроцедуры

&НаКлиенте
Процедура 	ДобавитьПоШтрихКоду(Команда)
	ОбработатьШКнаКлиенте(ШтрихКод);
КонецПроцедуры


&НаКлиенте
Процедура 	ПоменятьПолку(Команда)
	Если Объект.Проведен Тогда
		Сообщить("Нельзя поменять место хранения . Документ уже проведен");
	Иначе	
		для н=0 по  Элементы.Покупки.ВыделенныеСтроки.Количество()-1 цикл
			Объект.Покупки[Элементы.Покупки.ВыделенныеСтроки[н]].МестоХранения    =ЭтаФорма.МестоХранения;
		конецЦикла;	
		для н=0 по  Элементы.Посылки.ВыделенныеСтроки.Количество()-1 цикл
			Объект.Посылки[Элементы.Посылки.ВыделенныеСтроки[н]].МестоХранения    =ЭтаФорма.МестоХранения
		конецЦикла;			
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура 	ПоменятьГабарит(Команда)
	Если Объект.Проведен Тогда
		Сообщить("Нельзя поменять Габарит . Документ уже проведен");
	Иначе	
		для н=0 по  Элементы.Покупки.ВыделенныеСтроки.Количество()-1 цикл
			Объект.Покупки[Элементы.Покупки.ВыделенныеСтроки[н]].Габарит    =ЭтаФорма.Габарит;
		конецЦикла;	
		для н=0 по  Элементы.Посылки.ВыделенныеСтроки.Количество()-1 цикл
			Объект.Посылки[Элементы.Посылки.ВыделенныеСтроки[н]].Габарит    =ЭтаФорма.Габарит;
		конецЦикла;	
		
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура 	ПоказатьВсеПосылки(Команда)
	Элементы.Покупки.ОтборСтрок	= Неопределено;
	Элементы.Посылки.ОтборСтрок	= Неопределено;
КонецПроцедуры

&НаКлиенте
Процедура ВыбратьПунктВыдачи(Команда)
	Если Элементы.Посылки.ТекущиеДанные <> Неопределено Тогда
		параметрыФормы = новый Структура;
		параметрыФормы.Вставить("Посылка", 		   			Элементы.Посылки.ТекущиеДанные.Посылка); 
		параметрыФормы.Вставить("ДокументПоступления", 		Объект.Ссылка);               
		параметрыФормы.Вставить("ПунктВыдачиНаСтикере", 	Элементы.Посылки.ТекущиеДанные.ПунктВыдачи);               
		ОткрытьФорму("ОбщаяФорма.ФормаВыбораПунктаВыдачи", 	параметрыФормы ,ЭтотОбъект,,,,Новый ОписаниеОповещения("ВыбратьПунктВыдачи_Завершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;	
КонецПроцедуры


&НаКлиенте
Процедура ВыбратьПунктВыдачи_Завершение(ВыбранноеЗначение, ДополнительныеПараметры) Экспорт
	СП_РаботаСоСправочниками.ОбновитьПосылку(Элементы.Посылки.ТекущиеДанные.Посылка, новый Структура("ПунктВыдачи", ВыбранноеЗначение));
	Если Элементы.Посылки.ТекущиеДанные.ПунктВыдачи <> ВыбранноеЗначение Тогда
		Элементы.Посылки.ТекущиеДанные.ПунктВыдачи = ВыбранноеЗначение;
	КонецЕсли;
	СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтотОбъект);
	ОповеститьОбИзменении(Элементы.Посылки.ТекущиеДанные.Посылка);
КонецПроцедуры	



&НаКлиенте
Процедура ДобавитьПоПокупкеУчастнику(Команда)
	ОткрытьФорму("ОбщаяФорма.ВыборПосылкиПоПокупкеУчастнику",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ДобавитьПоПокупкеУчастнику_Завершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьПоКодуПосылки(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораПосылкиПоКодуПосылки",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ДобавитьПоПокупкеУчастнику_Завершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьПоПокупкеУчастнику_Завершение(ШК, ДополнительныеПараметры) Экспорт
	Если ШК <> Неопределено Тогда 
		Если Элементы.Коробки.ТекущиеДанные = Неопределено тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Необходимо выбрать группу в которую добавляем заказ!");
			Возврат;
		КонецЕсли;	
		ТекущаяКоробка			= Элементы.Коробки.ТекущиеДанные.Коробка;
		ДобавитьПосылку(ШК.ШК, ТекущаяКоробка);	
	КонецЕсли;
КонецПроцедуры	


&НаКлиенте
Процедура ЗаполнитьГабаритыПоУмолчанию(Команда)
	ЗаполнитьГабаритыПоУмолчаниюНаСервере();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьГабаритыПоУмолчаниюНаСервере()
	Для каждого элем из Объект.Посылки Цикл
		элем.габарит = элем.ПунктВыдачи.Габарит;
	КонецЦикла;	
КонецПроцедуры


#КонецОбласти 

#Область СверкаСоставаКоробкиССайтом

&НаКлиенте
Процедура 	СверкаКоробки(Команда)
	Если Элементы.Коробки.ТекущиеДанные <> неопределено Тогда
		СверитьКоробку(Элементы.Коробки.ТекущиеДанные.Коробка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура 	СверитьКоробку(Коробка, ВыводитьОтчетПриСовподении = Истина)
	Если Строка(Коробка) = "Без коробки" Тогда Возврат; КонецЕсли;
	параметрыФормы	= Новый Структура();
	параметрыФормы.Вставить("ТекущаяКоробка",			Коробка);
	параметрыФормы.Вставить("Документ_Объект",			Объект);
		
	структураСверки = ПолучитьСверкуКоробки(параметрыФормы);
	Если 	(структураСверки.КоличествоПроблемныхПозиций =  0   и
			 ВыводитьОтчетПриСовподении) или
			 структураСверки.КоличествоПроблемныхПозиций <> 0   Тогда
		ОткрытьФорму("Общаяформа.ФормаПросмотраТабличногоДокумента",структураСверки,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура СверитьПоследнююКоробку()
	ДобавленоКоробок = Объект.Коробки.Количество();
	Если ДобавленоКоробок>0 Тогда
		ПоследняяКоробка = Объект.Коробки[ДобавленоКоробок-1].Коробка;
		СверитьКоробку(ПоследняяКоробка, Ложь);
	КонецЕсли;
КонецПроцедуры	



Функция 	ПолучитьСверкуКоробки(Параметры)
	Возврат Документы.РазборКоробки.ПолучитьСверкуКоробок(Параметры);
КонецФункции	


&НаКлиенте
Процедура 	СверкаСупкргруппы(Команда)
	параметрыФормы	= Новый Структура();
	параметрыФормы.Вставить("ТекущаяКоробка",			Элементы.Коробки.ТекущиеДанные.Коробка);
	параметрыФормы.Вставить("Документ_Объект",			Объект);
	
	структураСверки = ПолучитьСверкуСупергруппы(параметрыФормы);
	ОткрытьФорму("Общаяформа.ФормаПросмотраТабличногоДокумента",структураСверки,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

Функция 	ПолучитьСверкуСупергруппы(Параметры)
	Возврат Документы.РазборКоробки.ПолучитьСверкуСупергруппы(Параметры);
КонецФункции	


&НаКлиенте
Процедура 	СверкаДокумента(Команда)
	структураСверки = ПолучитьСверкуДокумента();
	ОткрытьФорму("Общаяформа.ФормаПросмотраТабличногоДокумента",структураСверки,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

Функция 	ПолучитьСверкуДокумента()
	параметрыФормы	= Новый Структура();
	параметрыФормы.Вставить("ТекущаяКоробка",			Неопределено);
	параметрыФормы.Вставить("Документ_Объект",			Объект);	
	Возврат Документы.РазборКоробки.ПолучитьСверкуДокумента(параметрыФормы);
КонецФункции	


	


#КонецОбласти 

#Область СобытияФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	// СтандартныеПодсистемы.ДатыЗапретаИзменения
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	// Конец СтандартныеПодсистемы.ДатыЗапретаИзменения
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)	
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
    
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;	
	
	ВыбиратьГабаритПоТочкеНазначения = Константы.ВыбиратьГабаритПоТочкеНазначения.Получить();
	КонтралироватьТочкиПользователя	 = Константы.КонтралироватьТочкиПользователя.Получить();
	ПриниматьГруппыНаТранзитВРазборе = Константы.ПриниматьГруппыНаТранзитВРазборе.Получить();
		
	Объект.СвояТочка				= константы.СвояТочка.Получить();
	Объект.ДелаемГрупповойСтикер	= Константы.ДелаемГруупповойСтикер.Получить();
	ПодсветкаСтрок();
	
	Умолчания		= аСПНаСервере.ПолучитьЗначенияПоУмолчанию();
	Габарит			= Умолчания.Габарит;
	МестоХранения	= Умолчания.МестоХранения;
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	
	//ОтдельнымМестом = Истина;
	масс_стр	=	Объект.Посылки.НайтиСтроки(новый Структура("Отправлено",Истина));
	Для каждого элем из масс_стр Цикл
		ОповеститьОбИзменении(элем.Посылка);
	КонецЦикла;	

	УстановитьВидимость();
	Оплачен	= Истина;
	ОтдельнымМестом =  истина;
	
	//Сканер штрихкода
   СтоСП_Клиент.ПодключитьСканерШК(УникальныйИдентификатор);
	РасчитатьЗаголовки(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	#Область ЗамерПроизводительности
	//КлючеваяОперация = ПредопределенноеЗначение("Справочник.КлючевыеОперации.ПроведениеДокументаРазборКоробки");
	//уид_Замера		 = ОценкаПроизводительностиКлиент.НачатьЗамерВремени(Ложь,КлючеваяОперация);
	//ПараметрыЗаписи.Вставить("уид_Замера",уид_Замера);
	#КонецОбласти
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата	= ТекущаяДата();	
	КонецЕсли;		
	ЗаполнитьПоляОтбора();
	
	Если не Объект.НеУчитываемНеСоответствиеВКоробках Тогда
		структураСверки = ПолучитьСверкуДокумента();
		Если  структураСверки.КоличествоПроблемныхПозиций > 0  Тогда
			Отказ = истина;
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("В документе  есть не соответсвия заказов",,,Отказ);
			ОткрытьФорму("Общаяформа.ФормаПросмотраТабличногоДокумента",структураСверки,ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
		КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры


&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	РежимЗаписи	=	ПараметрыЗаписи;
	
	#Область ЗамерПроизводительности
	//уид_Замера=Неопределено;
	//Если ПараметрыЗаписи.Свойство("уид_Замера",уид_Замера) Тогда
	//	уид_Замера	= ПараметрыЗаписи.уид_Замера;
	//КонецЕсли;	
	//ОценкаПроизводительностиКлиент.ЗавершитьЗамерВремени(уид_Замера);
	#КонецОбласти
	
КонецПроцедуры

////////////////////////////////////

&НаКлиенте
Процедура ТранзитПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ГабаритПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура КоробкиПриАктивизацииСтроки(Элемент)
	Если Элемент.текущиеДанные	= неопределено Тогда Возврат; КонецЕсли;
	Элементы.Покупки.ОтборСтрок	= новый ФиксированнаяСтруктура("Коробка",Элемент.текущиеДанные.Коробка);
	Элементы.Посылки.ОтборСтрок	= новый ФиксированнаяСтруктура("Коробка",Элемент.текущиеДанные.Коробка);

	ОтдельнымМестом = (Строка(Элемент.текущиеДанные.Коробка) = "Без коробки");
	
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура КоробкиПередУдалением(Элемент, Отказ)
	масссСтрок=Объект.Покупки.НайтиСтроки(новый Структура("Коробка",элемент.ТекущиеДанные.Коробка));
	Если масссСтрок.Количество()<>0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Перед удалением коробки необходимо очистить список заказов ",,,,Отказ);
	КонецЕсли;
	масссСтрок=Объект.Посылки.НайтиСтроки(новый Структура("Коробка",элемент.ТекущиеДанные.Коробка));
	Если масссСтрок.Количество()<>0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Перед удалением коробки необходимо очистить список заказов ",,,,Отказ);
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура КоробкиПослеУдаления(Элемеент)
	УстановитьВидимость();
КонецПроцедуры

&НаСервере
Процедура ГруппаСтраницыПриСменеСтраницыНаСервере()
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница	= Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаПротокол Тогда
		парамДок				= Протокол.Параметры.Элементы.Найти("Документ");
		парамДок.Значение		= Объект.Ссылка;
		парамДок.Использование	= Истина;
	Конецесли;	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ГруппаСтраницыПриСменеСтраницыНаСервере();
КонецПроцедуры

#КонецОбласти 

#Область Вспомогательные

&НаСервере
Процедура ПодсветкаСтрок()
    ЭтаФорма.УсловноеОформление.Элементы.Очистить();
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Покупки");
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Покупки.Предупреждение");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = "Дубль";
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоЗолотистый);	
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Покупки");
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Покупки.Предупреждение");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = "ЧерныйСписок";
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоСерый);	
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Покупки");
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Покупки.ТочкаНазначения");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.НеРавно;
	ЭлементОтбора.ПравоеЗначение = Новый ПолеКомпоновкиДанных("Объект.СвояТочка");;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Красный);	

	
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Посылки");
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Посылки.Посылка.Участник.ЧерныйСписок");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Истина;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.Оранжевый);	
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ПосылкиПосылка");
	ЭлементОтбора 					= ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Объект.Посылки.ПунктВыдачи");
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.НеРавно;
	ЭлементОтбора.ПравоеЗначение 	= Новый ПолеКомпоновкиДанных("Объект.СвояТочка");;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветТекста", WebЦвета.Красный);		
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("ПосылкиОтправлено");
	ЭлементОтбора 					= ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Объект.Посылки.Отправлено");
	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение 	= Ложь;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.Оранжевый);		
	
КонецПроцедуры


Процедура УстановитьВидимость()

	//Элементы.гпВесОбъем.Видимость	= Габарит.НеГабарит;
	
//	Если Объект.Покупки.Количество()=0 Тогда
//		Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПосылки;
//	Конецесли;

	Если Объект.Посылки.Количество()=0 Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаГруппыНаТранзит;
	Конецесли;


	
	
	Элементы.ГруппаГруппыНаТранзит.Видимость 	= ПриниматьГруппыНаТранзитВРазборе;
	
	Элементы.группаПокупки.Видимость			= (Объект.Покупки.Количество()>0);
	
КонецПроцедуры	

Процедура ЗаполнитьПоляОтбора()
	
	ВсеКоробки="";
	Для каждого кор из Объект.Коробки Цикл
		ВсеКоробки=ВсеКоробки+Строка(кор.Коробка.Код)+"; ";

	КонецЦикла;	
	тзОрги=Объект.Покупки.Выгрузить();
	тзОрги.Свернуть("Организатор");
	
	ВсеОрги="";
	Для каждого орг из тзОрги Цикл
		Если ЗначениеЗаполнено(орг.Организатор) Тогда
			ВсеОрги=ВсеОрги+орг.Организатор.Наименование+"; ";
		КонецЕсли;
	КонецЦикла;
	Объект.ВсеОрги=ВсеОрги;
	Объект.ВсеКоробки=ВсеКоробки;
КонецПроцедуры	

#КонецОбласти 

#Область ОбменДанными
&НаСервере
Функция  ПросмотрXMLНаСервере()
	
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.РазборКоробки"));
	Возврат СтоСПОбмен_Посылки_income.СкомпоноватьДляВыгрузки(об);
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
	Для каждого пос из Объект.Посылки Цикл
		Если пос.Отправлено Тогда
			ОповеститьОбИзменении(пос.Посылка);
		Конецесли;
	КонецЦикла	
КонецПроцедуры

&НаСервере
Процедура ОтправитьНаСервере()
	об	=	ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.РазборКоробки"));
	об.ВыгрузитьНаСайт();
	ЗначениеВДанныеФормы(об,Объект);
КонецПроцедуры

#КонецОбласти 

#Область НеИспользуется

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если РежимЗаписи<>Неопределено и РежимЗаписи.РежимЗаписи=РежимЗаписиДокумента.Проведение Тогда 
		ВыгрузкаВФоне();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НаписатьСообщениеОрганизатору(Команда)
	параметры_формы = новый Структура("Оппонент");
	параметры_формы.Оппонент = Элементы.Коробки.ТекущиеДанные.Коробка;
	форма_Диалога = ПолучитьФорму("Обработка.ОбменСообщениями100СП.Форма.Форма_СписокДиалогов",параметры_формы,ЭтаФорма);
	форма_Диалога.Открыть();
КонецПроцедуры


Процедура ВыгрузкаВФоне()
	парам=Новый Массив();
	парам.Добавить(Объект.Ссылка);
	ФоновыеЗадания.Выполнить("аспПроцедурыОбменаДанными.УдалитьДокументИзОтправленных",парам,,"УдалитьДокументИзОтправленных");

	Если Константы.ВыгружатьПриходПриЗаписи.Получить() Тогда
		Попытка
			ФоновыеЗадания.Выполнить("СтоСПФоновые.Запустить_Выгрузку_100СП",,1,"Запустить_Выгрузку_100СП");
		Исключение
		
		КонецПопытки;
	КонецЕсли;
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
Процедура РасчитатьЗаголовки(Команда)
	//расчет заголовков страниц заказов
	всегоПокупок = Объект.Покупки.Количество();
	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПокупки.Заголовок=?(всегоПокупок=0,"Покупки","Покупки ("+всегоПокупок+")");
	
	всегоПосылок = Объект.Посылки.Количество();
	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПосылки.Заголовок=?(всегоПосылок=0,"Посылки","Посылки ("+всегоПосылок+")");

	всегоГруппНаТранзит = Объект.ГруппыНаТранзит.Количество();
	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаГруппыНаТранзит.Заголовок=?(всегоГруппНаТранзит=0,"Группы на транзит","Группы на транзит ("+всегоГруппНаТранзит+")");
	

КонецПроцедуры





// Конец СтандартныеПодсистемы.ПодключаемыеКоманды


