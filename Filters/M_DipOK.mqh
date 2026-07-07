bool M_DipOK(int CandlesToLookback)
{  
   bool DipOK;
   
   if(fMaxDipIntoFVG <= 0)
   {
      DipOK = true;
   }
   else
   {
      DipOK = true;
      if(stGVL.eCurrentDirection == DIR_LONG)
      {
         double DipMinimum = stGVL.LastFVGTop_HTF - (stGVL.LastFVGTop_HTF - stGVL.LastFVGBottom_HTF) * (fMaxDipIntoFVG / 100);
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
         double DipMaximum = stGVL.LastFVGBottom_HTF + (stGVL.LastFVGTop_HTF - stGVL.LastFVGBottom_HTF) * (fMaxDipIntoFVG / 100);
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