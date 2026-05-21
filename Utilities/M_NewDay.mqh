bool M_NewDay()
{
   stGVL.nNumberOfTrades = 0;
   M_LogInfo("Trade count reset");
   
   stGVL.DailyStartingBalance = AccountInfoDouble(ACCOUNT_BALANCE);
   
   return true;
}