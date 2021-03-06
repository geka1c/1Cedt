




Функция НаличиеОстатковНаСкладе(Покупки,Участник)      Экспорт
	Если Не Константы.КонтралироватьОстаткиПриРасходе.Получить() Тогда
		Возврат Истина;	
	КонецЕсли;
	Рез=Истина;
	
	Для каждого СтрокаДок из Покупки Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОстаткиТоваровОстатки.Габарит,
		|	ОстаткиТоваровОстатки.Участник,
		|	ОстаткиТоваровОстатки.МестоХранения,
		|	ОстаткиТоваровОстатки.Покупка,
		|	ОстаткиТоваровОстатки.Партия,
		|	ОстаткиТоваровОстатки.Оплачен,
		|	ОстаткиТоваровОстатки.Потерян,
		|	ОстаткиТоваровОстатки.КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров.Остатки(
		|			,
		|			Габарит = &Габарит
		|				И Участник = &Участник
		|				И МестоХранения = &МестоХранения
		|				И Покупка = &Покупка
		|				И Партия = &Партия
		|				И Оплачен = &Оплачен
		|				И Потерян = &Потерян) КАК ОстаткиТоваровОстатки";
		
		Запрос.УстановитьПараметр("Габарит",СтрокаДок.Габарит);
		Запрос.УстановитьПараметр("МестоХранения", СтрокаДок.МестоХранения);
		Запрос.УстановитьПараметр("Оплачен", СтрокаДок.Оплачен);
		Запрос.УстановитьПараметр("Партия", СтрокаДок.Партия);
		Запрос.УстановитьПараметр("Покупка", СтрокаДок.Покупка);
		Запрос.УстановитьПараметр("Потерян", СтрокаДок.Потерян);
		Запрос.УстановитьПараметр("Участник", Участник);
		
		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Если не ВыборкаДетальныеЗаписи.Следующий() Тогда
			
				Сообщить("Невозможно провести документ!");
				Сообщить("Для строки № "+СтрокаДок.НомерСтроки+"нет остатков на складе.");
				Рез=Ложь;
			
		КонецЕсли;
	КонецЦикла;
	Возврат Рез;
КонецФункции


Функция НаличиеОстатковНаСкладеДвиж(Покупки)      Экспорт
	Если Не Константы.КонтралироватьОстаткиПриРасходе.Получить() Тогда
		Возврат Истина;	
	КонецЕсли;
	Рез=Истина;
	
	Для каждого СтрокаДок из Покупки Цикл
		
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОстаткиТоваровОстатки.Габарит,
		|	ОстаткиТоваровОстатки.Участник,
		|	ОстаткиТоваровОстатки.МестоХранения,
		|	ОстаткиТоваровОстатки.Покупка,
		|	ОстаткиТоваровОстатки.Партия,
		|	ОстаткиТоваровОстатки.Оплачен,
		|	ОстаткиТоваровОстатки.Потерян,
		|	ОстаткиТоваровОстатки.КоличествоОстаток
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров.Остатки(
		|			,
		|			Габарит = &Габарит
		|				И Участник = &Участник
		|				И МестоХранения = &МестоХранения
		|				И (Покупка = &Покупка или Покупка = &ПокупкаКод)
		|				И Партия = &Партия
		|				И Оплачен = &Оплачен
		|				И Потерян = &Потерян) КАК ОстаткиТоваровОстатки";
		
		Запрос.УстановитьПараметр("Габарит",СтрокаДок.Габарит);
		Запрос.УстановитьПараметр("МестоХранения", СтрокаДок.МестоХранения);
		Запрос.УстановитьПараметр("Оплачен", СтрокаДок.Оплачен);
		Запрос.УстановитьПараметр("Партия", СтрокаДок.Партия);
		Запрос.УстановитьПараметр("Покупка", СтрокаДок.Покупка);
		Запрос.УстановитьПараметр("ПокупкаКод", СтрокаДок.Покупка.Код);
		Запрос.УстановитьПараметр("Потерян", СтрокаДок.Потерян);
		Запрос.УстановитьПараметр("Участник", СтрокаДок.Участник);
		
		Результат = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = Результат.Выбрать();
		
		Если не ВыборкаДетальныеЗаписи.Следующий() Тогда
			
				Сообщить("Невозможно провести документ!");
				Сообщить("Для строки № "+СтрокаДок.НомерСтроки+"нет остатков на складе.");
				Рез=Ложь;
			
		КонецЕсли;
		
		
		
	КонецЦикла;
	Возврат Рез;
КонецФункции

Функция НужноПечататьЧек(КодУчастника,ИмяКомпьютера,Сумма) экспорт
	Если Сумма = 0 Тогда возврат Ложь КОнецЕсли; 
	ЛимитЧека=Константы.ЛимитККМ_Чек.Получить();
	ПревышенаСуммаЧека=Ложь;
	Если ЛимитЧека>0 и Сумма>ЛимитЧека  Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Превышенна предельная сумма чека!");
		ПревышенаСуммаЧека=Истина;
	КонецЕсли;
	
	Если ТипЗнч(КодУчастника) = Тип("СправочникСсылка.Участники") Тогда
		участник	= КодУчастника;
	Иначе
		участник	= СП_РаботаСоСправочниками.ПолучитьУчастникаПо_Коду(КодУчастника);	
	КонецЕсли;	
	Если (участник.Рэйтинг<Константы.РейтингГраница.Получить() или участник.ВсегдаПечататьЧек) и 
			не ВыбранаДневнаяСумма() и 
			не ПревышенаСуммаЧека 		Тогда
		Возврат истина;
	Иначе
		Возврат Ложь;
	КонецЕсли	
КонецФункции


Функция ВыбранаДневнаяСумма()
	
	
	ЛимитККМ=Константы.ЛимитККМ_День.Получить();
	Если ЛимитККМ=0 Тогда Возврат Ложь; КонецЕсли;
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	СУММА(Расходная.СтоимостьИтого) КАК СтоимостьИтого
		|ИЗ
		|	Документ.Расходная КАК Расходная
		|ГДЕ
		|	Расходная.Дата МЕЖДУ &НачалоДня И &КонецДня
		|	И Расходная.НомерСменыККМ <> 0";
	
	Запрос.УстановитьПараметр("КонецДня", КонецДня(ТекущаяДата()));
	Запрос.УстановитьПараметр("НачалоДня", НачалоДня(ТекущаяДата()));
	
	РезультатЗапроса = Запрос.Выполнить();
	
	ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
	СуммаЗаДень=0;
	Если ВыборкаДетальныеЗаписи.Следующий() Тогда
		СуммаЗаДень= ?(ВыборкаДетальныеЗаписи.СтоимостьИтого=null,0,ВыборкаДетальныеЗаписи.СтоимостьИтого);
	КонецЕсли;
	Возврат (СуммаЗаДень>=ЛимитККМ);
	
	
	
КонецФункции


//Функция ВынрузкаПросрочена() экспорт
//	
//	возврат Константы.ПоследняяВыгрузка.Получить()+2*60*60*24<ТекущаяДата();	
//	
//КонецФункции	

Функция ИспользуетсяВДвижениях(Партия) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ОстаткиТоваровОстаткиИОбороты.Регистратор КАК Регистратор,
		|	ОстаткиТоваровОстаткиИОбороты.Участник КАК Участник,
		|	ОстаткиТоваровОстаткиИОбороты.МестоХранения КАК МестоХранения,
		|	ОстаткиТоваровОстаткиИОбороты.Габарит КАК Габарит
		|ИЗ
		|	РегистрНакопления.ОстаткиТоваров.ОстаткиИОбороты(, , Регистратор, , Партия = &партия) КАК ОстаткиТоваровОстаткиИОбороты
		|ГДЕ
		|	(ОстаткиТоваровОстаткиИОбороты.Регистратор ССЫЛКА Документ.Расходная
		|			ИЛИ ОстаткиТоваровОстаткиИОбороты.Регистратор ССЫЛКА Документ.Движение)
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ТранзитОстаткиИОбороты.Регистратор,
		|	ТранзитОстаткиИОбороты.Участник,
		|	ТранзитОстаткиИОбороты.МестоХранения,
		|	ТранзитОстаткиИОбороты.Габарит
		|ИЗ
		|	РегистрНакопления.Транзит.ОстаткиИОбороты(, , Регистратор, , Партия = &партия) КАК ТранзитОстаткиИОбороты
		|ГДЕ
		|	ТранзитОстаткиИОбороты.Регистратор ССЫЛКА Документ.ВыдачаТранзита
		|
		|УПОРЯДОЧИТЬ ПО
		|	Регистратор,
		|	МестоХранения,
		|	Участник,
		|	Габарит";

	Запрос.УстановитьПараметр("партия", Партия);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();
	
	Если ВыборкаДетальныеЗаписи.Количество()>0 тогда
		
		Результат= Истина;
		Сообщить("Данный документ невозможно перепровести илми пометить на удаление поскольку на него ссылаются следующие документы");
	Иначе
		Результат= ложь;
	КонецЕсли;

	
	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
		Сообщить("Документ :"+ВыборкаДетальныеЗаписи.Регистратор);		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции 

Процедура ПроверитьГруппыДоставкиНаСервере() Экспорт
	мТекущийПользователь =ПользователиКлиентСервер.ТекущийПользователь();
	Если ПараметрыСеанса.ЗапуститьУчетГруппДоставки и мТекущийПользователь = Константы.АдминистраторДоставки.Получить() Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Загруженна новая информация по Группамм доставки!",);
	КонецЕсли;
КонецПроцедуры