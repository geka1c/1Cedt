&НаКлиенте
Процедура РезультатОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
      
      СтруктураДанных = Новый Структура;
      СтруктураДанных.Вставить("Участник", "Участник");
	  //СтруктураДанных.Вставить("Менеджер", "Контрагент.ОсновнойМенеджерПокупателя");
	  //СтруктураДанных.Вставить("ДоговорКонтрагента", "ДоговорКонтрагента");

      ЗначенияРасшифровки = ПолучитьДанныеРасшифровки(Расшифровка, СтруктураДанных);
      Если ЗначенияРасшифровки = неопределено Тогда Возврат; КонецЕсли;
      СтандартнаяОбработка = Ложь;
      обрРасшифровки	= новый ОбработкаРасшифровкиКомпоновкиДанных(ДанныеРасшифровки, новый ИсточникДоступныхНастроекКомпоновкиДанных(Отчет));
      
      выпДействие		= ДействиеОбработкиРасшифровкиКомпоновкиДанных.Нет;
	  
	  ПараметрВыполненогоДействия	=  Неопределено;
	  
	  ДоступныеДействия	= Новый Массив;      
      ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение);
      ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Отфильтровать);
      ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Оформить);
      ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Расшифровать);
      ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Сгруппировать);
      ДоступныеДействия.Добавить(ДействиеОбработкиРасшифровкиКомпоновкиДанных.Упорядочить);
      
      ДополнительныеПункты	= новый СписокЗначений();
      ДополнительныеПункты.Добавить("Чек", 		"Чек с местами хранения");
      ДополнительныеПункты.Добавить("Движение", "Движение");
      обрРасшифровки.ВыбратьДействие(Расшифровка, выпДействие ,ПараметрВыполненогоДействия,ДоступныеДействия,ДополнительныеПункты);

	 Если выпДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.Нет Тогда
	 	
	 ИначеЕсли выпДействие = ДействиеОбработкиРасшифровкиКомпоновкиДанных.ОткрытьЗначение Тогда	
	 	ОткрытьЗначение(ПараметрВыполненогоДействия);
	 ИначеЕсли выпДействие = "Чек" Тогда	
			СтоСП_Печать_Клиент.ЧекНЗРасходная(ЗначенияРасшифровки.участник,Истина);
	 ИначеЕсли выпДействие = "Движение" Тогда	
	 	ПараметрДаты	=	Отчет.КомпоновщикНастроек.Настройки.ПараметрыДанных.НайтиЗначениеПараметра(новый ПараметрКомпоновкиДанных("НаДату"));
		ПараметрыЗаполнения= Новый Структура();
		ПараметрыЗаполнения.Вставить("ДатаОтчета", 		ПараметрДаты.Значение);
//		ПараметрыЗаполнения.Вставить("ДнейХранения", 	новый структура("ПравоеЗначение, Использование, ВидСравнения",14, Истина, ВидСравненияКомпоновкиДанных.Больше) );
		ПараметрыЗаполнения.Вставить("Участник", 		новый структура("ПравоеЗначение, Использование",ЗначенияРасшифровки.участник, Истина) );
	
    	ОписаниеОповещения = Новый ОписаниеОповещения("ПослеОткрытияДвижения",ЭтаФорма);
	
		ОткрытьФорму("Документ.Движение.ФормаОбъекта",Новый структура("ПараметрыЗаполнения",ПараметрыЗаполнения) ,ЭтаФорма,,,,ОписаниеОповещения  );
			


	 КонецЕсли;	
      

//	  Если ЗначениеЗаполнено(ЗначенияРасшифровки.участник) Тогда
//		  СтандартнаяОбработка = Ложь;
//			СтоСП_Печать_Клиент.ЧекНЗРасходная(ЗначенияРасшифровки.участник);	  
//	  КонецЕсли;	
	    
	    
	    
	    
КонецПроцедуры

&НаКлиенте
Процедура ПослеОткрытияДвижения(Результат, ДопПараметры) Экспорт
КонецПроцедуры

&НаСервере
Функция ПолучитьДанныеРасшифровки(Расшифровка, СтруктураДанных)

      Данные_Расшифровки = ПолучитьИзВременногоХранилища(ДанныеРасшифровки);

      Если Данные_Расшифровки <> Неопределено Тогда
            Для каждого ЭлементДанных Из СтруктураДанных Цикл
                  Родитель = Данные_Расшифровки.Элементы[Расшифровка];
                  Пока Истина Цикл
                        МассивРодителей = Родитель.ПолучитьРодителей();
                        Если МассивРодителей.Количество() = 0 Тогда
                              Прервать;
                        КонецЕсли;
                        Родитель = Родитель.ПолучитьРодителей()[0];
                        Если ТипЗнч(Родитель) = Тип("ЭлементРасшифровкиКомпоновкиДанныхПоля") Тогда
                              Поле = Родитель.ПолучитьПоля().Найти(ЭлементДанных.Значение);
                              Если Поле <> Неопределено Тогда
                                    СтруктураДанных.Вставить(ЭлементДанных.Ключ, Поле.Значение);
                                    Прервать;
                              КонецЕсли;
                        КонецЕсли;
                  КонецЦикла;
            КонецЦикла;
      КонецЕсли;

      Возврат СтруктураДанных;

  КонецФункции // ПолучитьДанныеРасшифровки()
  
  
  
