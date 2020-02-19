
&НаКлиенте
Процедура Заполнить(Команда)
	ВыбранноеЗначение=новый Структура;
	ВыбранноеЗначение.Вставить("КомпоновщикНастроек",КомпоновщикНастроек);
	ВыбранноеЗначение.Вставить("АдресСхемы",АдресСхемыКомпоновкиДанных);
	ОповеститьОВыборе(ВыбранноеЗначение);
КонецПроцедуры


&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Схема=Документы.Движение.ПолучитьМакет(Параметры.имяСхемы);
	АдресСхемыКомпоновкиДанных = ПоместитьВоВременноеХранилище(Схема, УникальныйИдентификатор);
    ИсточникНастроек = Новый ИсточникДоступныхНастроекКомпоновкиДанных(АдресСхемыКомпоновкиДанных);
	
	КомпоновщикНастроек.Инициализировать(ИсточникНастроек);
	КомпоновщикНастроек.ЗагрузитьНастройки(Схема.НастройкиПоУмолчанию);
	
КонецПроцедуры
