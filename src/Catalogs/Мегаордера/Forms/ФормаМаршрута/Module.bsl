
&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	//Оповещаем форму документа чтоб перепровести из нее(чтоб объект не похерился)
	Если ТипЗнч(Объект.Покупка) = Тип("ДокументСсылка.ВыдачаТранзита") Тогда
		Оповестить("ПерепровестиДокумент",Объект.Покупка);
	КонецЕсли;

КонецПроцедуры


&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	#Область СтарыеОбмены100сп
	Если ЗначениеЗаполнено(Объект.Ссылка) и ТипЗнч(Объект.Покупка) = Тип("ДокументСсылка.ВыдачаТранзита") Тогда
		//Убираем  ответные движения, Будет заново отправлено на ссайт
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Обмен100сп.Регистратор КАК Регистратор
		|ИЗ
		|	РегистрСведений.Обмен100сп КАК Обмен100сп
		|ГДЕ
		|	Обмен100сп.Партия = &Партия
		|	И Обмен100сп.Мегаордер = &Мегаордер
		|	И Обмен100сп.типОбмена = &типОбмена
		|	И ТИПЗНАЧЕНИЯ(Обмен100сп.Регистратор) = ТИП(Документ.ПакетНаСайт)";
		
		Запрос.УстановитьПараметр("Мегаордер", Объект.Ссылка);
		Запрос.УстановитьПараметр("Партия", Объект.Покупка);
		Запрос.УстановитьПараметр("типОбмена", Перечисления.ТипыОбменов100сп.СуперГруппа);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		Выборка= РезультатЗапроса.Выбрать();
		
		Пока Выборка.Следующий() Цикл
			пакет=Выборка.Регистратор.ПолучитьОбъект();
			масСтрок=пакет.Детально.НайтиСтроки(Новый Структура("Мегаордер, Партия ,ТипОбмена" ,
			Объект.Ссылка,Объект.Покупка,Перечисления.ТипыОбменов100сп.СуперГруппа));
			Для каждого стр из масСтрок Цикл
				стр.ДвижениеУстарело=Истина;
			КонецЦикла;
			Попытка
				пакет.Записать(РежимЗаписиДокумента.Проведение);
			Исключение
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось провести "+пакет.Ссылка);	
				отказ=истина;
			КонецПопытки;
		КонецЦикла;
	Конецесли;
	#КонецОбласти
КонецПроцедуры
