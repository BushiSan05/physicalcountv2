class ServerUrlList{
  //--------------------------> Note: Local IP should the same with the default IP @ server_url.dart<----------------------
  static var _serverUrlList = {'LOCAL'            : 'http://172.16.163.2:81/pcount_app/pcount_local_james/',
                               'DISTRIBUTION'     : 'http://172.16.163.2:81/pcount_app/pcount_pdc/',
                               'ASC: MAIN'        : 'http://172.16.163.2:81/pcount_app/pcount_alturas/',
                               'PLAZA MARCELA'    : 'http://172.16.163.2:81/pcount_app/pcount_pm/',
                               'ISLAND CITY MALL' : 'http://172.16.163.2:81/pcount_app/pcount/',
    // 'ISLAND CITY MALL' : 'http://172.16.163.2:81/pcount_app/pcount_local/',
                               'ALTA CITTA'       : 'http://172.16.163.2:81/pcount_app/pcount_alta/',
                               'ALTURAS TALIBON'  : 'http://172.16.163.2:81/pcount_app/pcount_alturas_talibon/', //SAMPLE ONLY
                               'COLONNADE- COLON' : 'http://172.16.163.2:81/pcount_app/pcount_colonnade/',}; //SAMPLE ONLY

  serverUrlKey()=> _serverUrlList.entries.map((e) => e.key).toList();
  serverUrlValue()=> _serverUrlList.entries.map((e) => e.value).toList();
  ip(String serverName)=> _serverUrlList['$serverName'] ?? 'Not found'.toString();
  //ip(String serverName)=>  _serverUrlList.values.firstWhere((e) => _serverUrlList[e] == serverName, orElse: () => "Not found");
  server(String ip)=> _serverUrlList.keys.firstWhere((e) => _serverUrlList[e] == ip, orElse: () => "Not found");
}