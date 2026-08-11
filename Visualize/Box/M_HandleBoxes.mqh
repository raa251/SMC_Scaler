bool M_HandleBoxes()
{
   if(stGVL.stFVG.Top != 0 && stGVL.stFVG.Bottom != 0)
   {
      M_ExtendBox(stGVL.stFVG.Name, stGVL.stFVG.Number);
   }

   if(stGVL.stFVG_HTF.Top != 0 && stGVL.stFVG_HTF.Bottom != 0)
   {
      M_ExtendBox(stGVL.stFVG_HTF.Name, stGVL.stFVG_HTF.Number);
   }

   return true;
}