void M_SM_WAIT_HTF_FVG_EXIT()
{
   int FVGReachedIndex = iBarShift(_Symbol, PERIOD_CURRENT, stGVL.dtFVGReached_Time_HTF);

   if((stGVL.Candle[1].close > stGVL.stFVG_HTF.Top || stGVL.Candle[1].close < stGVL.stFVG_HTF.Bottom) && !stGVL.bWaitForNewCurrBar)
   {
      // Close is outside FVG
      stGVL.eStateMachine = SM_RESET;
      return;
   }

   if(stGVL.Candle[2].close < stGVL.Candle[2].open && stGVL.eCurrentDirection == DIR_LONG) // Bearish candle
   {
      // LONG FVG
      // Gap between Candle 1 and 3 existing
      bool Condition1 = stGVL.Candle[3].low > stGVL.Candle[1].high;

      if(Condition1)
      { // fair value gap
         stGVL.stFVG.Top        = stGVL.Candle[3].low;
         stGVL.stFVG.Bottom     = stGVL.Candle[1].high;
         stGVL.stFVG.Start_Time = iTime(_Symbol, PERIOD_CURRENT, 2);
         stGVL.stFVG.End_Time   = iTime(_Symbol, PERIOD_CURRENT, 0);
         stGVL.stFVG.Number     = stGVL.stFVG.Number + 1;

         M_CreateBox(stGVL.stFVG.Name, stGVL.stFVG.Number, stGVL.stFVG.Start_Time, stGVL.stFVG.End_Time, stGVL.stFVG.Top, stGVL.stFVG.Bottom, clrBlue);

         M_LogInfo("FVG to inverse found within HTF FVG, TOP=" + DoubleToString(stGVL.stFVG.Top) + " BOTTOM=" + DoubleToString(stGVL.stFVG.Bottom));
         stGVL.eStateMachine = SM_WAIT_FVG_INVERSED;
      }
   }
   else if(stGVL.Candle[2].close > stGVL.Candle[2].open && stGVL.eCurrentDirection == DIR_SHORT) // Bullish candle
   {
      // SHORT
      // Gap between Candle 1 and 3 existing and is big enough
      bool Condition1 = stGVL.Candle[3].high < stGVL.Candle[1].low;

      if(Condition1)
      { // fair value gap
         stGVL.stFVG.Top        = stGVL.Candle[1].low;
         stGVL.stFVG.Bottom     = stGVL.Candle[3].high;
         stGVL.stFVG.Start_Time = iTime(_Symbol, PERIOD_CURRENT, 2);
         stGVL.stFVG.End_Time   = iTime(_Symbol, PERIOD_CURRENT, 0);
         stGVL.stFVG.Number     = stGVL.stFVG.Number + 1;

         M_CreateBox(stGVL.stFVG.Name, stGVL.stFVG.Number, stGVL.stFVG.Start_Time, stGVL.stFVG.End_Time, stGVL.stFVG.Top, stGVL.stFVG.Bottom, clrBlue);

         M_LogInfo("FVG to inverse found within HTF FVG, TOP=" + DoubleToString(stGVL.stFVG.Top) + " BOTTOM=" + DoubleToString(stGVL.stFVG.Bottom));

         stGVL.eStateMachine = SM_WAIT_FVG_INVERSED;
      }
   }
}
