
#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ОбработчикиСобытий
Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка) 

	Если ТипЗнч(ДанныеЗаполнения) = Тип("ДокументСсылка.РеализацияТоваровУслуг") Тогда
		// Заполнение шапки
		Запрос = Новый Запрос;
		Запрос.Текст =
			"ВЫБРАТЬ
			|	РеализацияТоваровУслуг.Ссылка,
			|	РеализацияТоваровУслуг.Договор,
			|	РеализацияТоваровУслуг.Комментарий,
			|	РеализацияТоваровУслуг.Контрагент,
			|	РеализацияТоваровУслуг.Организация,
			|	РеализацияТоваровУслуг.Основание,
			|	РеализацияТоваровУслугТовары.Номенклатура,
			|	РеализацияТоваровУслугТовары.Количество КАК Количество,
			|	РеализацияТоваровУслуг.Ответственный
			|ИЗ
			|	Документ.РеализацияТоваровУслуг.Товары КАК РеализацияТоваровУслугТовары
			|		ЛЕВОЕ СОЕДИНЕНИЕ Документ.РеализацияТоваровУслуг КАК РеализацияТоваровУслуг
			|		ПО РеализацияТоваровУслугТовары.Ссылка = РеализацияТоваровУслуг.Ссылка
			|ГДЕ
			|	РеализацияТоваровУслуг.Ссылка = &Ссылка";
		
		Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		
		ВыборкаДетальныеЗаписи = РезультатЗапроса.Выбрать();
		
		Пока ВыборкаДетальныеЗаписи.Следующий() Цикл
			Договор = ВыборкаДетальныеЗаписи.Договор;
		Комментарий = ВыборкаДетальныеЗаписи.Комментарий;
		Контрагент = ВыборкаДетальныеЗаписи.Контрагент;
		Организация = ВыборкаДетальныеЗаписи.Организация;
		Ответственный = ВыборкаДетальныеЗаписи.Ответственный;
		Основание = ВыборкаДетальныеЗаписи.Ссылка;
			Если ЗначениеЗаполнено(ВыборкаДетальныеЗаписи.Номенклатура) Тогда
			НоваяСтрока = Товары.Добавить();
			НоваяСтрока.Количество = ВыборкаДетальныеЗаписи.Количество;
			НоваяСтрока.Номенклатура = ВыборкаДетальныеЗаписи.Номенклатура;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли


