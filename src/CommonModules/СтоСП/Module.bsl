Функция ПолучитьТег_income2(Параметры) Экспорт 
	СтруктураТэга=новый Структура;
	pid				= Неопределено;
	orderId			= Неопределено;
	groupCode		= Неопределено;
	orderType		= Неопределено;
	
	Если ТипЗнч(Параметры.Покупка)=Тип("СправочникСсылка.Покупки") Тогда
		СтруктураТэга.Вставить("pid",Формат(Число(Параметры.Покупка.Код),"ЧГ=0"));
		СтруктураТэга.Вставить("orderType", 	"sp");
	КонецЕсли;
	Если ТипЗнч(Параметры.Покупка)=Тип("СправочникСсылка.Заказы") Тогда
		СтруктураТэга.Вставить("orderId",		Формат(Число(Параметры.Покупка.Код),"ЧГ=0"));
		СтруктураТэга.Вставить("orderType",		"shop");
	КонецЕсли;
	Если ТипЗнч(Параметры.Покупка)=Тип("СправочникСсылка.Коробки") Тогда
		СтруктураТэга.Вставить("groupCode",		Формат(Число(Параметры.Покупка.Код),"ЧГ=0"));
		СтруктураТэга.Вставить("orderType",		"group");
	КонецЕсли;
	
	
	СтруктураТэга.Вставить("paid",			?(Параметры.Оплачен,1,0));
	Если Параметры.Свойство("Габарит") Тогда
		СтруктураТэга.Вставить("isBig",		?(Параметры.Габарит.НеГабарит,1,0));
	Иначе	
		СтруктураТэга.Вставить("isBig",		0);
	КонецЕсли;	
	СтруктураТэга.Вставить("isFree",		?(Параметры.ОтдельнымМестом,1,0));
	СтруктураТэга.Вставить("date", 			?(ЗначениеЗаполнено(Параметры.ДатаПриема),Параметры.ДатаПриема,Параметры.Ссылка.Дата) );
	
	Если Параметры.ТипПараметра="ПриходнаяПокупки" Тогда
		натранзит=?(Параметры.Ссылка.Транзит,1,0);
		Если ТипЗнч(Параметры.Покупка)=Тип("СправочникСсылка.Коробки") Тогда
			СтруктураТэга.Вставить("groupCode", 	Формат(Число(Параметры.Покупка.Код),"ЧГ=0"));
			СтруктураТэга.Вставить("orderType", 	"group");
		КонецЕсли;
		СтруктураТэга.Вставить("DistributorFee",?(Параметры.ОргСбор,1,0));
	ИначеЕсли Параметры.ТипПараметра="РазборКоробкиПокупки" Тогда	
		натранзит =(Параметры.Коробка.КРазбору И Параметры.Ссылка.СвояТочка <> Параметры.ТочкаНазначения);
		Если Параметры.Коробка <> Справочники.Коробки.БезКоробки Тогда
			СтруктураТэга.Вставить("groupCode", 	Формат(Число(Параметры.Коробка.Код),"ЧГ=0"));
		КонецЕсли;
		Если ТипЗнч(Параметры.Покупка)=Тип("СправочникСсылка.Коробки") Тогда
			СтруктураТэга.Вставить("orderType", 	"group");
		КонецЕсли;
		СтруктураТэга.Вставить("DistributorFee",0);
	ИначеЕсли Параметры.ТипПараметра="РазборКоробкиКоробки" Тогда	
		натранзит =(Параметры.Коробка.КРазбору И Параметры.Ссылка.СвояТочка <> Параметры.ТочкаНазначения);
	КонецЕсли;
	СтруктураТэга.Вставить("transit", 		?(натранзит,1,0));
	Если Параметры.Свойство("Участник") Тогда
		СтруктураТэга.Вставить("uid", 				Формат(Число(Параметры.Участник.Код),"ЧГ=0"));
	КонецЕсли;
	СтруктураТэга.Вставить("orgid", 				Формат(Число(Параметры.Организатор.Код),"ЧГ=0"));
	СтруктураТэга.Вставить("sizedCategoryName", 	ПолучитьПредставлениеГабарита(Параметры.Габарит));
	СтруктураТэга.Вставить("arrivalNumber", 		Прав(Параметры.Ссылка.Номер,(СтрДлина(Параметры.Ссылка.Номер)-3)));
	СтруктураТэга.Вставить("sizedCategoryNumber", 	Параметры.Габарит.Код);
	
	ЗаписьXML=новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");	
	ЗаписьXML.ЗаписатьНачалоЭлемента("income");
	Для каждого элем из СтруктураТэга Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента(элем.Ключ);
		ЗаписьXML.ЗаписатьТекст(Строка(элем.Значение));
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЦикла;	
	ЗаписьXML.ЗаписатьКонецЭлемента();

	Возврат ЗаписьXML.Закрыть();
КонецФункции	

Функция ПолучитьТег(Параметры,ИмяТэга) Экспорт 
	ЗаписьXML=новый ЗаписьXML;
	ЗаписьXML.УстановитьСтроку("UTF-8");	
	ЗаписьXML.ЗаписатьНачалоЭлемента(ИмяТэга);
	Для каждого элем из Параметры Цикл
		ЗаписьXML.ЗаписатьНачалоЭлемента(элем.Ключ);
		ЗаписьXML.ЗаписатьТекст(Строка(элем.Значение));
		ЗаписьXML.ЗаписатьКонецЭлемента();
	КонецЦикла;	
	ЗаписьXML.ЗаписатьКонецЭлемента();

	Возврат ЗаписьXML.Закрыть();
КонецФункции


Процедура  Вставить_Тэг(ЗаписьXML,ИмяТэга,Значение) Экспорт
	ЗаписьXML.ЗаписатьНачалоЭлемента(ИмяТэга);
	ЗаписьXML.ЗаписатьТекст(Строка(Значение));
	ЗаписьXML.ЗаписатьКонецЭлемента();
КонецПроцедуры


#Область Вспомогательные

Функция ПолучитьПредставлениеГабарита(Габарит) Экспорт
	Возврат "("+Габарит.СтоимостьХранения+";"+Габарит.ДниХранения+";"+Габарит.ДобавочнаяСтоимость+";) "+Габарит.Наименование;
КонецФункции


#КонецОбласти