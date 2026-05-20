void M_NewBar_CurrTF()
{
   if(stGVL.dtTimeCurrent_HigherTF != stGVL.dtTimeLast_HigherTF)
   {
      M_NewBar_HigherTF();
      stGVL.dtTimeLast_HigherTF = stGVL.dtTimeCurrent_HigherTF;
   }
   
   M_HandleBoxes();
}