bool M_HandleBoxes()
{
   if(stGVL.LastFVGTop != 0 && stGVL.LastFVGBottom != 0)
   {
      M_ExtendBox(stGVL.Rect_FVG, stGVL.Rect_ActFVG_Number);
   }
   
   return true;
}