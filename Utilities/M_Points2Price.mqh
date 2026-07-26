bool M_Points2Price()
{
   double tmp;
   double tick_size = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   
   tmp = nMinDiffEMA;
   stGVL.fMinDiffEMA_Price = tmp * tick_size;
   
   tmp = nDistanceMoveRunnerSLTP1;
   stGVL.fDistanceMoveRunnerSLTP1_Price = tmp * tick_size;
   
   tmp = nMinFVGSize;
   stGVL.fMinFVGSize_Price = tmp * tick_size;
   
   tmp = nMaxFVGSize;
   stGVL.fMaxFVGSize_Price = tmp * tick_size;
   
   tmp = nMinIFVGSize;
   stGVL.fMinIFVGSize_Price = tmp * tick_size;
   
   tmp = nMaxIFVGSize;
   stGVL.fMaxIFVGSize_Price = tmp * tick_size;
   
   tmp = nMaxDistanceFVGInverse;
   stGVL.fMaxDistanceFVGInverse_Price = tmp * tick_size;
   
   return true;
}