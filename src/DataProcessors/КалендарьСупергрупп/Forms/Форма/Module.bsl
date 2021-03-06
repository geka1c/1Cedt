
#Область КнопкиФормы

&НаКлиенте
Процедура ОбновитьКалендарьизКП(Команда)
	ЗагрузкаСуперГруппНаСервере();
	ОбновитьКалендарьНаСервере()
КонецПроцедуры

&НаКлиенте
Процедура СледующийМесяц(Команда)
	ДатаНачалаМесяцаЗапроса=НачалоМесяца(ДобавитьМесяц(ДатаНачалаМесяцаЗапроса,1));
	ОбновитьКалендарьНаСервере();
КонецПроцедуры

&НаКлиенте
Процедура ПредыдущийМесяц(Команда)
	ДатаНачалаМесяцаЗапроса=НачалоМесяца(ДобавитьМесяц(ДатаНачалаМесяцаЗапроса,-1));
	ОбновитьКалендарьНаСервере();
КонецПроцедуры
#КонецОбласти

#Область СобытияФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	ДатаНачалаМесяцаЗапроса=НачалоМесяца(ТекущаяДата());
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОбновитьКалендарьНаСервере();
	РазмерШрифта=10;
КонецПроцедуры

#КонецОбласти



#Область Календарь

Процедура 	ОбновитьКалендарьНаСервере()
	//ТекущийСписок=ПолучитьТекущийСписок(Элементы);
	//Если ТекущийСписок<>Неопределено Тогда Возврат КонецЕсли;
	//стрНастройки=ХранилищеОбщихНастроек.Загрузить(ИмяФормы,,,ПараметрыСеанса.ТекущийПользователь.Наименование);
	//Если ТипЗнч(стрНастройки)=тип("Структура") Тогда
	//	ЗаполнитьЗначенияСвойств(ЭтаФорма,стрНастройки);
	//КонецЕсли;	
	
	тзОбластиДня=Новый ТаблицаЗначений;
	тзОбластиДня.Колонки.Добавить("ИмяОбласти");
	тзОбластиДня.Колонки.Добавить("Область");
	//если кОтПоставщика 	 Тогда  стр=тзОбластиДня.Добавить();стр.ИмяОбласти="От поставщика";	Конецесли;
	//если кНаСкладе 	 	 Тогда  стр=тзОбластиДня.Добавить();стр.ИмяОбласти=Строка(Перечисления.СтатусыОтправкиГруза.НаСкладе);				Конецесли;
	//если кЗаявкаТК		 Тогда стр=тзОбластиДня.Добавить();стр.ИмяОбласти=Строка(Перечисления.СтатусыОтправкиГруза.СформирванаЗаявкаВТК); 	Конецесли;
	//если кВыехал		 Тогда стр=тзОбластиДня.Добавить();стр.ИмяОбласти=Строка(Перечисления.СтатусыОтправкиГруза.ВыехалСТочки); 			Конецесли;
	//если кСчетЭК 		 Тогда стр=тзОбластиДня.Добавить();стр.ИмяОбласти=Строка(Перечисления.СтатусыОтправкиГруза.ДобавленСчетЭК); 		Конецесли;
	//если кСчетТК 		 Тогда стр=тзОбластиДня.Добавить();стр.ИмяОбласти=Строка(Перечисления.СтатусыОтправкиГруза.ВТранспортнойКомпании); 	Конецесли;
	//если кДоставлен 	 Тогда стр=тзОбластиДня.Добавить();стр.ИмяОбласти=Строка(Перечисления.СтатусыОтправкиГруза.Доставлен); 				Конецесли;
	//если кУтрачен		 Тогда стр=тзОбластиДня.Добавить();стр.ИмяОбласти=Строка(Перечисления.СтатусыОтправкиГруза.Утрачен); 				Конецесли;
	
	стр=тзОбластиДня.Добавить();стр.ИмяОбласти="Выехало";
	стр=тзОбластиДня.Добавить();стр.ИмяОбласти="ПриехалоВПВ";
	стр=тзОбластиДня.Добавить();стр.ИмяОбласти="Ожидаем в ПВ";
	стр=тзОбластиДня.Добавить();стр.ИмяОбласти="ПриехалоВТК";
	стр=тзОбластиДня.Добавить();стр.ИмяОбласти="Ожидаем в ТК";
	
	
	стр=тзОбластиДня.Добавить();стр.ИмяОбласти="НеУказанТрэкНомер";
	
	
	
	
	//Если Элементы.ГруппаСтраницы.ТекущаяСтраница<>Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Календарь Тогда Возврат; КонецЕсли;
	
	ТаблицаСтатусов=ПолучитьСтатусыЗаПериод(НачалоМесяца(ДатаНачалаМесяцаЗапроса),КонецМесяца(ДатаНачалаМесяцаЗапроса));
	
//	Если Элементы.ГруппаСтраницы.ТекущаяСтраница<>Элементы.ГруппаСтраницы.ПодчиненныеЭлементы.Календарь Тогда Возврат; КонецЕсли;
	КоличествоДнейНедели=7;
	
	Таб = тдКалендарь;
	Таб.Очистить();  
	ШиринаТабличногоПоляМесяца = 1400;//Таб.ШиринаСтраницы;
	
	ОбшаяШиринаМесяца = Цел(109*ШиринаТабличногоПоляМесяца/764);
	
	ШиринаКолонки = Цел(ОбшаяШиринаМесяца/КоличествоДнейНедели);
	
	Таб.Область(,1,,КоличествоДнейНедели).ШиринаКолонки = ШиринаКолонки;
	Таб.Область(1,,1,).ВысотаСтроки = 15;
	
	Если (ШиринаКолонки * КоличествоДнейНедели) <> ОбшаяШиринаМесяца Тогда
		Таб.Область(,КоличествоДнейНедели,,КоличествоДнейНедели).ШиринаКолонки = ОбшаяШиринаМесяца - (ШиринаКолонки * (КоличествоДнейНедели-1));
	КонецЕсли;
	
	ОбластьДнейНедели = Таб.Область(1,1,1,КоличествоДнейНедели);
	ОбластьДнейНедели.ЦветФона = ЦветаСтиля.ЦветФонаКнопки;
	ОбластьДнейНедели.ГраницаСверху = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	ОбластьДнейНедели.ГраницаСнизу 	= Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	ОбластьДнейНедели.ГраницаСлева 	= Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	ОбластьДнейНедели.ГраницаСправа = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
	
	ОбластьДнейНедели.ЦветРамки = ЦветаСтиля.ЦветРамки;
	ОбластьДнейНедели.ЦветТекста = ЦветаСтиля.ЦветРамки;
	
	Для а = 1 По КоличествоДнейНедели Цикл
		
		ОбластьДняНедели = Таб.Область(1,а,1,а);
		ОбластьДняНедели.Текст = ОпределитьДеньНедели(а);
		ОбластьДняНедели.Шрифт = Новый Шрифт(,10,Истина);
		ОбластьДняНедели.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Центр;
		ОбластьДняНедели.ВертикальноеПоложение = ВертикальноеПоложение.Центр;
		ОбластьДняНедели.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Авто;
		ОбластьДняНедели.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Текст;
		
	КонецЦикла;
	ВысотаТабПоляМесяца=600;//Таб.ВысотаСтраницы;
	ВысотаСтроки = Цел(50*(ВысотаТабПоляМесяца-30)/(359-30));
	
	ПервыйДеньНеделиМесяца = ДеньНедели(ДатаНачалаМесяцаЗапроса);
	Если ПервыйДеньНеделиМесяца > 1 Тогда
		ПерваяДатаМесяца = ДатаНачалаМесяцаЗапроса - (ПервыйДеньНеделиМесяца - 1)*60*60*24;
	Иначе
		ПерваяДатаМесяца = ДатаНачалаМесяцаЗапроса;
	КонецЕсли;
	
	ТаблицаСобытияЗаказы = Новый ТаблицаЗначений();
	ТаблицаСобытияЗаказы.Колонки.Добавить("ДатаДокумента");
	ТаблицаСобытияЗаказы.Индексы.Добавить("ДатаДокумента");
	
	ТаблицаСобытияЗаказы.Колонки.Добавить("СтрокаДокументов");
	ТаблицаСобытияЗаказы.Колонки.Добавить("Область");
	ТаблицаСобытияЗаказы.Колонки.Добавить("Цвет");
	
	
	Для каждого СтрокаДанных Из ТаблицаСтатусов Цикл
		имяОбласти=Строка(СтрокаДанных.Статус);
		
		массивстрок=ТаблицаСобытияЗаказы.НайтиСтроки(новый Структура("ДатаДокумента, Область", НачалоДня(СтрокаДанных.Период), имяОбласти));
		Если массивстрок.Количество() =0 Тогда
			НайденнаяСтрока=неопределено;	
		Иначе
			НайденнаяСтрока = массивстрок[0];
		КонецЕсли;
		Если НайденнаяСтрока = Неопределено Тогда
			НайденнаяСтрока = ТаблицаСобытияЗаказы.Добавить();
			НайденнаяСтрока.ДатаДокумента = НачалоДня(СтрокаДанных.Период);
			НайденнаяСтрока.СтрокаДокументов = "";
			НайденнаяСтрока.Цвет=новый Цвет;
	
			
			Если  		СтрокаДанных.Статус="Выехало" Тогда
				НайденнаяСтрока.Цвет=WebЦвета.Черный;
				НайденнаяСтрока.СтрокаДокументов="Выехало: ";
			ИначеЕсли	СтрокаДанных.Статус="ПриехалоВПВ" Тогда	
				НайденнаяСтрока.Цвет=WebЦвета.Зеленый;	
				НайденнаяСтрока.СтрокаДокументов="Приехало в ПВ: ";
				
			ИначеЕсли	СтрокаДанных.Статус="Ожидаем в ПВ" Тогда
				Если СтрокаДанных.Период<НачалоДня(ТекущаяДата()) Тогда
					НайденнаяСтрока.Цвет=ЦветаСтиля.ПросроченныеДанныеЦвет;	
				Иначе	
					НайденнаяСтрока.Цвет=WebЦвета.СинийСоСтальнымОттенком;
				КонецЕсли;
				НайденнаяСтрока.СтрокаДокументов="Ожидаем в ПВ: ";
			ИначеЕсли	СтрокаДанных.Статус="ПриехалоВТК" Тогда	
				НайденнаяСтрока.Цвет=WebЦвета.Зеленый;	
				НайденнаяСтрока.СтрокаДокументов="Приехало в ТК: ";
			ИначеЕсли	СтрокаДанных.Статус="Ожидаем в ТК" Тогда
				Если СтрокаДанных.Период<НачалоДня(ТекущаяДата()) Тогда
					НайденнаяСтрока.Цвет=ЦветаСтиля.ПросроченныеДанныеЦвет;	
				Иначе	
					НайденнаяСтрока.Цвет=WebЦвета.Синий;
				КонецЕсли;
				НайденнаяСтрока.СтрокаДокументов="Ожидаем в ТК: ";
				
				
			ИначеЕсли	СтрокаДанных.Статус="НеУказанТрэкНомер" Тогда
				НайденнаяСтрока.СтрокаДокументов="без ТН: ";
				НайденнаяСтрока.Цвет=ЦветаСтиля.ПросроченныеДанныеЦвет;	
			КонецЕсли;
		КонецЕсли;
		
		//Если НЕ ПустаяСтрока(НайденнаяСтрока.СтрокаДокументов) Тогда
		//	НайденнаяСтрока.СтрокаДокументов = НайденнаяСтрока.СтрокаДокументов + Символы.ПС;
		//КонецЕсли;
		НайденнаяСтрока.Область=имяОбласти;
		НайденнаяСтрока.СтрокаДокументов = НайденнаяСтрока.СтрокаДокументов + " - "+ СтрокаДанных.Штук +" гп.";
	КонецЦикла;
	
	ТекущаяДата = ПерваяДатаМесяца;
	ПерваяСтрока=Истина;
	Для Строка = 2 По 6 Цикл                            
		
		
		ВсегоОбластей=тзОбластиДня.Количество()+3;
		Для Колонка = 1 По КоличествоДнейНедели Цикл
			Если ПерваяСтрока Тогда
				НомерСтроки=Строка;
			Иначе	
				НомерСтроки=(Строка-1)*(ВсегоОбластей)-ВсегоОбластей+2;
			КонецЕсли;
			ОбластьЧислоДня = Таб.Область((НомерСтроки),Колонка,(НомерСтроки),Колонка);
			ОбластьЧислоДня.ГраницаСверху = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
			ОбластьЧислоДня.ГраницаСлева = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
			ОбластьЧислоДня.ГраницаСправа = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
			ОбластьЧислоДня.ЦветРамки = ЦветаСтиля.ЦветРамки;
			ОбластьЧислоДня.ВысотаСтроки = 11;
			
			ОбластьЧислоДня.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
			ОбластьЧислоДня.ВертикальноеПоложение = ВертикальноеПоложение.Центр;
			ОбластьЧислоДня.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Переносить;
			ОбластьЧислоДня.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Текст;
			//	ОбластьЧислоДня.Расшифровка = ТекущаяДата;
			
			//От поставщика
			
			НомерОбласти=1;
			
			Для каждого стр из тзОбластиДня Цикл
				
				стр.Область = Таб.Область((НомерСтроки + НомерОбласти),Колонка,(НомерСтроки+ НомерОбласти),Колонка);
				стр.Область.ГраницаСлева 		= Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
				стр.Область.ГраницаСправа 		= Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
				стр.Область.ЦветРамки 			= ЦветаСтиля.ЦветРамки;
				стр.Область.ВысотаСтроки		= 11;
				стр.Область.РазмещениеТекста 	= ТипРазмещенияТекстаТабличногоДокумента.Переносить;
				
				стр.Область.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
				стр.Область.ВертикальноеПоложение 	= ВертикальноеПоложение.Верх;
				стр.Область.Заполнение 				= ТипЗаполненияОбластиТабличногоДокумента.Текст;
				стр.Область.Шрифт					= Новый Шрифт(стр.Область.Шрифт,,10);;
				НомерОбласти=НомерОбласти+1;
			КонецЦикла;	
			
			
			
			ОбластьОжидаемДоставки = Таб.Область((НомерСтроки + НомерОбласти),Колонка,(НомерСтроки + НомерОбласти),Колонка);
			//ОбластьОжидаемДоставки.ГраницаСнизу = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
			ОбластьОжидаемДоставки.ГраницаСлева = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
			ОбластьОжидаемДоставки.ГраницаСправа = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
			ОбластьОжидаемДоставки.ЦветРамки = ЦветаСтиля.ЦветРамки;
			ОбластьОжидаемДоставки.ВысотаСтроки = 11;
			//ОбластьОжидаемДоставки.Расшифровка = ТекущаяДата;
			ОбластьОжидаемДоставки.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Обрезать;
			
			ОбластьОжидаемДоставки.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
			ОбластьОжидаемДоставки.ВертикальноеПоложение = ВертикальноеПоложение.Верх;
			ОбластьОжидаемДоставки.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Текст;
			НомерОбласти=НомерОбласти+1;

			
			
			ОбластьОжидаемПолучения = Таб.Область((НомерСтроки + НомерОбласти),Колонка,(НомерСтроки + НомерОбласти),Колонка);
			ОбластьОжидаемПолучения.ГраницаСнизу = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
			ОбластьОжидаемПолучения.ГраницаСлева = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
			ОбластьОжидаемПолучения.ГраницаСправа = Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
			ОбластьОжидаемПолучения.ЦветРамки = ЦветаСтиля.ЦветРамки;
			ОбластьОжидаемПолучения.ВысотаСтроки = 11;
			//ОбластьОжидаемПолучения.Расшифровка = ТекущаяДата;
			ОбластьОжидаемПолучения.РазмещениеТекста = ТипРазмещенияТекстаТабличногоДокумента.Обрезать;
			
			ОбластьОжидаемПолучения.ГоризонтальноеПоложение = ГоризонтальноеПоложение.Лево;
			ОбластьОжидаемПолучения.ВертикальноеПоложение = ВертикальноеПоложение.Верх;
			ОбластьОжидаемПолучения.Заполнение = ТипЗаполненияОбластиТабличногоДокумента.Текст;
			
			
			
			//НайденнаяСтрокаСобытияИЗаказы = ТаблицаСтатусов.Найти(ТекущаяДата, "ПериодДень");
			//
			//ОбластьПоляДня.Текст = ?(НайденнаяСтрокаСобытияИЗаказы = Неопределено, "", НайденнаяСтрокаСобытияИЗаказы.Груз);
			ТабСтатусов=ТаблицаСобытияЗаказы.Скопировать(новый структура("ДатаДокумента",ТекущаяДата));
			ТабСтатусов.свернуть("Область");
			МассСтатусов=табСтатусов.ВыгрузитьКолонку("Область");
			Для каждого стр из тзОбластиДня Цикл
				масСтрок=ТаблицаСобытияЗаказы.НайтиСтроки(новый структура("ДатаДокумента,Область", ТекущаяДата,стр.ИмяОбласти));
				Если масСтрок.Количество()=0 Тогда
					НайденнаяСтрокаСобытияИЗаказы = Неопределено;
				Иначе	
					НайденнаяСтрокаСобытияИЗаказы = масСтрок[0];
					стр.Область.ЦветТекста	= НайденнаяСтрокаСобытияИЗаказы.Цвет;
					стр.Область.Текст 		= НайденнаяСтрокаСобытияИЗаказы.СтрокаДокументов;
					стр.Область.Расшифровка	= новый Структура("ДатаКалендаря,Статусы,текСтатус",ТекущаяДата,МассСтатусов,стр.ИмяОбласти);
				КонецЕсли;
			КонецЦикла;
			
			
			
			
			масСтрок=ТаблицаСобытияЗаказы.НайтиСтроки(новый структура("ДатаДокумента,Область", ТекущаяДата,"Ожидает доставки"));
			Если масСтрок.Количество()=0 Тогда
				НайденнаяСтрокаСобытияИЗаказы = Неопределено;
			Иначе	
				НайденнаяСтрокаСобытияИЗаказы = масСтрок[0];
			КонецЕсли;
			ОбластьОжидаемДоставки.Текст = ?(НайденнаяСтрокаСобытияИЗаказы = Неопределено, "", НайденнаяСтрокаСобытияИЗаказы.СтрокаДокументов);
			ОбластьОжидаемДоставки.Расшифровка=новый Структура("ДатаКалендаря,Статусы,текСтатус",ТекущаяДата,МассСтатусов,"Ожидает доставки");
			
			Если НайденнаяСтрокаСобытияИЗаказы <> Неопределено Тогда
				ОбластьОжидаемДоставки.ЦветТекста=НайденнаяСтрокаСобытияИЗаказы.Цвет;	
			КонецЕсли;
			
			
			масСтрок=ТаблицаСобытияЗаказы.НайтиСтроки(новый структура("ДатаДокумента,Область", ТекущаяДата,"Ожидает получения"));
			Если масСтрок.Количество()=0 Тогда
				НайденнаяСтрокаСобытияИЗаказы = Неопределено;
			Иначе	
				НайденнаяСтрокаСобытияИЗаказы = масСтрок[0];
			КонецЕсли;
			ОбластьОжидаемПолучения.Текст = ?(НайденнаяСтрокаСобытияИЗаказы = Неопределено, "", НайденнаяСтрокаСобытияИЗаказы.СтрокаДокументов);
			ОбластьОжидаемПолучения.Расшифровка=новый Структура("ДатаКалендаря,Статусы,текСтатус",ТекущаяДата,МассСтатусов,"Ожидает получения");
			
			Если НайденнаяСтрокаСобытияИЗаказы <> Неопределено Тогда
				ОбластьОжидаемПолучения.ЦветТекста=НайденнаяСтрокаСобытияИЗаказы.Цвет;	
			КонецЕсли;
			
			
			
			Если НачалоДня(ТекущаяДата) = НачалоДня(ТекущаяДата()) Тогда
				
				ОбластьЧислоДня.Шрифт = Новый Шрифт(,,Истина);
				ОбластьЧислоДня.ЦветФона = WebЦвета.Бежевый;
				ОбластьЧислоДня.ГраницаСнизу =  Новый Линия(ТипЛинииЯчейкиТабличногоДокумента.Сплошная, 1);
				
				
				//кел область
				//ОбластьНаСкладе.ЦветФона = Новый Цвет;
				//ОбластьНаСкладе.ЦветТекста = Новый Цвет;
				//кел
				ОбластьОжидаемДоставки.ЦветФона = Новый Цвет;
				ОбластьОжидаемПолучения.ЦветФона = Новый Цвет;
				//ОбластьОжидаемДоставки.ЦветТекста = Новый Цвет;
				
				
				СтрокаДатыДня = СокрЛП(Формат(ТекущаяДата,"ДФ=d"));
				ОбластьЧислоДня.Текст = СокрЛП(Формат(ТекущаяДата,"ДФ=d"));
				
			Иначе
				
				Если Месяц(ТекущаяДата) <> Месяц(ДатаНачалаМесяцаЗапроса) Тогда
					ОбластьЧислоДня.ЦветФона = WebЦвета.Перламутровый;
					ОбластьЧислоДня.ЦветТекста = WebЦвета.Серый;
					ОбластьЧислоДня.Текст = СокрЛП(Формат(ТекущаяДата,"ДФ=dd.MM.yyyy"));
					ОбластьЧислоДня.Шрифт = Новый Шрифт(,,Ложь);
					СтрокаДатыДня = СокрЛП(Формат(ТекущаяДата,"ДФ=dd.MM.yyyy"));
					//кел область
					//ОбластьНаСкладе.ЦветФона = WebЦвета.Перламутровый;
					//ОбластьНаСкладе.ЦветТекста = WebЦвета.Серый;
					//кел 
					ОбластьОжидаемДоставки.ЦветФона = WebЦвета.Перламутровый;
					ОбластьОжидаемПолучения.ЦветФона = WebЦвета.Перламутровый;

					//ОбластьОжидаемДоставки.ЦветТекста = WebЦвета.Серый;
					
				Иначе
					
					Если Колонка = 6 ИЛИ Колонка = 7 Тогда
						ОбластьЧислоДня.ЦветФона = WebЦвета.ГолубойСКраснымОттенком;
						//кел область
						//ОбластьНаСкладе.ЦветФона = WebЦвета.ГолубойСКраснымОттенком;
						//кел 
						ОбластьОжидаемДоставки.ЦветФона = WebЦвета.ГолубойСКраснымОттенком;
						ОбластьОжидаемПолучения.ЦветФона = WebЦвета.ГолубойСКраснымОттенком;

					Иначе
						ОбластьЧислоДня.ЦветФона = Новый Цвет;
						//кел область
						//ОбластьНаСкладе.ЦветФона = Новый Цвет;
						//кел 						ОбластьОжидаемДоставки.ЦветФона = Новый Цвет;
					КонецЕсли; 
					
					ОбластьЧислоДня.ЦветТекста = Новый Цвет;
					ОбластьЧислоДня.Текст = СокрЛП(Формат(ТекущаяДата,"ДФ=d"));
					ОбластьЧислоДня.Шрифт = Новый Шрифт(,,Ложь);
					СтрокаДатыДня = СокрЛП(Формат(ТекущаяДата,"ДФ=d"));
					//кел область
					//ОбластьНаСкладе.ЦветТекста = Новый Цвет;
					//кел 
					//ОбластьОжидаемДоставки.ЦветТекста = Новый Цвет;
					
				КонецЕсли;
				
			КонецЕсли;
			
			ТекущаяДата = ОпределитьСледующуюДата(ТекущаяДата,КоличествоДнейНедели);
			
		КонецЦикла;
		ПерваяСтрока=Ложь;
		
	КонецЦикла;
	
	Таб.ФиксацияСверху = 1;
	Таб.ФиксацияСлева = КоличествоДнейНедели;
	Таб.ТолькоПросмотр = Истина;
	//Таб.Вывести(Элементы.тдКалендарь);
	
	
	
	
КонецПроцедуры // ОбновитьКалендарь()

Функция 	ПолучитьСтатусыЗаПериод(НачалоПериода,КонецПериода)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	МегаордераМаршрут.Ссылка КАК Супергруппа,
	|	СУММА(1) КАК Количество
	|ПОМЕСТИТЬ КоличествоКолен
	|ИЗ
	|	Справочник.Мегаордера.Маршрут КАК МегаордераМаршрут
	|СГРУППИРОВАТЬ ПО
	|	МегаордераМаршрут.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	МегаордераМаршрут.ТранспортнаяКомпания КАК ТранспортнаяКомпания,
	|	МегаордераМаршрут.ДатаДоставкиПлан КАК Период,
	|	ВЫБОР
	|		КОГДА МегаордераМаршрут.НомерСтроки = КоличествоКолен.Количество
	|			ТОГДА ""Ожидаем в ПВ""
	|		ИНАЧЕ ""Ожидаем в ТК""
	|	КОНЕЦ КАК Статус,
	|	МегаордераМаршрут.Ссылка КАК Ссылка,
	|	МегаордераМаршрут.ТрэкНомер КАК ТрэкНомер
	|ПОМЕСТИТЬ Сбор
	|ИЗ
	|	Справочник.Мегаордера.Маршрут КАК МегаордераМаршрут
	|		ЛЕВОЕ СОЕДИНЕНИЕ КоличествоКолен КАК КоличествоКолен
	|		ПО МегаордераМаршрут.Ссылка = КоличествоКолен.Супергруппа
	|ГДЕ
	|	МегаордераМаршрут.ДатаДоставкиФакт = ДАТАВРЕМЯ(1, 1, 1)
	|	И МегаордераМаршрут.ДатаДоставкиПлан МЕЖДУ &НачалоПериода И &КонецПериода
	|	И (МегаордераМаршрут.Ссылка.ПерваяТочкаПриема = &Отправитель
	|	ИЛИ &Отправитель = ЗНАЧЕНИЕ(Справочник.ТочкиРаздачи.ПустаяСсылка))
	|	И (МегаордераМаршрут.Ссылка.ПунктВыдачи = &Получатель
	|	ИЛИ &Получатель = ЗНАЧЕНИЕ(Справочник.ТочкиРаздачи.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МегаордераМаршрут.ТранспортнаяКомпания,
	|	МегаордераМаршрут.ДатаДоставкиФакт,
	|	ВЫБОР
	|		КОГДА МегаордераМаршрут.НомерСтроки = КоличествоКолен.Количество
	|			ТОГДА ""ПриехалоВПВ""
	|		ИНАЧЕ ""ПриехалоВТК""
	|	КОНЕЦ,
	|	МегаордераМаршрут.Ссылка,
	|	МегаордераМаршрут.ТрэкНомер
	|ИЗ
	|	Справочник.Мегаордера.Маршрут КАК МегаордераМаршрут
	|		ЛЕВОЕ СОЕДИНЕНИЕ КоличествоКолен КАК КоличествоКолен
	|		ПО МегаордераМаршрут.Ссылка = КоличествоКолен.Супергруппа
	|ГДЕ
	|	МегаордераМаршрут.ДатаДоставкиФакт МЕЖДУ &НачалоПериода И &КонецПериода
	|	И МегаордераМаршрут.Ссылка.ДатаСоздания МЕЖДУ &НачалоПериода И &КонецПериода
	|	И (МегаордераМаршрут.Ссылка.ПерваяТочкаПриема = &Отправитель
	|	ИЛИ &Отправитель = ЗНАЧЕНИЕ(Справочник.ТочкиРаздачи.ПустаяСсылка))
	|	И (МегаордераМаршрут.Ссылка.ПунктВыдачи = &Получатель
	|	ИЛИ &Получатель = ЗНАЧЕНИЕ(Справочник.ТочкиРаздачи.ПустаяСсылка))
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	МегаордераМаршрут.ТранспортнаяКомпания,
	|	МегаордераМаршрут.Ссылка.ДатаСоздания,
	|	""Выехало"",
	|	МегаордераМаршрут.Ссылка,
	|	МегаордераМаршрут.ТрэкНомер
	|ИЗ
	|	Справочник.Мегаордера.Маршрут КАК МегаордераМаршрут
	|ГДЕ
	|	МегаордераМаршрут.НомерСтроки = 1
	|	И (МегаордераМаршрут.Ссылка.ПерваяТочкаПриема = &Отправитель
	|	ИЛИ &Отправитель = ЗНАЧЕНИЕ(Справочник.ТочкиРаздачи.ПустаяСсылка))
	|	И (МегаордераМаршрут.Ссылка.ПунктВыдачи = &Получатель
	|	ИЛИ &Получатель = ЗНАЧЕНИЕ(Справочник.ТочкиРаздачи.ПустаяСсылка))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Сбор.ТранспортнаяКомпания КАК ТранспортнаяКомпания,
	|	Сбор.Период КАК Период,
	|	Сбор.Статус КАК Статус,
	|	Сбор.Ссылка КАК Супергруппа
	|ПОМЕСТИТЬ Пред
	|ИЗ
	|	Сбор КАК Сбор
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Сбор.ТранспортнаяКомпания,
	|	Сбор.Период,
	|	""НеУказанТрэкНомер"",
	|	Сбор.Ссылка
	|ИЗ
	|	Сбор КАК Сбор
	|ГДЕ
	|	Сбор.ТрэкНомер = """"
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	Пред.Период КАК Период,
	|	Пред.Статус КАК Статус,
	|	КОЛИЧЕСТВО(Пред.Супергруппа) КАК Штук
	|ИЗ
	|	Пред КАК Пред
	|СГРУППИРОВАТЬ ПО
	|	Пред.Период,
	|	Пред.Статус";
	
	
	
	
	
	Запрос.УстановитьПараметр("КонецПериода", 	КонецПериода+6*24*60*60);
	Запрос.УстановитьПараметр("НачалоПериода", 	НачалоПериода-6*24*60*60);
	Запрос.УстановитьПараметр("Отправитель", 	Объект.Отправитель);
	Запрос.УстановитьПараметр("Получатель", 	Объект.Получатель);

	//Запрос.УстановитьПараметр("СписокСтатусов", СписокСтатусов);
	
	РезультатЗапроса = Запрос.Выполнить();
	
	Возврат РезультатЗапроса.Выгрузить();
	
КонецФункции	

&НаКлиенте
Процедура 	тдКалендарьОбработкаРасшифровки(Элемент, Расшифровка, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(Расшифровка) = Тип("Дата") Тогда
		//фрм=ПолучитьФорму("Отчет.ОтчетПоСтатусамДоставки.Форма.ФормаОтчета");
		//отчетОбъект=фрм.Отчет;
		//УстановитьПараметрыРасшифровки(отчетОбъект,Расшифровка);
		//КопироватьДанныеФормы(отчетОбъект,фрм.отчет);
		//фрм.открыть();
	КонецЕсли;

	ОткрытьФорму("Обработка.КалендарьСупергрупп.Форма.РасшифровкаКалендаря",новый структура("ДатаКалендаря,Статусы,ТекСтатус",Расшифровка.ДатаКалендаря,Расшифровка.Статусы,Расшифровка.текСтатус),ЭтаФорма,,,,,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
//	фрм=ПолучитьФорму("Обработка.КалендарьСупергрупп.Форма.РасшифровкаКалендаря",новый структура("ДатаКалендаря,Статусы,ТекСтатус",Расшифровка.ДатаКалендаря,Расшифровка.Статусы,Расшифровка.текСтатус),ЭтаФорма,,ВариантОткрытияОкна.ОтдельноеОкно);
//	фрм.открыть();
КонецПроцедуры


#Область Вспомогательные

Функция 	ОпределитьДеньНедели(НомерДняНедели)
	
	Если НомерДняНедели = 1 Тогда
		Возврат "Понедельник";
	ИначеЕсли НомерДняНедели = 2 Тогда
		Возврат "Вторник";
	ИначеЕсли НомерДняНедели = 3 Тогда
		Возврат "Среда";
	ИначеЕсли НомерДняНедели = 4 Тогда
		Возврат "Четверг";
	ИначеЕсли НомерДняНедели = 5 Тогда
		Возврат "Пятница";
	ИначеЕсли НомерДняНедели = 6 Тогда
		Возврат "Суббота";
	Иначе
		Возврат "Воскресенье";
	КонецЕсли;
	
КонецФункции

Функция 	ОпределитьСледующуюДата(ТекущаяДата,КоличествоДнейНедели)
	
	Если КоличествоДнейНедели = 7 Тогда
		Возврат ТекущаяДата + 60*60*24;
	ИначеЕсли КоличествоДнейНедели = 6 Тогда
		Если ДеньНедели(ТекущаяДата) = 6 Тогда
			Возврат ТекущаяДата + 60*60*24*2;
		Иначе
			Возврат ТекущаяДата + 60*60*24;
		КонецЕсли; 
	ИначеЕсли КоличествоДнейНедели = 5 Тогда
		Если ДеньНедели(ТекущаяДата) = 5 Тогда
			Возврат ТекущаяДата + 60*60*24*3;
		ИначеЕсли ДеньНедели(ТекущаяДата) = 6 Тогда
			Возврат ТекущаяДата + 60*60*24*2;
		Иначе
			Возврат ТекущаяДата + 60*60*24;
		КонецЕсли; 
	КонецЕсли; 
	
КонецФункции // ОпределитьСледующуюДата()

&НаКлиенте
Процедура 	РазмерШрифтаПриИзменении(Элемент)
	ОбновитьКалендарьНаСервере();
КонецПроцедуры

#КонецОбласти

#КонецОбласти


Процедура ЗагрузкаСуперГруппНаСервере()
	#Область СупперГруппыПоДате
	стрОтвета = СтоСПОбмен_СупперГруппы.Загрузить_СуперГруппыПоДате();
	#КонецОбласти 
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия="ОбновитьФорму" Тогда	
        ОбновитьКалендарьНаСервере();
	КонецЕсли;

КонецПроцедуры
