
&НаКлиенте
Процедура НапечататьГрупповыеСтикеры(Команда)
	//ПараметрКоманды = Новый Массив;   // Добавим объект обработки печати ценников и этикеток в массив параметров печати.
	//ПараметрКоманды.Добавить(Объект); // В дальнейшем будем обращаться к объекту через ПараметрКоманды[0]
	//РежимПечати = "Этикетки";
	//
	//УправлениеПечатьюКлиент.ВыполнитьКомандуПечати(
	//"Обработка.ПечатьСтикеровДляКоробок", // Для вызова метода менеджера обработки "Печать".
	//РежимПечати,
	//ПараметрКоманды,
	//, // Форма владелец
	//Новый Структура("Шаблон", Шаблон));

КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
   //// СтандартныеПодсистемы.Печать
   // УправлениеПечатью.ПриСозданииНаСервере(ЭтотОбъект);
   // // Конец СтандартныеПодсистемы.Печать
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	
	//ОбщегоНазначения.ПриСозданииНаСервере(ЭтаФорма,Отказ, СтандартнаяОбработка);
	Если отказ Тогда Возврат конецЕсли;
    ЭлементОтбора = Список.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
    ЭлементОтбора.ЛевоеЗначение 	= Новый ПолеКомпоновкиДанных("Пользователь");
   	ЭлементОтбора.ВидСравнения 		= ВидСравненияКомпоновкиДанных.Равно;
    ЭлементОтбора.Использование 	= Истина;
  	ЭлементОтбора.РежимОтображения 	= РежимОтображенияЭлементаНастройкиКомпоновкиДанных.Недоступный;
    ЭлементОтбора.ПравоеЗначение 	= ПользователиКлиентСервер.ТекущийПользователь();	
КонецПроцедуры


// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
    ПодключаемыеКомандыКлиент.ВыполнитьКоманду(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры
&НаСервере
Процедура Подключаемый_ВыполнитьКомандуНаСервере(Контекст, Результат)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, Контекст, Элементы.Список, Результат);
КонецПроцедуры
&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

&НаКлиенте
Процедура ПриОткрытии(Отказ)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
		//Сконер штрихкода
   ПоддерживаемыеТипыВО = Новый Массив();
   ПоддерживаемыеТипыВО.Добавить("СканерШтрихкода");
   ОповещенияПриПодключении = Новый ОписаниеОповещения("ПодключитьОборудованиеЗавершение", ЭтотОбъект); 
   МенеджерОборудованияКлиент.НачатьПодключениеОборудованиеПоТипу(ОповещенияПриПодключении, УникальныйИдентификатор, ПоддерживаемыеТипыВО);
	//*****************

КонецПроцедуры

&НаКлиенте
Процедура ПодключитьОборудованиеЗавершение(РезультатВыполнения, Параметры) Экспорт
 
   Если Не РезультатВыполнения.Результат Тогда
      ТекстСообщения = НСтр( "ru = 'При подключении оборудования произошла ошибка:""%ОписаниеОшибки%"".'");
      ТекстСообщения = СтрЗаменить(ТекстСообщения, "%ОписаниеОшибки%" , РезультатВыполнения.ОписаниеОшибки);
      Сообщить(ТекстСообщения);
   Иначе
	  //ТекстСообщения = НСтр("ru = 'Оборудование подключено.'" );
	  //Сообщить(ТекстСообщения);
   КонецЕсли;

КонецПроцедуры

// СтандартныеПодсистемы.Печать
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуПечати(Команда)
    УправлениеПечатьюКлиент.ВыполнитьПодключаемуюКомандуПечати(Команда, ЭтотОбъект, Элементы.Список);
КонецПроцедуры


&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
    // СтандартныеПодсистемы.ПодключаемыеКоманды
    ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры
// Конец СтандартныеПодсистемы.Печать