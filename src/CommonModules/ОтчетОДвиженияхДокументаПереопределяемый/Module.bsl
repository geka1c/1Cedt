
#Область ПрограммныйИнтерфейс

// Позволяет дополнить регистры с движениями документа дополнительными регистрами.
//
// Параметры:
//    Документ - ДокументСсылка - документ коллекцию движений которого необходимо дополнить.
//    РегистрыСДвижениями - Соответствие - соответствие с данными:
//        * Ключ     - ОбъектМетаданных - регистр как объект метаданных.
//        * Значение - Строка           - имя поля регистратора.
//
Процедура ПриОпределенииРегистровСДвижениями(Документ, РегистрыСДвижениями) Экспорт
	
	
	
КонецПроцедуры

// Позволяет рассчитать количество записей для дополнительных наборов, добавленных процедурой
// ПриОпределенииРегистровСДвижениями.
//
// Параметры:
//    Документ - ДокументСсылка - документ коллекцию движений которого необходимо дополнить.
//    РассчитанноеКоличество - Соответствие - соответствие с данными:
//        * Ключ     - Строка - полное имя регистра (вместо точек используется символ подчеркивания).
//        * Значение - Число  - рассчитанное количество записей.
//
Процедура ПриРасчетеКоличестваЗаписей(Документ, РассчитанноеКоличество) Экспорт
	
	
	
КонецПроцедуры

// Позволяет дополнить или переопределить коллекцию наборов данных для вывода движений документа.
//
// Параметры:
//    Документ - ДокументСсылка - документ, коллекцию движений которого необходимо дополнить.
//    НаборыДанных - Массив - сведения о наборах данных (тип элемента Структура).
//
Процедура ПриПодготовкеНабораДанных(Документ, НаборыДанных) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
