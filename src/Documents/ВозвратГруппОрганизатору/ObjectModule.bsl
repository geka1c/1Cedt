Процедура ДобавитьГруппу(РазобралиШК,ДанныеЗаполнения) Экспорт
	строкаВозврата = Возвраты.Добавить();
	строкаВозврата.Группа			=	РазобралиШК.Коробка;
	строкаВозврата.Организатор		=	РазобралиШК.Организатор;
	строкаВозврата.ШК				=	РазобралиШК.Мегаордер;
	Для Каждого элем из ДанныеЗаполнения Цикл
		строкаВозврата[элем.Ключ]	=	элем.Значение;
	КонецЦикла;
КонецПроцедуры	

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	#Область ПравильноеПроведение
	ПроведениеСерверСП.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ВозвратГруппОрганизатору.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.Вставить("ЭтоНовый",ЭтоНовый());
	ПроведениеСерверСП.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
//	ПроведениеСерверСП.ОтразитьДвиженияПоТаблице(ДополнительныеСвойства, Движения, "Обмен100СПрн", Отказ);
	ПроведениеСерверСП.ОтразитьДвиженияПоТаблице(ДополнительныеСвойства, Движения, "Возвраты", Отказ);
	ПроведениеСерверСП.ОтразитьДвиженияПоТаблице(ДополнительныеСвойства, Движения, "Транзит", Отказ);
	ПроведениеСерверСП.ОтразитьДвиженияПоТаблице(ДополнительныеСвойства, Движения, "Расход", Отказ);

	#КонецОбласти
	
	Если ЗначениеЗаполнено(Основание) и ТипЗнч(Основание) = Тип("ДокументСсылка.ОтправлениеТранзита") Тогда
		объект_ГруппаДоставки = Основание.Коробка.ПолучитьОбъект();
		Для каждого элем из объект_ГруппаДоставки.Состав Цикл
			элем.Удалить = истина;
			элем.СообщениеУдаления = "Возврат группы организатору";
		КонецЦикла;	
		Попытка
			объект_ГруппаДоставки.Записать();
		Исключение
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось удалить заказы в группе: "+Основание.Коробка,,,,Отказ);
		КонецПопытки;
	Конецесли;
КонецПроцедуры
