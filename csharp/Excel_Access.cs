/// C# read Excel, get Access schema

///
/// Reference: How To Open and Read an Excel Spreadsheet into a ListView in .NET
///
public static void readExcel(string fullpath) {
  Excel.Application excelObj = new Excel.Application();
  if (excelObj == null) {
    MessageBox.Show("Error: Excel cannot be started.");
    return;
  }

  excelObj.Visible = false; 

  Excel.Workbook theWorkbook = excelObj.Workbooks.Open(fullpath, 0, true, 5, "", "",
    true, Excel.XlPlatform.xlWindows, "\t", false, false, 0, false, false, false);
  // get the collection of sheets in the workbook
  Excel.Sheets sheets = theWorkbook.Worksheets;
  // get the first and only worksheet from the collection of worksheets
  Excel.Worksheet worksheet = (Excel.Worksheet)sheets.get_Item(1);
  
  // getExcelSize(worksheet); // get row/col: ws.Rows.Count, ws.Columns.Count

  // loop through 10 rows of the spreadsheet and place each row in the list view
  for (int i = 1; i <= 10; i++)
  {
    Excel.Range range = worksheet.get_Range("A"+i.ToString(), "FB" + i.ToString());
    System.Array myvalues = (System.Array)range.Cells.Value2;
    string str = ConvertArrayToString(myvalues);
    MessageBox.Show(str);
  }
}


///
/// Reference: How to read an Excel file with OleDb and a simple SQL query? 
/// To use this, the Excel version should be 8.0 or compatible.
/// 
/// The link http://forums.microsoft.com/MSDN/ShowPost.aspx?PostID=107963&SiteID=1
/// says that to use this method, it takes a little setup in your Excel document. 
/// Basically, you need to define "named objects" in Excel that are synonymous to 
/// tables in a database. The first row of the named object are the column headers. 
/// To set up a named object, first select the range of cells (your "table," with 
/// the first row being the column headers), then go to menu Insert->Names->Define. 
/// Name your object and press "Add." Now you have an object which can be read by 
/// ADO.NET.
///
public static void readExcel2(string fullpath) {
  String sConnectionString = 
    "Provider=Microsoft.Jet.OLEDB.4.0;" +
    "Data Source=" + fullpath + ";" + "Extended Properties=\"Excel 8.0;HDR=NO;IMEX=1\"";
    MessageBox.Show(sConnectionString);

  try 
  {
    OleDbConnection objConn = new OleDbConnection(sConnectionString);
    objConn.Open();

    string sheetName = filename.Substring(0, filename.IndexOf(".xls"));
    MessageBox.Show("sheetName: " + sheetName);

    //OleDbCommand objCmdSelect =new OleDbCommand("SELECT * FROM [Sheet1$]", objConn);
    OleDbCommand objCmdSelect =new OleDbCommand("SELECT * FROM [" + sheetName + "$]", objConn);
    OleDbDataAdapter objAdapter1 = new OleDbDataAdapter();
    objAdapter1.SelectCommand = objCmdSelect;
    DataSet objDataset1 = new DataSet();
    objAdapter1.Fill(objDataset1);

    string str = objAdapter1.ToString();
    MessageBox.Show(str);

    objConn.Close();
  } 
  catch (Exception e) {
    MessageBox.Show("error: " + e.Message);
  }
}

///
/// Get Access Schema.
///
public void getSchema(string path) 
{
  int i, j;
  string result = "";
  DataTable userTables = null;
  DataTable userTable = null;
  System.Windows.Forms.TreeNode node = null;
  System.Windows.Forms.TreeNode[] nc;

  try 
  {
    OleDbConnection conn = new OleDbConnection();
    conn.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" + path;
    conn.Open();

    userTables = conn.GetOleDbSchemaTable(OleDbSchemaGuid.Tables, 
                   new object[] {null, null, null, "TABLE"});

    this.treeViewDBSchema.Nodes.Clear();
    // Add list of table names to listBox
    for (i=0; i < userTables.Rows.Count; i++) 
    {
        result += userTables.Rows[i][2].ToString() + " { ";
        userTable = conn.GetOleDbSchemaTable(OleDbSchemaGuid.Columns,
            new object[] {null, null, userTables.Rows[i][2].ToString(), null});

        nc = new TreeNode[userTable.Rows.Count];
        for (j = 0; j < userTable.Rows.Count - 1; j ++) 
        {
            result += userTable.Rows[j][3].ToString() + ", "; // [2].ToString();
            nc[j] = new TreeNode("Field: " + userTable.Rows[j][3].ToString());
            nc[j].Tag = userTable.Rows[j][3].ToString();
        }
        // for the last item.
        result += userTable.Rows[j][3].ToString(); // [2].ToString();
        nc[j] = new TreeNode("Field: " + userTable.Rows[j][3].ToString());
        nc[j].Tag = userTable.Rows[j][3].ToString();

        result += " }\n";
        node = new TreeNode("Table: " + userTables.Rows[i][2].ToString(), nc);
        node.Tag = userTables.Rows[i][2].ToString();
        this.treeViewDBSchema.Nodes.Add(node);
    }
    conn.Close();
    //MessageBox.Show(this, result);
    this.frmMain.setOutput(result);
  } 
  catch (Exception ex) 
  {
    MessageBox.Show(this, "Error: " + ex.Message);
  } 
}
