bool M_MaxTradesPerDayOK(bool bLog)
{
   if(stGVL.nNumberOfTrades < nMaxTradesPerDay || nMaxTradesPerDay == 0)
   {
      return true;
   }
   else
   {
      if(bLog)
      {
         M_LogInfo("Max daily trades reached");
      }
      return false;
   }
}