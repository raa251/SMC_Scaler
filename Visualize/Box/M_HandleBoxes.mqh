bool M_HandleBoxes()
{
   if(stGVL.LastFVGTop != 0 && stGVL.LastFVGBottom != 0)
   {
      M_ExtendBox(stGVL.Rect_FVG, stGVL.Rect_ActFVG_Number);
   }
   
   if(stGVL.LastFVGTop_HTF != 0 && stGVL.LastFVGBottom_HTF != 0)
   {
      M_ExtendBox(stGVL.Rect_FVG_HTF, stGVL.Rect_ActFVG_Number_HTF);
   }
   
   return true;
}