

&НаКлиенте
Процедура ПолучитьПосылки(Команда)
	Если КодПосылки = "" Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Укажите ""Код посылки""");
		Возврат;
	КонецЕсли;
	Если Не ЗначениеЗаполнено(ПунктВыдачи) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Укажите ""Пункт выдачи""");
		Возврат;
	КонецЕсли;
	
	ПолучитьПосылкиНаСервере();
	
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ПосылкаПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры



Процедура ПолучитьПосылкиНаСервере()
	Если КодПосылки = "" Тогда
		
	Иначе
		Посылка = СП_РаботаСоСправочниками.ПолучитьПосылкуПо_Коду(КодПосылки); 
		Если Посылка.Догрузить Тогда
		 	СтоСПОбмен_Посылки.Загрузить_СоставПосылкиПоКодам(Посылка);	
		КонецЕсли;	
		
		ПараметрыПосылки 	= Новый Структура;
		ШтрихКод			= СП_Штрихкоды.ПолучитьМегаордер(Посылка, , ПунктВыдачи);
		ПараметрыПосылки.Вставить("ШК", ШтрихКод);
		ПараметрыПосылки.Вставить("ПунктВыдачи", ПунктВыдачи);
		СП_РаботаСоСправочниками.ОбновитьПосылку(посылка, ПараметрыПосылки);
		СП_РаботаСоСправочниками.ОбновитьМегаордерПосылки(ШтрихКод,посылка);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Выбрать(Команда)
	Закрыть(Новый Структура("Посылка, ШК",Посылка, ШтрихКод));
КонецПроцедуры


Процедура УстановитьВидимость()
	Элементы.Выбрать.Видимость = ЗначениеЗаполнено(Посылка);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
КонецПроцедуры
	
