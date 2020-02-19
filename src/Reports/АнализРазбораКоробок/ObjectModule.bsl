
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
    КомпоновщикМакет = Новый КомпоновщикМакетаКомпоновкиДанных;
    Макет = КомпоновщикМакет.Выполнить(СхемаКомпоновкиДанных, КомпоновщикНастроек.ПолучитьНастройки(), ДанныеРасшифровки);
    ПроцессорКомпоновки = Новый ПроцессорКомпоновкиДанных;
    ПроцессорКомпоновки.Инициализировать(Макет, , ДанныеРасшифровки);
    ПроцессорВывода = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
    ПроцессорВывода.УстановитьДокумент(ДокументРезультат);
    ПроцессорВывода.Вывести(ПроцессорКомпоновки);
    ДокументРезультат.ПоказатьУровеньГруппировокСтрок(2); //Уровень 3
    ДокументРезультат.ПоказатьУровеньГруппировокСтрок(1); //Уровень 2
    ДокументРезультат.ПоказатьУровеньГруппировокСтрок(0);   //Уровень 1
КонецПроцедуры
