bool M_CheckCloseRunner()
{
   bool bResult = false;
   
   switch(eRunnerClose)
   {
      case EMA:
         if(stGVL.eCurrentDirection == DIR_LONG)
         {
            bResult = M_EMACloseBuy();
         }
         else
         {
            bResult = M_EMACloseSell();
         }
         break;
         
      case STRUCTURE:
         bResult = stGVL.eCurrentDirection != stGVL.eTrendStructure_CTF;
   }
   
   return bResult;
}