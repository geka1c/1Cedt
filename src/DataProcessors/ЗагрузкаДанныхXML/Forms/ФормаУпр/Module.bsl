
//Загрузка
&НаКлиенте
Процедура КомандаИмпорт(Команда)
	
	Если ПустаяСтрока(Объект.ИмяФайлаВыгрузки) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Укажите файл!'");
		Сообщение.Поле = "ИмяФайлаВыгрузки";
		Сообщение.КлючДанных = "ИмяФайлаВыгрузки";
		Сообщение.УстановитьДанные(Объект);
		Сообщение.Сообщить();		
		
		Возврат;
	КонецЕсли;
	
	Состояние("Импорт данных:", 1, ""+ТекущаяДата()+": Начали импорт...", БиблиотекаКартинок.ПрочитатьИзменения);
	
	СерверИмпорт();
	
	Сообщение=Новый СообщениеПользователю;
	Сообщение.Текст=Объект.ТекстСообщенияПользователю;
	Сообщение.Сообщить();
	
	Состояние("Импорт данных:", 100, ""+ТекущаяДата()+": Импорт завершен.", БиблиотекаКартинок.ПрочитатьИзменения);
	//Состояние("Импорт данных", 100, Объект.ТекстСообщенияПользователю, БиблиотекаКартинок.ПрочитатьИзменения);
КонецПроцедуры//КомандаИмпорт(Команда)

&НаСервере
Процедура СерверИмпорт()
	//Обработка = ДанныеФормыВЗначение(Объект, Тип("ВнешняяОбработкаОбъект.ВыгрузкаЗагрузкаДанныхXML")); ругань
	Обработка = РеквизитФормыВЗначение("Объект");
	//ТекстСообщенияПользователю = РеквизитФормыВЗначение("Объект").ТекстСообщенияПользователю;
	
	Обработка.ПриЗагрузкеИспользоватьРежимОбменаДанными=Истина;
	Обработка.ПродолжитьЗагрузкуВСлучаеВозникновенияОшибки=Истина;
	Обработка.ИспользоватьИтоги=Ложь;
	
	Обработка.ВыполнитьЗагрузку(СокрЛП(Объект.ИмяФайлаВыгрузки));
	
	//ЗначениеВРеквизитФормы(Обработка.ТекстСообщенияПользователю, "Объект.ТекстСообщенияПользователю"); 
	Объект.ТекстСообщенияПользователю=Обработка.ТекстСообщенияПользователю;
КонецПроцедуры//СерверИмпорт()




//Выгрузка
&НаКлиенте
Процедура КомандаЭкспорт(Команда)
	
	Если ПустаяСтрока(Объект.ИмяФайлаВыгрузки) Тогда
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = НСтр("ru = 'Укажите файл!'");
		Сообщение.Поле = "ИмяФайлаВыгрузки";
		Сообщение.КлючДанных = "ИмяФайлаВыгрузки";
		Сообщение.УстановитьДанные(Объект);
		Сообщение.Сообщить();		
		
		Возврат;
	КонецЕсли;
	
	СерверЭкспорт();
КонецПроцедуры

&НаСервере
Процедура СерверЭкспорт()
	//Обработка = ДанныеФормыВЗначение(Объект, Тип("ВнешняяОбработкаОбъект.ВыгрузкаЗагрузкаДанныхXML")); ругань
	Обработка = РеквизитФормыВЗначение("Объект");
	
	Обработка.ВыполнитьВыгрузку(СокрЛП(Объект.ИмяФайлаВыгрузки));
КонецПроцедуры//СерверЭкспорт()



&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ПриОткрытииСервер(Отказ);
КонецПроцедуры

&НаСервере
Процедура ПриОткрытииСервер(Отказ)
	Обработка = РеквизитФормыВЗначение("Объект");
	
	Обработка.Инициализация();
	
	Обработка.ПриЗагрузкеИспользоватьРежимОбменаДанными=Истина;
	Обработка.ПродолжитьЗагрузкуВСлучаеВозникновенияОшибки=Истина;
	Обработка.ИспользоватьИтоги=Ложь;
	Объект.ПриЗагрузкеИспользоватьРежимОбменаДанными=Обработка.ПриЗагрузкеИспользоватьРежимОбменаДанными;
	Объект.ПродолжитьЗагрузкуВСлучаеВозникновенияОшибки=Обработка.ПродолжитьЗагрузкуВСлучаеВозникновенияОшибки;
	Объект.ИспользоватьИтоги=Обработка.ИспользоватьИтоги;
	
	////Обработка.ИнициализацияУпр();
	////ЗначениеВРеквизитФормы(Обработка.ДеревоМетаданных, "ДеревоМетаданных") 
КонецПроцедуры



&НаКлиенте
Процедура ИмяФайлаВыгрузкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ИмяФайлаВыгрузки = "";
	
	Режим = РежимДиалогаВыбораФайла.Открытие;
	ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(Режим);
	ДиалогОткрытияФайла.ПолноеИмяФайла = "";
	Фильтр = НСтр("ru = 'Файлы обмена данными (*.xml)|*.xml'");
	ДиалогОткрытияФайла.Фильтр = Фильтр;
	ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
	ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите файл с данными'");
	#Если ВебКлиент Тогда
		//для веб-клиента - пробуем выбрать файл, если исключение - устанавливаем расширение для работы с файлами и пробуем еще раз
		Попытка РезультатОткрытия = ДиалогОткрытияФайла.Выбрать();
		Исключение
			УстановитьРасширениеРаботыСФайлами(); 
			Попытка РезультатОткрытия = ДиалогОткрытияФайла.Выбрать();
			Исключение РезультатОткрытия = Ложь;
			КонецПопытки;
		КонецПопытки;
	#Иначе 
		//для тонкого клиента - просто выбираем файл
		РезультатОткрытия = ДиалогОткрытияФайла.Выбрать();
	#КонецЕсли
	Если РезультатОткрытия Тогда
		Объект.ИмяФайлаВыгрузки = ДиалогОткрытияФайла.ПолноеИмяФайла;
	КонецЕсли;
КонецПроцедуры//ИмяФайлаВыгрузкиНачалоВыбора
