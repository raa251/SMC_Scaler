bool M_DipOK(int CandlesToLookback, E_DIRECTION dir)
{  
   bool DipOK;
   
   if(fMaxDipIntoFVG <= 0)
   {
      DipOK = true;
   }
   else
   {
      DipOK = true;
      if(dir == DIR_LONG)
      {
         double DipMinimum = stGVL.LastFVGTop - (stGVL.LastFVGTop - stGVL.LastFVGBottom) * (fMaxDipIntoFVG / 100);
         for(int i = 1; i <= CandlesToLookback; i++)
         {
            if(stGVL.Candle[i].low < DipMinimum)
            {
               DipOK = false;
               break;
            }
         }
      }
      else
      {
         double DipMaximum = stGVL.LastFVGBottom + (stGVL.LastFVGTop - stGVL.LastFVGBottom) * (fMaxDipIntoFVG / 100);
         for(int i = 1; i <= CandlesToLookback; i++)
         {
            if(stGVL.Candle[i].high > DipMaximum)
            {
               DipOK = false;
               break;
            }
         }
      }
   }
   
   if(!DipOK)
   {
      M_LogWarning("Wigs dipped too far into the FVG");
   }
   
   return DipOK;
}