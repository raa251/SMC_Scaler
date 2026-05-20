bool M_CreateBox(string name, int BoxNr, datetime time1, datetime time2, double high, double low, color clr)
{
   string Fullname = name + IntegerToString(BoxNr);
   ResetLastError();
   ObjectCreate(0, Fullname, OBJ_RECTANGLE, 0, time1, low, time2, high);
   ObjectSetInteger(0, Fullname, OBJPROP_COLOR, clr);
   ObjectSetInteger(0, Fullname, OBJPROP_STYLE, STYLE_SOLID);
   ObjectSetInteger(0, Fullname, OBJPROP_WIDTH, 2);
   ObjectSetInteger(0, Fullname, OBJPROP_BACK, true);        // behind candles
   ObjectSetInteger(0, Fullname, OBJPROP_RAY_RIGHT, false);
   ObjectSetInteger(0, Fullname, OBJPROP_RAY_LEFT, false);
   ObjectSetInteger(0, Fullname, OBJPROP_FILL, true);        // fill
   
   if(GetLastError() != 0)
   {
      M_LogError("An error occured when creating box " + Fullname + ", Error: " + IntegerToString(GetLastError()));
   }
   else
   {
      M_LogInfo("Box " + Fullname + " created");
   }
   
   return true;
}