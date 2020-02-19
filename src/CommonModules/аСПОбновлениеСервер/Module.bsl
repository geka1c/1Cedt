

Процедура ВыполнитьПроверкиНаСервере(отказ)  Экспорт
	КаталогСОбновлениями=Константы.КаталогСОбновлениями.Получить();
	КатологОбмена=Константы.КатологОбмена.Получить();
	отказ= не ЗначениеЗаполнено(КаталогСОбновлениями) или
				не ЗначениеЗаполнено(КатологОбмена);
	Если отказ Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не указан каталог обновлений или обмена.");
	КонецЕсли;
КонецПроцедуры	


Функция ПолучитьФайлыОбновления()	//Для РаботыСФТП
	//ИмяFTPСервера               = Адрес;//
	//ПортFTPСоединения           = "21";
	//ПользовательFTPСоединения   = Логин;//
	//ПарольFTPСоединения         =  Пароль;
	//ПассивноеFTPСоединение      =  Ложь;
	//Соединение = Новый FTPСоединение(ИмяFTPСервера, ПортFTPСоединения,ПользовательFTPСоединения,ПарольFTPСоединения, ,ПассивноеFTPСоединение);
	////Путь на сервере в формате /OOO_Birka/
	//Массив = Соединение.НайтиФайлы(СокрЛП(ПутьНаСервере), "*.cfu");
	//Для Работы локально
	КаталогСОбновлениями=Константы.КаталогСОбновлениями.Получить();
	КатологОбмена=Константы.КатологОбмена.Получить();
	
	СтрВерсий=Новый ТаблицаЗначений;
	СтрВерсий.Колонки.Добавить("Версия");
	СтрВерсий.Колонки.Добавить("Файл");
	масс=НайтиФайлы(КатологОбмена,"*.cfu",истина);
	Для каждого ф из масс Цикл
		прС=СтрНайти(ф.ПолноеИмя,"\",НаправлениеПоиска.СКонца,,2);	
		втС=СтрНайти(ф.ПолноеИмя,"\",НаправлениеПоиска.СКонца,,1);	
		новаяСтрока=СтрВерсий.Добавить();
		новаяСтрока.Версия=Сред(ф.ПолноеИмя,прС+1,втс-прС-1);
		новаяСтрока.Файл=ф;
	КонецЦикла;
	Возврат СтрВерсий;	
	
КонецФункции	


Функция ПолучитьФайлОбновления() Экспорт 
	КаталогСОбновлениями=Константы.КаталогСОбновлениями.Получить();
	КатологОбмена=Константы.КатологОбмена.Получить();
	
	массив=ПолучитьФайлыОбновления();
	ВесТекущей=ОбновлениеИнформационнойБазыСлужебный.ВесВерсии(Метаданные.Версия);
	ВерсияДляОбновления=Неопределено;
	Если Массив.Количество() <> 0 Тогда
		Для Каждого Стр Из Массив Цикл
			//Получаем релиз и сравниваем
			ВесФайла=ОбновлениеИнформационнойБазыСлужебный.ВесВерсии(Стр.Версия);
			Если ВесФайла>ВесТекущей Тогда
				ВесТекущей=ВесФайла;
				ВерсияДляОбновления=Стр;	
				
			КонецЕсли;	
		КонецЦикла;
		Если ЗначениеЗаполнено(ВерсияДляОбновления) Тогда
			ФайлНазначение=КаталогСОбновлениями+"\"+ВерсияДляОбновления.Версия+".cfu";
			КопироватьФайл(ВерсияДляОбновления.Файл.ПолноеИмя ,ФайлНазначение);
		КонецЕсли;	
	КонецЕсли;	        
	Возврат ФайлНазначение;
КонецФункции	




Функция СоздатьКомандныйФайл(ФайлОбновление) Экспорт 
	КаталогСОбновлениями=Константы.КаталогСОбновлениями.Получить();
	КатологОбмена=Константы.КатологОбмена.Получить();

	
    Если КаталогСОбновлениями = Null или КаталогСОбновлениями = "" Тогда
        Возврат неопределено;
	КонецЕсли;
	
    ПутьАрхива = КаталогСОбновлениями+"\Arhiv\";
	
	
    ПутьДля1СПредприятия = КаталогПрограммы()+"1cv8.exe"; 
    
    тек = Новый ТекстовыйДокумент;
	тек.ДобавитьСтроку("echo [Ожидаем завершения сеансов] ");
    тек.ДобавитьСтроку("timeout /t 300 ");
    
    ЗапускПред = """"+СокрЛП(ПутьДля1СПредприятия)+""" enterprise";
    ЗапускКонф = """"+СокрЛП(ПутьДля1СПредприятия)+""" DESIGNER";
    
    сс=СтрокаСоединенияИнформационнойБазы();
	началоСРВ=СтрНайти(сс,"""",,,1);
	КонецСРВ= СтрНайти(сс,"""",,,2);
	СРВ=Сред(сс,началоСРВ+1,КонецСРВ-НачалоСРВ-1);
	началоБаза=СтрНайти(сс,"""",,,3);
	КонецБаза= СтрНайти(сс,"""",,,4);
	База=Сред(сс,началоБаза+1,КонецБаза-НачалоБаза-1);
	СтрокаКонекта=СРВ+"/"+База;
    
    ПодклБаза = " /S """+СтрокаКонекта+"""" +" /N upd" + " /P 456258";
    
    РезервКоп = " /DumpIB """+СокрЛП(ПутьАрхива)+СтрЗаменить(Формат(ТекущаяДата(),"ДЛФ=Д"),".","_")+".dt"""+" /Out """+КаталогСОбновлениями+"\Arch_"+СтрЗаменить(Формат(ТекущаяДата(),"ДЛФ=Д"),".","_")+".log"" [-NoTruncate] /UC 123";
    
	//РезервКоп2 = " /DumpIB """+СокрЛП(ПутьАрхива);
	
	ОбновлКонф = " /UpdateCfg """+ФайлОбновление+""""+" /Out """+КаталогСОбновлениями+"\upd_"+СтрЗаменить(Формат(ТекущаяДата(),"ДЛФ=Д"),".","_")+".log"" [-NoTruncate] /UC 123";
	ОбновлКонфБД = " /UpdateDBCfg "+" /Out """+КаталогСОбновлениями+"/updDB_"+СтрЗаменить(Формат(ТекущаяДата(),"ДЛФ=Д"),".","_")+".log"" [-NoTruncate] /UC123";
//    ОбновлБазы = " /UpdateDBCfg";
    стр = ЗапускКонф+ПодклБаза+РезервКоп;
		Если стр<>"" тогда 
		тек.ДобавитьСтроку("echo [Архивирование]: НЕ ЗАКРЫВАЙТЕ ОКНО!!!");
		тек.ДобавитьСтроку(стр); стр=""; 
		
	конецесли;    //Архив
	
    Если ЗначениеЗаполнено(ФайлОбновление) Тогда
		стр = ЗапускКонф+ПодклБаза+ОбновлКонф;
		Если стр<>"" тогда 
			тек.ДобавитьСтроку("echo [Обновление]: НЕ ЗАКРЫВАЙТЕ ОКНО!!!");
			тек.ДобавитьСтроку(стр); 
			стр=""; 
		конецесли;
		стр = ЗапускКонф+ПодклБаза+ОбновлКонфБД;
		Если стр<>"" тогда 
			тек.ДобавитьСтроку("echo [Обновление БД]: НЕ ЗАКРЫВАЙТЕ ОКНО!!!");
			тек.ДобавитьСтроку(стр); 
			стр=""; 
		конецесли;	
	КонецЕсли;

	
	//стр = ЗапускКонф+ПодклБаза+РезервКоп2;
	//Если стр<>"" тогда тек.ДобавитьСтроку(стр); стр=""; конецесли;
	//тек.ДобавитьСтроку("del " + СокрЛП(КаталогСОбновлениями) + ФайлОбновление);
	стр = ЗапускПред+ПодклБаза+" /CРазрешитьРаботуПользователей /UC 123";
	Если стр<>"" тогда 
		тек.ДобавитьСтроку(стр); 
		тек.ДобавитьСтроку(ЗапускПред+ПодклБаза); 
		стр=""; 
	конецесли;
  //  тек.ДобавитьСтроку("del %0");
    тек.ДобавитьСтроку("echo Обновление завершено. Можете закрыть окно.");
	ИмяБАТ=ПолучитьИмяВременногоФайла("bat");
	Попытка
    	тек.Записать(ИмяБАТ,КодировкаТекста.OEM,);
	Исключение
	     а=1;
	КонецПопытки;
    
	Возврат ИмяБАТ;	    


КонецФункции



Процедура ЗавершитьСеансы() Экспорт
	стрСоединения=ПолучитьИмяБазыСервера();
	Если ЗначениеЗаполнено(стрСоединения) Тогда
		ИмяСервера = стрСоединения.ИмяСервера;
		ИмяБазы = стрСоединения.ИмяБазы;
	Иначе
		Возврат;
	КонецЕсли;
	
	Коннектор = Новый COMОбъект("v83.COMConnector");
	Агент = Коннектор.ConnectAgent(ИмяСервера);
	Кластеры = Агент.GetClusters();
	Для каждого Кластер из Кластеры Цикл
		АдминистраторКластера = "upd";
		ПарольКластера = "456258";
		//Агент.Authenticate(Кластер, АдминистраторКластера, ПарольКластера);
		Агент.Authenticate(Кластер, , );

		Процессы = Агент.GetWorkingProcesses(Кластер);
		Для каждого Процесс из Процессы Цикл
			Порт = Процесс.MainPort;
			// теперь есть адрес и порт для подключения к рабочему процессу
			РабПроц = Коннектор.ConnectWorkingProcess(ИмяСервера + ":" + СтрЗаменить(Порт, Символы.НПП, ""));
			РабПроц.AddAuthentication(АдминистраторКластера, ПарольКластера);
			
			ИнформационнаяБаза = "";
			
			Базы = РабПроц.GetInfoBases();
			Для каждого База из Базы Цикл
				Если База.Name = ИмяБазы Тогда
					ИнформационнаяБаза = База;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ИнформационнаяБаза = "" Тогда
				// база не найдена
			КонецЕсли;
			ИнформационнаяБаза.ScheduledJobsDenied = Истина;
			ИнформационнаяБаза.SessionsDenied	   = Истина;
			ИнформационнаяБаза.DeniedFrom          = Дата(1,1,1);
			ИнформационнаяБаза.DeniedTo            = Дата(1,1,1);
			ИнформационнаяБаза.DeniedMessage       ="Доступ к базе ограничен. Выполняется обновление!";
			ИнформационнаяБаза.PermissionCode      ="123";
			РабПроц.UpdateInfoBase(ИнформационнаяБаза);
			
			ИнформационнаяБазаОписание="";
			БазыОписания = Агент.GetInfoBases(Кластер);
			Для каждого БазаОписание из БазыОписания Цикл
				Если БазаОписание.Name = ИмяБазы Тогда
					ИнформационнаяБазаОписание = БазаОписание;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ИнформационнаяБазаОписание = "" Тогда
				// база не найдена
			КонецЕсли;
			
			
			
			///Отключаем сеансы
			
			НомерТекущегоСеанса=НомерСеансаИнформационнойБазы();
			Сеансы = Агент.GetInfoBaseSessions(Кластер, ИнформационнаяБазаОписание);
			Для каждого Сеанс из Сеансы Цикл
				//Если нРег(Сеанс.AppID) = "backgroundjob" ИЛИ нРег(Сеанс.AppID) = "designer" Тогда

				Если  нРег(Сеанс.AppID) = "designer" 
						ИЛИ нРег(Сеанс.AppID) = "srvrconsole"
						ИЛИ нРег(Сеанс.AppID) = "comconsole"
						или Сеанс.SessionID = НомерТекущегоСеанса 
					 Тогда
					// если это сеансы конфигуратора или фонового задания, то не отключаем
					Продолжить;
				КонецЕсли;
				//Если Сеанс.UserName = ИмяПользователя() Тогда
				//	// это текущий пользователь
				//	Продолжить;
				//КонецЕсли;
				Агент.TerminateSession(Кластер, Сеанс);
			КонецЦикла;	
			
			///Отключаем соединения
			НомерТекущегоСоединения=НомерСоединенияИнформационнойБазы();
			СоединенияБазы = РабПроц.GetInfoBaseConnections(ИнформационнаяБаза);
			//СоединенияБазы = РабПроц.GetInfoBaseConnections(Кластер,ИнформационнаяБаза);
			// Разорвать соединения клиентских приложений.
			Для Каждого Соединение Из СоединенияБазы Цикл
//				Если нРег(Соединение.Application) = "backgroundjob" ИЛИ нРег(Соединение.Application) = "designer" Тогда
				Если нРег(Соединение.AppID) = "designer" или Соединение.ConnID = НомерТекущегоСоединения
					 ИЛИ нРег(Соединение.AppID) = "srvrconsole"
					  ИЛИ нРег(Соединение.AppID) = "comconsole"
					 Тогда
				// если это соединение конфигуратора или фонового задания, то не отключаем
					Продолжить;
				КонецЕсли;
				//Если Соединение.UserName = ИмяПользователя() Тогда
				//	// это текущий пользователь
				//	Продолжить;
				//КонецЕсли;
				Попытка
					РабПроц.Disconnect(Соединение);
				Исключение
				КонецПопытки;
			КонецЦикла;
			

			
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры	


Функция ПолучитьИмяБазыСервера()
	Если Найти(СтрокаСоединенияИнформационнойБазы(), "Srvr") > 0 Тогда
		// серверный вариант
		Поиск1 = Найти(СтрокаСоединенияИнформационнойБазы(), "Srvr=");
		ПодстрокаПоиска = Сред(СтрокаСоединенияИнформационнойБазы(), Поиск1 + 6);
		ИмяСервера = Лев(ПодстрокаПоиска, Найти(ПодстрокаПоиска, """") - 1);
		// теперь ищем имя базы
		Поиск1 = Найти(СтрокаСоединенияИнформационнойБазы(), "Ref=");
		ПодстрокаПоиска = Сред(СтрокаСоединенияИнформационнойБазы(), Поиск1 + 5);
		ИмяБазы = Лев(ПодстрокаПоиска, Найти(ПодстрокаПоиска, """") - 1);
	Иначе
		// для других способов подключения алгоритм не актуален
		Возврат неопределено;
	КонецЕсли;
	
	Возврат новый Структура("ИмяСервера,ИмяБазы",ИмяСервера,ИмяБазы);
	
КонецФункции	


Процедура ВключитьРегламентныеЗаданияНаСервере() Экспорт
	ТребуетсяОбновление = ОбновлениеИнформационнойБазы.НеобходимоОбновлениеИнформационнойБазы();
	Если ТребуетсяОбновление Тогда Возврат; КонецЕсли;
	
	Если ПользователиКлиентСервер.ТекущийПользователь().Наименование<>"upd" Тогда  возврат; КонецЕсли;

	стрСоединения=ПолучитьИмяБазыСервера();
	Если ЗначениеЗаполнено(стрСоединения) Тогда
		ИмяСервера = стрСоединения.ИмяСервера;
		ИмяБазы = стрСоединения.ИмяБазы;
	Иначе
		Возврат;
	КонецЕсли;
	
	Коннектор = Новый COMОбъект("v83.COMConnector");
	Агент = Коннектор.ConnectAgent(ИмяСервера);
	Кластеры = Агент.GetClusters();
	Для каждого Кластер из Кластеры Цикл
		АдминистраторКластера = "upd";
		ПарольКластера = "456258";
		//Агент.Authenticate(Кластер, АдминистраторКластера, ПарольКластера);
		Агент.Authenticate(Кластер, , );

		Процессы = Агент.GetWorkingProcesses(Кластер);
		Для каждого Процесс из Процессы Цикл
			Порт = Процесс.MainPort;
			// теперь есть адрес и порт для подключения к рабочему процессу
			РабПроц = Коннектор.ConnectWorkingProcess(ИмяСервера + ":" + СтрЗаменить(Порт, Символы.НПП, ""));
			РабПроц.AddAuthentication(АдминистраторКластера, ПарольКластера);
			
			ИнформационнаяБаза = "";
			
			Базы = РабПроц.GetInfoBases();
			Для каждого База из Базы Цикл
				Если База.Name = ИмяБазы Тогда
					ИнформационнаяБаза = База;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			Если ИнформационнаяБаза = "" Тогда
				// база не найдена
			КонецЕсли;
			ИнформационнаяБаза.ScheduledJobsDenied = Ложь;
			//ИнформационнаяБаза.SessionsDenied	   = Истина;
			//ИнформационнаяБаза.DeniedFrom          = Дата(1,1,1);
			//ИнформационнаяБаза.DeniedTo            = Дата(1,1,1);
			//ИнформационнаяБаза.DeniedMessage       ="Доступ к базе ограничен. Выполняется обновление!";
			//ИнформационнаяБаза.PermissionCode      ="123";
			РабПроц.UpdateInfoBase(ИнформационнаяБаза);
		КонецЦикла;
	КонецЦикла;
	
КонецПроцедуры	

