///  C# work with local IP address
/// 
/// Ref: How To Get IP Address Of A Machine
/// Ref: WMI or How to change my IP address
/// using System.Management;
///

public string getLocalIP() 
{
  string localIP = "";
  string strHostName = Dns.GetHostName();

  IPHostEntry ipEntry = Dns.GetHostByName (strHostName);
  IPAddress [] addr = ipEntry.AddressList;

  /* what if more than one instance exists? */
  for (int i = 0; i < addr.Length; i++)  
  {
    localIP = addr[i].ToString();
  }

  return localIP;
}


public bool setLocalIP(string newIP) {
  try 
  {
    ManagementBaseObject inPar = null;
    ManagementBaseObject outPar = null;
    ManagementClass mc = new ManagementClass("Win32_NetworkAdapterConfiguration");
    ManagementObjectCollection moc = mc.GetInstances();
    foreach (ManagementObject mo in moc) 
    {
      if (!(bool) mo["IPEnabled"]) continue;
      inPar = mo.GetMethodParameters("EnableStatic");
      inPar["IPAddress"] = new string[] {newIP};
      inPar["SubnetMask"] = new string[] {subnetMask};
      outPar = mo.InvokeMethod("EnableStatic", inPar, null);
      break;
    }
  
    this.currentIP = newIP;
    return true;
  } 
  catch (Exception e) 
  {
    this.setErrMsg(e.Message + "\nsource: " + e.Source);
    return false;
  }
}


static void SwitchToDHCP()
{
  ManagementBaseObject inPar = null;
  ManagementBaseObject outPar = null;
  ManagementClass mc = new ManagementClass("Win32_NetworkAdapterConfiguration");
  ManagementObjectCollection moc = mc.GetInstances();
  foreach( ManagementObject mo in moc )
  {
    if( ! (bool) mo["IPEnabled"] )
      continue;

    inPar = mo.GetMethodParameters("EnableDHCP");
    outPar = mo.InvokeMethod( "EnableDHCP", inPar, null );
    break;
  }
}


static void SwitchToStatic()
{
  string newIP;
  string subnetMask = "255.255.255.0";
  newIP = (curIP.Equals("192.168.168.209"))?"192.168.168.204":"192.168.168.209";

  ManagementBaseObject inPar = null;
  ManagementBaseObject outPar = null;
  ManagementClass mc = new ManagementClass("Win32_NetworkAdapterConfiguration");
  ManagementObjectCollection moc = mc.GetInstances();
  foreach( ManagementObject mo in moc )
  {
    if( ! (bool) mo[ "IPEnabled" ] )
      continue;

    inPar = mo.GetMethodParameters( "EnableStatic" );
    inPar["IPAddress"] = new string[] { newIP };
    inPar["SubnetMask"] = new string[] { subnetMask };
    outPar = mo.InvokeMethod( "EnableStatic", inPar, null );
    break;
  }
}


static void ReportIP()
{
  Console.WriteLine( "****** Current IP addresses:" );
  ManagementClass mc = new ManagementClass("Win32_NetworkAdapterConfiguration");
  ManagementObjectCollection moc = mc.GetInstances();
  foreach( ManagementObject mo in moc )
  {
    if( ! (bool) mo[ "IPEnabled" ] )
      continue;

    Console.WriteLine( "{0}\n SVC: '{1}' MAC: [{2}]", (string) mo["Caption"],
      (string) mo["ServiceName"], (string) mo["MACAddress"] );

    string[] addresses = (string[]) mo[ "IPAddress" ];
    string[] subnets = (string[]) mo[ "IPSubnet" ];

    Console.WriteLine( " Addresses :" );
    foreach(string sad in addresses)
      Console.WriteLine( "\t'{0}'", sad );

    Console.WriteLine( " Subnets :" );
    foreach(string sub in subnets )
      Console.WriteLine( "\t'{0}'", sub );

    curIP = addresses[0];
  }
}
