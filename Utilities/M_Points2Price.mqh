bool M_Points2Price()
{
   double tick_size = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   stGVL.fMinDiffEMA_Price = nMinDiffEMA * tick_size;
   
   return true;
}