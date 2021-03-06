
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	#Область ПравильноеПроведение
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ПередачаВозвратовОрганизатору.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.Вставить("ЭтоНовый",ЭтоНовый());
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
//	СтоСПОбмен_Общий.ОтразитьСтоСПОбмен(ДополнительныеСвойства, Движения, Отказ);
	
	СтоСПОбмен_Общий.ОтразитьСтоСПОбмен_РН(ДополнительныеСвойства, Движения, Отказ);
	ПроведениеСерверСП.ОтразитьДвиженияПоТаблице(ДополнительныеСвойства, Движения, "Возвраты", Отказ);
	ПроведениеСерверСП.ОтразитьДвиженияПоТаблице(ДополнительныеСвойства, Движения, "Расход", Отказ);

	#КонецОбласти
	
	
	//Движения.Возвраты.Записывать = Истина;
	//Для Каждого ТекСтрокаПокупки Из Покупки Цикл
	//	Движение = Движения.Возвраты.Добавить();
	//	Движение.ВидДвижения = ВидДвиженияНакопления.Расход;
	//	Движение.Период = Дата;
	//	Движение.Организатор = Организатор;
	//	Движение.Участник = ТекСтрокаПокупки.Участник;
	//	Движение.МестоХранения=ТекСтрокаПокупки.МестоХранения;
	//	Движение.Покупка = ТекСтрокаПокупки.Покупка;
	//	Движение.Количество = ТекСтрокаПокупки.Количество;
	//	Движение.Партия=ТекСтрокаПокупки.Партия;
	//КонецЦикла;

КонецПроцедуры

Процедура заполнитьОстатками() экспорт
	Если Проведен Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Нельзя заполнить проведенный документ!!!");	
		Возврат;
	Иначе	
	Покупки.Очистить();
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	ВозвратыОстатки.Организатор КАК Организатор,
		|	ВозвратыОстатки.Участник КАК Участник,
		|	ВозвратыОстатки.Покупка КАК Покупка,
		|	ВозвратыОстатки.КоличествоОстаток КАК КоличествоОстаток,
		|	ВозвратыОстатки.МестоХранения КАК МестоХранения,
		|	ВозвратыОстатки.Партия КАК Партия,
		|	ВозвратыОстатки.СуммаОстаток КАК Сумма
		|ПОМЕСТИТЬ пред
		|ИЗ
		|	РегистрНакопления.Возвраты.Остатки(, Организатор = &Организатор) КАК ВозвратыОстатки
		|ГДЕ
		|	ВозвратыОстатки.КоличествоОстаток > 0
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ
		|	пред.Организатор КАК Организатор,
		|	пред.Участник КАК Участник,
		|	пред.Покупка КАК Покупка,
		|	пред.КоличествоОстаток КАК Количество,
		|	пред.МестоХранения КАК МестоХранения,
		|	пред.Партия КАК Партия,
		|	ВЫРАЗИТЬ(МАКСИМУМ(Мегаордера.Ссылка) КАК Справочник.Мегаордера) КАК ШК,
		|	пред.Сумма КАК Сумма
		|ИЗ
		|	пред КАК пред
		|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.Мегаордера КАК Мегаордера
		|		ПО пред.Покупка = Мегаордера.Покупка
		|			И (ВЫБОР
		|				КОГДА ТИПЗНАЧЕНИЯ(пред.Покупка) = ТИП(Справочник.Коробки)
		|					ТОГДА ИСТИНА
		|				ИНАЧЕ пред.Участник = Мегаордера.Участник
		|			КОНЕЦ)
		|
		|СГРУППИРОВАТЬ ПО
		|	пред.Покупка,
		|	пред.Участник,
		|	пред.МестоХранения,
		|	пред.Организатор,
		|	пред.Партия,
		|	пред.КоличествоОстаток,
		|	пред.Сумма";

	Запрос.УстановитьПараметр("СуммаЗаВозвратОрганизатору", Константы.СтоимостьВозвратаТКДляОрганизатора.Получить());
	Запрос.УстановитьПараметр("Организатор", Организатор);

	Результат = Запрос.Выполнить();

	ВыборкаДетальныеЗаписи = Результат.Выбрать();

	Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
	
		СтрПокупки=Покупки.Добавить();
		ЗаполнитьЗначенияСвойств(СтрПокупки,ВыборкаДетальныеЗаписи);
	
		Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.ШК) Тогда Продолжить; КонецЕсли;
		
		СтрПокупки.ШК	= СП_Штрихкоды.ПолучитьМегаордер(ВыборкаДетальныеЗаписи.Покупка,ВыборкаДетальныеЗаписи.Участник);
	КонецЦикла;

	КонецЕсли;
	

КонецПроцедуры 
