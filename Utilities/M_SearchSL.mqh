double M_SearchSL()
{
   int FVGReachedIndex = iBarShift(_Symbol, PERIOD_CURRENT, stGVL.dtFVGReached_Time_HTF);
   double tmpSL = 0;
   double tmpPrice = 0;
   
   if(stGVL.eCurrentDirection == DIR_LONG)
   {
      if(eSLPlacement == FVG)
      {
         tmpSL = stGVL.LastFVGBottom_HTF;
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
      if(eSLPlacement == FVG)
      {
         tmpSL = stGVL.LastFVGTop_HTF;
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