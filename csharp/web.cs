/// C# GET/POST request, login, download, axWebBrowser

///
/// Example of HTTP Get request.
///
private string requestURL(string url, int timeout) 
{
  HttpWebRequest wr;
  HttpWebResponse resp = null;
  Stream stream;
  StreamReader reader;
  string strResponse = "";

  try {
    wr = (HttpWebRequest) WebRequest.Create(url);
    wr.Timeout = timeout; // in milliseconds.
    resp = (HttpWebResponse) wr.GetResponse();
    stream = resp.GetResponseStream();
    reader = new StreamReader(stream);
    try { strResponse = reader.ReadToEnd(); } 
    finally { reader.Close(); }
    resp = null;
  }
  catch (Exception ex) { 
    this.output_response("::" + ex.Message); 
  }
  finally { 
    if (resp != null) resp.Close();
  }
  return strResponse;
}


///
/// Example of HTTP Post request.
/// Call the following function: e.g. 
/// string html = HttpPost("http://abcde.com", "a=1&b=2");
///
private string HttpPost(string URI, string Parameters) 
{
  WebRequest req = WebRequest.Create(URI);
  //req.Proxy = new System.Net.WebProxy(ProxyString, true);

  req.ContentType = "application/x-www-form-urlencoded";
  req.Method = "POST";

  byte [] bytes = System.Text.Encoding.ASCII.GetBytes(Parameters);
  req.ContentLength = bytes.Length;

  Stream os = req.GetRequestStream ();
  os.Write (bytes, 0, bytes.Length); 
  os.Close ();

  WebResponse resp = req.GetResponse();
  if (resp== null) return null;

  StreamReader sr = new StreamReader(resp.GetResponseStream());
  return sr.ReadToEnd().Trim();
}


///
/// Example of using HTTP Post to log into a site.
///
private void login() {
  HTMLDocument myDoc = new HTMLDocumentClass();
  myDoc = (HTMLDocument) axWebBrowser1.Document;

  try 
  {
    HTMLInputElement oUser = null, oPass = null;

    oUser = (HTMLInputElement) myDoc.all.item("username", 0);
    oPass = (HTMLInputElement) myDoc.all.item("password", 0);

    if (oUser == null || oPass == null) return;

    oUser.value = "username_value";
    oPass.value = "password_value";

    HTMLFormElement frm = (HTMLFormElement) myDoc.all.item("login", 0);
    frm.submit();

    this.Task = 1; 
  } 
  catch (Exception ex) 
  {
    this.showInfo("test() error: " + ex.Message);
  }
}


///
/// Example of using HTTP Post to download an Excel file.
///
private void getExcel() {
  HttpWebResponse resp = null;
  Stream stream;
  string filename = this.downloadFolder + "/download.xls";

  try 
  {
    wr = (HttpWebRequest) WebRequest.Create(this.excel_url);
    wr.Method = "POST";
    wr.ContentType = "application/x-www-form-urlencoded";
    wr.ContentLength = byteArray.Length;
    wr.Timeout = 100000; // in ms. Set this bigger than the site timeout value.
    MyUtil.appendLog("wr.contentlength: " + wr.ContentLength);

    wr.CookieContainer = new CookieContainer();
    wr.CookieContainer.SetCookies(new Uri(this.excel_url) , 
        ((mshtml.HTMLDocumentClass) this.axWebBrowser1.Document).cookie.ToString());
    MyUtil.appendLog("cookie: " + 
        ((mshtml.HTMLDocumentClass) this.axWebBrowser1.Document).cookie);

    // Send post request
    Stream dataStream = wr.GetRequestStream();
    dataStream.Write(byteArray, 0, byteArray.Length);
    dataStream.Close();
    resp = (HttpWebResponse) wr.GetResponse();
    resp.Cookies = wr.CookieContainer.GetCookies(resp.ResponseUri);
    MyUtil.appendLog("resp status: " + resp.StatusDescription);

    stream = resp.GetResponseStream();

    //MyUtil.appendLog("resp header: " + resp.ContentType );
    // Header: usually 'txt/html'. here is 'application/vnd.ms-excel'
    StreamReader reader = new StreamReader(stream);
    try 
    {
      MyUtil.saveFile(filename, reader.ReadToEnd());
      this.downloadSucceed = true;
    } 
    catch (Exception ex) 
    { 
      MyUtil.FileDelete(filename);
      this.downloadSucceed = false;
    }
    finally 
    {
      reader.Close();
    }
  } 
  catch (Exception ex) 
  {
    this.downloadSucceed = false;
    MyUtil.FileDelete(filename);
  } 
  finally 
  {
    if (resp != null) { resp.Close(); }
  }
}

///
/// Another way of navigating website: use the axWebBrowser control.
///
/// this.axWebBrowser1.Navigate(url);

/// 
/// [1] The user32 SendInput windows API. The SendInput function synthesizes 
///     keystrokes, mouse motions, and button clicks to the currently active window. 
/// [2] Capturing binary download via code through axwebbrowser1.
/// 
