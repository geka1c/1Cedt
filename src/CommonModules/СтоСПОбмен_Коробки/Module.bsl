
#Область ЗагрузкаКоробокПоКодам

Процедура Загрузить_КоробкиСПризнакомДогрузить() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	Коробки.Код КАК Код
		|ИЗ
		|	Справочник.Коробки КАК Коробки
		|ГДЕ
		|	НЕ Коробки.ПометкаУдаления
		|	И Коробки.Догрузить 
		|	И Коробки.ВидСтикера = Значение(Перечисление.ВидыСтикеров.ГС)";
	
	РезультатЗапроса = Запрос.Выполнить();
	
	СписокКодов=новый СписокЗначений;
	СписокКодов.ЗагрузитьЗначения(РезультатЗапроса.Выгрузить().ВыгрузитьКолонку("Код"));
	Если СписокКодов.Количество()>0 Тогда
		СтоСПОбмен_Коробки.Загрузить_КоробкиПоКодам(СписокКодов);
	Конецесли;
КонецПроцедуры

Процедура Загрузить_КоробкиПоКодам(ПараметрыКоробок) Экспорт
	Если ТипЗнч(ПараметрыКоробок) = Тип("СправочникСсылка.Коробки") Тогда
		СписокКодов	= новый СписокЗначений;
		СписокКодов.Добавить(ПараметрыКоробок.код);
	иначе
		СписокКодов	= ПараметрыКоробок;		
	КонецЕсли;	
	
	хмл_отправили	= ПолучитьХМЛ_КоробкиПоКодам(СписокКодов);
	хмл_получили 	= ПолученныеДанные_КоробкиПоКодам(хмл_отправили);
	
	ТЗ				= Новый ТаблицаЗначений;
	ТЗ.Колонки.Добавить("Ошибка");
	Если хмл_получили	= Неопределено Тогда 
		стр			= тз.Добавить();
		стр.Ошибка	= "Не удалось соединиться с сайтом";
	Иначе	
		Разбор_КоробкиПоКодам(ТЗ,хмл_получили);
	КонецЕсли;

КонецПроцедуры

Функция ПолучитьХМЛ_КоробкиПоКодам(СписокКодов)
	Тип_groups			=ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors.groups");
	Тип_distributors		=ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors");
	
	Объект_groups=ФабрикаXDTO.Создать(Тип_groups);
	Для каждого элем из СписокКодов Цикл
		кодКоробки = СтрЗаменить(элем.Значение,"гд_","");
		
		Попытка
			Объект_groups.group.Добавить(Число(кодКоробки));
		Исключение
		  	ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не корректный номер группы "+кодКоробки);
		КонецПопытки;
	КонецЦикла;
	
	Объект_distributors=ФабрикаXDTO.Создать(Тип_distributors);
	Объект_distributors.groups=Объект_groups;
	
	Запись = Новый ЗаписьXML;
	Запись.УстановитьСтроку(); 
	ФабрикаXDTO.ЗаписатьXML(Запись, Объект_distributors);
	ДанныеXML = Запись.Закрыть();
	ДанныеXML="<?xml version=""1.0"" encoding=""UTF-8""?> "+СтрЗаменить(ДанныеXML,"xmlns=""http://www.100sp.ru/out"" ","");
	Возврат ДанныеXML; 
КонецФункции

Функция ПолученныеДанные_КоробкиПоКодам(ДанныеXML) 
	Параметры    = новый Структура;
	Параметры.Вставить("token",Константы.Токен.Получить());
	Параметры.Вставить("xml", ДанныеXML);
	АдресСкрипта = Константы.АдресЗагрузкиССайта.Получить();

	ПолученныйФайл=СтоСПОбмен_Общий.ПолучитьПостЗапросом(Параметры,АдресСкрипта);
	Если ПолученныйФайл=Неопределено Тогда Возврат Неопределено КонецЕсли;

	ПолученныеДанные=СтоСПОбмен_Общий.ФайлВСтроку(ПолученныйФайл);
	Возврат ПолученныеДанные;
КонецФункции	

Функция Разбор_КоробкиПоКодам(ТЗЗаказов,ПолученныеДанные) 
	пространствоИмен		= "http://www.100sp.ru/api/distributor/upload/back";
	ПолученныеДанные		= СтрЗаменить(ПолученныеДанные,"http://www.100sp.ru",пространствоИмен);
	авторизацияВыполнена	= ложь;
	
	Тип_distributors		= ФабрикаXDTO.Тип(пространствоИмен, "distributors");
	
	ЧтениеXML 				= Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ПолученныеДанные);
	
	Объект_distributors		= ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,Тип_distributors);
	Если Объект_distributors.auth.result	= "ok" Тогда
		авторизацияВыполнена	= истина;
	КонецЕсли;
	Если Объект_distributors.groups			= Неопределено Тогда
		Возврат авторизацияВыполнена;
	КонецЕсли;	
	
	Для каждого коробка из Объект_distributors.groups.group Цикл
		Если коробка.result = "error" Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю("При загрузке коробки: "+коробка.code+" ошибка: " +коробка.message);
			Продолжить;
		КонецЕсли;	
		параметрыКоробки	= новый Структура;
		параметрыКоробки.Вставить("ДатаМодификации",	ТекущаяДата());
		параметрыКоробки.Вставить("ВидСтикера",			Перечисления.ВидыСтикеров.ГС);
		параметрыКоробки.Вставить("Состав",				коробка.orders.order);
		параметрыКоробки.Вставить("Догрузить",			Ложь);
		
		Коробка_Ссылка	= СП_РаботаСоСправочниками.ПолучитьКоробкуПо_Коду(коробка.code);	
		СП_РаботаСоСправочниками.ОбновитьКоробку(Коробка_Ссылка, параметрыКоробки); 
	КонецЦикла;
	Возврат авторизацияВыполнена;
КонецФункции

#КонецОбласти


#Область Вспомогательные

#КонецОбласти