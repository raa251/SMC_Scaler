// Scans the current-timeframe candles for the BEST inverse FVG opposing stGVL.stFVG_HTF -
// "best" meaning the one requiring the smallest further price move to invert (lowest Top
// for a long, highest Bottom for a short), not just the nearest one in time. Scanning the
// whole lookback window instead of stopping at the first match matters once this is called
// repeatedly (e.g. once per bar while SM_WAIT_FVG_INVERSED is waiting): taking the first
// time-ordered match could jump from a close, easy-to-invert candidate to a technically
// still-valid but far older/farther one once the close ones got invalidated by price action
// (confirmed in the tester log: switched from a 0.02-wide zone right at price to one 3 points
// away and 10 candles older, which then timed out without ever inverting).
//
// Safe to call repeatedly - if the best match is the same one already held in `fvg` (same
// Start_Time), nothing is redrawn/relogged and it returns false. Only a genuinely different
// (better) IFVG updates `fvg` and returns true.
bool M_SearchFVG(ST_FVG &fvg, E_DIRECTION dir, int nLookback)
{
   int NrCLDs = MathMin(nLookback, 97);
   double tmpLow = DBL_MAX;
   double tmpHigh = 0;

   double bestTop = 0;
   double bestBottom = 0;
   int bestIndex = -1;
   double bestDistance = DBL_MAX;

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
         }
      }

      if(bMatch)
      {
         // Lower is "closer to invert" either way: a long needs Top undercut (smaller Top
         // is easier), a short needs Bottom undercut from above (larger Bottom is easier,
         // so negate it to keep "smaller distance = better" uniform for both directions).
         double distance = (dir == DIR_LONG) ? fTop : -fBottom;
         if(distance < bestDistance)
         {
            bestDistance = distance;
            bestTop = fTop;
            bestBottom = fBottom;
            bestIndex = i;
         }
      }
   }

   if(bestIndex < 0)
   {
      return false;
   }

   datetime dtStart = iTime(_Symbol, PERIOD_CURRENT, bestIndex + 1);

   if(fvg.Start_Time == dtStart) // Same IFVG we already hold - nothing new
   {
      return false;
   }

   fvg.Top = bestTop;
   fvg.Bottom = bestBottom;
   fvg.Start_Time = dtStart;
   fvg.End_Time = iTime(_Symbol, PERIOD_CURRENT, 0);
   fvg.Number = fvg.Number + 1;
   fvg.Touched = false;

   M_CreateBox(fvg.Name, fvg.Number, fvg.Start_Time, fvg.End_Time, fvg.Top, fvg.Bottom, clrBlue);
   M_LogInfo("FVG to inverse found, TOP=" + DoubleToString(fvg.Top) + " BOTTOM=" + DoubleToString(fvg.Bottom) + " Start=" + TimeToString(fvg.Start_Time));

   return true;
}
