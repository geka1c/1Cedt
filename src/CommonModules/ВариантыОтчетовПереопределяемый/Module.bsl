#Область ПрограммныйИнтерфейс

// Задает настройки, применяемые как умолчания для объектов подсистемы.
//
// Параметры:
//   Настройки - Структура - Коллекция настроек подсистемы. Реквизиты:
//       * ВыводитьОтчетыВместоВариантов - Булево - Умолчание для вывода гиперссылок в панели отчетов:
//           Истина - Варианты отчетов по умолчанию скрыты, а отчеты включены и видимы.
//           Ложь   - Варианты отчетов по умолчанию видимы, а отчеты отключены.
//           Значение по умолчанию: Ложь.
//       * ВыводитьОписания - Булево - Умолчание для вывода описаний в панели отчетов:
//           Истина - Значение по умолчанию. Выводить описания в виде подписей под гиперссылками вариантов
//           Ложь   - Выводить описания в виде всплывающих подсказок
//           Значение по умолчанию: Истина.
//       * Поиск - Структура - Настройки поиска вариантов отчетов.
//           ** ПодсказкаВвода - Строка - Текст подсказки выводится в поле поиска когда поиск не задан.
//               В качестве примера рекомендуется указывать часто используемые термины прикладной конфигурации.
//       * ДругиеОтчеты - Структура - Настройки формы "Другие отчеты":
//           ** ЗакрыватьПослеВыбора - Булево - Закрывать ли форму после выбора гиперссылки отчета.
//               Истина - Закрывать "Другие отчеты" после выбора.
//               Ложь   - Не закрывать.
//               Значение по умолчанию: Истина.
//           ** ПоказыватьФлажок - Булево - Показывать ли флажок ЗакрыватьПослеВыбора.
//               Истина - Показывать флажок "Закрывать это окно после перехода к другому отчету".
//               Ложь   - Не показывать флажок.
//               Значение по умолчанию: Ложь.
//       * РазрешеноИзменятьВарианты - Булево - Показывать расширенные настройки отчета
//               и команды изменения варианта отчета.
//
// Пример:
//	Настройки.Поиск.ПодсказкаВвода = НСтр("ru = 'Например, себестоимость'");
//	Настройки.ДругиеОтчеты.ЗакрыватьПослеВыбора = Ложь;
//	Настройки.ДругиеОтчеты.ПоказыватьФлажок = Истина;
//	Настройки.РазрешеноИзменятьВарианты = Ложь;
//
Процедура ПриОпределенииНастроек(Настройки) Экспорт
	Настройки.ВыводитьОтчетыВместоВариантов = Истина;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Настройки размещения отчетов

// Определяет разделы глобального командного интерфейса, в которых предусмотрены панели отчетов.
// В Разделы необходимо добавить метаданные тех подсистем первого уровня,
// в которых размещены команды вызова панелей отчетов.
//
// Параметры:
//   Разделы - СписокЗначений - разделы, в которые выведены команды открытия панели отчетов.
//       * Значение - ОбъектМетаданных: Подсистема, Строка - подсистема раздела глобального командного интерфейса,
//           либо ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы для начальной страницы.
//       * Представление - Строка - заголовок панели отчетов в этом разделе.
//
// Пример:
//	Разделы.Добавить(Метаданные.Подсистемы.Анкетирование, НСтр("ru = 'Отчеты по анкетированию'"));
//	Разделы.Добавить(ВариантыОтчетовКлиентСервер.ИдентификаторНачальнойСтраницы(), НСтр("ru = 'Основные отчеты'"));
//
Процедура ОпределитьРазделыСВариантамиОтчетов(Разделы) Экспорт
	Разделы.Добавить(Метаданные.Подсистемы.Транзит,           НСтр("ru = 'Отчеты по транзитам'"));	
	Разделы.Добавить(Метаданные.Подсистемы.Склад,       	  НСтр("ru = 'Отчеты по складу'"));	
	Разделы.Добавить(Метаданные.Подсистемы.Возвраты,       	  НСтр("ru = 'Отчеты по возвратам'"));	
	Разделы.Добавить(Метаданные.Подсистемы.ОбменДаными,       НСтр("ru = 'Отчеты по обменам'"));	
	Разделы.Добавить(Метаданные.Подсистемы.Предприятие,    	  НСтр("ru = 'Отчеты по предприятию'"));
	Разделы.Добавить(Метаданные.Подсистемы.Выдача,    		  НСтр("ru = 'Отчеты по выдаче'"));	
КонецПроцедуры

// Задает настройки размещения вариантов отчетов в панели отчетов.
//   Отчет выступает в качестве контейнера вариантов.
//     Изменяя настройки отчета можно сразу изменять настройки всех его вариантов.
//     Однако, если явно получить настройки варианта отчета, то они станут самостоятельными,
//     т.е. более не будут наследовать изменения настроек от отчета.
//   
//   Начальная настройка размещения отчетов по подсистемам зачитывается из метаданных,
//     ее дублирование в коде не требуется.
//   
//   Функциональные опции варианта объединяются с функциональными опциями этого отчета по следующим правилам:
//     (ФО1_Отчета ИЛИ ФО2_Отчета) И (ФО3_Варианта ИЛИ ФО4_Варианта).
//   Функциональные опции отчетов не зачитываются из метаданных,
//     они применяются на этапе использования подсистемы пользователем.
//   Через ОписаниеОтчета можно добавлять функциональные опции, которые будут соединяться по указанным выше правилам,
//     но надо помнить, что эти функциональные опции будут действовать только для предопределенных вариантов отчетов.
//   Для пользовательских вариантов отчета действуют только функциональные опции отчета
//     - они отключаются только с отключением всего отчета.
//
// Параметры:
//   Настройки - Коллекция - настройки отчетов и вариантов отчетов конфигурации.
//                           Для их изменения предназначены следующие вспомогательные процедуры и функции:
//                           ВариантыОтчетов.ОписаниеОтчета, 
//                           ВариантыОтчетов.ОписаниеВарианта, 
//                           ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов, 
//                           ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера.
//
// Пример:
//
//  //Добавление варианта отчета в подсистему.
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Размещение.Вставить(Метаданные.Подсистемы.ИмяРаздела.Подсистемы.ИмяПодсистемы);
//
//  //Отключение варианта отчета.
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Включен = Ложь;
//
//  //Отключение всех вариантов отчета, кроме одного.
//	НастройкиОтчета = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	НастройкиОтчета.Включен = Ложь;
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, НастройкиОтчета, "<ИмяВарианта>");
//	НастройкиВарианта.Включен = Истина;
//
//  //Заполнение настроек для поиска - наименования полей, параметров и отборов:
//	НастройкиВарианта = ВариантыОтчетов.ОписаниеВарианта(Настройки, Метаданные.Отчеты.ИмяОтчетаБезСхемы, "");
//	НастройкиВарианта.НастройкиДляПоиска.НаименованияПолей =
//		НСтр("ru = 'Контрагент
//		|Договор
//		|Ответственный
//		|Скидка
//		|Дата'");
//	НастройкиВарианта.НастройкиДляПоиска.НаименованияПараметровИОтборов =
//		НСтр("ru = 'Период
//		|Ответственный
//		|Контрагент
//		|Договор'");
//
//  //Переключение режима вывода в панелях отчетов:
//  //Группировка вариантов отчета по этому отчету:
//	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Метаданные.Отчеты.ИмяОтчета, Истина);
//  //Без группировки по отчету:
//	Отчет = ВариантыОтчетов.ОписаниеОтчета(Настройки, Метаданные.Отчеты.ИмяОтчета);
//	ВариантыОтчетов.УстановитьРежимВыводаВПанеляхОтчетов(Настройки, Отчет, Ложь);
//
Процедура НастроитьВариантыОтчетов(Настройки) Экспорт
	//ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьТранзитов);	
	//ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьДвижений);	
	//ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ОтчетЗаДеньNew);	
	//ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПоискПокупок);
	//ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПродажиЗаДень);
	//ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ПросроченныеПокупки);
	//ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.РасположениеПокупок);
	//ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СверкаРазобранныхКоробокССайтом);
	//ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.СписанныеПокупки);
	//ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьЗаказовНаСкладе);
	//ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьЗаказовЧерезТК);
	//ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВедомостьТранзитов);
	//ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.ВзаиморасчетыСКонтрагентами);
	//ВариантыОтчетов.НастроитьОтчетВМодулеМенеджера(Настройки, Метаданные.Отчеты.КонтрольСупергрупп);	
	
КонецПроцедуры

// Регистрирует изменения в именах вариантов отчетов.
//   Используется при обновлении в целях сохранения ссылочной целостности,
//   в частности для сохранения пользовательских настроек и настроек рассылок отчетов.
//   Старое имя варианта резервируется и не может быть использовано в дальнейшем.
//   Если изменений было несколько, то каждое изменение необходимо зарегистрировать,
//   указывая в актуальном имени варианта последнее (текущее) имя варианта отчета.
//   Поскольку имена вариантов отчетов не выводятся в пользовательском интерфейсе,
//   то рекомендуется задавать их таким образом, что бы затем не менять.
//   В Изменения необходимо добавить описания изменений имен вариантов
//   отчетов, подключенных к подсистеме.
//
// Параметры:
//   Изменения - ТаблицаЗначений - Таблица изменений имен вариантов. Колонки:
//       * Отчет - ОбъектМетаданных - Метаданные отчета, в схеме которого изменилось имя варианта.
//       * СтароеИмяВарианта - Строка - Старое имя варианта, до изменения.
//       * АктуальноеИмяВарианта - Строка - Текущее (последнее актуальное) имя варианта.
//
// Пример:
//	Изменение = Изменения.Добавить();
//	Изменение.Отчет = Метаданные.Отчеты.<ИмяОтчета>;
//	Изменение.СтароеИмяВарианта = "<СтароеИмяВарианта>";
//	Изменение.АктуальноеИмяВарианта = "<АктуальноеИмяВарианта>";
//
Процедура ЗарегистрироватьИзмененияКлючейВариантовОтчетов(Изменения) Экспорт
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Настройки команд отчетов

// Определяет объекты конфигурации, в модулях менеджеров которых предусмотрена процедура ДобавитьКомандыОтчетов,
// описывающая команды открытия контекстных отчетов.
// Синтаксис процедуры ДобавитьКомандыОтчетов см. в документации.
//
// Параметры:
//   Объекты - Массив - объекты метаданных (ОбъектМетаданных) с командами отчетов.
//
Процедура ОпределитьОбъектыСКомандамиОтчетов(Объекты) Экспорт
	
КонецПроцедуры

// Определение списка глобальных команд отчетов.
//   Событие возникает в процессе вызова модуля повторного использования.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица команд для вывода в подменю. Для изменения.
//       * Идентификатор - Строка - Идентификатор команды.
//     
//     Настройки внешнего вида:
//       * Представление - Строка   - Представление команды в форме.
//       * Важность      - Строка   - Суффикс группы в подменю, в которой следует вывести эту команду.
//                                    Допустимо использовать: "Важное", "Обычное" и "СмТакже".
//       * Порядок       - Число    - Порядок размещения команды в группе. Используется для настройки под конкретное
//                                    рабочее место.
//       * Картинка      - Картинка - Картинка команды.
//       * СочетаниеКлавиш - СочетаниеКлавиш - Сочетание клавиш для быстрого вызова команды.
//     
//     Настройки видимости и доступности:
//       * ТипПараметра - ОписаниеТипов - Типы объектов, для которых предназначена эта команда.
//       * ВидимостьВФормах    - Строка - Имена форм через запятую, в которых должна отображаться команда.
//                                        Используется когда состав команд отличается для различных форм.
//       * ФункциональныеОпции - Строка - Имена функциональных опций через запятую, определяющих видимость команды.
//       * УсловияВидимости    - Массив - Определяет видимость команды в зависимости от контекста.
//                                        Для регистрации условий следует использовать процедуру
//                                        ПодключаемыеКоманды.ДобавитьУсловиеВидимостиКоманды().
//                                        Условия объединяются по "И".
//       * ИзменяетВыбранныеОбъекты - Булево - Определяет доступность команды в ситуации,
//                                        когда у пользователя нет прав на изменение объекта.
//                                        Если Истина, то в описанной выше ситуации кнопка будет недоступна.
//                                        Необязательный. Значение по умолчанию: Ложь.
//     
//     Настройки процесса выполнения:
//       * МножественныйВыбор - Булево, Неопределено - Если Истина, то команда поддерживает множественный выбор.
//             В этом случае в параметре выполнения будет передан список ссылок.
//             Необязательный. Значение по умолчанию: Истина.
//       * РежимЗаписи - Строка - Действия, связанные с записью объекта, которые выполняются перед обработчиком команды.
//             ** "НеЗаписывать"          - Объект не записывается, а в параметрах обработчика вместо ссылок передается
//                                       вся форма. В этом режиме рекомендуется работать напрямую с формой,
//                                       которая передается в структуре 2 параметра обработчика команды.
//             ** "ЗаписыватьТолькоНовые" - Записывать новые объекты.
//             ** "Записывать"            - Записывать новые и модифицированные объекты.
//             ** "Проводить"             - Проводить документы.
//             Перед записью и проведением у пользователя запрашивается подтверждение.
//             Необязательный. Значение по умолчанию: "Записывать".
//       * ТребуетсяРаботаСФайлами - Булево - Если Истина, то в веб-клиенте предлагается
//             установить расширение работы с файлами.
//             Необязательный. Значение по умолчанию: Ложь.
//     
//     Настройки обработчика:
//       * Менеджер - Строка - Полное имя объекта метаданных, отвечающего за выполнение команды.
//             Пример: "Отчет._ДемоКнигаПокупок".
//       * ИмяФормы - Строка - Имя формы, которую требуется открыть или получить для выполнения команды.
//             Если Обработчик не указан, то у формы вызывается метод "Открыть".
//       * КлючВарианта - Строка - Имя варианта отчета, открываемого при выполнении команды.
//       * ИмяПараметраФормы - Строка - Имя параметра формы, в который следует передать ссылку или массив ссылок.
//       * ПараметрыФормы - Неопределено, Структура - Параметры формы, указанной в ИмяФормы.
//       * Обработчик - Строка - Описание процедуры, обрабатывающей основное действие команды.
//             Формат "<ИмяОбщегоМодуля>.<ИмяПроцедуры>" используется когда процедура размещена в общем модуле.
//             Формат "<ИмяПроцедуры>" используется в следующих случаях:
//               - Если ИмяФормы заполнено то в модуле указанной формы ожидается клиентская процедура.
//               - Если ИмяФормы не заполнено то в модуле менеджера этого объекта ожидается серверная процедура.
//       * ДополнительныеПараметры - Структура - Параметры обработчика, указанного в Обработчик.
//   
//   Параметры - Структура - Сведения о контексте исполнения.
//       * ИмяФормы - Строка - Полное имя формы.
//   
//   СтандартнаяОбработка - Булево - Если установить в Ложь, то событие "ДобавитьКомандыОтчетов" менеджера объекта не
//                                   будет вызвано.
//
Процедура ПередДобавлениемКомандОтчетов(КомандыОтчетов, Параметры, СтандартнаяОбработка) Экспорт
	
	
	
КонецПроцедуры

#КонецОбласти
