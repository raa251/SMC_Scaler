void M_SM_WAIT_HTF_FVG_EXIT()
{
   int FVGReachedIndex = iBarShift(_Symbol, PERIOD_CURRENT, stGVL.dtFVGReached_Time_HTF);
   
   if((stGVL.Candle[1].close > stGVL.LastFVGTop_HTF || stGVL.Candle[1].close < stGVL.LastFVGBottom_HTF) && !stGVL.bWaitForNewCurrBar)
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
         stGVL.LastFVGTop     = stGVL.Candle[3].low;
         stGVL.LastFVGBottom  = stGVL.Candle[1].high;
         stGVL.LastFVGIndex   = 2;
         
         datetime barTime = iTime(_Symbol, PERIOD_CURRENT, 0);
         datetime barTimeFVGStart = iTime(_Symbol, PERIOD_CURRENT, stGVL.LastFVGIndex);
         stGVL.Rect_ActFVG_Number = stGVL.Rect_ActFVG_Number + 1;
         M_CreateBox(stGVL.Rect_FVG, stGVL.Rect_ActFVG_Number, barTimeFVGStart, barTime, stGVL.LastFVGTop, stGVL.LastFVGBottom, clrBlue);
         
         M_LogInfo("FVG to inverse found within HTF FVG, TOP=" + DoubleToString(stGVL.LastFVGTop) + " BOTTOM=" + DoubleToString(stGVL.LastFVGBottom) + " Index=" + IntegerToString(stGVL.LastFVGIndex));
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
         stGVL.LastFVGTop     = stGVL.Candle[1].low;
         stGVL.LastFVGBottom  = stGVL.Candle[3].high;
         stGVL.LastFVGIndex   = 2;
         
         datetime barTime = iTime(_Symbol, PERIOD_CURRENT, 0);
         datetime barTimeFVGStart = iTime(_Symbol, PERIOD_CURRENT, stGVL.LastFVGIndex);
         stGVL.Rect_ActFVG_Number = stGVL.Rect_ActFVG_Number + 1;
         M_CreateBox(stGVL.Rect_FVG, stGVL.Rect_ActFVG_Number, barTimeFVGStart, barTime, stGVL.LastFVGTop, stGVL.LastFVGBottom, clrBlue);
         
         M_LogInfo("FVG to inverse found within HTF FVG, TOP=" + DoubleToString(stGVL.LastFVGTop) + " BOTTOM=" + DoubleToString(stGVL.LastFVGBottom) + " Index=" + IntegerToString(stGVL.LastFVGIndex));
         
         stGVL.eStateMachine = SM_WAIT_FVG_INVERSED;
      }
   }
}