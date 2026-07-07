void M_SM_SEARCH_INVERSE_FVG()
{
   // Search for the last FVG
   int NrCLDs = MathMin(nCandlesLookbackFVG, 97);
   double tmpLow = 100000000;
   double tmpHigh = 0;
   for(int i = 1; i <= NrCLDs; i++) // Bei 1 anfangen, da 0 noch nicht geschlossen is
   {
      if(stGVL.Candle[i].high > tmpHigh)
      {
         tmpHigh = stGVL.Candle[i].high;
      }
      if(stGVL.Candle[i].low < tmpLow)
      {
         tmpLow = stGVL.Candle[i].low;
      }
      // Direction Buy
      if(stGVL.Candle[i+1].open > stGVL.Candle[i+1].close && stGVL.eCurrentDirection == DIR_LONG) // middle candle is bearish
      {
         // Gap between Candle i and i+2 existing
         bool Condition1 = stGVL.Candle[i+2].low > stGVL.Candle[i].high;

         // FVG is above FVG
         bool Condition2 = stGVL.Candle[i].high > stGVL.LastFVGTop_HTF;
         
         // Check if the FVG is still valid and did not get taken out already buy a candle between now and FVG
         bool Condition3 = stGVL.Candle[i].high >= tmpHigh;
         
         // Check if the FVG is big enough
         bool Condition4 = stGVL.Candle[i+2].low - stGVL.Candle[i].high >= stGVL.fMinIFVGSize_Price || stGVL.fMinIFVGSize_Price == 0;
         
         // Check if the FVG is not too big
         bool Condition5 = stGVL.Candle[i+2].low - stGVL.Candle[i].high <= stGVL.fMaxIFVGSize_Price || stGVL.fMaxIFVGSize_Price == 0;
         
         if(Condition1 && Condition2 && Condition3 && Condition4 && Condition5)
         { // fair value gap
            stGVL.LastFVGTop     = stGVL.Candle[i+2].low;
            stGVL.LastFVGBottom  = stGVL.Candle[i].high;
            stGVL.LastFVGIndex   = i + 1;
            
            datetime barTime = iTime(_Symbol, PERIOD_CURRENT, 0);
            datetime barTimeFVGStart = iTime(_Symbol, PERIOD_CURRENT, stGVL.LastFVGIndex);
            stGVL.Rect_ActFVG_Number = stGVL.Rect_ActFVG_Number + 1;
            M_CreateBox(stGVL.Rect_FVG, stGVL.Rect_ActFVG_Number, barTimeFVGStart, barTime, stGVL.LastFVGTop, stGVL.LastFVGBottom, clrAquamarine);
            
            M_LogInfo("FVG to inverse found, TOP=" + DoubleToString(stGVL.LastFVGTop) + " BOTTOM=" + DoubleToString(stGVL.LastFVGBottom) + " Index=" + IntegerToString(stGVL.LastFVGIndex));
            stGVL.eStateMachine = SM_WAIT_FVG_INVERSED;
            break; // Fair value gap found - exit
         }
      }
      // Direction Sell
      else if(stGVL.Candle[i+1].close > stGVL.Candle[i+1].open && stGVL.eCurrentDirection == DIR_SHORT) // Middle Candle is bullish
      {
         // Gap between Candle i and i+2 existing and is big enough
         bool Condition1 = stGVL.Candle[i+2].high < stGVL.Candle[i].low;
         
         // FVG is below FVG
         bool Condition2 = stGVL.Candle[i].low < stGVL.LastFVGBottom_HTF;
         
         // Check if the FVG is still valid and did not get taken out already buy a candle between now and FVG
         bool Condition3 = stGVL.Candle[i].low <= tmpLow;
         
         // Check if the FVG is big enough
         bool Condition4 = stGVL.Candle[i].low - stGVL.Candle[i+2].high >= stGVL.fMinIFVGSize_Price || stGVL.fMinIFVGSize_Price == 0;
         
         // Check if the FVG is not too big
         bool Condition5 = stGVL.Candle[i].low - stGVL.Candle[i+2].high <= stGVL.fMaxIFVGSize_Price || stGVL.fMaxIFVGSize_Price == 0;
         
         if(Condition1 && Condition2 && Condition3 && Condition4 && Condition5)
         { // fair value gap
            stGVL.LastFVGTop     = stGVL.Candle[i].low;
            stGVL.LastFVGBottom  = stGVL.Candle[i+2].high;
            stGVL.LastFVGIndex   = i + 1;
            
            datetime barTime = iTime(_Symbol, PERIOD_CURRENT, 0);
            datetime barTimeFVGStart = iTime(_Symbol, PERIOD_CURRENT, stGVL.LastFVGIndex);
            stGVL.Rect_ActFVG_Number = stGVL.Rect_ActFVG_Number + 1;
            M_CreateBox(stGVL.Rect_FVG, stGVL.Rect_ActFVG_Number, barTimeFVGStart, barTime, stGVL.LastFVGTop, stGVL.LastFVGBottom, clrYellow);
            
            M_LogInfo("FVG to inverse found, TOP=" + DoubleToString(stGVL.LastFVGTop) + " BOTTOM=" + DoubleToString(stGVL.LastFVGBottom) + " Index=" + IntegerToString(stGVL.LastFVGIndex));
            
            stGVL.eStateMachine = SM_WAIT_FVG_INVERSED;
            break; // Fair value gap found - exit
         }
      }
      
      if(NrCLDs == i) // Last loop run through, no FVG found
      {
         M_LogWarning("No FVG to inverse found in last " + IntegerToString(NrCLDs) + " Candles!");
         M_LogWarning("Wait until a IFVG is formed in HTF FVG");
         if(bSearchFVGWithinHTF_FVG)
         {
            stGVL.bWaitForNewCurrBar = true; // Otherwise we would directly jump to reset on the next tick
            stGVL.eStateMachine = SM_WAIT_HTF_FVG_EXIT;
         }
         else
         {
            stGVL.eStateMachine = SM_RESET;
         }
         break;
      }
   }
}