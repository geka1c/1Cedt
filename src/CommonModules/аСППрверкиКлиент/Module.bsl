Функция  НаличиеОткрытыхОкон(НазваниеОкна)  Экспорт
	Окна=ПолучитьОкна();
	рез=0;
	Если НазваниеОкна="Совместные покупки"  Тогда
		Если  Окна.Количество()=1  Тогда
			Возврат Истина
		Иначе
			Возврат ложь
		КонецЕсли;
		
	КонецЕсли;
	
	Для каждого ОкноЭлемент из Окна Цикл
        Если ОкноЭлемент=Неопределено Тогда Продолжить КонецЕсли;
		рез=рез+Найти(ОкноЭлемент.Заголовок,НазваниеОкна);
	КонецЦикла;
	
	
	   
	Если рез>1 тогда
		Возврат  Истина;
	Иначе
		Возврат  Ложь;
	КонецЕсли;
КонецФункции //  ПроверкаОткрытыхОкон()

	