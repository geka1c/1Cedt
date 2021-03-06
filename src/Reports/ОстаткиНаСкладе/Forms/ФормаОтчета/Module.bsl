
&НаКлиенте
Процедура Сформировать(Команда)
	// Вставить содержимое обработчика.


//	ПечатьПриход(ТабДок, Дата);

	Печать(ТабДок, Дата,Организатор,МестаХранения,Участник,Покупка,Потерян,Партия);
	
КонецПроцедуры

// <Описание процедуры>
//
// Параметры
//  <Параметр1>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//  <Параметр2>  - <Тип.Вид> - <описание параметра>
//                 <продолжение описания параметра>
//
&НаСервереБезКонтекста
Процедура Печать(ТабДок, Дата,Организатор,МестаХранения,Участник,Покупка,Потерян,Партия)
	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
    ДатаЕ=КонецДня(Дата);
	Макет = Отчеты.ОстаткиНаСкладе.ПолучитьМакет("Макет1");
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОстаткиТоваровОстатки.Габарит,
		|	ПРЕДСТАВЛЕНИЕ(ОстаткиТоваровОстатки.Габарит),
		|	ОстаткиТоваровОстатки.Участник КАК Участник,
		|	ПРЕДСТАВЛЕНИЕ(ОстаткиТоваровОстатки.Участник),
		|	ОстаткиТоваровОстатки.МестоХранения КАК МестоХранения,
		|	ПРЕДСТАВЛЕНИЕ(ОстаткиТоваровОстатки.МестоХранения),
		|	ОстаткиТоваровОстатки.Покупка КАК Покупка,
		|	ОстаткиТоваровОстатки.Партия,
		|	ПРЕДСТАВЛЕНИЕ(ОстаткиТоваровОстатки.Партия),
		|	ОстаткиТоваровОстатки.Оплачен,
		|	ОстаткиТоваровОстатки.Потерян КАК Потерян,
		|	ОстаткиТоваровОстатки.КоличествоОстаток,
		|	ОстаткиТоваровОстатки.Партия.Организатор Как Организатор
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров.Остатки(&ДатаЕ) КАК ОстаткиТоваровОстатки
		|ГДЕ
		|	(ОстаткиТоваровОстатки.МестоХранения в (&МестаХранения) или &МестаХранения is null)
		|	И (ОстаткиТоваровОстатки.Партия.Организатор = &Организатор или &Организатор is null)
		|	И (ОстаткиТоваровОстатки.Участник = &Участник или &Участник is null)
		|	И (ОстаткиТоваровОстатки.Покупка = &Покупка или &Покупка is null)
		|	И (ОстаткиТоваровОстатки.Потерян = &Потерян или &Потерян is null)
		|	И (ОстаткиТоваровОстатки.Партия = &Партия или &Партия is null)
		|
		|УПОРЯДОЧИТЬ ПО
		|	Потерян,
		|	МестоХранения,
		|	Участник,
		|	Покупка";
    Запрос.УстановитьПараметр("ДатаЕ", ДатаЕ);
	Если МестаХранения.Количество()=0 Тогда
	  Запрос.УстановитьПараметр("МестаХранения", null);
  	Иначе
		Запрос.УстановитьПараметр("МестаХранения", МестаХранения);  
	КонецЕсли;
	//Запрос.УстановитьПараметр("МестоХранения", ?(МестоХранения= Справочники.МестаХранения.ПустаяСсылка(),null,МестоХранения));
	Запрос.УстановитьПараметр("Организатор",?(Организатор= Справочники.Организаторы.ПустаяСсылка(),null,Организатор) );
	Запрос.УстановитьПараметр("Партия", ?(Партия= Документы.Приходная.ПустаяСсылка(),null,Партия));
	Запрос.УстановитьПараметр("Покупка", ?(Покупка="",null,Покупка));
	Запрос.УстановитьПараметр("Потерян", Потерян);
	Запрос.УстановитьПараметр("Участник", ?(Участник= Справочники.Участники.ПустаяСсылка(),null,Участник));

	Результат = Запрос.Выполнить();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

	ТабДок.Очистить();
	ТабДок.Вывести(ОбластьЗаголовок);
	ТабДок.Вывести(ОбластьШапкаТаблицы);
	ТабДок.НачатьАвтогруппировкуСтрок();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
		ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетальныеЗаписи.Уровень());
	КонецЦикла;

	ТабДок.ЗакончитьАвтогруппировкуСтрок();
	ТабДок.Вывести(ОбластьПодвалТаблицы);
	ТабДок.Вывести(ОбластьПодвал);

	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	
	
	
КонецПроцедуры // Печать()

&НаКлиенте
Процедура Добавить(Команда)
	Если Строка(МестоХранения)= "" тогда
		#Если не ВебКлиент Тогда
		Сигнал();
		#КонецЕсли
		Сообщить("Зачем добавлять пустую строку?");
		Возврат;
	конецЕсли;	
	Если ПроверкаСписка(МестоХранения) Тогда
		#Если не ВебКлиент Тогда
		Сигнал();
		#КонецЕсли
		Сообщить("Этот элемент уже присутствует в списке!!!");
		Возврат;
	
	КонецЕсли;
	МестаХранения.Добавить(МестоХранения);
	// Вставить содержимое обработчика.
КонецПроцедуры


&НаКлиенте
Функция ПроверкаСписка(МестоХранения)
    Для н=0 По МестаХранения.Количество()-1 Цикл
		Если МестаХранения.Получить(н).Значение=МестоХранения Тогда
			Возврат Истина
		КонецЕсли
	КонецЦикла;
	Возврат Ложь

КонецФункции // ПроверкаСписка()


&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Дата=КонецДня(ТекущаяДата());
	//Вставить содержимое обработчика
КонецПроцедуры



//&НаСервереБезКонтекста
//Процедура ПечатьПриход(ТабДок, Дата)
//	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
//	// Данный фрагмент построен конструктором.
//	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!
//	ДатаБ=НачалоДня(Дата);
//	ДатаЕ=КонецДня(Дата);

//	Макет = Отчеты.ОтчетЗаДень.ПолучитьМакет("Макет1");
//	Запрос = Новый Запрос;
//	Запрос.Текст = 
//		"ВЫБРАТЬ
//		|	ПриходОбороты.Габарит КАК Габарит,
//		|	ПриходОбороты.Организатор,
//		|	ПриходОбороты.Покупка,
//		|	ПриходОбороты.ПокупкаСпр,
//		|	СУММА(ПриходОбороты.КоличествоОборот) КАК КоличествоОборот
//		|ИЗ
//		|	РегистрНакопления.Приход.Обороты(&ДатаБ, &ДатаЕ, , ) КАК ПриходОбороты
//		|
//		|СГРУППИРОВАТЬ ПО
//		|	ПриходОбороты.Габарит,
//		|	ПриходОбороты.Организатор,
//		|	ПриходОбороты.Покупка,
//		|	ПриходОбороты.ПокупкаСпр
//		|ИТОГИ
//		|	СУММА(КоличествоОборот)
//		|ПО
//		|	ОБЩИЕ,
//		|	Габарит";

//	Запрос.УстановитьПараметр("ДатаБ", ДатаБ);
//	Запрос.УстановитьПараметр("ДатаЕ", ДатаЕ);

//	Результат = Запрос.Выполнить();

//	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
//	ОбластьПодвал = Макет.ПолучитьОбласть("Подвал");
//	ОбластьШапкаТаблицы = Макет.ПолучитьОбласть("ШапкаТаблицы");
//	ОбластьПодвалТаблицы = Макет.ПолучитьОбласть("ПодвалТаблицы");
//	ОбластьОбщийИтог = Макет.ПолучитьОбласть("ОбщиеИтоги");
//	ОбластьГабарит = Макет.ПолучитьОбласть("Габарит");
//	ОбластьДетальныхЗаписей = Макет.ПолучитьОбласть("Детали");

//	ТабДок.Очистить();
//	ОбластьЗаголовок.Параметры.Дата=Дата;
//	ТабДок.Вывести(ОбластьЗаголовок);
//	ТабДок.Вывести(ОбластьШапкаТаблицы);
//   	ТабДок.НачатьАвтогруппировкуСтрок();

//	
//	ВыборкаОбщийИтог = Результат.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

//	ВыборкаОбщийИтог.Следующий();		// Общий итог
//	ОбластьОбщийИтог.Параметры.Заполнить(ВыборкаОбщийИтог);
//	ТабДок.Вывести(ОбластьОбщийИтог, ВыборкаОбщийИтог.Уровень());

//	ВыборкаГабарит = ВыборкаОбщийИтог.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);

//	Пока ВыборкаГабарит.Следующий() Цикл
//		ОбластьГабарит.Параметры.Заполнить(ВыборкаГабарит);
//		ТабДок.Вывести(ОбластьГабарит, ВыборкаГабарит.Уровень());

//		ВыборкаДетальныеЗаписи = ВыборкаГабарит.Выбрать();

//		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
//			ОбластьДетальныхЗаписей.Параметры.Заполнить(ВыборкаДетальныеЗаписи);
//			ТабДок.Вывести(ОбластьДетальныхЗаписей, ВыборкаДетальныеЗаписи.Уровень(),,ложь);
//		КонецЦикла;
//	КонецЦикла;
//   	ТабДок.ЗакончитьАвтогруппировкуСтрок();

//	ТабДок.Вывести(ОбластьПодвалТаблицы);
//	ТабДок.Вывести(ОбластьПодвал);

//	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА



//КонецПроцедуры


