
#Область ПрограммныйИнтерфейс


Процедура ОтразитьДвиженияПоРегистру(НазваниеРегистра, ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений["Таблица"+НазваниеРегистра];
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияРегистра = Движения[НазваниеРегистра];
	ДвиженияРегистра.Записывать = Истина;
	ДвиженияРегистра.Загрузить(ТаблицаДвижений);
	
КонецПроцедуры




// Процедура формирования движений по регистру "НеВыгруженноНаСайт ".
//
// Параметры:
//  ДополнительныеСвойства - Структура - Структура дополнительных свойств для проведения.
//  Движения - Структура - Структура наборов движений документа.
//  Отказ - Булево - Признак отказа от проведения документа.
//
Процедура ОтразитьНеВыгруженноНаСайт(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаНеВыгруженноНаСайт = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаНеВыгруженноНаСайт;
	
	Если Отказ ИЛИ ТаблицаНеВыгруженноНаСайт.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияНеВыгруженноНаСайт = Движения.НеВыгруженноНаСайт;
	ДвиженияНеВыгруженноНаСайт.Записывать = Истина;
	ДвиженияНеВыгруженноНаСайт.Загрузить(ТаблицаНеВыгруженноНаСайт);
	
КонецПроцедуры

Процедура ОтразитьТранзит(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаТранзит = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаТранзит;
	
	Если Отказ ИЛИ ТаблицаТранзит.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияТранзит = Движения.Транзит;
	ДвиженияТранзит.Записывать = Истина;
	ДвиженияТранзит.Загрузить(ТаблицаТранзит);
	
КонецПроцедуры




Процедура ОтразитьОстаткиТоваров(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаОстаткиТоваров = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаОстаткиТоваров;
	
	Если Отказ ИЛИ ТаблицаОстаткиТоваров.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияОстаткиТоваров = Движения.ОстаткиТоваров;
	ДвиженияОстаткиТоваров.Записывать = Истина;
	ДвиженияОстаткиТоваров.Загрузить(ТаблицаОстаткиТоваров);
	
КонецПроцедуры

Процедура ОтразитьУпакованныеЗаказы(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаУпакованныеЗаказы = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаУпакованныеЗаказы;
	
	Если Отказ ИЛИ ТаблицаУпакованныеЗаказы.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияУпакованныеЗаказы= Движения.УпакованныеЗаказы;
	ДвиженияУпакованныеЗаказы.Записывать = Истина;
	ДвиженияУпакованныеЗаказы.Загрузить(ТаблицаУпакованныеЗаказы);
	
КонецПроцедуры



Процедура ОтразитьЗаказыВПосылках(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаЗаказыВПосылках = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаЗаказыВПосылках;
	
	Если Отказ ИЛИ ТаблицаЗаказыВПосылках.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияЗаказыВПосылках = Движения.ЗаказыВПосылках;
	ДвиженияЗаказыВПосылках.Записывать = Истина;
	ДвиженияЗаказыВПосылках.Загрузить(ТаблицаЗаказыВПосылках);
	
КонецПроцедуры

Процедура ОтразитьПриход(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаПриход = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПриход;
	
	Если Отказ ИЛИ ТаблицаПриход.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияПриход = Движения.Приход;
	ДвиженияПриход.Записывать = Истина;
	ДвиженияПриход.Загрузить(ТаблицаПриход);
	
КонецПроцедуры

Процедура ОтразитьРасход(ДополнительныеСвойства, Движения, Отказ) Экспорт

	Таблица_Движений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРасход;
	
	Если Отказ ИЛИ Таблица_Движений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияПриход = Движения.Расход;
	ДвиженияПриход.Записывать = Истина;
	ДвиженияПриход.Загрузить(Таблица_Движений);
	
КонецПроцедуры


Процедура ОтразитьПродажи(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаПродажи = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПродажи;
	
	Если Отказ ИЛИ ТаблицаПродажи.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияПродажи = Движения.Продажи;
	ДвиженияПродажи.Записывать = Истина;
	ДвиженияПродажи.Загрузить(ТаблицаПродажи);
	
КонецПроцедуры

Процедура ОтразитьКПолучению(ДополнительныеСвойства, Движения, Отказ) Экспорт

	ТаблицаКПолучению = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаКПолучению;
	
	Если Отказ ИЛИ ТаблицаКПолучению.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияКПолучению = Движения.КПолучению;
	ДвиженияКПолучению.Записывать = Истина;
	ДвиженияКПолучению.Загрузить(ТаблицаКПолучению);
	
КонецПроцедуры


#КонецОбласти