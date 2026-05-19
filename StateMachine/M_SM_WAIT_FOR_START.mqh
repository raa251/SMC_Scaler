void M_SM_WAIT_FOR_START()
{
   if(1==0)
   {
      if(!M_FiltersOK(true))
      {
         return;
      }
      
      for(int i = 1; i <= nNumberOfCandlesLow; i++)
      {
         if(stGVL.Candle[i].close < stGVL.BodyStopLoss || stGVL.BodyStopLoss == 0)
         {
            stGVL.BodyStopLoss = stGVL.Candle[i].close;
         }
      }
      
      MqlTick tick;
      SymbolInfoTick(_Symbol, tick);
      double CurrentEntryPrice = tick.ask;
      
      stGVL.StopLoss = stGVL.BodyStopLoss;
      
      stGVL.Entry = CurrentEntryPrice;
      stGVL.TakeProfit = stGVL.Entry + (stGVL.Entry - stGVL.StopLoss) * fRiskReward;
      
      int SLInPoints = (stGVL.Entry - stGVL.StopLoss) / SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
      stGVL.LotSize = M_CalculateLotSize(fRiskPerTrade, SLInPoints);
      
      Trade.Buy(stGVL.LotSize, _Symbol, 0, stGVL.StopLoss, stGVL.TakeProfit, "Buy");
      
      stGVL.eCurrentDirection = DIR_LONG;
      stGVL.eStateMachine = SM_IN_TRADE;
   }
   else if(1==0)
   {
      if(!M_FiltersOK(true))
      {
         return;
      }
      
      for(int i = 1; i <= nNumberOfCandlesLow; i++)
      {
         if(stGVL.Candle[i].close > stGVL.BodyStopLoss || stGVL.BodyStopLoss == 0)
         {
            stGVL.BodyStopLoss = stGVL.Candle[i].close;
         }
      }
      
      MqlTick tick;
      SymbolInfoTick(_Symbol, tick);
      double CurrentEntryPrice = tick.bid;
      
      stGVL.StopLoss = stGVL.BodyStopLoss;
      
      stGVL.Entry = CurrentEntryPrice;
      stGVL.TakeProfit = stGVL.Entry - (stGVL.StopLoss - stGVL.Entry) * fRiskReward;
      
      int SLInPoints = (stGVL.StopLoss - stGVL.Entry) / SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
      stGVL.LotSize = M_CalculateLotSize(fRiskPerTrade, SLInPoints);
      
      Trade.Sell(stGVL.LotSize, _Symbol, 0, stGVL.StopLoss, stGVL.TakeProfit, "Sell");
      
      stGVL.eCurrentDirection = DIR_SHORT;
      stGVL.eStateMachine = SM_IN_TRADE;
   }
}