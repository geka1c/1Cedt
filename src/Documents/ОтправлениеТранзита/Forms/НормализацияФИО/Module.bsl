
&НаКлиенте
Процедура ОК(Команда)
	ОповеститьОВыборе(новый Структура("Фамилия, Имя, Отчество",Фамилия, Имя, Отчество));	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ФИО=Параметры.ФИО;
	стрФИО=ФизическиеЛицаКлиентСервер.ЧастиИмени(Параметры.ФИО);
    Фамилия		= стрФИО.Фамилия;
	Имя			= стрФИО.Имя;
	Отчество	= стрФИО.Отчество;
КонецПроцедуры
