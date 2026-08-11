// Pure logging only - does not affect trading behavior. Logs the previous
// calendar month's realized P&L so multi-month backtests can be checked
// month-by-month against a target (e.g. a propfirm's monthly profit goal)
// without needing a separate backtest per month, which would break the
// compounding/sequential balance carry-over a single continuous run has.
bool M_NewMonth()
{
   double currentBalance = AccountInfoDouble(ACCOUNT_BALANCE);

   if(stGVL.MonthStartingBalance > 0)
   {
      double pct = (currentBalance - stGVL.MonthStartingBalance) / stGVL.MonthStartingBalance * 100.0;
      M_LogInfo(StringFormat("Month closed: balance=%.2f change=%.2f%%", currentBalance, pct));
   }

   stGVL.MonthStartingBalance = currentBalance;

   return true;
}
