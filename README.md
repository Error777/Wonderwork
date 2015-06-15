# Wonderwork
Штаб по переделыванию зеленого билда на синие нужды.

Сайт: http://ss13.ru/
Репозиторий: https://github.com/BlueCabaret/Wonderwork/
Конференция: spacestation13@conference.jabber.ru

================================================================================
Установка
================================================================================

Первоначальная установка довольно проста. Во-первых, установите BYOND. 
Перейдите по адресу http://www.byond.com/. И для начала извлеките файлы из архива в любое удобное вам место.  
Это исходный код, все последующие действия заключаются в компиляции этого кода.
Откройте baystation12.dme двойным нажатием, откройте меню "Build", и нажмите
"compile".  Ждите пока не появится сообщение в нижней части окна:

saving baystation12.dmb (DEBUG mode)

baystation12.dmb - 0 errors, 0 warnings

Если ошибок или предупреждений больше нуля - перекачайте файлы или попытайтесь починить это говно (НА СВОЙ СТРАХ И РИСК!)

Затем зайдите в папку config.  В файле config.txt можно изменить настройки сервера. 
Мы рекомендумем не трогать своими потными пальчиками файл настройки, если вы ничего в нем не понимаете.

Так же вы можете изменить файл admins.txt для добавления или изымания администраторов, и конечно, себя любимого.  
"Knight" имеет почти полный доступ к флагам и идеален для администраторов, 
Чуть ниже по иерархии стоит "Steward", он идеален для начинающих администраторов и не в состоянии натворить "дел", 
а "Delator" - местная реинкарнация модератора (прав почти нет). Однако, для полного доступа ко всем кнопкам 
вы можете использовать следующие ранги: "Count", "Duke", "King"

Еще раз, кратко:

Бьендкей - Ранг

Бьендкей - это ваш ник во вселенной бьенд, записаный без пробелов, строчными буквами.

Для запуска сервера запустите Dream Daemon и подключите к нему ваш откомпилированный
baystation12.dmb. Выберите любой удобный вам порт, и нажмите в окошке безопасности 'Safe'. 
Нажмите "GO" для запуска и заходите (кнопка "Join")

================================================================================
Обновление
================================================================================

To update an existing installation, first back up your /config and /data folders
as these store your server configuration, player preferences and banlist.

Then, extract the new files (preferably into a clean directory, but updating in
place should work fine), copy your /config and /data folders back into the new
install, overwriting when prompted except if we've specified otherwise, and
recompile the game.  Once you start the server up again, you should be running
the new version.

================================================================================
SQL Setup
================================================================================

The SQL backend for the library and stats tracking requires a 
MySQL server.  Your server details go in /config/dbconfig.txt, and the SQL 
schema is in /SQL/tgstation_schema.sql.  More detailed setup instructions are
coming soon, for now ask in our IRC channel.