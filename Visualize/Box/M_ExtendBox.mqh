bool M_ExtendBox(string BoxName, int BoxNumber)
{
   string FullBoxName = BoxName + IntegerToString(BoxNumber);
   
   ResetLastError();
   
   if(ObjectFind(0, FullBoxName) < 0)
   {
      M_LogError("Object not found: " + FullBoxName);
      return false;
   }
   else
   {
      double price = ObjectGetDouble(0, FullBoxName, OBJPROP_PRICE, 1);
      datetime barTime = iTime(_Symbol, PERIOD_CURRENT, 0);
      ObjectMove(0, FullBoxName, 1, barTime, price);
      
      if(GetLastError() != 0)
      {
         M_LogError("An error occured when extending box " + FullBoxName + ", Error: " + IntegerToString(GetLastError()));
      }
   }
   
   return true;
}