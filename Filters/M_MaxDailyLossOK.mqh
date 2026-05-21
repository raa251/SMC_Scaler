bool M_MaxDailyLossOK(bool bLog)
{
   if(AccountInfoDouble(ACCOUNT_BALANCE) > stGVL.DailyStartingBalance * (1 - nMaxDailyLoss / 100 ) || nMaxDailyLoss==0)
   {
      return true; // Daily loss is OK
   }
   else
   {
      if(bLog)
      {
         M_LogInfo("Max daily loss reached! Tomorrow will be a better day");
      }
      return false;
   }
}