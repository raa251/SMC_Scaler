void M_SM_SEARCH_INVERSE_FVG()
{
   // Search for the last FVG
   int NrCLDs = MathMin(nCandlesLookbackFVG, 97);
   for(int i = 1; i <= NrCLDs; i++) // Bei 1 anfangen, da 0 noch nicht geschlossen is
   {
      // Direction Buy
      if(stGVL.Candle[i+1].open > stGVL.Candle[i+1].close && stGVL.eCurrentDirection == DIR_LONG) // middle candle is bearish
      {
         // Gap between Candle i and i+2 existing
         bool Condition1 = stGVL.Candle[i+2].low > stGVL.Candle[i].high;

         // FVG is above FVG
         bool Condition2 = stGVL.Candle[i].high > stGVL.LastFVGTop;
         
         if(Condition1 && Condition2)
         { // fair value gap
            stGVL.LastFVGTop     = stGVL.Candle[i+2].low;
            stGVL.LastFVGBottom  = stGVL.Candle[i].high;
            stGVL.LastFVGIndex   = i + 1;
            
            datetime barTime = iTime(_Symbol, PERIOD_CURRENT, 0);
            datetime barTimeFVGStart = iTime(_Symbol, eHigherTF, stGVL.LastFVGIndex);
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
         bool Condition2 = stGVL.Candle[i].low < stGVL.LastFVGBottom;
         
         if(Condition1 && Condition2)
         { // fair value gap
            stGVL.LastFVGTop     = stGVL.Candle[i].low;
            stGVL.LastFVGBottom  = stGVL.Candle[i+2].high;
            stGVL.LastFVGIndex   = i + 1;
            
            datetime barTime = iTime(_Symbol, PERIOD_CURRENT, 0);
            datetime barTimeFVGStart = iTime(_Symbol, eHigherTF, stGVL.LastFVGIndex);
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
         stGVL.eStateMachine = SM_RESET;
         break;
      }
   }
}