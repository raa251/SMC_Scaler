void M_SM_WAIT_FVG_INVERSED()
{
   int FVGReachedIndex = iBarShift(_Symbol, PERIOD_CURRENT, stGVL.dtFVGReached_Time_HTF);
   // Long
   if(stGVL.eCurrentDirection == DIR_LONG)
   {      
      if(FVGReachedIndex > nMaxCandlesFVGInverse && nMaxCandlesFVGInverse != 0)
      {
         M_LogWarning("Maximum candles to inverse FVG reached = ");
         stGVL.eStateMachine = SM_RESET;
         return;
      }
      else if(stGVL.Candle[1].close <= stGVL.LastFVGTop) // FVG not inversed yet
      {
         return;
      }
      else if(!M_FiltersOK(true))
      {
         stGVL.eStateMachine = SM_RESET;
         return;
      }
      
      else
      {
         // Enter trade
         MqlTick tick;
         SymbolInfoTick(_Symbol, tick);
         double CurrentEntryPrice = tick.ask;

         stGVL.StopLoss = M_SearchSL();
         
         if(stGVL.StopLoss == 0)
         {
            M_LogError("Stoploss could not be calculated!");
            stGVL.eStateMachine = SM_RESET;
            return;
         }
         
         stGVL.Entry = CurrentEntryPrice;
         stGVL.TakeProfit = stGVL.Entry + (stGVL.Entry - stGVL.StopLoss) * fRiskReward;
         stGVL.nNumberOfPositions = 1;
         
         if(bRunnerPosition)
         {
            stGVL.nNumberOfPositions = stGVL.nNumberOfPositions + 1;
         }
         
         int SLInPoints = (stGVL.Entry - stGVL.StopLoss) / SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
         stGVL.LotSize = M_CalculateLotSize(fRiskPerTrade, SLInPoints);
         // Enter tradex
         Trade.Buy(stGVL.LotSize, _Symbol, 0, stGVL.StopLoss, stGVL.TakeProfit, "Buy");
         M_LogInfo("Long entered with Lot " + DoubleToString(stGVL.LotSize) + " Entry=" + DoubleToString(stGVL.Entry) + " Stoploss=" + DoubleToString(stGVL.StopLoss) + " Takeprofit=" + DoubleToString(stGVL.TakeProfit));
         if(bRunnerPosition)
         {
            Trade.Buy(stGVL.LotSize, _Symbol, 0, stGVL.StopLoss, 0, "Buy Runner");
            M_LogInfo("Long entered with Lot " + DoubleToString(stGVL.LotSize) + " Entry=" + DoubleToString(stGVL.Entry) + " Stoploss=" + DoubleToString(stGVL.StopLoss) + " Takeprofit=0 -> runner position");
         }
         
         stGVL.nNumberOfTrades = stGVL.nNumberOfTrades + 1;
         
         stGVL.eStateMachine = SM_IN_TRADE;
      }
   }
   // Short
   else if(stGVL.eCurrentDirection == DIR_SHORT)
   {
      if(FVGReachedIndex > nMaxCandlesFVGInverse && nMaxCandlesFVGInverse != 0)
      {
         M_LogWarning("Maximum candles to inverse FVG reached = ");
         stGVL.eStateMachine = SM_RESET;
         return;
      }
      else if(stGVL.Candle[1].close >= stGVL.LastFVGBottom) // FVG not inversed yet
      {
         return;
      }
      else if(!M_FiltersOK(true))
      {
         stGVL.eStateMachine = SM_RESET;
         return;
      }
      else
      {
         // Enter trade
         MqlTick tick;
         SymbolInfoTick(_Symbol, tick);
         double CurrentEntryPrice = tick.bid;
         
         stGVL.StopLoss = M_SearchSL();
         
         if(stGVL.StopLoss == 0)
         {
            M_LogError("Stoploss could not be calculated!");
            stGVL.eStateMachine = SM_RESET;
            return;
         }
         
         stGVL.Entry = CurrentEntryPrice;
         stGVL.TakeProfit = stGVL.Entry - (stGVL.StopLoss - stGVL.Entry) * fRiskReward;
         stGVL.nNumberOfPositions = 1;
         
         if(bRunnerPosition)
         {
            stGVL.nNumberOfPositions = stGVL.nNumberOfPositions + 1;
         }
         
         int SLInPoints = (stGVL.StopLoss - stGVL.Entry) / SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
         stGVL.LotSize = M_CalculateLotSize(fRiskPerTrade, SLInPoints);
         // Enter tradex
         Trade.Sell(stGVL.LotSize, _Symbol, 0, stGVL.StopLoss, stGVL.TakeProfit, "Sell");
         M_LogInfo("Short entered with Lot " + DoubleToString(stGVL.LotSize) + " Entry=" + DoubleToString(stGVL.Entry) + " Stoploss=" + DoubleToString(stGVL.StopLoss) + " Takeprofit=" + DoubleToString(stGVL.TakeProfit));
         if(bRunnerPosition)
         {
            Trade.Sell(stGVL.LotSize, _Symbol, 0, stGVL.StopLoss, 0, "Sell Runner");
            M_LogInfo("Short entered with Lot " + DoubleToString(stGVL.LotSize) + " Entry=" + DoubleToString(stGVL.Entry) + " Stoploss=" + DoubleToString(stGVL.StopLoss) + " Takeprofit=0 -> runner position");
         }
         
         stGVL.nNumberOfTrades = stGVL.nNumberOfTrades + 1;
         
         stGVL.eStateMachine = SM_IN_TRADE;
      }
   }
}