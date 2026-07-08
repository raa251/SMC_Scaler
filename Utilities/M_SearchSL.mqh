double M_SearchSL()
{
   int FVGReachedIndex = iBarShift(_Symbol, PERIOD_CURRENT, stGVL.dtFVGReached_Time_HTF);
   double tmpSL = 0;
   double tmpPrice = 0;
   
   if(stGVL.eCurrentDirection == DIR_LONG)
   {
      if(eSLPlacement == END_OF_FVG)
      {
         tmpSL = stGVL.LastFVGBottom_HTF;
      }
      else if(eSLPlacement == MIDDLE_OF_FVG)
      {
         tmpSL = stGVL.LastFVGTop_HTF - ((stGVL.LastFVGTop_HTF - stGVL.LastFVGBottom_HTF) / 2);
      }
      else
      {
         for(int i = 1; i <= FVGReachedIndex; i++) // Search for the Stoploss at the minimum body between now and liquidity cross
         {
            if(eSLPlacement == LAST_STRUCTURE_BODY)
            {
               tmpPrice = stGVL.Candle[i].close;
            }
            else
            {
               tmpPrice = stGVL.Candle[i].low;
            }
            
            if(tmpPrice < tmpSL || tmpSL == 0)
            {
               tmpSL = tmpPrice;
            }
         }
      }
   }
   else
   {
      if(eSLPlacement == END_OF_FVG)
      {
         tmpSL = stGVL.LastFVGTop_HTF;
      }
      else if(eSLPlacement == MIDDLE_OF_FVG)
      {
         tmpSL = stGVL.LastFVGBottom_HTF + ((stGVL.LastFVGTop_HTF - stGVL.LastFVGBottom_HTF) / 2);
      }
      else
      {
         for(int i = 1; i <= FVGReachedIndex; i++) // Search for the Stoploss at the maximum body between now and liquidity cross
         {
            if(eSLPlacement == LAST_STRUCTURE_BODY)
            {
               tmpPrice = stGVL.Candle[i].close;
            }
            else
            {
               tmpPrice = stGVL.Candle[i].high;
            }
            
            if(tmpPrice > tmpSL || tmpSL == 0)
            {
               tmpSL = tmpPrice;
            }
         }
      }
   }
   
   return tmpSL;
}