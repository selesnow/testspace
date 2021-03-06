yadirGetReport <- function(ReportType        = "CUSTOM_REPORT", 
                           DateRangeType     = "LAST_30_DAYS", 
                           DateFrom          = NULL, 
                           DateTo            = NULL, 
                           FieldNames        = c("CampaignName","Impressions","Clicks","Cost"), 
                           FilterList        = NULL,
                           Goals             = NULL,
                           AttributionModels = NULL,
                           IncludeVAT        = "YES",
                           IncludeDiscount   = "NO",
                           Login             = NULL,
                           AgencyAccount     = NULL,
                           Token             = NULL,
                           TokenPath         = getwd()){
  
  #������ ������� ������ ������ �������
  proc_start <- Sys.time()
  #���������� ������ �����
  Fields <- paste0("<FieldNames>",FieldNames, "</FieldNames>", collapse = "")
  
  #��������� ������
  if(!is.null(FilterList)){
    fil_list <- NA
    filt <- FilterList
    for(fil in filt){
      val <- strsplit(paste0(strsplit(fil ," ")[[1]][3:length(strsplit(fil ," ")[[1]])], collapse = ""), split = ",| |;")[[1]]
      fil_list <- paste0(fil_list[!is.na(fil_list)],
                         paste0("<Filter>",
                                paste0("<Field>",strsplit(fil ," ")[[1]][1], "</Field>"),
                                paste0("<Operator>",strsplit(fil ," ")[[1]][2], "</Operator>"),
                                paste0(paste0("<Values>",val, "</Values>"), collapse = ""),"</Filter>"))
    }}
  
  Goals <- ifelse(is.null(Goals), "", paste0("<Goals>",Goals, "</Goals>", collapse = ""))

  AttributionModels <- ifelse(is.null(AttributionModels), "", paste0("<AttributionModels>",AttributionModels, "</AttributionModels>", collapse = ""))
 
   #��������� ���� �������
  queryBody <- paste0('
                      <ReportDefinition xmlns="http://api.direct.yandex.com/v5/reports">
                      <SelectionCriteria>',
                      ifelse(DateRangeType == "CUSTOM_DATE",paste0("<DateFrom>",DateFrom,"</DateFrom>","<DateTo>",DateTo,"</DateTo>") ,"" ),
                      ifelse(is.null(FilterList),"",fil_list),
                      '
                      </SelectionCriteria>',
                      Goals,AttributionModels,Fields,'
                      <ReportName>',paste0("MyReport ", Sys.time()),'</ReportName>
                      <ReportType>',ReportType,'</ReportType>
                      <DateRangeType>',DateRangeType ,'</DateRangeType>
                      <Format>TSV</Format>
                      <IncludeVAT>',IncludeVAT,'</IncludeVAT>
                      <IncludeDiscount>',IncludeDiscount,'</IncludeDiscount>
                      </ReportDefinition>')
  #������ �������������� dataframe
  result <- data.frame()
  
  for(login in Login){
    #�����������
    Token <- tech_auth(login = Login, token = Token, AgencyAccount = AgencyAccount, TokenPath = TokenPath)
   
    #������� �������
    parsing_time <- 0
    server_time <- 0
    #������ ��������� � ��� ����� ������ � ������
    packageStartupMessage("-----------------------------------------------------------")
    packageStartupMessage(paste0("�������� ������ �� ",login))
    #���������� ������ �� ������ �������
    #��������� ����� ������ �������� ������
    serv_start_time <- Sys.time()
    
    answer <- POST("https://api.direct.yandex.com/v5/reports", body = queryBody, add_headers(Authorization = paste0("Bearer ",Token), 'Accept-Language' = "ru", skipReportHeader = "true" ,skipReportSummary = "true" , 'Client-Login' = login, returnMoneyInMicros = "false", processingMode = "auto"))
    
    if(substr(answer$status_code,1,1) == 4){
      packageStartupMessage("������ � ���������� ������� ���� ��������� ����������� �� ���������� �������� ��� ������� � �������. � ���� ������ ��������������� ��������� �� ������, �������������� ������ � ��������� ��� �����.")
      
      # ������ ������
      content(answer, "parsed","text/xml",encoding = "UTF-8") %>%
          xml_find_all(., xpath = ".//reports:ApiError//reports:requestId") %>%
          xml_text() %>%
          message("Request Id: ", .)
      
      content(answer, "parsed","text/xml",encoding = "UTF-8") %>%
          xml_find_all(., xpath = ".//reports:ApiError//reports:errorCode") %>%
          xml_text() %>%
          message("Error Code: ", .)
      
      content(answer, "parsed","text/xml",encoding = "UTF-8") %>%
          xml_find_all(., xpath = ".//reports:ApiError//reports:errorMessage") %>%
          xml_text() %>%
          message("Error Message: ", .)
      
      content(answer, "parsed","text/xml",encoding = "UTF-8") %>%
          xml_find_all(., xpath = ".//reports:ApiError//reports:errorDetail") %>%
          xml_text() %>%
          message("Error Detail: ", .)
      
      next
    }
    
    if(answer$status_code == 500){
      packageStartupMessage(paste0(login," - ",xml_text(content(answer, "parsed","text/xml",encoding = "UTF-8"))))
      packageStartupMessage("��� ������������ ������ ��������� ������ �� �������. ���� ��� ����� ������ ������ �� ������� �������� �������, ���������� ������������ ����� ������. ���� ������ �����������, ���������� � ������ ���������.")
      next
    }
    
    if(answer$status_code == 201){
      packageStartupMessage("����� ������� ��������� � ������� �� ������������ � ������ ������.", appendLF = T)
      packageStartupMessage("Proccesing", appendLF = F)
      packageStartupMessage("|", appendLF = F)
    }
    
    if(answer$status_code == 202){
      packageStartupMessage("������������ ������ ��� �� ���������.", appendLF = F)
    }
    
    
    while(answer$status_code != 200){
      answer <- POST("https://api.direct.yandex.com/v5/reports", body = queryBody, add_headers(Authorization = paste0("Bearer ",Token), 'Accept-Language' = "ru", skipReportHeader = "true" ,skipReportSummary = "true" , 'Client-Login' = login, returnMoneyInMicros = "false", processingMode = "auto"))
      packageStartupMessage("=", appendLF = F)
      if(answer$status_code == 500){
        stop("��� ������������ ������ ��������� ������ �� �������. ���� ��� ����� ������ ������ �� ������� �������� �������, ���������� ������������ ����� ������. ���� ������ �����������, ���������� � ������ ���������.")
      }
      if(answer$status_code == 502){
        stop("����� ��������� ������� ��������� ��������� �����������.")
      }
      Sys.sleep(5)
    }
    packageStartupMessage("|", appendLF = T)
    #�������� ��� ����� ��� �����������.
    server_time <- round(difftime(Sys.time(), serv_start_time , units ="secs"),0)
    packageStartupMessage("����� ������� ����������� � ������� � ���� ������.", appendLF = T)
    packageStartupMessage(paste0("����� �������� ������ �� �������: ",server_time , " ���."), appendLF = T)
    
    #��������� ����� ������ �������� ������
    pasr_start_time <- Sys.time()
    
    if(answer$status_code == 200){
      df_new <- suppressMessages(content(answer,  "parsed", "text/tab-separated-values", encoding = "UTF-8"))

      #�������� ��������� �� ����� �� ������
      if(nrow(df_new) == 0){
        packageStartupMessage("��� ������ �� ������ ������� ������, ����������� ��������� �������� ������ � ������ ��� ��, ����� ���� ��������� �������.")
        next
      }
      #�������� � ��� ������� ������� ������ ������� ����������
      parsing_time <- round(difftime(Sys.time(), pasr_start_time , units ="secs"),0)
      packageStartupMessage(paste0("����� �������� ����������: ", parsing_time, " ���."), appendLF = T)

      #���������� � ���������� ������.
      packageStartupMessage(paste0("���������� ������������� ������� ������� ���������� ��������� ��� ��������� � ������ ���������: ",answer$headers$requestid), appendLF = T)
      
      #��������� �����
      if(length(Login) > 1){
        df_new$Login <- login}
      
      #������������ ������ ������ � ��������������� ���� ������
      result <- rbind(result, df_new)
      #��������� ����
    }
  }
  #������� ���� � ������� ������ �������
  total_work_time <- round(difftime(Sys.time(), proc_start , units ="secs"),0)
  packageStartupMessage(paste0("����� ����� ������ �������: ",total_work_time, " ���."))
  packageStartupMessage(paste0(round(as.integer(server_time) / as.integer(total_work_time) * 100, 0), "% ������� ������ ������ �������� ������ �� �������."))
  packageStartupMessage(paste0(round(as.integer(parsing_time) / as.integer(total_work_time) * 100, 0), "% ������� ������ ����� ������� ����������� ����������."))
  packageStartupMessage("-----------------------------------------------------------")
  #���������� ���������� ������
  return(result)
}
