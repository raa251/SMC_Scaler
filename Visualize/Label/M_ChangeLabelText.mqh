bool M_ChangeLabelText(string name, string text)
{
   if(ObjectFind(0, name) >= 0)
   {
      ResetLastError();
      ObjectSetString(0, name, OBJPROP_TEXT, text);
      
      if(GetLastError() != 0)
      {
         M_LogError("An error occured when changing label text of " + name + ", Error: " + IntegerToString(GetLastError()));
         return false;
      }
      else
      {
         return false;
      }
   }
   else
   {
      return false;
   }
}