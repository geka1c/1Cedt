

&НаСервере
Процедура РаспределитьПоВесуНаСервере()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.СчетКонтрагента"));	
	массИтог= аСПНаСервере.РаспределитьПропорционально(Объект.Сумма,ДокОбъект.Организаторы.ВыгрузитьКолонку("Вес"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"Сумма");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);

КонецПроцедуры

&НаКлиенте
Процедура РаспределитьПоВесу(Команда)
	РаспределитьПоВесуНаСервере();
	элементы.гпСтраницы.ТекущаяСтраница=Элементы.гпСтраницы.ПодчиненныеЭлементы.ГруппаСтоимостьПоОрганизаторам;
КонецПроцедуры

&НаСервере
Процедура РаспределитьПоОбъемуНаСервере()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.СчетКонтрагента"));	
	массИтог= аСПНаСервере.РаспределитьПропорционально(Объект.Сумма,ДокОбъект.Организаторы.ВыгрузитьКолонку("Объем"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"Сумма");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры

&НаКлиенте
Процедура РаспределитьПоОбъему(Команда)
	РаспределитьПоОбъемуНаСервере();
	элементы.гпСтраницы.ТекущаяСтраница=Элементы.гпСтраницы.ПодчиненныеЭлементы.ГруппаСтоимостьПоОрганизаторам;
КонецПроцедуры

&НаСервере
Процедура РаспределитьПоКоличествуНаСервере()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.СчетКонтрагента"));	
	массИтог= аСПНаСервере.РаспределитьПропорционально(Объект.Сумма,ДокОбъект.Организаторы.ВыгрузитьКолонку("Количество"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"Сумма");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры


&НаКлиенте
Процедура РаспределитьПоКоличеству(Команда)
	РаспределитьПоКоличествуНаСервере();
	элементы.гпСтраницы.ТекущаяСтраница=Элементы.гпСтраницы.ПодчиненныеЭлементы.ГруппаСтоимостьПоОрганизаторам;
КонецПроцедуры


Процедура УстановитьВидимость()
	сТК=(Объект.ВидОперации=перечисления.ВидыОперацийСчетКонтрагента.СТранспортнойКомпанией);
	элементы.ГруппаСтоимостьПоОрганизаторам.Видимость=сТК;
	элементы.РаспределитьПоОбъему.Видимость=сТК;
	элементы.РаспределитьПоВесу.Видимость=сТК;
	элементы.РаспределитьПоКоличеству.Видимость=сТК;
	элементы.ОриентировачнаяДатаДоставки.Видимость=сТК;
	элементы.ГруппаВесОбъем.Видимость=сТК;
	//Элементы.ТранзитнаяТочка.Видимость= не сТК;	
	
КонецПроцедуры	

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
		Если не ЗначениеЗаполнено(Объект.ТранзитнаяТочка) Тогда
		Объект.ТранзитнаяТочка = СП_РаботаСоСправочниками.ПолучитьПунктВыдачиПо_Коду("0039");
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ВидОперацииПриИзменении(Элемент)
	УстановитьВидимость();
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьВесаНаСервере()
	докОбъект=ДанныеФормыВЗначение(Объект,Тип("ДокументОбъект.СчетКонтрагента"));
	докОбъект.ЗаполнитьВесОбъемПоГрузу();
	ЗначениеВДанныеФормы(докОбъект,Объект);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьВеса(Команда)
	ЗаполнитьВесаНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ВесПриИзменении(Элемент)
	ВесПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ВесПриИзмененииНаСервере()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.СчетКонтрагента"));	
	ДокОбъект.УстановитьПроценты();
	массИтог= аСПНаСервере.РаспределитьПропорционально(ДокОбъект.Вес,ДокОбъект.Организаторы.ВыгрузитьКолонку("ВесПроцент"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"Вес");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОбъемПриИзменении(Элемент)
	ОбъемПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОбъемПриИзмененииНаСервере()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.СчетКонтрагента"));
	ДокОбъект.УстановитьПроценты();
	массИтог= аСПНаСервере.РаспределитьПропорционально(ДокОбъект.Объем,ДокОбъект.Организаторы.ВыгрузитьКолонку("ОбъемПроцент"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"Объем");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизаторыВесПриИзменении(Элемент)
	ОрганизаторыВесПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизаторыВесПриИзмененииНаСервере()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.СчетКонтрагента"));	
	ДокОбъект.Вес=Объект.Организаторы.Итог("Вес");
	массИтог= аСПНаСервере.РаспределитьПропорционально(100,ДокОбъект.Организаторы.ВыгрузитьКолонку("Вес"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"ВесПроцент");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизаторыОбъемПриИзменении(Элемент)
	ОрганизаторыОбъемПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизаторыОбъемПриИзмененииНаСервере()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.СчетКонтрагента"));	
	ДокОбъект.Объем=Объект.Организаторы.Итог("Объем");
	массИтог= аСПНаСервере.РаспределитьПропорционально(100,ДокОбъект.Организаторы.ВыгрузитьКолонку("Объем"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"ОбъемПроцент");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизаторыВесПроцентПриИзменении(Элемент)
	ОрганизаторыВесПроцентПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизаторыВесПроцентПриИзмененииНаСервере()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.СчетКонтрагента"));	
	массИтог= аСПНаСервере.РаспределитьПропорционально(Объект.Вес,ДокОбъект.Организаторы.ВыгрузитьКолонку("ВесПроцент"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"Вес");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры

&НаКлиенте
Процедура ОрганизаторыОбъемПроцентПриИзменении(Элемент)
	ОрганизаторыОбъемПроцентПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ОрганизаторыОбъемПроцентПриИзмененииНаСервере()
	ДокОбъект=ДанныеФормыВЗначение(объект,Тип("ДокументОбъект.СчетКонтрагента"));	
	массИтог= аСПНаСервере.РаспределитьПропорционально(Объект.Объем,ДокОбъект.Организаторы.ВыгрузитьКолонку("ОбъемПроцент"));
	Если   массИтог=неопределено Тогда Возврат; КонецЕсли;
	ДокОбъект.Организаторы.ЗагрузитьКолонку(массИтог,"Объем");
	ЗначениеВДанныеФормы(ДокОбъект,Объект);
КонецПроцедуры


&НаСервереБезКонтекста
Процедура ПередЗаписьюНаСервере(Заказы)
	//массивГрузов=Заказы.Выгрузить().ВыгрузитьКолонку("Груз");
	
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаявкиВТКПриАктивизацииСтроки(Элемент)
	ОтобратьПоЗаявке();
КонецПроцедуры

&НаКлиенте
Процедура ОтобратьПоЗаявке()
	Если ОтбиратьПоЗаявкам Тогда
		Элементы.Заказы.ОтборСтрок=Новый ФиксированнаяСтруктура("Заявка",Элементы.ЗаявкиВТК.ТекущиеДанные.Заявка);
	Иначе
		Элементы.Заказы.ОтборСтрок=неопределено;
	КонецЕсли;	
КонецПроцедуры	

&НаКлиенте
Процедура ОтбиратьПоЗаявкамПриИзменении(Элемент)
	ОтобратьПоЗаявке();
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии()
	Оповестить("ОбновитьВсеЗаявки");
КонецПроцедуры







