double M_SearchNewHigh(MqlRates &aCandles[])
{
   int nMiddleCandleIndexRight = nFreeCandlesForExtrema_Right + 1;
   int nMiddleCandleIndexLeft  = nFreeCandlesForExtrema_Right + 2;
   
   bool bCondition1 = true;
   for(int ii = 1; ii <= nFreeCandlesForExtrema_Right; ii++) // Check right side
   {
      if(aCandles[ii].close > aCandles[nMiddleCandleIndexRight].open || aCandles[ii].open > aCandles[nMiddleCandleIndexRight].open)
      {
         bCondition1 = false;
         break;
      }
   }
   
   bool bCondition2 = true;
   for(int ii = nMiddleCandleIndexLeft + 1; ii <= nFreeCandlesForExtrema_Left + 2 + nFreeCandlesForExtrema_Right; ii++) // Check left side
   {
      if(aCandles[ii].close > aCandles[nMiddleCandleIndexLeft].close || aCandles[ii].open > aCandles[nMiddleCandleIndexLeft].close)
      {
         bCondition2 = false;
         break;
      }
   }
   
   bool bCondition3 = aCandles[nMiddleCandleIndexRight].open > aCandles[nMiddleCandleIndexRight].close;   // Bearish candle
   bool bCondition4 = aCandles[nMiddleCandleIndexLeft].open < aCandles[nMiddleCandleIndexLeft].close;     // Bullish candle
   
   if(bCondition1 && bCondition2 && bCondition3 && bCondition4)
   {
      return aCandles[nMiddleCandleIndexRight].open;
   }
   else
   {
      return 0;
   }
}