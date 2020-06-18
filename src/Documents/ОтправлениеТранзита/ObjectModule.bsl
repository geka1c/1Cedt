перем ЭтоEMS;



Функция ПолучитьАдресДоставки_Api() Экспорт
	Если Заказы.Количество()>0 Тогда
		результат = СП_АдресаДоставки.выполнитьЗапрос(Заказы[0].КодЗаказа,Ссылка );
		ЗаполнитьЗначенияСвойств(ЭтотОбъект, Результат.СтруктураАдреса);
	КонецЕсли;
КонецФункции



#Область ГруппыДоставки
Процедура Заполнить_ГруппуДоставки_По_Отпралению(Отказ)
	Если  не ЗначениеЗаполнено(Коробка) или 
		     Коробка.ВидСтикера<>Перечисления.ВидыСтикеров.ГруппаДоставки Тогда
			 Возврат;
	КОнецесли;
	
	Если ЗначениеЗаполнено(Коробка.ОтправлениеТранзита) и Коробка.ОтправлениеТранзита <> Ссылка    Тогда
		ТекстСообщения = "Группа доставки "+Коробка+" уже выбрана в "+Коробка.ОтправлениеТранзита;
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения,,,,Отказ);
		Возврат;
	КонецЕсли;

	об_ГруппаДоставки 								= Коробка.ПолучитьОбъект();
	об_ГруппаДоставки.ОтправлениеТранзита			= Ссылка;
	об_ГруппаДоставки.НомерЗаказа					= НомерЗаказа;
	об_ГруппаДоставки.Вес							= Вес;
	об_ГруппаДоставки.Длина							= Длина;
	об_ГруппаДоставки.Ширина						= Длина;
	об_ГруппаДоставки.Высота						= Высота;
	об_ГруппаДоставки.ДатаВзвешивания				= Дата;
	об_ГруппаДоставки.СтоимостьДоставки				= СтоимостьДоставки;
	об_ГруппаДоставки.СтоимостьДоставкиПредоплата	= СтоимостьДоставкиПредоплата;
	
	
	исключенныеЗаказы = Заказы.НайтиСтроки(новый Структура("Исключить",Истина));	
	Для каждого стр из исключенныеЗаказы Цикл
		заказыВгруппе = об_ГруппаДоставки.Состав.НайтиСтроки(новый Структура("Покупка, Участник",стр.Покупка,Участник)) ;
		Для каждого строкаГруппы Из заказыВгруппе Цикл
			строкаГруппы.Исключить	= истина;
			строкаГруппы.Удалить	= Ложь;
			строкаГруппы.СообщениеУдаления=стр.СообщениеУдаления;
		КОнецЦикла	
	КонецЦикла;	
	
	удаленныеЗаказы = Заказы.НайтиСтроки(новый Структура("Удалить",Истина));	
	Для каждого стр из удаленныеЗаказы Цикл
		заказыВгруппе = об_ГруппаДоставки.Состав.НайтиСтроки(новый Структура("Покупка, Участник",стр.Покупка,Участник)) ;
		Для каждого строкаГруппы Из заказыВгруппе Цикл
			строкаГруппы.Удалить	= истина;
			строкаГруппы.Исключить 	= Ложь;
			строкаГруппы.СообщениеУдаления=стр.СообщениеУдаления;
		КОнецЦикла	
	КонецЦикла;	
	Попытка
		об_ГруппаДоставки.Записать();
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("не удалось обновить группу :" + Коробка +". "+ОписаниеОшибки(),,,,Отказ);
	КонецПопытки;
КонецПроцедуры
#КонецОбласти


#Область СобытияФормы
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	СоздатьКоробкуЗаказ();
КонецПроцедуры


Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если 	ЗначениеЗаполнено(Коробка) И Коробка.ВидСтикера=Перечисления.ВидыСтикеров.ГруппаДоставки  
		и 	коробка.МетодОплаты	= Перечисления.МетодыОплаты.cod
		и   ТочкаНазначения		<> Справочники.ТочкиРаздачи.НайтиПоКоду("0100") 	Тогда
		ПроверяемыеРеквизиты.Добавить("ИтогоСтоимость");
	КонецЕсли;
	Если ТочкаНазначения = СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0100") Тогда
		инд=ПроверяемыеРеквизиты.Найти("Вес");
		Если инд <> Неопределено Тогда 
			ПроверяемыеРеквизиты.Удалить(инд);
		КонецЕсли;
	КонецЕсли	
КонецПроцедуры

#КонецОбласти


#Область ОбработкаПроведения

Процедура ОбработкаПроведения(Отказ, Режим)
	
	Заполнить_ГруппуДоставки_По_Отпралению(Отказ);
	
	#Область ПравильноеПроведение
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, Режим);
	Документы.ОтправлениеТранзита.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.Вставить("ЭтоНовый",ЭтоНовый());
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СП_ДвиженияСервер.ОтразитьТранзит(ДополнительныеСвойства, Движения, Отказ);
	СП_ДвиженияСервер.ОтразитьЗаказыВПосылках(ДополнительныеСвойства, Движения, Отказ);
	
	#КонецОбласти
	
	
	
	//	Движения.Транзит.Записывать = Истина;
	//	Для Каждого ТекСтрокаЗаказы Из Заказы Цикл
	//		Движение = Движения.Транзит.Добавить();
	//		Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	//		Движение.Период = Дата;
	//		Движение.Габарит = ТекСтрокаЗаказы.Габарит;
	//		Движение.Участник = Участник;
	//		Движение.МестоХранения = ТекСтрокаЗаказы.МестоХранения;
	//		Движение.Партия = ТекСтрокаЗаказы.Партия;
	//		Движение.ПокупкаСсылка = ТекСтрокаЗаказы.Покупка;
	//		Движение.Точка = ТекСтрокаЗаказы.Точка;
	//		Движение.Количество = ТекСтрокаЗаказы.Количество;
	//	КонецЦикла;
	//
	
	Если ЗначениеЗаполнено(Коробка) И Коробка.ВидСтикера=Перечисления.ВидыСтикеров.ГруппаДоставки  
		и не ЗначениеЗаполнено(коробка.МетодОплаты) Тогда
		//Движение = Движения.СтатусыГруппДоставки.Добавить();
		//Движение.ГруппаДоставки=Коробка;
		//Движение.Статус=Перечисления.СтатусыГруппДоставкиНаТочке.ЖдемОплату;
		
		
		
		
	Иначе
		//Движение = Движения.СтатусыГруппДоставки.Добавить();
		//Движение.ГруппаДоставки=Коробка;
		//Движение.Статус=Перечисления.СтатусыГруппДоставкиНаТочке.ЖдемОтправление;
		
		
		
		Если ЗначениеЗаполнено(Коробка) Тогда
			//Движение = Движения.Транзит.Добавить();
			//Движение.ВидДвижения = ВидДвиженияНакопления.Приход;
			//Движение.Период = Дата;
			//Движение.Габарит = Габарит;
			//Движение.Участник = Коробка.УчастникГД;
			//Движение.МестоХранения = МестоХранения;
			//Движение.Партия = Ссылка;
			//Движение.ПокупкаСсылка = Коробка;
			//Движение.Точка = ТочкаНазначения;
			//Движение.Количество = 1;
			
			//Движение 				= Движения.Приход.Добавить();
			//Движение.Период 		= Дата;
			//Движение.Организатор	= Коробка.Организатор;
			//Движение.Габарит 	 	= Габарит;
			//
			//Движение.ТипПрихода		= Перечисления.ТипыПриходов.НаТранзит;
			//Движение.Участник       = Коробка.УчастникГД;
			//Движение.Коробка		= Коробка;
			//Движение.Покупка 		= Коробка;
			//Движение.ПокупкаСпр		= Коробка.Код;
			//Движение.Количество 	= 1;
		КонецЕсли;
		
		ДвиженияСтатусыДоставки(Отказ, Режим);
		ДвиженияСтатусыДоставкиСвернуто(Отказ, Режим);
	КонецЕсли;
	
КонецПроцедуры

Процедура ДвиженияСтатусыДоставки(Отказ, Режим)
	Если не ЗначениеЗаполнено(Коробка) Тогда Возврат КонецЕсли;
	Движения.СтатусыДоставки.Записывать = Истина;
	
	Движение = Движения.СтатусыДоставки.Добавить();
	Движение.Период = Дата;
	Движение.Груз = Коробка;
	Движение.Статус = Перечисления.СтатусыОтправкиГруза.НаСкладе;
КонецПроцедуры

Процедура ДвиженияСтатусыДоставкиСвернуто(Отказ, Режим)
	Если не ЗначениеЗаполнено(Коробка) Тогда Возврат КонецЕсли;

		Движения.СтатусыДоставкиСвернуто.Записывать = Истина;
		Движение = Движения.СтатусыДоставкиСвернуто.Добавить();
		Движение.Период = Дата;
		Движение.Статус = Перечисления.СтатусыОтправкиГруза.НаСкладе;
		Движение.ЗаявкаВТК=Документы.ЗаявкаВТранспортнуюКомпанию.ПустаяСсылка();
		Движение.Количество=Заказы.Количество();
		Движение.КоличествоГС=1;
		Движение.КоличествоМест=0;

	КонецПроцедуры
	
Процедура ОбработкаУдаленияПроведения(Отказ)
	Если ЗначениеЗаполнено(Коробка) И Коробка.ВидСтикера=Перечисления.ВидыСтикеров.ГруппаДоставки Тогда
		
		обКоробка=Коробка.ПолучитьОбъект();
		обКоробка.ОтправлениеТранзита=Документы.ОтправлениеТранзита.ПустаяСсылка();
		Попытка
			обКоробка.Записать();
		Исключение
			Отказ =Истина;
		КонецПопытки;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти


#Область СДЭК

Процедура СформироватьЗаказСДЭК() Экспорт
	Отказ=Ложь;
	стрХМЛ=ОбменДаннымиСДЭК.ПолучитьХМЛСДЭКСоздатьЗаказ(Ссылка);
	
	стрПротокол=новый Структура;
	стрПротокол.Вставить("ОтправленныеДанные",стрХМЛ);
	стрПротокол.Вставить("ДатаНачала",ТекущаяДата());
	стрПротокол.Вставить("ВидОбмена",Перечисления.ВидыОбменовСДЭК.СозданиеЗаказаНаДоставку);
	
	Файл=ОбменДаннымиСДЭК.ОбменССайтом(ТочкаНазначения,стрХМЛ,Отказ,Перечисления.ВидыОбменовСДЭК.СозданиеЗаказаНаДоставку);
	
	Если Файл<>неопределено Тогда
		стрПротокол.Вставить("ПолученныеДанные",ОбменДаннымиСДЭК.ФайлВСтроку(Файл));
		Протокол=ПротоколыПередач.Добавить();
		НомерСДЭК=ОбменДаннымиСДЭК.ПолучитьНомерСДЭК(Файл);
		//НомерСДЭК=ОбменДаннымиСДЭК.ПолучитьНомерСДЭК("C:\Windows\Temp\111.ansv");
		Если НомерСДЭК=неопределено Тогда
			стрПротокол.Вставить("Результат","error");
		Иначе
			НомерЗаказа=НомерСДЭК;
			стрПротокол.Вставить("Результат","Получен номер");
		КонецЕсли;
		стрПротокол.Вставить("ДатаОкончания",ТекущаяДата());

		ЗаполнитьЗначенияСвойств(Протокол,стрПротокол);
	КонецЕсли;
	СоздатьКоробкуЗаказ();	
КонецПроцедуры	

Процедура УдалитьЗаказСДЭК() Экспорт
	Отказ=Ложь;
	стрХМЛ=ОбменДаннымиСДЭК.ПолучитьХМЛСДЭКУдалитьЗаказ(Ссылка);
	
	стрПротокол=новый Структура;
	стрПротокол.Вставить("ОтправленныеДанные",стрХМЛ);
	стрПротокол.Вставить("ДатаНачала",ТекущаяДата());
	стрПротокол.Вставить("ВидОбмена",Перечисления.ВидыОбменовСДЭК.УдалениеЗаказа);

	
	
	Файл=ОбменДаннымиСДЭК.ОбменССайтом(ТочкаНазначения,стрХМЛ,Отказ,Перечисления.ВидыОбменовСДЭК.УдалениеЗаказа);
	
	
	Если Файл<>неопределено Тогда
		стрПротокол.Вставить("ПолученныеДанные",ОбменДаннымиСДЭК.ФайлВСтроку(Файл));
		Протокол=ПротоколыПередач.Добавить();
		УдалилиЗаказ=ОбменДаннымиСДЭК.ПолучитьОтветНаУдалениеСДЭК(Файл);
		Если УдалилиЗаказ Тогда
			стрПротокол.Вставить("Результат","Заказ удален");
			НомерЗаказа="";
		Иначе
			стрПротокол.Вставить("Результат","error");
		КонецЕсли;
		стрПротокол.Вставить("ДатаОкончания",ТекущаяДата());

		ЗаполнитьЗначенияСвойств(Протокол,стрПротокол);
	КонецЕсли;
	
	
КонецПроцедуры	

Функция СформироватьКвитанциюСДЭК() Экспорт
	Отказ=Ложь;
	стрХМЛ=ОбменДаннымиСДЭК.ПолучитьХМЛСДЭКПолучитьКвитанцию(Ссылка);
	
	стрПротокол=новый Структура;
	стрПротокол.Вставить("ОтправленныеДанные",стрХМЛ);
	стрПротокол.Вставить("ДатаНачала",ТекущаяДата());
	стрПротокол.Вставить("ВидОбмена",Перечисления.ВидыОбменовСДЭК.ПолучитьКвитанцию);

	
	
	Файл=ОбменДаннымиСДЭК.ОбменССайтом(ТочкаНазначения,стрХМЛ,Отказ,Перечисления.ВидыОбменовСДЭК.ПолучитьКвитанцию);
	
	
	Если Файл<>неопределено Тогда
		Протокол=ПротоколыПередач.Добавить();
		Попытка
			НомерСДЭК=ОбменДаннымиСДЭК.ПолучитьНомерСДЭКОшибкаКвитанции(Файл);
		Исключение
			НомерСДЭК=Неопределено;
		КонецПопытки;
		Если НомерСДЭК=неопределено Тогда
			стрПротокол.Вставить("Результат","Получена квитанция");
		Иначе
			стрПротокол.Вставить("Результат","error");
			стрПротокол.Вставить("ПолученныеДанные",ОбменДаннымиСДЭК.ФайлВСтроку(Файл));
		КонецЕсли;
		стрПротокол.Вставить("ДатаОкончания",ТекущаяДата());

		ЗаполнитьЗначенияСвойств(Протокол,стрПротокол);
	КонецЕсли;
	Если НомерСДЭК=неопределено Тогда
		ДвоичныеДанныеВложения = Новый ДвоичныеДанные(Файл);
		Адрес = ПоместитьВоВременноеХранилище(ДвоичныеДанныеВложения);
		Возврат Адрес;
		//Возврат Файл;
	Иначе
		Возврат неопределено;
	КонецЕсли;	
КонецФункции



#КонецОбласти

#Область ПостКальк

Процедура  ПолучитьСтоимостьПоТарифуПостКалк() Экспорт
	Отказ=Ложь;
	
	Параметры=Новый Структура;
	//Параметры.Вставить("СерверТК","test.postcalc.ru");
	Параметры.Вставить("СерверТК","api.postcalc.ru");

	Параметры.Вставить("Откуда",Константы.ПочтовыйИндекс.Получить());
	Параметры.Вставить("Куда",Индекс);
	Параметры.Вставить("Вес",Вес);
	Параметры.Вставить("Ценность",ТарифТК);
	Параметры.Вставить("ПродавецДляТК","100sp.ru");
	Параметры.Вставить("Майл","absentx@yandex.ru");
	
	СтруктураРасчета=ОбменДаннымиПостКалк.ПослатьЗапрос(Параметры);
	РасчетКалькулятораПочта.Очистить();
	Для Каждого стр из СтруктураРасчета Цикл
		стрТЧ=РасчетКалькулятораПочта.Добавить();
		ЗаполнитьЗначенияСвойств(стрТЧ,стр.Значение);
		
	КонецЦикла;
КонецПроцедуры	

Функция СформироватьКвитанциюПостКалкФ7П() Экспорт
	обр=Обработки.ОбменСПочтойРоссии.Создать();
	Возврат обр.ОбменССайтомКвитанцияФ7П(Ссылка) ;
КонецФункции

Функция СформироватьКвитанциюПостКалкФ112() Экспорт
	обр=Обработки.ОбменСПочтойРоссии.Создать();
	Возврат обр.ОбменССайтомКвитанцияФ112(Ссылка) ;
КонецФункции
#КонецОбласти

#Область Бокбери

Процедура УдалитьЗаказBoxBerry() Экспорт
	Отказ=Ложь;
	стрХМЛ=ОбменДаннымиСДЭК.ПолучитьХМЛСДЭКУдалитьЗаказ(Ссылка);
	
	стрПротокол=новый Структура;
	стрПротокол.Вставить("ОтправленныеДанные",стрХМЛ);
	стрПротокол.Вставить("ДатаНачала",ТекущаяДата());
	стрПротокол.Вставить("ВидОбмена",Перечисления.ВидыОбменовСДЭК.УдалениеЗаказа);

	ответ= Интеграция_BoxBerry.УдалитьЗаказ(НомерЗаказа);
КонецПроцедуры	

Функция СформироватьКвитанциюBoxBerry() Экспорт
	Результат=новый Структура;
	
	ответ=Интеграция_BoxBerry.ПечатьЭтикеток(НомерЗаказа);
	Если Ответ.Успех Тогда
		Результат.Вставить("Квитанция",Ответ.Результат.label);
	КонецЕсли;
	
	Возврат Результат ;
КонецФункции


#КонецОбласти

#Область ПочтаРоссии
 Процедура ПолучитьСтоимостьПоТарифуПочтаРоссии() Экспорт 
	
	Параметры=Новый Соответствие;
	
	Параметры.Вставить("declared-value",	 	ОбъявленнаяСтоимость*100 ); 				// Объявленная стоимость целое
	Параметры.Вставить("dimension", 			Новый Структура("height ,length ,width", Высота,Длина,Ширина)); //Сантиметры
	Параметры.Вставить("fragile", 				Хрупкое); 				//Осторожно хрупко 
	Параметры.Вставить("index-from", 			ИндексОтправителя); 			//Откуда
	Параметры.Вставить("index-to", 				Индекс);	 		//КУда
	Параметры.Вставить("mail-category", 		КатегорияРПО);		//Категория РПО
	Параметры.Вставить("mail-type", 			ВидРПО);			//Вид РПО
	Параметры.Вставить("mass",					Вес);	 			//Масса отправления в граммах 
	Параметры.Вставить("with-simple-notice",	Ложь);				//Отметка 'С простым уведомлением'
	
	

	стрПротокол=новый Структура;
	стрПротокол.Вставить("ДатаНачала",ТекущаяДата());
	стрПротокол.Вставить("ВидОбмена",Перечисления.ВидыОбменовСДЭК.СтоимостьПоТарифу);
	
	Параметры.Вставить("ЭтоEMS",				ЭтоEMS);				//Отметка 'С простым уведомлением'
 	СтруктураРасчета	= Интеграция_ПочтаРоссии.РасчетСтоимости(Параметры);	
	стрПротокол.Вставить("ПолученныеДанные",СтруктураРасчета.ПолученныеДанные);
	стрПротокол.Вставить("ОтправленныеДанные",СтруктураРасчета.ОтправленныеДанные);
	стрПротокол.Вставить("ДатаОкончания",ТекущаяДата());
	Протокол=ПротоколыПередач.Добавить();
	ЗаполнитьЗначенияСвойств(Протокол,стрПротокол);
	Если не СтруктураРасчета.Успешно Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось подключиться к АПИ "+Символы.ПС+
		СтруктураРасчета.ПолученныеДанные);
		Возврат;
	КонецЕсли;	
	Стоимость=0;
	Если СтруктураРасчета.Свойство("totalrate") Тогда
		Стоимость=СтруктураРасчета.totalrate;
	КонецЕсли;	
	Если СтруктураРасчета.Свойство("totalvat") Тогда
		Стоимость=Стоимость+СтруктураРасчета.totalvat;
	КонецЕсли;	
	Стоимость=Стоимость/100;
	
	 
	РасчетКалькулятора="Итоговая цена: "+Стоимость+ " руб."+Символы.ПС+
			"	Плата всего: "+?(СтруктураРасчета.Свойство("totalrate"),СтруктураРасчета.totalrate/100," --- ")+ " "+Символы.ПС+
			"	Всего НДС  : "+?(СтруктураРасчета.Свойство("totalvat"),СтруктураРасчета.totalvat/100," --- ")+ " "+Символы.ПС;
	Если  СтруктураРасчета.Свойство("deliverytime") Тогда		
			РасчетКалькулятора=РасчетКалькулятора+
			"Время доставки  : "+Символы.ПС+
			"	Макс (дни) : "+?(СтруктураРасчета.deliverytime.Свойство("maxdays"),СтруктураРасчета.deliverytime.maxdays," --- ")+ " "+Символы.ПС+
			"	Мин (дни)  : "+?(СтруктураРасчета.deliverytime.Свойство("mindays"),СтруктураРасчета.deliverytime.mindays," --- ")+ " "+Символы.ПС;
	КОнецЕсли;			
	ТарифТК=Стоимость;
	
	
 КонецПроцедуры
 
 Процедура СформироватьЗаказПочтаРоссии(ПараметрыФИО) Экспорт
	 Если  Коробка.МетодОплаты=Перечисления.МетодыОплаты.cod и ОбъявленнаяСтоимость<ИтогоСтоимость Тогда
		 ОбъявленнаяСтоимость=ИтогоСтоимость;
	КонецЕсли;	 
	Параметры=Новый Соответствие;
	
	Параметры.Вставить("dimension", 			Новый Структура("height ,length ,width", Высота,Длина,Ширина)); //Сантиметры
	Параметры.Вставить("Негаборит", 			Негаборит); 
	Параметры.Вставить("fragile", 				Хрупкое); 			//Осторожно хрупко 
	Параметры.Вставить("mass",					Вес);	 			//Масса отправления в граммах 
	
	Параметры.Вставить("mail-category", 		КатегорияРПО);		//Категория РПО
	Параметры.Вставить("mail-type", 			ВидРПО);			//Вид РПО
	Параметры.Вставить("НомерГС",				Коробка.Код);		//Вид РПО
	Параметры.Вставить("payment", 				?(Коробка.МетодОплаты=Перечисления.МетодыОплаты.prepay,0,ИтогоСтоимость)*100);			//Сумма наложенного платежа (копейки) 
	Параметры.Вставить("ОбъявленнаяСтоимость", 	ОбъявленнаяСтоимость*100);															//Сумма объявленной ценности (копейки)) 

	Параметры.Вставить("Фамилия", 				ПараметрыФИО.Фамилия);		
	Параметры.Вставить("Имя", 					ПараметрыФИО.Имя);			
	Параметры.Вставить("Отчество", 				ПараметрыФИО.Отчество);	
	
	Параметры.Вставить("Регион",				Регион);				//Область, регион 	
	Параметры.Вставить("Город",					Город);					//Населенный пункт 
	Параметры.Вставить("ИндексОтправителя",		ИндексОтправителя);		//Индекс места приема 
	Параметры.Вставить("Улица",					Улица);					//Часть адреса: Улица 
	Параметры.Вставить("НомерДома",				Дом);					//Часть адреса: Номер здания 
	Параметры.Вставить("Индекс",				Индекс);   				//Почтовый индекс  
	Параметры.Вставить("Телефон",				Телефон);				//Телефон получателя (может быть обязательным для некоторых типов отправлений) 
	
	
	стрПротокол=новый Структура;
	стрПротокол.Вставить("ДатаНачала",			ТекущаяДата());
	стрПротокол.Вставить("ВидОбмена",			Перечисления.ВидыОбменовСДЭК.СозданиеЗаказаНаДоставку);
 	Результат	= Интеграция_ПочтаРоссии.СформироватьЗаказ(Параметры,ЭтоEMS);
	
	стрПротокол.Вставить("ПолученныеДанные",	Результат.ПолученныеДанные);
	стрПротокол.Вставить("ОтправленныеДанные",	Результат.ОтправленныеДанные);
	стрПротокол.Вставить("ДатаОкончания",		ТекущаяДата());
	Протокол=ПротоколыПередач.Добавить();
	ЗаполнитьЗначенияСвойств(Протокол,стрПротокол);
	Если Результат.Успешно и Результат.Свойство("resultids") Тогда
		ВнутреннийНомерЗаказаТК=Формат(Результат.resultids[0],"ЧГ=0");
		Протокол.Результат="Получен внутренний номер";
	Иначе	
		Протокол.Результат="error";
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось получить Трэк номер"+Символы.ПС+Результат.ПолученныеДанные);
	КонецЕсли;	
	Если ВнутреннийНомерЗаказаТК="" Тогда
		ОписаниеЗаказаПочтаРоссии(НомерЗаказа);
	Иначе	
		ОписаниеЗаказаПочтаРоссии(ВнутреннийНомерЗаказаТК);
	КонецЕсли;	
КонецПроцедуры	


 Процедура ОписаниеЗаказаПочтаРоссии(НЗаказа) Экспорт
 	стрПротокол=новый Структура;
	стрПротокол.Вставить("ДатаНачала",			ТекущаяДата());
	стрПротокол.Вставить("ВидОбмена",			Перечисления.ВидыОбменовСДЭК.СозданиеЗаказаНаДоставку);

	Результат=Интеграция_ПочтаРоссии.ПолучитьИнформациюПоЗаказу(НЗаказа,ЭтоEMS);
	
	стрПротокол.Вставить("ПолученныеДанные",	Результат.ПолученныеДанные);
	стрПротокол.Вставить("ОтправленныеДанные",	Результат.ОтправленныеДанные);
	стрПротокол.Вставить("ДатаОкончания",		ТекущаяДата());
	Протокол=ПротоколыПередач.Добавить();
	ЗаполнитьЗначенияСвойств(Протокол,стрПротокол);
	Если Результат.Успешно и Результат.Свойство("barcode") Тогда
		НомерЗаказа=Формат(Результат.barcode,"ЧГ=0");
		Протокол.Результат="Получен номер";
	Иначе	
		Протокол.Результат="error";
	КонецЕсли;	
	
КонецПроцедуры	



#КонецОбласти




Процедура  СоздатьКоробкуЗаказ()
	Если не ЗначениеЗаполнено(НомерЗаказа) Тогда Возврат; КонецЕсли;
	Если 	ЗначениеЗаполнено(Коробка) и 
			Коробка.ВидСтикера	=	Перечисления.ВидыСтикеров.ГруппаДоставки 
	Тогда Возврат; КонецЕсли;
	
	КодКоробки		= Строка(ТочкаНазначения.Код)+"_"+НомерЗаказа;	
	ПараметрыЗаказа	= новый Структура;
	

	ПараметрыЗаказа.Вставить("ВидСтикера",		Перечисления.ВидыСтикеров.ЗаказТК);
	ПараметрыЗаказа.Вставить("НомерЗаказа",		НомерЗаказа);
	ПараметрыЗаказа.Вставить("Количество",		Заказы.Количество());
	ПараметрыЗаказа.Вставить("Догрузить",		Ложь);
	ПараметрыЗаказа.Вставить("ТочкаНазначения",	ТочкаНазначения);
	ПараметрыЗаказа.Вставить("Вес",				Вес/1000);
	ПараметрыЗаказа.Вставить("Объем",			(Длина/100)*(Ширина/100)*(Высота/100));
	тзСостав	= 			Заказы.Выгрузить(,"Покупка");
	тзСостав.Колонки.Добавить("Участник", новый ОписаниеТипов("СправочникСсылка.Участники"));
	тзСостав.ЗаполнитьЗначения(Участник,"Участник");
	ПараметрыЗаказа.Вставить("Состав",			тзСостав);
	
	Коробка			=	СП_РаботаСоСправочниками.ПолучитьКоробкуПо_Коду(КодКоробки);
	СП_РаботаСоСправочниками.ОбновитьКоробку(Коробка, ПараметрыЗаказа);
КонецПроцедуры



Функция СформироватьКвитанциюПБРФ() Экспорт
	Отказ=Ложь;
	стрЖСОН=ОбменДаннымиПостКалк.ПолучитьЖСОНПБФ(Ссылка);
	
	стрПротокол=новый Структура;
	стрПротокол.Вставить("ОтправленныеДанные",стрЖСОН);
	стрПротокол.Вставить("ДатаНачала",ТекущаяДата());
	стрПротокол.Вставить("ВидОбмена",Перечисления.ВидыОбменовСДЭК.СтоимостьПоТарифу);

	Ответ=ОбменДаннымиПостКалк.ОбменССайтомПБФ(стрЖСОН,Отказ);
	
	
	Если Ответ<>неопределено Тогда
		стрПротокол.Вставить("ПолученныеДанные",Ответ);
		Протокол=ПротоколыПередач.Добавить();
		структураЖсон=ОбменДаннымиСДЭК.РазобратьЖСОН(Ответ);
		Если структураЖсон.Свойство("error") Тогда
			РасчетКалькулятораП="";
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Возникли ошибки при расчете стоимости: ",,,,Отказ);
			Для каждого элем из структураЖсон.error Цикл
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("код ошибки:"+элем.code+"; описание: "+элем.text,,,,Отказ);
				РасчетКалькулятораП=РасчетКалькулятораП+"код ошибки:"+элем.code+"; описание: "+элем.text+Символы.ПС;
			КонецЦикла;
			стрПротокол.Вставить("Результат","error");
		ИначеЕсли структураЖсон.Свойство("result") Тогда
			стрПротокол.Вставить("Результат","Получена стоимость");
			РасчетКалькулятораП="сумма за доставку: "+структураЖсон.result.price+ " руб."+Символы.ПС+
			"минимальная дата доставки: "+структураЖсон.result.deliveryDateMin+ " "+Символы.ПС+
			"максимальная дата доставки: "+структураЖсон.result.deliveryDateMax+ " "+Символы.ПС+
			"код тарифа: "+структураЖсон.result.tariffId;
			ТарифТК=структураЖсон.result.price;
			//Если Число(структураЖсон.result.price)<>Тариф.Стоимость Тогда
			//	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Стоимость по тарифу: "+Строка(Тариф.Стоимость)+" отличается от стоимости калькулятора СДЭК: "+Строка(структураЖсон.result.price));	
			//КонецЕсли	
		КонецЕсли;	
		
		//НомерСДЭК=ОбменДаннымиСДЭК.ПолучитьНомерСДЭК(Файл);
		////НомерСДЭК=ОбменДаннымиСДЭК.ПолучитьНомерСДЭК("C:\Windows\Temp\111.ansv");
		//Если НомерСДЭК=неопределено Тогда
		//	стрПротокол.Вставить("Результат","error");
		//Иначе
		//	НомерЗаказа=НомерСДЭК;
		//	стрПротокол.Вставить("Результат","Получен номер");
		//КонецЕсли;
		стрПротокол.Вставить("ДатаОкончания",ТекущаяДата());

		ЗаполнитьЗначенияСвойств(Протокол,стрПротокол);
	КонецЕсли;
	

КонецФункции

Функция СформироватьКвитанциюПР() Экспорт
	ИмяФайла   = ПолучитьИмяВременногоФайла("doс");

	СсылкаМакет = ПолучитьМакет("Макет");
	Word = СсылкаМакет.Получить();
	
	СсылкаМакет = Word.Application.Documents(1);
	СсылкаМакет.Activate();
	
	
	
	
	//
	//Word1C = Новый COMОбъект("Word.Application");
	//
	//Word1C.Visible = 0; 
	//

	//Word1C.Documents.Add();
	//мДок = мNewDoc.Add("C:\2\ф7.doc", 0, 0, 1);   
	//
	//мОбъект = мДок.Content;
	//
	//// подставляем значения по тексту договора - признак замены []
	//мПокупатель="Иванов Иван Иванович";
	//мОбъект.Find.Execute("[ОтКого]",0,0,,,,,,,мПокупатель,2); 
	//
	////мОбъект.Find.Execute("[ПечДатаДоговора]",0,0,,,,,,,Нрег(СокрЛП(мДатаДоговора)),2); 
	////
	////мОбъект.Find.Execute("[ПечПокупатель]",0,0,,,,,,,СокрЛП(мПокупатель),2); 
	////
	////мОбъект.Find.Execute("[ПечРуководитель]",0,0,,,,,,,мПечОтветственноеЛицо,2); 
	////
	////мОбъект.Find.Execute("[ПечОснование]",0,0,,,,,,,СокрЛП(Основание),2);      
	//
	//// подставляем значения в реквизиты покупателя: надпись, признак замены []
	//
	//СчетчикЦикла = 0;
	//
	//КолВоНадписей = мДок.Shapes.Count;
	//
	//Для СчетчикЦикла = 1 По КолВоНадписей Цикл 
	//	
	//	мНашли = мДок.Shapes.Item(СчетчикЦикла).Select(); 
	//	
	//	Если Число(мДок.Application.Selection.ShapeRange.Type) = 17 Тогда
	//		
	//		мДок.Application.Selection.Range.Find.Execute("[ОтКого]",0,0,,,,,,,СокрЛП(мПокупатель),2);
	//		
	//		//мДок.Application.Selection.Range.Find.Execute("[ПечЮрАдресПокупателя]",0,0,,,,,,,СокрЛП(мЮрАдресПокупателя),2);
	//		//
	//		//мДок.Application.Selection.Range.Find.Execute("[ПечПочтАдресПокупателя]",0,0,,,,,,,СокрЛП(мПочтПокупателя),2);
	//		//
	//		//мДок.Application.Selection.Range.Find.Execute("[ПечТелефонПокупателя]",0,0,,,,,,,СокрЛП(мТелефонПокупателя),2);
	//		//
	//		//мДок.Application.Selection.Range.Find.Execute("[ПечИННПокупателя]",0,0,,,,,,,СокрЛП(мИННПокупателя),2);
	//		//
	//		//мДок.Application.Selection.Range.Find.Execute("[ПечКПППокупателя]",0,0,,,,,,,СокрЛП(мКПППокупателя),2);
	//		//
	//		//мДок.Application.Selection.Range.Find.Execute("[ПечРСПокупателя]",0,0,,,,,,,СокрЛП(мРСчетПокупателя),2);
	//		//
	//		//мДок.Application.Selection.Range.Find.Execute("[ПечБанкПокупателя]",0,0,,,,,,,СокрЛП(мБанкПокупателя),2);
	//		//
	//		//мДок.Application.Selection.Range.Find.Execute("[ПечКСПокупателя]",0,0,,,,,,,СокрЛП(мКСчетПокупателя),2);
	//		//
	//		//мДок.Application.Selection.Range.Find.Execute("[ПечБИКБанкаПокупателя]",0,0,,,,,,,СокрЛП(мБИКПокупателя),2);
	//		//
	//		//мДок.Application.Selection.Range.Find.Execute("[ПечПокупательПодпись]",0,0,,,,,,,СокрЛП(ПодписьОтветственногоЛица),2);
	//		
	//	КонецЕсли;
	//	
	//КонецЦикла;
	//
	//// записываем файл
	//
	//мДок.SaveAs(ИмяФайла);
	Возврат ИмяФайла;	
	
КонецФункции




ЭтоEMS = (ТочкаНазначения = СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0021"));
