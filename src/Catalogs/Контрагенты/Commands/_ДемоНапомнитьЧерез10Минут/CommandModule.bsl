
&НаКлиенте
Процедура ОбработкаКоманды(ПараметрКоманды, ПараметрыВыполненияКоманды)
	
	НапоминанияПользователяКлиент.НапомнитьВУказанноеВремя(
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("""%1"" требует внимания", ПараметрКоманды),
		ОбщегоНазначенияКлиент.ДатаСеанса() + 10*60,
		ПараметрКоманды);
		
	Состояние(НСтр("ru = 'Напоминание добавлено'"));
	
КонецПроцедуры
