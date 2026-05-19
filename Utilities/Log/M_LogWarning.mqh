bool M_LogWarning(string Message)
{
   if(!MQLInfoInteger(MQL_OPTIMIZATION))
   {
      Print("Warning:   " + Message);
   }
   
   return true;
}