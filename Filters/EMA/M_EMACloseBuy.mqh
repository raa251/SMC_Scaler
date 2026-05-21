bool M_EMACloseBuy()
{
   if(stGVL.SmallEMABuffer_CurrTF[1] < stGVL.BigEMABuffer_CurrTF[1])
   {
      M_LogWarning("Close buy because EMA crossed, small=" + DoubleToString(stGVL.SmallEMABuffer_CurrTF[1]) + " big=" + DoubleToString(stGVL.BigEMABuffer_CurrTF[1]));
      return true;
   }
   else
   {
      return false;
   }
}