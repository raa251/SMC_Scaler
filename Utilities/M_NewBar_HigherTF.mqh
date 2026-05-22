void M_NewBar_HigherTF()
{
   if(stGVL.eStateMachine != SM_WAIT_FOR_START)
   {
      return;
   }
   if(stGVL.CandleHigherTF[2].open < stGVL.CandleHigherTF[2].close) // middle candle is bullish
   {
      bool bCondition1 = stGVL.CandleHigherTF[3].high < stGVL.CandleHigherTF[1].low;
      
      bool bCondition2 = M_EMABullish(true);
      
      bool bCondition3 = stGVL.eTrendStructure == DIR_LONG || eTrendFilter != STRUCTURE;
      
      if(!bCondition1)
      {
         return; // No FVG
      }
      else if(!bCondition2)
      {
         return; // EMA is not bullish
      }
      else if(!bCondition3)
      {
         M_LogWarning("Structure is not bearish");
         return; // Structure is not bullish
      }
      else
      { // fair value gap
         stGVL.LastFVGTop_HTF     = stGVL.CandleHigherTF[1].low;
         stGVL.LastFVGBottom_HTF  = stGVL.CandleHigherTF[3].high;
         stGVL.LastFVGIndex_HTF   = 2;
         
         stGVL.eCurrentDirection = DIR_LONG;
         
         stGVL.dtFVGCreated_Time_HTF = iTime(_Symbol, PERIOD_CURRENT, 0);
         datetime barTime = iTime(_Symbol, eHigherTF, 0);
         datetime barTimeFVGStart = iTime(_Symbol, eHigherTF, stGVL.LastFVGIndex_HTF);
         stGVL.Rect_ActFVG_Number_HTF = stGVL.Rect_ActFVG_Number_HTF + 1;
         M_CreateBox(stGVL.Rect_FVG_HTF, stGVL.Rect_ActFVG_Number_HTF, barTimeFVGStart, barTime, stGVL.LastFVGTop_HTF, stGVL.LastFVGBottom_HTF, clrYellow);
         
         M_LogInfo("FVG for buy found, TOP=" + DoubleToString(stGVL.LastFVGTop_HTF) + " BOTTOM=" + DoubleToString(stGVL.LastFVGBottom_HTF));
         stGVL.eStateMachine = SM_WAIT_FVG_REACHED;
      }
   }
   else if(stGVL.CandleHigherTF[2].open > stGVL.CandleHigherTF[2].close) // middle candle is bearish
   {
      bool bCondition1 = stGVL.CandleHigherTF[1].high < stGVL.CandleHigherTF[3].low;
      
      bool bCondition2 = M_EMABearish(true);
      
      bool bCondition3 = stGVL.eTrendStructure == DIR_SHORT || eTrendFilter != STRUCTURE;
      
      if(!bCondition1)
      {
         return; // No FVG
      }
      else if(!bCondition2)
      {
         return; // EMA is not bearish
      }
      else if(!bCondition3)
      {
         M_LogWarning("Structure is not bearish");
         return; // Structure is not bearish
      }
      else
      { // fair value gap
         stGVL.LastFVGTop_HTF     = stGVL.CandleHigherTF[3].low;
         stGVL.LastFVGBottom_HTF  = stGVL.CandleHigherTF[1].high;
         stGVL.LastFVGIndex_HTF   = 2;
         
         stGVL.eCurrentDirection = DIR_SHORT;
         
         stGVL.dtFVGCreated_Time_HTF = iTime(_Symbol, PERIOD_CURRENT, 0);
         datetime barTime = iTime(_Symbol, eHigherTF, 0);
         datetime barTimeFVGStart = iTime(_Symbol, eHigherTF, stGVL.LastFVGIndex_HTF);
         stGVL.Rect_ActFVG_Number_HTF = stGVL.Rect_ActFVG_Number_HTF + 1;
         M_CreateBox(stGVL.Rect_FVG_HTF, stGVL.Rect_ActFVG_Number_HTF, barTimeFVGStart, barTime, stGVL.LastFVGTop_HTF, stGVL.LastFVGBottom_HTF, clrYellow);
         
         M_LogInfo("FVG for sell found, TOP=" + DoubleToString(stGVL.LastFVGTop_HTF) + " BOTTOM=" + DoubleToString(stGVL.LastFVGBottom_HTF));
         stGVL.eStateMachine = SM_WAIT_FVG_REACHED;
      }
   }
}