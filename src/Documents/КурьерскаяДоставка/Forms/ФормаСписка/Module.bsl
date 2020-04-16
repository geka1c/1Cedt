


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
     //Конец СтандартныеПодсистемы.ПодключаемыеКоманды	
КонецПроцедуры

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды

КонецПроцедуры

// Конец СтандартныеПодсистемы.ПодключаемыеКоманды



&НаКлиенте
Процедура СформироватьВыдачуТранзита(Команда)
	
	Фрм=ПолучитьФорму("Документ.ВыдачаТранзита.Форма.ФормаДокумента",,ЭтаФорма);
	обВыдачаТранзитаСформы=фрм.Объект;	
	СформироватьВыдачуТранзитаНаСервере(обВыдачаТранзитаСформы);
	КопироватьДанныеФормы(обВыдачаТранзитаСформы,фрм.объект);
	фрм.Открыть();
КонецПроцедуры




&НаСервере
Процедура СформироватьВыдачуТранзитаНаСервере(обВыдачаТранзитаСформы)
		обВыдачаТранзита		= ДанныеФормыВЗначение(обВыдачаТранзитаСформы,Тип("ДокументОбъект.ВыдачаТранзита"));
		обВыдачаТранзита.ЗаполнитьЗаказамиКурьерскойДоставки();
		ЗначениеВДанныеФормы(обВыдачаТранзита,обВыдачаТранзитаСформы);
КонецПроцедуры

&НаКлиенте
Процедура ОбновитьЗаказы(Команда)
	аСППрив.ЗагрузкаГруппДоставки();
	Элементы.Список.Обновить();
КонецПроцедуры
