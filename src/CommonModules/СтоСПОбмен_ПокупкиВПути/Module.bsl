Функция Получить(ПериодНачала) Экспорт

	ПериодыОтправления = ПолучитьПериодыОтправления(ПериодНачала);
	хмл_отправили	= ПолучитьХМЛ(ПериодыОтправления);
	хмл_получили 	= СтоСПОбмен_Общий.Загрузить(хмл_отправили);

	Возврат Разбор(хмл_получили);

КонецФункции	

Функция ПолучитьПериодыОтправления(ПериодНачала)
	текушийПериод = НачалоДня(ПериодНачала);
	периодыОтправления = новый СписокЗначений;
	Пока текушийПериод <= НачалоДня(ТекущаяДата()) Цикл
		периодыОтправления.Добавить(Формат(текушийПериод,"ДФ=dd.MM.yyyy;"));
		текушийПериод = текушийПериод + 60*60*24;
	КонецЦикла;
	Возврат периодыОтправления;	
КонецФункции	

Функция ПолучитьХМЛ(ПериодыОтправления) 
	Тип_transfers				= ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors.transfers");
	Тип_distributors			= ФабрикаXDTO.Тип("http://www.100sp.ru/out","distributors");
	
	Объект_transfers			 	= ФабрикаXDTO.Создать(Тип_transfers);
	


	Для каждого элем из ПериодыОтправления Цикл	
		Объект_transfers.transfer.Добавить(элем.Значение);
	КонецЦикла;

	Объект_distributors						= ФабрикаXDTO.Создать(Тип_distributors);
	Объект_distributors.transfers			= Объект_transfers;
	
	Возврат СтоСПОбмен_Общий.ПолучитьСтрокуXML(Объект_distributors);
КонецФункции

Функция Разбор(ПолученныеДанные) 
	пространствоИмен		= "http://www.100sp.ru/api/distributor/upload/back/transfer";
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
//	Если Объект_distributors.transitOrdersCounts=Неопределено Тогда
//		Возврат авторизацияВыполнена;
//	КонецЕсли;	
//	
//
//	
//	Возврат	Число(Объект_distributors.transitOrdersCounts.transitOrdersCount[0].transitOrdersCount);
КонецФункции