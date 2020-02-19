#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ПроцедурыИФункцииБсп

#Область НастройкиПоУмолчанию

// Возвращает структуру отборов на узле плана обмена с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//      ВерсияКорреспондента - Строка - версия корреспондента.
//      ИмяФормы             - Строка - имя формы.
//      ИдентификаторНастройки          - Строка - имя дополнительной настройки обмена.
//
// Возвращаемое значение:
//      Структура - структура отборов на узле плана обмена.
// 
Функция НастройкаОтборовНаУзле(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки = "") Экспорт
	
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ВерсияФорматаОбмена",             "1.0.0");
	
	Возврат СтруктураНастроек;
КонецФункции

// Возвращает структуру отборов на узле плана обмена базы корреспондента с установленными значениями по умолчанию;
// Структура настроек повторяет состав реквизитов шапки и табличных частей плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры,
// а для табличных частей используются структуры,
// содержащие массивы значений полей табличных частей плана обмена.
// 
// Параметры:
//      ВерсияКорреспондента - Строка - версия корреспондента.
//      ИмяФормы             - Строка - имя формы.
//      ИдентификаторНастройки          - Строка - имя дополнительной настройки обмена.
//
// Возвращаемое значение:
//      Структура - структура отборов на узле плана обмена базы корреспондента.
// 
Функция НастройкаОтборовНаУзлеБазыКорреспондента(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки = "") Экспорт
	
	СтруктураНастроек = Новый Структура;
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает структуру значений по умолчанию для узла;
// Структура настроек повторяет состав реквизитов шапки плана обмена;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//      ВерсияКорреспондента - Строка - версия корреспондента.
//      ИмяФормы             - Строка - имя формы.
//      ИдентификаторНастройки          - Строка - имя дополнительной настройки обмена.
//
// Возвращаемое значение:
//      Структура - структура значений по умолчанию на узле плана обмена.
// 
Функция ЗначенияПоУмолчаниюНаУзле(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки = "") Экспорт
	
	СтруктураНастроек = Новый Структура;
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает структуру значений по умолчанию для узла базы корреспондента;
// Структура настроек повторяет состав реквизитов шапки плана обмена базы корреспондента;
// Для реквизитов шапки используются аналогичные по ключу и значению элементы структуры.
// 
// Параметры:
//      ВерсияКорреспондента - Строка - версия корреспондента.
//      ИмяФормы             - Строка - имя формы.
//      ИдентификаторНастройки          - Строка - имя дополнительной настройки обмена.
// 
// Возвращаемое значение:
//      Структура - структура значений по умолчанию на узле плана обмена базы корреспондента.
//
Функция ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента(ВерсияКорреспондента, ИмяФормы, ИдентификаторНастройки = "") Экспорт
	
	СтруктураНастроек = Новый Структура;
	Возврат СтруктураНастроек;
	
КонецФункции

// Возвращает строковое представление варианта синхронизации документов,
// в зависимости от установленного режима выгрузки документов; 
//
// Возвращаемое значение:
//  Строка, неограниченной длины - строковое представление варианта выгрузки документов.
//
Функция ОпределитьВариантСинхронизацииДокументов(РежимВыгрузкиДокументов) Экспорт
	
	ВариантСинхронизацииДокументов = "";
	
	Если РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию Тогда
		
		ВариантСинхронизацииДокументов = "АвтоматическаяСинхронизация"
		
	ИначеЕсли РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную Тогда
		
		ВариантСинхронизацииДокументов = "ИнтерактивнаяСинхронизация"
		
	ИначеЕсли РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать Тогда
		
		ВариантСинхронизацииДокументов = "НеСинхронизировать"
		
	КонецЕсли;
	
	Возврат ВариантСинхронизацииДокументов;
	
КонецФункции

// Возвращает строковое представление варианта синхронизации справочников,
// в зависимости от установленного режима выгрузки справочников; 
//
// Возвращаемое значение:
//  Строка, неограниченной длины - строковое представление варианта выгрузки справочников.
//
Функция ОпределитьВариантСинхронизацииСправочников(РежимВыгрузкиСправочников) Экспорт
	
	ВариантСинхронизацииСправочников = "";
	
	Если РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию Тогда
		
		ВариантСинхронизацииСправочников = "АвтоматическаяСинхронизация";
		
	ИначеЕсли РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости Тогда
		
		ВариантСинхронизацииСправочников = "СинхронизироватьПоНеобходимости";
		
	ИначеЕсли РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать Тогда
		
		ВариантСинхронизацииСправочников = "НеСинхронизировать";
		
	КонецЕсли;
	
	Возврат ВариантСинхронизацииСправочников;
	
КонецФункции

#КонецОбласти

#Область ВыводОписаний

// Возвращает представление команды создания нового обмена данными.
//
// Возвращаемое значение:
//  Строка, неограниченной длины - представление команды, выводимое в пользовательском интерфейсе.
//
// Например:
//	Возврат НСтр("ru = 'Создать обмен в распределенной информационной базе'");
//
Функция ЗаголовокКомандыДляСозданияНовогоОбменаДанными() Экспорт
	
	Возврат НСтр("ru = 'Синхронизация Заявок с СП точкой раздачи через формат sample-package'");
	
КонецФункции

// Возвращает краткую информацию по обмену, выводимую при настройке синхронизации данных.
//
Функция КраткаяИнформацияПоОбмену(ИдентификаторНастройки = "") Экспорт
	
	ПоясняющийТекст = "";
	Если ИдентификаторНастройки = "ТолькоОтправка" Тогда
		ПоясняющийТекст = НСтр("ru = 'Позволяет отправлять данные в программу СП.'");
	ИначеЕсли ИдентификаторНастройки = "ТолькоПолучение" Тогда
		ПоясняющийТекст = НСтр("ru = 'Позволяет получать данные из программы СП'");
	ИначеЕсли ИдентификаторНастройки = "Двухсторонний" Тогда
		ПоясняющийТекст = НСтр("ru = 'Позволяет синхронизировать данные между двумя однотипными программами СП'");
	Иначе
		ПоясняющийТекст = НСтр("ru = 'Позволяет синхронизировать данные с любой программой, поддерживающей универсальный формат обмена ""Enterprise Data"".
		|В синхронизации данных участвуют следующие типы данных:
		| - справочники (например, Организации),
		| - документы (например, Реализация товаров).'");
	КонецЕсли;
	
	Возврат ПоясняющийТекст;
	
КонецФункции

// Возвращаемое значение: Строка - Ссылка на подробную информацию по настраиваемой синхронизации,
// в виде гиперссылки или полного пути к форме.
Функция ПодробнаяИнформацияПоОбмену(ИдентификаторНастройки = "") Экспорт
	Возврат "";
КонецФункции

// Возвращает строку описания ограничений миграции данных для пользователя;
// Прикладной разработчик на основе установленных отборов на узле должен сформировать строку описания ограничений 
// удобную для восприятия пользователем.
// 
// Параметры:
//      НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена,
//                                           полученная при помощи функции НастройкаОтборовНаУзле().
//      ВерсияКорреспондента - Строка - версия корреспондента.
//      ИдентификаторНастройки          - Строка - имя дополнительной настройки обмена.
//
// Возвращаемое значение:
//     Строка - описание ограничений миграции данных для пользователя.
//
Функция ОписаниеОграниченийПередачиДанных(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает строку описания значений по умолчанию для пользователя;
// Прикладной разработчик на основе установленных значений по умолчанию на узле должен сформировать строку описания 
// удобную для восприятия пользователем.
// 
// Параметры:
//      ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена,
//                                              полученная при помощи функции ЗначенияПоУмолчаниюНаУзле().
// 
//      ВерсияКорреспондента - Строка - версия корреспондента.
//      ИдентификаторНастройки          - Строка - имя дополнительной настройки обмена.
//
// Возвращаемое значение:
//      Строка - описание для пользователя значений по умолчанию.
//
Функция ОписаниеЗначенийПоУмолчанию(ЗначенияПоУмолчаниюНаУзле, ВерсияКорреспондента, ИдентификаторНастройки) Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает строку описания ограничений миграции данных для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных отборов на узле базы корреспондента должен сформировать строку
// описания ограничений  удобную для восприятия пользователем.
// 
// Параметры:
//      НастройкаОтборовНаУзле - Структура - структура отборов на узле плана обмена базы корреспондента,
//                                           полученная при помощи функции НастройкаОтборовНаУзлеБазыКорреспондента().
//      ВерсияКорреспондента - Строка - версия корреспондента.
//      ИдентификаторНастройки          - Строка - имя дополнительной настройки обмена.
//
// Возвращаемое значение:
//      Строка - строка описания ограничений миграции данных для пользователя.
//
Функция ОписаниеОграниченийПередачиДанныхБазыКорреспондента(НастройкаОтборовНаУзле, ВерсияКорреспондента, ИдентификаторНастройки = "") Экспорт
	
	Возврат "";
	
КонецФункции

// Возвращает строку описания значений по умолчанию для базы корреспондента, которая отображается пользователю;
// Прикладной разработчик на основе установленных значений по умолчанию на узле базы корреспондента должен сформировать
// строку описания  удобную для восприятия пользователем.
// 
// Параметры:
//      ЗначенияПоУмолчаниюНаУзле - Структура - структура значений по умолчанию на узле плана обмена базы
//                                              корреспондента, полученная при помощи функции
//                                              ЗначенияПоУмолчаниюНаУзлеБазыКорреспондента().
//      ВерсияКорреспондента - Строка - версия корреспондента.
//      ИдентификаторНастройки          - Строка - имя дополнительной настройки обмена.
//
// Возвращаемое значение:
//      Строка - строка описания для пользователя значений по умолчанию.
//
Функция ОписаниеЗначенийПоУмолчаниюБазыКорреспондента(ЗначенияПоУмолчаниюНаУзле, ВерсияКорреспондента, ИдентификаторНастройки = "") Экспорт
	
	Возврат "";
	
КонецФункции

#КонецОбласти

#Область КонстантыИПроверкаПараметровУчета

// Определяет текст пояснения для настройки параметров учета.
// 
// Возвращаемое значение:
//	Строка - строка описания пояснения для настройки параметров учета.
//
Функция ПояснениеДляНастройкиПараметровУчета() Экспорт
	
	Возврат "";
	
КонецФункции

// Определяет текст пояснения для настройки параметров учета базы-корреспондента.
// 
// Параметры:
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для различного
//									пояснения для настройки параметров учета в зависимости от версии корреспондента.
// 
// Возвращаемое значение:
//  Строка - строка описания пояснения для настройки параметров учета базы-корреспондента.
//
Функция ПояснениеДляНастройкиПараметровУчетаБазыКорреспондента(ВерсияКорреспондента) Экспорт
	Возврат "";
КонецФункции

// Проверяет корректность настройки параметров учета.
//
// Параметры:
//	Отказ - Булево - Признак невозможности продолжения настройки обмена из-за некорректно настроенных параметров учета.
//	Получатель - ПланОбменаСсылка - Узел обмена, для которого выполняется проверка параметров учета.
//	Сообщение - Строка - Содержит текст сообщения о некорректных параметрах учета.
//
Процедура ОбработчикПроверкиПараметровУчета(Отказ, Получатель, Сообщение) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#Область ПереопределяемаяНастройкаДополненияВыгрузки

// Предназначена для настройки вариантов интерактивной настройки выгрузки по сценарию узла.
// Для настройки необходимо установить значения свойств параметров в необходимые значения.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого производится настройка.
//     Параметры  - Структура        - Параметры для изменения. Содержит поля:
//
//         ВариантБезДополнения - Структура     - настройки типового варианта "Не добавлять".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 1.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантВсеДокументы - Структура      - настройки типового варианта "Добавить все документы за период".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 2.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантПроизвольныйОтбор - Структура - настройки типового варианта "Добавить данные с произвольным отбором".
//                                                Содержит поля:
//             Использование - Булево - флаг разрешения использования варианта. По умолчанию Истина.
//             Порядок       - Число  - порядок размещения варианта на форме помощника, сверху вниз. По умолчанию 3.
//             Заголовок     - Строка - позволяет переопределить название типового варианта.
//             Пояснение     - Строка - позволяет переопределить текст пояснения варианта для пользователя.
//
//         ВариантДополнительно - Структура     - настройки дополнительного варианта по сценарию узла.
//                                                Содержит поля:
//             Использование            - Булево            - флаг разрешения использования варианта. По умолчанию Ложь.
//             Порядок                  - Число             - порядок размещения варианта на форме помощника, сверху
//                                                            вниз. По умолчанию 4.
//             Заголовок                - Строка            - название варианта для отображения на форме.
//             ИмяФормыОтбора           - Строка            - Имя формы, вызываемой для редактирования настроек.
//             ЗаголовокКомандыФормы    - Строка            - Заголовок для отрисовки на форме команды открытия формы
//                                                            настроек.
//             ИспользоватьПериодОтбора - Булево            - флаг того, что необходим общий отбор по периоду. По
//                                                            умолчанию Ложь.
//             ПериодОтбора             - СтандартныйПериод - значение периода общего отбора, предлагаемого по
//                                                            умолчанию.
//
//             Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию
//                                                            узла.
//                                                            Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор
//                                                               которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Можно
//                                                               использовать специальные  значения "ВсеДокументы" и
//                                                               "ВсеСправочники" для отбора соответственно всех
//                                                               документов и всех справочников, регистрирующихся на
//                                                               узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим
//                                                               периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки,
//                                                               предлагаемого по умолчанию.
//                 Отбор               - ОтборКомпоновкиДанных - отбор по умолчанию. Поля отбора формируются в
//                                                               соответствии с общим правилами формирования полей
//                                                               компоновки. Например, для указания отбора по реквизиту
//                                                               документа "Организация", необходимо использовать поле
//                                                               "Ссылка.Организация".
Процедура НастроитьИнтерактивнуюВыгрузку(Получатель, Параметры) Экспорт
	
	
КонецПроцедуры

// Возвращает представление отбора для варианта дополнения выгрузки по сценарию узла.
// См. описание "ВариантДополнительно" в процедуре "НастроитьИнтерактивнуюВыгрузку".
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого определяется представление отбора.
//     Параметры  - Структура        - Характеристики отбора. Содержит поля:
//         ИспользоватьПериодОтбора - Булево            - флаг того, что необходимо использовать общий отбор по периоду.
//         ПериодОтбора             - СтандартныйПериод - значение периода общего отбора.
//         Отбор                    - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию
//                                                        узла.
//                                                        Содержит колонки:
//                 ПолноеИмяМетаданных - Строка                - полное имя метаданных регистрируемого объекта, отбор
//                                                               которого описывает строка.
//                                                               Например "Документ._ДемоПоступлениеТоваров". Могут
//                                                               быть использованы специальные  значения "ВсеДокументы"
//                                                               и "ВсеСправочники" для отбора соответственно всех
//                                                               документов и всех справочников, регистрирующихся на
//                                                               узле Получатель.
//                 ВыборПериода        - Булево                - флаг того, что данная строка описывает отбор с общим
//                                                               периодом.
//                 Период              - СтандартныйПериод     - значение периода общего отбора для метаданных строки.
//                 Отбор               - ОтборКомпоновкиДанных - поля отбора. Поля отбора формируются в соответствии с
//                                                               общим правилами формирования полей компоновки.
//                                                               Например, для указания отбора по реквизиту документа
//                                                               "Организация", будет использовано поле
//                                                               "Ссылка.Организация".
//
// Возвращаемое значение: 
//     Строка - описание отбора.
//
Функция ПредставлениеОтбораИнтерактивнойВыгрузки(Получатель, Параметры) Экспорт
	

	Возврат "";
КонецФункции

// Расчет параметров выгрузки по умолчанию.
//
// Параметры:
//     Получатель - ПланОбменаСсылка - Узел, для которого производится настройка.
//
// Возвращаемое значение - Структура - содержит поля:
//     ПредставлениеОтбора - Строка - текстовое описание отбора по умолчанию.
//     Период              - СтандартныйПериод     - значение периода общего отбора по умолчанию.
//     Отбор               - ОтборКомпоновкиДанных - отбор.
//
Функция ПараметрыВыгрузкиПоУмолчанию(Получатель)
	
	Результат = Новый Структура;
	Возврат Результат;
КонецФункции

// Возвращает список организаций по таблице отбора (см "ПредставлениеОтбораИнтерактивнойВыгрузки").
// Также используется из демонстрационной формы "НастройкаВыгрузки" этого плана обмена.
//
// Параметры:
//     ТаблицаОтбора - ТаблицаЗначений   - содержит строки с описанием подробных отборов по сценарию узла. Содержит
//                                         колонки:
//         ПолноеИмяМетаданных - Строка
//         ВыборПериода        - Булево
//         Период              - СтандартныйПериод
//         Отбор               - ОтборКомпоновкиДанных
//
// Возвращаемое значение:
//     СписокЗначений - значение - ссылка на организацию, представление - наименование.
//
Функция ОрганизацииОтбораИнтерактивнойВыгрузки(Знач ТаблицаОтбора) Экспорт
	
	Результат = Новый СписокЗначений;
	Возврат Результат;
КонецФункции


#КонецОбласти

#Область Прочее

// Позволяет переопределить настройки плана обмена, заданные по умолчанию.
// Значения настроек по умолчанию см. в ОбменДаннымиСервер.НастройкиПланаОбменаПоУмолчанию.
// 
// Параметры:
//      Настройки - Структура - Содержит настройки по умолчанию.
//      ИдентификаторНастройки          - Строка - имя дополнительной настройки обмена.
//
Процедура ОпределитьНастройки(Настройки, ИдентификаторНастройки) Экспорт
	
	Настройки.ПредупреждатьОНесоответствииВерсийПравилОбмена = Ложь;
	Настройки.Вставить("ЭтоПланОбменаXDTO", Истина);
	Если ИдентификаторНастройки = "ТолькоОтправка" Тогда
		
		Настройки.Вставить("ЗаголовокКомандыДляСозданияНовогоОбменаДанными", НСтр("ru = 'Отправка данных'"));
		Настройки.Вставить("ЗаголовокПомощникаСозданияОбмена",               НСтр("ru = 'Отправка данных в СП (настройка)'"));
		Настройки.Вставить("ЗаголовокУзлаПланаОбмена",                       НСтр("ru = 'Отправка данных в СП'"));
		
		Настройки.ОтображатьЗначенияПоУмолчаниюНаУзле = Ложь;
		
	ИначеЕсли ИдентификаторНастройки = "ТолькоПолучение" Тогда
		
		Настройки.Вставить("ЗаголовокКомандыДляСозданияНовогоОбменаДанными", НСтр("ru = 'Получение данных'"));
		Настройки.Вставить("ЗаголовокПомощникаСозданияОбмена",               НСтр("ru = 'Получение данных из СП (настройка)"));
		Настройки.Вставить("ЗаголовокУзлаПланаОбмена",                       НСтр("ru = 'Получение данных из СП'"));
		
		Настройки.ОтображатьНастройкуОтборовНаУзле = Ложь;
		
	ИначеЕсли ИдентификаторНастройки = "Двухсторонний" Тогда
		
		Настройки.Вставить("ЗаголовокКомандыДляСозданияНовогоОбменаДанными", НСтр("ru = 'Полная синхронизация'"));
		Настройки.Вставить("ЗаголовокПомощникаСозданияОбмена",               НСтр("ru = 'Синхронизация данных с СП (настройка)"));
		Настройки.Вставить("ЗаголовокУзлаПланаОбмена",                       НСтр("ru = 'Синхронизация данных с СП'"));
		
	Иначе
		Настройки.Вставить("НаименованиеКонфигурацииКорреспондента", НСтр("ru = 'Совместные покупки Через формат SP'"));
	КонецЕсли;
	Настройки.ОтображатьЗначенияПоУмолчаниюНаУзле = Ложь;
	Настройки.ОтображатьНастройкуОтборовНаУзле = Ложь;
	Настройки.ВариантыНастроекОбмена = МассивДоступныхВариантовНастроекОбмена();
	
КонецПроцедуры

// Возвращает имя файла настроек по умолчанию;
// В этот файл будут выгружены настройки обмена для приемника;
// Это значение должно быть одинаковым в плане обмена источника и приемника.
// 
// Параметры:
//  Нет.
// 
// Возвращаемое значение:
//  Строка, 255 - имя файла по умолчанию для выгрузки настроек обмена данными.
//
Функция ИмяФайлаНастроекДляПриемника() Экспорт
	
	Возврат НСтр("ru = 'Синхронизация данных через формат sample-package'");
	
КонецФункции

// Возвращает пользовательскую форму для создания начального образа базы.
// Эта форма будет открыта после завершения настройки обмена с помощью помощника.
// Для планов обмена не РИБ функция возвращает пустую строку.
//
// Возвращаемое значение:
//  Строка, неограниченной длины - имя формы.
//
// Например:
//  Возврат "ПланОбмена._ДемоРаспределеннаяИнформационнаяБаза.Форма.ФормаСозданияНачальногоОбраза";
//
Функция ИмяФормыСозданияНачальногоОбраза() Экспорт
	
	Возврат "";
	
КонецФункции

// Определяет, будет ли использоваться помощник для создания новых узлов плана обмена.
//
// Возвращаемое значение:
//  Булево - признак использования помощника.
//
Функция ИспользоватьПомощникСозданияОбменаДанными() Экспорт
	
	Возврат Истина;
	
КонецФункции

// Возвращает возможность использование данного плана обмена в модели сервиса.
 //
Функция ПланОбменаИспользуетсяВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает признак того, что план обмена поддерживает обмен данными с корреспондентом, работающим в модели сервиса.
// Если признак установлен, то становится возможным создать обмен данными когда эта информационная база
// работает в локальном режиме, а корреспондент в модели сервиса.
//
Функция КорреспондентВМоделиСервиса() Экспорт
	
	Возврат Ложь;
	
КонецФункции

// Возвращает массив используемых транспортов сообщений для этого плана обмена.
//
// 1. Например, если план обмена поддерживает только два транспорта сообщений FILE и FTP,
// то тело функции следует определить следующим образом:
//
//	Результат = Новый Массив;
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
//	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
//	Возврат Результат;
//
// 2. Например, если план обмена поддерживает все транспорты сообщений, определенных в конфигурации,
// то тело функции следует определить следующим образом:
//
//	Возврат ОбменДаннымиСервер.ВсеТранспортыСообщенийОбменаКонфигурации();
//
// Возвращаемое значение:
//  Массив - массив содержит значения перечисления ВидыТранспортаСообщенийОбмена.
//
Функция ИспользуемыеТранспортыСообщенийОбмена() Экспорт
	
	Результат = Новый Массив;
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FILE);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.FTP);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.EMAIL);
	Результат.Добавить(Перечисления.ВидыТранспортаСообщенийОбмена.WS);
	
	Возврат Результат;
	
КонецФункции

// Возвращает режим запуска, в случае интерактивного инициирования синхронизации.
// Возвращаемые значения АвтоматическаяСинхронизация Или ИнтерактивнаяСинхронизация.
// На основании этих значений запускается либо помощник интерактивного обмена, либо автообмен.
Функция РежимЗапускаСинхронизацииДанных(УзелИнформационнойБазы) Экспорт

	Если УзелИнформационнойБазы.РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию
		Или (УзелИнформационнойБазы.РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать
		И УзелИнформационнойБазы.РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию) Тогда
		
		Возврат "АвтоматическаяСинхронизация";
		
	Иначе
		
		Возврат "ИнтерактивнаяСинхронизация";
		
	КонецЕсли;
	
КонецФункции

// Возвращает сценарий работы помощника интерактивного сопоставления
// НеОтправлять, ИнтерактивнаяСинхронизацияДокументов, ИнтерактивнаяСинхронизацияСправочников либо пустую строку.
Функция ИнициализироватьСценарийРаботыПомощникаИнтерактивногоОбмена(УзелИнформационнойБазы) Экспорт
	
	Если УзелИнформационнойБазы.РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьВручную Тогда
		
		Возврат "ИнтерактивнаяСинхронизацияДокументов";
		
	ИначеЕсли УзелИнформационнойБазы.РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать
		И УзелИнформационнойБазы.РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать Тогда
		
		Возврат "НеОтправлять";
		
	ИначеЕсли (УзелИнформационнойБазы.РежимВыгрузкиДокументов = Перечисления.РежимыВыгрузкиОбъектовОбмена.НеВыгружать
		И УзелИнформационнойБазы.РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПриНеобходимости)
		Или УзелИнформационнойБазы.РежимВыгрузкиСправочников = Перечисления.РежимыВыгрузкиОбъектовОбмена.ВыгружатьПоУсловию Тогда
		
		Возврат "ИнтерактивнаяСинхронизацияСправочников";
		
	КонецЕсли;
	
КонецФункции

// Функция возвращает имя обработки выгрузки данных.
//
Функция ИмяОбработкиВыгрузки() Экспорт
	
	// Не используется. Вызывается только в обработке КОИБ, которая не применяется для данного плана обмена.
	Возврат "";
	
КонецФункции // ИмяОбработкиВыгрузки()

// Функция возвращает имя обработки загрузки.
//
Функция ИмяОбработкиЗагрузки() Экспорт
	
	// Не используется. Вызывается только в обработке КОИБ, которая не применяется для данного плана обмена.
	Возврат "";
	
КонецФункции // ИмяОбработкиЗагрузки()

// Возвращает имена реквизитов и табличных частей плана обмена, перечисленных через запятую,
// которые являются общими для пары обменивающихся конфигураций.
//
// Параметры:
//	ВерсияКорреспондента - Строка - Номер версии корреспондента. Используется, например, для разного
//									состава общих данных узлов в зависимости от версии корреспондента.
//	ИмяФормы - Строка - Имя используемой формы настройки значений по умолчанию.
//						Возможно, например, использование различных форм для разных версий корреспондента.
//
// Возвращаемое значение:
//	Строка - Список имен реквизитов.
//
Функция ОбщиеДанныеУзлов(ВерсияКорреспондента, ИмяФормы) Экспорт
	
	Возврат "";
	
КонецФункции

// Предназначена для точной идентификации имени этой конфигурации при настройке 
// синхронизации данных в модели сервиса.
// В случае если данная конфигурация разработана на основе оригинальной конфигурации
// и должна поддерживать обмен с другими прикладными решениями с помощью плана обмена,
// взятого из оригинальной конфигурации, то следует вернуть имя оригинальной конфигурации.
// Например, для конфигурации МояБухгалтерия, которая является доработанной конфигурацией БухгалтерияПредприятия,
// следует вернуть БухгалтерияПредприятия.
//
// Используется только для планов обмена в модели сервиса.
//
// Возвращаемое значение:
//	Строка - имя этой или другой конфигурации, от имени которой выполняется обмен данными
//			(имя конфигурации как задано в метаданных).
//
// Пример:
//  Возврат "БухгалтерияПредприятия";
//
Функция ИмяКонфигурацииИсточника() Экспорт
 
	// В демонстрационной конфигурации значение хранится в константе
	// _ДемоИмяКонфигурацииВОбменеСБиблиотекойСтандартныхПодсистем.
	// Это связано с необходимостью настройки обмена между идентичными конфигурациями "БСП-БСП".
	// Для настройки обмена между различными конфигурациями функция должна возвращать константное значение.
	УстановитьПривилегированныйРежим(Истина);
	Возврат Метаданные.Имя;
 
КонецФункции

#Область ОбработчикиСобытийСинхронизацииДанных

// Обработчик события при подключении к корреспонденту.
// Событие возникает при успешном подключении к корреспонденту и получении версии конфигурации корреспондента
// при настройке обмена с использованием помощника через прямое подключение
// или при подключении к корреспонденту через Интернет.
// В обработчике можно проанализировать версию корреспондента и,
// если настройка обмена не поддерживается с корреспондентом указанной версии, то вызвать исключение.
//
// Параметры:
//	ВерсияКорреспондента - Строка - версия конфигурации корреспондента, например, "2.1.5.1".
//
Процедура ПриПодключенииККорреспонденту(ВерсияКорреспондента) Экспорт
	
КонецПроцедуры

// Обработчик события при отправке данных узла-отправителя.
// Событие возникает при отправке данных узла-отправителя из текущей базы в корреспондент,
// до помещения данных узла в сообщения обмена.
// В обработчике можно изменить отправляемые данные или вовсе отказаться от отправки данных узла.
//
// Параметры:
//	Отправитель - ПланОбменаОбъект, Структура - узел плана обмена, от имени которого выполняется отправка данных.
//	Игнорировать - Булево - признак отказа от выгрузки данных узла.
//							Если в обработчике установить значение этого параметра в Истина,
//							то отправка данных узла выполнена не будет. Значение по умолчанию - Ложь.
//
Процедура ПриОтправкеДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

// Обработчик события при получении данных узла-отправителя.
// Событие возникает при получении данных узла-отправителя,
// когда данные узла прочитаны из сообщения обмена, но не записаны в информационную базу.
// В обработчике можно изменить полученные данные или вовсе отказаться от получения данных узла.
//
// Параметры:
//	Отправитель - ПланОбменаОбъект, Структура - узел плана обмена, от имени которого выполняется получение данных.
//	Игнорировать - Булево - признак отказа от получения данных узла.
//							Если в обработчике установить значение этого параметра в Истина,
//							то получение данных узла выполнена не будет. Значение по умолчанию - Ложь.
//
Процедура ПриПолученииДанныхОтправителя(Отправитель, Игнорировать) Экспорт
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецОбласти

#Область ПрочиеПроцедурыИФункции

Функция МассивДоступныхВариантовНастроекОбмена()
	
	МассивНастроек = Новый Массив();
	
	МассивНастроек.Добавить("ТолькоОтправка");
	МассивНастроек.Добавить("ТолькоПолучение");
	МассивНастроек.Добавить("Двухсторонний");
	
	Возврат МассивНастроек;
	
КонецФункции

#КонецОбласти

#Область ОбменЧерезФормат

// Возвращает ссылку на описание используемого формата обмена;
//
// Возвращаемое значение:
//  Строка, неограниченной длины - ссылка на описание используемого формата обмена данными.
//
Функция ФорматОбмена() Экспорт
	
	Возврат "http://www.100sp.ru";
	
КонецФункции

// Возвращает структуру доступных для данного плана обмена версий формата обмена;
//
// Параметры:
//  ВерсииФормата - структура.
//
// Возвращаемое значение:
//  ВерсииФормата, структура - пара ключ и значение, где в качестве ключа устанавливается доступная версия формата,
//                             а в качестве значения общий модуль с обработчиками обработки данных данной версии формата.
//
Процедура ПолучитьВерсииФорматаОбмена(ВерсииФормата) Экспорт
	ВерсииФормата.Вставить("1.0.0", спМенеджерОбменаЧерезУниверсальныйФормат);
КонецПроцедуры

#КонецОбласти

#КонецОбласти

#КонецЕсли