#Область ПрограммнфйИнтерфейс
//Используется в регламентном задании "Загрузка с сайта"
//аналогичная процедура в Обработке ЗагрузкаССайта ЗагрузкаNew(Команда)
Процедура ВыполнитьЗагрузкуССайта()  Экспорт
	
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	
	АнтейТранзит = Справочники.ТочкиРаздачи.НайтиПоКоду("0039");
	Если Константы.СвояТочка.Получить() <> АнтейТранзит Тогда
		ЗаказовНаТранзите = СтоСПОбмен_ЗаказыНаТранзите.Получить(АнтейТранзит);
		константы.ЗаказовНаТранзите.Установить("На транзите " + Строка(ЗаказовНаТранзите) + " шт , на "+ ТекущаяДата());
		//СП_ПокупкиВПути.ЗагрузитьВыехавшиеТранзиты();
		СтоСПОбмен_ПокупкиВПути.Получить()
	КонецЕсли;
	
	аспПроцедурыОбменаДанными.ПолучитьССайта();
	
	#Область СупперГруппыПоДате
	ПоследняяЗагрузкаСупергрупп	= Константы.ПоследняяЗагрузкаСупергрупп.Получить();
	стрОтвета 					= СтоСПОбмен_СупперГруппы.Загрузить_СуперГруппыПоДате(ПоследняяЗагрузкаСупергрупп);
	#КонецОбласти 
	
	аспПроцедурыОбменаДанными.ДогрузитьСправочникиССайта();

КонецПроцедуры	



#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Процедура  ЗапуститьВосстановлениеТранзита() Экспорт
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();

	ЗаписьЖурналаРегистрации("Восстановление транзита",,,,"Запуск !!!",);
	//ПараметрыСеанса.глОбработкаПерепроведения_ВосстановлениеСерий = Ложь;
	НачПериодаТранзит =НачалоДня(Последовательности.Транзит.ПолучитьГраницу().Дата-60*60*24);
	КонПериода=НачалоДня(ТекущаяДата())-1;
	Пока НачПериодаТранзит<=КонПериода Цикл
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	Приходная.Ссылка
		|ИЗ
		|	Документ.Приходная КАК Приходная
		|ГДЕ
		|	Приходная.Проведен
		|	И Приходная.Дата МЕЖДУ &НачалоДня И &КонецДня
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	РазборКоробки.Ссылка
		|ИЗ
		|	Документ.РазборКоробки КАК РазборКоробки
		|ГДЕ
		|	РазборКоробки.Дата МЕЖДУ &НачалоДня И &КонецДня
		|	И РазборКоробки.Проведен";
		
		Запрос.Параметры.Вставить("НачалоДня",НачалоДня(НачПериодаТранзит));
		Запрос.Параметры.Вставить("КонецДня",КонецДня(НачПериодаТранзит));
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий()  Цикл
			об = ВыборкаДетальныеЗаписи.Ссылка.ПолучитьОбъект();
			Попытка
				об.Записать(РежимЗаписиДокумента.Проведение);
			Исключение
				ЗаписьЖурналаРегистрации("Восстановление транзита",,,,"Ошибка !!!"+ОписаниеОшибки(),);
			КонецПопытки;
		КонецЦикла;
			
		НачПериодаТранзит=НачПериодаТранзит+24*60*60;
		Последовательности.Транзит.УстановитьГраницу(КонецДня(НачПериодаТранзит),);
		ЗаписьЖурналаРегистрации("Восстановление транзита",,,,"подвинулись на "+КонецДня(НачПериодаТранзит),);
	КонецЦикла;
КонецПроцедуры







Процедура ВыполнитьВыгрузкунаСайт() Экспорт
	ОбщегоНазначения.ПриНачалеВыполненияРегламентногоЗадания();
	аспПроцедурыОбменаДанными.СформироватИОтправитьПакет();
	СтоСПФоновые.Запустить_Выгрузку_100СП();
	СтоСПОбмен_Посылки.ВыгрузитьНеВыгруженныеПосылки();
КонецПроцедуры	


Процедура ВыполнитьПроверкуВремени()    Экспорт
	//
	//времяСайта=аспПроцедурыОбменаДанными.ПолучитьТекущееВремя();	
	//времяКлиента=ТекущаяДата();
	//погрешностьМин=30;
	//Если ЗначениеЗаполнено(времяСайта) Тогда
	//	нижнГраница= времяСайта-погрешностьМин*60;
	//	верхГраница= времяСайта+погрешностьМин*60;
	//	Если времяКлиента<нижнГраница или времяКлиента>верхГраница Тогда
	//		Константы.ВремяНеСоответствует.Установить(истина);
	//	Иначе
	//		Константы.ВремяНеСоответствует.Установить(ложь);
	//	КонецЕсли;
	//КонецЕсли;
КонецПроцедуры

Процедура ПодпискаНаСобытие1ПередЗаписью(Источник, Отказ, РежимЗаписи, РежимПроведения) Экспорт
	//Если источник
	
КонецПроцедуры

Процедура ЭкспортОценкиПроизводительности() Экспорт
	// Вставить содержимое обработчика.
КонецПроцедуры


//РегламентноеЗадание
Процедура ЗагрузкаГруппДоставки(ДатаЗагрузки=неопределено) Экспорт
	
	массГрупп	= СтоСПОбмен_ГруппыДоставки.Получить_ПоДате(ДатаЗагрузки);
	Константы.ПоследняяЗагрузкаГруппОбъединеннойДоставки.Установить(НачалоДня(ТекущаяДата()));
	СтоСПОбмен_ГруппыДоставки.ПолучитьГруппыДоставкиСпризнаком_Догрузить();
	СтоСПОбмен_ГруппыДоставки.ВыгрузитьИзмененияНаСайт();
	
	СтоСП_ГруппыДоставки.РасчитатьОстаткиПоГруппамДоставки();	
    Если массГрупп.Количество()>0  Тогда
		ПараметрыСеанса.ЗапуститьУчетГруппДоставки=Истина;	
	КонецЕСли;	
КонецПроцедуры	

#КонецОбласти
