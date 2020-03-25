

Процедура СохранитьОтправитьФайлыОтчетов(ПериодОтчета) экспорт
	Дата			= КонецМесяца(ПериодОтчета);
	Если не ЗначениеЗаполнено(СвойПунктВыдачи) Тогда
		СвойПунктВыдачи = Константы.СвояТочка.Получить();
	КонецЕсли;
	ПВ 			= Формат(число(СвойПунктВыдачи.Код),"ЧЦ=4; ЧВН=; ЧГ=0;");
	имяОтчета 	= формат(Дата,"ДФ=yyyy_MM_;") + ПВ;
	
	
	СоздатОтчетБесплатнойВыдачи();
	СоздатьФайлБесплатнойВыдачи();

	каталогМесяц 	= Формат(Дата,"ДФ=yyyy_MM;")+"_xls";
	Если СоздатьКаталогНаЯД(каталогМесяц) Тогда
		ОтправленОтчет = ОтправитьНаЯД(каталогМесяц, ПутьОтчета);
	иначе	
		ОтправленОтчет = Ложь;
	КонецЕсли;
		
	каталогМесяц 	= Формат(Дата,"ДФ=yyyy_MM;");
	Если СоздатьКаталогНаЯД(каталогМесяц) Тогда
		ОтправленФайл = ОтправитьНаЯД(каталогМесяц, ПутьФайла);
	иначе	
		ОтправленФайл = Ложь;
	КонецЕсли;	
	Отправлено = (ОтправленОтчет и ОтправленФайл);	
	Если Отправлено Тогда
		ЗаписатьДатуЗапретаСОписанием(Дата);
	КонецЕсли	
	
КонецПроцедуры



Процедура ЗаписатьДатуЗапретаСОписанием(ДатаЗапрета)
	Запрос = новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ДатыЗапретаИзменения.ДатаЗапрета,
		|	ДатыЗапретаИзменения.ОписаниеДатыЗапрета
		|ИЗ
		|	РегистрСведений.ДатыЗапретаИзменения КАК ДатыЗапретаИзменения
		|ГДЕ
		|	ДатыЗапретаИзменения.Пользователь = Значение(Перечисление.ВидыНазначенияДатЗапрета.ДляВсехПользователей)
		|	И ДатыЗапретаИзменения.Раздел = ЗНАЧЕНИЕ(ПланВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка)
		|	И ДатыЗапретаИзменения.Объект = ЗНАЧЕНИЕ(ПланВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка)";
	Выборка = Запрос.Выполнить().Выбрать();
	ОбщаяДатаПрочитана = Выборка.Следующий();
	
	
	Если ОбщаяДатаПрочитана и Выборка.ДатаЗапрета >= НачалоДня(ДатаЗапрета) Тогда Возврат КонецЕсли; 
	
	ПустойРаздел 	= ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.ПустаяСсылка();
	МенеджерЗаписи 	= РегистрыСведений.ДатыЗапретаИзменения.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.Раздел              		= ПустойРаздел;
	МенеджерЗаписи.Объект              		= ПустойРаздел;
	МенеджерЗаписи.Пользователь        		= Перечисления.ВидыНазначенияДатЗапрета.ДляВсехПользователей;
	МенеджерЗаписи.ДатаЗапрета         		= ДатаЗапрета;
	//МенеджерЗаписи.ОписаниеДатыЗапрета 	= "КонецПрошлогоМесяца";
	МенеджерЗаписи.Комментарий 				= "Установлено отчетом по бесплатной выдаче";
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры


Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ПроведениеСервер.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства, РежимПроведения);
	Документы.ОтчетПоБесплатнойВыдаче.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	ДополнительныеСвойства.Вставить("ЭтоНовый",ЭтоНовый());
	ПроведениеСервер.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	СП_ДвиженияСервер.ОтразитьДвиженияПоРегистру("Обмен100СПрн_Ошибки", ДополнительныеСвойства, Движения, Отказ);
КонецПроцедуры
		




Функция СоздатьКаталогНаЯД(каталогМесяц)
	результат 		= Интеграция_Яндекс.СоздатьКаталогНаДиске("/FreeStorage/"+каталогМесяц);
	Возврат (Результат.КодСостояния = 200  Или Результат.КодСостояния = 201);
КонецФункции	


Функция ОтправитьНаЯД(каталогМесяц, ПутьКФайлу)
	ф = новый Файл(ПутьКФайлу);
	Если не ф.Существует() Тогда Возврат Ложь; КонецЕсли;
	
	АдресФайлаВоВременномХранилище = ПоместитьВоВременноеХранилище(Новый ДвоичныеДанные(ПутьКФайлу));	
	
	параметрыФайла 					= Новый Структура;
	параметрыФайла.Вставить("ПутьКФайлу", "/FreeStorage/" + каталогМесяц + "/" + ф.Имя);
	параметрыФайла.Вставить("ДвоичныеДанные", АдресФайлаВоВременномХранилище);
	Результат =  Интеграция_Яндекс.ВыгрузитьНаДиск(параметрыФайла);
	Возврат (Результат.КодСостояния = 200 Или Результат.КодСостояния = 201);
КонецФункции
	





Процедура СоздатОтчетБесплатнойВыдачи()
	КаталогХранения	= Справочники.ТомаХраненияФайлов.БесплатнаяВыдача.ПолныйПутьWindows;
	Расширение		= "xlsx";
	ИмяФайла 		= имяОтчета + "_" + СтрЗаменить(СвойПунктВыдачи.Наименование,"-" ,"_" ) ;
	ПолноеИмяФайла 	= КаталогХранения + ИмяФайла + "." +Расширение;
	
	ПутьОтчета 		= СП_Отчеты.ОтчетПоБесплатнойВыдачеXLSX(ПолноеИмяФайла, Дата);

КонецПроцедуры




Процедура СоздатьФайлБесплатнойВыдачи()
	КаталогХранения	= Справочники.ТомаХраненияФайлов.БесплатнаяВыдача.ПолныйПутьWindows;
	Расширение  	= "txt";
	ИмяФайла 		= ИмяОтчета;
	
	ПолноеИмяФайла	= КаталогХранения + имяФайла+"."+Расширение;
	файлТХТ 		= новый ТекстовыйДокумент();
	
	тз				= СП_Отчеты.ОтчетПоБесплатнойВыдаче(Дата);
	СуммаВозмещаемаяПунктуВыдачи = тз.Итог("Сумма");
	
	ПВ 			= Формат(число(СвойПунктВыдачи.Код),"ЧЦ=4; ЧВН=; ЧГ=0;");
	ТекстФайла = "s="+СуммаВозмещаемаяПунктуВыдачи+";pv="+ПВ;
	файлТХТ.УстановитьТекст(ТекстФайла);
	
	Попытка
		а =Новый файл(ПолноеИмяФайла);
		Если а.Существует() Тогда
			а.УстановитьТолькоЧтение(Ложь);
		КонецЕсли;
		файлТХТ.Записать(ПолноеИмяФайла);
		ПутьФайла = ПолноеИмяФайла;
	Исключение
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ОписаниеОшибки());
	КонецПопытки;
КонецПроцедуры


Процедура ПриЗаписи(Отказ)
	ПВ 			= Формат(число(СвойПунктВыдачи.Код),"ЧЦ=4; ЧВН=; ЧГ=0;");
	имяОтчета 	= формат(Дата,"ДФ=yyyy_MM_;") + ПВ
КонецПроцедуры
 



