void M_NewBar_HigherTF()
{
   if(stGVL.eStateMachine != SM_WAIT_FOR_START)
   {
      return;
   }
   if(stGVL.CandleHigherTF[2].open < stGVL.CandleHigherTF[2].close) // middle candle is bullish
   {
      // Check for gap
      bool Condition1 = stGVL.CandleHigherTF[3].high < stGVL.CandleHigherTF[1].low;
      
      if(Condition1)
      { // fair value gap
         stGVL.LastFVGTop     = stGVL.CandleHigherTF[1].low;
         stGVL.LastFVGBottom  = stGVL.CandleHigherTF[3].high;
         stGVL.LastFVGIndex   = 2;
         
         stGVL.eCurrentDirection = DIR_LONG;
         
         stGVL.dtFVGCreated_Time = iTime(_Symbol, PERIOD_CURRENT, 0);
         datetime barTime = iTime(_Symbol, eHigherTF, 0);
         datetime barTimeFVGStart = iTime(_Symbol, eHigherTF, stGVL.LastFVGIndex);
         stGVL.Rect_ActFVG_Number = stGVL.Rect_ActFVG_Number + 1;
         M_CreateBox(stGVL.Rect_FVG, stGVL.Rect_ActFVG_Number, barTimeFVGStart, barTime, stGVL.LastFVGTop, stGVL.LastFVGBottom, clrYellow);
         
         M_LogInfo("FVG for buy found, TOP=" + DoubleToString(stGVL.LastFVGTop) + " BOTTOM=" + DoubleToString(stGVL.LastFVGBottom));
         stGVL.eStateMachine = SM_WAIT_FVG_REACHED;
      }
   }
   else if(stGVL.CandleHigherTF[2].open > stGVL.CandleHigherTF[2].close) // middle candle is bearish
   {
      // Gap between Candle i and i+2 existing and is big enough
      bool Condition1 = stGVL.CandleHigherTF[1].high < stGVL.CandleHigherTF[3].low;
      
      if(Condition1)
      { // fair value gap
         stGVL.LastFVGTop     = stGVL.CandleHigherTF[3].low;
         stGVL.LastFVGBottom  = stGVL.CandleHigherTF[1].high;
         stGVL.LastFVGIndex   = 2;
         
         stGVL.eCurrentDirection = DIR_SHORT;
         
         stGVL.dtFVGCreated_Time = iTime(_Symbol, PERIOD_CURRENT, 0);
         datetime barTime = iTime(_Symbol, eHigherTF, 0);
         datetime barTimeFVGStart = iTime(_Symbol, eHigherTF, stGVL.LastFVGIndex);
         stGVL.Rect_ActFVG_Number = stGVL.Rect_ActFVG_Number + 1;
         M_CreateBox(stGVL.Rect_FVG, stGVL.Rect_ActFVG_Number, barTimeFVGStart, barTime, stGVL.LastFVGTop, stGVL.LastFVGBottom, clrYellow);
         
         M_LogInfo("FVG for sell found, TOP=" + DoubleToString(stGVL.LastFVGTop) + " BOTTOM=" + DoubleToString(stGVL.LastFVGBottom));
         stGVL.eStateMachine = SM_WAIT_FVG_REACHED;
      }
   }
}