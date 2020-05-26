


Функция ПолучитьЗначенияПоУмолчанию(ТочкаНазначения=Неопределено,ОбрабатыватьЖурналДокументов=Истина)      Экспорт
	СтруктураВозврата					= Новый Структура("Габарит,МестоХранения,ТарифПВ,ТарифПВнп,Процент,ПроцентОС");
	///Берем значения в Пользователе
	ТекПользователь						= ПользователиКлиентСервер.ТекущийПользователь();
	СтруктураВозврата.Габарит			= ТекПользователь.Габарит;
	СтруктураВозврата.МестоХранения		= ТекПользователь.МестоХранения;
	
	Если ЗначениеЗаполнено(СтруктураВозврата.Габарит) И ЗначениеЗаполнено(СтруктураВозврата.МестоХранения) Тогда
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	///Берем значения в Точке назначения
	Если ЗначениеЗаполнено(ТочкаНазначения) Тогда
		СтруктураВозврата.Габарит			=?(не ЗначениеЗаполнено(СтруктураВозврата.Габарит)
												,ТочкаНазначения.Габарит,СтруктураВозврата.Габарит);
		СтруктураВозврата.МестоХранения		=?(не ЗначениеЗаполнено(СтруктураВозврата.МестоХранения)
												,ТочкаНазначения.МестоХранения,СтруктураВозврата.МестоХранения);
		СтруктураВозврата.ТарифПВ	= ТочкаНазначения.ТарифПВ;
		СтруктураВозврата.ТарифПВнп	= ТочкаНазначения.ТарифПВнп;
		СтруктураВозврата.Процент	= ТочкаНазначения.Процент;
		СтруктураВозврата.ПроцентОС	= ТочкаНазначения.ПроцентОС;
	КонецЕсли;	
	
	Если ЗначениеЗаполнено(СтруктураВозврата.Габарит) И ЗначениеЗаполнено(СтруктураВозврата.МестоХранения) Тогда
		Возврат СтруктураВозврата;
	КонецЕсли;
	
	Если не ОбрабатыватьЖурналДокументов Тогда Возврат СтруктураВозврата; Конецесли;
	///Берем значения в ПоследнемДокументе
	
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	Приход.Регистратор,
		|	Приход.МестоХранения,
		|	Приход.Габарит
		|ИЗ
		|	РегистрНакопления.Приход КАК Приход
		|УПОРЯДОЧИТЬ ПО
		|	Приход.Период УБЫВ";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		СтруктураВозврата.Габарит			= ?(не ЗначениеЗаполнено(СтруктураВозврата.Габарит)
				,ВыборкаДетальныеЗаписи.Габарит
				,СтруктураВозврата.Габарит);
		СтруктураВозврата.МестоХранения		= ?(не ЗначениеЗаполнено(СтруктураВозврата.МестоХранения)
				,ВыборкаДетальныеЗаписи.МестоХранения
				,СтруктураВозврата.МестоХранения);
	КонецЕсли;
	
	Возврат СтруктураВозврата;
КонецФункции	






Функция  ПоискОрганизатора(Покупка) экспорт
	Если не ЗначениеЗаполнено(Покупка) Тогда
		Орг	= Справочники.Организаторы.нулевой;
	ИначеЕсли ТипЗнч(Покупка)=Тип("СправочникСсылка.Покупки")Тогда	
		Орг	= СП_РаботаСоСправочниками.ПолучитьОрганизатораПо_Коду(Покупка.Владелец.Код);	
	ИначеЕсли ТипЗнч(Покупка)=Тип("СправочникСсылка.Пристрой")Тогда	
		Орг	= Справочники.Организаторы.нулевой;
	Иначе                                    
		Если ЗначениеЗаполнено(Покупка.Организатор) Тогда
			Орг	= СП_РаботаСоСправочниками.ПолучитьОрганизатораПо_Коду(Покупка.Организатор.Код);
		КонецЕсли;
	КонецЕсли;	
	Если не ЗначениеЗаполнено(Орг) Тогда
		Орг= Справочники.Организаторы.нулевой;
	КонецЕсли;	
	Возврат Орг;	
КонецФункции	


Функция ПоказыватьРейтингУчастника() экспорт
	
	Возврат Константы.ПоказыватьРейтингВрасходной.Получить();	
КонецФункции	

функция ПолучитьКонстанту(имяКонстанты) Экспорт
	возврат Константы[имяКонстанты].Получить();
КонецФункции	


Функция разрешеноПринимать(Участник) Экспорт
	Группа=Константы.гпНеПринимать.Получить() ;
	Если ЗначениеЗаполнено(Группа) Тогда
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	УчастникиВГруппах.Группа,
		|	УчастникиВГруппах.Участник
		|ИЗ
		|	РегистрСведений.УчастникиВГруппах КАК УчастникиВГруппах
		|ГДЕ
		|	УчастникиВГруппах.Группа = &Группа
		|	И УчастникиВГруппах.Участник = &Участник";
		
		Запрос.УстановитьПараметр("Группа", Группа);
		Запрос.УстановитьПараметр("Участник", Участник);
		
		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Если ВыборкаДетальныеЗаписи.Количество()>0 Тогда
			Возврат Ложь;
		КонецЕсли;
		
	КонецЕсли;	
	Возврат Истина;
КонецФункции



Функция  ПоказыватьАнализОтвета() Экспорт
	Возврат Константы.ПоказыватьАнализОтвета.Получить();
КонецФункции	



Функция  ВыгружатьПриходПриЗаписи() Экспорт
	Возврат Константы.ВыгружатьПриходПриЗаписи.Получить();
КонецФункции	




Функция ПолучитьНазваниеОрганизации() экспорт
	Возврат Константы.НазваниеОрганизации.Получить();
	
КонецФункции	

функция РассчитатьСтоимостьХранения(Параметры) Экспорт

		ВремяХраненияНаСкладе			= Параметры.ВремяХранения;
		ВремяХраненияЗаСчетОрганизатора = ?(Параметры.БесплатнаяВыдача,Константы.ДниХраненияБесплатнойДоставки.Получить(),0);
		ДобавочнаяСтоимость				= Параметры.Габарит.ДобавочнаяСтоимость;
		ДниХранения						= Параметры.Габарит.ДниХранения;
		Если Параметры.Габарит.Негабарит Тогда
			СтоимостьКг		= Параметры.Габарит.СтоимостьКг*Параметры.Вес;
			СтоимостьКуб	= Параметры.Габарит.СтоимостьКуб*Параметры.Объем;
			СтоимостьХранения  = ?(СтоимостьКг > СтоимостьКуб, СтоимостьКг,СтоимостьКуб);
		Иначе
			СтоимостьХранения		= Параметры.Габарит.СтоимостьХранения;				
		КонецЕсли;
			
		Если ВремяХраненияЗаСчетОрганизатора > 0 Тогда
			ДнейШтрафаЗаСчетОрганизатора = ?(ВремяХраненияЗаСчетОрганизатора > ДниХранения, ВремяХраненияЗаСчетОрганизатора	- ДниХранения, 0);
			ШтрафЗаСчетОрганизатора = ДнейШтрафаЗаСчетОрганизатора * ДобавочнаяСтоимость;
			ЛимитОплатыОрганизатора = СтоимостьХранения + ШтрафЗаСчетОрганизатора + Параметры.СтоимостьДоставки;
		Иначе
			ЛимитОплатыОрганизатора = 0;
		КонецЕсли;	
		
		ДнейШтрафаИтого					= ?(ВремяХраненияНаСкладе >  ДниХранения, ВремяХраненияНаСкладе - ДниХранения, 0);
		ШтрафИтого						= ДнейШтрафаИтого * ДобавочнаяСтоимость;
		
		СтоимостьИтого					= СтоимостьХранения + ШтрафИтого				+ Параметры.СтоимостьДоставки;	

		ОплачиваетОрганизатор  			= ?(ЛимитОплатыОрганизатора > СтоимостьИтого, СтоимостьИтого, ЛимитОплатыОрганизатора);
		ОплачиваетУчастник				= СтоимостьИтого - ОплачиваетОрганизатор;
		
		Результат = Новый Структура;
		Результат.Вставить("СтоимостьИтого", 		СтоимостьИтого);
		Результат.Вставить("ОплачиваетОрганизатор", ОплачиваетОрганизатор);
		Результат.Вставить("ОплачиваетУчастник", 	ОплачиваетУчастник);
		Результат.Вставить("СтоимостьХранения", 	СтоимостьХранения);
			
		Возврат Результат;
КонецФункции	


Функция ПолучитьМаршрутныйЛист(Объект) экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	МаршрутныйЛист.Ссылка
		|ИЗ
		|	Документ.МаршрутныйЛист КАК МаршрутныйЛист
		|ГДЕ
		|	 МаршрутныйЛист.Основание = &Основание
		|
		|УПОРЯДОЧИТЬ ПО
		|	МаршрутныйЛист.Дата УБЫВ";
	Запрос.Параметры.Вставить("Основание",Объект);	
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	
	Если  ВыборкаДетальныеЗаписи.Следующий() Тогда
		Возврат ВыборкаДетальныеЗаписи.ссылка;
	КонецЕсли;
	Возврат Документы.МаршрутныйЛист.ПустаяСсылка();
КонецФункции	


Функция НайтиМегаордер(Покупка,Участник) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Мегаордера.Ссылка КАК Ссылка
		|ИЗ
		|	Справочник.Мегаордера КАК Мегаордера
		|ГДЕ
		|	Мегаордера.Участник = &Участник
		|	И Мегаордера.Покупка = &Покупка";
	
	Запрос.УстановитьПараметр("Покупка", Покупка);
	Запрос.УстановитьПараметр("Участник", Участник);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выбрать();
КонецФункции	

Функция ПолучитьМегаордер(Покупка,Участник=Неопределено) Экспорт
	Если Участник=неопределено Тогда
		Участник=Справочники.Участники.нулевой;
	КонецЕсли;
	Выборка = НайтиМегаордер(Покупка,Участник);
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Справочники.Мегаордера.ПустаяСсылка();
	КонецЕсли;
КонецФункции


// <Описание функции>
//
// Параметры
//  <ДатаКонец>  - <Дата> - <дата конца периода>
//
//  <ДатаНачало>  - <Дата> - <Дата начала периода>
//
//
// Возвращаемое значение:
//   <Число>   - <количество дней между датами>
//			<Если ДатаКонец<ДатаНачало возвращаем 0 дн >		
Функция РазностьДат(ДатаКонец,ДатаНачало)  Экспорт 
	
	 	//{{КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА
	// Данный фрагмент построен конструктором.
	// При повторном использовании конструктора, внесенные вручную изменения будут утеряны!!!

	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(1) КАК количество
		|ИЗ
		|	Справочник.ПраздничныеДни КАК ПраздничныеДни
		|ГДЕ
		|	ПраздничныеДни.Дата <= &ДатаК
		|	И ПраздничныеДни.Дата >= &ДатаН";

	Запрос.УстановитьПараметр("ДатаК", ДатаКонец);
	Запрос.УстановитьПараметр("ДатаН", ДатаНачало);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
    КоличествоПраздников=0;
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		КоличествоПраздников=?(ВыборкаДетальныеЗаписи.количество=null,0,ВыборкаДетальныеЗаписи.количество);
	КонецЦикла;

	//}}КОНСТРУКТОР_ЗАПРОСА_С_ОБРАБОТКОЙ_РЕЗУЛЬТАТА

	
	Если ДатаКонец<ДатаНачало тогда

		возврат 0;
	КонецЕсли;
	КоличествоДней=0;
	Если Год(ДатаКонец)-Год(ДатаНачало)>0 Тогда
		КоличествоДней=(Год(ДатаКонец)-Год(ДатаНачало))*365;
	КонецЕсли;
	КоличествоДней=КоличествоДней+(ДеньГода(ДатаКонец)-ДеньГода(ДатаНачало))-КоличествоПраздников;
	Возврат КоличествоДней;
КонецФункции // РазностьДат()


Функция РаспределитьПропорционально(Знач ИсхСумма, МассивКоэф, Знач Точность = 2) Экспорт
	
	Если МассивКоэф.Количество() = 0 Или ИсхСумма = 0 Или ИсхСумма = Null Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	ИндексМакс = 0;
	МаксЗнач   = 0;
	РаспрСумма = 0;
	СуммаКоэф  = 0;
	
	Для К = 0 По МассивКоэф.Количество() - 1 Цикл
		
		МодульЧисла = ?(МассивКоэф[К] > 0, МассивКоэф[К], - МассивКоэф[К]);
		
		Если МаксЗнач < МодульЧисла Тогда
			МаксЗнач = МодульЧисла;
			ИндексМакс = К;
		КонецЕсли;
		
		СуммаКоэф = СуммаКоэф + МассивКоэф[К];
		
	КонецЦикла;
	
	Если СуммаКоэф = 0 Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	МассивСумм = Новый Массив(МассивКоэф.Количество());
	
	Для К = 0 По МассивКоэф.Количество() - 1 Цикл
		МассивСумм[К] = Окр(ИсхСумма * МассивКоэф[К] / СуммаКоэф, Точность, 1);
		РаспрСумма = РаспрСумма + МассивСумм[К];
	КонецЦикла;
	
	// Погрешности округления отнесем на коэффицент с максимальным весом
	Если Не РаспрСумма = ИсхСумма Тогда
		МассивСумм[ИндексМакс] = МассивСумм[ИндексМакс] + ИсхСумма - РаспрСумма;
	КонецЕсли;
	
	Возврат МассивСумм;

КонецФункции


