
&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ВыбраннаяДата = ТекущаяДата();
КонецПроцедуры

&НаКлиенте
Процедура выбрать(Команда)
	Закрыть(ВыбраннаяДата);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Элементы.ВыбраннаяДата.Подсказка = Параметры.Сообщение;
КонецПроцедуры
