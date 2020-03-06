Функция ПолучитьДанныеДляОбмена() Экспорт 

	ДанныеДляОбмена=Новый Структура ;
	ДанныеДляОбмена.Вставить("ПоследняяЗагрузкаУчастников",	Справочники.ПараметрыОбмена.Участники.ДатаЗагрузки);
	ДанныеДляОбмена.Вставить("ПоследняяЗагрузкаПокупок",	Справочники.ПараметрыОбмена.Покупки.ДатаЗагрузки);
	ДанныеДляОбмена.Вставить("ПоследняяЗагрузкаКарты",		Справочники.ПараметрыОбмена.КартыУчастников.ДатаЗагрузки);
	ДанныеДляОбмена.Вставить("Сервер",						Константы.Сервер.Получить());
	ДанныеДляОбмена.Вставить("ВыгружатьПриходПриЗаписи",	Константы.ВыгружатьПриходПриЗаписи.Получить());
	ДанныеДляОбмена.Вставить("АнализОтветаТолькоОшибки",	Константы.АнализОтветаТолькоОшибки.Получить());
	ДанныеДляОбмена.Вставить("ВыгружатьТранзитПриЗаписи",	Константы.ВыгружатьТранзитПриЗаписи.Получить());
	ДанныеДляОбмена.Вставить("Токен",						Константы.Токен.Получить());
    ДанныеДляОбмена.Вставить("Порт",						Константы.Порт.Получить());
	ДанныеДляОбмена.Вставить("Выгрузка",					Ложь);
	ДанныеДляОбмена.Вставить("АдресСкрипта",				Константы.АдресОбменаССайтом.Получить());
	
	
	
    Возврат ДанныеДляОбмена;
КонецФункции // ПолучитьДанныеДляОбмена()



Функция ПолучитьПараметрыТранзита(Транзит) Экспорт 

	ДанныеДляОбмена=Новый Структура ;
	ДанныеДляОбмена.Вставить("ДатаТранзита",Транзит.Дата);
	ДанныеДляОбмена.Вставить("КодТочкиназначения",Транзит.ТочкаНазначения.Код);
	ДанныеДляОбмена.Вставить("КодТочкинаТранзита",Транзит.ТочкаТранзита.Код);
	
	
    Возврат ДанныеДляОбмена;
КонецФункции 

///////////// Выборки Для выгрузки

Функция ВыбратьКартыXDTO(Карта) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	КартыУчастников.Владелец.Код КАК uid,
		|	КартыУчастников.Код КАК id
		|ИЗ
		|	Справочник.КартыУчастников КАК КартыУчастников
		|ГДЕ
		|	"+?(Карта=Неопределено," КартыУчастников.Статус = &Статус "," КартыУчастников.Ссылка=&Карта ");

	Запрос.УстановитьПараметр("Статус", Перечисления.СтатусКартыУчастника.НеЗарегистрирована);
	Запрос.УстановитьПараметр("Карта", Карта);

	Результат = Запрос.Выполнить();

	тз = Результат.Выгрузить();
	
	ТЗ.Колонки.id.Имя  ="idint";
	ТЗ.Колонки.uid.Имя ="uidint";
	ТЗ.Колонки.Добавить("id", Новый ОписаниеТипов("Строка"));
	ТЗ.Колонки.Добавить("uid", Новый ОписаниеТипов("Строка"));
	Для каждого стр из тз Цикл
		стр.id		= Формат(стр.idint,"ЧГ=0");
		стр.uid	= Формат(стр.uidint,"ЧГ=0");
	КонецЦикла;	
	тз.Колонки.Удалить("idint");
	тз.Колонки.Удалить("uidint");
    Возврат тз;
КонецФункции 


Процедура ЗаписатьОтправленныеДокументы(тзДляДокОтправки,Отправлен)
	тзДляДокОтправки.Свернуть("Документ");

	Для каждого элем из тзДляДокОтправки цикл
	нз=РегистрыСведений.ОтправленныеДокументы.СоздатьМенеджерЗаписи();
	нз.Документ=элем.Документ;
	нз.Отправлен=Отправлен;
	нз.Записать();
	КонецЦикла;
КонецПроцедуры	


Процедура ПометитьОтправленныеДокументы() экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОтправленныеДокументы.Документ
		|ИЗ
		|	РегистрСведений.ОтправленныеДокументы КАК ОтправленныеДокументы
		|ГДЕ
		|	(НЕ ОтправленныеДокументы.Отправлен)";
	Результат = Запрос.Выполнить();
    ЗаписатьОтправленныеДокументы(Результат.Выгрузить(),Истина);
КонецПроцедуры	


Функция ВыбратьТранзит(Транзит) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Транзит.Точка.Код КАК ТочкаПолучательКод,
		|	Константы.СвояТочка.Код КАК ОтправительТочкаКод,
		|	Транзит.Регистратор.Номер,
		|	Транзит.Регистратор.Дата,
		|	Транзит.Участник.Код,
		|	Транзит.ПокупкаСсылка.Код КАК ПокупкаКод,
		|	СУММА(Транзит.Количество) КАК Количество
		|ИЗ
		|	РегистрНакопления.Транзит КАК Транзит,
		|	Константы КАК Константы
		|ГДЕ
		|	Транзит.Регистратор = &Регистратор
		|
		|СГРУППИРОВАТЬ ПО
		|	Транзит.Регистратор.Дата,
		|	Транзит.Регистратор.Номер,
		|	Константы.СвояТочка.Код,
		|	Транзит.Точка.Код,
		|	Транзит.Участник.Код,
		|	Транзит.ПокупкаСсылка.Код";

	Запрос.УстановитьПараметр("Регистратор", Транзит);

	Результат = Запрос.Выполнить();

	ТЗ = Результат.Выгрузить();
	Стр=ЗначениеВСтрокуВнутр(ТЗ);
	Возврат Стр;
КонецФункции	

Функция НайтиКонтрагентаПоНаименованию(Наименование) Экспорт
	КонтрагентСсылка=Справочники.Контрагенты.НайтиПоНаименованию(СокрЛП(Наименование));
	Если не ЗначениеЗаполнено(КонтрагентСсылка) Тогда
		эл=Справочники.Контрагенты.СоздатьЭлемент();
		эл.Наименование=СокрЛП(Наименование);
		эл.ЮридическоеФизическоеЛицо=Перечисления.ЮридическоеФизическоеЛицо.ЮридическоеЛицо;
		эл.Записать();
		КонтрагентСсылка=эл.Ссылка;
	КонецЕсли;	
	Возврат КонтрагентСсылка;
КонецФункции	




/////////////   Правим Справочники

Функция ДобавитьКартуИзСтруктуры(СЗКарта) Экспорт
	   КартаДобавлена=Истина;
	
		УчастникСсылка	= СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(СЗКарта.uid);
		Если УчастникСсылка = Неопределено Тогда возврат Ложь; КонецЕсли;
		
		Если СЗКарта.status="active" Тогда
			СтатусКарты=Перечисления.СтатусКартыУчастника.Зарегистрированна;
		ИначеЕсли СЗКарта.status="rejected"   Тогда
			СтатусКарты=Перечисления.СтатусКартыУчастника.Блокирована;
		Иначе
			Возврат ложь;	
		Конецесли;
		
		КартаСсылка=СП_РаботаСоСправочниками.ПолучитьКартуУчастникаПо_Коду(СЗКарта.id);
		Если не ЗначениеЗаполнено(КартаСсылка) Тогда
			Карта=Справочники.КартыУчастников.СоздатьЭлемент();
			Карта.Код			=Число(СЗКарта.id);
		Иначе
			Карта=КартаСсылка.ПолучитьОбъект();
		КонецЕсли;	
		Карта.Статус		=СтатусКарты;
		Карта.Владелец		=УчастникСсылка;
		Карта.ДатаЗагрузки=ТекущаяДата();
		Карта.ДатаМодификации= СЗКарта.modified;
		Попытка
			Карта.Записать();
		Исключение
			Сообщение = Новый СообщениеПользователю();
			Сообщение.Текст = ОписаниеОшибки();
			Сообщение.Сообщить();
			УчастникДобавлен=Ложь;
			
			КартаДобавлена=Ложь;
		КонецПопытки;
		
		Возврат КартаДобавлена
КонецФункции	
////////////




Функция ИзКолекцииВтз(коллекция) Экспорт
	Возврат коллекция.ВЫгрузить();
	
КонецФункции	

Процедура ДобавитьСтрокувТЗизСтруктуры(ТЗ,Структ)
	ТЗ=новый ТаблицаЗначений;
	стрТЗ=ТЗ.Добавить();
	Для каждого колонкаТЗ из ТЗ.Колонки Цикл
		стрТЗ[колонкаТЗ.Имя]=Структ[колонкаТЗ];
	КонецЦикла;
КонецПроцедуры

////////////




Процедура ДобавитьЭлементXML(ЗаписьXML,Название,Значение)
	ЗаписьXML.ЗаписатьНачалоЭлемента(Название);
	ЗаписьXML.ЗаписатьТекст(Строка(Значение));
	ЗаписьXML.ЗаписатьКонецЭлемента();
КонецПроцедуры // ДобавитьЭлементXML()

Процедура ОбработатьЗагруженныеКарты(сз,сзУчастн,сзКарты)  Экспорт
	тзИзФайла=новый ТаблицаЗначений;
	тзИзФайла.Колонки.Добавить("Код",новый ОписаниеТипов("Число"));
	
	Масс=новый Массив;
	Масс.Добавить(Тип("Строка"));
	КС=новый КвалификаторыСтроки(150);
	тзИзФайла.Колонки.Добавить("Статус",новый ОписаниеТипов(Масс,,КС));
	//КС=новый КвалификаторыСтроки(50);
	тзИзФайла.Колонки.Добавить("КодУч",новый ОписаниеТипов("Число"));
	//
	Для каждого элем из сз Цикл
		стрТЗ=тзИзФайла.Добавить();		
		стрТЗ.Код=элем.Значение.id;
		стрТЗ.Статус=элем.Значение.status;
		стрТЗ.КодУч=элем.Значение.uid;
	КонецЦикла;	

	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц=новый МенеджерВременныхТаблиц;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	тзФ.Код,
		|	ВЫБОР
		|		КОГДА тзФ.Статус = ""active""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусКартыУчастника.Зарегистрированна)
		|		КОГДА тзФ.Статус = ""rejected""
		|			ТОГДА ЗНАЧЕНИЕ(Перечисление.СтатусКартыУчастника.Блокирована)
		|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.СтатусКартыУчастника.НеЗарегистрирована)
		|	КОНЕЦ КАК Статус,
		|	тзФ.КодУч
		|ПОМЕСТИТЬ Ф
		|ИЗ
		|	&тзФ КАК тзФ
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	Ф.Код,
		|	Ф.Статус,
		|	Ф.КодУч,
		|	Участники.Ссылка КАК СсылкаУч ,
		|	КартыУчастников.Ссылка КАК СсылкаКарта
		|ПОМЕСТИТЬ Итоговая
		|ИЗ
		|	Ф КАК Ф
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.КартыУчастников КАК КартыУчастников
		|		ПО Ф.Код = КартыУчастников.Код		
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Участники КАК Участники
		|		ПО Ф.КодУч = Участники.Код";
	Запрос.Параметры.Вставить("тзФ",тзИзФайла);
	Результат=Запрос.Выполнить();
	//
	//
	Запрос.Текст=
		"ВЫБРАТЬ
		|	Ф.Код,
		|	Ф.Статус,
		|	Ф.КодУч,
		|	Ф.СсылкаУч,
		|	Ф.СсылкаКарта

		|ИЗ
		|	Итоговая КАК Ф";

	рез=Запрос.Выполнить();	
	//
	Запрос.Текст=
		"ВЫБРАТЬ
		|	Ф.Код,
		|	Ф.Статус,
		|	Ф.КодУч,
		|	Ф.СсылкаУч,
		|	Ф.СсылкаКарта
		|ИЗ
		|	Итоговая КАК Ф
		|		Где  Ф.СсылкаУч есть NULL ";

	результатНетУч=Запрос.Выполнить();	
	Выборка = результатНетУч.Выбрать();
	Пока Выборка.Следующий() Цикл
		сзУчастн.добавить(Выборка.КодУч);
		сзКарты.добавить(Выборка.Код);
	КонецЦикла;
	
	
	Запрос.Текст=
		"ВЫБРАТЬ
		|	Ф.Код,
		|	Ф.Статус,
		|	Ф.КодУч,
		|	Ф.СсылкаУч как Владелец,
		|	Ф.СсылкаКарта
		|ИЗ
		|	Итоговая КАК Ф
		|		Где не Ф.СсылкаУч есть NULL и Ф.СсылкаКарта есть null";
	
	
	
	результатНетКарты=Запрос.Выполнить();	
	Выборка = результатНетКарты.Выбрать();
	
	Пока Выборка.Следующий() Цикл
		ДобавитьКартуИзСтрТЗ(Выборка);
	КонецЦикла;
	
	
	
	
	
	//
	Запрос.Текст=
		"ВЫБРАТЬ
		|	Ф.Код,
		|	Ф.Статус,
		|	Ф.КодУч,
		|	Ф.СсылкаУч как Владелец,
		|	Ф.СсылкаКарта
		|ИЗ
		|	Итоговая КАК Ф
		|		Где не Ф.СсылкаУч есть NULL и не Ф.СсылкаКарта есть null  и
		|		     (ф.Статус<>Ф.СсылкаКарта.Статус или
		|		     ф.КодУч<>Ф.СсылкаУч.Код)";
	
	
	
	результатИзменилисьКарты=Запрос.Выполнить();	
	Выборка = результатИзменилисьКарты.Выбрать();
	Пока Выборка.Следующий() Цикл
		ДобавитьКартуИзСтрТЗ(Выборка);
	КонецЦикла;
//	аСПОбменССайтомСервер.УстановитьДатуЗагрузкиКарт();
КонецПроцедуры	




Функция ДобавитьКартуИзСтрТЗ(стр) экспорт
	КартаДобавлена=истина;
	Если ЗначениеЗаполнено(стр.СсылкаКарта) Тогда
		Карта=стр.СсылкаКарта.ПолучитьОбъект();
	Иначе	
		Карта=Справочники.КартыУчастников.СоздатьЭлемент();
		//Участник.Код=Число(стр.Код);	
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(Карта,стр);
	Карта.ДатаЗагрузки=ТекущаяДата();
	
	Попытка
		Карта.Записать();
	Исключение
		Сообщение = Новый СообщениеПользователю();
		Сообщение.Текст = ОписаниеОшибки();
		Сообщение.Сообщить();
		ПокупкаДобавлена=Ложь;
	КонецПопытки;
КонецФункции



Функция СформироватьФайлЗагрузкиXDTO(ПараметрыОбмена) Экспорт
	ФайлВыгрузки=КаталогВременныхФайлов()+"dataByDates.xml";
	ЗаписьXML=новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ФайлВыгрузки);
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("distributors");
	
	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsd","http://www.w3.org/2001/XMLSchema");
	
	
	
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("dataByDates");
	
	ДобавитьЭлементXML(ЗаписьXML,"users",		ПараметрыОбмена.ПоследняяЗагрузкаУчастников);         
	ДобавитьЭлементXML(ЗаписьXML,"purchases",	ПараметрыОбмена.ПоследняяЗагрузкаПокупок);     	
	ДобавитьЭлементXML(ЗаписьXML,"cards",		ПараметрыОбмена.ПоследняяЗагрузкаКарты);
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.Закрыть();
	Возврат  ФайлВыгрузки;
КонецФункции



Функция СформироватьФайлЗагрузкиПоЗапросуXDTO(знач колПокупки,знач колУчастники,знач колКарты) Экспорт
	ФайлВыгрузки=КаталогВременныхФайлов()+"Supply.xml";
	ЗаписьXML=новый ЗаписьXML;
	ЗаписьXML.ОткрытьФайл(ФайлВыгрузки);
	
	ЗаписьXML.ЗаписатьНачалоЭлемента("distributors");
	
	
	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsd","http://www.w3.org/2001/XMLSchema");
	
	Если колУчастники.Количество()>0 Тогда
		ЗаписьXML.ЗаписатьНачалоЭлемента("users");
		Для каждого стрУчастник из колУчастники Цикл
			ДобавитьЭлементXML(ЗаписьXML,"user",Формат(стрУчастник.Значение, " ЧГ=0"));         
		КонецЦикла;
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЕсли;
	
	Если колПокупки.Количество()>0 Тогда
		ЗаписьXML.ЗаписатьНачалоЭлемента("purchases");
		Для каждого стрПокупка из колПокупки Цикл
			ДобавитьЭлементXML(ЗаписьXML,"purchase",Формат(стрПокупка.Значение, " ЧГ=0"));         
		КонецЦикла;
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЕсли;
	
	Если колКарты.Количество()>0 Тогда
		ЗаписьXML.ЗаписатьНачалоЭлемента("cards");
		Для каждого стрКарта из колКарты Цикл
			ДобавитьЭлементXML(ЗаписьXML,"card",Формат(стрКарта.Значение, " ЧГ=0"));         
		КонецЦикла;
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЕсли;
	
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	ЗаписьXML.Закрыть();	
	Возврат  ФайлВыгрузки;
	
КонецФункции


Функция СформироватьСтроку(Файл) экспорт
	//Получаю данные из файла     
	ТекстовыйФайл = Файл;
	//Создаю текстовый документ
	ПотокЧтенияСтрок = Новый ТекстовыйДокумент;
	//Читаю файл
	Попытка
		ПотокЧтенияСтрок.Прочитать(ТекстовыйФайл);
	Исключение
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = "Выбранный файл не прочитан!";
		Сообщение.Сообщить();
	КонецПопытки;
	
	//Получаю количество записей в файле
	КоличествоСтрок = ПотокЧтенияСтрок.КоличествоСтрок();
	
	ИтоговаяСтрока = "";
	
	//В каждой строке долбавляю номер в массив
	Для Строка = 1 По КоличествоСтрок Цикл
		СтрокаИзФайла = ПотокЧтенияСтрок.ПолучитьСтроку(Строка);
		ИтоговаяСтрока=ИтоговаяСтрока+СтрокаИзФайла ;
	КонецЦикла;
	
	Возврат ИтоговаяСтрока;
КонецФункции

Функция ПолучитьСтрокуЗапросаОрговПоЗаказам() Экспорт
	СписокЗаказов=новый СписокЗначений;	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Заказы.Код
		|ИЗ
		|	Справочник.Заказы КАК Заказы
		|ГДЕ
		|	(Заказы.Организатор = ЗНАЧЕНИЕ(Справочник.Организаторы.ПустаяСсылка)
		|			ИЛИ Заказы.Организатор = ЗНАЧЕНИЕ(Справочник.Участники.ПустаяСсылка)
		|			ИЛИ Заказы.Организатор = НЕОПРЕДЕЛЕНО)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	
	
	
	ЗаписьXML=новый ЗаписьXML;
	//ЗаписьXML.ОткрытьФайл(ФайлВыгрузки);
	ЗаписьXML.УстановитьСтроку("UTF-8");
	ЗаписьXML.ЗаписатьНачалоЭлемента("distributors");
	
	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsi","http://www.w3.org/2001/XMLSchema-instance");
	ЗаписьXML.ЗаписатьАтрибут("xmlns:xsd","http://www.w3.org/2001/XMLSchema");
	

	ЗаписьXML.ЗаписатьНачалоЭлемента("shopOrders");
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		ДобавитьЭлементXML(ЗаписьXML,"shopOrder",ВыборкаДетальныеЗаписи.Код); 
	КонецЦикла;
	ЗаписьXML.ЗаписатьКонецЭлемента();

	
	
	ЗаписьXML.ЗаписатьКонецЭлемента();
	
	Возврат ЗаписьXML.Закрыть();

КОнецФункции

Функция СформироватьФайлЗапросаОрговПоЗаказам() экспорт
	ИмяФайлаВыгрузки=КаталогВременныхФайлов()+"ShopOrders.xml";
    ФайлВыгрузки = Новый ЗаписьТекста(ИмяФайлаВыгрузки, КодировкаТекста.UTF8, Символы.ПС, ЛОЖЬ);
	СтрокаXML= аСПОбменССайтомСервер.ПолучитьСтрокуЗапросаОрговПоЗаказам();	
	ФайлВыгрузки.ЗаписатьСтроку(СтрокаXML);
	ФайлВыгрузки.Закрыть();
	Возврат  ИмяФайлаВыгрузки;

КонецФункции

