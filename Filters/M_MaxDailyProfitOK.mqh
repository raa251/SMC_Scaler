bool M_MaxDailyProfitOk(bool bLog)
{
   if(AccountInfoDouble(ACCOUNT_BALANCE) < stGVL.DailyStartingBalance * (1 + nMaxDailyProfit / 100 ) || nMaxDailyProfit==0)
   {
      return true; // Daily profit is OK
   }
   else
   {
      if(bLog)
      {
         M_LogInfo("Max daily profit reached! BOT IS ON FIRE!");
      }
      return false;
   }
}