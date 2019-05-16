\name{fbGetMarketingStat}
\alias{fbGetMarketingStat}

\title{Get statistic by ad accounts.}
\description{fbGetMarketingStat is main function of rfacebookstat package, intended for load statiscit data by your ad, adset, campaign or account}
\usage{
fbGetMarketingStat(
    accounts_id = getOption("rfacebookstat.accounts_id"), 
    sorting = NULL, level = "account", breakdowns = NULL, 
	action_breakdowns = NULL, 
	fields = "account_id,campaign_name,impressions,clicks,reach,spend",
    filtering = NULL, date_start = Sys.Date() - 30,
    date_stop = Sys.Date(), 
	api_version = getOption("rfacebookstat.api_version"), 
	action_report_time = NULL, interval = "day", 
	console_type = "progressbar", request_speed = "normal", 
	access_token = getOption("rfacebookstat.access_token"))
}
\arguments{
  \item{accounts_id}{ID of your ad account.}
  \item{sorting}{Field to sort the result, and direction of sorting. You can specify sorting direction by appending "_ascending" or "_descending" to the sort field. For example, "reach_descending". This array supports no more than one element. By default, the sorting direction is ascending.}
  \item{level}{Represents the level of result. Avable ad, adset, campaign, account.}
  \item{action_breakdowns}{group results in the actions field. You can use the following breakdowns for action_breakdowns, for details go - https://developers.facebook.com/docs/marketing-api/insights/breakdowns/#actionsbreakdown}
  \item{breakdowns}{Permutations marked with an asterisk (*) can be joined with action_type and action_target_id. Avable age, country, gender, frequency_value, hourly_stats_aggregated_by_advertiser_time_zone, hourly_stats_aggregated_by_audience_time_zone, impression_device, place_page_id, placement, device_platform, product_id, region}
  \item{fields}{List of fields which you want get in R.}
  \item{filtering}{Array of filtring parameters, on example [{/'field/':/'ad.effective_status/',/'operator/':/'IN/',/'value/':[/'ARCHIVED/']}}
  \item{date_start}{Start reporting date.}
  \item{date_stop}{End reporting day}
  \item{request_speed}{Speed beetwen API request, "normal", "fast" or "slow", depend of you API access level.}
  \item{api_version}{Current Facebook API version.}
  \item{action_report_time}{Determines the report time of action stats.}
  \item{interval}{Character value for split by time interval, one of "day", "week", "month", "quarter", "year". By default = "day"}
  \item{console_type}{Character value for manage console output message, one of "progressbar", "message". By default = "progressbar". See more at Detail}
  \item{access_token}{Your facebook API token}
}

\value{Data frame with statistic.}
\details{
Console_type parameters, if chose "progressbar" you can see load progress in percent, and if chose "message" you get message about loading process.
}
\section{Action breackdowns}{
Group results in the actions field. You can use the following breakdowns for action_breakdowns.
Now you can use next action breakdowns:
\describe{
  \item{action_device}{The device on which the conversion event you're tracking occurred. For example, "Desktop" if someone converted on a desktop computer.}
  \item{action_destination}{The destination where people go after clicking on your ad. This could be your Facebook Page, an external URL for your conversion pixel or an app configured with the software development kit (SDK).}
  \item{action_reaction}{The number of reactions on your ads or boosted posts. The reactions button on an ad allows people to share different reactions on its content: Like, Love, Haha, Wow, Sad or Angry.}
  \item{action_target_id}{The id of destination where people go after clicking on your ad. This could be your Facebook Page, an external URL for your conversion pixel or an app configured with the software development kit (SDK).}
  \item{action_type}{The kind of actions taken on your ad, Page, app or event after your ad was served to someone, even if they didn't click on it. Action types include Page likes, app installs, conversions, event responses and more.}
  \item{action_type,action_reaction}{Together of action types and reactions brekdown.}
}
}
 
\author{Alexey Seleznev}

\seealso{
All avable field, and discription of all parameters you can see oh this  \href{https://developers.facebook.com/docs/marketing-api/insights/parameters}{link}.
More information about breakdowns and action brekdowns on this \href{https://developers.facebook.com/docs/marketing-api/insights/breakdowns}{link}.
More information about action field in this \href{https://developers.facebook.com/docs/marketing-api/reference/ads-action-stats/}{documentation}.
}
\examples{
\dontrun{
fbStat <- fbGetMarketingStat(accounts_id = "act_xxxxxxxxxxxxxxx",
                             level = "campaign",
                             fields = "account_name,campaign_name,impressions",
                             breakdowns = "device_platform",
                             date_start = "2016-08-01",
                             date_stop = "2016-08-10",
			     interval = "day",
                             access_token = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
}
}

