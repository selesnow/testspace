\name{myTarGetStats}
\alias{myTarGetStats}

\title{Get stat by any 'MyTarget API' objects}
\description{Load data frame with statistic by any API objects.}
\usage{
myTarGetStats(date_from   = Sys.Date() - 7,
           date_to     = Sys.Date(), 
           object_type = "campaigns",
           object_id   = NULL, 
           stat_type   = "day",
           metrics     = "base",
           auth        = NULL,
           token_path  = getwd(), 
           login       = NULL) 
}

\arguments{
  \item{date_from}{Start date}
  \item{date_to}{End date}
  \item{object_type}{API object typr, character value, apply one of campaigns, banners,pad_groups,pads,users}
  \item{object_id}{ID of API object (id campaign or any object}
  \item{stat_type}{Time stap, get value day or hour}
  \item{metrics}{Set of metrics, see metrics section for more ditali, default "base", but you can load any of all, base, events, video, viral, uniques, tps, or go this \href{https://target.my.com/adv/api-marketing/doc/stat-v2}{link}}
  \item{auth}{R auth object}
  \item{token_path}{Path to directory where you save credential data}
  \item{login}{Your login, or client name in MyTarget account}
}
\value{
Data frame with statistic.
}

\section{Sets of metrics}{
You can load different sets of metrics, for this use metrics arguments, and set a vector containing the names of the desired metric sets.
For more details go \href{https://target.my.com/adv/api-marketing/doc/stat-v2}{this link}. 
For example: metrics = c("base", "video", "viral")

\strong{base - based metrcis.}
 \describe{
   \item{shows}{Number of impressions}
   \item{clicks}{Number of clicks}
   \item{goals}{Number of goals achieved}
   \item{spent}{Cost sum}
   \item{cpm}{Average cost per 1000 views}
   \item{cpc}{Average cost per click}
   \item{cpa}{Average cost per goals}
   \item{ctr}{Percentage of clicks to views}
   \item{cr}{Percentage ratio of the number of goals achieved to the number of clicks.}
 }
 
\strong{events - metrics for advertised posts on social media feeds.}
 \describe{
   \item{opening_app}{Number of discoveries of the advertised social networks application}
   \item{opening_post}{Number of discoveries of the advertised message in the social media feed}
   \item{moving_into_group}{Number of transitions to the group page from the advertised message}
   \item{clicks_on_external_url}{Number of clicks on the external link in the advertised message}
   \item{launching_video}{Number of video launches in advertised message}
   \item{comments}{Number of comments left in the advertised message}
   \item{joinings}{Number of joining the group through the advertised message}
   \item{likes}{Number of likes of the advertised message}
   \item{shares}{Number of action "Share" for the advertised message.}
   \item{votings}{Number of voting actions in the advertised message}
 }

\strong{uniques - metrics by the number of unique users.}
 \describe{
   \item{reach}{Number of unique users who saw the ad for the specified period}
   \item{total}{Number of unique users who saw an ad for all time}
   \item{increment}{Number of new unique users who saw the ad for the specified period}
   \item{frequency}{Average frequency of displaying ads to one unique user}
 }
 
\strong{video - metrics for video ads.}
 \describe{
   \item{started}{Number of video playback starts}
   \item{paused}{Number of pauses of video playback}
   \item{resumed_after_pause}{Number of video playback after pause}
   \item{fullscreen_on}{Number of full-screen video playbacks}
   \item{fullscreen_off}{Number of shutdowns of full-screen video playback}
   \item{sound_turned_off}{Number of video mute}
   \item{sound_turned_on}{Number of video sound starts}
   \item{viewed_10_seconds}{Number of views of the first 10 seconds of the video}
   \item{viewed_25_percent}{Number of views of the first 25 percent of the video duration}
   \item{viewed_50_percent}{Number of views of the first 50 percent of the video duration}
   \item{viewed_75_percent}{Number of views of the first 75 of the video duration}
   \item{viewed_100_percent}{Number of views 100 percent of the video duration}
   \item{viewed_10_seconds_rate}{Percentage of views with the achievement of the first 10 seconds of the video}
   \item{viewed_25_percent_rate}{Percentage of views with the achievement of the first 25 percent of the video duration}
   \item{viewed_50_percent_rate}{Percentage of views with the achievement of the first 50 percent of the video duration}
   \item{viewed_75_percent_rate}{Percentage of views with the achievement of the first 75 percent of the video duration}
   \item{viewed_100_percent_rate}{Percentage of views with the achievement of the first 100 percent of the video duration}
   \item{depth_of_view}{Average video viewing depth (percent)}
   \item{view_10_seconds_cost}{Average cost of watching the first 10 seconds of a video}
   \item{viewed_25_percent_cost}{Average viewing cost of the first 25 percent of video length}
   \item{viewed_50_percent_cost}{Average viewing cost of the first 50 percent of video length}
   \item{viewed_75_percent_cost}{Average viewing cost of the first 75 percent of video length}
   \item{viewed_100_percent_cost}{Average viewing cost of the first 100 percent of video length}
 }
 
\strong{viral - metrics of viral events.}
 \describe{
   \item{viral_impressions}{Number of impressions of the shared advertising message in social networks}
   \item{viral_reach}{Number of unique users who saw the shared advertising message for the specified period}
   \item{viral_total}{Total number of unique users who have seen the shared advertising message for all time}
   \item{viral_increment}{Number of new unique users who saw the shared advertising message for the specified period}
   \item{viral_frequency}{Average frequency of displaying a shared advertising message to one unique user}
   \item{viral_opening_app}{Number of openings of the advertised application from the shared advertising message}
   \item{viral_opening_post}{Number of discoveries of the shared advertised message in the social media feed}
   \item{viral_moving_into_group}{number of transitions to the group page from the shared advertised message}
   \item{viral_clicks_on_external_url}{Number of clicks on the external link in the shared advertised message}
   \item{viral_launching_video}{Number of video launches in the shared advertised message}
   \item{viral_comments}{Number of comments left in the shared advertised message}
   \item{viral_joinings}{Number of joining the group through the shared advertised message}
   \item{viral_likes}{Number of likes of the shared advertised message}
   \item{viral_shares}{Number of actions "Share" for the shared advertised message}
   \item{viral_votings}{Number of voting actions in the shared advertised message}
 }
 
 \strong{carousel - statistics on individual slides of the advertising carousel (N - from 1 to the number of slides).}
 \describe{
   \item{slide_N_shows}{Number of N slide shows}
   \item{slide_N_clicks}{Number of clicks on slide N}
   \item{slide_N_ctr}{Percentage ratio of clicks to the number of views on slide N}
  }
  
 \strong{tps - additional write-off statistics.}
 \describe{
   \item{tps}{Additional charges for using the moat service}
   \item{tpd}{Additional charges for using third-party data (from dmp).}
  }
  
\strong{moat - statistics according to the moat service.}
 \describe{
   \item{impressions}{Number of impressions}
   \item{in_view}{Number of visible shows}
   \item{never_focused}{Number of impressions in the inactive tab}
   \item{never_visible}{Number of impressions out of sight}
   \item{never_50_perc_visible}{Additional charges for using third-party data (from dmp).}
   \item{never_1_sec_visible}{Number of impressions with visibility duration less than 1 second}
   \item{human_impressions}{Number of verified impressions}
   \item{impressions_analyzed}{number of impressions analyzed}
   \item{in_view_percent}{Number of impressions analyzed}
   \item{human_and_viewable_perc}{Percentage of visible hits}
   \item{never_focused_percent}{Verified impression percentage}
   \item{never_visible_percent}{Impression percentage in inactive tab}
   \item{never_50_perc_visible_percent}{The percentage of orders with a zone of visibility of the ad is less than 50 percent}
   \item{never_1_sec_visible_percent}{Percentage of impressions with visibility duration less than 1 second}
   \item{in_view_diff_percent}{Visible impression difference}
   \item{active_in_view_time}{Average time the ad is in view}
   \item{attention_quality}{Engagement level}
  }
}

\author{
Alexey Seleznev
}
\seealso{
MyTarget API documentation - https://target.my.com/doc/api/detailed/#resource_statistics
}
\examples{
\dontrun{
# base metrics by campaigns
base_data <- myTarGetTotalData(date_from   = Sys.Date() - 7,
                               date_to     = Sys.Date(),
                               object_type = "campaigns",
                               object_id = camp$id,
                               metrics = "base",
                               stat_type = "day",
                               login = "client_login", 
                               token_path = "D:\\mytarget_token")

# all metrics by campaigns
all_data <- myTarGetTotalData(date_from   = Sys.Date() - 7,
                              date_to     = Sys.Date(),
                              object_type = "campaigns",
                              object_id = camp$id,
                              metrics = "all",
                              stat_type = "day",
                              login = "client_login", 
                              token_path = "D:\\mytarget_token")

# custom set of metric by campaigns
custom_data <- myTarGetTotalData(date_from   = Sys.Date() - 7,
                                 date_to     = Sys.Date(),
                                 object_type = "campaigns",
                                 object_id = camp$id,
                                 metrics = c("base", "tps", "viral"),
                                 stat_type = "day",
                                 login = "client_login", 
                                 token_path = "D:\\mytarget_token")


# if have note objects id, base metrics by ads
base_data2 <- myTarGetStats(date_from   = as.Date("2013-01-01"),
                                date_to     = Sys.Date(),
                                object_type = "banners",
                                metrics = "base",
                                stat_type = "day",
                                login = "client_login", 
                                token_path = "D:\\mytarget_token")
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }% use one of  RShowDoc("KEYWORDS")
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
