
#Область КомандыФормы

&НаКлиенте
Процедура ПередатьКурьеру(Команда)
//	Если ТК Тогда
//		ОткрытьФорму("Обработка.ФормированиеЗаказовТК.Форма.Форма",,ЭтаФорма,Истина);
//	Иначе	
		ОткрытьФорму(	"Обработка.ВыдачаТранзита.Форма.НеПодтвержденныеПосылки",
						новый Структура("ИсточникВызова, ПунктВыдачи","ВыдачаТранзита",ПВНазначения),
						ЭтаФорма,Истина);		
//	КонецЕсли;
КонецПроцедуры


&НаКлиенте
Процедура УпаковатьЗаказы(Команда)
		ОткрытьФорму(	"Обработка.ВыдачаТранзита.Форма.НеПодтвержденныеПосылки",
						новый Структура("ИсточникВызова, ПунктВыдачи","УпаковатьЗаказы",ПВНазначения),
						ЭтаФорма,Истина);		
	
КонецПроцедуры


#КонецОбласти

//&НаСервере
//Процедура ЗаполнитьНаСервере(ТочкаРаздачи,ДанныеФормы);  
//	обДок=ДанныеФормыВЗначение(ДанныеФормы,Тип("ДокументОбъект."+ДанныеФормы.Ссылка.Метаданные().Имя));
//	обДок.ТочкаНазначения=ТочкаРаздачи;
//	Если обДок.Метаданные().Реквизиты.Найти("ТочкаТранзита")<>Неопределено Тогда
//		обДок.ТочкаТранзита=ТочкаРаздачи;
//	КонецЕсли;	
//	обДок.ЗаполнитьПоТочкеНазначения();
//	ЗначениеВДанныеФормы(обДок,ДанныеФормы);
//КонецПроцедуры

&НаКлиенте
Процедура ТочкаРаздачиПриИзменении(Элемент)
	ТочкаРаздачиПриИзмененииНаСервере();
КонецПроцедуры

&НаСервере
Процедура ТочкаРаздачиПриИзмененииНаСервере()
	ТК=ПВНазначения.ТранспортнаяКомпания;
КонецПроцедуры


&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="ВыдачаТранзита" Тогда
		ОткрытьФорму(	"Документ.ВыдачаТранзита.ФормаОбъекта",
						новый Структура("ТочкаНазначения",Параметр),ЭтаФорма,Истина);
					
	ИначеЕсли ИмяСобытия="УпаковатьЗаказы" Тогда
		ОткрытьФорму(	"Документ.УпаковатьЗаказы.ФормаОбъекта",
						новый Структура("ТочкаНазначения",Параметр),ЭтаФорма,Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Статусы(Команда)
		ОткрытьФорму(	"Обработка.ВыдачаТранзита.Форма.СостоянияЗаказовПоПунктамВыдачи",
						,ЭтаФорма,Истина,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);

КонецПроцедуры



