// Scans the current-timeframe candles for a fresh inverse FVG opposing stGVL.stFVG_HTF,
// starting from the most recent closed candle backward. Safe to call repeatedly (e.g. once
// per bar while SM_WAIT_FVG_INVERSED is waiting) - if the closest matching IFVG is the same
// one already held in `fvg` (same Start_Time), nothing is redrawn/relogged and it returns
// false. Only a genuinely different (closer/fresher) IFVG updates `fvg` and returns true.
bool M_SearchFVG(ST_FVG &fvg, E_DIRECTION dir, int nLookback)
{
   int NrCLDs = MathMin(nLookback, 97);
   double tmpLow = DBL_MAX;
   double tmpHigh = 0;

   for(int i = 1; i <= NrCLDs; i++) // Bei 1 anfangen, da 0 noch nicht geschlossen ist
   {
      if(stGVL.Candle[i].high > tmpHigh)
      {
         tmpHigh = stGVL.Candle[i].high;
      }
      if(stGVL.Candle[i].low < tmpLow)
      {
         tmpLow = stGVL.Candle[i].low;
      }

      double fTop = 0;
      double fBottom = 0;
      bool bMatch = false;
      color clr = clrNONE;

      if(dir == DIR_LONG && stGVL.Candle[i+1].open > stGVL.Candle[i+1].close) // middle candle is bearish
      {
         bool Condition1 = stGVL.Candle[i+2].low > stGVL.Candle[i].high;                 // Gap between Candle i and i+2 existing
         bool Condition2 = stGVL.Candle[i].high > stGVL.stFVG_HTF.Top;                   // FVG is above the HTF FVG
         bool Condition3 = stGVL.Candle[i].high >= tmpHigh;                              // FVG not already taken out
         bool Condition4 = stGVL.Candle[i+2].low - stGVL.Candle[i].high >= stGVL.fMinIFVGSize_Price || stGVL.fMinIFVGSize_Price == 0;
         bool Condition5 = stGVL.Candle[i+2].low - stGVL.Candle[i].high <= stGVL.fMaxIFVGSize_Price || stGVL.fMaxIFVGSize_Price == 0;

         if(Condition1 && Condition2 && Condition3 && Condition4 && Condition5)
         {
            fTop = stGVL.Candle[i+2].low;
            fBottom = stGVL.Candle[i].high;
            bMatch = true;
            clr = clrAquamarine;
         }
      }
      else if(dir == DIR_SHORT && stGVL.Candle[i+1].close > stGVL.Candle[i+1].open) // middle candle is bullish
      {
         bool Condition1 = stGVL.Candle[i+2].high < stGVL.Candle[i].low;                 // Gap between Candle i and i+2 existing
         bool Condition2 = stGVL.Candle[i].low < stGVL.stFVG_HTF.Bottom;                 // FVG is below the HTF FVG
         bool Condition3 = stGVL.Candle[i].low <= tmpLow;                                // FVG not already taken out
         bool Condition4 = stGVL.Candle[i].low - stGVL.Candle[i+2].high >= stGVL.fMinIFVGSize_Price || stGVL.fMinIFVGSize_Price == 0;
         bool Condition5 = stGVL.Candle[i].low - stGVL.Candle[i+2].high <= stGVL.fMaxIFVGSize_Price || stGVL.fMaxIFVGSize_Price == 0;

         if(Condition1 && Condition2 && Condition3 && Condition4 && Condition5)
         {
            fTop = stGVL.Candle[i].low;
            fBottom = stGVL.Candle[i+2].high;
            bMatch = true;
            clr = clrYellow;
         }
      }

      if(bMatch)
      {
         datetime dtStart = iTime(_Symbol, PERIOD_CURRENT, i + 1);

         if(fvg.Start_Time == dtStart) // Same IFVG we already hold - nothing new
         {
            return false;
         }

         fvg.Top = fTop;
         fvg.Bottom = fBottom;
         fvg.Start_Time = dtStart;
         fvg.End_Time = iTime(_Symbol, PERIOD_CURRENT, 0);
         fvg.Number = fvg.Number + 1;

         M_CreateBox(fvg.Name, fvg.Number, fvg.Start_Time, fvg.End_Time, fvg.Top, fvg.Bottom, clr);
         M_LogInfo("FVG to inverse found, TOP=" + DoubleToString(fvg.Top) + " BOTTOM=" + DoubleToString(fvg.Bottom) + " Start=" + TimeToString(fvg.Start_Time));

         return true;
      }
   }

   return false;
}
