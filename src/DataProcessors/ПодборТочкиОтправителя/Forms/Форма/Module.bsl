&НаКлиенте
Процедура ПриОткрытии(Отказ)
	//Объект.СрокВозврата=14;
	ЗаполнитьТабЧасть();
	ОбновитьОтображениеДанных();
	Элементы.Участник.ТолькоПросмотр=Истина;
КонецПроцедуры

Процедура ЗаполнитьТабЧасть()
КонецПроцедуры	

&НаКлиенте
Процедура Выбрать(Команда)
	сз=новый СписокЗначений;
	Для каждого стр из Объект.ВыданныеПокупки Цикл
		Если стр.Пометка Тогда
			сз.Добавить(стр.КодПокупки);
		КонецЕсли;
	КонецЦикла;	             
	ОповеститьОВыборе(СЗ);
КонецПроцедуры


