&НаКлиенте
перем РежимЗаписи;
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
	// Конец ПодключаемоеОборудование
КонецПроцедуры

&НаКлиенте
Процедура ОбработатьШКнаКлиенте(ШК)
	ДанныеШК    = СП_Штрихкоды.ПолучитьДанныеПоШК(ШК);

	Если не ЗначениеЗаполнено(объект.ПунктВыдачи) Тогда
		ДанныеШК.Свойство("ПунктВыдачи",объект.ПунктВыдачи)
	КонецЕсли;	
	Если Строка(ДанныеШК.Тип) = "Посылка (12)"  		или
		 Строка(ДанныеШК.Тип) = "Покупка (11)" 			или 
		 Строка(ДанныеШК.Тип) = "Заказ100маркета (33)"	или
		 Строка(ДанныеШК.Тип) = "Заказ КД (45)"	или
		 Строка(ДанныеШК.Тип) = "Коробка (44)"					Тогда	
		ПроверитьПунктВыдачиИДобавитьЗаказ(ДанныеШК);
		
	Иначеесли Строка(ДанныеШК.Тип) = "Сотрудник (55)" 			Тогда	
		ЗакрыватьДокумент = (сред(шк,8,2) = "01");
		Если СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(этотОбъект,,ДанныеШК.Сотрудник) и ЗакрыватьДокумент Тогда
			Закрыть();
		КонецЕсли;	
	ИначеЕсли Строка(ДанныеШК.Тип) = "Габарит (62)" 				Тогда	
		Габарит			= ДанныеШК.Габарит;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Место хранения (63)" 		Тогда	
		МестоХранения	= ДанныеШК.МестоХранения;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Действие по ШК (66)"  и ДанныеШК.Действие = "СнятьУстановитьОтдельнымМестом"	    Тогда		
		ОтдельнымМестом	=	не ОтдельнымМестом;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Действие по ШК (66)"  и ДанныеШК.Действие = "Мультиорг"	    Тогда		
		Объект.МультиОрг	=	не Объект.МультиОрг;	
	иначе	
		
	КонецЕсли;
	Модифицированность			= Истина;
	УстановитьВидимость();
КонецПроцедуры	

&НаКлиенте
Процедура ВвестиШтрихКодВручную(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаВводаШК",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ВвестиШтрихКодВручную_Завершение", ЭтотОбъект));
	//12000008536904000077
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
Процедура ВвестиШтрихКодВручную_Завершение(ШК, ДополнительныеПараметры) Экспорт
	ОбработатьШКнаКлиенте(ШК);
КонецПроцедуры	

#КонецОбласти

#Область ДобавлениеЗаказа

Функция ПередДобавлениемЗаказа(ПараметрыЗаказа)
	ПроверкаПройдена=Истина;

	Если  НЕ ЗначениеЗаполнено(Габарит) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Необходимо выбрать Габарит",,"Габарит");
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	
	
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


	Возврат ПроверкаПройдена;
КонецФункции

Функция ДобавитьПосылку(ПараметрыПосылки)
	Посылка 			= ПараметрыПосылки.Посылка;



	
	Если не ЗначениеЗаполнено(Объект.ПунктВыдачи) Тогда
		Объект.ПунктВыдачи	 	= Посылка.ПунктВыдачи;
		Объект.Транзит 			= (Объект.ПунктВыдачи <> Объект.СвояТочка);
	КонецЕсли;	
	Если не ЗначениеЗаполнено(Объект.Организатор) тогда
		Объект.Организатор		= Посылка.Организатор;
	КонецЕсли;


	
	ПроверкаПройдена	= ПередДобавлениемЗаказа(параметрыПосылки);


	масс_строк	= Объект.Посылки.НайтиСтроки(новый Структура("Посылка",Посылка));
	Если масс_строк.Количество()>0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Посылка "+Посылка+" уже добавлена ",,"Габарит");
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	
	
	мТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Если 	КонтралироватьТочкиПользователя и
			мТекущийПользователь.ТочкиПриема.Количество()>0 и
			мТекущийПользователь.ТочкиПриема.НайтиСтроки(новый структура("ТочкаРаздачи",Посылка.ПунктВыдачи)).Количество()=0
		Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Текущий пользователь не может принимать покупки на пункт выдачи: "+Посылка.ПунктВыдачи);
		ПроверкаПройдена = Ложь;
	КонецЕсли;	
	
	
	Если не ПроверкаПройдена Тогда Возврат Ложь; КонецЕсли;
	

	
	новая_строка				= Объект.Посылки.Добавить();
	новая_строка.Посылка	 	= Посылка;
	новая_строка.ПунктВыдачи	= Посылка.ПунктВыдачи;
	новая_строка.ОтдельнымМестом= ОтдельнымМестом;
	
	//Умолчания					= аСПНаСервере.ПолучитьЗначенияПоУмолчанию(Посылка.ПунктВыдачи,Ложь);
	
	новая_строка.Габарит		= Габарит;
	новая_строка.МестоХранения	= МестоХранения;

	
	новая_строка.Вес			= Вес;
	новая_строка.объем			= объем;
	новая_строка.ДатаПриема		= ТекущаяДата();
	новая_строка.ШК				= Посылка.ШК;
	Возврат Истина;
КонецФункции

Функция ДобавитьСтарыйЗаказ(параметрыПосылки)
	Если не ЗначениеЗаполнено(Объект.ПунктВыдачи) Тогда
		Объект.ПунктВыдачи	 	= параметрыПосылки.ПунктВыдачи;
		Объект.Транзит 			= (Объект.ПунктВыдачи <> Объект.СвояТочка);
	КонецЕсли;	
	Если не ЗначениеЗаполнено(Объект.Организатор) тогда
		Объект.Организатор		= параметрыПосылки.Организатор;
	КонецЕсли;
	
	
	ПроверкаПройдена	= ПередДобавлениемЗаказа(параметрыПосылки);
	
	Если  параметрыПосылки.Участник.ЧерныйСписок Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Участник:"+параметрыПосылки.Участник+"находится в черном списке",,"Габарит");
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	
	
	Если  параметрыПосылки.НеПринимать Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Участник:"+параметрыПосылки.Участник+"находится в группе ""Не принимать""",,"Габарит");
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	
	
	масс_строк	=	Объект.Покупки.НайтиСтроки(новый Структура("Покупка, Участник",параметрыПосылки.Покупка, параметрыПосылки.Участник));
	Если масс_строк.Количество()>0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заказ "+параметрыПосылки.Участник+символы.ПС+
															  ", "+параметрыПосылки.Покупка+символы.ПС+ 
															  " уже добавлен. ",,"Габарит");
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	
	
	мТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Если КонтралироватьТочкиПользователя и
		мТекущийПользователь.ТочкиПриема.Количество()>0 и
		мТекущийПользователь.ТочкиПриема.НайтиСтроки(новый структура("ТочкаРаздачи",параметрыПосылки.ПунктВыдачи)).Количество()=0
		Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Текущий пользователь не может принимать покупки на точку "+параметрыПосылки.ПунктВыдачи);
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	

	
	Если не ПроверкаПройдена Тогда Возврат Ложь; КонецЕсли;
	

	новая_строка					= Объект.Покупки.Добавить();
	
	новая_строка.Участник			= параметрыПосылки.Участник;
	новая_строка.Покупка			= параметрыПосылки.Покупка;
	новая_строка.Организатор		= параметрыПосылки.Организатор;
	новая_строка.ОтдельнымМестом	= ОтдельнымМестом;
	новая_строка.ОргСбор			= ОргСбор;
	новая_строка.Оплачен			= Оплачен;
	новая_строка.вес				= Вес;
	новая_строка.объем				= объем;
	новая_строка.количество			= 1;
	новая_строка.ДатаПриема			= ТекущаяДата();
	новая_строка.ШК					= параметрыПосылки.ШК;
	новая_строка.КодПокупки			= параметрыПосылки.Покупка.Код;
	
	//Умолчания						= аСПНаСервере.ПолучитьЗначенияПоУмолчанию(параметрыПосылки.ПунктВыдачи,Ложь);
	//Если Константы.ВыбиратьГабаритПоТОчкеНазначения.Получить() и 
	//	параметрыПосылки.ПунктВыдачи <> Объект.СвояТочка   Тогда
	//	новая_строка.Габарит		= ?(ЗначениеЗаполнено(Умолчания.Габарит),		Умолчания.Габарит,			Габарит);
	//	новая_строка.МестоХранения	= ?(ЗначениеЗаполнено(Умолчания.МестоХранения),	Умолчания.МестоХранения,	МестоХранения);
	//Иначе	
		новая_строка.Габарит		= Габарит;
		новая_строка.МестоХранения	= МестоХранения;
	//КонецЕсли;		
	
	Возврат Истина;
КонецФункции


Функция ДобавитьЗаказКД(параметрыПосылки)
	Если не ЗначениеЗаполнено(Объект.ПунктВыдачи) Тогда
		Объект.ПунктВыдачи	 	= параметрыПосылки.ПунктВыдачи;
		Объект.Транзит 			= (Объект.ПунктВыдачи <> Объект.СвояТочка);
	КонецЕсли;	
	Если не ЗначениеЗаполнено(Объект.Организатор) тогда
		Объект.Организатор		= Справочники.Организаторы.нулевой;
	КонецЕсли;
	
	ПроверкаПройдена	= ПередДобавлениемЗаказа(параметрыПосылки);
	масс_строк	=	Объект.Покупки.НайтиСтроки(новый Структура("Покупка",параметрыПосылки.заказ));
	Если масс_строк.Количество()>0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Заказ "+параметрыПосылки.Заказ+" уже добавлен. ",,"Габарит");
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	
	
	мТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Если КонтралироватьТочкиПользователя и
		мТекущийПользователь.ТочкиПриема.Количество()>0 и
		мТекущийПользователь.ТочкиПриема.НайтиСтроки(новый структура("ТочкаРаздачи",параметрыПосылки.ПунктВыдачи)).Количество()=0
		Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Текущий пользователь не может принимать покупки на точку "+параметрыПосылки.ПунктВыдачи);
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	

	
	Если не ПроверкаПройдена Тогда Возврат Ложь; КонецЕсли;
	

	новая_строка					= Объект.Покупки.Добавить();
	
	новая_строка.Участник			= Справочники.Участники.нулевой;
	новая_строка.Покупка			= параметрыПосылки.Заказ;
	новая_строка.Организатор		= Справочники.Организаторы.нулевой;
	новая_строка.ОтдельнымМестом	= ОтдельнымМестом;
	новая_строка.ОргСбор			= ОргСбор;
	новая_строка.Оплачен			= Оплачен;
	новая_строка.вес				= Вес;
	новая_строка.объем				= объем;
	новая_строка.количество			= 1;
	новая_строка.ДатаПриема			= ТекущаяДата();
	новая_строка.ШК					= параметрыПосылки.ШК;
	новая_строка.КодПокупки			= параметрыПосылки.Заказ.Код;
	
	//Умолчания						= аСПНаСервере.ПолучитьЗначенияПоУмолчанию(параметрыПосылки.ПунктВыдачи,Ложь);
	//Если Константы.ВыбиратьГабаритПоТОчкеНазначения.Получить() и 
	//	параметрыПосылки.ПунктВыдачи <> Объект.СвояТочка   Тогда
	//	новая_строка.Габарит		= ?(ЗначениеЗаполнено(Умолчания.Габарит),		Умолчания.Габарит,			Габарит);
	//	новая_строка.МестоХранения	= ?(ЗначениеЗаполнено(Умолчания.МестоХранения),	Умолчания.МестоХранения,	МестоХранения);
	//Иначе	
		новая_строка.Габарит		= Габарит;
		новая_строка.МестоХранения	= МестоХранения;
	//КонецЕсли;		
	
	Возврат Истина;
КонецФункции


Функция ДобавитьГруппу(параметрыПосылки)
	Если не ЗначениеЗаполнено(Объект.ПунктВыдачи) Тогда
		Объект.ПунктВыдачи	 	= параметрыПосылки.ПунктВыдачи;
		Объект.Транзит 			= (Объект.ПунктВыдачи <> Объект.СвояТочка);
	КонецЕсли;	
	Если не ЗначениеЗаполнено(Объект.Организатор) тогда
		Объект.Организатор		= параметрыПосылки.Организатор;
	КонецЕсли;
	
	ПроверкаПройдена	= ПередДобавлениемЗаказа(параметрыПосылки);
	
	Если не Объект.Транзит Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нельзя принимать коробки на склад. Воспользуйтесь документом ""Разбор коробки"", либо установите переключатель ""Транзит"" ");
		ПроверкаПройдена	= Ложь;
	ИначеЕсли параметрыПосылки.КРазбору Тогда	
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Это не транзитный заказ. Воспользуйтесь документом ""Разбор коробки"".");
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	

	масс_строк	=	Объект.Покупки.НайтиСтроки(новый Структура("Покупка, Участник",параметрыПосылки.Коробка, Справочники.Участники.нулевой));
	Если масс_строк.Количество()>0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Коробка "+параметрыПосылки.Коробка+" уже добавлена. ",,"Габарит");
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	
	
	мТекущийПользователь = ПользователиКлиентСервер.ТекущийПользователь();
	Если КонтралироватьТочкиПользователя и
		мТекущийПользователь.ТочкиПриема.Количество()>0 и
		мТекущийПользователь.ТочкиПриема.НайтиСтроки(новый структура("ТочкаРаздачи",параметрыПосылки.ПунктВыдачи)).Количество()=0
		Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Текущий пользователь не может принимать покупки на точку "+параметрыПосылки.ПунктВыдачи);
		ПроверкаПройдена	= Ложь;
	КонецЕсли;	

	
	Если не ПроверкаПройдена Тогда Возврат Ложь; КонецЕсли;
	

	новая_строка					= Объект.Покупки.Добавить();
	
	новая_строка.Участник			= Справочники.Участники.нулевой;
	новая_строка.Покупка			= параметрыПосылки.Коробка;
	новая_строка.Организатор		= параметрыПосылки.Организатор;
	новая_строка.ОтдельнымМестом	= ОтдельнымМестом;
	новая_строка.ОргСбор			= ОргСбор;
	новая_строка.Оплачен			= Оплачен;
	новая_строка.вес				= Вес;
	новая_строка.объем				= объем;
	новая_строка.количество			= параметрыПосылки.Количество;
	новая_строка.ДатаПриема			= ТекущаяДата();
	новая_строка.ШК					= параметрыПосылки.ШК;
	новая_строка.КодПокупки			= параметрыПосылки.Коробка.Код;
	
	//Умолчания						= аСПНаСервере.ПолучитьЗначенияПоУмолчанию(параметрыПосылки.ПунктВыдачи,Ложь);
	//Если Константы.ВыбиратьГабаритПоТОчкеНазначения.Получить() и 
	//	параметрыПосылки.ПунктВыдачи <> Объект.СвояТочка   Тогда
	//	новая_строка.Габарит		= ?(ЗначениеЗаполнено(Умолчания.Габарит),		Умолчания.Габарит,			Габарит);
	//	новая_строка.МестоХранения	= ?(ЗначениеЗаполнено(Умолчания.МестоХранения),	Умолчания.МестоХранения,	МестоХранения);
	//Иначе	
		новая_строка.Габарит		= Габарит;
		новая_строка.МестоХранения	= МестоХранения;
	//КонецЕсли;		
	
	Возврат Истина;
КонецФункции

#КонецОбласти

#Область Команды

&НаКлиенте
Процедура Добавить(Команда)
	ШК_Строка	=	СП_Штрихкоды.ПолучитьШтрихКод(Покупка,Участник,?(Объект.Транзит, Объект.ПунктВыдачи, Объект.СвояТочка));
	ОбработатьШКнаКлиенте(ШК_Строка);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоКодуПосылки(Команда)
	ОткрытьФорму("ОбщаяФорма.ФормаВыбораПосылкиПоКодуПосылки",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ДобавитьПоПокупкеУчастнику_Завершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры


&НаКлиенте
Процедура ДобавитьПоШтрихКоду(Команда)
	ОбработатьШКнаКлиенте(ШтрихКод);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоПокупкеУчастнику(Команда)
	ОткрытьФорму("ОбщаяФорма.ВыборПосылкиПоПокупкеУчастнику",,ЭтотОбъект,,,,Новый ОписаниеОповещения("ДобавитьПоПокупкеУчастнику_Завершение", ЭтотОбъект), РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоПокупкеУчастнику_Завершение(ШК, ДополнительныеПараметры) Экспорт
	//Добавлено в ЕДТ
	Если ШК<>неопределено Тогда
		ДобавитьПосылку(ШК);
	КонецЕсли;		
КонецПроцедуры	


&НаКлиенте
Процедура ПоменятьПолку(Команда)
	Если Объект.Проведен Тогда
		Сообщить("Нельзя поменять место хранения . Документ уже проведен");
	Иначе	
		для н=0 по  Элементы.Покупки.ВыделенныеСтроки.Количество()-1 цикл
			Объект.Покупки[Элементы.Покупки.ВыделенныеСтроки[н]].МестоХранения    =ЭтаФорма.МестоХранения;
		конецЦикла;
		для н=0 по  Элементы.Посылки.ВыделенныеСтроки.Количество()-1 цикл
			Объект.Посылки[Элементы.Посылки.ВыделенныеСтроки[н]].МестоХранения    =ЭтаФорма.МестоХранения;
		конецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПоменятьГабарит(Команда)
	Если Объект.Проведен Тогда
		Сообщить("Нельзя поменять Габарит . Документ уже проведен");
	Иначе	
		для н=0 по Элементы.Покупки.ВыделенныеСтроки.Количество()-1 цикл
			Объект.Покупки[Элементы.Покупки.ВыделенныеСтроки[н]].Габарит    =ЭтаФорма.Габарит;

		конецЦикла;	
		для н=0 по Элементы.Посылки.ВыделенныеСтроки.Количество()-1 цикл
			Объект.Посылки[Элементы.Посылки.ВыделенныеСтроки[н]].Габарит    =ЭтаФорма.Габарит;
		конецЦикла;	
	КонецЕсли;
КонецПроцедуры



#КонецОбласти

#Область Вспомогательные

&НаКлиенте
Процедура ПроверитьПунктВыдачиИДобавитьЗаказ(ДанныеШК)
	ПВКорректен	= Истина;
	Если		Объект.Транзит 					 и  
		    не (ДанныеШК.ПунктВыдачи = Объект.ПунктВыдачи или 
				НеПроверятьТочку) 			Тогда 
		ТекстВопроса	= "Пункт выдачи заказа:"+ДанныеШК.ПунктВыдачи+" не совпадает с пунктом выдачи документа:"+Объект.ПунктВыдачи+". ";		
				
		ПВКорректен	= Ложь ;
	ИначеЕсли 	не Объект.Транзит и 
				не (ДанныеШК.ПунктВыдачи = Объект.СвояТочка)  Тогда
		ТекстВопроса	= "Заказ предназначен для пункта выдачи:"+ ДанныеШК.ПунктВыдачи+ ". ";		
		ПВКорректен	= Ложь;
		
	КонецЕсли;	
	Если не ОткрытДиалогВопроса Тогда
		Если не ПВКорректен Тогда
			ОткрытДиалогВопроса = Истина;
			ПоказатьВопрос(новый ОписаниеОповещения("ДобавитьЗаказ", ЭтотОбъект, ДанныеШК), ТекстВопроса
				+ "Все равно добавить?", РежимДиалогаВопрос.ДаНет);
				//		Ответ = Вопрос(ТекстВопроса + "Все равно добавить?", РежимДиалогаВопрос.ДаНет, 0, КодВозвратаДиалога.Нет);
			//		Если Ответ = КодВозвратаДиалога.Да Тогда
			//			Возврат Истина;
			//		КонецЕсли;
		Иначе
			ДобавитьЗаказ(КодВозвратаДиалога.Да, ДанныеШК)
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры	

&НаКлиенте
Процедура ДобавитьЗаказ(Результат, ДанныеШК) Экспорт
	
	Если Результат =  КодВозвратаДиалога.Нет Тогда
		ОткрытДиалогВопроса = Ложь; 
		Возврат; 
	КонецЕсли;
	
	Если Строка(ДанныеШК.Тип) = "Посылка (12)" Тогда
			ПсылкаДобавлена = ДобавитьПосылку(ДанныеШК);
			Если ПсылкаДобавлена Тогда
				СтоСП_Клиент.СигналДинамика();
			КонецЕсли;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПосылки;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Покупка (11)"
			или Строка(ДанныеШК.Тип) = "Заказ100маркета (33)" Тогда //11043940487532000904	
			ЗаказДобавлен = ДобавитьСтарыйЗаказ(ДанныеШК);
			Если ЗаказДобавлен Тогда
				СтоСП_Клиент.СигналДинамика();
			КОнецЕсли;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПокупки;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Коробка (44)" Тогда //44352952000899132115000954   44017898000522752026005685
			ЗаказДобавлен = ДобавитьГруппу(ДанныеШК);
			Если ЗаказДобавлен Тогда
				СтоСП_Клиент.СигналДинамика();
			КОнецЕсли;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПокупки;
	ИначеЕсли Строка(ДанныеШК.Тип) = "Заказ КД (45)" Тогда //44352952000899132115000954   44017898000522752026005685
			ЗаказДобавлен = ДобавитьЗаказКД(ДанныеШК);
			Если ЗаказДобавлен Тогда
				СтоСП_Клиент.СигналДинамика();
			КОнецЕсли;
			Элементы.ГруппаСтраницы.ТекущаяСтраница = Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПокупки;
	КонецЕсли;
	ОткрытДиалогВопроса = Ложь;
КонецПроцедуры

//Не испротзуется висит для примера
&НаСервере
Процедура ПодсветкаСтрок()

    ЭтаФорма.УсловноеОформление.Элементы.Очистить();
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Покупки");
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Покупки.Предупреждение");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Перечисления.ПредупрежденияПрихода.Дубль;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоЗолотистый);	
	
	ЭлементУсловногоОформления = УсловноеОформление.Элементы.Добавить();
	ОформляемоеПоле = ЭлементУсловногоОформления.Поля.Элементы.Добавить();
	ОформляемоеПоле.Поле = Новый ПолеКомпоновкиДанных("Покупки");
	ЭлементОтбора = ЭлементУсловногоОформления.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ЭлементОтбора.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Покупки.Предупреждение");
	ЭлементОтбора.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ЭлементОтбора.ПравоеЗначение = Перечисления.ПредупрежденияПрихода.ЧерныйСписок;
	ЭлементУсловногоОформления.Оформление.УстановитьЗначениеПараметра("ЦветФона", WebЦвета.СветлоСерый);	
	
КонецПроцедуры


Процедура УстановитьВидимость()
	Элементы.грТранзит.Видимость			= Объект.Транзит и не Объект.МультиОрг;
	Элементы.ЗаказыОрганизатор.Видимость	= Объект.Транзит или Объект.МультиОрг;
	Элементы.грПриход.Видимость				= не (Объект.Транзит или Объект.МультиОрг);
	Элементы.гпВесОбъем.Видимость			= Габарит.НеГабарит;
	Элементы.Дата.ТолькоПросмотр			= не РольДоступна("ПолныеПрава");
	
	Элементы.ОргСбор.Видимость				= Константы.ФлагОрганизаторОплачиваетРазборДоступность.Получить();
	Элементы.ПокупкиОргСбор.Видимость		= Элементы.ОргСбор.Видимость;
	
	Если Объект.Покупки.Количество()=0 Тогда
		Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПосылки;
	Конецесли;
	
	всегоПокупок = Объект.Покупки.Количество();
	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПокупки.Заголовок=?(всегоПокупок=0,"Покупки","Покупки ("+всегоПокупок+")");
	
	всегоПосылок = Объект.Посылки.Количество();
	Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.группаПосылки.Заголовок=?(всегоПосылок=0,"Посылки","Посылки ("+всегоПосылок+")");
	
	
КонецПроцедуры	


#КонецОбласти


#Область ОбменДанными

&НаСервере
Функция  ПросмотрXMLНаСервере()
	
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.Приходная"));
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
	об	=	ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.Приходная"));
	об.ВыгрузитьНаСайт();
	ЗначениеВДанныеФормы(об,Объект);
КонецПроцедуры

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
	
	СП_РаботаСДокументами.ПриСозданииНаСервере(ЭтотОбъект);	

	
	Если Параметры.Свойство("ПунктВыдачи") Тогда
		Объект.ПунктВыдачи = Параметры.ПунктВыдачи;
	КонецЕсли;	
	Если Параметры.Свойство("Транзит") Тогда
		Объект.Транзит = Параметры.Транзит;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(Объект.Ссылка) Тогда
		ЗаблокироватьДанныеФормыДляРедактирования();
	КонецЕсли;	
	
	
	
	Умолчания		= аСПНаСервере.ПолучитьЗначенияПоУмолчанию(Объект.ПунктВыдачи);
	Габарит			= Умолчания.Габарит;
	МестоХранения	= Умолчания.МестоХранения;
	
	
	КонтралироватьТочкиПользователя = Константы.КонтралироватьТочкиПользователя.Получить();
	Объект.ДелаемГрупповойСтикер	= Константы.ДелаемГруупповойСтикер.Получить();

	Покупка=справочники.Покупки.ПустаяСсылка();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОткрытДиалогВопроса = Ложь;
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	СП_РаботаСДокументами_Клиент.ПриОткрытии(ЭтотОбъект);
	 
	ОтдельнымМестом = Истина;
	Умолчания		= аСПНаСервере.ПолучитьЗначенияПоУмолчанию(Объект.ПунктВыдачи);
	Габарит			= Умолчания.Габарит;
	МестоХранения	= Умолчания.МестоХранения;
	
	ПодсветкаСтрок();
	
	//Сканер штрихкода
   СтоСП_Клиент.ПодключитьСканерШК(УникальныйИдентификатор);

	
	Оплачен=Истина;	
	УстановитьВидимость();
КонецПроцедуры


&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата=ТекущаяДата();	
	КонецЕсли;	
	
	Результат = ПроверитьОшибкиГрупп();
	Если Результат.ЕстьОшибки Тогда
		СтоСП_Клиент.СигналДинамика();
		СтоСП_Клиент.СигналДинамика();
		СтоСП_Клиент.СигналДинамика();
	
		Ответ	= Вопрос(Результат.ТекстСообщения + ". Продолжить?" , РежимДиалогаВопрос.ДаНет);
		Если Ответ = КодВозвратаДиалога.Нет Тогда
			Отказ =  истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Функция ПроверитьОшибкиГрупп()
	естьОшибки = ложь;
	ТекстСообщения = "";
	Для каждого элем из Объект.Покупки Цикл
		Если 	ТипЗнч(элем.покупка) = Тип("СправочникСсылка.Коробки") и 
			элем.покупка.ТочкаНазначения <> Объект.ПунктВыдачи			Тогда
			ТекстСообщения = ТекстСообщения + "В строке "+элем.НомерСтроки+" ПВ группы: " + элем.покупка.ТочкаНазначения+
			" отличается от ПВ документа: " + Объект.ПунктВыдачи + Символы.ПС;
			естьОшибки = Истина;
		КонецЕсли;		
	КонецЦикла;
	Для каждого элем из Объект.Посылки Цикл
		Если 	элем.Посылка.ПунктВыдачи <> Объект.ПунктВыдачи			Тогда
			ТекстСообщения = ТекстСообщения + "В строке "+элем.НомерСтроки+" ПВ посылки: " + элем.Посылка.ПунктВыдачи +
			" отличается от ПВ документа: " + Объект.ПунктВыдачи+Символы.ПС;
			естьОшибки = Истина;
		КонецЕсли;		
	КонецЦикла;
	возврат Новый Структура("естьОшибки, ТекстСообщения",естьОшибки, ТекстСообщения);
КонецФункции	


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если ТекущийОбъект.Проведен и  (ПараметрыЗаписи.РежимЗаписи=РежимЗаписиДокумента.Проведение или ПараметрыЗаписи.РежимЗаписи=РежимЗаписиДокумента.ОтменаПроведения) Тогда
		Если Константы.ЗапретРедактированияПрихода.Получить() Тогда	
			Отказ=аСППрверки.ИспользуетсяВДвижениях(ТекущийОбъект.Ссылка);
		КонецЕсли;	
	КонецЕсли;
КонецПроцедуры



&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	РежимЗаписи	=	ПараметрыЗаписи;
КонецПроцедуры

Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	Если 	ПараметрыЗаписи 				<> 	Неопределено
			и ПараметрыЗаписи.РежимЗаписи 	= 	РежимЗаписиДокумента.Проведение Тогда

		парам = Новый Массив();
		парам.Добавить(Объект.Ссылка);

		ФоновыеЗадания.Выполнить("аспПроцедурыОбменаДанными.УдалитьДокументИзОтправленных", парам, , "УдалитьДокументИзОтправленных");

		Если Константы.ВыгружатьПриходПриЗаписи.Получить() Тогда
			Попытка
				ФоновыеЗадания.Выполнить("СтоСПФоновые.Запустить_Выгрузку_100СП", , 1, "Запустить_Выгрузку_100СП");
			Исключение
			КонецПопытки;
		КонецЕсли;
	КонецЕсли;	
КонецПроцедуры	


///////

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ГруппаСтраницыПриСменеСтраницыНаСервере();
КонецПроцедуры

&НаСервере
Процедура ГруппаСтраницыПриСменеСтраницыНаСервере()
	Если Элементы.ГруппаСтраницы.ТекущаяСтраница=Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.ГруппаПротокол Тогда
		парамДок				= Протокол.Параметры.Элементы.Найти("Документ");
		парамДок.Значение		= Объект.Ссылка;
		парамДок.Использование	= Истина;
	Конецесли;	
КонецПроцедуры

&НаКлиенте
Процедура ТранзитПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура МультиОргПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ТочкаНазначенияПриИзменении(Элемент)
	Умолчания		= аСПНаСервере.ПолучитьЗначенияПоУмолчанию(Объект.ПунктВыдачи,ложь);
	Габарит			= ?(ЗначениеЗаполнено(Умолчания.Габарит),Умолчания.Габарит,Габарит);
	МестоХранения	= ?(ЗначениеЗаполнено(Умолчания.МестоХранения),Умолчания.МестоХранения,МестоХранения);
КонецПроцедуры

&НаКлиенте
Процедура ГабаритПриИзменении(Элемент)
	УстановитьВидимость();
	Вес		= 0;
	объем	= 0;
КонецПроцедуры

&НаКлиенте
Процедура ПокупкиПосылкиПослеУдаления(Элемент)
	УстановитьВидимость();
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




// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
 






