void M_SM_WAIT_FVG_INVERSED()
{
   // Keep looking for a closer/fresher IFVG while we wait - but only as long as the
   // held IFVG hasn't actually been touched by price yet. Once a candle trades into
   // the zone we commit to it instead of still re-scanning; otherwise price sitting
   // inside/near two overlapping IFVGs made this flip-flop between them bar after bar
   // (confirmed in the tester log - same two zones swapped back and forth repeatedly).
   //
   // The touch check only looks at candles that closed strictly AFTER the FVG was
   // found/last switched to (Candle[1].time > stFVG.End_Time). The FVG's own defining
   // candle always satisfies a plain zone-overlap test trivially - its high/low IS one
   // of the zone's boundaries by construction - which made "touched" fire the instant
   // an IFVG was found and froze the search on whatever was found first, even while
   // price kept moving away and forming fresher, closer IFVGs (confirmed: the "too far
   // away to inverse" warning fired right after discovery, the very first tick it could).
   //
   // Crucially, this whole block is skipped once the held FVG has already been inverted
   // by Candle[1] this bar - otherwise the inversion candle itself becomes the new
   // tmpHigh/tmpLow inside M_SearchFVG, which makes the FVG we're about to trade fail its
   // own "not already taken out" check and get replaced by some other, worse candidate in
   // the very same tick the entry should have fired (confirmed in the tester log: price
   // closed back through the held zone, no trade opened, search jumped to a farther FVG
   // instead).
   bool bAlreadyInverted = (stGVL.eCurrentDirection == DIR_LONG && stGVL.Candle[1].close > stGVL.stFVG.Top)
                         || (stGVL.eCurrentDirection == DIR_SHORT && stGVL.Candle[1].close < stGVL.stFVG.Bottom);

   if(!bAlreadyInverted && stGVL.dtTimeCurrent_CurrTF != stGVL.dtTimeLast_CurrTF)
   {
      if(!stGVL.stFVG.Touched && stGVL.Candle[1].time > stGVL.stFVG.End_Time
         && stGVL.Candle[1].low <= stGVL.stFVG.Top && stGVL.Candle[1].high >= stGVL.stFVG.Bottom)
      {
         stGVL.stFVG.Touched = true;
      }

      if(!stGVL.stFVG.Touched && M_SearchFVG(stGVL.stFVG, stGVL.eCurrentDirection, nCandlesLookbackFVG))
      {
         M_LogInfo("Switched to a closer IFVG while waiting for inversion");
      }
   }

   int FVGReachedIndex = iBarShift(_Symbol, PERIOD_CURRENT, stGVL.dtFVGReached_Time_HTF);

   // Long
   if(stGVL.eCurrentDirection == DIR_LONG)
   {
      if(FVGReachedIndex > nMaxCandlesFVGInverse && nMaxCandlesFVGInverse != 0)
      {
         M_LogWarning("Maximum candles to inverse FVG reached");
         stGVL.eStateMachine = SM_RESET;
         return;
      }
      else if(!M_DipOK(FVGReachedIndex))
      {
         stGVL.eStateMachine = SM_RESET;
         return;
      }
      else if(stGVL.Candle[1].close < stGVL.stFVG.Bottom - stGVL.fMaxDistanceFVGInverse_Price && stGVL.fMaxDistanceFVGInverse_Price != 0)
      {
         M_LogWarning("Price is too far away from FVG to inverse");
         stGVL.eStateMachine = SM_RESET;
         return;
      }
      else if(stGVL.Candle[1].close <= stGVL.stFVG.Top) // FVG not inversed yet
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

         if(stGVL.fMinSLDistance_Price != 0 && CurrentEntryPrice - stGVL.StopLoss < stGVL.fMinSLDistance_Price)
         {
            M_LogWarning("Stoploss distance too small (" + DoubleToString(CurrentEntryPrice - stGVL.StopLoss) + "), skipping trade");
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
      else if(!M_DipOK(FVGReachedIndex))
      {
         stGVL.eStateMachine = SM_RESET;
         return;
      }
      else if(stGVL.Candle[1].close > stGVL.stFVG.Top + stGVL.fMaxDistanceFVGInverse_Price && stGVL.fMaxDistanceFVGInverse_Price != 0)
      {
         M_LogWarning("Price is too far away from FVG to inverse");
         stGVL.eStateMachine = SM_RESET;
         return;
      }
      else if(stGVL.Candle[1].close >= stGVL.stFVG.Bottom) // FVG not inversed yet
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

         if(stGVL.fMinSLDistance_Price != 0 && stGVL.StopLoss - CurrentEntryPrice < stGVL.fMinSLDistance_Price)
         {
            M_LogWarning("Stoploss distance too small (" + DoubleToString(stGVL.StopLoss - CurrentEntryPrice) + "), skipping trade");
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