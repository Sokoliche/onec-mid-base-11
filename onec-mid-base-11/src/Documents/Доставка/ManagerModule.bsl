 #Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда 
  #Область ПрограммныйИнтерфейс   
  
  Процедура ПриОпределенииНастроекПечати(НастройкиОбъекта) Экспорт	
	  НастройкиОбъекта.ПриДобавленииКомандПечати = Истина;
  КонецПроцедуры
  
  Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	  
	  // Анкета доставки
	  КомандаПечати = КомандыПечати.Добавить();
	  КомандаПечати.Идентификатор = "АнкетаДоставки";
	  КомандаПечати.Представление = НСтр("ru = 'Анкета доставки'");
	  КомандаПечати.Порядок = 5;
	  
	  // Транспортная накладная
	  КомандаПечати = КомандыПечати.Добавить();
	  КомандаПечати.Идентификатор = "ТранспортнаяНакладная";
	  КомандаПечати.Представление = НСтр("ru = 'Транспортная накладная'");
	  КомандаПечати.Порядок = 10;  
	  
	   // Договор доставки docx
	  КомандаПечати = КомандыПечати.Добавить();
	  КомандаПечати.Идентификатор = "Документ.Доставка.ПФ_DOC_ДоговорДоставки";
	  КомандаПечати.МенеджерПечати = "УправлениеПечатью";
	  КомандаПечати.Представление = НСтр("ru = 'Договор доставки docx'");
	  КомандаПечати.Порядок = 15; 
	  
	  //Комплект документов
	  КомандаПечати = КомандыПечати.Добавить();
	  КомандаПечати.Идентификатор = "АнкетаДоставки,ТранспортнаяНакладная";
	  КомандаПечати.Представление = НСтр("ru = 'Комплект документов'");
	  КомандаПечати.Порядок = 25;
	  	  
  КонецПроцедуры
  
  Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	  
	  ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "АнкетаДоставки");
	  Если ПечатнаяФорма <> Неопределено Тогда
		  ПечатнаяФорма.ТабличныйДокумент = ПечатьДоставки(МассивОбъектов, ОбъектыПечати);
		  ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Анкета доставки'");
		  ПечатнаяФорма.ПолныйПутьКМакету = "Документ.Доставка.ПФ_MXL_АнкетаДоставки";
	  КонецЕсли;
	  
	  ПечатнаяФорма = УправлениеПечатью.СведенияОПечатнойФорме(КоллекцияПечатныхФорм, "ТранспортнаяНакладная");
	  Если ПечатнаяФорма <> Неопределено Тогда
		  ПечатнаяФорма.ТабличныйДокумент = ПечатьТранспортнаяНакладная(МассивОбъектов, ОбъектыПечати);
		  ПечатнаяФорма.СинонимМакета = НСтр("ru = 'Транспортная накладная'");
		  ПечатнаяФорма.ПолныйПутьКМакету = "Документ.Доставка.ПФ_MXL_ТранспортнаяНакладная";
	  КонецЕсли;
	  
  КонецПроцедуры
  
  #КонецОбласти
  
  #Область СлужебныеПроцедурыИФункции
    
  Функция ПечатьДоставки(МассивОбъектов, ОбъектыПечати)
	  
	  ТабличныйДокумент = Новый ТабличныйДокумент;
	  ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_Доставка";
	  
	  Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Доставка.ПФ_MXL_АнкетаДоставки");
	  
	  ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);
	  
	  ПервыйДокумент = Истина;
	  
	  Пока ДанныеДокументов.Следующий() Цикл
		  
		  Если Не ПервыйДокумент Тогда
			  // Все документы нужно выводить на разных страницах.
			  ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		  КонецЕсли;
		  
		  ПервыйДокумент = Ложь;
		  
		  НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		  
		  ВывестиЗаголовокДоставки(ДанныеДокументов, ТабличныйДокумент, Макет);	
		  ВывестиТабличнуюЧастьДоставки(ДанныеДокументов, ТабличныйДокумент, Макет);				
		  // В табличном документе необходимо задать имя области, в которую был 
		  // выведен объект. Нужно для возможности печати комплектов документов.
		  УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
		  НомерСтрокиНачало, ОбъектыПечати, ДанныеДокументов.Ссылка);		
		  
	  КонецЦикла;	
	  
	  Возврат ТабличныйДокумент;
	  
  КонецФункции  
  
  Функция ПечатьТранспортнаяНакладная(МассивОбъектов, ОбъектыПечати)
	  
	  ТабличныйДокумент = Новый ТабличныйДокумент;
	  ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ТранспортнаяНакладная";
	  
	  Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.Доставка.ПФ_MXL_ТранспортнаяНакладная");
	  
	  ДанныеДокументов = ПолучитьДанныеДокументов(МассивОбъектов);
	  
	  ПервыйДокумент = Истина;
	  
	  Пока ДанныеДокументов.Следующий() Цикл
		  
		  Если Не ПервыйДокумент Тогда
			  // Все документы нужно выводить на разных страницах.
			  ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		  КонецЕсли;
		  
		  ПервыйДокумент = Ложь;
		  
		  НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		  
		  ВывестиЗаголовокТранспортнаяНакладная(ДанныеДокументов, ТабличныйДокумент, Макет);
		  
		  ВывестиШапкуТЧТранспортнаяйНакладная(ДанныеДокументов, ТабличныйДокумент, Макет);
		  
		  ВывестиСтрокиТранспортнаяНакладная(ДанныеДокументов, ТабличныйДокумент, Макет);
		  
		  ВывестиПодвалТранспортнаяНакладная(ДанныеДокументов, ТабличныйДокумент, Макет);
		  
		  // В табличном документе необходимо задать имя области, в которую был 
		  // выведен объект. Нужно для возможности печати комплектов документов.
		  УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, 
		  НомерСтрокиНачало, ОбъектыПечати, ДанныеДокументов.Ссылка);		
		  
	  КонецЦикла;	
	  
	  Возврат ТабличныйДокумент;
	  
  КонецФункции
  
  Функция ПолучитьДанныеДокументов(МассивОбъектов)
	  
	  Запрос = Новый Запрос;
	  Запрос.Текст = "ВЫБРАТЬ
	                 |	ДР_Доставка.Ссылка КАК Ссылка,
	                 |	ДР_Доставка.Номер КАК Номер,
	                 |	ДР_Доставка.Дата КАК Дата,
	                 |	ДР_Доставка.Организация КАК Организация,
	                 |	ДР_Доставка.Контрагент КАК Контрагент,
	                 |	ДР_Доставка.Договор КАК Договор,
	                 |	ДР_Доставка.Основание КАК Основание,
	                 |	ДР_Доставка.Ответственный КАК Ответственный,
	                 |	ДР_Доставка.Комментарий КАК Комментарий,
	                 |	ДР_Доставка.Товары.(
	                 |		Ссылка КАК Ссылка,
	                 |		НомерСтроки КАК НомерСтроки,
	                 |		Номенклатура КАК Номенклатура,
	                 |		Количество КАК Количество
	                 |	) КАК Товары
	                 |ИЗ
	                 |	Документ.Доставка КАК ДР_Доставка
	                 |ГДЕ
	                 |	ДР_Доставка.Ссылка В(&МассивОбъектов)";
	  
	  Запрос.УстановитьПараметр("МассивОбъектов", МассивОбъектов);
	  
	  Возврат Запрос.Выполнить().Выбрать();
	  
  КонецФункции 
  
  //Доставка
  Процедура ВывестиЗаголовокДоставки(ДанныеДокументов, ТабличныйДокумент, Макет)
	  
	  ОбластьЗаголовокДоставки = Макет.ПолучитьОбласть("Заголовок");
	  
	  ДанныеПечати = Новый Структура;
	  
	  ШаблонЗаголовка = "Анкета о доставке № %1 от %2";
	  ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка,
	  ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокументов.Номер),
	  Формат(ДанныеДокументов.Дата, "ДЛФ=DD"));
	  ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
	  
	  ОбластьЗаголовокДоставки.Параметры.Заполнить(ДанныеПечати);
	  
	  СтрокаСсылки = ПолучитьНавигационнуюСсылку(ДанныеДокументов.Ссылка); 
	  ДанныеQRКода = ГенерацияШтрихкода.ДанныеQRКода(СтрокаСсылки, 1, 140);
	  
	  Если НЕ ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
		  ТекстСообщения = НСтр("ru = 'Не удалось сформировать QR-код.
		  |Технические подробности см. в журнале регистрации.'");
		  ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	  Иначе
		  КартинкаQRКода = Новый Картинка(ДанныеQRКода);
		  ОбластьЗаголовокДоставки.Рисунки.МашинноЧитаемыйКод.Картинка = КартинкаQRКода;
	  КонецЕсли;  
	  
	  ТабличныйДокумент.Вывести(ОбластьЗаголовокДоставки);
	  
  КонецПроцедуры
  
  Процедура ВывестиТабличнуюЧастьДоставки(ДанныеДокументов, ТабличныйДокумент, Макет)
	  
	  ОбластьТабличнойЧастиДоставки = Макет.ПолучитьОбласть("ТабличнаяЧасть");
	  
	  ТабличныйДокумент.Вывести(ОбластьТабличнойЧастиДоставки);
	  
  КонецПроцедуры

  //Транспортная накладная
  Процедура ВывестиЗаголовокТранспортнаяНакладная(ДанныеДокументов, ТабличныйДокумент, Макет)
	  
	  ОбластьЗаголовокТН = Макет.ПолучитьОбласть("Заголовок");
	  ОбластьЗаголовокТН.Параметры.Отправитель = ДанныеДокументов.Организация;
	  ОбластьЗаголовокТН.Параметры.Получатель = ДанныеДокументов.Контрагент; 
	  
	  ДанныеПечати = Новый Структура;
	  
	  ШаблонЗаголовка = "Транспортная накладная № %1 от %2";
	  ТекстЗаголовка = СтрШаблон(ШаблонЗаголовка,
	  ПрефиксацияОбъектовКлиентСервер.НомерНаПечать(ДанныеДокументов.Номер),
	  Формат(ДанныеДокументов.Дата, "ДЛФ=DD"));
	  ДанныеПечати.Вставить("ТекстЗаголовка", ТекстЗаголовка);
	  
	  ОбластьЗаголовокТН.Параметры.Заполнить(ДанныеПечати);
	  
	  СтрокаСсылки = ПолучитьНавигационнуюСсылку(ДанныеДокументов.Ссылка); 
	  ДанныеQRКода = ГенерацияШтрихкода.ДанныеQRКода(СтрокаСсылки, 1, 120);
	  
	  Если НЕ ТипЗнч(ДанныеQRКода) = Тип("ДвоичныеДанные") Тогда
		  ТекстСообщения = НСтр("ru = 'Не удалось сформировать QR-код.
		  |Технические подробности см. в журнале регистрации.'");
		  ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	  Иначе
		  КартинкаQRКода = Новый Картинка(ДанныеQRКода);
		  ОбластьЗаголовокТН.Рисунки.МашинноЧитаемыйКод.Картинка = КартинкаQRКода;
	  КонецЕсли; 
	  
	  ТабличныйДокумент.Вывести(ОбластьЗаголовокТН); 	
	  
  КонецПроцедуры
  
  Процедура ВывестиШапкуТЧТранспортнаяйНакладная(ДанныеДокументов, ТабличныйДокумент, Макет)
	  
	  ОбластьШапкиТЧ = Макет.ПолучитьОбласть("ШапкаТаблицы");
	  
	  ТабличныйДокумент.Вывести(ОбластьШапкиТЧ);
	  
  КонецПроцедуры
  
  Процедура ВывестиСтрокиТранспортнаяНакладная(ДанныеДокументов, ТабличныйДокумент, Макет)
	  
	  ОбластьСтрокаТЧ = Макет.ПолучитьОбласть("Строка");
	  
	  ВыборкаТовары = ДанныеДокументов.Товары.Выбрать();
	  Пока ВыборкаТовары.Следующий() Цикл
		  ОбластьСтрокаТЧ.Параметры.Заполнить(ВыборкаТовары);
		  ТабличныйДокумент.Вывести(ОбластьСтрокаТЧ);
	  КонецЦикла;
	  
  КонецПроцедуры
  
  Процедура ВывестиПодвалТранспортнаяНакладная(ДанныеДокументов, ТабличныйДокумент, Макет)
	  
	  ОбластьПодвалаТН = Макет.ПолучитьОбласть("Подвал");
	  
	  ТабличныйДокумент.Вывести(ОбластьПодвалаТН);
	  
  КонецПроцедуры
  
  #КонецОбласти
  
  #КонецЕсли