///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2023, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Раскладывает полное имя физического лица на составные части - фамилию, имя и отчество.
// Если в конце полного имени встречаются "оглы", "улы", "уулу", "кызы" или "гызы",
// то они также считаются частью отчества.
//
// Параметры:
//  ФамилияИмяОтчество - Строка - полное имя в виде "Фамилия Имя Отчество".
//
// Возвращаемое значение:
//  Структура:
//   * Фамилия  - Строка - фамилия;
//   * Имя      - Строка - имя;
//   * Отчество - Строка - отчество.
//
// Пример:
//   1. ФизическиеЛицаКлиентСервер.ЧастиИмени("Иванов Иван Иванович") 
//   вернет структуру со значениями свойств: "Иванов", "Иван", "Иванович".
//   2. ФизическиеЛицаКлиентСервер.ЧастиИмени("Смит Джон") 
//   вернет структуру со значениями свойств: "Смит", "Джон", "".
//   3. ФизическиеЛицаКлиентСервер.ЧастиИмени("Алиев Ахмед Октай оглы") 
//   вернет структуру со значениями свойств: "Алиев", "Ахмед", "Октай оглы".
//
Функция ЧастиИмени(ФамилияИмяОтчество) Экспорт
	
	Результат = Новый Структура("Фамилия,Имя,Отчество");
	
	ЧастиИмени = СтрРазделить(ФамилияИмяОтчество, " ", Ложь); 
	
	КоличествоДополнений = 0;
	
	Если ЧастиИмени.Количество() >= 1 Тогда
		Результат.Фамилия = ЧастиИмени[0];
	КонецЕсли;
	
	Если ЧастиИмени.Количество() >= 2 Тогда
		ПервыеЧастиИмени = Новый Массив;
		ПервыеЧастиИмени.Добавить(НСтр("ru = 'Абдул'"));
		ПервыеЧастиИмени.Добавить(НСтр("ru = 'Абу'"));
		
		Результат.Имя = ЧастиИмени[1];
		Если ПервыеЧастиИмени.Найти(ТРег(ЧастиИмени[1])) <> Неопределено 
			И ЧастиИмени.Количество() >= 3 Тогда
			КоличествоДополнений = КоличествоДополнений + 1;
			Результат.Имя = Результат.Имя + " " + ЧастиИмени[2];
		КонецЕсли;
	КонецЕсли;
	
	Если ЧастиИмени.Количество() >= 3 + КоличествоДополнений Тогда
		Результат.Отчество = ЧастиИмени[2 + КоличествоДополнений];
	КонецЕсли;
	
	Если ЧастиИмени.Количество() > 3 + КоличествоДополнений Тогда
		ДополнительныеЧастиОтчества = Новый Массив;
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'оглы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'улы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'уулу'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'кызы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'гызы'"));
		ДополнительныеЧастиОтчества.Добавить(НСтр("ru = 'угли'"));
		
		Если ДополнительныеЧастиОтчества.Найти(НРег(ЧастиИмени[3 + КоличествоДополнений])) <> Неопределено Тогда
			Результат.Отчество = Результат.Отчество + " " + ЧастиИмени[3 + КоличествоДополнений];
		КонецЕсли;
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции

// Формирует краткое представление из полного имени физического лица.
//
// Параметры:
//  ФамилияИмяОтчество - Строка - полное имя в виде "Фамилия Имя Отчество";
//                     - Структура:
//                        * Фамилия  - Строка - фамилия;
//                        * Имя      - Строка - имя;
//                        * Отчество - Строка - отчество.
//
// Возвращаемое значение:
//  Строка - фамилия и инициалы. Например, "Пупкин В. И.".
//
// Пример:
//  Результат = ФизическиеЛицаКлиентСервер.ФамилияИнициалы("Пупкин Василий Иванович"); 
//  - возвращает "Пупкин В. И.".
//
Функция ФамилияИнициалы(Знач ФамилияИмяОтчество) Экспорт
	
	Если ТипЗнч(ФамилияИмяОтчество) = Тип("Строка") Тогда
		ФамилияИмяОтчество = ЧастиИмени(ФамилияИмяОтчество);
	КонецЕсли;
	
	Фамилия = ФамилияИмяОтчество.Фамилия;
	Имя = ФамилияИмяОтчество.Имя;
	Отчество = ФамилияИмяОтчество.Отчество;
	
	Если ПустаяСтрока(Имя) Тогда
		Возврат Фамилия;
	КонецЕсли;
	
	Если ПустаяСтрока(Отчество) Тогда
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 %2.", Фамилия, Лев(Имя, 1));
	КонецЕсли;
	
	Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("%1 %2. %3.", Фамилия, Лев(Имя, 1), Лев(Отчество, 1));
	
КонецФункции

// Проверяет, верно ли написано ФИО физического лица.
// ФИО считается верным, если содержит только символы национального алфавита, либо только латиницу.
//
// Параметры:
//  ФИО - Строка - фамилия, имя и отчество. Например, "Пупкин Василий Иванович".
//  ТолькоНациональныеСимволы - Булево - при проверке ФИО должна включать только символы национального алфавита.
//
// Возвращаемое значение:
//  Булево - Истина, если ФИО написано верно.
//
Функция ФИОНаписаноВерно(Знач ФИО, ТолькоНациональныеСимволы = Ложь) Экспорт
	
	РезультатПроверки = Истина;
	ФизическиеЛицаКлиентСерверЛокализация.ФИОНаписаноВерно(ФИО, ТолькоНациональныеСимволы, РезультатПроверки);
	
	Возврат РезультатПроверки;
	
КонецФункции

#КонецОбласти
