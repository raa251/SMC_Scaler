bool M_LogError(string Message)
{
   if(!MQLInfoInteger(MQL_OPTIMIZATION))
   {
      Print("Error:     " + Message);
   }
   
   return true;
}