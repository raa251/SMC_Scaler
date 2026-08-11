// Passive measurement only - does not affect trading behavior. Records the
// worst same-day loss and worst drawdown-from-initial-balance seen during
// the run, so backtest/optimization results can be judged against prop-firm
// style limits (e.g. 5% daily / 10% total) without baking those limits into
// the EA itself.
bool M_TrackDrawdown()
{
   double current = MathMin(AccountInfoDouble(ACCOUNT_BALANCE), AccountInfoDouble(ACCOUNT_EQUITY));

   if(stGVL.DailyStartingBalance > 0)
   {
      double dailyLossPct = (stGVL.DailyStartingBalance - current) / stGVL.DailyStartingBalance * 100.0;
      if(dailyLossPct > stGVL.fMaxObservedDailyLossPct)
      {
         stGVL.fMaxObservedDailyLossPct = dailyLossPct;
      }
   }

   if(stGVL.InitialBalance > 0)
   {
      double totalDDPct = (stGVL.InitialBalance - current) / stGVL.InitialBalance * 100.0;
      if(totalDDPct > stGVL.fMaxObservedTotalDDPct)
      {
         stGVL.fMaxObservedTotalDDPct = totalDDPct;
      }
   }

   return true;
}
