</head>

<p align="center">
<a href="https://selesnow.github.io/"><img src="https://alexeyseleznev.files.wordpress.com/2017/03/as.png" height="80"></a>
</p>

# rfacebookstat - R пакет для работы с рекламным кабинетом Facebook <a href='https:/selesnow.github.io/rfacebookstat'><img src='https://raw.githubusercontent.com/selesnow/rfacebookstat/master/inst/logo/rfacebookstat.png' align="right" height="139" /></a>

## CRAN

[![Rdoc](http://www.rdocumentation.org/badges/version/rfacebookstat)](http://www.rdocumentation.org/packages/rfacebookstat)
[![rpackages.io rank](http://www.rpackages.io/badge/rfacebookstat.svg)](http://www.rpackages.io/package/rfacebookstat)
[![](https://cranlogs.r-pkg.org/badges/rfacebookstat)](https://cran.r-project.org/package=rfacebookstat)

## For English speaking users

For use inside package manual run: `help( package = "rfacebookstat")`

## Краткое описание.

Пакет для загрузки данных из [Marketing API Facebook](https://developers.facebook.com/docs/marketing-apis?locale=ru_RU) в R, а так же с помощью пакета вы можете управлять доступами пользователей к рекламный аккаунтам на Facebook.

## Достижения

1. rfacebookstat попал в [top 40 пакетов](https://rviews.rstudio.com/2018/09/26/august-2018-top-40-new-packages/), опубликованных на CRAN в августе 2018 года.

## Установка пакета rfacebookstat
Для установки пакета запустите приведённый ниже код в RStudio или R консоли.
Установка из главного репозитория CRAN:
```r
install.packages("rfacebookstat")
```
Устновка наиболее актульной dev версии пакета:
```r
if(!"devtools" %in% installed.packages()[,1]){install.packages("devtools")}
devtools::install_github('selesnow/rfacebookstat')
```

### Пример кода
```
library(rfacebookstat)

# опции
options(rfacebookstat.access_token = "ваш токен",
        rfacebookstat.accounts_id  = "act_000000000",
		rfacebookstat.api_version  = "v3.3",
		rfacebookstat.business_id  = 0000000000)
 
# авторизация в API
# краткосрочный токен
my_st_token <- fbGetToken(app_id = 00000000000000)

# долгосрочный токен
fb_token    <- fbGetLongTimeToken(client_id = 00000000000000,
                                  client_secret = "jdslmfudsfud9sm8fumsd98",
                                  fb_exchange_token = my_st_token)

# Загрузка объектов API
# бизнес менеджеры
my_fb_bm   <- fbGetBusinessManagers()

# проекты из бизнес менеджера
my_fb_proj <- fbGetProjects()
# рекламные аккаунты
my_fb_acc  <- fbGetAdAccounts(source_id = my_fb_bm$id)
# страницы
my_fb_page <- fbGetPages(projects_id = my_fb_proj$id)
# приложения
my_fb_apps <- fbGetApps(projects_id = my_fb_proj$id)

# Объекты рекламного аккаунта
# кампании
my_fb_camp <- fbGetCampaigns()

# группы объявлений
my_fb_adsets <- fbGetAdSets()
# объявления
my_fb_ads    <- fbGetAds()

# контент объявлений
my_fb_ad_content <- fbGetAdCreative()

# загрузка статистики
my_fb_stats <- fbGetMarketingStat(level = "campaign",
                                  fields = "account_name,campaign_name,impressions,clicks",
                                  breakdowns = "device_platform",
                                  date_start = "2018-08-01",
                                  date_stop = "2018-08-07",
                                  interval = "day")


# управление пользователями
fb_acc_user <- fbGetAdAccountUsers()

fbDeleteAdAccountUsers(user_ids = "823041644481205")
```

### Виньетки 
Виньетка посвящённая загрузке статистическим данных из рекламных аккаунтов: `vignette('rfacebookstat-get-statistics', package = 'rfacebookstat')`

### Статьи
1. [Как загрузить статистику рекламных кампаний из API Facebook с помощью языка R](https://netpeak.net/ru/blog/kak-zagruzit-statistiku-reklamnykh-kampanii-iz-api-facebook-s-pomoshch-yu-yazyka-r/)
2. [Как загрузить статистику из рекламных систем в Google BigQuery](https://ppc.world/articles/kak-zagruzit-statistiku-iz-reklamnyh-sistem-v-google-bigquery/)
3. [Импорт данных о расходах в Google Analytics с помощью R](https://analytics-tips.com/import-dannyh-o-raskhodah-v-google-analytics-s-pomoshchyu-r/)

### Ссылки
1. [Документация по работе с пакетом rfacebookstat](https://selesnow.github.io/rfacebookstat/).
2. Баг репорты, предложения по доработке и улучшению функционала rfacebookstat оставлять [тут](https://github.com/selesnow/rfacebookstat/issues). 
3. [Список релизов](https://github.com/selesnow/rfacebookstat/releases).
4. [Группа в Вконтакте](https://vk.com/data_club).

### Автор пакета
Алексей Селезнёв, Head of analytics dept. at [Netpeak](https://netpeak.net)
<Br>Telegram Channel: [R4marketing](https://t.me/R4marketing)
<Br>email: selesnow@gmail.com
<Br>skype: selesnow
<Br>facebook: [facebook.com/selesnow](https://facebook.com/selesnow)
<Br>blog: [alexeyseleznev.wordpress.com](https://alexeyseleznev.wordpress.com/)
