
&НаКлиенте
Процедура ВыполнитьСверку(Команда)
	ПараметрыОбмена=аСПОбменССайтомСервер.ПолучитьДанныеДляОбмена();
   	ОтправляемыйXMLфайл = КаталогВременныхФайлов()+"dataByDates.xml";
    аСПОбменССайтом.СформироватьФайлЗагрузкиXDTO(ОтправляемыйXMLфайл,ПараметрыОбмена.ПоследняяЗагрузкаУчастников,ПараметрыОбмена.ПоследняяЗагрузкаПокупок,ПараметрыОбмена.ПоследняяЗагрузкаКарты);

КонецПроцедуры
