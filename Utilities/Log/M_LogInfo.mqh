bool M_LogInfo(string Message)
{
   if(!MQLInfoInteger(MQL_OPTIMIZATION))
   {
      Print("Info:      " + Message);
   }
   
   return true;
}