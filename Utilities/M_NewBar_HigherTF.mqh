void M_NewBar_HigherTF()
{
   M_StructureTrendHTF();
   
   if(stGVL.eStateMachine != SM_WAIT_FOR_START)
   {
      return;
   }
   if(stGVL.CandleHigherTF[2].open < stGVL.CandleHigherTF[2].close) // middle candle is bullish
   {
      bool bCondition1 = stGVL.CandleHigherTF[3].high <= stGVL.CandleHigherTF[1].low;
      
      bool bCondition2 = M_TrendOK(DIR_LONG);
      
      bool bCondition3 = stGVL.CandleHigherTF[1].low - stGVL.CandleHigherTF[3].high >= stGVL.fMinFVGSize_Price || stGVL.fMinFVGSize_Price == 0;
      
      bool bCondition4 = stGVL.CandleHigherTF[1].low - stGVL.CandleHigherTF[3].high <= stGVL.fMaxFVGSize_Price || stGVL.fMaxFVGSize_Price == 0;
      
      if(!bCondition1)
      {
         return; // No FVG
      }
      else if(!bCondition2)
      {
         return; // Structure is not bullish
      }
      else if(!bCondition3)
      {
         return; // FVG is to small
      }
      else if(!bCondition4)
      {
         return; // FVG is to big
      }
      else
      { // fair value gap
         int nStartIndexCTF = iBarShift(_Symbol, PERIOD_CURRENT, iTime(_Symbol, eHigherTF, 2));

         stGVL.stFVG_HTF.Top        = stGVL.CandleHigherTF[1].low;
         stGVL.stFVG_HTF.Bottom     = stGVL.CandleHigherTF[3].high;
         stGVL.stFVG_HTF.Start_Time = iTime(_Symbol, PERIOD_CURRENT, nStartIndexCTF);
         stGVL.stFVG_HTF.End_Time   = iTime(_Symbol, PERIOD_CURRENT, 0);
         stGVL.stFVG_HTF.Number     = stGVL.stFVG_HTF.Number + 1;
         stGVL.stFVG_HTF.Touched    = false;

         stGVL.eCurrentDirection = DIR_LONG;

         stGVL.dtFVGCreated_Time_HTF = iTime(_Symbol, PERIOD_CURRENT, 0);
         M_CreateBox(stGVL.stFVG_HTF.Name, stGVL.stFVG_HTF.Number, stGVL.stFVG_HTF.Start_Time, stGVL.stFVG_HTF.End_Time, stGVL.stFVG_HTF.Top, stGVL.stFVG_HTF.Bottom, clrGreen);

         M_LogInfo("FVG for buy found, TOP=" + DoubleToString(stGVL.stFVG_HTF.Top) + " BOTTOM=" + DoubleToString(stGVL.stFVG_HTF.Bottom));
         stGVL.eStateMachine = SM_WAIT_FVG_REACHED;
      }
   }
   else if(stGVL.CandleHigherTF[2].open > stGVL.CandleHigherTF[2].close) // middle candle is bearish
   {
      bool bCondition1 = stGVL.CandleHigherTF[1].high < stGVL.CandleHigherTF[3].low;
      
      bool bCondition2 = M_TrendOK(DIR_SHORT);
      
      bool bCondition3 = stGVL.CandleHigherTF[3].low - stGVL.CandleHigherTF[1].high >= stGVL.fMinFVGSize_Price || stGVL.fMinFVGSize_Price == 0;
      
      bool bCondition4 = stGVL.CandleHigherTF[3].low - stGVL.CandleHigherTF[1].high <= stGVL.fMaxFVGSize_Price || stGVL.fMaxFVGSize_Price == 0;
      
      if(!bCondition1)
      {
         return; // No FVG
      }
      else if(!bCondition2)
      {
         return; // Structure is not bearish
      }
      else if(!bCondition3)
      {
         return; // FVG is to small
      }
      else if(!bCondition4)
      {
         return; // FVG is to big
      }
      else
      { // fair value gap
         int nStartIndexCTF = iBarShift(_Symbol, PERIOD_CURRENT, iTime(_Symbol, eHigherTF, 2));

         stGVL.stFVG_HTF.Top        = stGVL.CandleHigherTF[3].low;
         stGVL.stFVG_HTF.Bottom     = stGVL.CandleHigherTF[1].high;
         stGVL.stFVG_HTF.Start_Time = iTime(_Symbol, PERIOD_CURRENT, nStartIndexCTF);
         stGVL.stFVG_HTF.End_Time   = iTime(_Symbol, PERIOD_CURRENT, 0);
         stGVL.stFVG_HTF.Number     = stGVL.stFVG_HTF.Number + 1;
         stGVL.stFVG_HTF.Touched    = false;

         stGVL.eCurrentDirection = DIR_SHORT;

         stGVL.dtFVGCreated_Time_HTF = iTime(_Symbol, PERIOD_CURRENT, 0);
         M_CreateBox(stGVL.stFVG_HTF.Name, stGVL.stFVG_HTF.Number, stGVL.stFVG_HTF.Start_Time, stGVL.stFVG_HTF.End_Time, stGVL.stFVG_HTF.Top, stGVL.stFVG_HTF.Bottom, clrRed);

         M_LogInfo("FVG for sell found, TOP=" + DoubleToString(stGVL.stFVG_HTF.Top) + " BOTTOM=" + DoubleToString(stGVL.stFVG_HTF.Bottom));
         stGVL.eStateMachine = SM_WAIT_FVG_REACHED;
      }
   }
}