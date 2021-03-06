# ��� ������� ��� ����������� � ������ ��������
tech_auth <-  function(login = NULL, token = NULL, AgencyAccount = NULL, TokenPath = NULL) {

  # ���� ����� ����� �� ���������� ��������
  if (! is.null(token) ) {
    # ���������� ����� ������� ����������� �����
    if(class(token) == "list") {
      Token <- token$access_token 
    } else {
      Token <- token
    }
  # ���� ����� �� ����� �� ���������� ��� ��������
  } else {
    # ���������� ��� ��������, ��������� ��� ����������
    load_login <- ifelse(is.null(AgencyAccount) || is.na(AgencyAccount), login, AgencyAccount)
    # ��������� �����
    Token <- yadirAuth(Login = load_login, TokenPath = TokenPath, NewUser = FALSE)$access_token
  }
  
  # ���������� �����
  return(Token)
}