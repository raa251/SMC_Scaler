bool M_CreateLabel(string name, int XPos, int YPos)
{
   ResetLastError();
   
   if(!ObjectCreate(0, name, OBJ_LABEL, 0, 0, 0))
   {
      M_LogError("An error occured when creating a label, Error: " + IntegerToString(GetLastError()));
   }
   
   ObjectSetString(0, name, OBJPROP_TEXT, "Initialized");

   // Position (distance to top left corner)
   ObjectSetInteger(0, name, OBJPROP_CORNER, CORNER_LEFT_UPPER);
   ObjectSetInteger(0, name, OBJPROP_XDISTANCE, XPos);
   ObjectSetInteger(0, name, OBJPROP_YDISTANCE, YPos);

   // Style
   ObjectSetInteger(0, name, OBJPROP_FONTSIZE, 10);
   ObjectSetString(0, name, OBJPROP_FONT, "Arial");
   ObjectSetInteger(0, name, OBJPROP_COLOR, clrWhite);
   
   if(GetLastError() != 0)
   {
      M_LogError("An error occured when creating label " + name + ", Error: " + IntegerToString(GetLastError()));
   }
   else
   {
      M_LogInfo("Label " + name + " created");
   }
   
   return true;
}