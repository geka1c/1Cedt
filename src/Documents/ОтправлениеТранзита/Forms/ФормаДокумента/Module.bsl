
#Область ОбменССайтом

&НаКлиенте
Процедура ПолучитьАдресДоставки(Команда)
	ПолучитьАдресДоставкиНаСервере();
КонецПроцедуры

&НаСервере
Процедура ПолучитьАдресДоставкиНаСервере()
	док	= ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.ОтправлениеТранзита"));
	док.ПолучитьАдресДоставки_Api();
	ЗначениеВДанныеФормы(док, Объект);
КонецПроцедуры



&НаСервере
Процедура ОбновитьГруппуССайтаНаСервере()
	док	= ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.ОтправлениеТранзита"));
	док.ОбновитьИЗаполнитьОстатками();
	ЗначениеВДанныеФормы(док, Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьГруппуССайта(Команда)
	ОбновитьГруппуССайтаНаСервере();
КонецПроцедуры


&НаКлиенте
Процедура ПолучитьИсториюЗаказа(Команда)
	ПолучитьИсториюЗаказаНаСервере();
КонецПроцедуры

Процедура ПолучитьИсториюЗаказаНаСервере()
	ДокументРезультат.Очистить();
	тзИстория = СтоСПОбмен_ГруппыДоставки.ПолучитьИсториюДоставки(Объект.Коробка);	
	
	
	
	СхемаКомпоновкиДанных = Документы.ОтправлениеТранзита.ПолучитьМакет("СКД_ИсторияГруппыДоставки");
	ДанныеРасшифровки = новый ДанныеРасшифровкиКомпоновкиДанных;
	
	
	КомпоновщикНастроек=Новый КомпоновщикНастроекКомпоновкиДанных;
	КомпоновщикНастроек.Инициализировать(Новый ИсточникДоступныхНастроекКомпоновкиДанных(СхемаКомпоновкиДанных));
	КомпоновщикНастроек.ЗагрузитьНастройки(СхемаКомпоновкиДанных.ВариантыНастроек["Основной"].Настройки);
	
	
	КомпоновщикМакета = Новый КомпоновщикМакетаКомпоновкиДанных;
	МакетКомпоновки = КомпоновщикМакета.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.Настройки, ДанныеРасшифровки);

	
	ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновки.Инициализировать(МакетКомпоновки,новый Структура("История",тзИстория) , ДанныеРасшифровки, Истина);

	ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
	//
	//УниверсальныеМеханизмыПартийИСебестоимости.АктуализироватьПартииДляОтчетов(ДокументРезультат, КомпоновщикНастроек);
	//
	АдресХранилищаСКД = ПоместитьВоВременноеХранилище(СхемаКомпоновкиДанных, УникальныйИдентификатор);
	АдресРасшифровки = ПоместитьВоВременноеХранилище(ДанныеРасшифровки, УникальныйИдентификатор);
	
	ПроцессорВывода.Вывести(ПроцессорКомпоновки);

КонецПроцедуры
#КонецОбласти





#Область СоздатьЗаказТК

&НаКлиенте
Процедура ПолучитьНомерОтправления(Команда)    
	если не ПроверитьЗаполнение() Тогда Возврат; КонецЕсли ;	
	
	Записать();
	ЗаполнитьОбъявленнуюСтоимость();
	Если Объект.Тип="postMail" или Объект.Тип="ems" Тогда
		ОткрытьФорму("Документ.ОтправлениеТранзита.Форма.НормализацияФИО",новый Структура("ФИО",Объект.ФИО),ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
//		фрм=ПолучитьФорму("Документ.ОтправлениеТранзита.Форма.НормализацияФИО",новый Структура("ФИО",Объект.ФИО),ЭтаФорма,,ВариантОткрытияОкна.ОтдельноеОкно);
//		фрм.Открыть();
		Возврат;
	КонецЕсли;

	СформмироватьЗаказНаСервере();		
	Попытка
		Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры

Процедура СформмироватьЗаказНаСервере(ПараметрыФИО=Неопределено)
	Если ЗначениеЗаполнено(Объект.Коробка) и не ЗначениеЗаполнено(Объект.Коробка.МетодОплаты) и Объект.Коробка.ВидСтикера=Перечисления.ВидыСтикеров.ГруппаДоставки тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбран метод оплаты! ");
		Возврат;	
	КонецЕсли;
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ОтправлениеТранзита"));
	Если   (Объект.Тип="postMail" или Объект.Тип="ems") и ПараметрыФИО<>Неопределено Тогда
		об.СформироватьЗаказПочтаРоссии(ПараметрыФИО);   //Перенесено в обработкуОповещения
	ИначеЕсли   Объект.Тип="dpd" или Объект.Тип="boxberry" или Объект.Тип="boxberryCourier" Тогда
		Интеграция_ТранспортныеКомпании_Общий.СформироватьЗаказ(об);
	Иначе	
		об.СформироватьЗаказСДЭК();
	КонецЕсли;
	
	ЗначениеВДанныеФормы(об,Объект);
	УстановитьДоступность();
КонецПроцедуры	

&НаКлиенте
Процедура ПоказатьРасчетСтоимости(Команда)
	Элементы.РасчетСтоимости.Видимость = не Элементы.РасчетСтоимости.Видимость;
КонецПроцедуры


&НаКлиенте
Процедура ОписаниеЗаказаПР(Команда)
	ОписаниеЗаказаПРНаСервере();
КонецПроцедуры

Процедура ОписаниеЗаказаПРНаСервере()
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ОтправлениеТранзита"));
	
	об.ОписаниеЗаказаПочтаРоссии(Объект.НомерЗаказа);
	ЗначениеВДанныеФормы(об,Объект);
	УстановитьДоступность();
	
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьНомер(Команда)
	Объект.НомерЗаказа="";
	Объект.ВнутреннийНомерЗаказаТК="";
	УстановитьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура УдалитьЗаказВТК(Команда)
	Записать();
	УдалитьЗаказВТКНаСервере();
	Попытка
		записан=Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
		Если Записан Тогда
			//Закрыть();
		Иначе
			Сообщить("Документ не записан");
		КонецЕсли
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;

КонецПроцедуры


Процедура УдалитьЗаказВТКНаСервере()
	если не ПроверитьЗаполнение() Тогда
		Возврат;
	КонецЕсли ;	
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ОтправлениеТранзита"));
	Если Объект.Тип="sdecCourier" или Объект.Тип="sdec" Тогда
		об.УдалитьЗаказСДЭК();
	ИначеЕсли Объект.Тип="boxberry" или Объект.Тип="boxberryCourier" Тогда
		об.УдалитьЗаказBoxBerry();
	ИначеЕсли Объект.Тип="dpd" Тогда
		Интеграция_ТранспортныеКомпании_Общий.УдалитьЗаказ(об);
	КонецЕсли;	
	ЗначениеВДанныеФормы(об,Объект);
	УстановитьДоступность();
КонецПроцедуры

#КонецОбласти

#Область ПолучитьКвитанциюТК

&НаКлиенте
Процедура ПолучитьКвитанцию(Команда)
	
	#Если не ВебКлиент Тогда
	Записать();
	файл= ПолучитьКвитанциюнаСервере();	
	Если файл <> Неопределено Тогда
		Если ТипЗнч(Файл)=Тип("Структура") Тогда
			Если Объект.Тип="dpd" и файл.ТипФайла = "Хранилище" Тогда
				ИмяФ=ПолучитьИмяВременногоФайла("pdf");
				ПолучитьФайл(файл.Файл,ИмяФ);
				ЗапуститьПриложение(ИмяФ)
			КонецЕсли;
			
			Если Объект.Тип="postMail" или Объект.Тип="ems" Тогда
				ИмяФ=ПолучитьИмяВременногоФайла("pdf");
				Если файл.Успешно Тогда
					ПолучитьФайл(файл.Адрес,ИмяФ);
				Конецесли;
				
			Иначе
				Если Файл.Свойство("Квитанция") Тогда
					ЗапуститьПриложение(Файл.Квитанция); 
				КонецЕсли;
				Если Файл.Свойство("Акт") Тогда
					ЗапуститьПриложение(Файл.Акт); 
				КонецЕсли;
				
			КонецЕсли;
		Иначе	
			Адрес=файл;
			Описание=Новый ОписаниеПередаваемогоФайла(ПолучитьИмяВременногоФайла("pdf"),Адрес);
			МассивОписаний=Новый Массив;
			МассивОписаний.Добавить(Описание);
//			НачатьПолучениеФайлов(МассивОписаний,,,Ложь );
			ПолучитьФайлы(МассивОписаний,,,Ложь);			
			ЗапуститьПриложение(МассивОписаний[0].Имя);
		КонецЕсли;
	Иначе
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось получить квитанцию!");
	КонецЕсли;
	#КонецЕсли	
КонецПроцедуры

Функция ПолучитьКвитанциюнаСервере()
	если не ПроверитьЗаполнение() Тогда
		отказ=истина;
		Возврат неопределено
	КонецЕсли ;	
	Если ЗначениеЗаполнено(Объект.Коробка) и не ЗначениеЗаполнено(Объект.Коробка.МетодОплаты)  и Объект.Коробка.ВидСтикера=Перечисления.ВидыСтикеров.ГруппаДоставки тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не выбран метод оплаты! ");
		Возврат неопределено;	
	КонецЕсли;
	
	об=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ОтправлениеТранзита"));
	Если   Объект.Тип="dpd" Тогда
		Протокол = Интеграция_ТранспортныеКомпании_Общий.ПолучитьНаклейки(об);
		ЗначениеВДанныеФормы(об,Объект);
		УстановитьДоступность();
	Возврат Протокол;

	КонецЕсли;
	
	Если   Объект.Тип="postMail" или Объект.Тип="ems" Тогда
		
		Возврат Интеграция_ПочтаРоссии.ПолучитьПечатныеФормыДоПартии(Объект.ВнутреннийНомерЗаказаТК,ЭтоEMS);
	ИначеЕсли   Объект.Тип="boxberry" или Объект.Тип="boxberryCourier" Тогда	
		Файл=об.СформироватьКвитанциюBoxBerry();
	Иначе	
		Файл=об.СформироватьКвитанциюСДЭК();
	КонецЕсли;

//	Файл=об.СформироватьКвитанциюСДЭК();
	ЗначениеВДанныеФормы(об,Объект);
	УстановитьДоступность();
	Возврат Файл;
КонецФункции

#КонецОбласти




#Область РасчетСтоимостиДоставки

&НаКлиенте
Процедура ОбновитьСтоимостьИтого(Команда)
	Если Объект.ТарифТК = 0 Тогда 
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Стоимость не расчитана. Сначала расчитайте тариф ТК.");
		Возврат; 
	КонецЕсли;
	ПересчитатьСтоимостиОтправки();
КонецПроцедуры

Процедура ПересчитатьСтоимостиОтправки()
	объектОтправление = ДанныеФормыВЗначение(Объект, Тип("ДокументОбъект.ОтправлениеТранзита"));
	объектОтправление.ПересчитатьСтоимостиОтправки();
	ЗначениеВДанныеФормы(объектОтправление,Объект );
КонецПроцедуры 


&НаКлиенте
Процедура ПолучитьСтоимостьПоТарифу(Команда)
	Если не ПроверитьЗаполнение() тогда
		Возврат;
	Конецесли;	
	ЗаполнитьОбъявленнуюСтоимость();
	
	ПолучитьСтоимостьТранспортнойКомпании();		
	ПересчитатьСтоимостиОтправки();	
	СП_РаботаСДокументами_Клиент.ЗаписатьДокумент(ЭтотОбъект);

КонецПроцедуры


Процедура ПолучитьСтоимостьТранспортнойКомпании()
	об	= ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.ОтправлениеТранзита"));
	Интеграция_ТранспортныеКомпании_Общий.РасчитатьСтоимостьОтправления(об);
	ЗначениеВДанныеФормы(об,Объект);
	УстановитьДоступность();
КонецПроцедуры	



#КонецОбласти

#Область ПолучениеАдреса



////////////////////////////////

Процедура ЗаполнитьАдрес()
	Если Объект.Заказы.Количество()=0 тогда Возврат; КонецЕсли;
	тзДляАдреса=	Объект.Заказы.Выгрузить(,"Покупка");
	
	тзДляАдреса.Колонки.Добавить("Участник",новый ОписаниеТипов("СправочникСсылка.Участники"));
	тзДляАдреса.ЗаполнитьЗначения(Объект.Участник,"Участник");
	тзАдреса=СПЗаказыТК.ПолучитьАдресаНаТЗЗаказов(тзДляАдреса);
	Если тзАдреса.Количество()=0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось получить адрес с сайта!");	
	Иначе	
		ЗаполнитьЗначенияСвойств(Объект,тзАдреса[0]);
	КонецЕсли;
КонецПроцедуры	

Функция ПолучитьТКПоТипуАдреса(тип)
	Если 	  тип="sdecCourier" или тип="sdec" Тогда
		Возврат СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0083");
	ИначеЕсли тип="postMail"  Тогда
		Возврат СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0020");	
	ИначеЕсли тип="ems" Тогда
		Возврат СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0021");
	ИначеЕсли тип="internationalPost" Тогда
		Возврат СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0091");	
	Иначе
		Возврат Справочники.ТочкиРаздачи.ТочкаНеОпределена;
	КонецЕсли
КонецФункции

&НаКлиенте
Процедура ВыбратьАдрес(Команда)
	ФРМ=ПолучитьФорму("Обработка.ФормированиеЗаказовТК.Форма.ФормаВыбораАдреса",новый Структура("ВыбранныеСтроки,Источник,Участник",Объект.Заказы,"ОтправлениеГД",Объект.Участник),ЭтаФорма);
	Если ФРМ.Адреса.Количество()=0 Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось получить адрес с сайта!");
	ИначеЕсли ФРМ.Адреса.Количество()=1 Тогда
		ЗаполнитьЗначенияСвойств(Объект,ФРМ.Адреса[0]);
	Иначе
		ФРМ.открытьМодально();
	Конецесли;
	УстановитьВидимость();
	УстановитьДоступность();
КонецПроцедуры

#КонецОбласти


&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Объект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
	
	
	//ОбновитьГруппуССайтаНаСервере();
	Документы.ОтправлениеТранзита.ЗаполнитьОстатками(Объект, Параметры);
	Если Объект.Адрес="" Тогда
		ПолучитьАдресДоставкиНаСервере();
	КонецЕсли;

	//
	Если Объект.Ссылка.Пустая() и ЗначениеЗаполнено(Объект.ТочкаНазначения) Тогда
		ЗаполнитьЗначенияСвойств(Объект,Объект.ТочкаНазначения,"МестоХранения, Габарит");	
		ЗаполнитьЗначенияСвойств(Объект,Объект.ТочкаНазначения,"ТарифПВ, ТарифПВнп,Процент,ПроцентОС");	
		Объект.ТочкаОтправитель=Константы.СвояТочка.Получить();
	КонецЕсли;
	
	//Для почты россии разные параметры Для разных Методов оплаты
	Если ЗначениеЗаполнено(Объект.Коробка) и Объект.Коробка.МетодОплаты=Перечисления.МетодыОплаты.prepay Тогда
		Объект.КатегорияРПО		= Перечисления.КатегорияРПО.WITH_DECLARED_VALUE;
	ИначеЕсли  Объект.Коробка.МетодОплаты=Перечисления.МетодыОплаты.cod Тогда
		Объект.КатегорияРПО		= Перечисления.КатегорияРПО.WITH_DECLARED_VALUE_AND_CASH_ON_DELIVERY;
	КонецЕсли;
	
	Если Объект.ТочкаНазначения.Код = "0048" Тогда  //dpd
		Объект.УслугаDPD = Справочники.УслугиDPD.PCL;
	КонецЕсли;

//	мЭтоКурьер  = (Объект.ТочкаНазначения = СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0100"));
	ЭтоEMS 		= (Объект.ТочкаНазначения = СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0021"));
	
КонецПроцедуры

&НаКлиенте
Процедура ГруппаСтраницыПриСменеСтраницы(Элемент, ТекущаяСтраница)
	ГруппаСтраницыПриСменеСтраницыНаСервере();
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
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("ПровелиОтправлениеТранзита",истина);
	Если ЗначениеЗаполнено(Объект.Коробка) Тогда
		ОповеститьОбИзменении(Объект.Коробка);
	КонецЕсли;	
	УстановитьДоступность();
КонецПроцедуры



&НаКлиенте
Процедура ПриОткрытии(Отказ)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
//	Если Объект.Адрес="" Тогда
//		ВыбратьАдрес(Истина);
//	КонецЕсли;
	УстановитьВидимость();
	УстановитьДоступность();
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Если ИсточникВыбора.ИмяФормы = "Документ.ОтправлениеТранзита.Форма.НормализацияФИО" Тогда
		СформмироватьЗаказНаСервере(ВыбранноеЗначение);		
		Попытка
			записан=Записать(Новый Структура("РежимЗаписи", РежимЗаписиДокумента.Проведение));
			Если Записан Тогда
				//Закрыть();
			Иначе
				Сообщить("Документ не записан");
			КонецЕсли
		Исключение
			Сообщить(ОписаниеОшибки());
		КонецПопытки;
	ИначеЕсли ИсточникВыбора.ИмяФормы ="Обработка.ФормированиеЗаказовТК.Форма.ФормаВыбораАдреса" Тогда
		ЗаполнитьЗначенияСвойств(Объект,ВыбранноеЗначение);
	Иначе	
		УстановитьКодПВЗнаСервере(ВыбранноеЗначение);
	КонецЕсли;	
	УстановитьВидимость();
	УстановитьДоступность();
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	Если Объект.Коробка.ВидСтикера=Перечисления.ВидыСтикеров.ГруппаДоставки Тогда
		Если (Объект.СтоимостьДоставки=0 или Объект.СтоимостьДоставкиПредоплата=0)  Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("""Стоимость Доставки"" и ""Стоимость Доставки предоплата"" должны быть указанны! ",,,,Отказ);
		КонецЕсли;	
	КонецЕсли;		

КонецПроцедуры




#Область СобытияФормы

&НаКлиенте
Процедура НомерЗаказаПриИзменении(Элемент)
	УстановитьДоступность();
КонецПроцедуры


Процедура УстановитьКодПВЗнаСервере(ВыбранноеЗначение)
	Если Объект.тип="boxberry" Тогда
		Объект.КодПВЗ=ВыбранноеЗначение.Код;
	Иначе	
		Объект.КодПВЗ=ВыбранноеЗначение.Code;
		Если ВыбранноеЗначение.Type="PVZ" Тогда
			Объект.Тип="sdec";
		иначе
			Объект.Тип="postamat"
		КонецЕсли;			
	КонецЕсли;	
КонецПроцедуры


#КонецОбласти

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
	
    УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Объект);
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать



Процедура ЗаполнитьОбъявленнуюСтоимость()
	Для каждого стр из Объект.Заказы Цикл
		масСтрок=Объект.Коробка.Состав.НайтиСтроки(новый Структура("Покупка, Участник",стр.Покупка,Объект.Участник));
		Если масСтрок.Количество()> 0 Тогда
			стр.ОбъявленнаяСтоимость=масСтрок[0].Цена;
		КонецЕсли;
	КонецЦикла ;
	Если Объект.ОбъявленнаяСтоимость=0 Тогда 
		Объект.ОбъявленнаяСтоимость=Объект.Заказы.Итог("ОбъявленнаяСтоимость");
	КонецЕсли;	
КонецПроцедуры	


Процедура УстановитьДоступность()

	Элементы.ГруппаЗаказ.ТолькоПросмотр				= не (объект.НомерЗаказа="");	
	Элементы.ГруппаНомерОтправления.ТолькоПросмотр	= не (объект.НомерЗаказа="");
	Элементы.ПолучитьНомерОтправления.Доступность   =  (объект.НомерЗаказа="");
	УстановитьВидимость()
КонецПроцедуры	


Процедура УстановитьВидимость()
	ЭтоПочта	= (Объект.Тип="postMail" или Объект.Тип="ems");
	ЭтоСДЭК 	= (Объект.Тип="sdecCourier" или Объект.Тип="sdec");
	ЭтоБоксбери = (Объект.Тип="boxberry" или Объект.Тип="boxberryCourier");
	ЭтоDPD 		= (Объект.Тип="dpd");
	
	Элементы.ГруппаПочтаРоссии.Видимость	= Ложь;
	Элементы.ГруппаБоксберри.Видимость		= Ложь;
	Элементы.ГруппаСДЭК.Видимость			= Ложь;
	Элементы.ГруппаDPD.Видимость			= Ложь;
	
	Если ЭтоБоксбери Тогда Элементы.ГруппаПараметрыТК.ТекущаяСтраница = Элементы.ГруппаБоксберри КонецЕсли;
	
	Элементы.ГруппаПочтаРоссии.Видимость	= ЭтоПочта;
	Элементы.ГруппаБоксберри.Видимость		= ЭтоБоксбери;
	Элементы.ГруппаСДЭК.Видимость			= ЭтоСДЭК;
	Элементы.ГруппаDPD.Видимость			= ЭтоDPD;
	
	//Элементы.ГруппаРасчетКалькулятора.ТекущаяСтраница=Элементы.РКСтрокой;

	
//	Элементы.ГруппаГабаритыГруза.Видимость			= не мЭтоКурьер;
//	Элементы.ПолучитьНомерОтправления.Видимость		= не мЭтоКурьер;
//	Элементы.ПолучитьКвитанцию.Видимость			= не мЭтоКурьер;
//	Элементы.ОчиститьНомер.Видимость				= не мЭтоКурьер;
//	Элементы.УдалитьЗаказВТК.Видимость				= не мЭтоКурьер;
//	Элементы.ТарифТК.Видимость						= не мЭтоКурьер;
//	Элементы.Процент.Видимость						= не мЭтоКурьер;
//	Элементы.ГородОтправитель.Видимость				= не мЭтоКурьер;
//	Элементы.ПунктПриема.Видимость					= не мЭтоКурьер;
//	Элементы.ПолучитьСтоимостьПоТарифу.Видимость	= не мЭтоКурьер;    
//	Элементы.ГруппаРасчетКалькулятора.Видимость		= не мЭтоКурьер;
//	Элементы.ТарифПВ.Видимость						= не мЭтоКурьер;
//	Элементы.СтоимостьДоставкиПредоплата.Видимость	= не мЭтоКурьер;
	
	Если не ЗначениеЗаполнено(Объект.Тариф) Тогда
		Если Объект.Тип="sdec" Тогда
			Объект.Тариф=Справочники.ТарифыТК.НайтиПоКоду("136");
		ИначеЕсли Объект.Тип="postamat" Тогда
			Объект.Тариф=Справочники.ТарифыТК.НайтиПоКоду("302");
		ИначеЕсли Объект.Тип="sdecCourier" Тогда
			Объект.Тариф=Справочники.ТарифыТК.НайтиПоКоду("137");
		КонецЕсли	
	КонецЕсли;	
	
	Если Не ЗначениеЗаполнено(Объект.ВидРПО) Тогда
		Если 		Объект.ТочкаНазначения = СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0020") Тогда
			Объект.ВидРПО=Перечисления.ВидРПО.POSTAL_PARCEL;
		ИначеЕсли 	Объект.ТочкаНазначения = СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0021") Тогда	
			Объект.ВидРПО=Перечисления.ВидРПО.EMS;
	    КонецЕсли;
	КонецЕсли;
	
	
	Если не ЗначениеЗаполнено(Объект.ГородОтправитель) Тогда
		Если Объект.Тип="sdecCourier" или Объект.Тип="sdec" Тогда
			Объект.ГородОтправитель=Константы.ГородОтправительСДЭКпоУмолчанию.Получить();
		КонецЕсли;
		Если Объект.Тип="boxberry" или Объект.Тип="boxberryCourier" Тогда
			Объект.ГородОтправитель=Константы.ГородОтправительBoxBerryПоУмолчанию.Получить();
		КонецЕсли;
	КонецЕсли;	
	
	Если не ЗначениеЗаполнено(Объект.ПунктПриема) Тогда
		Если Объект.Тип="boxberry" или Объект.Тип="boxberryCourier" Тогда
			Объект.ПунктПриема=Константы.ПунктПриемаBoxBerryПоУмолчанию.Получить();
		КонецЕсли;
	КонецЕсли;	
	Если не ЗначениеЗаполнено(Объект.ИндексОтправителя) и (Объект.Тип="postMail" или Объект.Тип="ems")   Тогда
		ТК							= ПолучитьТКПоТипуАдреса(Объект.Тип);
		Объект.ИндексОтправителя	= Константы.ИндексОтправителяПРУмолчание.Получить();
	КонецЕсли;
	
КонецПроцедуры	

&НаКлиенте
Процедура СменитьПунктВыдачи(Команда)
	Если Объект.Тип="dpd" Тогда
		ОткрытьФорму("Справочник.ТранспортныеКомпании.Форма.ВыборПунктаВыдачиDPD",новый структура("ГородНазначения",Объект.Город),ЭтаФорма,,,,новый ОписаниеОповещения("Обработчик_ВыборПунктаСдачиDPD",ЭтотОбъект),РежимОткрытияОкнаФормы.БлокироватьВесьИнтерфейс);		
		возврат;
	КонецЕсли;	
	Если Объект.Тип="boxberry" Тогда
		фрм=ПолучитьФорму("Справочник.ПунктыВыдачиBoxBerry.ФормаВыбора",новый структура("КодГородаНазначения",Объект.cityCode),ЭтаФорма);
	Иначе	
		фрм=ПолучитьФорму("Документ.ОтправлениеТранзита.Форма.ВыборПунктаВыдачиСДЭК",новый структура("КодГородаНазначения",Объект.cityCode),ЭтаФорма);
	КонецЕсли;
	фрм.открыть();
КонецПроцедуры


Процедура Обработчик_ВыборПунктаСдачиDPD(РезультатЗакрытия, параметр)
	Если ЗначениеЗаполнено(РезультатЗакрытия) Тогда
		Объект.КодПВЗ	= РезультатЗакрытия.КодПВ;
		Объект.cityCode	= РезультатЗакрытия.КодГорода;
	КонецЕсли;
КонецПроцедуры	


&НаКлиенте
Процедура ГородОтправительНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если Объект.Тип="boxberry" или Объект.Тип="boxberryCourier" Тогда
		ТипСтр = "СправочникСсылка.ГородаBoxBerry";
	Иначе	
		ТипСтр = "СправочникСсылка.ГородаСДЭК";
	КонецЕсли;
	
    Элемент.ОграничениеТипа = Новый ОписаниеТипов(ТипСтр);
    Значение = Объект.ГородОтправитель;
    Объект.ГородОтправитель = Элемент.ОграничениеТипа.ПривестиЗначение(Значение);
    Элемент.ВыбиратьТип = Ложь;
	
КонецПроцедуры

&НаКлиенте
Процедура ТарифПВПриИзменении(Элемент)
	ПересчитатьСтоимостиОтправки();
КонецПроцедуры




&НаКлиенте
Процедура ДокументРезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка, ДополнительныеПараметры)
	СтандартнаяОбработка = Ложь;
 
	ИсточникДоступныхНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресХранилищаСКД);
 
	ОбработкаРасшифровки = Новый ОбработкаРасшифровкиКомпоновкиДанных(АдресРасшифровки, ИсточникДоступныхНастроек);
 
	ДоступныеДействия = Новый Массив();
	ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
	
	Оповещение = Новый ОписаниеОповещения("РезультатОбработкаРасшифровки_Продолжение", ЭтаФорма, Расшифровка);
	ОбработкаРасшифровки.ПоказатьВыборДействия(Оповещение, Расшифровка, ДоступныеДействия, , Истина);
КонецПроцедуры


&НаКлиенте
Процедура РезультатОбработкаРасшифровки_Продолжение(ВыполненноеДействие, ПараметрВыполненногоДействия, ДополнительныеПараметры) Экспорт
    Если ПараметрВыполненногоДействия <> Неопределено Тогда
        
        Если ВыполненноеДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда
            ПоказатьЗначение(,ПараметрВыполненногоДействия);
        КонецЕсли;
        
    КонецЕсли;        
КонецПроцедуры


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
 
