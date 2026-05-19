bool M_SpreadOK(bool bLog)
{
   int nSpread = (int)SymbolInfoInteger(_Symbol, SYMBOL_SPREAD);
   
   if(nSpread <= nMaxSpread || nMaxSpread==0)
   {
      return true;
   }
   else
   {
      if(bLog)
      {
         M_LogInfo("Spread to high, spread=" + IntegerToString(nSpread));
      }
      return false;
   }
}