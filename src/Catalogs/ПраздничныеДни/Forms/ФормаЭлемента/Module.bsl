

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	отказ=не ПроверкаДаты(Объект.Дата);

КонецПроцедуры



&НаСервере
Функция ПроверкаДаты(прДата)

		Запрос = Новый Запрос;
		Запрос.Текст = 
			"ВЫБРАТЬ
			|	ПраздничныеДни.Дата
			|ИЗ
			|	Справочник.ПраздничныеДни КАК ПраздничныеДни
			|ГДЕ
			|	ПраздничныеДни.Дата = &ДатаТек";

		Запрос.УстановитьПараметр("ДатаТек", прДата);

		Результат = Запрос.Выполнить();

		ВыборкаДетальныеЗаписи = Результат.Выбрать();
        запись=истина;
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Сообщить("Элемент на дату "+прДата+"Уже добавлен");
			запись=ложь;
		КонецЦикла;
        Возврат запись;

КонецФункции // ПроверкаДаты()
