bool M_TrendOK(E_DIRECTION eDir)
{
   bool bResult = false;
   if(eTrendFilter == EMA)
   {
      if(eDir == DIR_LONG)
      {
         bResult = M_EMABullish(true);
      }
      else
      {
         bResult = M_EMABearish(true);
      }
   }
   
   else if(eTrendFilter == STRUCTURE)
   {
      if(stGVL.eTrendStructure_HTF == eDir)
      {
         bResult = true;
      }
      else
      {
         bResult = false;
      }
   }
   
   else
   {
      bResult = true;
   }
   
   return bResult;
}