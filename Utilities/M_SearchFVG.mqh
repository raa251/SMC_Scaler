// Scans the current-timeframe candles for an inverse FVG opposing stGVL.stFVG_HTF and always
// takes the freshest (nearest-in-time) valid match - i.e. the first one hit scanning from i=1
// (most recent closed candle) upward.
//
// The zone check (Condition2) only excludes candidates beyond the HTF FVG's FAR boundary (the
// one price would have to break for the setup to be invalidated) - not its near boundary. This
// matters because this function keeps getting called for as long as we're waiting for
// inversion, including after price has already entered the HTF FVG (SM_WAIT_HTF_FVG_EXIT /
// SM_WAIT_FVG_INVERSED). A stricter "candidate must sit above/below the HTF FVG entirely" check
// would only ever match candidates found before price touched the zone - any IFVG that forms
// deeper inside the zone as price keeps moving through it would always fail that check, so with
// bSearchFVGWithinHTF_FVG=true price could fall straight through the whole zone forming several
// fresh IFVGs and none of them would ever be picked up.
//
// The held `fvg` only ever moves FORWARD in time:
//   - freshest match has the same Start_Time as the held FVG -> nothing to do, still holding it.
//   - freshest match is NEWER than the held FVG -> price moved further into the HTF FVG and a
//     new IFVG formed there; switch to it, that is the whole point of calling this repeatedly
//     while waiting for inversion.
//   - freshest match is OLDER than the held FVG -> the FVG we were holding has dropped out of
//     the scan (invalidated/taken out), leaving only stale candidates behind it. Do NOT fall
//     back to one of those - that is exactly the flip-flopping between IFVGs this used to cause.
//     Treat it as "nothing usable found" and let the caller's own max-candles-to-inverse timeout
//     handle the held FVG expiring.
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

      if(dir == DIR_LONG && stGVL.Candle[i+1].open > stGVL.Candle[i+1].close) // middle candle is bearish
      {
         bool Condition1 = stGVL.Candle[i+2].low > stGVL.Candle[i].high;                 // Gap between Candle i and i+2 existing
         bool Condition2 = stGVL.Candle[i].high > stGVL.stFVG_HTF.Bottom;                // FVG is above the HTF FVG's far (bottom) boundary - inside the zone or beyond it
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
         bool Condition2 = stGVL.Candle[i].low < stGVL.stFVG_HTF.Top;                    // FVG is below the HTF FVG's far (top) boundary - inside the zone or beyond it
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

      if(!bMatch)
      {
         continue;
      }

      // First match hit while scanning from the most recent candle backward is, by
      // construction, the freshest valid IFVG currently available.
      datetime dtCandidateStart = iTime(_Symbol, PERIOD_CURRENT, i + 1);

      if(dtCandidateStart <= fvg.Start_Time) // Not newer than what we already hold - ignore it
      {
         return false;
      }

      fvg.Top = fTop;
      fvg.Bottom = fBottom;
      fvg.Start_Time = dtCandidateStart;
      fvg.End_Time = iTime(_Symbol, PERIOD_CURRENT, 0);
      fvg.Number = fvg.Number + 1;

      M_CreateBox(fvg.Name, fvg.Number, fvg.Start_Time, fvg.End_Time, fvg.Top, fvg.Bottom, clrBlue);
      M_LogInfo("FVG to inverse found, TOP=" + DoubleToString(fvg.Top) + " BOTTOM=" + DoubleToString(fvg.Bottom) + " Start=" + TimeToString(fvg.Start_Time));

      return true;
   }

   return false; // Nothing valid at all this scan
}
