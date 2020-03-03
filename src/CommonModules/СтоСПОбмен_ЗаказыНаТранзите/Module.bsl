
Функция Получить(ПунктВыдачи) Экспорт

	хмл_отправили	= ПолучитьХМЛ(ПунктВыдачи);
	хмл_получили 	= СтоСПОбмен_Общий.Загрузить(хмл_отправили);

	Возврат Разбор(хмл_получили);

КонецФункции	



Функция ПолучитьХМЛ(ПунктВыдачи) 
	Тип_transitOrdersCounts		= ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors.transitOrdersCounts");
	Тип_distributors			= ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors");
	
	Объект_transitOrdersCounts 	= ФабрикаXDTO.Создать(Тип_transitOrdersCounts);
	

	
	Объект_transitOrdersCounts.transitOrdersCount.Добавить(Число(ПунктВыдачи.Код));


	Объект_distributors						= ФабрикаXDTO.Создать(Тип_distributors);
	Объект_distributors.transitOrdersCounts	= Объект_transitOrdersCounts;
	
	Возврат СтоСПОбмен_Общий.ПолучитьСтрокуXML(Объект_distributors);
	
КонецФункции




Функция Разбор(ПолученныеДанные) 
	пространствоИмен		= "http://www.100sp.ru/api/distributor/upload/back";
	ПолученныеДанные		= СтрЗаменить(ПолученныеДанные,"http://www.100sp.ru",пространствоИмен);
	
	авторизацияВыполнена	= ложь;
	Если ПолученныеДанные 	= "Не удалось соеденится с сайтом" Тогда Возврат авторизацияВыполнена; КонецЕсли;
	
	Тип_distributors		= ФабрикаXDTO.Тип(пространствоИмен, "distributors");
	
	ЧтениеXML 				= Новый ЧтениеXML;
	ЧтениеXML.УстановитьСтроку(ПолученныеДанные);
 	Объект_distributors		= ФабрикаXDTO.ПрочитатьXML(ЧтениеXML,Тип_distributors);
	
	Если Объект_distributors.auth.result="ok" Тогда
		авторизацияВыполнена=истина;
	КонецЕсли;
	Если Объект_distributors.transitOrdersCounts=Неопределено Тогда
		Возврат авторизацияВыполнена;
	КонецЕсли;	
	

	
	Возврат	Число(Объект_distributors.transitOrdersCounts.transitOrdersCount[0].transitOrdersCount);
КонецФункции


